package ddtActivityIcon
{
   import dayActivity.data.DayActiveData;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import lanternriddles.event.LanternEvent;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class DdtActivityIconManager extends EventDispatcher
   {
      
      private static var _instance:DdtActivityIconManager;
      
      private static const MINI:int = 1000 * 10;
      
      private static const HOURS:int = 1000 * 60 * 60;
      
      public static const READY_START:String = "ready_start";
      
      public static const START:String = "start";
      
      private static const NO_START:String = "no_start";
      
      private var _timerList:Vector.<DayActiveData>;
      
      private var _timer:Timer;
      
      private var todayActList:Array;
      
      private var _isOneOpen:Boolean;
      
      private var _isAlreadyOpen:Boolean;
      
      public var currObj:Array;
      
      public function DdtActivityIconManager(target:IEventDispatcher = null)
      {
         super(target);
         this._timer = new Timer(MINI);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
      }
      
      public static function get Instance() : DdtActivityIconManager
      {
         if(_instance == null)
         {
            _instance = new DdtActivityIconManager();
         }
         return _instance;
      }
      
      private function timerHander(e:TimerEvent) : void
      {
         this.checkTodayActList();
         this.checkSpecialActivity();
      }
      
      private function checkSpecialActivity() : void
      {
         var tStr:String = null;
         if(this._isAlreadyOpen)
         {
            return;
         }
         var now:Date = TimeManager.Instance.Now();
         var nowTime:String = now.getFullYear().toString() + "/" + (now.month + 1).toString() + "/" + now.date.toString() + " ";
         var serverData:DictionaryData = ServerConfigManager.instance.serverConfigInfo;
         var startDate:Date = DateUtils.getDateByStr(serverData["LightRiddleBeginDate"].Value);
         var startTime:Date = DateUtils.getDateByStr(this.transformTime(nowTime,serverData["LightRiddleBeginTime"].Value));
         var endDate:Date = DateUtils.getDateByStr(serverData["LightRiddleEndDate"].Value);
         if(PlayerManager.Instance.Self.Grade >= 15)
         {
            if(now.time > startDate.time && now.time < endDate.time)
            {
               if(startTime.time > now.time && startTime.time - now.time <= HOURS)
               {
                  this._isAlreadyOpen = true;
                  tStr = this.addO(startTime.hours) + ":" + this.addO(startTime.minutes) + LanguageMgr.GetTranslation("ddt.activityIcon.timePreStartTxt");
                  dispatchEvent(new LanternEvent(LanternEvent.LANTERN_SETTIME,tStr));
               }
            }
         }
      }
      
      private function transformTime(nowTime:String, startTime:String) : String
      {
         var temp:Array = startTime.split(" ");
         return nowTime + temp[1];
      }
      
      public function set timerList(list:Vector.<DayActiveData>) : void
      {
         this._timerList = list;
      }
      
      public function setup() : void
      {
         this._timer.reset();
         this.initToDayActivie();
         this._timer.start();
      }
      
      public function startTime() : void
      {
         this._timer.start();
      }
      
      public function stopTime() : void
      {
         this._timer.stop();
      }
      
      private function initToDayActivie() : Array
      {
         var len:int = 0;
         var i:int = 0;
         if(Boolean(this._timerList))
         {
            this.todayActList = [];
            len = int(this._timerList.length);
            for(i = 0; i < len; i++)
            {
               if(this.checkToday(this._timerList[i].DayOfWeek))
               {
                  if(!(this._timerList[i].ID == 5 && int(this._timerList[i].LevelLimit) > PlayerManager.Instance.Self.Grade))
                  {
                     if(!(this._timerList[i].ID == 4 && int(this._timerList[i].LevelLimit) > PlayerManager.Instance.Self.Grade))
                     {
                        this.todayActList.push(this.strToDataArray(this._timerList[i].ActiveTime,this._timerList[i].ID));
                     }
                  }
               }
            }
         }
         return this.todayActList;
      }
      
      public function get isOneOpen() : Boolean
      {
         return this._isOneOpen;
      }
      
      public function set isOneOpen(bool:Boolean) : void
      {
         this._isOneOpen = bool;
      }
      
      private function checkTodayActList() : void
      {
         var obj1:Object = null;
         var end:Date = null;
         var obj2:Object = null;
         var objReady1:Object = null;
         var endReady1:Date = null;
         var objReady2:Object = null;
         if(!this.todayActList)
         {
            return;
         }
         var len:int = int(this.todayActList.length);
         var now:Date = TimeManager.Instance.Now();
         for(var i:int = 0; i < len; i++)
         {
            obj1 = this.todayActList[i][0];
            end = obj1.end;
            this.checkActOpen(obj1);
            if(Boolean(this.todayActList[i][1]) && now.time > end.time)
            {
               obj2 = this.todayActList[i][1];
               this.checkActOpen(obj2);
            }
         }
         if(this._isOneOpen)
         {
            return;
         }
         for(var j:int = 0; j < len; j++)
         {
            objReady1 = this.todayActList[j][0];
            endReady1 = objReady1.end;
            this.checkActReady(objReady1);
            if(Boolean(this.todayActList[j][1]) && now.time > endReady1.time)
            {
               objReady2 = this.todayActList[j][1];
               this.checkActReady(objReady2);
            }
         }
      }
      
      private function checkToday(str:String) : Boolean
      {
         var now:Date = TimeManager.Instance.Now();
         var arr:Array = str.split(",");
         var len:int = int(arr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(now.day == int(arr[i]))
            {
               return true;
            }
         }
         return false;
      }
      
      private function checkActOpen(obj:Object) : void
      {
         var id:int = 0;
         var tStr:String = null;
         var now:Date = TimeManager.Instance.Now();
         var start:Date = obj.start;
         var end:Date = obj.end;
         var disT:int = start.time - now.time;
         if(now.time >= start.time && now.time < end.time)
         {
            if(obj.name == 1)
            {
               id = 2;
            }
            else if(obj.name == 2)
            {
               id = 1;
            }
            else if(obj.name == 19)
            {
               id = 4;
            }
            else
            {
               id = -100;
            }
            this._isOneOpen = true;
            this.currObj = new Array();
            this.currObj.push(obj.name);
            this.currObj.push(id);
            tStr = this.addO(start.hours) + ":" + this.addO(start.minutes) + "已開啟";
            this.currObj.push(tStr);
            dispatchEvent(new ActivitStateEvent(DdtActivityIconManager.START,[obj.name,id,tStr]));
         }
      }
      
      private function checkActReady(obj:Object) : void
      {
         var id:int = 0;
         var tStr:String = null;
         var now:Date = TimeManager.Instance.Now();
         var start:Date = obj.start;
         var end:Date = obj.end;
         var disT:int = start.time - now.time;
         if(start.time > now.time && disT < HOURS)
         {
            if(obj.name == 1)
            {
               id = 2;
            }
            else if(obj.name == 2)
            {
               id = 1;
            }
            else if(obj.name == 19)
            {
               id = 4;
            }
            else
            {
               id = -100;
            }
            this._isOneOpen = false;
            tStr = this.addO(start.hours) + ":" + this.addO(start.minutes) + " " + LanguageMgr.GetTranslation("ddt.activityIcon.timePreStartTxt");
            dispatchEvent(new ActivitStateEvent(DdtActivityIconManager.READY_START,[obj.name,id,tStr]));
         }
      }
      
      private function addO(num:Number) : String
      {
         var str:String = num.toString();
         if(str.length == 1)
         {
            str = "0" + str;
         }
         return str;
      }
      
      private function strToDataArray(str:String, id:int) : Array
      {
         var startStr2:String = null;
         var endStr2:String = null;
         var startDate2:Date = null;
         var endDate2:Date = null;
         var obj2:Object = null;
         var dataArr:Array = [];
         var arr:Array = str.split("|");
         var startStr1:String = arr[0].substr(0,5);
         var endStr1:String = arr[0].substr(6,5);
         var startDate1:Date = this.strToDate(startStr1);
         var endDate1:Date = this.strToDate(endStr1);
         var obj1:Object = new Object();
         obj1.start = startDate1;
         obj1.end = endDate1;
         obj1.name = id;
         dataArr.push(obj1);
         if(Boolean(arr[1]))
         {
            startStr2 = arr[1].substr(0,5);
            endStr2 = arr[1].substr(6,5);
            startDate2 = this.strToDate(startStr2);
            endDate2 = this.strToDate(endStr2);
            obj2 = new Object();
            obj2.start = startDate2;
            obj2.end = endDate2;
            obj2.name = id;
            dataArr.push(obj2);
         }
         return dataArr;
      }
      
      private function strToDate(str:String) : Date
      {
         var now:Date = TimeManager.Instance.Now();
         var year:Number = now.fullYear;
         var month:int = now.month;
         var day:Number = now.date;
         var hours:String = str.substr(0,2);
         var minutes:String = str.substr(3,2);
         return new Date(year,month,day,hours,minutes);
      }
      
      public function set isAlreadyOpen(value:Boolean) : void
      {
         this._isAlreadyOpen = value;
      }
   }
}

