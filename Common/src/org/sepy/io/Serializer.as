/*
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @license FREEWARE
 * @copyright (c) 2003 sephiroth.it
 *
 * SerializerClass is the base class for retreiving complex data type
 * from and to PHP pages using the built-in serializer/unserializer
 * php functions
 * Thanks to Rainer Becker [rainer.becker@pixelmotive.de] for the string bug fixing
 * Gavril Tarasoff for PHP5 stdObject addition
 *
 * @project : serializer
 * @file :    Serializer
 * @author :  Alessandro Crugnola- alessandro@sephiroth.it/ www.sephiroth.it
 * @version  $Id: Serializer.as,v 1.19 2006/04/19 08:37:45 sephiroth_tmm Exp $
 *
*/
package org.sepy.io
{
	import mx.core.*;
	use namespace mx_internal;
	
	/**
	 * Serializer enable you to pass and receive complex data type from/to PHP/Flash using the native PHP functions serialize and unserialize.
	 * Flash received data will be a native Flash object too.
	 * 
	 * @author alessandro crugnola (alessandro@sephiroth.it)
	 * @version 3.0.0
	 * @url http://www.sephiroth.it/test/unserializer
	 */	
	public class Serializer extends Object
	{
		public static const version:String = "3.0.0";
		
		mx_internal static var c:uint;
		mx_internal static var pattern:RegExp = /[A-Z][a-z]{2}, \d{2} [A-Z][a-z]{2} \d{4} \d{2}:\d{2}:\d{2} \+|\-\d{4}/g
		
		/**
		 * Serialize an input data into a PHP readable string
		 * which can be send through get or post and deserialized
		 * into the starting object
		 * 
		 * @param data
		 * @return the serialized string
		 * @example
		 * 
		 * <pre>
		 * var o:Object = {first:1, second:[1,2,3,4]};
		 * var result:String = Serializer.serialize(o);
		 * </pre>
		 */
		public static function serialize(data:*):String
		{
			var s:String;
			var tmp:Array = new Array();
			var i:int = 0;
			var key:String;
			
			if(data is Boolean){
				s = "b:"+uint(data)+";";
			} else if(data is int){
				s = "i:"+data.toString()+";";
			} else if(data is Number){
				s = "d:"+data.toString()+";";
			} else if(data is String){
				s = "s:"+Serializer.stringLength(data)+":\""+data+"\";"
			} else if(data is Date){
                s = "s:" + data.toString().length + ":\"" + data + "\";"
			} else if(data is Object){
                for(key in data){
                	tmp.push(Serializer.serialize(key));
                	tmp.push(Serializer.serialize(data[key]));
                    i += 1;
                }
                s = "O:8:\"stdClass\":" + i + ":{" + tmp.join("") + "}";
			} else if(data is Array){
				for(key in data){
					tmp.push(Serializer.serialize(i))
					tmp.push(Serializer.serialize(data[key]))
					i += 1
				}
				s = "a:"+i+":{"+ tmp.join("") + "}";
			} else if(data == null || data == undefined){
				s = "N;";
			} else {
                s = "i:0;"
			}
			return s;
		}
		
		/**
		 * unserialize PHP serialized string into a
		 * readable Flash object
		 * @param data serialized string
		 * @return type depends on the content of serialized string
		 * 
		 * @example
		 *  <pre>
		 *	import flash.net.*;
		 *	import org.sepy.io.Serializer;
         * 
		 *	private var req:URLRequest;
		 *	private var loader:URLLoader;
         * 
		 *	private function init():void
		 *	{
		 *		req = new URLRequest("http://localhost/serializer/unserializer.php?getvalue");
		 *		loader = new URLLoader(req);
		 *		loader.addEventListener(Event.COMPLETE, handler);
		 *		loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		 *		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
		 *	}
		 *	 
		 *	private function handler(e:Event):void
		 *	{
		 *		if(e.type == Event.COMPLETE)
		 *		{
		 *			var res:String = URLLoader(e.target).data.result
		 *			var data:* = Serializer.unserialize(res);
		 *			trace(data);
		 *		}
		 *	}
		 * 
		 *  init();
		 * 
		 *  </pre>
		 */		
		public static function unserialize(data:String):*
		{
			Serializer.c = 0;
			return Serializer.unserialize_internal(data);
		}
		
		
		mx_internal static function unserialize_internal(data:String):*
		{
			var result:*;
			var tmpvar:*;
			var tmp:Array = new Array();
			var type:String = data.charAt(Serializer.c);
			var pos:uint = 0;
			var islist:Boolean = true;
			var i:uint;
			
			switch(type){
				case "N":
					Serializer.c += 2;
					break;
				case "b":
					result = data.substr(Serializer.c+2, 1) == "1"
					Serializer.c += 4
					break;
				case "i":
					tmp.push(data.indexOf(";", Serializer.c))
					pos = Serializer.c+2
					Serializer.c = tmp[0]+1
					result = int(data.substring(pos,tmp[0]))
					break;
				case "d":
					tmp.push(data.indexOf(";", Serializer.c))
					pos = Serializer.c + 2
					Serializer.c = tmp[0]+1
					result = Number(data.substring(pos,tmp[0]))
					break;
				case "s":
					tmp.push(int(data.indexOf(":", Serializer.c+2)))
					tmp.push(tmp[0]+2)
					pos = Serializer.c+2
					tmp.push(0)
					tmp.push(int(data.substring(pos, tmp[0])))
					if(tmp[3] == 0)
					{
						result = "";
						Serializer.c = pos+5
					} else {
						var lenc:uint = Serializer.stringCLenght(data, Serializer.c, tmp[3]);
						if(lenc != tmp[3])
						{
							result = data.substr(tmp[0]+2, lenc);
							Serializer.c = tmp[0]+4+lenc;
						} else {
							result = data.substr(tmp[0]+2, tmp[3]);
							Serializer.c = tmp[0]+4+tmp[3];
						}
					}
					if(Serializer.pattern.test(result))
					{
						result = new Date(result)
					}
					break;
				case "a":
					pos = Serializer.c+2
					tmp.push(int(data.indexOf(":", pos)))
					tmp.push(int(data.substring(pos, tmp[0])))
					Serializer.c = tmp[0]+2
					result = []
					for(i = 0; i < tmp[1]; i++){
						tmpvar = Serializer.unserialize_internal(data)
						result[tmpvar] = Serializer.unserialize_internal(data)
						if(!(tmpvar is int) || tmpvar < 0){
							islist = false
						}
					}
					if(islist){
						tmp.push([])
						for(var key:uint = 0; key < result.length; key++){
							pos = tmp[2].length
							while(key > pos){
								tmp[2].push(null)
								pos +=1
							}
							tmp[2].push(result[key])
						}
						result = tmp[2]
					}
					Serializer.c += 1
					break;
		        case "O":
		            pos = data.indexOf("\"", Serializer.c)+1;
		            Serializer.c =  data.indexOf("\"", pos);
		            tmp.push(data.substring(pos, Serializer.c))
		            Serializer.c += 2
		            i = Serializer.c
			        Serializer.c = data.indexOf(":", i)
			        i = int(data.substring(i, Serializer.c))
		        	Serializer.c +=2;
		        	result = {};
		        	var tmps:*;
		        	while(i > 0){
		        		tmps = Serializer.unserialize_internal(data)
		        		result[tmps] = Serializer.unserialize_internal(data)
		        		i -= 1
		        	}
		            break;
			}
			return result;
		}
		

	    mx_internal static function stringCLenght(data:String, from:uint = 0, len:uint = 0):int
	    {
	        var i:uint;
	        var j:uint = len;
	        var startIndex:uint = from + 4 + len.toString().length;
	        for (i = 0; i < j; i++){
	            if (data.charCodeAt(i+startIndex) > 128)
	            {
	                j = j - 1
	            }
	        }
	        return j;
	    }
		
		mx_internal static function stringLength(data:String):uint
		{
			var code:int   = 0
			var result:int = 0
			var slen:int   = data.length;
			while(slen){
				slen = slen - 1
				try
				{
					code = data.charCodeAt(slen)
				} catch(e:Error){
					code = 65536
				}
				if(code < 128){
					result = result + 1
				} else if(code < 2048){
					result = result + 2
				} else if(code < 65536){
					result = result + 3
				} else {
					result = result + 4
				}
			}
			return result
		}
		
	}
}