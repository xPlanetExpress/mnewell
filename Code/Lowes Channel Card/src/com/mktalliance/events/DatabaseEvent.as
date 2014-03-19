package com.mktalliance.events
{	
	import com.mktalliance.vos.*;
	
	import flash.events.Event;

	public class DatabaseEvent extends Event
	{
		/*-.........................................Constants..........................................*/
		
		public static const SAVE_JOB_DATA: String		= "saveJobDatabaseEvent";
		public static const GET_JOB_DATA: String		= "getjobDatabaseEvent";
		public static const UPDDATE_JOB_DATA: String 	= "updateDatabaseEvent";
		
		/*-.........................................Properties..........................................*/
		public var jobData:JobData;
		public var templateData:TemplateData;
		public var logoData:LogoData;
		public var holeData:HoleData;
		public var iconData:IconData;
		
		/*-.........................................Constructor..........................................*/	
		public function DataEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}