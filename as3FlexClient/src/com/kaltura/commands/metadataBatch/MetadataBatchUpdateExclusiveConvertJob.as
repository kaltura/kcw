package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.delegates.metadataBatch.MetadataBatchUpdateExclusiveConvertJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchUpdateExclusiveConvertJob extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchUpdateExclusiveConvertJob( id : int,lockKey : KalturaExclusiveLockKey,job : KalturaBatchJob,entryStatus : int=undefined )
		{
			service= 'metadata_metadatabatch';
			action= 'updateExclusiveConvertJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(lockKey,'lockKey');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'entryStatus' );
			valueArr.push( entryStatus );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchUpdateExclusiveConvertJobDelegate( this , config );
		}
	}
}
