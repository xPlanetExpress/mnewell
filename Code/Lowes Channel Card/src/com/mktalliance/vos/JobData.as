package com.mktalliance.vos
{
	
	[Bindable]
	public class JobData 
	{
		/*-.........................................Properties..........................................*/
		public var _jobType:int;
		public var _productName:String;
		public var _productNumber:String;
		public var _reorderNumber:String;
		public var _reorderNumber2:String;
		public var _vendorContact:String;
		public var _vendorEmail:String;
		public var _vendorTelephone:String;
		public var _instoreDate:Date;
		public var _numberofStore:int;
		public var _numberforArchway:int;
		public var _jobNotes:String;
		
		/*-.........................................Constructor..........................................*/
		public function JobData(jobType 	: int		=	2,
								productName : String 	=	"", 
								productNumber : String =	"",
								reorderNumber : String =    "",
								reorderNumber2 : String =    "",
								vendorContact : String =	"",
								vendorEmail : String 	=	"",
								vendorTelephone : String =	"",
								instoreDate : Date 	=	null,
								numberofStore : int 	= 	0,
								numberforArchway : int = 	0,
								jobNotes : String 		= 	"") 
		{
			this._jobType			= jobType;
			this._productName 		= productName;  
			this._productNumber 	= productNumber; 
			this._reorderNumber		= reorderNumber;
			this._reorderNumber2	= reorderNumber2;
			this._vendorContact 	= vendorContact;
			this._vendorEmail 		= vendorEmail;
			this._vendorTelephone 	= vendorTelephone;
			this._instoreDate 		= instoreDate;
			this._numberofStore 	= numberofStore;
			this._numberforArchway 	= numberforArchway;
			this._jobNotes 			= jobNotes;
		}
		
		/*-.........................................Methods..........................................*/
		
		/*public function saveJob(jobData:JobData):void 
		{
			this._productName 		= jobData._productName;  
			this._productNumber 	= jobData._productNumber; 
			this._vendorContact 	= jobData._vendorContact;
			this._vendorEmail 		= jobData._vendorEmail;
			this._vendorTelephone 	= jobData._vendorTelephone;
			this._instoreDate 		= jobData._instoreDate;
			this._numberofStore 	= jobData._numberofStore;
			this._numberforArchway 	= jobData._numberforArchway;
			this._jobNotes 			= jobData._jobNotes;
			
		}*/
		
		/*public function editJob(pjobData:JobData):void 
		{
			this._productName 		= pjobData._productName;  
			this._productNumber 	= pjobData._productNumber; 
			this._vendorContact 	= pjobData._vendorContact;
			this._vendorEmail 		= pjobData._vendorEmail;
			this._vendorTelephone 	= pjobData._vendorTelephone;
			this._instoreDate 		= pjobData._instoreDate;
			this._numberofStore 	= pjobData._numberofStore;
			this._numberforArchway 	= pjobData._numberforArchway;
			this._jobNotes 			= pjobData._jobNotes;
			
		}*/
	}
}