package com.kaltura.commands.upload
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.upload.UploadUploadByTokenIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadUploadByTokenId extends KalturaCall
	{
		public var filterFields : String;
		public function UploadUploadByTokenId( fileData : file,uploadTokenId : String )
		{
			service= 'upload';
			action= 'uploadByTokenId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(fileData,'fileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'uploadTokenId' );
			valueArr.push( uploadTokenId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new UploadUploadByTokenIdDelegate( this , config );
		}
	}
}
