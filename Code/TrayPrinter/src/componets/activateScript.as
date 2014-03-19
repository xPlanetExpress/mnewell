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
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.WebService;
import mx.managers.PopUpManager;

/**
 * the array collection holds the rows that we use in the grid
 */
[Bindable]
private var dataArr:ArrayCollection = new ArrayCollection();

/**
 * column that we order by. This is updated each time the users clicks on the 
 * grid column header. 
 * see headerRelease="setOrder(event);" in the DataGrid instantiation in the 
 * mxml file
 */
private var orderColumn:Number;

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
private function initApp():void 
{	
    parentApplication.gateway.FindAllUnActiveJob.addEventListener(ResultEvent.RESULT, fillHandler);
    parentApplication.gateway.UpdateJob.addEventListener(ResultEvent.RESULT, saveItemHandler);
    parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
    fill();
}
/**
 * Click handler for "Filter" button.
 * When setting another filter, refresh the collection, and load the new data
 */
private function filterResults():void{
    fill();
}
/**
 * Click handler for "Activate" button.
 * Sets the jobs status to active
 */
private function updateJob():void {	
	parentApplication.gateway.UpdateJob(dataGrid.selectedItem.trayjobid, parentApplication.myCompany, dataGrid.selectedItem.jobname, dataGrid.selectedItem.trayid, dataGrid.selectedItem.stylename, dataGrid.selectedItem.status, 1, dataGrid.selectedItem.qty, dataGrid.selectedItem.lastupdatedby, dataGrid.selectedItem.createdby);
}
/**
 * Duplication routine to go from an unactive job to a active job
 * when finished the dupitemHandler needs to dup the color line as well
 */
private function dupItem():void {
	parentApplication.gateway.DupJob(parentApplication.myCompany, dataGrid.selectedItem.jobname, dataGrid.selectedItem.trayid, dataGrid.selectedItem.stylename, 0, 1, dataGrid.selectedItem.qty, dataGrid.selectedItem.lastupdatedby, dataGrid.selectedItem.createdby);
	parentApplication.fromjobID = dataGrid.selectedItem.trayjobid;
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
    //var myCompany:String = "ap";
	/*
    if (isNaN(filter)) {
    	filter = 0;
    }
	*/
	
	parentApplication.gateway.FindAllUnActiveJob(parentApplication.myCompany, filter, orderField, desc);
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

		var token:AsyncToken = parentApplication.gateway.RemoveJob(vo.trayjobid);
		token.trayjobid = vo.trayjobid;
		
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