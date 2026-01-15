package magicStone.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class MagicStoneEvent extends Event
   {
      
      public static const MAGIC_STONE_SCORE:String = "magicStoneScore";
      
      public static const UPDATE_BAG:String = "updateBag";
      
      public static const UPDATE_REMAIN_COUNT:String = "updateRemainCount";
      
      public static const MAGIC_STONE_DOUBLESCORE:String = "magicStoneDoubleScore";
      
      private var _pkg:PackageIn;
      
      public function MagicStoneEvent(type:String, pkg:PackageIn = null)
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

