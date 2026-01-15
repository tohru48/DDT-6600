package giftSystem
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class GiftModel extends EventDispatcher
   {
      
      public function GiftModel(target:IEventDispatcher = null)
      {
         super(target);
         this.init();
      }
      
      private function init() : void
      {
      }
   }
}

