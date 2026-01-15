package calendar
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.core.Disposeable;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   [Event(name="TodayChanged",type="calendar.CalendarEvent")]
   [Event(name="SignCountChanged",type="calendar.CalendarEvent")]
   [Event(name="LuckyNumChanged",type="calendar.CalendarEvent")]
   public class CalendarModel extends EventDispatcher implements Disposeable
   {
      
      public static const Current:int = 1;
      
      public static const NewAward:int = 2;
      
      public static const Received:int = 3;
      
      public static const Calendar:int = 1;
      
      public static const Activity:int = 2;
      
      public static const MS_of_Day:int = 86400000;
      
      private var _luckyNum:int;
      
      private var _myLuckyNum:int;
      
      private var _selectedActives:ActiveEventsInfo;
      
      private var _eventActives:Array;
      
      private var _activeExchange:Array;
      
      private var _signCount:int = 0;
      
      private var _awardCounts:Array;
      
      private var _awards:Array;
      
      private var _today:Date;
      
      private var _dayLog:Dictionary;
      
      public function CalendarModel(today:Date, signCount:int, dayLog:Dictionary, signAwards:Array, awardCounts:Array, eventActives:Array, _activeExchange:Array)
      {
         super();
         this._today = today;
         this._signCount = signCount;
         this._dayLog = dayLog;
         this._awards = signAwards;
         this._awardCounts = awardCounts;
         this._eventActives = eventActives;
         this._selectedActives = this._eventActives[0];
         _activeExchange = _activeExchange;
      }
      
      public static function getMonthMaxDay(month:int, year:int) : int
      {
         switch(month)
         {
            case 0:
               return 31;
            case 1:
               if(year % 4 == 0)
               {
                  return 29;
               }
               return 28;
               break;
            case 2:
               return 31;
            case 3:
               return 30;
            case 4:
               return 31;
            case 5:
               return 30;
            case 6:
               return 31;
            case 7:
               return 31;
            case 8:
               return 30;
            case 9:
               return 31;
            case 10:
               return 30;
            case 11:
               return 31;
            default:
               return 0;
         }
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function set luckyNum(value:int) : void
      {
         if(this._luckyNum == value)
         {
            return;
         }
         this._luckyNum = value;
         dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
      }
      
      public function get myLuckyNum() : int
      {
         return this._myLuckyNum;
      }
      
      public function set myLuckyNum(value:int) : void
      {
         if(this._myLuckyNum == value)
         {
            return;
         }
         this._myLuckyNum = value;
         dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
      }
      
      public function get selectedActives() : ActiveEventsInfo
      {
         return this._selectedActives;
      }
      
      public function get eventActives() : Array
      {
         return this._eventActives;
      }
      
      public function get activeExchange() : Array
      {
         return this._activeExchange;
      }
      
      public function get signCount() : int
      {
         return this._signCount;
      }
      
      public function set signCount(value:int) : void
      {
         if(this._signCount == value)
         {
            return;
         }
         this._signCount = value;
         dispatchEvent(new CalendarEvent(CalendarEvent.SignCountChanged));
      }
      
      public function get awardCounts() : Array
      {
         return this._awardCounts;
      }
      
      public function get awards() : Array
      {
         return this._awards;
      }
      
      public function get today() : Date
      {
         return this._today;
      }
      
      public function set today(value:Date) : void
      {
         if(this._today == value)
         {
            return;
         }
         this._today = value;
         dispatchEvent(new CalendarEvent(CalendarEvent.TodayChanged));
      }
      
      public function get dayLog() : Dictionary
      {
         return this._dayLog;
      }
      
      public function set dayLog(value:Dictionary) : void
      {
         if(this._dayLog == value)
         {
            return;
         }
         this._dayLog = value;
         dispatchEvent(new CalendarEvent(CalendarEvent.DayLogChanged));
      }
      
      public function hasSigned(date:Date) : Boolean
      {
         return this._dayLog && date.fullYear == this._today.fullYear && date.month == this._today.month && this._dayLog[date.date.toString()] == "True";
      }
      
      public function hasSignedNew(date:Date) : Boolean
      {
         return this._dayLog[date.date.toString()] == "True";
      }
      
      public function hasReceived(count:int) : Boolean
      {
         if(count <= this._signCount)
         {
            return true;
         }
         return false;
      }
      
      public function dispose() : void
      {
      }
   }
}

