package com.cyj.utils
{
	import flash.net.getClassByAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class XML2Obj
	{
		public static const XML_COMMENT:String = "XML_COMMENT";
		private static const REG_XML_COMMENT:RegExp = /<!--([\s\S]*?)-->/gi;
		
		public static const ITEM_DATA:String = "__$$data";
		
		private static var _registerCls:Dictionary = new Dictionary();
		private static var _cls2Name:Dictionary = new Dictionary(); 
		
		private static var _parser2Class:IXMLParser2UI;
		public function XML2Obj()
		{
		}
		
		public static function readXml(xmlstr:*):Object
		{
			var xml:XML;
			if(xmlstr is XML)
			{
				xml = xmlstr;	
			}else{
				xml = new XML(xmlstr);	
			}
			
			var xmlobj:Object = getClsInstanceByName(xml.name());
			var comment:Array = REG_XML_COMMENT.exec(xmlstr);
			if(comment && comment.length>=2 && xmlobj.hasOwnProperty(XML_COMMENT))xmlobj[XML_COMMENT] = comment[1];
			readXmlProp(xml, xmlobj);
			for(var i:int=0; i<xml.children().length(); i++)
			{
				readXmlChild(xml.children()[i], xmlobj);
			}
			return xmlobj;
		}
		
		public static function registerClass(key:String, cls:Class):void
		{
			_registerCls[key] = cls;
			var type:String = getQualifiedClassName(cls);
			var arr:Array = type.split("::");
			var clsname:String;
			if(arr.length>1)
				clsname = arr[1];
			else
				clsname = arr[0];
			_cls2Name[clsname] = key;
		}
		
		
		private static function readXmlChild(xml:XML, obj:Object):void
		{
			var xmlname:String = xml.name();
			var clsName:String = xml.@_className;
			var xmlObj:Object = getClsInstanceByName(clsName?clsName:xmlname);
//			if(obj.hasOwnProperty(xmlname)==false)return;
			if(obj[xmlname] == null)
			{
				obj[xmlname] = [];
			}
			var haveProy:Boolean = readXmlProp(xml, xmlObj);
			for(var i:int=0; i<xml.children().length(); i++)
			{
				if(xml.children().length()==1 && xml.children()[i].name()==null)
				{
					if(haveProy)
					{
						xmlObj[ITEM_DATA] = xml.children()[i].toString();
					}else{
						xmlObj = xml.children()[i].toString();
					}
				}else{
					readXmlChild(xml.children()[i], xmlObj);
				}
			}
			obj[xmlname].push(xmlObj);
		}
		
		private static function getClsInstanceByName(name:String):Object
		{
			var cls:Class
			if(_parser2Class)
			{
				cls = _parser2Class.getClassByName(name);
			}
			if(_registerCls[name])
			{
				cls = _registerCls[name];
			}
			if(cls == null)
				return {};
			else
				return new cls();
		}
		
		public static function set parser2Class(value:IXMLParser2UI):void
		{
			_parser2Class = value;
		}
		
		public static function get parser2Class():IXMLParser2UI
		{
			return _parser2Class;
		}
		
		private static function readXmlProp(xml:XML, obj:Object):Boolean
		{
			var describe:XML = describeType(obj);
			var havePorp:Boolean = false;
			for each(var item:XML in xml.attributes())
			{
				if(item==null)continue;
				var prop:String = item.name();
				var value:String = item;
				havePorp = true;
				if(describe.@isDynamic == "true")
				{
					obj[prop]= value;
				}else{
					if(obj.hasOwnProperty(prop))
					{
						if(obj[prop] is Boolean)
						{
							obj[prop] = !(value=="false" || value=="0");
						}else{
							obj[prop]= value;
						}
					}
						
				}
			}
			return havePorp;
		}
		
		public static function readObj(xmlobj:Object, rootName:String):String
		{
			var xml:String = "";//(xmlobj.hasOwnProperty(XML_COMMENT)&&xmlobj[XML_COMMENT]!=null)?"":"<!--"+xmlobj[XML_COMMENT]+"-->\n";
			xml += readObjProp(xmlobj, rootName, 0);
			return xml;
		}
		
		private static function readObjProp(obj:Object, name:String, layer:int=0, clsName:String=""):String
		{
			var xml:String = getWaitString(layer)+"<"+name;
			var haveChild:Boolean = false;
			var prop:String;
			var i:int;
			if(clsName && name != clsName)
			{
				xml+= ' _className="'+clsName+'"';
			}
			if(obj is Array|| obj  is Vector.<*>)
			{
				haveChild = true;
				xml += ">\n";
				var objArr:Array = obj as Array;
				for(i=0; i<objArr.length; i++)
				{
					xml += readObjProp(objArr[i], getObjectName(objArr[i]), layer+1, getObjectName(objArr[i]));
				}
			}else if(obj is String || obj is Number)
			{
				haveChild = true;
				xml += ">\n";
				xml += getWaitString(layer+1)+obj+"\n";
			}else{
				var props:Array = ObjectUtils.getObjProps(obj);
				props.sort();
				var haveCheck:Dictionary = new Dictionary();
				for each(prop in props)
				{
					if(prop == XML_COMMENT)
					{
						xml = "<!--"+obj[prop]+"-->" +"\n"+ xml;
						haveCheck[prop] = true;
						continue;
					}
					if(obj[prop] is String || obj[prop] is Number)
					{
						haveCheck[prop] = true;
						xml+= ' '+ prop + '="'+obj[prop]+'"';
					}
				}
				var isEndTag:Boolean = false;
				for each(prop in props)
				{
					if(haveCheck[prop])continue;
					if(obj[prop] is Array || obj[prop] is Vector.<*>)
					{
						haveChild = true;
						xml += ">\n";
						var arr:* = obj[prop];
						for(i=0; i<arr.length; i++)
						{
							xml += readObjProp(arr[i], prop, layer+1, getObjectName(arr[i]));
						}
					}else if(obj[prop]!=null && !(obj[prop] is Array)){//作为object处理
						if(isEndTag==false)
						{
							haveChild = true;
							xml += ">\n";
							isEndTag = true;
						}
						xml += readObjProp(obj[prop], getObjectName(obj[prop]), layer+1, getObjectName(obj[prop]));
					}
				}
			}	
				
			
			if(haveChild)
				xml += getWaitString(layer)+"</"+name+">";
			else
				xml += "/>";
			return xml+"\n";
		}
		
		private static function getObjectName(obj:Object):String
		{
			var type:String = getQualifiedClassName(obj);
			var arr:Array = type.split("::");
			var clsname:String;
			if(arr.length>1)
				clsname = arr[1];
			else
				clsname = arr[0];
			if(_cls2Name[clsname])
				return _cls2Name[clsname];
			return clsname;
		}
		
		private static function getWaitString(waitIndex:int):String
		{
			var wait:String = "";
			for(var i:int=0; i<waitIndex; i++)
			{
				wait += "\t";
			}
			return wait;
		}
	}
}