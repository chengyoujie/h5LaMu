package com.cyj.app.data.map
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class PstInfo
	{
		public function PstInfo()
		{
		}
		/**
		 * 图片数据字典<br/>
		 * Key      String  存储图片数据的key <br/>
		 * Value    UnitResource<br/>
		 */
		protected var _resources: Object = {};//{ [uri: String]: UnitResource } | UnitResource;
		
		/**
		 * pst的唯一标识
		 */
		public var key: String;
		
		/**
		 * 动作信息，帧的播放信息的数组  
		 * Key      {Number}        动作标识
		 * Value    {ActionInfo}    动作信息
		 */
		public var  frames:Object = {};// { [action: Number]: ActionInfo };
		
		/**
		 * 头顶显示的基准坐标Y，相对于角色的原点
		 * 
		 * @type {Number}
		 */
		public var headY: Number;
		
		/**
		 * 受创点的基准坐标Y，相对于角色的原点
		 * 
		 * @type {Number}
		 */
		public var hurtY: Number;
		
		/**
		 * 施法点
		 * KEY      {Number}        action << 8 | direction
		 * VALUE    {egret.Point}   施法点坐标
		 * @type {[adKey:String]:Point}
		 */
		protected var castPoints:Object = {};// { [adKey: Number]: Point };
		
		
		/**
		 * 获取施法点
		 * @param {Number} action 动作标识
		 * @param {Number} direction 方向
		 * @return {Point} 如果有施法点
		 */
		public function getCastPoint(action: Number, direction: Number) {
			if (this.castPoints) {
				var pt = this.castPoints[ADKey.get(action, direction)];
				if (pt) {
					return pt;
				}
			}
			return;
		}
		
		public var splitInfo: SplitInfo;
		
		
		public function parser(key: String, data: Array) {
			this.key = key;
			this._resources = {};
			// var parserRef = getParsers(data[0]);
			// if (!parserRef) {
			//     return;
			// }
			// var parser = new parserRef(key);
			var parser = new SplitInfo(key);
			//处理数据
			this.splitInfo = parser;
			parser.parseSplitInfo(data[1]);
			this.frames = parser.parseFrameData(data[2]);
			// extra [0] 头顶坐标Y Number
			// extra [1] 受创点Y Number
			// extra [2] 施法点 {[index:String]:Array<Array<Number>(2)>(5)}
			var extra = data[3];
			if (extra) {
				this.headY = +extra[0];
				this.hurtY = +extra[1];
				var castInfo:Object = {};// { [adKey: Number]: Number[][] } = extra[2];
				if (castInfo) {
					var castPoints:Object = {}// { [adKey: Number]: Point } = {};
					this.castPoints = castPoints;
					for (var a in castInfo) {
						var aInfo = castInfo[a];
						for (var d = 0; d < 8; d++) {
							var pInfo = aInfo[d > 4 ? 8 - d : d];
							if (pInfo) {
								castPoints[ADKey.get(+a, d)] = { x: +pInfo[0], y: +pInfo[1] };
							}
						}
					}
				}
			}
		}
		
		
//		/**
//		 * 解析图片数据
//		 * 用于批量处理数据
//		 */
//		public decodeImageDatas(data: { [index: String]: {} }) {
//			for (var uri in data) {
//				var res = this.getResource(uri);
//				res.decodeData(data[uri]);
//			}
//		}
//		
//		getResource(uri: String) {
//			var res = this._resources[uri];
//			if (!res) {
//				res = new UnitResource(uri, this.splitInfo);
//				this._resources[uri] = res;
//			}
//			return res;
//		}
//		
//		/**
//		 * 获取单位资源
//		 */
//		public getUnitResource(uri) {
//			var res = this.getResource(uri);
//			res.loadData();
//			return res;
//		}
		
	}
}
import com.cyj.app.data.map.ADKey;

import flash.utils.Dictionary;


class SplitInfo
{
	
	/**
	 * 资源字典
	 */
	protected var _resDict:Object = {};
	
	/**
	 * 子资源列表
	 */
	protected var _subReses:Array;
	
	/**
	 * key
	 */
	protected var _key: String;
	
	/**
	 * 动作/方向的字典<br/>
	 * key      {String}  资源key<br/>
	 * value    {Array}   action<<8|direction
	 *                   
	 */
	public var adDict: Object = {};
	
	public function SplitInfo(key: String) {
		this._key = key;
	}
	
	protected var _n: String;
	protected var _a: Array;
	protected var _d: Array;
	
	public function parseFrameData(data: *) {
		this._resDict = {};
		var adDict = this.adDict = {};
		var frames: Object = {};
		for (var key in data) {
			var a = +key;
			frames[a] = getActionInfo(data[a], a);
			for (var d = 0; d < 5; d++) {
				var res = this.getResKey(d, a);
				adDict[res] = ADKey.get(a, d);
			}
		}
		return frames;
	}
	
	public function getResName(action: Number,direction: Number):String
	{
		var key = ADKey.get(action, direction);
		return this._resDict[key];
	}
	
	public function parseSplitInfo(infos: *) {
		this._n = infos.n || "{a}{d}";
		this._a = infos.a || _pst$a;
		this._d = infos.d;
	}
	
	public function getResKey(direction: Number, action: Number): String {
		var key = ADKey.get(action, direction);
		var res = this._resDict[key];
		if (!res) {
			this._resDict[key] = res = subStr(this._n, { "f": this._key, "a": getRep(action, this._a), "d": getRep(direction, this._d) });//this._n.substr({ "f": this._key, "a": getRep(action, this._a), "d": getRep(direction, this._d) });
		}
		return res;
	}
	
	public function subStr(str:String, obj:Object):String
	{
		var reg:RegExp = /\{(.*?)\}/gi;
		var arr:Array;
			while(arr = reg.exec(str))
			{
				var prop:String = arr[1];
				if(obj.hasOwnProperty(prop))
					str = str.replace(arr[0], obj[prop]);
				reg.lastIndex = 0;
			}
			return str;
	}
	
	public function  getRep(data: Number, repArr:Array): String {
		var str = data + "";
		if (repArr && (data in repArr)) {
			str = repArr[data];
		}
		return str;
	}
	
	
	/**
	 * 默认动作数组
	 * [a,b,c....x,y,z,A,B,C...X,Y,Z]
	 */
	public const _pst$a = function () {
		var a: Array = [];
		m(97, 122);//a-z
		m(65, 90);//A-Z
		return a;
		function m(f: Number, t: Number) {
			for (var i = f; i <= t; i++) {
				a.push(String.fromCharCode(i));
			}
		}
	}();
	
	/**
	 * 获取动作数据
	 * 
	 * @param {any} data
	 * @param {Number} key
	 * @returns
	 */
	public  function getActionInfo(data, key: Number) {
		var aInfo = {};
		aInfo.key = key;
		var d: Array = data[0];//放数组0号位的原因是历史遗留，之前AS3项目的结构有这个数组，做h5项目的时候忘记修改
		var totalTime = 0;
		var j = 0;
//		d.forEach((item) => {
//		var f = getFrameInfo(item);
//		totalTime += f.t;
//		d[j++] = f;// 防止有些错误的空数据
//		});
		for each(var item:* in d)
		{
			var f = getFrameInfo(item);
			totalTime += f.t;
			d[j++] = f;
		}
		aInfo.frames = d;
		aInfo.totalTime = totalTime;
		aInfo.isCircle = !!data[1];
		return aInfo;
	}

	/**
	 * 获取帧数据
	 * 为数组的顺序："a", "f", "t", "e", "d"
	 * @param {*} data 如果无法获取对应属性的数据，会使用默认值代替  a: 0, d: -1, f: 0, t: 100 
	 * @returns
	 */
	public  function getFrameInfo(data: *): FrameInfo {
		const def = { a: 0, d: -1, f: 0, t: 100 };
		const keys = ["a", "f", "t", "e", "d"];
		if (!data is Array) {
			if (typeof data === "object") {
				for (var i = 0; i < 5; i++) {
					var key = keys[i];
					if (data[key] == undefined) {
						data[key] = def[key];
					}
				}
				return data;
				
			} else {
				return def;
			}
		}
		var ff: Object = getData(data, keys, def);
		var f:FrameInfo = new FrameInfo();
		for(var p:String in ff)
		{
			if(f.hasOwnProperty(p))
				f[p] = ff[p];
		}
		if (f.e == "0") {
			f.e = undefined;
		}
		if (f.t == -1) {//-1做特殊用途，让其变为正无穷
			f.t = Infinity;
		}
		return f;
	}
	
	
	public  function getData(valueList, keyList, o) {
		o = o || {};
		for (var i = 0, len = keyList.length; i < len; i++) {
			var key = keyList[i];
			var v = valueList[i];
			if (v != undefined) {
				o[key] = valueList[i];
			}
		}
		return o;
	}
}



class  ActionInfo {
	/**
	 * 动作标识
	 */
	public var key: Number;
	/**
	 * 帧列表信息
	 * 
	 * @type {FrameInfo[]}
	 */
	public var frames: Array;
	/**
	 * 是否为循环动作
	 */
	public var isCircle: Boolean;
	/**
	 * 动画默认的总时间
	 */
	public var totalTime: Number;
}



/**
 * 绘图数据
 * 
 * @interface IDrawInfo
 */
class IDrawInfo {
	/**原始动作索引 */
	public var a: Number;
	/**原始方向索引 */
	public var d: Number;
	/**原始帧数索引 */
	public var f: Number;
}

/**
 * 帧数据
 * 
 * @interface FrameInfo
 * @extends {IDrawInfo}
 */
class FrameInfo extends IDrawInfo {
	/**和下一帧间隔索引 */
	public var t: Number;
	/**事件 */
	public var e: String;
}