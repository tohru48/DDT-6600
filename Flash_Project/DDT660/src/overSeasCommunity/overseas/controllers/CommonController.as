package overSeasCommunity.overseas.controllers
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class CommonController extends EventDispatcher
   {
      
      public function CommonController(target:IEventDispatcher = null)
      {
         super(target);
      }
   }
}

