/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import flash.net.URLRequest;

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
 * column that we order by. This is updated each time the users clicks on the 
 * grid column header. 
 * see headerRelease="setOrder(event);" in the DataGrid instantiation in the 
 * mxml file
 */
private var orderColumn:Number;


/**
 * the list of fields in the database table
 * needed to parse the response into hashes
 */ 
private var fields:Object = {  'trayjobid':Number, 'company':String, 'jobname':String, 'trayid':Number, 'stylename':String, 'status':Number, 'qty':Number, 'lastupdatedby':Number, 'createdby':Number};

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
private function initApp():void {	
    /**
     * set the event handler which prevents editing of the primary key
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, editCellHandler);

    /**
     * set the event handler which triggers the update actions - everytime an 
     * edit operation is finished
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, editCellEnd);
    /**
    * webservice[gateway] event listeners
    */
    parentApplication.gateway.FindAllJob.addEventListener(ResultEvent.RESULT, fillHandler);
    parentApplication.gateway.UpdateJob.addEventListener(ResultEvent.RESULT, saveItemHandler);
    parentApplication.gateway.InsertJob.addEventListener(ResultEvent.RESULT, insertItemHandler);
    parentApplication.gateway.DupJob.addEventListener(ResultEvent.RESULT, dupItemHandler);
    parentApplication.gateway.RemoveJob.addEventListener(ResultEvent.RESULT, deleteHandler);
    parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
    //fill(); If this changes the myCompany logic will have to change
}

public function getDateLabel(item:Object,column:DataGridColumn):String {
	return dateFormatter.format(item[column.dataField]);
}

/**
 * Disallow editing of the primary key column.
 * @param e DataGridEvent contains details about the row and column of the grid 
 * where the user clicked
 */
private function editCellHandler(e:DataGridEvent):void{
    /**
     * if the user clicked on the primary key column, stop editing
     */
    if(e.dataField == "moldname")
    {
        e.preventDefault();
        return;
    }
	else if(e.dataField == "userlastupdatedby")
    {
        e.preventDefault();
        return;
    }
    else if(e.dataField == "usercreatedby")
    {
        e.preventDefault();
        return;
    }
}

/**
 * Click handler for "Filter" button.
 * When setting another filter, refresh the collection, and load the new data
 */
private function filterResults():void{
    fill();
}

/**
 * Event handler triggered when the user finishes editing an entry
 * triggers an "update" server command
 */
private function editCellEnd(e:DataGridEvent):void{
	parentApplication.buttonBar.enabled = false;
    var dsRowIndex:int = e.rowIndex;
    var dsFieldName:String = e.dataField;
    var dsColumnIndex:Number = e.columnIndex;

    var vo:* = dataArr[dsRowIndex];
    
    var col:DataGridColumn = dataGrid.columns[dsColumnIndex];
    var newvalue:String = dataGrid.itemEditorInstance[col.editorDataField];

	vo[dsFieldName] = newvalue;
	
	parentApplication.gateway.UpdateJob(vo.trayjobid, vo.company, vo.jobname, vo.trayid, vo.stylename, vo.status, vo.active, vo.qty, parentApplication.myUserRole.trayuserid, vo.createdby);
	dataGrid.editable = false;
}

private function updateJob():void {
	var from_numberofColors:int = dataGrid.selectedItem.numberofholes;
	var to_numberofColors:int = editJobMold.dataGrid.selectedItem.numberofholes;
	
	if(from_numberofColors >= to_numberofColors){
		var delete_numberofColors:int = from_numberofColors - to_numberofColors;
		parentApplication.gateway.RemoveJobColor(dataGrid.selectedItem.trayjobid, delete_numberofColors);
	}
	else if(to_numberofColors >= from_numberofColors){
		var add_numberofColors:int =  to_numberofColors - from_numberofColors;
		for (var c:Number = 1; c<=add_numberofColors; c++){
		parentApplication.gateway.InsertJobColorname(' ',dataGrid.selectedItem.trayjobid, from_numberofColors + c);
		}
	}
	parentApplication.gateway.UpdateJob(dataGrid.selectedItem.trayjobid, editcompanyCol.text, editjobnameCol.text, edittrayidCol.text, editstylenameCol.text, editstatusCol.text, editactiveCol.text, editqtyCol.value, editlastupdatedbyCol.text, editcreatedbyCol.text	);
	goToView();
	editclearAll();
}

private function inActiveJobs():void {
	parentApplication.gateway.UpdateJob(dataGrid.selectedItem.trayjobid, dataGrid.selectedItem.company, dataGrid.selectedItem.jobname, dataGrid.selectedItem.trayid, dataGrid.selectedItem.stylename, 1, 0, dataGrid.selectedItem.qty, parentApplication.myUserRole.trayuserid, dataGrid.selectedItem.createdby);
	fill();
}

/**
 * result handler for the "update" server command.
 * Just alert the error, or do nothing if it's ok - the data has already 
 * been updated in the grid
 */
private function saveItemHandler(e:ResultEvent):void{
    fill();
}

/**
 * dragHeader handler for the datagrid. This handler is executed when the user 
 * clicks on a header column in the datagrid
 * updates the global orderColumn variable, refreshes the TableCollection
 * @param event DataGridEvent details about the column
 */
private function setOrder(event:DataGridEvent):void {
    orderColumn = event.columnIndex;
    var col:DataGridColumn = dataGrid.columns[orderColumn];
    col.sortDescending = !col.sortDescending;
    
    event.preventDefault();
    fill();
}

/**
 * Click handler for the "Save" button in the "Add" state
 * collects the information in the form and adds a new object to the collection
 */
private function insertItem():void {
	parentApplication.gateway.InsertJob(parentApplication.myCompany, jobnameCol.text, trayidCol.text, stylenameCol.text, statusCol.text, activeCol.text, qtyCol.value, lastupdatedbyCol.text, createdbyCol.text	);
}

/**
 * Result handler for the insert call.
 * Alert the error if it exists
 * if the call went through ok, return to the list, and refresh the data
 */
private function insertItemHandler(e:ResultEvent):void {
	if(e.result.Tables.validJob.Rows[0].Column1 == 0) {
		var table:* = e.result.Tables.validJob.Rows;
		var newjobColor:Object = table.getItemAt(1);
		var insertintoJob:int = newjobColor.Column1;
		var numberOfColors:int = addnewJobMold.dataGrid.selectedItem.numberofholes;
	
		for (var j:Number = 1; j<=numberOfColors; j++){
			parentApplication.gateway.InsertJobColorname(' ',insertintoJob, j);
		}
	
    	goToView();
    	fill();
    	newclearAll();
	}
	else if(e.result.Tables.validJob.Rows[0].Column1 == 1) {
		Alert.show("A job with the same name already exists. Please check the active job list. ","Job Name Error");
	}
}

private function dupItem():void {
	parentApplication.gateway.DupJob(parentApplication.myCompany, dupjobnameCol.text, duptrayidCol.text, dupstylenameCol.text, dupstatusCol.text, dupactiveCol.text, dupqtyCol.value, duplastupdatedbyCol.text, dupcreatedbyCol.text	);
}

private function dupItemHandler(e:ResultEvent):void {
	var table:* = e.result.Tables.Table0.Rows;
	var newjobDup:Object = table.getItemAt(0);
	var tojobID:int = newjobDup.Column1;

	parentApplication.gateway.DupJobColorname(parentApplication.fromjobID, tojobID);
	
    goToView();
    fill();
    //dupclearAll();
}

/** 
 * general utility function for refreshing the data 
 * gets the filtering and ordering, then dispatches a new server call
 *
 */
private function fill():void {
    /**
     * find the order parameters
     */
    var desc:Boolean = false;
    var orderField:String = '';
    
    if(!isNaN(orderColumn))
    {
        var col:DataGridColumn = dataGrid.columns[orderColumn];
        desc = col.sortDescending;
        orderField = col.dataField;
    }

    dataGrid.enabled = false;
    CursorManager.setBusyCursor();

    var filter:String = filterTxt.text;
	/*
    if (isNaN(filter)) {
    	filter = 0;
    }
	*/
	parentApplication.gateway.FindAllJob(parentApplication.myCompany, filter, orderField, desc);
	
	/**
	 * Keep user from not selecting job.
	* */
	parentApplication.buttonBar.enabled = false;
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
 * Click handler for the "delete" button in the list
 * confirms the action and launches the deleteClickHandler function
 */
private function deleteItem():void {
    
    if (dataGrid.selectedItem)
    {
        Alert.show("Are you sure you want to delete the selected record?",
        "Confirm Delete", 3, this, deleteClickHandler);
    }
    
}

/**
 * Event handler function for the Confirm dialog raises when the 
 * Delete button is pressed.
 * If the pressed button was Yes, then the product is deleted.
 * @param object event
 * @return nothing
 */ 
private function deleteClickHandler(event:CloseEvent):void{
    var indexForDelete:Number = dataGrid.selectedIndex.valueOf();
    if (indexForDelete == -1) {
        return;    
    }
    if (event.detail == Alert.YES) 
    {
        var vo:* = dataArr[indexForDelete];
		
		var jobtoken:AsyncToken = parentApplication.gateway.RemoveJob(vo.trayjobid);
		jobtoken.trayjobid = vo.trayjobid;
		
        setTimeout( function():void
        {
            dataGrid.destroyItemEditor();
        },
        1);
    }
}

public function deleteHandler(e:ResultEvent):void{
   	var trayjobid:Number = e.token.trayjobid;
    for (var index:Number = 0; index < dataArr.length; index++)
    {
        if (dataArr[index].trayjobid == trayjobid)
        {
            dataArr.removeItemAt(index);
            break;
        }
    }
}


/**
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
public function faultHandler(e:FaultEvent):void{
	Alert.show("An unexpected error occurred and has been logged.");
}

/**
 * Click handler when the user click the "Create" button
 * Load the "Update" canvas.
 */
public function goToUpdate():void{
	applicationScreens.selectedChild = update;
}

/**
 * Load the "View" canvas.
 */
public function goToView():void {
    applicationScreens.selectedChild = view;
}

public function goToEdit():void {
    applicationScreens.selectedChild = edit;
}

public function goToDup():void {
	parentApplication.fromjobID = dataGrid.selectedItem.trayjobid;
    applicationScreens.selectedChild = duplicate;
}

public function newclearAll():void {
	jobnameCol.text = "";
	stylenameCol.text = "";
	qtyCol.value = 1;
	traymoldnameCol.text = "";
	trayidCol.text = "";
}

public function editclearAll():void {
	editjobnameCol.text = "";
	editstylenameCol.text = "";
	editqtyCol.value = 1;
	edittraymoldnameCol.text = "";
	edittrayidCol.text = "";
}

public function dupclearAll():void {
	dupjobnameCol.text = "";
	dupstylenameCol.text = "";
	dupqtyCol.value = 1;
	duptraymoldnameCol.text = "";
	duptrayidCol.text = "";
}

private function showUnActiveJobs():void {       
   	var showActivatePanel:activatePanel=activatePanel(PopUpManager.createPopUp( this, activatePanel , true));
	PopUpManager.centerPopUp(showActivatePanel);
}
