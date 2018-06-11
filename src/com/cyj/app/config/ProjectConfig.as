package com.cyj.app.config
{
	import com.cyj.utils.ObjectUtils;
	import com.cyj.utils.XML2Obj;

	public class ProjectConfig
	{
		
		public var name:String;
		public var id:String;
		public var path:String;
//		public var cfgpath:String;
		public var monstercfg:String;
		public var chengjiucfg:String;
		public var mappath:String;
		public var actionlist:String;
		public var gameurl:String;
		public var bindata:String;
		public var resurl:String;
		public var jsoncopyto:String;
		public var mainroleindex:int;
		public var mainface:String;
		public var facepath:String;
		
		
		public var baseurl:String;
		
		
		
		public function ProjectConfig()
		{
			
		}
		
		public function initVar():void
		{
			var props:Array = ObjectUtils.getObjProps(this);
			var reg:RegExp = /\{\$(.*?)\}/gi;
			for(var i:int=0; i<props.length; i++)
			{
				var arr:Array;
				while(arr = reg.exec(this[props[i]]))
				{
					if(this.hasOwnProperty(arr[1]))
						this[props[i]] = this[props[i]].replace(arr[0], this[arr[1]]);
					else
						this[props[i]] = this[props[i]].replace(arr[0], "");
					reg.lastIndex = 0;
				}
			}
		}
	}
}