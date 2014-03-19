/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import flash.system.*;

import mx.collections.ArrayCollection;
import mx.containers.Tile;
import mx.controls.Alert;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;


/**
 * the array collection holds the rows that we use in the grid
 */
[Bindable]
public var colornameArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var bcmcolornameArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var moldnameArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var dataArr:ArrayCollection = new ArrayCollection();

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
public function initApp():void {
 parentApplication.gateway.FindAllMold.addEventListener(ResultEvent.RESULT, findmoldHandler);
 parentApplication.gateway.FindJobColorname.addEventListener(ResultEvent.RESULT, jobColornameHandler);
 parentApplication.gateway.FindBCMJob.addEventListener(ResultEvent.RESULT, fillHandler);
 parentApplication.gateway.FindBCMColorline.addEventListener(ResultEvent.RESULT, bcmjobColornameHandler);
 parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
}

public function findmoldHandler(e:ResultEvent):void {
	var table:* = e.result.Tables.Table0.Rows;
	moldnameArr = table;	
    CursorManager.removeBusyCursor();
}

public function jobColornameHandler(e:ResultEvent):void {
    var table:ArrayCollection = e.result.Tables.Table0.Rows;
    colornameArr = table;
}

/**
 * Click handler for the "Save" button in the "Add" state
 * collects the information in the form and adds a new object to the collection
 */
public function JobColorname():void {
	CursorManager.setBusyCursor();
	parentApplication.gateway.FindJobColorname(parentApplication.jobPanelData.dataGrid.selectedItem.trayjobid, "sequencenumber" , true);
	parentApplication.gateway.FindAllMold(parentApplication.jobPanelData.dataGrid.selectedItem.moldname, "", true);
}

private function SaveColorNames():void {
	CursorManager.setBusyCursor();
	for(var i:int=0;i<colornameArr.length;i++) {
		colorName[i].text = colorName[i].text.toUpperCase();
		parentApplication.gateway.UpdateJobColorname(colornameArr.getItemAt(i).traycolorid, colorName[i].text, colornameArr.getItemAt(i).jobid, colornameArr.getItemAt(i).sequencenumber);
	}
	parentApplication.gateway.UpdateJob(parentApplication.jobPanelData.dataGrid.selectedItem.trayjobid, parentApplication.myCompany, parentApplication.jobPanelData.dataGrid.selectedItem.jobname, parentApplication.jobPanelData.dataGrid.selectedItem.trayid, parentApplication.jobPanelData.dataGrid.selectedItem.stylename, parentApplication.jobPanelData.dataGrid.selectedItem.status, parentApplication.jobPanelData.dataGrid.selectedItem.active, parentApplication.jobPanelData.dataGrid.selectedItem.qty, parentApplication.myUserRole.trayuserid, parentApplication.jobPanelData.dataGrid.selectedItem.createdby);
	CursorManager.removeBusyCursor();
	parentApplication.buttonBar.selectedIndex = 0;
}

private function CopyColorNames():void {
	var colorString:String = ""
	for(var i:int = 0; i < colornameArr.length;i++) {
		colorString += String(colornameArr[i].colorname)+'\r\n';
	}
	System.setClipboard(colorString);
}

private function ReportColorNames():void {
	//&reportOutput=folder/reportname.pdf
	//How to specify output path
	var url:String = "http://paramount.mktalliance.com/DDP/ReportViewer.aspx?ReportName=/DDP/TrayPrintReport&jobid=" + parentApplication.jobPanelData.dataGrid.selectedItem.trayjobid;
	var request:URLRequest = new URLRequest(url);
	try {
		navigateToURL(request, '_blank'); 
	}
	catch (e:Error) {
    	trace("Error occurred!");
	}
}

/**
 * Click handler for "Filter" button.
 * When setting another filter, refresh the collection, and load the new data
 */
private function filterResults():void{
    if(filterTxt.length >= 4){
		fill();
	}
	else{
		Alert.show("You must type at least 4 characters to search for a job.");
	}
	
}

/** 
 * general utility function for refreshing the data 
 * gets the filtering and ordering, then dispatches a new server call
 *
 */
private function fill():void {
    dataGrid.enabled = false;
    var filter:String = filterTxt.text;
	parentApplication.gateway.FindBCMJob(filter,parentApplication.myCompany);
}

/** 
 * result handler for the fill call. 
 * if it is an error, show it to the user, else refill the arraycollection with the new data
 *
 */
private function fillHandler(e:ResultEvent):void{
	var table:* = e.result.Tables.Table0.Rows;
	dataArr = table;
	
    CursorManager.removeBusyCursor();
    dataGrid.enabled = true;
}
/** 
 * general utility function for refreshing the data 
 * gets the filtering and ordering, then dispatches a new server call
 *
 */

private function bcmColorline():void {
	parentApplication.gateway.FindBCMColorline(dataGrid.selectedItem.jobname, parentApplication.myCompany);
}

/** 
 * result handler for the fill call. 
 * if it is an error, show it to the user, else refill the arraycollection with the new data
 *
 */
private function bcmjobColornameHandler(e:ResultEvent):void{
	var table:* = e.result.Tables.Table0.Rows;
    bcmcolornameArr = table;
    if(colornameArr.length == bcmcolornameArr.length){
    	for(var i:int = 0; i < colornameArr.length;i++) {
    		colornameArr[i].colorname = bcmcolornameArr[i].colorname;	
    	}	
    }
    else{
    	Alert.show("The number of colors does not match the bcm job.\nPlease check the mold and number of swatches.");
    }
    CursorManager.removeBusyCursor();
}

private function enableImport():void {
	btnImportColors.enabled = true;
}

private function importColors():void {
	CursorManager.setBusyCursor();
	bcmColorline();
	applicationScreens.selectedChild = colorScreen;
}

private function scrollDown():void {
	callLater(autoScrollTile, [myTile]);
}

private function autoScrollTile(target:Tile):void {
	target.verticalScrollPosition = target.verticalScrollPosition + 81;
}

/**
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
private function faultHandler(e:FaultEvent):void {
	Alert.show("An unexpected error occurred and has been logged.");
}

private function showBCMJobs():void {
    applicationScreens.selectedChild = bcmScreen;
}

private function showColorNames():void {
    applicationScreens.selectedChild = colorScreen;
}