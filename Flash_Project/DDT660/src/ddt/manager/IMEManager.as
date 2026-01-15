package ddt.manager
{
   import flash.system.Capabilities;
   import flash.system.IME;
   
   public class IMEManager
   {
      
      public function IMEManager()
      {
         super();
      }
      
      public static function enable() : void
      {
         if(Capabilities.hasIME)
         {
            try
            {
               IME.enabled = true;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public static function disable() : void
      {
         if(Capabilities.hasIME)
         {
            try
            {
               IME.enabled = false;
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

