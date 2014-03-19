package com.mktalliance.business
{
	import com.mktalliance.events.*;
	import com.mktalliance.vos.EditData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
		
	public class EditManager extends EventDispatcher
	{
		/*-.........................................Properties..........................................*/		
		private var dispatcher:IEventDispatcher;
		
		[Bindable]
		public var _editData:EditData;
		
		/*-.........................................Constructor..........................................*/
		public function EditManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			_editData = new EditData();
		}
		
		/*-.........................................Methods..........................................*/
		
		public function setEditData(editData:EditData):void
		{
			_editData._editJob = editData._editJob;
			_editData._editTemplate = editData._editTemplate;
			_editData._editIcons = editData._editIcons;
		}
		
		public function getEditData():EditData
		{
			return _editData;
		}
		
	}
}