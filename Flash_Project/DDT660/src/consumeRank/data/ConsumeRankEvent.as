package consumeRank.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ConsumeRankEvent extends Event
   {
      
      public static const UPDATE:String = "update";
      
      private var _pkg:PackageIn;
      
      public function ConsumeRankEvent(type:String, pkg:PackageIn = null)
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

