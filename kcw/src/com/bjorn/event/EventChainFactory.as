/*
Copyright
*/
package com.bjorn.event
{

public class EventChainFactory
{
	public static function chainEvents( evts:Array ):ChainEvent
	{
		var len:int = evts.length;
		if ( len < 1 )
			return null;
			
		var returnEvent:ChainEvent = evts[ 0 ] as ChainEvent;
		
		var i:int = len-1;
		for ( i; i>=0; i-- )
		{
			if ( i != ( len-1 ) )
			{
				var e:ChainEvent = evts[ i ] as ChainEvent;
				var next_e:ChainEvent = evts[ i+1 ] as ChainEvent;
				e.nextChainedEvent = next_e;
			}
		}
		
		return returnEvent;
	}
}

}