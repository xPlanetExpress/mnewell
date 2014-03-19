/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.managers.CursorManager;
import mx.managers.IBrowserManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

/**
 * the array collection holds the rows that we use in the grid
 */
[Bindable]
public var dataArr:ArrayCollection = new ArrayCollection();

public var browserManager:IBrowserManager;

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
private function initApp():void {
    /**
    * webservice[gateway] event listeners
    */
    parentApplication.gateway.FindBCMJob.addEventListener(ResultEvent.RESULT, fillHandler);
    parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
    //fill(); If this changes the myCompany logic will have to change
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
    CursorManager.setBusyCursor();
    var filter:String = filterTxt.text;
	parentApplication.gateway.FindBCMJob(filter);
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
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
public function faultHandler(e:FaultEvent):void{
	Alert.show("An unexpected error occurred and has been logged.");
}
