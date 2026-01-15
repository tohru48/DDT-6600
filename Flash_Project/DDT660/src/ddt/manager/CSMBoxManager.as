package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.box.TimeBoxInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.CSMBoxView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import hall.HallStateView;
   import road7th.data.DictionaryData;
   
   public class CSMBoxManager extends EventDispatcher
   {
      
      private static var _instance:CSMBoxManager;
      
      public var CSMBoxList:DictionaryData;
      
      public var isShowBox:Boolean;
      
      private var _GSMBox:CSMBoxView;
      
      private var _awards:AwardsView;
      
      private var _timer:Timer;
      
      private var _currentLevel:int = 1;
      
      private var _currentNum:int;
      
      private var _remainTime:Number;
      
      private var _startTime:Number;
      
      private var _hall:HallStateView;
      
      private var _boxLoader:BaseLoader;
      
      public function CSMBoxManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : CSMBoxManager
      {
         if(_instance == null)
         {
            _instance = new CSMBoxManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_CSM_TIME_BOX,this._getGSMTimeBox);
      }
      
      private function showFrame() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_TIMEBOX);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_TIMEBOX)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_TIMEBOX)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.removeBox();
            if(!this._GSMBox)
            {
               this._GSMBox = new CSMBoxView();
               PositionUtils.setPos(this._GSMBox,"CSMBoxViewPos");
            }
            LayerManager.Instance.addToLayer(this._GSMBox,LayerManager.GAME_DYNAMIC_LAYER);
         }
      }
      
      private function _getGSMTimeBox(evt:CrazyTankSocketEvent) : void
      {
         this.isShowBox = true;
         this._currentLevel = evt.pkg.readInt();
         this._currentNum = evt.pkg.readInt();
         if(this._currentLevel < 9)
         {
            if(Boolean(this.CSMBoxList))
            {
               this.createBoxAndTimer();
            }
            else if(this._boxLoader == null)
            {
               this._boxLoader = LoaderCreate.Instance.creatUserBoxInfoLoader();
               this._boxLoader.addEventListener(LoaderEvent.COMPLETE,this.__onBoxLoaderComplete);
               LoaderManager.Instance.startLoad(this._boxLoader);
            }
         }
      }
      
      private function __onBoxLoaderComplete(evt:LoaderEvent) : void
      {
         BaseLoader(evt.currentTarget).removeEventListener(LoaderEvent.COMPLETE,this.__onBoxLoaderComplete);
         if(Boolean(this.CSMBoxList))
         {
            this.createBoxAndTimer();
         }
      }
      
      private function createBoxAndTimer() : void
      {
         var tempInfo:TimeBoxInfo = TimeBoxInfo(this.CSMBoxList[this._currentLevel].info);
         this._remainTime = tempInfo.Condition * 60 - this._currentNum;
         this._startTime = getTimer();
         this.showBox();
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__updateBoxTime);
            this._timer.start();
         }
      }
      
      public function showBox($hall:HallStateView = null) : void
      {
         if(Boolean($hall))
         {
            this._hall = $hall;
         }
         if(Boolean(this._hall) && this.isShowBox)
         {
            this.showFrame();
         }
      }
      
      public function removeBox() : void
      {
         if(Boolean(this._GSMBox))
         {
            ObjectUtils.disposeObject(this._GSMBox);
            this._GSMBox = null;
         }
      }
      
      public function showAwards(type:int = 0) : void
      {
         var goodListIds:Array = null;
         var goodList:Array = null;
         var i:int = 0;
         var tempId:int = 0;
         var tempItemList:Array = null;
         if(Boolean(this.CSMBoxList))
         {
            this._awards = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
            this._awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendGetAwards);
            this._awards.addEventListener(FrameEvent.RESPONSE,this.__awardsFrameEventHandler);
            this._awards.boxType = 0;
            goodListIds = this.CSMBoxList[this._currentLevel].goodListIds;
            goodList = new Array();
            for(i = 0; i < goodListIds.length; i++)
            {
               tempId = int(goodListIds[i]);
               tempItemList = BossBoxManager.instance.inventoryItemList[tempId];
               goodList = goodList.concat(tempItemList);
            }
            this._awards.goodsList = goodList;
            if(type == 0)
            {
               this._awards.setCheck();
            }
            LayerManager.Instance.addToLayer(this._awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __awardsFrameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
         }
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      private function __sendGetAwards(evt:Event) : void
      {
         SocketManager.Instance.out.sendGetCSMTimeBox();
         this.removeAwards();
         this.removeBox();
         this.removeTimer();
      }
      
      private function __updateBoxTime(evt:TimerEvent) : void
      {
         var tempNum:int = 0;
         var second:int = 0;
         if(Boolean(this._GSMBox))
         {
            tempNum = (getTimer() - this._startTime) / 1000;
            if(tempNum < this._remainTime)
            {
               second = this._remainTime - tempNum;
               this._GSMBox.showBox(0);
               this._GSMBox.updateTime(second);
            }
            else
            {
               this._GSMBox.showBox(1);
            }
         }
      }
      
      private function removeTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateBoxTime);
            this._timer.stop();
            this._timer = null;
         }
      }
      
      private function removeAwards() : void
      {
         if(Boolean(this._awards))
         {
            this._awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendGetAwards);
            this._awards.removeEventListener(FrameEvent.RESPONSE,this.__awardsFrameEventHandler);
            ObjectUtils.disposeObject(this._awards);
            this._awards = null;
         }
      }
   }
}

