package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.utils.DateUtils;
   
   public class CalendarSignAnalyze extends DataAnalyzer
   {
      
      private var _date:Date;
      
      private var _signCount:int;
      
      private var _dayLog:String;
      
      private var _luckyNum:int = -1;
      
      private var _myLuckyNum:int = -1;
      
      private var _times:int;
      
      private var _price:int;
      
      private var _isOK:String;
      
      public function CalendarSignAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function get signCount() : int
      {
         return this._signCount;
      }
      
      public function get dayLog() : String
      {
         return this._dayLog;
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function get myLuckyNum() : int
      {
         return this._myLuckyNum;
      }
      
      public function get times() : int
      {
         return this._times;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = null;
         var date:Date = null;
         try
         {
            xml = new XML(data);
            if(xml.@value == "true")
            {
               this._date = DateUtils.dealWithStringDate(xml.@nowDate);
               this._signCount = xml.DailyLogList.@UserAwardLog;
               this._dayLog = xml.DailyLogList.@DayLog;
               this._times = xml.DailyLogList.@Times;
               this._luckyNum = xml.@luckyNum;
               this._myLuckyNum = xml.@myLuckyNum;
               this._price = xml.@Price;
               this._isOK = xml.DailyLogList.@AwardMonth;
               onAnalyzeComplete();
            }
            else
            {
               message = xml.@message;
               onAnalyzeError();
               onAnalyzeComplete();
            }
         }
         catch(e:Error)
         {
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get isOK() : String
      {
         return this._isOK;
      }
      
      public function set isOK(value:String) : void
      {
         this._isOK = value;
      }
   }
}

