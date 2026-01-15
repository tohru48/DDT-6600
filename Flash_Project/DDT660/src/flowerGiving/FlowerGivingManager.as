package flowerGiving
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flowerGiving.components.FlowerFallMc;
   import flowerGiving.events.FlowerGivingEvent;
   import flowerGiving.views.FlowerGivingFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   
   public class FlowerGivingManager extends EventDispatcher
   {
      
      private static var _instance:FlowerGivingManager;
      
      private var _frame:FlowerGivingFrame;
      
      private var flowerMc:FlowerFallMc;
      
      public var isShowIcon:Boolean;
      
      public var actId:String;
      
      public var xmlData:GmActivityInfo;
      
      private var delayTimer:Timer;
      
      public var flowerTempleteId:int;
      
      public function FlowerGivingManager()
      {
         super(null);
         this.addEvents();
      }
      
      public static function get instance() : FlowerGivingManager
      {
         if(!_instance)
         {
            _instance = new FlowerGivingManager();
         }
         return _instance;
      }
      
      public function addEvents() : void
      {
         SocketManager.Instance.addEventListener(FlowerGivingEvent.FLOWER_FALL,this.__flowerFallHandler);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.FLOWER_GIVING_OPEN,this.__flowerGivingOpenHandler);
      }
      
      public function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.FLOWER_FALL,this.__flowerFallHandler);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.FLOWER_GIVING_OPEN,this.__flowerGivingOpenHandler);
      }
      
      protected function __flowerGivingOpenHandler(event:FlowerGivingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var isOpen:int = pkg.readInt();
         this.checkOpen();
      }
      
      protected function __flowerFallHandler(event:FlowerGivingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var from:int = pkg.readInt();
         var to:int = pkg.readInt();
         var curState:String = StateManager.currentStateType;
         if(curState == StateType.MAIN || curState == StateType.ROOM_LIST || curState == StateType.CONSORTIA || curState == StateType.AUCTION || curState == StateType.FARM || curState == StateType.SHOP || curState == StateType.TOFFLIST || curState == StateType.DDTCHURCH_ROOM_LIST || curState == StateType.CONSORTIA_BATTLE_SCENE || curState == StateType.MATCH_ROOM || curState == StateType.DUNGEON_LIST || curState == StateType.DUNGEON_ROOM || curState == StateType.CHALLENGE_ROOM)
         {
            if(!this.flowerMc)
            {
               this.flowerMc = new FlowerFallMc();
               this.flowerMc.addEventListener(Event.COMPLETE,this.__flowerMcComplete);
               LayerManager.Instance.addToLayer(this.flowerMc,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
            }
            if(Boolean(this.delayTimer))
            {
               this.delayTimer.stop();
               this.delayTimer.removeEventListener(TimerEvent.TIMER,this.onDelayTimer);
               this.delayTimer = null;
            }
            this.delayTimer = new Timer(8000,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.onDelayTimer);
            this.delayTimer.start();
         }
      }
      
      protected function __flowerMcComplete(event:Event) : void
      {
         this.flowerMc.removeEventListener(Event.COMPLETE,this.__flowerMcComplete);
         this.flowerMc.dispose();
         this.flowerMc = null;
      }
      
      protected function onDelayTimer(event:TimerEvent) : void
      {
         this.delayTimer.stop();
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.onDelayTimer);
         this.delayTimer = null;
         if(Boolean(this.flowerMc))
         {
            this.flowerMc.isOver = true;
         }
      }
      
      public function checkOpen() : void
      {
         var item:GmActivityInfo = null;
         this.isShowIcon = false;
         var now:Date = TimeManager.Instance.Now();
         var activityData:Dictionary = WonderfulActivityManager.Instance.activityData;
         for each(item in activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.FLOWER_GIVING_ACTIVITY && now.time >= Date.parse(item.beginTime) && now.time <= Date.parse(item.endShowTime))
            {
               switch(item.activityChildType)
               {
                  case 0:
                     this.flowerTempleteId = 334128;
                     break;
                  case 1:
                     this.flowerTempleteId = 334129;
                     break;
                  case 2:
                     this.flowerTempleteId = 334130;
                     break;
                  case 3:
                     this.flowerTempleteId = 334133;
                     break;
                  case 4:
                     this.flowerTempleteId = 334134;
                     break;
                  case 5:
                     this.flowerTempleteId = 334132;
               }
               this.actId = item.activityId;
               this.xmlData = activityData[this.actId];
               this.isShowIcon = true;
            }
         }
         if(this.isShowIcon)
         {
            this.createFlowerIcon();
         }
         else
         {
            this.deleteFlowerIcon();
         }
      }
      
      public function getDataByRewardMark(mark:int) : Array
      {
         var item:GiftBagInfo = null;
         var dataArr:Array = new Array();
         for each(item in this.xmlData.giftbagArray)
         {
            if(item.rewardMark == mark)
            {
               dataArr.push(item);
            }
         }
         dataArr.sortOn("giftbagOrder",Array.NUMERIC);
         return dataArr;
      }
      
      public function createFlowerIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.FLOWERGIVING,true);
      }
      
      public function deleteFlowerIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.FLOWERGIVING,false);
      }
      
      public function onIconClick(event:MouseEvent) : void
      {
         this.onShow();
      }
      
      public function onShow() : void
      {
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFlowerGivingFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FLOWER_GIVING);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerGivingFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFlowerGivingFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.FLOWER_GIVING)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function createFlowerGivingFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.FLOWER_GIVING)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFlowerGivingFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerGivingFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

