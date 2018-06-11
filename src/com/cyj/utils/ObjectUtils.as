package com.cyj.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		
		public static function getObjProps(object:Object):Array
		{
			var describe:XML = describeType(object);
			var vars:XMLList = describe["variable"];
			var props:Array = [];
			for(var i:int=0; i<vars.length(); i++)
			{
				props.push(vars[i].@name+"");
			}
			if(describe.@isDynamic == "true")
			{
				for(var pop:String in object)
				{
					props.push(pop);
				}
			}
			return props;
		}
		
		public static function copyObject(data:Object, toObj:Object):void
		{
			var reg:RegExp = /__AS3__\.vec::Vector\.<(.*?)>/gi;
			var describe:XML = describeType(toObj);
			var vars:XMLList = describe["variable"];
			var props:Dictionary = new Dictionary();
			for(var i:int=0; i<vars.length(); i++)
			{
				props[vars[i].@name+""] = vars[i].@type;
			}
			var dataprops:Array = getObjProps(data);
			for each(var prop:String in dataprops)
			{
				if(toObj.hasOwnProperty(prop))
				{
					
					var str:String= props[prop]?props[prop]:getQualifiedClassName(toObj[prop]);
					reg.lastIndex = 0;
					var res:Array = reg.exec(str);
					if(res)
					{
						var cls:Class = ApplicationDomain.currentDomain.getDefinition(res[1]) as Class;
						var veccls:Class = ApplicationDomain.currentDomain.getDefinition(str) as Class;
						if(cls)
						{
							if(toObj[prop] == null)
								toObj[prop] = new veccls();
							var item:Object;
							for(var m:int=0; m<data[prop].length; m++)
							{
								item = new cls();
								copyObject(data[prop][m], item);
								toObj[prop].push(item);
							}
							
						}
					}else{
						toObj[prop] = data[prop];	
					}
				}
			}
		}
		
		
		public static function checkIsSame(orgionData:Object, campData:Object):Boolean
		{
//			trace(getQualifiedClassName(campData));
//			trace(getQualifiedClassName(orgionData));
			if(getQualifiedClassName(orgionData) != getQualifiedClassName(campData))return false;
			if(orgionData is Array || orgionData is Vector.<*>)// arr vec
			{
				if(orgionData.length != campData.length)return false;
				for(var m:int=0; m<orgionData.length; m++)
				{
					var d1:* = orgionData[m];
					var d2:* = campData[m];
					if(d1== d2)continue;
					if(checkIsSame(d1, d2)==false)
						return false;
					
				}
				return true;
			}
			var describe:XML = describeType(orgionData);
			var vars:XMLList = describe["variable"];
			var props:Dictionary = new Dictionary();
			var len:int = 0;
			if(vars==null || !vars.toString())
			{
				for(var prop:String in orgionData)
				{
					props[prop] = getQualifiedClassName(orgionData[prop]);
					len ++;
				}
			}
			for(var i:int=0; i<vars.length(); i++)
			{
				props[vars[i].@name+""] = vars[i].@type;
				len ++;
			}
			
			
			
			var describe2:XML = describeType(campData);
			var vars2:XMLList = describe["variable"];
			var props2:Dictionary = new Dictionary();
			var len2:int = 0;
			if(vars2==null || !vars2.toString())
			{
				for(var prop2:String in campData)
				{
					props2[prop2] = getQualifiedClassName(orgionData[prop2]);
					len2 ++;
				}
			}
			
			for(var i:int=0; i<vars2.length(); i++)
			{
				props2[vars2[i].@name+""] = vars2[i].@type;
				len2 ++;
			}
			
			if(len != len2)return false;
			if(len == 0)
			{
				return orgionData == campData;
			}
			
			for(var prop:String in props)
			{
				if(props[prop] != props2[prop])return false;
				var d1:* = orgionData[prop];
				var d2:* = campData[prop];
				if(d1== d2)continue;
				if(checkIsSame(d1, d2)==false)
					return false;
			}
			
			return true;	
		}
		
		
		public static function vec2arr(vec:*):Array
		{
			var arr:Array = [];
			for(var i:int=0; i<vec.length; i++)
			{
				arr.push(vec[i]);
			}
			return arr;
		}
		
		/**clone副本*/
		public static function clone(source:*):* {
			if(source==null)return;
			var clsName:String = getQualifiedClassName(source);//getQualifiedSuperclassName(source);//getQualifiedClassName(source);
			clsName = clsName.replace("::", ".");
			var cls:Class = getDefinitionByName(clsName) as Class;//  getClassByAlias(clsName);
			var obj:* ;
			if(cls)
			{
				obj = new cls();
				var pops:Array = getObjProps(source);
				for each(var prop:* in pops)
				{
					if(source[prop] is String || source[prop] is Number || source[prop]==null || source[prop]==undefined)
					{
						obj[prop] = source[prop];
					}else{
						obj[prop] = clone(source[prop]);
					}
				}
			}
			return obj;
		}
		
		/**深度克隆**/
		public static function cloneDepthObject($object:Object) :* {  
			if($object == null){
				throw new ArgumentError("Parameter $object can not be null.");
				return null;
			}else{
				//为了深度复制一个对象, 需要注册该对象用到的所有类
				var allClassName:Array = getAllQualifiedClassName($object);
				for each(var item:String in allClassName)
				registerClassAlias(item, Class(getDefinitionByName(item)));
				//使用 byteArray 对象进行深度复制即可
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject($object);
				bytes.position = 0;
				//取出复制出的新对象，如果有带参数的构造函数而导致复制失败的就返回 null
				var className:String = getQualifiedClassName($object);
				var ObjectClass:Class = Class(getDefinitionByName(className));
				var result:*;
				try{
					result = bytes.readObject() as ObjectClass;
					return result;
				}catch($error:ArgumentError){
					trace($error.message);
				}
				return null; 
			}
		}
			
		public static function getAllQualifiedClassName($object:*):Array{
			if($object == null){
				throw new ArgumentError("Parameter $object can not be null.");
				return null;
			}else{
				var xml:XML = describeType($object), dictionary:Dictionary = new Dictionary(), i:int, j:int, result:Array = new Array();
				dictionary[xml.@name] = true;
				for(i=0; i<xml.extendsClass.length(); i++){
					dictionary[String(xml.extendsClass[i].@type)] = true;
				}
				for(i=0; i<xml.implementsInterface.length(); i++)
					dictionary[String(xml.implementsInterface[i].@type)] = true;
				for(i=0; i<xml.accessor.length(); i++)
					dictionary[String(xml.accessor[i].@type)] = true;
				for(i=0; i<xml.method.length(); i++){
					dictionary[String(xml.method[i].@returnType)] = true;
					for(j=0; j<xml.method[i].parameter.length(); j++)
						dictionary[String(xml.method[i].parameter[j].@type)] = true;
				}
				for(var obj:* in dictionary)
					if(String(obj) != "void" && String(obj) != "*")
						result.push(String(obj));
				return result;
			}
		}
		
		public static function removeAllChild(parent:DisplayObjectContainer):void
		{
			while(parent.numChildren>0)
			{
				parent.removeChildAt(0);
			}
		}
		
	
//		/**clone副本*/
//		public static function clone(source:*):* {
//			var bytes:ByteArray = new ByteArray();
//			bytes.writeObject(source);
//			bytes.position = 0;
//			return bytes.readObject();
//		}
		
	}
}