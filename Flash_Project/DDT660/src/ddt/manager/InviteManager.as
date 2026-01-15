package ddt.manager
{
   public class InviteManager
   {
      
      private static var _ins:InviteManager;
      
      private var _enabled:Boolean = true;
      
      public function InviteManager()
      {
         super();
      }
      
      public static function get Instance() : InviteManager
      {
         return _ins = _ins || new InviteManager();
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         this._enabled = value;
      }
   }
}

