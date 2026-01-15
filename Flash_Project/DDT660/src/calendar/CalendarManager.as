package calendar
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.view.CalendarFrame;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AccountInfo;
   import ddt.data.DaylyGiveInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.ActiveEventsAnalyzer;
   import ddt.data.analyze.ActiveExchangeAnalyzer;
   import ddt.data.analyze.CalendarSignAnalyze;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.DatetimeHelper;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mainbutton.MainButtnController;
   import road7th.comm.PackageIn;
   
   public class CalendarManager extends EventDispatcher
   {
      
      private static var _isOK:Boolean;
      
      private static var _ins:CalendarManager;
      
      public static const PET_BTN_SHOW:String = "petBtnShow";
      
      private var _localVisible:Boolean = false;
      
      private var _model:CalendarModel;
      
      private var _today:Date;
      
      private var _signCount:int;
      
      private var _dayLogDic:Dictionary = new Dictionary();
      
      private var _timer:Timer;
      
      private var _startTime:int;
      
      private var _localMarkDate:Date = new Date();
      
      private var _frame:Frame;
      
      private var _luckyNum:int = -1;
      
      private var _myLuckyNum:int = -1;
      
      private var _initialized:Boolean = false;
      
      private var _responseLuckyNum:Boolean = true;
      
      private var _currentModel:int;
      
      private var _times:int;
      
      private var _price:int;
      
      private var _isQQopen:Boolean = false;
      
      private var _activeID:int;
      
      private var _reciveActive:ActiveEventsInfo;
      
      private var _showInfo:ActiveEventsInfo;
      
      private var _eventActives:Array;
      
      private var _activeExchange:Array;
      
      private var _dailyInfo:Array;
      
      private var _signAwards:Array;
      
      private var _signAwardCounts:Array;
      
      private var _signPetInfo:Array;
      
      private var _dailyAwardState:Boolean = true;
      
      public function CalendarManager()
      {
         super();
      }
      
      public static function getInstance() : CalendarManager
      {
         if(_ins == null)
         {
            _ins = new CalendarManager();
         }
         return _ins;
      }
      
      public function initialize() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_LUCKYNUM,this.__userLuckyNum);
      }
      
      public function requestLuckyNum() : void
      {
         if(this._responseLuckyNum)
         {
            SocketManager.Instance.out.sendUserLuckyNum(-1,false);
            this._responseLuckyNum = false;
         }
      }
      
      private function __userLuckyNum(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._luckyNum = pkg.readInt();
         var luckyBuff:String = pkg.readUTF();
         if(Boolean(this._model))
         {
            this._model.luckyNum = this._luckyNum;
            this._model.myLuckyNum = this._myLuckyNum;
         }
         this._responseLuckyNum = true;
      }
      
      public function open(current:int, isFromWantStrong:Boolean = false) : void
      {
         var localDate:Date = null;
         this._currentModel = current;
         if(this._initialized && (!this._localVisible || isFromWantStrong) && Boolean(this._today))
         {
            this._localVisible = true;
            this._model = new CalendarModel(this._today,this._signCount,this._dayLogDic,this._signAwards,this._signAwardCounts,this._eventActives,this._activeExchange);
            this._model.luckyNum = this._luckyNum;
            this._model.myLuckyNum = this._myLuckyNum;
            localDate = new Date();
            if(localDate.time - this._today.time > CalendarModel.MS_of_Day)
            {
               SocketManager.Instance.out.sendErrorMsg("打开签到的时候，客户端时间与服务器时间间隔超过一天。by" + PlayerManager.Instance.Self.NickName);
            }
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CALENDAR);
            this.requestLuckyNum();
         }
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      private function __onProgress(e:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
      }
      
      public function qqOpen(activeID:int) : void
      {
         this._isQQopen = true;
         this._activeID = activeID;
         if(this._initialized && !this._localVisible)
         {
            this.open(2);
         }
         else if(this._frame != null)
         {
            this._isQQopen = false;
            (this._frame as CalendarFrame).showByQQ(this._activeID);
         }
      }
      
      private function _qqOpenComplete() : void
      {
         if(this._frame is CalendarFrame)
         {
            (this._frame as CalendarFrame).showByQQ(this._activeID);
         }
      }
      
      public function close() : void
      {
         this._localVisible = false;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer = null;
         }
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      private function __moduleIOError(event:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleSmallLoading.Instance.hide();
         this.close();
      }
      
      private function __loadingClose(event:Event) : void
      {
         this.close();
      }
      
      private function __moduleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_CALENDAR)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            if(this._localVisible)
            {
               if(this._currentModel == CalendarModel.Calendar)
               {
                  this._frame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.SignFrameStyle",[this._model]);
                  this._frame.titleText = LanguageMgr.GetTranslation("tank.calendar.signTitle");
                  LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               }
               else
               {
                  this._frame = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarFrame",[this._model]);
                  this._frame.titleText = LanguageMgr.GetTranslation("tank.calendar.title");
                  (this._frame as CalendarFrame).setState();
                  this.lookActivity(TimeManager.Instance.Now());
               }
               this._frame.addEventListener(ComponentEvent.DISPOSE,this.__frameDispose);
               MainToolBar.Instance.showSignShineEffect(false);
               MainToolBar.Instance.signEffectEnable = false;
               if(this._frame is CalendarFrame)
               {
                  this.lookActivity(TimeManager.Instance.Now());
               }
               if(this._timer == null)
               {
                  this._timer = new Timer(1000);
                  this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
                  this._timer.start();
               }
            }
            if(this._isQQopen)
            {
               this._isQQopen = false;
               this._qqOpenComplete();
            }
         }
      }
      
      private function __frameDispose(event:ComponentEvent) : void
      {
         this._localVisible = false;
         event.currentTarget.removeEventListener(ComponentEvent.DISPOSE,this.__frameDispose);
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer = null;
         }
      }
      
      private function __mark(event:TimerEvent) : void
      {
         var today:Date = null;
         if(this._localVisible && Boolean(this._model))
         {
            today = this._model.today;
            this._localMarkDate.time = today.time + getTimer() - this._startTime;
            if(this._localMarkDate.fullYear > today.fullYear || this._localMarkDate.month > today.month || this._localMarkDate.date > today.date)
            {
               this.localToNextDay(this._model,this._localMarkDate);
            }
         }
      }
      
      public function closeActivity() : void
      {
         this.setState(CalendarModel.Calendar);
      }
      
      public function setState(data:* = null) : void
      {
         if(Boolean(this._frame))
         {
            (this._frame as CalendarFrame).setState(data);
         }
      }
      
      public function request() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["rnd"] = Math.random();
         var calendarLoader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyLogList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         calendarLoader.analyzer = new CalendarSignAnalyze(this.calendarSignComplete);
         calendarLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         calendarLoader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.Instance.startLoad(calendarLoader);
         return calendarLoader;
      }
      
      public function requestActiveEvent() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActiveList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingActivityInformationFailure");
         loader.analyzer = new ActiveEventsAnalyzer(this.setEventActivity);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         return loader;
      }
      
      public function requestActionExchange() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActiveConvertItemInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingActivityInformationFailure");
         loader.analyzer = new ActiveExchangeAnalyzer(this.setActivityExchange);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         return loader;
      }
      
      private function __complete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      private function calendarSignComplete(analyze:CalendarSignAnalyze) : void
      {
         var day:int = 0;
         var nowtoday:Date = new Date();
         this._startTime = getTimer();
         this._today = analyze.date;
         this._times = analyze.times;
         this._price = analyze.price;
         _isOK = analyze.isOK == "True" ? true : false;
         this._signCount = 0;
         var arr:Array = analyze.dayLog.split(",");
         var len:int = CalendarModel.getMonthMaxDay(this._today.month,this._today.fullYear);
         if(arr.length <= 0)
         {
            _isOK = false;
         }
         for(var i:int = 0; i < len; i++)
         {
            if(i < arr.length && arr[i] == "True")
            {
               day = i + 1;
               ++this._signCount;
               this._dayLogDic[String(i + 1)] = "True";
               this.returnPetIsShow(this._signCount);
               if(day == int(nowtoday.date))
               {
                  PlayerManager.Instance.Self.Sign = true;
                  MainButtnController.instance.dispatchEvent(new Event(MainButtnController.CLOSESIGN));
               }
            }
            else
            {
               this._dayLogDic[String(i + 1)] = "False";
            }
         }
         if(Boolean(this._model) && this._localVisible)
         {
            this._model.today = this._today;
            this._model.signCount = this._signCount;
            this._model.dayLog = this._dayLogDic;
         }
      }
      
      private function localToNextDay(model:CalendarModel, date:Date) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(date.date == 1)
         {
            len = CalendarModel.getMonthMaxDay(date.month,date.fullYear);
            for(i = 1; i <= len; i++)
            {
               this._model.dayLog[String(i)] = "False";
            }
            this._model.signCount = 0;
         }
         this._model.today = date;
      }
      
      public function sign(date:Date) : Boolean
      {
         var today:Date = null;
         var len:int = 0;
         var i:int = 0;
         var result:Boolean = false;
         if(this._localVisible && Boolean(this._model))
         {
            today = this._model.today;
            if(date.fullYear == today.fullYear && date.month == today.month && date.date == today.date && !this._model.hasSigned(date))
            {
               SocketManager.Instance.out.sendDailyAward(5);
               this._model.dayLog[date.date.toString()] = "True";
               ++this._model.signCount;
               this._signCount = this._model.signCount;
               result = true;
               len = int(this._model.awardCounts.length);
               this.returnPetIsShow(this._model.signCount);
               for(i = 0; i < len; i++)
               {
                  if(this._model.signCount == this._model.awardCounts[i])
                  {
                     this.receive(this._model.awardCounts[i],this._model.awards);
                     return result;
                  }
               }
            }
         }
         return result;
      }
      
      public function signNew(date:Date) : Boolean
      {
         var len:int = 0;
         var i:int = 0;
         var result:Boolean = false;
         if(this._localVisible && Boolean(this._model))
         {
            if(!this._model.hasSignedNew(date))
            {
               this._model.dayLog[date.date.toString()] = "True";
               ++this._model.signCount;
               this._signCount = this._model.signCount;
               result = true;
               len = int(this._model.awardCounts.length);
               this.returnPetIsShow(this._model.signCount);
               for(i = 0; i < len; i++)
               {
                  if(this._model.signCount == this._model.awardCounts[i])
                  {
                     this.receive(this._model.awardCounts[i],this._model.awards);
                     return result;
                  }
               }
            }
         }
         return result;
      }
      
      private function returnPetIsShow(count:int) : void
      {
         var serverTime:Date = TimeManager.Instance.Now();
         var date:Date = new Date(serverTime.getFullYear(),serverTime.getMonth() + 1);
         date.time -= 1;
         var totalDay:int = date.date;
         if(count == totalDay && !_isOK)
         {
            dispatchEvent(new Event(PET_BTN_SHOW));
         }
      }
      
      public function hasSignedIsTrue(date:Date) : Boolean
      {
         return this._model.hasSignedNew(date);
      }
      
      public function lookActivity(date:Date) : void
      {
         if(this._frame && this._model && this.hasSameWeek(this._model.today,date))
         {
            (this._frame as CalendarFrame).activityList.setActivityDate(date);
         }
      }
      
      private function hasSameWeek(date1:Date, date2:Date) : Boolean
      {
         if(Math.abs(date2.time - date1.time) > CalendarModel.MS_of_Day * 7)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.OutWeek"));
            return false;
         }
         return true;
      }
      
      private function getWeekCount(date:Date) : int
      {
         var yearDate:Date = new Date();
         yearDate.setFullYear(date.fullYear,1,1);
         var days:int = (date.time - yearDate.time) / CalendarModel.MS_of_Day;
         return days / 7;
      }
      
      public function receive(signCount:int, list:Array) : void
      {
         var award:DaylyGiveInfo = null;
         SocketManager.Instance.out.sendSignAward(signCount);
         var awards:Array = [];
         for each(award in list)
         {
            if(award.AwardDays == signCount)
            {
               awards.push(award);
            }
         }
         this.showAwardInfo(awards);
      }
      
      public function showAwardInfo(awards:Array) : void
      {
         var info:ItemTemplateInfo = null;
         var item:DaylyGiveInfo = null;
         var msgStr:String = "";
         for each(item in awards)
         {
            info = ItemManager.Instance.getTemplateById(item.TemplateID);
            if(Boolean(info))
            {
               msgStr += info.Name + "X" + item.Count + " ";
            }
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signedAwards",msgStr));
      }
      
      public function reciveActivityAward(Active:ActiveEventsInfo, key:String) : BaseLoader
      {
         this._reciveActive = Active;
         var temp:ByteArray = new ByteArray();
         temp.writeUTFBytes(key);
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var acc:AccountInfo = PlayerManager.Instance.Account;
         args["activeKey"] = CrytoUtils.rsaEncry4(acc.Key,temp);
         args["activeID"] = Active.ActiveID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActivePullDown.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete,false,99);
         LoadResourceManager.Instance.startLoad(loader,true);
         return loader;
      }
      
      private function __activityLoadComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         var result:XML = XML(event.loader.content);
         if(String(result.@value) == "True")
         {
            this._reciveActive.isAttend = true;
         }
         if(String(result.@message).length > 0)
         {
            MessageTipManager.getInstance().show(result.@message);
         }
      }
      
      public function isShowLimiAwardButton() : Boolean
      {
         return Boolean(this._reciveActive) && this._reciveActive.IsShow;
      }
      
      public function reciveDayAward() : void
      {
         var nowDate:Date = null;
         var date:Date = PlayerManager.Instance.Self.systemDate as Date;
         if(!this._dailyAwardState)
         {
            nowDate = new Date();
            nowDate.setTime(nowDate.getTime() + DatetimeHelper.millisecondsPerDay);
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.calendar.DailyAward",nowDate.month + 1,nowDate.date),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         }
         else
         {
            this._dailyAwardState = false;
            MainButtnController.instance.DailyAwardState = false;
            SocketManager.Instance.out.sendDailyAward(0);
            MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
         }
      }
      
      public function hasTodaySigned() : Boolean
      {
         return Boolean(this._dayLogDic) && Boolean(this._today) && this._dayLogDic[this._today.date.toString()] == "True";
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function get isShow() : Boolean
      {
         return this._localVisible;
      }
      
      public function checkEventInfo() : Boolean
      {
         var info:ActiveEventsInfo = null;
         for each(info in this._eventActives)
         {
            if(info.IsShow == true && !info.overdue())
            {
               this._showInfo = info;
               return true;
            }
         }
         return false;
      }
      
      public function getShowActiveInfo() : ActiveEventsInfo
      {
         return this._showInfo;
      }
      
      public function setEventActivity(analyzer:ActiveEventsAnalyzer) : void
      {
         this._eventActives = analyzer.list;
      }
      
      public function get eventActives() : Array
      {
         return this._eventActives;
      }
      
      public function setActivityExchange(analyzer:ActiveExchangeAnalyzer) : void
      {
         this._activeExchange = analyzer.list;
      }
      
      public function get activeExchange() : Array
      {
         return this._activeExchange;
      }
      
      public function setDailyInfo(analyzer:DaylyGiveAnalyzer) : void
      {
         this._dailyInfo = analyzer.list;
         this._signAwards = analyzer.signAwardList;
         this._signAwardCounts = analyzer.signAwardCounts;
         this._signPetInfo = analyzer.signPetInfo;
         this._initialized = true;
      }
      
      public function setDailyAwardState(state:Boolean) : void
      {
         this._dailyAwardState = state;
      }
      
      public function get model() : CalendarModel
      {
         return this._model;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function get times() : int
      {
         return this._times;
      }
      
      public function set times(value:int) : void
      {
         this._times = value;
      }
      
      public function get isOK() : Boolean
      {
         return _isOK;
      }
      
      public function set isOK(value:Boolean) : void
      {
         _isOK = value;
      }
      
      public function get signPetInfo() : Array
      {
         return this._signPetInfo;
      }
   }
}

