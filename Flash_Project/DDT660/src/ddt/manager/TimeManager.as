package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import wantstrong.WantStrongManager;
   import wantstrong.event.WantStrongEvent;
   
   public class TimeManager
   {
      
      private static var _instance:TimeManager;
      
      public static const DAY_TICKS:Number = 1000 * 24 * 60 * 60;
      
      public static const HOUR_TICKS:Number = 1000 * 60 * 60;
      
      public static const Minute_TICKS:Number = 1000 * 60;
      
      public static const Second_TICKS:Number = 1000;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var CHANGE:String = "change";
      
      private var _serverDate:Date;
      
      private var _serverTick:int;
      
      private var _enterFightTime:Number;
      
      private var _startGameTime:Date;
      
      private var _currentTime:Date;
      
      private var _totalGameTime:Number;
      
      public function TimeManager()
      {
         super();
      }
      
      public static function addEventListener(type:String, listener:Function) : void
      {
         _dispatcher.addEventListener(type,listener);
      }
      
      public static function removeEventListener(type:String, listener:Function) : void
      {
         _dispatcher.removeEventListener(type,listener);
      }
      
      public static function get Instance() : TimeManager
      {
         if(_instance == null)
         {
            _instance = new TimeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._serverDate = new Date();
         this._serverTick = getTimer();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE,this.__update);
      }
      
      private function __update(event:CrazyTankSocketEvent) : void
      {
         this._serverTick = getTimer();
         this._serverDate = event.pkg.readDate();
         if((StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON_LIST) && !WantStrongManager.Instance.isTimeUpdated)
         {
            WantStrongManager.Instance.isTimeUpdated = true;
            WantStrongManager.Instance.dispatchEvent(new WantStrongEvent(WantStrongEvent.ALREADYUPDATETIME));
         }
      }
      
      public function Now() : Date
      {
         return new Date(this._serverDate.getTime() + getTimer() - this._serverTick);
      }
      
      public function get serverDate() : Date
      {
         return this._serverDate;
      }
      
      public function get currentDay() : Number
      {
         return this.Now().getDay();
      }
      
      public function TimeSpanToNow(last:Date) : Date
      {
         return new Date(Math.abs(this._serverDate.getTime() + getTimer() - this._serverTick - last.time));
      }
      
      public function TotalDaysToNow(last:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - last.time) / DAY_TICKS;
      }
      
      public function TotalHoursToNow(last:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - last.time) / HOUR_TICKS;
      }
      
      public function TotalMinuteToNow(last:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - last.time) / Minute_TICKS;
      }
      
      public function TotalSecondToNow(last:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - last.time) / Second_TICKS;
      }
      
      public function TotalDaysToNow2(last:Date) : Number
      {
         var dt:Date = this.Now();
         dt.setHours(0,0,0,0);
         var lt:Date = new Date(last.time);
         lt.setHours(0,0,0,0);
         return (dt.time - lt.time) / DAY_TICKS;
      }
      
      public function getMaxRemainDateStr(endTime:Date, type:int = 1) : String
      {
         var timeTxtStr:String = null;
         if(!endTime)
         {
            return "0" + LanguageMgr.GetTranslation("second");
         }
         var endTimestamp:Number = Number(endTime.getTime());
         var nowTimestamp:Number = Number(this.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ - 10000 < 0 ? differ : differ - 10000;
         differ = differ < 0 ? 0 : differ;
         var count:int = 0;
         if(differ / DAY_TICKS > 1)
         {
            if(type == 1)
            {
               count = Math.floor(differ / DAY_TICKS);
            }
            else
            {
               count = Math.ceil(differ / DAY_TICKS);
            }
            timeTxtStr = count + LanguageMgr.GetTranslation("day");
         }
         else if(differ / HOUR_TICKS > 1)
         {
            count = differ / HOUR_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("hour");
         }
         else if(differ / Minute_TICKS > 1)
         {
            count = differ / Minute_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            count = differ / Second_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("second");
         }
         return timeTxtStr;
      }
      
      public function set totalGameTime(time:int) : void
      {
         this._totalGameTime = time;
         _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
      }
      
      public function get totalGameTime() : int
      {
         return this._totalGameTime;
      }
      
      public function get enterFightTime() : Number
      {
         return this._enterFightTime;
      }
      
      public function set enterFightTime(value:Number) : void
      {
         this._enterFightTime = value;
      }
   }
}

