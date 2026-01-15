package wonderfulActivity
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.ConsumeRankManager;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import foodActivity.FoodActivityManager;
   import road7th.comm.PackageIn;
   import shop.view.ShopPresentClearingFrame;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.CanGetData;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.event.WonderfulActivityEvent;
   import wonderfulActivity.items.JoinIsPowerView;
   import wonderfulActivity.limitActivity.LimitActivityFrame;
   import wonderfulActivity.limitActivity.SendGiftActivityFrame;
   import wonderfulActivity.newActivity.returnActivity.ReturnActivityView;
   
   public class WonderfulActivityManager extends EventDispatcher
   {
      
      private static var _instance:WonderfulActivityManager;
      
      public static const UPDATE_MOUNT_MASTER:String = "updateMountMaster";
      
      public static var isFirstClick:Boolean = true;
      
      public var activityData:Dictionary;
      
      public var activityInitData:Dictionary;
      
      public var leftViewInfoDic:Dictionary;
      
      public var currentView:*;
      
      private var _frame:LimitActivityFrame;
      
      private var _sendGiftFrame:SendGiftActivityFrame;
      
      private var _info:GmActivityInfo;
      
      private var _actList:Array;
      
      public var activityTypeList:Vector.<ActivityTypeData>;
      
      public var activityFighterList:Vector.<ActivityTypeData>;
      
      public var activityExpList:Vector.<ActivityTypeData>;
      
      public var activityRechargeList:Vector.<ActivityTypeData>;
      
      public var chickenEndTime:Date;
      
      public var rouleEndTime:Date;
      
      private var _timerHanderFun:Dictionary;
      
      private var _timer:Timer;
      
      public var xiaoFeiScore:int;
      
      public var chongZhiScore:int;
      
      public var _stateList:Vector.<CanGetData>;
      
      public var deleWAIcon:Function;
      
      public var addWAIcon:Function;
      
      public var hasActivity:Boolean = false;
      
      public var isRuning:Boolean = true;
      
      public var currView:String;
      
      public var frameCanClose:Boolean = true;
      
      public var clickWonderfulActView:Boolean;
      
      public var stateDic:Dictionary;
      
      public var isSkipFromHall:Boolean;
      
      public var skipType:String;
      
      public var leftUnitViewType:int;
      
      private var lastActList:Array = [];
      
      private var sendGiftIsOut:Boolean = false;
      
      private var firstShowSendGiftFrame:Boolean = true;
      
      private var _giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _battleCompanionInfo:InventoryItemInfo;
      
      private var _eventsActiveDic:Dictionary;
      
      public var selectId:String = "";
      
      public function WonderfulActivityManager()
      {
         super();
         this._actList = [];
         this._timerHanderFun = new Dictionary();
         this._stateList = new Vector.<CanGetData>();
         this.activityInitData = new Dictionary();
         this.leftViewInfoDic = new Dictionary();
         this.activityFighterList = new Vector.<ActivityTypeData>();
         this.activityExpList = new Vector.<ActivityTypeData>();
         this.activityRechargeList = new Vector.<ActivityTypeData>();
         this.stateDic = new Dictionary();
      }
      
      public static function get Instance() : WonderfulActivityManager
      {
         if(!_instance)
         {
            _instance = new WonderfulActivityManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initAdvIdName();
         this.addEvents();
         ConsumeRankManager.instance.setup();
      }
      
      private function initAdvIdName() : void
      {
         this.leftViewInfoDic[ActivityType.CHONGZHIHUIKUI] = new LeftViewInfoVo(ActivityType.CHONGZHIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt1"));
         this.leftViewInfoDic[ActivityType.XIAOFEIHUIKUI] = new LeftViewInfoVo(ActivityType.XIAOFEIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt2"));
         this.leftViewInfoDic[ActivityType.ZHANYOUCHONGZHIHUIKUI] = new LeftViewInfoVo(ActivityType.ZHANYOUCHONGZHIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt6"));
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WONDERFUL_ACTIVITY,this.rechargeReturnHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WONDERFUL_ACTIVITY_INIT,this.activityInitHandler);
      }
      
      private function activityInitHandler(event:CrazyTankSocketEvent) : void
      {
         var updateInfoType:int = 0;
         var pkg:PackageIn = event.pkg;
         updateInfoType = pkg.readInt();
         if(updateInfoType == 0)
         {
            this.updateNewActivityXml();
         }
         else if(updateInfoType == 1)
         {
            this.activityInit(pkg);
            this.checkActivity();
            WonderfulActivityManager.Instance.initFrame(this.isSkipFromHall,this.skipType);
            SocketManager.Instance.out.updateConsumeRank();
            SocketManager.Instance.out.sendWonderfulActivity(0,-1);
            CalendarManager.getInstance().open(-1);
         }
         else if(updateInfoType == 2)
         {
            this.activityInit(pkg);
            this.checkActivity();
         }
         else if(updateInfoType == 3)
         {
            this.activityInit(pkg);
            this.checkActivity(updateInfoType);
         }
      }
      
      private function updateNewActivityXml() : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.loadWonderfulActivityXml();
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function activityInit(pkg:PackageIn) : void
      {
         var actID:String = null;
         var statusCount:int = 0;
         var statusArr:Array = null;
         var j:int = 0;
         var giftInfoCount:int = 0;
         var giftInfoDic:Dictionary = null;
         var k:int = 0;
         var playerStatus:PlayerCurInfo = null;
         var giftCurInfo:GiftCurInfo = null;
         var key:String = null;
         var actCount:int = pkg.readInt();
         for(var i:int = 0; i <= actCount - 1; i++)
         {
            actID = pkg.readUTF();
            statusCount = pkg.readInt();
            statusArr = [];
            for(j = 0; j <= statusCount - 1; j++)
            {
               playerStatus = new PlayerCurInfo();
               playerStatus.statusID = pkg.readInt();
               playerStatus.statusValue = pkg.readInt();
               statusArr.push(playerStatus);
            }
            giftInfoCount = pkg.readInt();
            giftInfoDic = new Dictionary();
            for(k = 0; k <= giftInfoCount - 1; k++)
            {
               giftCurInfo = new GiftCurInfo();
               key = pkg.readUTF();
               giftCurInfo.times = pkg.readInt();
               giftCurInfo.allGiftGetTimes = pkg.readInt();
               giftInfoDic[key] = giftCurInfo;
            }
            this.activityInitData[actID] = {
               "statusArr":statusArr,
               "giftInfoDic":giftInfoDic
            };
         }
         if(this.currentView is JoinIsPowerView || this.currentView is ReturnActivityView)
         {
            this.currentView.refresh();
         }
      }
      
      private function rechargeReturnHander(e:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var startTime:Date = null;
         var endTime:Date = null;
         var data:CanGetData = null;
         var i:int = 0;
         var activityType:int = 0;
         var nowDate:Date = null;
         var t:int = 0;
         var tt:int = 0;
         var type:int = e.pkg.readByte();
         if(type == 2)
         {
            if(StateManager.currentStateType == StateType.MAIN || Boolean(this._frame))
            {
               this.updateFirstRechargeXml();
            }
         }
         else if(type == 0)
         {
            count = e.pkg.readInt();
            for(i = 0; i < count; i++)
            {
               activityType = -1;
               data = new CanGetData();
               data.id = e.pkg.readInt();
               switch(data.id)
               {
                  case ActivityType.ZHANYOUCHONGZHIHUIKUI:
                     activityType = ActivityType.ZHANYOUCHONGZHIHUIKUI;
                     t = e.pkg.readInt();
                     break;
                  case ActivityType.CHONGZHIHUIKUI:
                     activityType = ActivityType.CHONGZHIHUIKUI;
                     this.chongZhiScore = e.pkg.readInt();
                     break;
                  case ActivityType.XIAOFEIHUIKUI:
                     activityType = ActivityType.XIAOFEIHUIKUI;
                     this.xiaoFeiScore = e.pkg.readInt();
                     break;
                  default:
                     tt = e.pkg.readInt();
               }
               data.num = e.pkg.readInt();
               startTime = e.pkg.readDate();
               endTime = e.pkg.readDate();
               this.setActivityTime(data.id,startTime,endTime);
               this.updateStateList(data);
               if(activityType != -1)
               {
                  nowDate = TimeManager.Instance.Now();
                  if(nowDate.getTime() > startTime.getTime() && nowDate.getTime() < endTime.getTime() && data.num != -2)
                  {
                     this.addElement(activityType);
                  }
                  else
                  {
                     this.removeElement(activityType);
                  }
               }
            }
            if(count == 1 && this._frame && Boolean(this._frame.parent))
            {
               if(Boolean(data))
               {
                  this._frame.setState(data.num,data.id);
               }
            }
         }
      }
      
      private function updateFirstRechargeXml() : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.firstRechargeLoader();
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function updateChargeActiveTemplateXml() : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.creatWondActiveLoader();
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function dispatchCheckEvent() : void
      {
         if(!this._frame && !this.clickWonderfulActView)
         {
            dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.CHECK_ACTIVITY_STATE));
         }
      }
      
      private function updateStateList(data:CanGetData) : void
      {
         var len:int = int(this._stateList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(data.id == this._stateList[i].id)
            {
               this._stateList[i] = data;
               return;
            }
         }
         this._stateList.push(data);
      }
      
      private function timerHander(event:TimerEvent) : void
      {
         var timerHander:Function = null;
         for each(timerHander in this._timerHanderFun)
         {
            timerHander();
         }
      }
      
      public function addTimerFun(key:String, fun:Function) : void
      {
         this._timerHanderFun[key] = fun;
         if(!this._timer)
         {
            this._timer = new Timer(1000);
            this._timer.start();
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         }
      }
      
      public function delTimerFun(key:String) : void
      {
         if(Boolean(this._timerHanderFun[key]))
         {
            delete this._timerHanderFun[key];
         }
         if(this.isEmptyDictionary(this._timerHanderFun))
         {
            if(Boolean(this._timer))
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
               this._timer = null;
            }
         }
      }
      
      private function isEmptyDictionary(dic:Dictionary) : Boolean
      {
         var str:String = null;
         for(str in dic)
         {
            if(Boolean(str))
            {
               return false;
            }
         }
         return true;
      }
      
      public function getTimeDiff(endDate:Date, nowDate:Date) : String
      {
         var d:uint = 0;
         var h:uint = 0;
         var m:uint = 0;
         var s:uint = 0;
         var diff:Number = Math.round((endDate.getTime() - nowDate.getTime()) / 1000);
         if(diff >= 0)
         {
            d = Math.floor(diff / 60 / 60 / 24);
            diff %= 60 * 60 * 24;
            h = Math.floor(diff / 60 / 60);
            diff %= 60 * 60;
            m = Math.floor(diff / 60);
            s = diff % 60;
            if(d > 0)
            {
               return d + LanguageMgr.GetTranslation("wonderfulActivityManager.d");
            }
            if(h > 0)
            {
               return this.fixZero(h) + LanguageMgr.GetTranslation("wonderfulActivityManager.h");
            }
            if(m > 0)
            {
               return this.fixZero(m) + LanguageMgr.GetTranslation("wonderfulActivityManager.m");
            }
            if(s > 0)
            {
               return this.fixZero(s) + LanguageMgr.GetTranslation("wonderfulActivityManager.s");
            }
         }
         return "0";
      }
      
      private function fixZero(num:uint) : String
      {
         return num < 10 ? String(num) : String(num);
      }
      
      private function setActivityTime(id:int, start:Date, end:Date) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(id == ActivityType.ZHANYOUCHONGZHIHUIKUI)
         {
            if(this.activityFighterList.length == 0)
            {
               return;
            }
            this.activityFighterList[0].StartTime = start;
            this.activityFighterList[0].EndTime = end;
         }
         else if(id >= ActivityType.CHONGZHIHUIKUI && id < ActivityType.XIAOFEIHUIKUI)
         {
            if(this.activityRechargeList.length == 0)
            {
               return;
            }
            i = 0;
            while(true)
            {
               if(i < this.activityRechargeList.length)
               {
                  if(id != this.activityRechargeList[i].ID)
                  {
                     continue;
                  }
                  this.activityRechargeList[i].StartTime = start;
                  this.activityRechargeList[i].EndTime = end;
               }
               i++;
            }
         }
         else if(id >= ActivityType.XIAOFEIHUIKUI)
         {
            if(this.activityExpList.length == 0)
            {
               return;
            }
            for(j = 0; j < this.activityExpList.length; j++)
            {
               if(id == this.activityExpList[i].ID)
               {
                  this.activityExpList[i].StartTime = start;
                  this.activityExpList[i].EndTime = end;
                  break;
               }
            }
         }
      }
      
      public function wonderfulGMActiveInfo(analyer:WonderfulGMActAnalyer) : void
      {
         this.activityData = analyer.ActivityData;
         FoodActivityManager.Instance.checkOpen();
         SocketManager.Instance.out.updateConsumeRank();
      }
      
      public function wonderfulActiveType(analy:WonderfulActAnalyer) : void
      {
         this.activityFighterList = new Vector.<ActivityTypeData>();
         this.activityExpList = new Vector.<ActivityTypeData>();
         this.activityRechargeList = new Vector.<ActivityTypeData>();
         this.activityTypeList = analy.itemList;
         var len:int = int(this.activityTypeList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.activityTypeList[i].StartTime = new Date();
            this.activityTypeList[i].EndTime = new Date();
            if(this.activityTypeList[i].ID == ActivityType.ZHANYOUCHONGZHIHUIKUI)
            {
               this.activityFighterList.push(this.activityTypeList[i]);
            }
            else if(this.activityTypeList[i].ID >= ActivityType.CHONGZHIHUIKUI && this.activityTypeList[i].ID < ActivityType.XIAOFEIHUIKUI)
            {
               this.activityRechargeList.push(this.activityTypeList[i]);
            }
            else
            {
               this.activityExpList.push(this.activityTypeList[i]);
            }
         }
         SocketManager.Instance.out.sendWonderfulActivity(0,-1);
      }
      
      public function initFrame(SkipFromHall:Boolean = false, type:String = "0") : void
      {
         this.isSkipFromHall = SkipFromHall;
         this.skipType = type;
         this.leftUnitViewType = Boolean(this.leftViewInfoDic[this.skipType]) ? int(this.leftViewInfoDic[this.skipType].unitIndex) : 2;
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_CALENDAR);
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._frame.addElement(this.actList);
         }
      }
      
      public function addElement(activityID:*, pop:Boolean = false) : void
      {
         activityID = String(activityID);
         if(this._actList.indexOf(activityID) == -1 && pop)
         {
            this._actList.push(activityID);
         }
         if(this._actList.indexOf(activityID) == -1)
         {
            this._actList.unshift(activityID);
         }
         if(this._actList.length > 0)
         {
            if(this.addWAIcon != null)
            {
               this.addWAIcon();
            }
         }
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.addElement(this.actList);
         }
      }
      
      public function removeElement(activityID:*) : void
      {
         activityID = String(activityID);
         var index:int = int(this._actList.indexOf(activityID));
         if(index == -1)
         {
            return;
         }
         this._actList.splice(index,1);
         if(this._actList.length == 0)
         {
            this.dispose();
            return;
         }
         if(this._actList.length > 0)
         {
            if(this.currView == activityID)
            {
               this.currView = this._actList[0];
            }
         }
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.addElement(this.actList);
         }
      }
      
      public function dispose() : void
      {
         if(!this.isRuning)
         {
            return;
         }
         this.clickWonderfulActView = false;
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         this.currentView = null;
         this.isSkipFromHall = false;
         this.skipType = "0";
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._timer = null;
         }
         if(this._actList.length == 0)
         {
            if(this.deleWAIcon != null)
            {
               this.deleWAIcon();
            }
         }
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WONDERFULACTIVI)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function createActivityFrame(event:UIModuleEvent) : void
      {
         var loader:BaseLoader = null;
         if(event.module != UIModuleTypes.WONDERFULACTIVI)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         if(Boolean(WonderfulActivityManager.Instance.activityTypeList))
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._frame.addElement(this.actList);
         }
         else
         {
            loader = LoaderCreate.Instance.creatWondActiveLoader();
            loader.addEventListener(Event.COMPLETE,this.__dataLoaderCompleteHandler);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function __dataLoaderCompleteHandler(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__dataLoaderCompleteHandler);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._frame.addElement(this.actList);
      }
      
      private function checkActivity(_type:int = 0) : void
      {
         var item:GmActivityInfo = null;
         var index:int = 0;
         var i:int = 0;
         var type:String = null;
         var temp:int = 0;
         var isHeroExist:Boolean = false;
         var leftViewInfo:LeftViewInfoVo = null;
         var isRookieExist:Boolean = false;
         var leftViewInfoVo:LeftViewInfoVo = null;
         var isGiftExist:Boolean = false;
         var viewInfoVo:LeftViewInfoVo = null;
         if(this.activityData == null)
         {
            return;
         }
         var tmpArr:Array = [];
         var now:Date = TimeManager.Instance.Now();
         this.checkActState2();
         for each(item in this.activityData)
         {
            if(now.time < Date.parse(item.beginTime) || now.time > Date.parse(item.endShowTime))
            {
               continue;
            }
            switch(item.activityType)
            {
               case WonderfulActivityTypeData.MAIN_PAY_ACTIVITY:
                  switch(item.activityChildType)
                  {
                     case WonderfulActivityTypeData.FIRST_CONTACT:
                        break;
                     case WonderfulActivityTypeData.ACC_FIRST_PAY:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.ONE_OFF_PAY:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.ACCUMULATIVE_PAY:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACCUMULATIVE_PAY,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.NEWGAMEBENIFIT:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.NEWGAMEBENIFIT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.PAY_RETURN:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.PAY_RETURN,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.ONE_OFF_IN_TIME:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MAIN_CONSUME_ACTIVITY:
                  switch(item.activityChildType)
                  {
                     case WonderfulActivityTypeData.ONE_OFF_CONSUME:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.CONSUME_RETURN:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.CONSUME_RETURN,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                        break;
                     case WonderfulActivityTypeData.SPECIFIC_COUNT_CONSUME:
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                        tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MAIN_FAMOUS_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.HERO_POWER || item.activityChildType == WonderfulActivityTypeData.HERO_GRADE)
                  {
                     for each(leftViewInfo in this.leftViewInfoDic)
                     {
                        if(leftViewInfo.viewType == ActivityType.HERO)
                        {
                           isHeroExist = true;
                           break;
                        }
                     }
                     if(!isHeroExist)
                     {
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.HERO,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                     }
                     if(tmpArr.indexOf(item.activityId) == -1)
                     {
                        tmpArr.push(item.activityId);
                     }
                  }
                  break;
               case WonderfulActivityTypeData.CONSORTION_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.TUANJIE_POWER)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.TUANJIE_POWER,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.STRENGTHEN_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.STRENGTHEN_DAREN)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.STRENGTHEN_DAREN,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.EXCHANGE_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.NORMAL_EXCHANGE)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.NORMAL_EXCHANGE,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MARRY_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.HOLD_WEDDING)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.RECEIVE_ACTIVITY:
                  if(item.activityChildType == WonderfulActivityTypeData.USER_ID_RECEIVE || item.activityChildType == WonderfulActivityTypeData.DAILY_RECEIVE)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.RECEIVE_ACTIVITY,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  else if(item.activityChildType == WonderfulActivityTypeData.SEND_GIFT)
                  {
                     this._info = item;
                     if(this._sendGiftFrame && this.activityInitData[this._info.activityId] && this.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagArray[0].giftbagId].times != 0 && this._sendGiftFrame.nowId == this._info.activityId)
                     {
                        this._sendGiftFrame.setBtnFalse();
                     }
                     if(_type != 3)
                     {
                        continue;
                     }
                     if(PlayerManager.Instance.Self.Grade > 2 && !this.sendGiftIsOut && this.activityInitData[this._info.activityId] && this.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagArray[0].giftbagId].times == 0 && !this._sendGiftFrame)
                     {
                        this._sendGiftFrame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.sendGiftFrame");
                        this._sendGiftFrame.setData(this._info);
                        this.sendGiftIsOut = true;
                     }
                  }
                  break;
               case WonderfulActivityTypeData.CARNIVAL_ACTIVITY:
                  switch(item.activityChildType)
                  {
                     case WonderfulActivityTypeData.CARNIVAL_GRADE:
                        temp = ActivityType.CARNIVAL_GRADE;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_STRENGTH:
                        temp = ActivityType.CARNIVAL_STRENGTH;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_FUSION:
                        temp = ActivityType.CARNIVAL_FUSION;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE:
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE + 8:
                        for each(leftViewInfoVo in this.leftViewInfoDic)
                        {
                           if(leftViewInfoVo.viewType == ActivityType.CARNIVAL_ROOKIE)
                           {
                              isRookieExist = true;
                              break;
                           }
                        }
                        if(!isRookieExist)
                        {
                           temp = ActivityType.CARNIVAL_ROOKIE;
                        }
                        else
                        {
                           temp = 0;
                        }
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_BEAD:
                        temp = ActivityType.CARNIVAL_BEAD;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_TOTEM:
                        temp = ActivityType.CARNIVAL_TOTEM;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_PRACTICE:
                        temp = ActivityType.CARNIVAL_PRACTICE;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_CARD:
                        temp = ActivityType.CARNIVAL_CARD;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ZHANHUN:
                        temp = ActivityType.CARNIVAL_ZHANHUN;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_MOUNT_LEVEL:
                        temp = ActivityType.CARNIVAL_MOUNT_MASTER;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_PET:
                        temp = ActivityType.CARNIVAL_PET;
                  }
                  if(temp != 0)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(temp,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                  }
                  if(tmpArr.indexOf(item.activityId) == -1)
                  {
                     tmpArr.push(item.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MOUNT_MASTER:
                  if(item.activityChildType == WonderfulActivityTypeData.MOUNT_LEVEL)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.MOUNT_MASTER_LEVEL,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  else if(item.activityChildType == WonderfulActivityTypeData.MOUNT_SKILL)
                  {
                     this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.MOUNT_MASTER_SKILL,"· " + item.activityName,item.icon);
                     this.addElement(item.activityId);
                     tmpArr.push(item.activityId);
                  }
                  dispatchEvent(new Event(UPDATE_MOUNT_MASTER));
                  break;
               case WonderfulActivityTypeData.WHOLEPEOPLE_VIP:
                  this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.WHOLEPEOPLE_VIP,"· " + item.activityName,item.icon);
                  this.addElement(item.activityId);
                  tmpArr.push(item.activityId);
                  break;
               case WonderfulActivityTypeData.WHOLEPEOPLE_PET:
                  this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.WHOLEPEOPLE_PET,"· " + item.activityName,item.icon);
                  this.addElement(item.activityId);
                  tmpArr.push(item.activityId);
                  break;
               case WonderfulActivityTypeData.DAILY_GIFT:
                  if(item.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_BEAD || item.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_CARD || item.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_PLANT || item.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_STONE || item.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_USE)
                  {
                     for each(viewInfoVo in this.leftViewInfoDic)
                     {
                        if(viewInfoVo.viewType == ActivityType.DAILY_GIFT)
                        {
                           isGiftExist = true;
                           break;
                        }
                     }
                     if(!isGiftExist)
                     {
                        this.leftViewInfoDic[item.activityId] = new LeftViewInfoVo(ActivityType.DAILY_GIFT,"· " + item.activityName,item.icon);
                        this.addElement(item.activityId);
                     }
                     if(tmpArr.indexOf(item.activityId) == -1)
                     {
                        tmpArr.push(item.activityId);
                     }
                  }
                  break;
            }
         }
         index = -1;
         for(i = 0; i <= tmpArr.length - 1; i++)
         {
            index = int(this.lastActList.indexOf(tmpArr[i]));
            if(index >= 0)
            {
               this.lastActList.splice(index,1);
            }
         }
         for each(type in this.lastActList)
         {
            this.removeElement(type);
         }
         this.lastActList = tmpArr;
         this.checkActState();
      }
      
      public function checkShowSendGiftFrame() : void
      {
         if(this.sendGiftIsOut && this.firstShowSendGiftFrame)
         {
            this.firstShowSendGiftFrame = false;
            LayerManager.Instance.addToLayer(this._sendGiftFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function getActIdWithViewId(viewId:int) : String
      {
         var key:String = null;
         var leftViewInfo:LeftViewInfoVo = null;
         for(key in this.leftViewInfoDic)
         {
            leftViewInfo = this.leftViewInfoDic[key];
            if(leftViewInfo.viewType == viewId)
            {
               return key;
            }
         }
         return "";
      }
      
      private function checkActState() : void
      {
         var key:String = null;
         var leftViewInfo:LeftViewInfoVo = null;
         var giftInfoDic:Dictionary = null;
         var statusArr:Array = null;
         var item:GmActivityInfo = null;
         var nowTime:Number = NaN;
         var grade:int = 0;
         var currentGrade:int = 0;
         var reallyHorseGrade:int = 0;
         var horseSkillType:int = 0;
         var horseSkillGrade:int = 0;
         var giftInfo:GiftBagInfo = null;
         var alreadyGet:int = 0;
         var remain:int = 0;
         var info_mountGrade:PlayerCurInfo = null;
         var giftInfo_mountGrade:GiftBagInfo = null;
         var i_mountGrade:int = 0;
         var giftInfo_mountSkill:GiftBagInfo = null;
         var i_mountSkill:int = 0;
         var skillGrade:int = 0;
         var currentSkillGrade:int = 0;
         var info_mountSkill:PlayerCurInfo = null;
         for(key in this.leftViewInfoDic)
         {
            this.stateDic[this.leftViewInfoDic[key].viewType] = false;
            if(!this.activityData[key] || !this.activityInitData[key])
            {
               continue;
            }
            leftViewInfo = this.leftViewInfoDic[key];
            giftInfoDic = this.activityInitData[key].giftInfoDic;
            statusArr = this.activityInitData[key].statusArr;
            item = this.activityData[key];
            nowTime = new Date().time;
            switch(leftViewInfo.viewType)
            {
               case ActivityType.PAY_RETURN:
               case ActivityType.CONSUME_RETURN:
                  for each(giftInfo in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo.giftbagId])
                     {
                        break;
                     }
                     alreadyGet = int(giftInfoDic[giftInfo.giftbagId].times);
                     if(giftInfo.giftConditionArr[2].conditionValue == 0)
                     {
                        remain = int(Math.floor(statusArr[0].statusValue / giftInfo.giftConditionArr[0].conditionValue)) - alreadyGet;
                        if(remain > 0)
                        {
                           this.stateDic[leftViewInfo.viewType] = true;
                           break;
                        }
                     }
                     else if(alreadyGet == 0 && Math.floor(statusArr[0].statusValue / giftInfo.giftConditionArr[0].conditionValue) > 0)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_LEVEL:
                  for each(info_mountGrade in statusArr)
                  {
                     if(info_mountGrade.statusID == 0)
                     {
                        grade = info_mountGrade.statusValue;
                     }
                     else if(info_mountGrade.statusID == 1)
                     {
                        currentGrade = info_mountGrade.statusValue;
                     }
                  }
                  for each(giftInfo_mountGrade in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo_mountGrade.giftbagId])
                     {
                        break;
                     }
                     for(i_mountGrade = 0; i_mountGrade < giftInfo_mountGrade.giftConditionArr.length; i_mountGrade++)
                     {
                        if(giftInfo_mountGrade.giftConditionArr[i_mountGrade].conditionIndex == 0)
                        {
                           reallyHorseGrade = giftInfo_mountGrade.giftConditionArr[i_mountGrade].remain1;
                           break;
                        }
                     }
                     if(nowTime >= Date.parse(item.beginShowTime) && nowTime <= Date.parse(item.endShowTime) && giftInfoDic[giftInfo_mountGrade.giftbagId].times == 0 && reallyHorseGrade > grade && reallyHorseGrade <= currentGrade)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_SKILL:
                  for each(giftInfo_mountSkill in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo_mountSkill.giftbagId])
                     {
                        break;
                     }
                     for(i_mountSkill = 0; i_mountSkill < giftInfo_mountSkill.giftConditionArr.length; i_mountSkill++)
                     {
                        if(giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionIndex == 0)
                        {
                           horseSkillType = giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionValue;
                           break;
                        }
                        horseSkillGrade = giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionValue;
                     }
                     for each(info_mountSkill in statusArr)
                     {
                        if(info_mountSkill.statusID == horseSkillType)
                        {
                           skillGrade = info_mountSkill.statusValue;
                        }
                        else if(info_mountSkill.statusID == 100 + horseSkillType)
                        {
                           currentSkillGrade = info_mountSkill.statusValue;
                        }
                     }
                     if(nowTime >= Date.parse(item.beginShowTime) && nowTime <= Date.parse(item.endShowTime) && giftInfoDic[giftInfo_mountSkill.giftbagId].times == 0 && horseSkillGrade > skillGrade && horseSkillGrade <= currentSkillGrade)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
            }
         }
         this.dispatchCheckEvent();
      }
      
      private function checkActState2() : void
      {
         var key:String = null;
         var leftViewInfo:LeftViewInfoVo = null;
         var giftInfoDic:Dictionary = null;
         var statusArr:Array = null;
         var item:GmActivityInfo = null;
         var nowTime:Number = NaN;
         var grade:int = 0;
         var currentGrade:int = 0;
         var reallyHorseGrade:int = 0;
         var horseSkillType:int = 0;
         var horseSkillGrade:int = 0;
         var giftInfo:GiftBagInfo = null;
         var alreadyGet:int = 0;
         var remain:int = 0;
         var info_mountGrade:PlayerCurInfo = null;
         var giftInfo_mountGrade:GiftBagInfo = null;
         var i_mountGrade:int = 0;
         var giftInfo_mountSkill:GiftBagInfo = null;
         var i_mountSkill:int = 0;
         var skillGrade:int = 0;
         var currentSkillGrade:int = 0;
         var info_mountSkill:PlayerCurInfo = null;
         for(key in this.leftViewInfoDic)
         {
            this.stateDic[this.leftViewInfoDic[key].viewType] = false;
            if(!this.activityData[key] || !this.activityInitData[key])
            {
               continue;
            }
            leftViewInfo = this.leftViewInfoDic[key];
            giftInfoDic = this.activityInitData[key].giftInfoDic;
            statusArr = this.activityInitData[key].statusArr;
            item = this.activityData[key];
            nowTime = new Date().time;
            switch(leftViewInfo.viewType)
            {
               case ActivityType.PAY_RETURN:
               case ActivityType.CONSUME_RETURN:
                  for each(giftInfo in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo.giftbagId])
                     {
                        break;
                     }
                     alreadyGet = int(giftInfoDic[giftInfo.giftbagId].times);
                     if(giftInfo.giftConditionArr[2].conditionValue == 0)
                     {
                        remain = int(Math.floor(statusArr[0].statusValue / giftInfo.giftConditionArr[0].conditionValue)) - alreadyGet;
                        if(remain > 0)
                        {
                           this.stateDic[leftViewInfo.viewType] = true;
                           break;
                        }
                     }
                     else if(alreadyGet == 0 && Math.floor(statusArr[0].statusValue / giftInfo.giftConditionArr[0].conditionValue) > 0)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_LEVEL:
                  for each(info_mountGrade in statusArr)
                  {
                     if(info_mountGrade.statusID == 0)
                     {
                        grade = info_mountGrade.statusValue;
                     }
                     else if(info_mountGrade.statusID == 1)
                     {
                        currentGrade = info_mountGrade.statusValue;
                     }
                  }
                  for each(giftInfo_mountGrade in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo_mountGrade.giftbagId])
                     {
                        break;
                     }
                     for(i_mountGrade = 0; i_mountGrade < giftInfo_mountGrade.giftConditionArr.length; i_mountGrade++)
                     {
                        if(giftInfo_mountGrade.giftConditionArr[i_mountGrade].conditionIndex == 0)
                        {
                           reallyHorseGrade = giftInfo_mountGrade.giftConditionArr[i_mountGrade].remain1;
                           break;
                        }
                     }
                     if(nowTime >= Date.parse(item.beginShowTime) && nowTime <= Date.parse(item.endShowTime) && giftInfoDic[giftInfo_mountGrade.giftbagId].times == 0 && reallyHorseGrade > grade && reallyHorseGrade <= currentGrade)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_SKILL:
                  for each(giftInfo_mountSkill in item.giftbagArray)
                  {
                     if(!giftInfoDic[giftInfo_mountSkill.giftbagId])
                     {
                        break;
                     }
                     for(i_mountSkill = 0; i_mountSkill < giftInfo_mountSkill.giftConditionArr.length; i_mountSkill++)
                     {
                        if(giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionIndex == 0)
                        {
                           horseSkillType = giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionValue;
                           break;
                        }
                        horseSkillGrade = giftInfo_mountSkill.giftConditionArr[i_mountSkill].conditionValue;
                     }
                     for each(info_mountSkill in statusArr)
                     {
                        if(info_mountSkill.statusID == horseSkillType)
                        {
                           skillGrade = info_mountSkill.statusValue;
                        }
                        else if(info_mountSkill.statusID == 100 + horseSkillType)
                        {
                           currentSkillGrade = info_mountSkill.statusValue;
                        }
                     }
                     if(nowTime >= Date.parse(item.beginShowTime) && nowTime <= Date.parse(item.endShowTime) && giftInfoDic[giftInfo_mountSkill.giftbagId].times == 0 && horseSkillGrade > skillGrade && horseSkillGrade <= currentSkillGrade)
                     {
                        this.stateDic[leftViewInfo.viewType] = true;
                        break;
                     }
                  }
                  break;
            }
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      public function useBattleCompanion(info:InventoryItemInfo) : void
      {
         this._battleCompanionInfo = info;
         this._giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._giveFriendOpenFrame.nameInput.enable = false;
         this._giveFriendOpenFrame.onlyFriendSelectView();
         this._giveFriendOpenFrame.show();
         this._giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick,false,0,true);
         this._giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler2,false,0,true);
      }
      
      private function __responseHandler2(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.removeBattleCompanion();
            this._giveFriendOpenFrame = null;
         }
      }
      
      private function removeBattleCompanion() : void
      {
         if(Boolean(this._giveFriendOpenFrame) && Boolean(this._giveFriendOpenFrame.presentBtn))
         {
            this._giveFriendOpenFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         }
         if(Boolean(this._giveFriendOpenFrame))
         {
            this._giveFriendOpenFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler2);
         }
         this._battleCompanionInfo = null;
      }
      
      private function __presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var name:String = this._giveFriendOpenFrame.nameInput.text;
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         SocketManager.Instance.out.sendBattleCompanionGive(this._giveFriendOpenFrame.selectPlayerId,this._battleCompanionInfo.BagType,this._battleCompanionInfo.Place);
         this.removeBattleCompanion();
         ObjectUtils.disposeObject(this._giveFriendOpenFrame);
         this._giveFriendOpenFrame = null;
      }
      
      private function getTodayList() : Array
      {
         var info:ActiveEventsInfo = null;
         var arr:Array = [];
         var len:int = int(CalendarManager.getInstance().eventActives.length);
         var now:Date = TimeManager.Instance.Now();
         for(var i:int = 0; i < len; i++)
         {
            info = CalendarManager.getInstance().eventActives[i];
            if(now.time > info.start.time && now.time < info.end.time)
            {
               arr.push(info);
            }
         }
         return arr;
      }
      
      public function get eventsActiveDic() : Dictionary
      {
         return this._eventsActiveDic;
      }
      
      public function getActiveEventsInfoByID(id:int) : ActiveEventsInfo
      {
         return this._eventsActiveDic[id];
      }
      
      public function setLimitActivities(activities:Array) : void
      {
         var info:ActiveEventsInfo = null;
         var idStr:String = null;
         var tagId:int = 10000;
         this._eventsActiveDic = new Dictionary();
         var now:Date = TimeManager.Instance.Now();
         for each(info in activities)
         {
            if(now.time > info.start.time && now.time < info.end.time)
            {
               this._eventsActiveDic[tagId] = info;
               idStr = tagId.toString();
               this.leftViewInfoDic[idStr] = new LeftViewInfoVo(tagId,"· " + info.Title,1);
               if(info.HasKey != 1)
               {
                  this.addElement(idStr);
               }
               else
               {
                  this.addElement(idStr,true);
               }
               tagId++;
            }
         }
      }
      
      public function getActivityDataById(actId:String) : GmActivityInfo
      {
         return this.activityData[actId];
      }
      
      public function getActivityInitDataById(actId:String) : Object
      {
         return this.activityInitData[actId];
      }
      
      public function get frame() : LimitActivityFrame
      {
         return this._frame;
      }
      
      public function get sendFrame() : SendGiftActivityFrame
      {
         return this._sendGiftFrame;
      }
      
      public function get actList() : Array
      {
         return this._actList;
      }
   }
}

