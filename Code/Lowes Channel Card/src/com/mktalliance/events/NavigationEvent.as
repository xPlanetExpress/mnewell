package com.mktalliance.events
{
	import com.mktalliance.vos.JobData;
	
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		/*-.........................................Constants..........................................*/
		
		public static const NEW_JOB: String			= "newJobNavigationEvent";
		public static const REPEAT_JOB: String		= "repeatJobNavigationEvent";
		public static const JOB_INFO: String 		= "jobStartNavigationEvent";
		public static const TEMPLATE: String 		= "templateNavigationEvent";
		public static const VENDOR_LOGO: String 	= "vendorNavigationEvent";
		public static const HOLE_CONFIG: String		= "holeConfigNaviationEvent";
		public static const FEATURES_ICONS: String 	= "featuresNavigationEvent";
		public static const SUBMIT_PROOF: String 	= "proofNavigationEvent";
		public static const NEXT_PANEL: String		= "nextPanelEvent";
		public static const BACK_PANEL: String		= "backPanelEvent";
		
		/*-.........................................Properties..........................................*/
		
		/*-.........................................Constructor..........................................*/	
		public function NavigationEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}