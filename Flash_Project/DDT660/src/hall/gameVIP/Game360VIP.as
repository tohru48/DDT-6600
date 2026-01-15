package hall.gameVIP
{
   import com.pickgliss.utils.MD5;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class Game360VIP
   {
      
      public function Game360VIP()
      {
         super();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.__addComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.__addError);
         var url:URLRequest = new URLRequest("http://public.api.360game.vn/script/sdk/get-vip-info");
         var obj:URLVariables = new URLVariables();
         obj["zingAccount"] = "Zing Account";
         obj["authKey"] = MD5.hash(obj["zingAccount"] + "" + TimeManager.Instance.Now().getMilliseconds());
         obj["time"] = TimeManager.Instance.Now().getMilliseconds();
         url.data = obj;
         loader.load(url);
      }
      
      private function __addComplete(evt:Event) : void
      {
         if((evt.currentTarget as URLLoader).data == "0")
         {
         }
      }
      
      private function __addError(evt:IOErrorEvent) : void
      {
      }
   }
}

