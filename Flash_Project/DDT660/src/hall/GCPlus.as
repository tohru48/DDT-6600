package hall
{
   import flash.net.SharedObject;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class GCPlus
   {
      
      public function GCPlus()
      {
         super();
      }
      
      public static function clear() : void
      {
         var interval:int = 0;
         var loop:Function = null;
         loop = function():void
         {
            if(!time--)
            {
               clearInterval(interval);
               return;
            }
            SharedObject.getLocal("cypl","/");
         };
         var time:int = 2;
         interval = int(setInterval(loop,50));
      }
   }
}

