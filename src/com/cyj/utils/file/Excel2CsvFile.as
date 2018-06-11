package com.cyj.utils.file
{
	import com.as3xls.xls.Cell;
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.childoftv.xlsxreader.Worksheet;
	import com.childoftv.xlsxreader.XLSXLoader;
	import com.childoftv.xlsxreader.XLSXUtils;
	import com.cyj.utils.Log;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	import com.lipi.excel.Excel;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class Excel2CsvFile
	{
		private var _outPath:String;
		private var _execFile:File;
		private var _handleFun:Function;
		private var excelloader:XLSXLoader;
		private var _startTime:int;
		
		public static const STATE_SUCCESS:int = 1;
		public static const STATE_ERROR:int = 0;
		
		
		public function Excel2CsvFile(excelFile:File, outPath:String, completeFun:Function=null)
		{
			_outPath = outPath;
			_execFile = excelFile;
			_handleFun = completeFun;
			_startTime = getTimer();
//			if(_execFile.type == FileManager.TYPE_FILE_XLS)
//			{
				Excel2Csv.loader.loadSingleRes(excelFile.nativePath, ResLoader.BYT, handleLoadedComplete, null, handleErrorLoaded);
//			}else if(_execFile.type == FileManager.TYPE_FILE_XLSX){
//				excelloader = new XLSXLoader();
//				excelloader.load(excelFile.nativePath);
//				excelloader.addEventListener(Event.COMPLETE, handleReadXlsx);
//			}
		}
		
		private function handleReadXlsx(e:Event):void
		{
			var sheet:Worksheet = excelloader.worksheet(excelloader.getSheetNames()[0]);//new Worksheet("Sheet1");
			var row:int = sheet.rows;
			var col:int = sheet.maxcol;
			var datas:Array = [];
			
			for(var i:int=1; i<=row;i++)
			{		
				var items:Array = [];
				for(var j:int=1; j<=col; j++)
				{
					trace(XLSXUtils.num2AZ(j)+""+i, "", sheet.getCellValue(XLSXUtils.num2AZ(j)+""+i));
					items.push(sheet.getCellValue(XLSXUtils.num2AZ(j)+""+i));
				}
				datas.push(items);
			}
			save2Csv(datas);
//			var result:Array = sheet.maxcol;
//			save2Csv(result);
		}
		
		private function get runtime():int
		{
			return getTimer() - _startTime;
		}
		
		private function handleLoadedComplete(res:ResData):void
		{
			var byte:ByteArray = res.data;
			byte.position = 0;
			var data:Array;
			try{
				if(_execFile.type == FileManager.TYPE_FILE_XLS)
				{
					data = getXlsxData(byte);
				}else if(_execFile.type == FileManager.TYPE_FILE_XLSX)
				{
					data = getXlsData(byte);
				}
			}catch(e:*){
				Log.error("转换"+_execFile.nativePath+"数据失败"+"请检查文件格式"+e);
				doComplete(STATE_ERROR);
				return;
			}
			save2Csv(data);
		}
		
		private function save2Csv(data:Array):void
		{
			var csvstr:String;
			try{
				csvstr = CSVFile.write(data);
			}catch(e:*){
				Log.error("转换"+_execFile.nativePath+"为csv数组失败"+"请检查文件中数据格式是否正确...."+e);
				doComplete(STATE_ERROR);
				return;
			}
			try{
				Excel2Csv.file.saveFile(_outPath, csvstr, false, "gb2312");
			}catch(e:*){
				Log.error("保存"+_outPath+"失败"+"请检查路径或者文档是否打开中...."+e);
				doComplete(STATE_ERROR);
				return;
			}
			Log.alert("导出"+_execFile.nativePath+"至"+_outPath+"成功"+runtime);
			doComplete(STATE_SUCCESS);
		}
		
		private function handleErrorLoaded(msg:*, res:ResData):void
		{
			Log.error("读取"+_execFile.nativePath+"失败"+"请检查路径或者文档是否打开中...."+msg);
			doComplete(STATE_ERROR);
		}
		
		public function doComplete(state:int):void
		{
			if(_handleFun != null)
			{
				_handleFun.apply(this, [state]);
			}
		}
		
		private function getXlsData(byte:ByteArray):Array
		{
			var excel:Excel = new Excel(byte);
			var data:Array = excel.getSheetArray();
			return data;
		}
		
		private function getXlsxData(byte:ByteArray):Array
		{
			byte.position = 0;
			var excel:ExcelFile = new ExcelFile();
			excel.loadFromByteArray(byte);
			var sheet:Sheet = excel.sheets[0];
			var rownum:int = sheet.rows;
			var cell:Cell;
			var result:Array = [];
			for(var i:int=0; i<rownum; i++)
			{
				var arr:Array = sheet.values[i];
				var items:Array = [];
				for(var j:int=0; j<arr.length; j++)
				{
					cell = arr[j];
					items.push(cell.value);
				}
				result.push(items);
			}
			return result;
		}
			
		
	}
}