package com.mktalliance.business
{
	import com.mktalliance.events.*;
	import com.mktalliance.views.repeatPanel;
	import com.mktalliance.vos.HoleData;
	import com.mktalliance.vos.TemplateData;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.styles.StyleManager;
	
	import spark.components.TitleWindow;
	
	
	public class NavigationManager
	{
		/*-.........................................Properties..........................................*/		
		private var dispatcher:IEventDispatcher;
		
		[Bindable]
		public var currentPanel:String;
		[Bindable]
		public var templateData:TemplateData;
		
		/*-.........................................Constructor..........................................*/
		public function NavigationManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		/*-.........................................Methods..........................................*/
		public function uiEvent():void
		{
			//currentPanel = event.currentTarget.mainView.viewStack.selectedChild.label;
			//trace(event.currentTarget.mainView.viewStack.selectedChild.label);
			//trace(event.currentTarget.mainView.viewStack.selectedIndex);
			currentPanel = "1: Template Selection";
		}
		
		public function nextPanel(event:Event):void
		{	
			if(event.currentTarget.mainView.viewStack.selectedIndex == 0) {
				currentPanel = "2: Job Information";
				var tEvent:NavigationEvent = new NavigationEvent(NavigationEvent.JOB_INFO);				
				dispatcher.dispatchEvent(tEvent);
				//event.currentTarget.mainView.backButton.enabled = true;
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 1){
				currentPanel = "3: Logo Selection";
				var iEvent:NavigationEvent = new NavigationEvent(NavigationEvent.VENDOR_LOGO);				
				dispatcher.dispatchEvent(iEvent);
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 2){
				if(templateData._templateType.webshopColor == "7.9x2.625_bar.indd" ||
					templateData._templateType.webshopColor == "11.75x6_pullout.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_pulldown.indd" ||
					templateData._templateType.webshopColor == "11.75x6_kitchenfaucet.indd"){
						currentPanel = "4: Hole Configuration";
						var hEvent:NavigationEvent = new NavigationEvent(NavigationEvent.HOLE_CONFIG);				
						dispatcher.dispatchEvent(hEvent);
					
				}
				else if(templateData._templateType.webshopColor == "7.9x2.625_centerset.indd" ||
					templateData._templateType.webshopColor == "7.9x2.625_laundryfaucet.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_romantub.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_tubonly.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_tubshower.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_showeronly.indd" ||
					templateData._templateType.webshopColor == "7.9x2.625_Vessel.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_widespread.indd"){
						currentPanel = "6: Submit Proof";
						var sEvent:NavigationEvent = new NavigationEvent(NavigationEvent.SUBMIT_PROOF);				
						dispatcher.dispatchEvent(sEvent);
				}
				
				else {
					currentPanel = "5: Feature Icons";
					var fEvent:NavigationEvent = new NavigationEvent(NavigationEvent.FEATURES_ICONS);
					dispatcher.dispatchEvent(fEvent);
				}
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 3){
				currentPanel = "5: Feature Icons";
				var fiEvent:NavigationEvent = new NavigationEvent(NavigationEvent.FEATURES_ICONS);				
				dispatcher.dispatchEvent(fiEvent);
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 4){
				currentPanel = "6: Submit Proof";
				var sEvent:NavigationEvent = new NavigationEvent(NavigationEvent.SUBMIT_PROOF);				
				dispatcher.dispatchEvent(sEvent);
				//event.currentTarget.mainView.nextButton.enabled = false;
			}
		}
		
		public function backPanel(event:Event):void
		{
			if(event.currentTarget.mainView.viewStack.selectedIndex == 1) {
				currentPanel = "1: Template Selection";
				var jEvent:NavigationEvent = new NavigationEvent(NavigationEvent.TEMPLATE);				
				dispatcher.dispatchEvent(jEvent);
				//event.currentTarget.mainView.backButton.enabled = false;
			}
			
			else if(event.currentTarget.mainView.viewStack.selectedIndex == 2) {
				currentPanel = "2: Job Information";
				var tEvent:NavigationEvent = new NavigationEvent(NavigationEvent.JOB_INFO);				
				dispatcher.dispatchEvent(tEvent);
				//currentPanel = "2: Template Selection";
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 3){
				currentPanel = "3: Logo Selection";
				var vEvent:NavigationEvent = new NavigationEvent(NavigationEvent.VENDOR_LOGO);				
				dispatcher.dispatchEvent(vEvent);
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 4){
				if(templateData._templateType.webshopColor == "7.9x2.625_bar.indd" ||
					templateData._templateType.webshopColor == "11.75x6_pullout.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_pulldown.indd" ||
					templateData._templateType.webshopColor == "11.75x6_kitchenfaucet.indd"){					
					currentPanel = "4: Hole Configuration";
					var hEvent:NavigationEvent = new NavigationEvent(NavigationEvent.HOLE_CONFIG);				
					dispatcher.dispatchEvent(hEvent);
					
				}
				else {
					currentPanel = "3: Logo Selection";
					var lEvent:NavigationEvent = new NavigationEvent(NavigationEvent.VENDOR_LOGO);
					dispatcher.dispatchEvent(lEvent);
				}
			}
			
			else if (event.currentTarget.mainView.viewStack.selectedIndex == 5){
				if(templateData._templateType.webshopColor == "7.9x2.625_centerset.indd" ||
					templateData._templateType.webshopColor == "7.9x2.625_laundryfaucet.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_romantub.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_tubonly.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_tubshower.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_showeronly.indd" ||
					templateData._templateType.webshopColor == "7.9x2.625_Vessel.indd" ||
					templateData._templateType.webshopColor == "11.75x2.625_widespread.indd"){
					currentPanel = "3: Logo Selection";
					var vEvent:NavigationEvent = new NavigationEvent(NavigationEvent.VENDOR_LOGO);				
					dispatcher.dispatchEvent(vEvent);
				}
				else {
					currentPanel = "5: Feature Icons";
					//event.currentTarget.mainView.nextButton.enabled = true;	
					var sEvent:NavigationEvent = new NavigationEvent(NavigationEvent.FEATURES_ICONS);				
					dispatcher.dispatchEvent(sEvent);
				}
			}
			
		}
		
		public function repeatPanel(event:Event):void
		{
			trace("repeat");
			/*var repeatWindow:TitleWindow = PopUpManager.createPopUp(this, repeatPanel, false) as TitleWindow;
			var repeatWindow:com.mktalliance.views.repeatPanel = repeatPanel( PopUpManager.createPopUp(UIComponent(Application.application),repeatPanel, true));
			PopUpManager.centerPopUp(repeatWindow);*/
			
			
			/*var popUp:RegisterWindow = RegisterWindow( PopUpManager.createPopUp(UIComponent(Application.application),RegisterWindow, true ))
			PopUpManager.centerPopUp(popUp);*/

		}
		
		/*public function login(username:String, password:String):Boolean 
		{
			check hardcoded username and password
			if (username == 'Flex' && password == 'Mate') 
			{
				login ok, send navigation event
				var event:NavigationEvent = new NavigationEvent(NavigationEvent.CATALOG_START);
				dispatcher.dispatchEvent(event);
				StyleManager.loadStyleDeclarations("http://localhost:8500/magalog/Magalog-debug/assets/styles/orange.swf");
				return true;
			}
			return false;
		}
		
		public function logout():void
		{
			var event:NavigationEvent = new NavigationEvent(NavigationEvent.LOGIN);
			dispatcher.dispatchEvent(event);
		}*/
	}
}