package com.mktalliance.vos
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class TemplateData 
	{
		/*-.........................................Properties..........................................*/
		public var _templateType:Object;
		public var _templateSize:Object;
		public var _templateColor:Object;
		public var _showerOnly:Boolean;
		public var _hardWare:Boolean;
		
		/*-.........................................Constructor..........................................*/
		public function TemplateData()
			
		{
			this._templateType  = new Object();
			this._templateSize 	= new Object();  
			this._templateColor = new Object(); 
			this._showerOnly 	= false;
			this._hardWare 		= false;
		}
		
		/*-.........................................Methods..........................................*/
		
		
	}
}