package baglocked.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class BagLockedEvent extends Event
   {
      
      public static const GET_BACK_LOCK_PWD:String = "getBackLockPwd";
      
      public static const DEL_QUESTION:String = "delQuestion";
      
      private var _pkg:PackageIn;
      
      public function BagLockedEvent(type:String, pkg:PackageIn = null)
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

