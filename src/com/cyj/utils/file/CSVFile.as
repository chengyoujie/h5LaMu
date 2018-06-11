package com.cyj.utils.file
{
	public class CSVFile
	{
		public function CSVFile()
		{
		}
//		private static const BLOCK_STR:String = String.fromCharCode(1990);
		private static const STR_REG:RegExp = /\".*?\"/gi;
		public static function read(value:String):Array
		{
			var arr:Array = [];
			var lines:Array = value.split("\r\n");
			for(var i:int=0; i<lines.length; i++)
			{
				if(!lines[i] && i==lines.length-1)continue;
				arr.push(parserCsvLine(lines[i]));
			}
			return arr;
		}
		
		
		private static function parserCsvLine(line:String):Array
		{
			var arr:Array = [];
			var char:String;
			var nextchar:String;
			var index:int=0;
			var cell:String="";
			var isEnd:Boolean = true;
			var doltNum:int=0;
			var doltIsAdd:Boolean = true;
			var reg:RegExp = /\"\"/gi;
			while(index<line.length)
			{
				char = line.charAt(index);
				nextchar = line.charAt(index+1);
				switch(char)
				{
					case '"':
						if(doltIsAdd)
						{
							doltNum ++;
							doltIsAdd = false;
						}else{
							doltNum--;
							doltIsAdd = true;
						}
						if(isEnd)
						{
//							cell = char;
							isEnd = false;
						}else{
//							cell += char;
							if(doltNum==0 && (nextchar==','||index==line.length-1))
								isEnd = true;
							else
								cell += char;
						}
						break;
					case ',':
						if(isEnd==false)
							cell += char;
						else{
							reg.lastIndex = 0;
							cell = cell.replace(reg, '"');
							arr.push(cell);
							cell = "";
							doltNum = 0;
							doltIsAdd = true;
						}
						break;
					default:
						cell += char;
						break;
				}
				index ++;
			}
			reg.lastIndex = 0;
			cell = cell.replace(reg, '"');
			arr.push(cell);
			return arr;
//			var items:Array = line.split(",");
//			var cell:String;
//			var item:String;
//			var temp:String;
//			var isEnd:Boolean = true;
//			for(var i:int=0; i<items.length; i++)
//			{
//				item = items[i];
////				if(isEnd)
////				{
////					cell = item;
////				}else{
////					cell += item;
////				}
//				var reg:RegExp = new RegExp(BLOCK_STR, "gi");
//				item = item.replace(/\"\"/gi, BLOCK_STR);
//				temp = item.replace(reg, "");
//				if(temp.charAt(0)=='"' && isEnd)
//				{
//					cell = item;
//					isEnd = false;
//				}else if(temp.charAt(item.length-1)=='"')
//				{
//					cell += ","+item;
//					isEnd = true;
//				}else{
//					cell = item;
//					isEnd = true;
//				}
//				if(isEnd)
//				{
//					cell = cell.replace(reg, '"');
//					arr.push(cell);
//				}
////				if(item.indexOf('"')!=-1)
////				{
////					item = item.replace(/\"/gi, '');
////				}
////				if(item.charAt(0)=='"')
////				{
////					isEnd = false;
////				}
////				if(item.charAt(item.length-1)=='"')
////				{
////					isEnd = true;
////				}
////				if(isEnd)
////				{
////					arr.push(cell);
////				}
//			}
//			return arr;
		}
		
		public static function write(arr:Array):String
		{
			var str:String = "";
			if(arr==null)return str;
			var lines:Array;
			for(var i:int=0; i<arr.length; i++)
			{
				lines = arr[i];
				if(lines ==null){str+="\n";continue;}
				for(var m:int =0; m<lines.length; m++)
				{
					str += getCsvItemString(lines[m])+((m==lines.length-1)?"":",");
				}
//				for(var index:* in lines)
//				{
//					str += getCsvItemString(lines[index])+",";
//				}
				
				str += "\n";
			}
			return str;
		}
		
		private static function getCsvItemString(item:Object):String
		{
			if(!item)return "";
			if((item+"").indexOf("Object") != -1)
			{
				item = JSON.stringify(item);
			}else{
				item = item+"";
			}
			if(item.indexOf('"')!=-1 || item.indexOf(",")!=-1 || item.indexOf("，")!=-1|| item.indexOf("“")!=-1|| item.indexOf("\n")!=-1)
			{
				item = item.replace(/\"/gi, '""');
				item = '"'+item+'"';
			}
			return item+"";
		}
	}
}