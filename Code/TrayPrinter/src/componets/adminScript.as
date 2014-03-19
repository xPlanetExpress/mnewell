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
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
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
private var fields:Object = {  'trayuserID':Number, 'fName':String, 'lName':String, 'userName':String, 'password':String, 'userEmail':String, 'userRole':String};

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
public function initApp():void 
{
    /**
     * set the event handler which prevents editing of the primary key
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, editCellHandler);

    /**
     * set the event handler which triggers the update actions - everytime an 
     * edit operation is finished
     */
    dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, editCellEnd);

    parentApplication.gateway.FindAllUser.addEventListener(ResultEvent.RESULT, fillHandler);
    parentApplication.gateway.InsertUser.addEventListener(ResultEvent.RESULT, insertItemHandler);
    //gateway.Update.addEventListener(ResultEvent.RESULT, saveItemHandler);
    parentApplication.gateway.RemoveUser.addEventListener(ResultEvent.RESULT, deleteHandler);
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
    if(e.dataField == "trayuserID")
    {
        e.preventDefault();
        return;
    }
}

/**
 * Click handler for "Filter" button.
 * When setting another filter, refresh the collection, and load the new data
 */
private function filterResults():void
{
    fill();
}

/**
 * Event handler triggered when the user finishes editing an entry
 * triggers an "update" server command
 */
private function editCellEnd(e:DataGridEvent):void
{
    var dsRowIndex:int = e.rowIndex;
    var dsFieldName:String = e.dataField;
    var dsColumnIndex:Number = e.columnIndex;

    var vo:* = dataArr[dsRowIndex];
    
    var col:DataGridColumn = dataGrid.columns[dsColumnIndex];
    var newvalue:String = dataGrid.itemEditorInstance[col.editorDataField];

	vo[dsFieldName] = newvalue;
	//gateway.Update(vo.trayuserID,        vo.fName,        vo.lName,        vo.userName,        vo.password,        vo.userEmail,        vo.userRole	);
}

/**
 * result handler for the "update" server command.
 * Just alert the error, or do nothing if it's ok - the data has already 
 * been updated in the grid
 */
private function saveItemHandler(e:ResultEvent):void
{
    fill();
}

/**
 * dragHeader handler for the datagrid. This handler is executed when the user 
 * clicks on a header column in the datagrid
 * updates the global orderColumn variable, refreshes the TableCollection
 * @param event DataGridEvent details about the column
 */
private function setOrder(event:DataGridEvent):void 
{
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
private function insertUser():void {
	parentApplication.gateway.InsertUser(fNameCol.text,		lNameCol.text,		userNameCol.text,		passwordCol.text,		userEmailCol.text,		userRoleCol.text	);
	fill();
}

/**
 * Result handler for the insert call.
 * Alert the error if it exists
 * if the call went through ok, return to the list, and refresh the data
 */
private function insertItemHandler(e:ResultEvent):void
{
    goToView();
    fill();
}

/** 
 * general utility function for refreshing the data 
 * gets the filtering and ordering, then dispatches a new server call
 *
 */
private function fill():void 
{
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
	parentApplication.gateway.FindAllUser(filter, orderField, desc);
}

/** 
 * result handler for the fill call. 
 * if it is an error, show it to the user, else refill the arraycollection with the new data
 *
 */
private function fillHandler(e:ResultEvent):void
{
	var table:* = e.result.Tables.Table0.Rows;
	dataArr = table;
	
    CursorManager.removeBusyCursor();
    dataGrid.enabled = true;
}

/**
 * Click handler for the "delete" button in the list
 * confirms the action and launches the deleteClickHandler function
 */
private function RemoveUser():void {
    
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
private function deleteClickHandler(event:CloseEvent):void {
    var indexForDelete:Number = dataGrid.selectedIndex.valueOf();
    var userForDelete:Number = dataGrid.selectedItem.trayuserid.valueOf();
    if (indexForDelete == -1) {
        return;    
    }
    if (event.detail == Alert.YES) {
        var vo:* = dataArr[indexForDelete];
		parentApplication.gateway.RemoveUser(userForDelete);
    }
}

public function deleteHandler(e:ResultEvent):void
{	
   	var trayuserID:Number = e.token.trayuserID;
    for (var index:Number = 0; index < dataArr.length; index++)
    {
        if (dataArr[index].trayuserID == trayuserID)
        {
            dataArr.removeItemAt(index);
            break;
        }  
    }
    fill();
}

/**
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
public function faultHandler(e:FaultEvent):void
{
	Alert.show(FaultEvent.FAULT+" An unexpected error occurred and has been logged.");
}

/**
 * Click handler when the user click the "Create" button
 * Load the "Update" canvas.
 */
public function goToUpdate():void
{
	applicationScreens.selectedChild = update;
}

/**
 * Load the "View" canvas.
 */
public function goToView():void
{
    applicationScreens.selectedChild = view;
}
