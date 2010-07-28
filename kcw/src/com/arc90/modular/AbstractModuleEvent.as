/*
Copyright
*/
package com.arc90.modular
{
import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;

/**
 * The AbstractModuleEvent extends com.bjorn.event.ChainEvent and overrides the <code>dispatch</code>
 * method defined in com.adobe_cw.adobe.cairngorm.control.CairngormEvent. It uses the CairngormEventDispatcheFactory
 * to dispatch events.
 * 
 * @see CairngormEventDispatcheFactory
 */
public class AbstractModuleEvent extends CairngormEvent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * Constructor.
	 */
	public function AbstractModuleEvent(type:String, nextSequenceEvent:AbstractModuleEvent=null)
	{
		super(type);
		
		this.nextSequenceEvent = nextSequenceEvent;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------	

	//----------------------------------
	//  nextSequenceEvent
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the nextSequenceEvent property.
	 */
	private var _nextSequenceEvent:AbstractModuleEvent;
	
	/**
	 * The next event in a chain of sequence events.
	 */
	public function get nextSequenceEvent():AbstractModuleEvent
	{
		return _nextSequenceEvent;	
	}
	
	/**
	 * @private
	 */
	public function set nextSequenceEvent(value:AbstractModuleEvent):void
	{
		_nextSequenceEvent = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */	
	override public function dispatch():Boolean
	{
		return CairngormEventDispatcherFactory.getDispatcher(this).dispatchEvent(this);
	} 	
}
}