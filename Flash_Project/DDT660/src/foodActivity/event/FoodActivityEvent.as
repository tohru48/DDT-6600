package foodActivity.event
{
   import flash.events.Event;
   
   public class FoodActivityEvent extends Event
   {
      
      public static var ACTIVITY_STATE:int = 1;
      
      public static var SIMPLE_COOKING:int = 2;
      
      public static var PAY_COOKING:int = 3;
      
      public static var REWARD:int = 4;
      
      public static var UPDATE_COUNT:int = 5;
      
      public static var UPDATE_COUNT_BYTIME:int = 6;
      
      public static var CLEAN_DATA:int = 7;
      
      public function FoodActivityEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

