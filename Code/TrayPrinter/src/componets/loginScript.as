/**
 * ActionScript source file that defines the UI logic and some of the data access code.
 * This file is linked into the main application MXML file using the mx:Script tag.
 * Most of the functions in this file are called by event handlers defined in
 * the MXML.
 */
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
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
private var fields:Object = {'userName':String, 'password':String};

/**
 * Executes when the mxml is completed loaded. Initialize the Rest Gateway.
 */
private function initApp():void {
/**
 * Validate userName and password 
 * Web Service will return the userRole for which Admin rights are granted
 */
 parentApplication.gateway.ValidateUser.addEventListener(ResultEvent.RESULT, validateUserHandler);
 parentApplication.gateway.addEventListener(FaultEvent.FAULT, faultHandler);
 focusManager.setFocus(inputUserName);
}

/**
 * Validate User Result
 * If userRole is admin then give rights 
 * Else return a user type
 */
public function validateUserHandler(e:ResultEvent):void {	
	
	if(e.result.Tables.Table0.Rows.length == 0){
		loginError.text = 'Incorrect user name or password.'
		CursorManager.removeBusyCursor();
		return;
	}
	
	else if(e.result.Tables.Table0.Rows.length != 0){
	    var table:ArrayCollection = e.result.Tables.Table0.Rows;
	    var myUserRole:Object = table.getItemAt(0);
	 	CursorManager.removeBusyCursor();
	 	
	    if(myUserRole.userRole == "admin") {
	    	//Set Admin Permessions
	    	parentApplication.myUserRole = myUserRole;
	    	this.dispatchEvent( new Event( Event.CLOSE ) );
	        PopUpManager.removePopUp(this);
	        return;
	    }
	    else if(myUserRole.userRole == "mod") {
	    	//Set User Permessions
	    	parentApplication.myUserRole = myUserRole;
	    	this.dispatchEvent( new Event( Event.CLOSE ) );
	    	PopUpManager.removePopUp(this);
	        return;
	    }
	    else if(myUserRole.userRole == "user") {
	    	//Set User Permessions
	    	parentApplication.myUserRole = myUserRole;
	    	this.dispatchEvent( new Event( Event.CLOSE ) );
	    	PopUpManager.removePopUp(this);
	        return;
	    }
	}
}


/**
 * Click handler for the "Save" button in the "Add" state
 * collects the information in the form and adds a new object to the collection
 */
private function ValidateUser():void {
	CursorManager.setBusyCursor();
	parentApplication.gateway.ValidateUser(inputUserName.text, inputPassword.text);
}

/**
 * fault handler for this connection
 *
 * @param e FaultEvent the error object
 */
private function faultHandler(e:FaultEvent):void {
	Alert.show(" An unexpected error occurred and has been logged.");
}