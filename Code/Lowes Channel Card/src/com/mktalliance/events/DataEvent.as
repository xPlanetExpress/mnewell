package com.mktalliance.events
{	
	import com.mktalliance.vos.*;
	
	import flash.events.Event;

	public class DataEvent extends Event
	{
		/*-.........................................Constants..........................................*/
		
		public static const JOB_DATA: String			= "jobDataEvent";
		public static const GET_JOB_DATA: String		= "getjobDataEvent";
		public static const TEMPLATE_DATA: String 		= "templateDataEvent";
		public static const GET_TEMPLATE_DATA:String	= "gettemplateDataEvent";
		public static const LOGO_DATA: String			= "logoDataEvent";
		public static const GET_LOGO_DATA:String		= "getlogoDataEvent";
		public static const HOLE_DATA: String			= "holeDataEvent";
		public static const GET_HOLE_DATA:String		= "getholeDataEvent";
		public static const ICON_DATA: String			= "iconDataEvent";
		public static const GET_ICON_DATA:String		= "geticonDataEvent";
		public static const SAVE_DATA: String			= "saveDataEvent";
		public static const GET_DATA: String			= "getDataEvent";
		public static const UPDATE_DATA: String 		= "updateDataEvent";
		
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