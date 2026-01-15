package foodActivity
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import foodActivity.event.FoodActivityEvent;
   import foodActivity.view.FoodActivityEnterIcon;
   import foodActivity.view.FoodActivityFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   
   public class FoodActivityManager
   {
      
      private static var _instance:FoodActivityManager;
      
      private var _info:GmActivityInfo;
      
      private var _frame:FoodActivityFrame;
      
      public var _isStart:Boolean;
      
      public var ripeNum:int;
      
      public var cookingCount:int;
      
      public var state:int;
      
      public var currentSumTime:int;
      
      public var delayTime:int;
      
      private var _timer:Timer;
      
      public var sumTime:int;
      
      private var _actId:String;
      
      private var _foodActivityEnterIcon:FoodActivityEnterIcon;
      
      public function FoodActivityManager()
      {
         super();
      }
      
      public static function get Instance() : FoodActivityManager
      {
         if(_instance == null)
         {
            _instance = new FoodActivityManager();
         }
         return _instance;
      }
      
      public function setUp() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOOD_ACTIVITY,this.pkgHandler);
      }
      
      protected function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case FoodActivityEvent.ACTIVITY_STATE:
               this.openOrCloseHandler(pkg);
               break;
            case FoodActivityEvent.UPDATE_COUNT:
               this.updateCookingCount(pkg);
               break;
            case FoodActivityEvent.SIMPLE_COOKING:
               this.cookingHanlder(pkg);
               break;
            case FoodActivityEvent.PAY_COOKING:
               this.cookingHanlder(pkg);
               break;
            case FoodActivityEvent.REWARD:
               this.rewardHandler(pkg);
               break;
            case FoodActivityEvent.CLEAN_DATA:
               this.cleanDataHandler(pkg);
         }
      }
      
      private function cleanDataHandler(pkg:PackageIn) : void
      {
         this.sumTime = this.currentSumTime = this.cookingCount = this.ripeNum = 0;
         this.updateView();
         if(!this._info)
         {
            return;
         }
         if(this.info.activityChildType == 0)
         {
            this.startTime();
         }
      }
      
      private function rewardHandler(pkg:PackageIn) : void
      {
         var isSuccess:Boolean = pkg.readBoolean();
         this.ripeNum = pkg.readInt();
         if(isSuccess)
         {
            if(Boolean(this._frame))
            {
               this._frame.updateBoxMc();
            }
            if(this.info.activityChildType == 0)
            {
               SocketManager.Instance.out.updateCookingCountByTime();
            }
         }
         else if(Boolean(this._frame))
         {
            this._frame.failRewardUpdate();
         }
      }
      
      private function cookingHanlder(pkg:PackageIn) : void
      {
         this.cookingCount = pkg.readInt();
         this.ripeNum = pkg.readInt();
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.text = "" + this.cookingCount;
         }
         if(Boolean(this._frame))
         {
            this._frame.updateProgress();
         }
      }
      
      private function updateCookingCount(pkg:PackageIn) : void
      {
         this.cookingCount = pkg.readInt();
         this.currentSumTime = pkg.readInt();
         this.delayTime = pkg.readInt();
         if(!this._info)
         {
            return;
         }
         if(this.info.activityChildType == 0)
         {
            if(this.cookingCount == 0)
            {
               this.startTime(true);
            }
            else
            {
               this.endTime();
            }
         }
         this.updateView();
      }
      
      private function openOrCloseHandler(pkg:PackageIn) : void
      {
         this._actId = pkg.readUTF();
         this._isStart = pkg.readBoolean();
         this.cookingCount = pkg.readInt();
         this.ripeNum = pkg.readInt();
         this.state = pkg.readInt();
         this.currentSumTime = pkg.readInt();
         if(this._isStart)
         {
            this.initData();
            if(Boolean(this._info))
            {
               this.initBtn(this._isStart);
               HallIconManager.instance.updateSwitchHandler(HallIconType.FOODACTIVITY,this._isStart);
            }
         }
         else
         {
            this.info = null;
            this.sumTime = 0;
            if(Boolean(this._timer))
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
               this._timer = null;
            }
            this.deleteBtn();
            this.disposeFrame();
         }
      }
      
      public function checkOpen() : void
      {
         this.initData();
         if(Boolean(this._info))
         {
            this.initBtn(this._isStart);
         }
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         var now:Date = TimeManager.Instance.Now();
         var activityData:Dictionary = WonderfulActivityManager.Instance.activityData;
         for each(item in activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.FOOD_ACTIVITYS && (item.activityChildType == WonderfulActivityTypeData.FOOD_ONLINETIME || item.activityChildType == WonderfulActivityTypeData.FOOD_ACTIVITY) && now.time >= Date.parse(item.beginTime) && now.time <= Date.parse(item.endShowTime))
            {
               this._info = Boolean(activityData[this._actId]) ? activityData[this._actId] : null;
               break;
            }
         }
      }
      
      public function initBtn(flag:Boolean) : void
      {
         if(!this._foodActivityEnterIcon)
         {
            this._foodActivityEnterIcon = new FoodActivityEnterIcon();
         }
         if(Boolean(this.info) && this.info.activityChildType == 0)
         {
            this._foodActivityEnterIcon.showTxt();
         }
      }
      
      public function startTime(isUpdateCount:Boolean = false) : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.startTime(isUpdateCount);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
            this._timer = null;
         }
         this._timer = new Timer(1000,this.sumTime);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timer.start();
      }
      
      public function endTime() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.endTime();
         }
      }
      
      public function stopTime() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         --this.sumTime;
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.updateTime();
         }
         if(FoodActivityManager.Instance.sumTime == 0)
         {
            this.stopTime();
            SocketManager.Instance.out.updateCookingCountByTime();
         }
      }
      
      public function deleteBtn() : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.FOODACTIVITY,this._isStart);
            ObjectUtils.disposeObject(this._foodActivityEnterIcon);
            this._foodActivityEnterIcon = null;
         }
      }
      
      public function openFrame() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FOOD_ACTIVITY);
      }
      
      protected function _loaderCompleteHandle(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.FOOD_ACTIVITY)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
            UIModuleSmallLoading.Instance.hide();
            this._frame = ComponentFactory.Instance.creatCustomObject("foodActivity.frame");
            this._frame.titleText = LanguageMgr.GetTranslation("foodActivity.frame.title");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function _loaderErrorHandle(event:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loaderProgressHandle(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      protected function _loadingCloseHandle(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public function get info() : GmActivityInfo
      {
         return this._info;
      }
      
      public function set info(value:GmActivityInfo) : void
      {
         this._info = value;
      }
      
      public function get isStart() : Boolean
      {
         return this._isStart;
      }
      
      public function disposeFrame() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.dispose();
         }
         this._frame = null;
      }
      
      public function get foodActivityIcon() : FoodActivityEnterIcon
      {
         return this._foodActivityEnterIcon;
      }
   }
}

