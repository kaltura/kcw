/*
Copyright
*/
package com.arc90.modular
{
import com.adobe_cw.adobe.cairngorm.CairngormError;
import com.adobe_cw.adobe.cairngorm.CairngormMessageCodes;
import com.adobe_cw.adobe.cairngorm.control.FrontController;

/**
 * The ModuleFrontController overrides the <code>addCommand</code> and <code>removeCommand</code> 
 * methods of com.adobe_cw.adobe.cairngorm.control.FrontController so that all events are attached to and
 * removed from the appropriate CairngormEventDispatcher instance.
 * 
 * @see CairngormEventDispatcherFactory
 */
public class ModuleFrontController extends FrontController
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * Constructor.
	 */
	public function ModuleFrontController()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * @private
	 */
	override public function addCommand( commandName : String, commandRef : Class, useWeakReference : Boolean = true ) : void
	{
	     if( commands[ commandName ] != null )
	        throw new CairngormError( CairngormMessageCodes.COMMAND_ALREADY_REGISTERED, commandName );
	     
	     commands[ commandName ] = commandRef;
	     CairngormEventDispatcherFactory.getDispatcher(this).addEventListener( commandName, executeCommand, false, 0, useWeakReference );
	}
      
	/**
	 * @private
	 */
	override public function removeCommand( commandName : String ) : void
  	{
    	if( commands[ commandName ] === null)
        	throw new CairngormError( CairngormMessageCodes.COMMAND_NOT_REGISTERED, commandName);  
     
    	CairngormEventDispatcherFactory.getDispatcher(this).removeEventListener( commandName, executeCommand );
     	commands[ commandName ] = null;
    	delete commands[ commandName ]; 
	}
}
}