package playerDress.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class PlayerDressEvent extends Event
   {
      
      public static const GET_DRESS_MODEL:String = "getDressModel";
      
      public static const CURRENT_MODEL:String = "currentModel";
      
      public static const LOCK_DRESSBAG:String = "lockDressBag";
      
      public static const UPDATE_PLAYERINFO:String = "updatePlayerinfo";
      
      private var _pkg:PackageIn;
      
      public function PlayerDressEvent(type:String, pkg:PackageIn = null)
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

