/*
Copyright
*/
package com.arc90.modular
{
import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;

/**
 * The ModuleSequenceCommand overrides the <code>executeNextCommand</code> method
 * of com.adobe_cw.adobe.cairngorm.commands.SequenceCommand so that all events are dispatched
 * through the appropriate CairngormEventDispatcher instance.
 * 
 * @see CairngormEventDispatcherFactory
 */
public class ModuleSequenceCommand extends SequenceCommand
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * Constructor.
	 */
	public function ModuleSequenceCommand()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * @private
	 */
	override public function executeNextCommand():void
    {
    	var isSequenceCommand : Boolean = ( nextEvent != null );
        if( isSequenceCommand )
        	CairngormEventDispatcherFactory.getDispatcher(this).dispatchEvent( nextEvent );
    }
}
}