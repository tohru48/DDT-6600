package calendar
{
   import flash.events.Event;
   
   public class CalendarEvent extends Event
   {
      
      public static const SignCountChanged:String = "SignCountChanged";
      
      public static const TodayChanged:String = "TodayChanged";
      
      public static const DayLogChanged:String = "DayLogChanged";
      
      public static const LuckyNumChanged:String = "LuckyNumChanged";
      
      public static const ExchangeGoodsChange:String = "ExchangeGoodsChange";
      
      private var _enable:Boolean;
      
      public function CalendarEvent(type:String, enable:Boolean = true, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._enable = enable;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}

