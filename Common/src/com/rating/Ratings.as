package com.rating
{
	import mx.core.UIComponent;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	
		
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
			
	[Event("change")]	
	public class Ratings extends UIComponent implements IDataRenderer, IDropInListItemRenderer,	IListItemRenderer
    {
		
		public function Ratings():void
		{
			//add the mouse move event listener so that we can update 
			//the display as the user moves out of the component capture both
			//rollout and mouse out to ensure proper display updating
			addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
			addEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
			
			//make sure we can get notified of the child events
			mouseChildren = true;
			
		}
		
		/**
		* Store the number of items to create. 
		**/
		private const itemCount:Number =5;
		
		private var contentWidth:Number=0;
		
		
		/**
		* Data storage.
		**/
		private var _data:Object;
	
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]
	    public function get data():Object
	    {
			return _data;    	
	    }
	   
	    public function set data(value:Object):void
	    {	    	
    		 _data = value;
			
			try{
				if (_listData && _listData is DataGridListData)
	        	{
	            	this.value = _data[DataGridListData(_listData).dataField];
	        	}
	        	else
	        	{
	        		this.value = int(_listData.label);
	        	}
	        	
   			}
   			catch(e:Error){
   				this.value =0;
   			}
   			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));

	    }
	    
	    /**
	    * Storage for the listData property.
	    */
	    private var _listData:BaseListData;
	    [Bindable("dataChange")]
	    public function get listData():BaseListData
	    {
	      return _listData;
	    }
	    public function set listData(value:BaseListData):void
	    {
	      _listData = value;
	    }
		
		/**
		* An array of tooltips for the rating items
		**/
		[Bindable]
		[Inspectable]
		private var _tooltips:Array = null;
		public function set tooltips(value:Array):void
		{
			_tooltips = value;
			
		}
		public function get tooltips():Array
		{
			return _tooltips;
		}
		
		
		/**
		* the value of the rating
		**/
		[Bindable(event="change")]
		[Inspectable]
		private var _value:int = 0;
		public function set value(value:int):void
		{
			_value = value;
			selectItems(value);
			
			try{
				if (_listData && _listData is DataGridListData)
		        {
		           	_data[DataGridListData(_listData).dataField] = _value;
		        }
		        else
		        {
		        	_listData.label = _value.toString();
		        }
	        }
   			catch(e:Error){
   				
   			}
   				
			
			dispatchEvent(new Event("change"));
			
		}
		public function get value():int
		{
			return _value;
		}
		
		[Bindable]
		[Inspectable]
		private var _outerRadius:Number=50;
		public function set outerRadius(value:Number):void
		{
			_outerRadius = value;
			updateChildren("outerRadius",value);
		}
		
		public function get outerRadius():Number
		{
			return _outerRadius;
			
		}
		
		[Bindable]
		[Inspectable]
		private var _innerRadius:Number=25;
		public function set innerRadius(value:Number):void
		{
			_innerRadius = value;
			updateChildren("innerRadius",value);
		}
		public function get innerRadius():Number
		{
			return _innerRadius;
		}
					
		[Bindable]
		[Inspectable]
		private var _points:Number=5;
		public function set points(value:Number):void
		{
			_points = value;
			updateChildren("points",value);
		}
		public function get points():Number
		{
			return _points;
		}
		
		[Bindable]
		[Inspectable]
		private var _angle:Number = 90;
		public function set angle(value:Number):void
		{
			_angle = value;
			updateChildren("angle",value);
		}
		public function get angle():Number
		{
			return _angle;
		}		
		
		/**
		 * Update the children if the property changes.
		 **/
		private function updateChildren(property:String, value:Number):void
		{
			for (var i:int = 1; i < itemCount+1; i++)
			{
				
				if (getChildByName(i.toString())){
					RatingItem(getChildByName(i.toString()))[property]=value;
				}
			}
			
			
		}
		
		
		/**
		* Add the star objects for rating and set thier properties and 
		* add the event listener for rollover and click
		**/
		override protected function childrenCreated():void
		{
			
			//use the horizontal Gap style for spacing between items
			var horizontalGap:Number = getStyle("horizontalGap");
			var paddingLeft:Number = getStyle("paddingLeft");
			var paddingTop:Number = getStyle("paddingTop");
			
			var lastX:Number = 0;
			
			//create each item, set the properties, and add the listeners. 		   
			for (var i:int = 1; i < itemCount+1; i++)
			{
				
				var newItem:RatingItem = new RatingItem();
				newItem.id = (i).toString();
				newItem.name =(i).toString();
				
				//if the tooltips are set apply it to the primitive
				if (tooltips)
				{
					if (tooltips.length >(i-1)){
						newItem.toolTip = tooltips[i-1].toString();
					}
				}
											
				//set the default width and height
				newItem.width = 12;
				newItem.height = 12;
				addChild(newItem);
								
				if (lastX == 0)
				{
					newItem.x=paddingLeft;
				}	
				else
				{			
					newItem.x= ((12+horizontalGap)+lastX);
				}

				lastX = newItem.x;

				newItem.y= paddingTop;
				
				//set the inicial value based on this value
				if ((i-1) < value)
				{
					newItem.selected = true;
				}
				
				newItem.addEventListener(MouseEvent.CLICK,handleItemClick,false,1);
				newItem.addEventListener(MouseEvent.ROLL_OVER,handleMouseRoll);
				newItem.addEventListener(MouseEvent.ROLL_OUT,handleMouseRoll);
				
					
			}
			
			width=newItem.x+horizontalGap;
			height = 12;
		}
						
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
												
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			//draw a transparent background so we can get the 
			//rollout/over event on the ui object in not doing 
			//this we'll get flashing when moving between items
			graphics.lineStyle(0,0xFFFFFF,1); //BOAZ CHANGE ==> graphics.lineStyle(0,0xFFFFFF,0);
			graphics.beginFill(0xFFFFFF,1); //BOAZ CHANGE ==> graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			graphics.endFill();
			
						
		}
		
		//do the selection based on passed value
		private function selectItems(value:Number):void{
			//make sure items are selected up to the target name
			//and any items after are not selected
			var currentItem:RatingItem;
			for (var i:int = 1; i < itemCount+1; i++)
			{
				currentItem = RatingItem(getChildByName(i.toString()));
				if (currentItem)
				{
					if (i <= value)
					{
						//selected		
						currentItem.selected = true;
						
					}
					else
					{
						//not selected
						currentItem.selected = false;
					}
				}
			}
			
		}
		
		
		private function handleMouseRoll(event:MouseEvent):void{
			selectItems(Number(event.currentTarget.name));
		}
		
		private function handleMouseOut(event:MouseEvent):void{
			if (event.currentTarget is Ratings)
			{
				selectItems(value);
			}
		}
		
			
		/**
		* handle the click and dispatch the event
		**/
		private function handleItemClick(event:MouseEvent):void
		{	
			
			//prevent the default and stop the propogation
			//so that the base class does not select it.
			event.preventDefault();
			event.stopImmediatePropagation();
			
			if (event.currentTarget.id == 1 && value == 1){
				value=0;
			}
			else{
				value= Number(event.currentTarget.id); 
			}
			
			dispatchEvent(event);
			
		}	
		
			     
		
	}
}