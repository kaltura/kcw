/*
Copyright
*/
package com.arc90.modular
{
import com.adobe_cw.adobe.cairngorm.control.CairngormEventDispatcher;

import flash.utils.Dictionary;

import mx.modules.ModuleManager;

/**
 * Utility class that creates and tracks instances of CairngormEventDispatcher
 * by the module that created the instance.
 */
public class CairngormEventDispatcherFactory
{
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * @private
	 * All instances of the CairngormEventDispatcher that have been instantiated.
	 */
	private static var instances:Dictionary = new Dictionary();
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * Returns the CairngormEventDispatcher instance that corresponds to
	 * the module or application that triggered the event.
	 */
	public static function getDispatcher(obj:Object):CairngormEventDispatcher
	{
		// in order for each module developed using cairngorm to be able
		// to work independently of the shell and other modules,
		// we need to create a hash map of cairngormeventdispatchers
		// that are keyed on module instance or application.
		// This prevents cross module listening for events,
		// which is beneficial especially when loading multiple instances
		// of the same module
		var instance:Object = ModuleManager.getAssociatedFactory(obj);
		var parent:String = "application";
	
		if(instance != null)
			parent = instance.name;
		
		if(instances[parent] == null)
		{
			var cgDispatcher:CairngormEventDispatcher = new CairngormEventDispatcher();
			instances[parent] = cgDispatcher;
			return cgDispatcher;
		}
		else
		{
			return instances[parent];
		}
	}
	
	/**
	 * Takes an array of AbstractModuleEvents and sequences them in the order
	 * in which they are present in the array.
	 * 
	 * @param evts Array of AbstractModuleEvents
	 */
	public static function sequenceEvents(evts:Array):AbstractModuleEvent
    {
        var len:int = evts.length;
        if ( len < 1 )
            return null;
            
        var returnEvent:AbstractModuleEvent = evts[ 0 ] as AbstractModuleEvent;
        
        var i:int = len-1;
        for ( i; i>=0; i-- )
        {
            if ( i != ( len-1 ) )
            {
                var e:AbstractModuleEvent = evts[ i ] as AbstractModuleEvent;
                var next_e:AbstractModuleEvent = evts[ i+1 ] as AbstractModuleEvent;
                e.nextSequenceEvent = next_e;
            }
        }
        
        return returnEvent;
    }
}
}