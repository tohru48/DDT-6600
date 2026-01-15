package rescue.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class RescueEvent extends Event
   {
      
      public static const IS_OPEN:String = "isOpen";
      
      public static const FRAME_INFO:String = "frameInfo";
      
      public static const CHALLENGE:String = "challenge";
      
      public static const BUY_ITEM:String = "buyItem";
      
      public static const CLEAN_CD:String = "cleanCD";
      
      public static const FIGHT_RESULT:String = "result";
      
      public static const ITEM_INFO:String = "itemInfo";
      
      private var _pkg:PackageIn;
      
      public function RescueEvent(type:String, pkg:PackageIn = null)
      {
         super(type,bubbles,cancelable);
         this._pkg = pkg;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}

