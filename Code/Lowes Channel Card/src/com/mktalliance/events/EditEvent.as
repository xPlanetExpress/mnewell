package com.mktalliance.events
{	
	import com.mktalliance.vos.EditData;
	
	import flash.events.Event;

	public class EditEvent extends Event
	{
		/*-.........................................Constants..........................................*/
		
		public static const EDIT_JOB: String			= "editJobEvent";
		
		/*-.........................................Properties..........................................*/
		public var editData:EditData;
		
		/*-.........................................Constructor..........................................*/	
		public function EditEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}