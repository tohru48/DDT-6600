package ddt.events
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class WorshipTheMoonEvent extends Event
   {
      
      public static const IS_ACTIVITY_OPEN:String = "is_activity_open";
      
      public static const FREE_COUNT:String = "free_count";
      
      public static const AWARDS_LIST:String = "awards_list";
      
      public static const WORSHIP_THE_MOON:String = "worship_the_moon";
      
      public static const RECEIVE_MOON_REWARD:String = "receive_moon_reward";
      
      private var _data:ByteArray;
      
      public function WorshipTheMoonEvent(type:String, $data:ByteArray, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._data = $data;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
   }
}

