/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import componets.adminPanel;
import componets.loginPanel;
import flash.system.*;
import mx.controls.Alert;
import mx.events.BrowserChangeEvent;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.managers.PopUpManager;
import mx.printing.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;
import mx.utils.URLUtil;

/**
 * gateway : this is the communication layer with the server side ASP.NET code
 */
public var gateway:WebService = new WebService();
public var browserManager:IBrowserManager;

[Bindable]
public var myUserRole:Object;
[Bindable]
public var myCompany:String;
[Bindable]
public var serverName:String;
[Bindable]
public var fromjobID:int;


private function initApp():void {
	var showLoginPanel:loginPanel=loginPanel(PopUpManager.createPopUp( this, loginPanel, true));
	PopUpManager.centerPopUp(showLoginPanel);
	showLoginPanel.addEventListener(Event.CLOSE, myUserRoleHandler);
	/**
 	* Loadind the URL to know which Domain the user is in
 	*/	
	browserManager = BrowserManager.getInstance();
    browserManager.addEventListener(BrowserChangeEvent.URL_CHANGE, showURLDetails);
    browserManager.init("", "Welcome!");    
    
    var url:String = browserManager.base;
    serverName = URLUtil.getServerName(url);
    if(serverName == 'ap.mktalliance.com'){
		myCompany = "ap";
	}
	else if(serverName == 'paramount.mktalliance.com'){
		myCompany = "pp";
	}
	else if(serverName == 'mattnewell.mktalliance.com'){
		myCompany = "ap";
	}
	browserManager.setTitle("Welcome to " + serverName);
	/**
 	* initialize the gateway
 	* - this will take care off server communication and simple xml protocol.
 	*/
	//gateway.wsdl = "http://ap.mktalliance.com/trayprinter/services/trayprint.asmx?wsdl";
	gateway.wsdl = "http://" + serverName + "/trayprinter/services/trayprint.asmx?wsdl";
	gateway.loadWSDL();
	gateway.InsertMold.addEventListener(ResultEvent.RESULT, insertItemHandler);
}

/**
 * This is a fix for the browserManager bug.
 */
private function showURLDetails(e:BrowserChangeEvent):void {
}

/**
 * Click handler for the "Save" button in the "Add" state
 * collects the information in the form and adds a new object to the collection
 */
private function insertItem():void {
	gateway.InsertMold(moldnameCol.text, moldwidthCol.value, moldheightCol.value, moldacrossCol.value,	molddownCol.value, gwidthCol.value,	gdepthCol.value,	numberofholesCol.value,	swatchwidthCol.value,	swatchheightCol.value,	myUserRole.trayuserid);
}

/**
 * Result handler for the insert call.
 * Alert the error if it exists
 * if the call went through ok, return to the list, and refresh the data
 */
private function insertItemHandler(e:ResultEvent):void {
	addMoldBar.visible = false;
	addMoldBar.height = 1;
	moldclearAll();
}

/**
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
private function faultHandler(e:FaultEvent):void {
	Alert.show("An unexpected error occurred and has been logged.");
}


private function myUserRoleHandler(e:Event):void {
	if(myUserRole.userRole == 'admin'){
		buttonBar.dataProvider = ['Jobs', 'Colorline', 'Admin'];
		this.jobPanelData.btnInactivate.enabled = true;
		this.jobPanelData.btnInactivate.visible = true;
	}
	else if(myUserRole.userRole != 'admin'){
		buttonBar.dataProvider = ['Jobs', 'Colorline'];
		this.jobPanelData.btnInactivate.enabled = false;
		this.jobPanelData.btnInactivate.visible = false;
	}
}

public function moldclearAll():void {
	moldnameCol.text = "";
	moldwidthCol.value = 0;
	moldheightCol.value = 0;
	moldacrossCol.value = 0;
	molddownCol.value = 0;
	numberofholesCol.value = 0;
	gwidthCol.value = 0.125;
	gdepthCol.value = 0.125;
	swatchwidthCol.value = 0.125;
	swatchheightCol.value = 0.125;
	
}