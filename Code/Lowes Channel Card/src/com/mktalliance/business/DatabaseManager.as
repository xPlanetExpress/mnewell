package com.mktalliance.business
{
	import com.mktalliance.events.*;
	import com.mktalliance.vos.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	public class DatabaseManager extends EventDispatcher
	{
		/*-.........................................Properties..........................................*/		
		private var dispatcher:IEventDispatcher;
		
		
		/*Job Information*/
		[Bindable]
		public var _jobData:JobData;
		/*Template Information*/
		[Bindable]
		public var _templateData:TemplateData;
		/*Logo Selection*/
		[Bindable]
		public var _logoData:LogoData;
		/*Hole Configuration*/
		[Bindable]
		public var _holeData:HoleData;
		/*Feature Icons*/
		[Bindable]
		public var _iconData:IconData;
		
		/*-.........................................Constructor..........................................*/
		public function DatabaseManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			/*Set up the hooks for Data Model to VOS layer*/
			_jobData 		= new JobData();
			_templateData 	= new TemplateData();
			_logoData 		= new LogoData();
			_holeData 		= new HoleData();
			_iconData 		= new IconData();
		}
		
		/*-.........................................Methods..........................................*/
		
		public function saveDatabase(jobData:JobData, templateData:TemplateData, logoData:LogoData, holeData:HoleData, iconData:IconData):void
		{
			_jobData._productName = jobData._productName;
			_jobData._productNumber = jobData._productNumber;
			_jobData._reorderNumber = jobData._reorderNumber;
			_jobData._reorderNumber2 = jobData._reorderNumber2;
			_jobData._vendorContact = jobData._vendorContact;
			_jobData._vendorEmail = jobData._vendorEmail;
			_jobData._vendorTelephone = jobData._vendorTelephone;
			_jobData._instoreDate = jobData._instoreDate;
			_jobData._numberofStore = jobData._numberofStore;
			_jobData._numberforArchway = jobData._numberforArchway;
			_jobData._jobNotes = jobData._jobNotes;
			/*##################################################*/
			_templateData._templateType = templateData._templateType;
			_templateData._templateSize = templateData._templateSize;
			_templateData._templateColor = templateData._templateColor;
			_templateData._showerOnly = templateData._showerOnly;
			_templateData._hardWare = templateData._hardWare;
			/*##################################################*/
			_logoData._vendorLogo = logoData._vendorLogo;
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*Set Job Information Variables for Model*/
		public function setJobData(jobData:JobData):void	
		{
			_jobData._productName = jobData._productName;
			_jobData._productNumber = jobData._productNumber;
			_jobData._reorderNumber = jobData._reorderNumber;
			_jobData._vendorContact = jobData._vendorContact;
			_jobData._vendorEmail = jobData._vendorEmail;
			_jobData._vendorTelephone = jobData._vendorTelephone;
			_jobData._instoreDate = jobData._instoreDate;
			_jobData._numberofStore = jobData._numberofStore;
			_jobData._numberforArchway = jobData._numberforArchway;
			_jobData._jobNotes = jobData._jobNotes;
		}
		/*Get Job Information Variables for Model*/
		public function getJobData():JobData
		{
		 	return _jobData;
		}
		
		/*Set Template Information Variables for Model*/
		public function setTemplateData(templateData:TemplateData):void
		{
			_templateData._templateType = templateData._templateType;
			_templateData._templateSize = templateData._templateSize;
			_templateData._templateColor = templateData._templateColor;
			_templateData._showerOnly = templateData._showerOnly;
			_templateData._hardWare = templateData._hardWare;
		}
		/*Get Template Information Variables for Model*/
		public function getTemplateData():TemplateData
		{
			return _templateData;
		}
		
		/*Set Vendor Logo Variables for Model*/
		public function setLogoData(logoData:LogoData):void
		{
			_logoData._vendorLogo = logoData._vendorLogo;
		}
		/*Get Vendor Logo Variables for Model*/
		public function getLogoData():LogoData
		{
			return _logoData;
		}
		
		/*Set Hole Configuration Variables for Model*/
		public function setHoleData(holeData:HoleData):void
		{
			_holeData._holeConf = holeData._holeConf;
		}
		/*Get Hole Configuration Variables for Model*/
		public function getHoleData():HoleData
		{
			return _holeData;
		}
		
		/*Set Feature Icons Variables for Model*/
		public function setIconData(iconData:IconData):void
		{
			_iconData._selectedIcons = iconData._selectedIcons;
		}
		/*Get Feature Icons Variables for Model*/
		public function getIconData():IconData
		{
			return _iconData;
		}
	}
}