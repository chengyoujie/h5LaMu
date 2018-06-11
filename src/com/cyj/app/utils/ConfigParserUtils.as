package com.cyj.app.utils
{
	import com.cyj.app.data.map.MapInfo;
	import com.cyj.utils.Log;
	
	import flash.utils.ByteArray;

	public class ConfigParserUtils
	{
		
		private static var  CfgHeadStruct = {1:[0,2,9], 2:[1, 2, 14], 3:[2,1, 14], 4:[3,1,17], 5:[4, 1, 1], 6:[5,1, 9]};
		private static var _result:Object = {};
		private static var _mapinfos:Object = {};
		private static var _cfgs:Object = {};
		
		public function ConfigParserUtils()
		{
			
		}
		
		
		public static function parser(byte:ByteArray):void
		{
			_cfgs = ConfigParserUtils.decodePakCfgs(byte);
			_mapinfos = ConfigParserUtils.mapCfgParser(_cfgs["maps"]);
			//			var ditu:Object = Utils.readCfg(cfgs["DiTu"]);
			ConfigParserUtils.parserAllCfg(_cfgs);
		}
		
		public static function get mapInfos():Object
		{
			return _mapinfos;
		}
		public static function get cfgData():Object
		{
			return _result;
		}
		public static function get allCfgs():Object
		{
			return _cfgs;
		}
		
		private static function decodePakCfgs(buffer:ByteArray) {
			var cfgs = {};
			while (buffer.bytesAvailable) {
				var len = buffer.readUnsignedByte();
				var key = buffer.readUTFBytes(len); //得到表名
				var type = buffer.readUnsignedByte();
				var value = void 0;
				len = readVarint(buffer);//buffer.readInt();
				switch (type) {
					case 0://JSON字符串
						var str = buffer.readUTFBytes(len);
						value = JSON.parse(str);
						break;
					case 1://PBBytes
						var byte:ByteArray = new ByteArray();
						buffer.readBytes(byte, 0, len);
						value = byte;//buffer.readByteArray(len);
						break;
				}
				cfgs[key] = value;
			}
			return cfgs;
		}
		
		private static const KEY:String = "story";
		
		public static function writeStroy(oldByte:ByteArray, stroyJson:String):ByteArray
		{
			var newbyte:ByteArray = new ByteArray();
			var finded:Boolean = false;
			while (oldByte.bytesAvailable) {
				var len = oldByte.readUnsignedByte();
				var key = oldByte.readUTFBytes(len); //得到表名
				var type = oldByte.readUnsignedByte();
				newbyte.writeByte(len);
				newbyte.writeUTFBytes(key);
				newbyte.writeByte(type);
				
				var value = void 0;
				len = readVarint(oldByte);//buffer.readInt();
				
				switch (type) {
					case 0://JSON字符串
						var str = oldByte.readUTFBytes(len);
						value = JSON.parse(str);
						if(key == KEY)
						{
							var bstr:ByteArray = new ByteArray();
							bstr.writeUTFBytes(stroyJson);
							writeVarint(newbyte, bstr.length);
							newbyte.writeUTFBytes(stroyJson);
							finded = true;
						}else{
							writeVarint(newbyte, len);
							newbyte.writeUTFBytes(str);
						}
						break;
					case 1://PBBytes
						writeVarint(newbyte, len);
						
						var byte:ByteArray = new ByteArray();
						oldByte.readBytes(byte, 0, len);
						value = byte;//buffer.readByteArray(len);
						newbyte.writeBytes(byte);
						break;
				}
			}
			if(finded == false)
			{
				var kbstr:ByteArray = new ByteArray();
				kbstr.writeUTFBytes(KEY);
				
				newbyte.writeByte(kbstr.length);
				newbyte.writeUTFBytes(KEY);
				newbyte.writeByte(0);
				
				var bstr:ByteArray = new ByteArray();
				bstr.writeUTFBytes(stroyJson);
				writeVarint(newbyte, bstr.length);
				newbyte.writeUTFBytes(stroyJson);
			}
			newbyte.position = 0;
			return newbyte;
		}
		
//		public static var CfgHeadStruct = {
//			1:[0, 2 /* Required */, 9 /* String */], /*必有 属性名字*/,
//			2:[1, 2 /* Required */, 14 /* Enum */], /*必有 数值的数据类型*/,
//			3:[2, 1 /* Optional */, 14 /* Enum */], /*可选 此列的状态*/,
//			4:[3, 1 /* Optional */, 17 /* SInt32 */], /*可选 bool / int32 型默认值 */,
//			5:[4, 1 /* Optional */, 1 /* Double */], /*可选 double 型默认值 */,
//			6:[5, 1 /* Optional */, 9 /* String */] /*可选 字符串型默认值 */
//		};
		private static function readCfg(cfgs:Object, key, NotUseCls:*=null, idkey=null, type:int=0):Object
		{
			var bytes:ByteArray = cfgs[key];
			if(bytes==null)return null;
			if (!idkey) { idkey = "id"; }
			var struct = {};
			var headersRaw = [];
			var i = 0;
//			var result:Object = {};
			var count = readVarint(bytes); //头的数量
			var hasLocal = 0;
			while (bytes.bytesAvailable && count--) {
				var len = readVarint(bytes);
				var head = readFrom(CfgHeadStruct, bytes, len);
//				const [name, headType, headState, i32Def, dblDef, strDef] = head;
				var name_7 = head[0], headType = head[1], headState = head[2], i32Def = head[3], dblDef = head[4], strDef = head[5];
				var def, isJSON = 0, pbType;
				switch (headType) {
					case JSONHeadType.Any:
					case JSONHeadType.String:
						def = strDef;
						pbType = PBType.String;
						break;
					case JSONHeadType.Number:
						def = dblDef;
						pbType = PBType.Double;
						break;
					case JSONHeadType.Bool:
					case JSONHeadType.Int32:
					case JSONHeadType.Date:
					case JSONHeadType.Time:
					case JSONHeadType.DateTime:
						def = i32Def;
						pbType = PBType.SInt32;
						break;
					case JSONHeadType.Array:
					case JSONHeadType.Array2D:
						if (strDef) {
							def = JSON.parse(strDef);
						}
						pbType = PBType.String;
						isJSON = 1;
						break;
				}
				struct[i + 1] = [name_7, PBFieldType.Optional, pbType, def];
				head.length = 5;
				head[3] = def;
				head[4] = isJSON;
				headersRaw[i++] = head;
				if ((headState & 2 /* Local */) == 2 /* Local */) {
					hasLocal = 1;
				}
			}
//				junyou.PBUtils.initDefault(struct, CfgCreator.prototype);
				var headLen = i;
				i = 0;
				count = readVarint(bytes); //行的数量
				while (bytes.bytesAvailable && count--) {
					var len = readVarint(bytes);
					var obj = readFrom(struct, bytes, len);
					if (!obj) {
						continue;
					}
//					if (CfgCreator) {
//						CfgCreator.call(obj);
//					}
					var local = hasLocal && {};
					for (var j = 0; j < headLen; j++) {
						var head = headersRaw[j];
						var name_8 = head[0], test = head[1], type_2 = head[2], def = head[3], isJSON = head[4];
						var value = obj[name_8];
						if (value && isJSON) {
							value = JSON.parse(value);
						}
						var v = getJSONValue(value, test, def);
						if ((type_2 & 2 /* Local */) == 2 /* Local */) {
							local[name_8] = v;
						}
						else {
							obj[name_8] = v;
						}
					}
					if(!_result[key])
						_result[key] = {};
					_result[key][obj[idkey]] = obj; 
			}
//			return dict;
			return _result;
		}
		
		private static function parserAllCfg(cfgs:Object):Object
		{
			_result ={};
			readCfg(cfgs,"GongNeng", "GongNengCfg");
			readCfg(cfgs,"DiTu", "DiTuCfg");
			readCfg(cfgs,"DaoJu", "DaoJuCfg", 0);
			readCfg(cfgs,"ZhuangBei", "ZhuangBeiCfg", 0);
			readCfg(cfgs,"Bag", "BagCfg");
			readCfg(cfgs,"ShangHai", "ShangHaiCfg", 0);
			readCfg(cfgs,"JiNengXiaoGuo", "JiNengXiaoGuoCfg", 0);
			readCfg(cfgs,"JiNeng", "JiNengCfg");
			readCfg(cfgs,"JueSe", 0);
			readCfg(cfgs,"TeXiao", 0);
			readCfg(cfgs,"PinZhi", 0, "rare");
			readCfg(cfgs,"Vip", 0, 0);
			readCfg(cfgs,"Cd", 0);
			readCfg(cfgs,"ItemType", 0, "type");
			readCfg(cfgs,"YaoShen", 0);
			readCfg(cfgs,"GuanKa", 0, "id", 1);
			readCfg(cfgs,"YaoShenBuWei", 0);
			readCfg(cfgs,"YaoShenHuoDe", 0, "huashenid");
			readCfg(cfgs,"YaoShenShengXing", 0);
			readCfg(cfgs,"MoWenWaiXian", "MoWenWaiXianCfg");
			readCfg(cfgs,"QiRi", 0, "id", 1);
			readCfg(cfgs,"JingYan", 0, "level");
			readCfg(cfgs,"ShenQiJiHuo", 0, "type");
			readCfg(cfgs,"FeiSheng", "FeiShengCfg");
			readCfg(cfgs,"ChengHaoBiao", 0, "id", 1);
			readCfg(cfgs,"Npc", 0);
			readCfg(cfgs,"QianDao", 0, "id", 1);
			readCfg(cfgs,"ChengZhangJiJin", 0, "id", 1);
			readCfg(cfgs,"SiXiangInfo", 0, "id", 1);
			readCfg(cfgs,"ShangDian", 0, "id", 1);
			readCfg(cfgs,"YeQian", 0, "modelid", 1);
			readCfg(cfgs,"ChengJiuYe", 0, "type");
			readCfg(cfgs,"ChengJiuKai", 0, 0);
			readCfg(cfgs,"ChengJiuRenWu", 0, "order");
			readCfg(cfgs,"JingJiChang", 0);
			readCfg(cfgs,"JingJiPaiMing", 0, 0);
			readCfg(cfgs,"ChiBangJinJie", 0);
			readCfg(cfgs,"ChiBangWaiXian", 0);
			readCfg(cfgs,"LingYu", 0, "type");
			readCfg(cfgs,"ChongWuBiao", 0, "id", 1);
			readCfg(cfgs,"MenPai", 0, "level");
			readCfg(cfgs,"QuanXian", 0);
			readCfg(cfgs,"ZhanQi", 0, "level");
			readCfg(cfgs,"JuanXian", 0, 0);
			readCfg(cfgs,"CaiLiaoFuBen", 0);
			readCfg(cfgs,"CaiLiaoFuBenXinXi", 0);
			readCfg(cfgs,"VipKa", 0, "id", 1);
			readCfg(cfgs,"ChongZhi", 0);
			readCfg(cfgs,"FeiJian", 0, "id", 1);
			readCfg(cfgs,"JuQingDuiHuaBiao", 0, 0);
			readCfg(cfgs,"YYHDGongNeng", 0, "module");
			readCfg(cfgs,"QiShaDengJi", 0);
			readCfg(cfgs,"QiShaPingJia", 0, 0);
			readCfg(cfgs,"QiShaLaiXi", 0, 0);
			readCfg(cfgs,"QiShaGouMai", 0, "times");
			readCfg(cfgs,"GuWuBiao", 0, 0);
			readCfg(cfgs,"HuoYue", "HuoYueCfg");
			readCfg(cfgs,"RiChang", 0);
			readCfg(cfgs,"ChongZhiShangCheng", 0, "id", 1);
			readCfg(cfgs,"FanLi", 0, "id1", 1);
			readCfg(cfgs,"DuoXuan", 0);
			readCfg(cfgs,"TuJing", "TuJingCfg");
			readCfg(cfgs,"JianGeGouMai", 0, "times");
			readCfg(cfgs,"TengTaTianJie", 0);
			readCfg(cfgs,"TianJieGouMai", 0, "times");
			readCfg(cfgs,"BossZhiJia", 0, "id", 1);
			readCfg(cfgs,"PaiHang", 0);
			readCfg(cfgs,"MuBiao", 0);
			readCfg(cfgs,"JianGePingJia", 0, 0);
			readCfg(cfgs,"YaoShenPaiMing", 0, "id", 1);
			readCfg(cfgs,"ZhongLiBoss", 0, "id", 1);
			readCfg(cfgs,"GongNengYuGao", 0, "id", 1);
			readCfg(cfgs,"TuiGuang", 0, "type");
			return _result;
		}
		
		
		private static function getJSONValue(value, type, def) {
			// 特殊类型数据
			switch (type) {
				case 0 /* Any */:
					if (value == null) {
						value = def;
					}
					break;
				case 1 /* String */:
					if (value === 0 || value == null) {
						value = def || "";
					}
					break;
				case 2 /* Number */:
				case 9 /* Int32 */:
					// 0 == "" // true
					if (value === "" || value == null) {
						value = +def || 0;
					}
					break;
				case 3 /* Bool */:
					if (value == null) {
						value = def;
					}
					value = !!value;
					break;
				case 4 /* Array */:
				case 5 /* Array2D */:
					if (value === 0) {
						value = undefined;
					}
					if (!value && def) {
						value = def;
					}
					break;
				case 6 /* Date */:
				case 8 /* DateTime */:
					value = new Date((value || def || 0) * 10000);
					break;
				case 7 /* Time */:
					value = decodeBit(value || def || 0);
					break;
			}
			return value;
		}
		
		private static function decodeBit(value: Number) {
			return _decode(value >> 6, value & 63);
		}
		
		/**
		 * 解析数据
		 * 
		 * @private
		 * @param {number} hour 
		 * @param {number} minute
		 * @returns 
		 */
		private static function  _decode(hour: Number, minute: Number) {
//			this.hour = hour;
//			this.minute = minute;
//			this.time = hour * Time.ONE_HOUR + minute * Time.ONE_MINUTE;
//			this.strTime = hour.zeroize(2) + ":" + minute.zeroize(2);
			return hour+":"+minute;
//			return this;
		}
		
		/**
		 * 读取消息
		 * 
		 * @param {(Key | PBStruct)} msgType 
		 * @param {ByteArray} bytes 
		 * @param {number} [len] 
		 * @returns {any} 
		 */
		private static function readFrom(msgType:*, bytes: ByteArray, len: Number=0) {
			if (len === undefined) len = -1;
			var afterLen = 0;
			if (len > -1) {
				afterLen = bytes.bytesAvailable - len;
			}
//			var struct = typeof msgType == "object" ? msgType : structDict[msgType];
//			if (!struct) {
//				Throw Error("非法的通信类型[${msgType}]");
//				return;
//			}
			//检查处理默认值
//			var msg = Object.create(struct.def);
			
			var struct = msgType;
			var msg:Object = {};
			
			
			
			while (bytes.bytesAvailable > afterLen) {
				var tag =readVarint( bytes);
				if (tag == 0)
					continue;
				var idx = tag >>> 3;
				var body = struct[idx];
				if (!body) {
					Log.error("读取消息类型为：${msgType}，索引${idx}时数据出现错误，找不到对应的数据结构配置");
					// 使用默认读取
					readValue(tag, bytes);
					continue;
				}
				var name = body[0];
				var label = body[1];
				var type = body[2];
				var subMsgType = body[3];
				var value;
				var isRepeated = label == PBFieldType.Repeated;
				if (!isRepeated || (tag & 0xb111) != 7) {//自定义  tag & 0b111 == 7 为 数组中 undefined的情况
					switch (type) {
						case PBType.Double:
//							value = bytes.readPBDouble();
							value = bytes.readDouble();
							break;
						case PBType.Float:
//							value = bytes.readPBFloat();
							value = bytes.readFloat();
							break;
						case PBType.Int64:
						case PBType.UInt64:
						case PBType.SInt64:
//							value = bytes.readVarint64();//理论上项目不使用
							value = bytes.readDouble();
							break;
						case PBType.SInt32:
							value = decodeZigzag32(readVarint(bytes));
							break;
						case PBType.Int32:
						case PBType.Uint32:
						case PBType.Enum:
							value = readVarint(bytes);
							break;
						case PBType.Fixed64:
						case PBType.SFixed64:
//							value = bytes.readFix64();//理论上项目不使用
							value = bytes.readDouble();
							break;
						case PBType.Fixed32:
//							value = bytes.readFix32();
							value = bytes.readInt();
							break;
						case PBType.Bool:
							value = bytes.readBoolean();
							break;
						case PBType.String:
							value = readString(bytes);
							break;
						case PBType.Group://(protobuf 已弃用)
							value = undefined;
//							if (DEBUG) {
//								Throw Error(`读取消息类型为：${msgType}，索引${idx}时数据出现已弃用的GROUP分组类型`);
//							}
							break;
						case PBType.Message://消息
							value = readMessage(bytes, subMsgType);
							break;
						case PBType.Bytes:
							value = readBytes(bytes);
							break;
						case PBType.SFixed32:
//							value = bytes.readSFix32();
							value = bytes.readInt();
							break;
						default:
							value = readValue(tag, bytes);
//					}
				}
				if (isRepeated) {//repeated
					var arr = msg[name];
					if (!arr) msg[name] = arr = [];
					arr.push(value);
				} else {
					msg[name] = value;
				}
			}
			}
			return msg;
		}
			
		
		private static function readMessage(bytes, msgType) {
			var blen = readVarint(bytes);
			return readFrom(msgType, bytes, blen);
		}
		private static function readBytes(bytes) {
			var blen = bytes.readVarint();
			return bytes.readByteArray(blen);
		}
		private static function decodeZigzag32(n) {
			return n >> 1 ^ (((n & 1) << 31) >> 31);
		}
		
		private static function readValue(tag, bytes:ByteArray) {
			var wireType = tag & 7;
			var value;
			switch (wireType) {
				case 0://Varint	int32, int64, uint32, uint64, sint32, sint64, bool, enum
					value = readVarint(bytes);
					break;
				case 2://Length-delimi	string, bytes, embedded messages, packed repeated fields
					value = readString(bytes);
					break;
				case 5://32-bit	fixed32, sfixed32, float
					value = bytes.readInt();
					break;
				case 1://64-bit	fixed64, sfixed64, double
					value = bytes.readDouble();
					break;
				default:
					Log.error("protobuf的wireType未知");
					break;
			}
			return value;
		}
		
		private static function readString(bytes:ByteArray) {
			var blen = readVarint(bytes);
			return blen > 0 ? bytes.readUTFBytes(blen) : "";
		}
		
		/**
			* 读取字节流中的32位变长整数(Protobuf)
			*/
		private static function readVarint(data:ByteArray):Number {
				var result:Number = 0
				for (var i = 0; ; i += 7) {
					if (i < 32) {
						var b:uint = data.readUnsignedByte();
						if (b >= 0x80) {
							result |= ((b & 0x7f) << i);
						}
						else {
							result |= (b << i);
							break
						}
					} else {
						while (data.readUnsignedByte() >= 0x80) { }
						break
					}
				}
				return result;
			}
		
		/**
		 * 向字节流中写入32位的可变长度的整数(Protobuf)
		 */
		private static function writeVarint(data:ByteArray, value:Number): void {
			for (; ;) {
				if (value < 0x80) {
					data.writeByte(value);
					return;
				}
				else {
					data.writeByte((value & 0x7F) | 0x80);
					value >>>= 7;
				}
			}
		}
		
		
		
		private static function mapCfgParser(data: ByteArray) {
			var maps = {};
			var len = readVarint(data);;
			var effects = [];
			for (var i = 0; i < len; i++) {
				var ulen = data.readUnsignedByte();
				effects[i] = data.readUTFBytes(ulen);
			}
			while (data.bytesAvailable) {
				var map = decodeMap(data, effects);
				maps[map.id] = map;
			}
			return maps;
		}
		
		
		private static function decodeMap(data: ByteArray, effects:Array) {
			var m:MapInfo = new MapInfo();
			const MapInfoKeys = ["id", "columns", "rows", "width", "height", "gridWidth", "gridHeight", "hasFar"];
			for (var i = 0; i < MapInfoKeys.length; i++) {
				const key = MapInfoKeys[i];
				m[key] = readVarint(data);;
			}
			m.path = m.id + "";
			m.maxPicX = m.width / m.pWidth - 1 >> 0;
			m.maxPicY = m.height / m.pHeight - 1 >> 0;
			//检查地图路径点
			var len = readVarint(data);;
			if (len) {
				var byte:ByteArray = new ByteArray();
				data.readBytes(byte, 0,len);
				m.pathdata = byte;//new Uint8Array(data.readBuffer(len));
			} else {
//				m.getWalk = getWalk1;
			}
			len = readVarint(data);
			// 暂时不增加alpha的处理
			// if (len) {
			//     m.adata = new Uint8Array(data.readBuffer(len));
			// } else {
			//     m.getAlpha = getAlpha;
			// }
			len = readVarint(data);
			if (len > 0) {
				var effs = [];
				var meffs = [];
				const layers = [1740, 1790, 1705]//GameLayerID.BottomEffect, GameLayerID.CeilEffect, GameLayerID.UnderMap];
				for (var i = 0; i < len; i++) {
					var elen = readVarint(data);;
					var idx = readZV(data);
					var uri = effects[idx];
					var x = readZV(data);
					var y = readZV(data);
					var layerID = layers[readZV(data)];
					var sX = readZV(data) * .01;
					var sY = readZV(data) * .01;
					var rotation = readZV(data);
					var eff:Object = { "uri":null, layerID:null, x:null, y:null, sX:null, sY:null, rotation:null };
					if (elen == 11) {
						eff.duration = readZV(data);
						eff.speedX = readZV(data);
						eff.speedY = readZV(data);
						eff.seed = readZV(data);
						meffs.push(eff);
					} else {
						effs.push(eff);
					}
				}

				m.effs = effs;
				m.meffs = meffs;
			}
			return m;
		}
		
		private static function readZV(data:ByteArray) {
			var n = readVarint(data);
			return n >> 1 ^ (((n & 1) << 31) >> 31);
		}
		
		
		
		
		
	}
}

class JSONHeadType {
	public static const Any:int = 0;
	public static const String:int  = 1;
	public static const Number:int  = 2;
	public static const Bool:int  = 3;
	public static const Array:int  = 4;
	public static const Array2D:int  = 5;
	public static const Date:int  = 6;
	public static const Time:int  = 7;
	public static const DateTime:int  = 8;
	public static const Int32:int  = 9
}

class PBType {
	public static const Double = 1;
	public static const Float=2;
	public static const Int64=3;
	public static const UInt64=4;
	public static const Int32=5;
	public static const Fixed64=6;
	public static const Fixed32=7;
	public static const Bool=8;
	public static const String=9;
	public static const Group=10;
	public static const Message=11;
	public static const Bytes=12;
	public static const Uint32=13;
	public static const Enum=14;
	public static const SFixed32=15;
	public static const SFixed64=16;
	public static const SInt32=17;
	public static const SInt64=18
}
class PBFieldType {
	public static const Optional = 1;
	public static const Required=2;
	public static const Repeated=3
}

class  Time {
	/**
	 * 一秒
	 */
	public static const ONE_SECOND = 1000;
	/**
	 * 五秒
	 */
	public static const FIVE_SECOND = 5000;
	/**
	 * 一分种
	 */
	public static const ONE_MINUTE = 60000;
	/**
	 * 五分种
	 */
	public static const FIVE_MINUTE = 300000;
	/**
	 * 半小时
	 */
	public static const HALF_HOUR = 1800000;
	/**
	 * 一小时
	 */
	public static const ONE_HOUR = 3600000;
	/**
	 * 一天
	 */
	public static const ONE_DAY = 86400000;
}

