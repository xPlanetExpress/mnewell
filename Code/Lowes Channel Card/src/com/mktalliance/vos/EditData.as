package com.mktalliance.vos
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class EditData
	{
		/*-.........................................Properties..........................................*/
		public var _editJob:Object;
		public var _editTemplate:Object;
		public var _editIcons:Object;
		
		/*-.........................................Constructor..........................................*/
		public function EditData()
		{
			this._editJob = new Object();
			this._editTemplate = new Object();
			this._editIcons = new Object();
		}
		
		/*-.........................................Methods..........................................*/
	}
}