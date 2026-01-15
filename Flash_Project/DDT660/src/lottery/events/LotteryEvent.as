package lottery.events
{
   import flash.events.Event;
   
   public class LotteryEvent extends Event
   {
      
      public static const CARD_SELECT:String = "cardSelect";
      
      public static const CARD_CANCEL:String = "cardCancel";
      
      public static const CARD_CANCEL_ALL:String = "cardCancelAll";
      
      private var _paras:Array;
      
      public function LotteryEvent(type:String, ... args)
      {
         super(type);
         this._paras = args;
      }
      
      public function get paras() : Array
      {
         return this._paras;
      }
   }
}

