package yyvip
{
	import com.pickgliss.events.UIModuleEvent;
	import com.pickgliss.loader.UIModuleLoader;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.container.HBox;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.data.UIModuleTypes;
	import ddt.manager.ItemManager;
	import ddt.view.UIModuleSmallLoading;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import road7th.data.DictionaryData;
	import yyvip.view.YYVipEntryBtn;
	import yyvip.view.YYVipMainFrame;
	
	public class YYVipManager extends EventDispatcher
	{
		
		public static var YY_VIP_TAG:int;
		
		public static var VIP_OPEN_URL:String;
		
		public static var YY_VIP_SHOW_OPEN_VIEW:int;
		
		private static var _instance:YYVipManager;
		
		public var award_id_list:Array;
		
		private var _awardList:DictionaryData;
		
		private var _entryBtn:YYVipEntryBtn;
		
		public function YYVipManager(target:IEventDispatcher = null)
		{
			var id:int = 0;
			award_id_list = [112315,112316,112317,112318,112319,112320,112321,112322];
			super(target);
			this._awardList = new DictionaryData();
			for each(id in this.award_id_list)
			{
				this._awardList.add(id,[]);
			}
		}
		
		public static function get isShowOpenView() : Boolean
		{
			return YY_VIP_SHOW_OPEN_VIEW == 1;
		}
		
		public static function get isShowEntryBtn() : Boolean
		{
			return YY_VIP_TAG == 1;
		}
		
		public static function get instance() : YYVipManager
		{
			if(_instance == null)
			{
				_instance = new YYVipManager();
			}
			return _instance;
		}
		
		public function get awardList() : DictionaryData
		{
			return this._awardList;
		}
		
		public function get openViewAwardList() : Vector.<Object>
		{
			var obj:Object = null;
			var tmp:Array = this._awardList[this.award_id_list[0]] as Array;
			var len:int = int(tmp.length);
			var tmpList:Vector.<Object> = new Vector.<Object>();
			for(var i:int = 0; i < len; i++)
			{
				obj = {};
				obj.itemInfo = ItemManager.Instance.getTemplateById(tmp[i].TemplateId);
				obj.itemCount = tmp[i].ItemCount;
				tmpList.push(obj);
			}
			return tmpList;
		}
		
		public function getDailyLevelVipAwardList(index:int) : Vector.<Object>
		{
			var obj:Object = null;
			var tmp:Array = this._awardList[this.award_id_list[index]] as Array;
			var len:int = int(tmp.length);
			var tmpList:Vector.<Object> = new Vector.<Object>();
			for(var i:int = 0; i < len; i++)
			{
				obj = {};
				obj.itemInfo = ItemManager.Instance.getTemplateById(tmp[i].TemplateId);
				obj.itemCount = tmp[i].ItemCount;
				tmpList.push(obj);
			}
			return tmpList;
		}
		
		public function get dailyViewYearAwardList() : Vector.<Object>
		{
			var obj:Object = null;
			var tmp:Array = this._awardList[this.award_id_list[7]] as Array;
			var len:int = int(tmp.length);
			var tmpList:Vector.<Object> = new Vector.<Object>();
			for(var i:int = 0; i < len; i++)
			{
				obj = {};
				obj.itemInfo = ItemManager.Instance.getTemplateById(tmp[i].TemplateId);
				obj.itemCount = tmp[i].ItemCount;
				tmpList.push(obj);
			}
			return tmpList;
		}
		
		public function gotoOpenUrl() : void
		{
			navigateToURL(new URLRequest(VIP_OPEN_URL));
		}
		
		public function loadResModule() : void
		{
			UIModuleSmallLoading.Instance.progress = 0;
			UIModuleSmallLoading.Instance.show();
			UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
			UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
			UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.YY_VIP);
		}
		
		private function onUimoduleLoadProgress(event:UIModuleEvent) : void
		{
			if(event.module == UIModuleTypes.YY_VIP)
			{
				UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
			}
		}
		
		private function loadCompleteHandler(event:UIModuleEvent) : void
		{
			var tmp:YYVipMainFrame = null;
			if(event.module == UIModuleTypes.YY_VIP)
			{
				UIModuleSmallLoading.Instance.hide();
				UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
				UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
				tmp = ComponentFactory.Instance.creatComponentByStylename("YYVipMainFrame");
				LayerManager.Instance.addToLayer(tmp,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
			}
		}
		
		public function createEntryBtn(hBox:HBox) : void
		{
			if(isShowEntryBtn)
			{
				this._entryBtn = new YYVipEntryBtn();
				hBox.addChild(this._entryBtn);
			}
		}
		
		public function disposeEntryBtn() : void
		{
			ObjectUtils.disposeObject(this._entryBtn);
			this._entryBtn = null;
		}
	}
}

