/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.rpc.events.ResultEvent;
import mx.managers.CursorManager;
import mx.utils.ObjectUtil;
import mx.rpc.soap.WebService;
import mx.rpc.events.FaultEvent;
import mx.rpc.AsyncToken;
import mx.rpc.soap.WebService;

/**
 * the array collection holds the rows that we use in the grid
 */
[Bindable]
public var dataArr:ArrayCollection = new ArrayCollection();

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
private var fields:Object = {  'traymoldid':Number, 'moldname':String, 'moldwidth':Number, 'moldheight':Number, 'moldacross':Number, 'molddown':Number, 'gwidth':Number, 'gdepth':Number, 'numberofholes':Number, 'swatchwidth':Number, 'swatchheight':Number, 'createdby':Number};

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
private function initApp():void {
	if(parentApplication.myUserRole.userRole == 'admin'){
		btnAddNew.visible = true;
		btnDelete.visible = true;
	}
	else if(parentApplication.myUserRole.userRole == 'mod'){
		btnAddNew.visible = true;
		btnDelete.visible = true;
	}	
 	
    /**
     * set the event handler which prevents editing of the primary key
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, editCellHandler);

    /**
     * set the event handler which triggers the update actions - everytime an 
     * edit operation is finished
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, editCellEnd);

    parentApplication.gateway.FindAllMold.addEventListener(ResultEvent.RESULT, fillHandler);
    parentApplication.gateway.UpdateMold.addEventListener(ResultEvent.RESULT, saveItemHandler);
    parentApplication.gateway.InsertMold.addEventListener(ResultEvent.RESULT, insertItemHandler);
    parentApplication.gateway.RemoveMold.addEventListener(ResultEvent.RESULT, deleteHandler);
    parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
    
    fill();
}

/**
 * Disallow editing of the primary key column.
 * @param e DataGridEvent contains details about the row and column of the grid 
 * where the user clicked
 */
private function editCellHandler(e:DataGridEvent):void
{
    /**
     * if the user clicked on the primary key column, stop editing
     */
    if(e.dataField == "traymoldid")
    {
        e.preventDefault();
        return;
    }
    else if(e.dataField == "moldacross")
    {
        e.preventDefault();
        return;
    }
    else if(e.dataField == "molddown")
    {
        e.preventDefault();
        return;
    }
    else if(e.dataField == "numberofholes")
    {
        e.preventDefault();
        return;
    }
    else if(e.dataField == "usercreated")
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
private function editCellEnd(e:DataGridEvent):void {
    var dsRowIndex:int = e.rowIndex;
    var dsFieldName:String = e.dataField;
    var dsColumnIndex:Number = e.columnIndex;

    var vo:* = dataArr[dsRowIndex];
    
    var col:DataGridColumn = dataGrid.columns[dsColumnIndex];
    var newvalue:String = dataGrid.itemEditorInstance[col.editorDataField];

	vo[dsFieldName] = newvalue;
	parentApplication.gateway.UpdateMold(vo.traymoldid, vo.moldname, vo.moldwidth, vo.moldheight, vo.moldacross, vo.molddown, vo.gwidth, vo.gdepth, vo.numberofholes, vo.swatchwidth, vo.swatchheight, vo.createdby);
}

/**
 * result handler for the "update" server command.
 * Just alert the error, or do nothing if it's ok - the data has already 
 * been updated in the gridg
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
	parentApplication.gateway.InsertMold(parentApplication.moldnameCol.text, parentApplication.moldwidthCol.value,	parentApplication.moldheightCol.value,	parentApplication.moldacrossCol.value,	parentApplication.molddownCol.value, parentApplication.gwidthCol.value,	parentApplication.gdepthCol.value,	parentApplication.numberofholesCol.value,	parentApplication.swatchwidthCol.value,	parentApplication.swatchheightCol.value,	parentApplication.myUserRole.trayuserid);
}

/**
 * Result handler for the insert call.
 * Alert the error if it exists
 * if the call went through ok, return to the list, and refresh the data
 */
private function insertItemHandler(e:ResultEvent):void{
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
	/*
    if (isNaN(filter)) {
    	filter = 0;
    }
	*/
	parentApplication.gateway.FindAllMold(filter, orderField, desc);
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
    
    if (dataGrid.selectedItem){
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
    if (event.detail == Alert.YES) {
        var vo:* = dataArr[indexForDelete];

		var token:AsyncToken = parentApplication.gateway.RemoveMold(vo.traymoldid);
		token.traymoldid = vo.traymoldid;
		
        setTimeout( function():void
        {
            dataGrid.destroyItemEditor();
        },
        1);
    }
}

public function deleteHandler(e:ResultEvent):void{
   	var traymoldid:Number = e.token.traymoldid;
    for (var index:Number = 0; index < dataArr.length; index++)
    {
        if (dataArr[index].traymoldid == traymoldid)
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
