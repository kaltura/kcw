package com.kaltura.utils
{
    import flash.net.SharedObject;

    public class LSOHandler {

        private var _lso:SharedObject;
        private var _name:String;
        private var _path:String;

        // The parameter is "feeds" or "sites".
        public function LSOHandler(name:String, path:String = null)
        {
            _name = name;
            _path = path;
            init();
        }

        private function init():void
        {
            _lso = SharedObject.getLocal(_name, _path);
        }

        public function getData():Object
        {
            return _lso.data ?
				            _lso.data :
				            {};
        }

        public function flush():void
        {
        	try
        	{
	            _lso.flush();
        	}
        	catch(e:Error)
        	{
				//teh user had permanently denied writing local objects
        	}
        }
    }

}
