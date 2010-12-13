package com.kaltura.commands.upload
{
	import com.kaltura.delegates.upload.UploadGetUploadTokenIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadGetUploadTokenId extends KalturaCall
	{
		public var filterFields : String;
		public function UploadGetUploadTokenId(  )
		{
			service= 'upload';
			action= 'getUploadTokenId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new UploadGetUploadTokenIdDelegate( this , config );
		}
	}
}
