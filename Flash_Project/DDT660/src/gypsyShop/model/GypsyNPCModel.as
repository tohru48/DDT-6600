package gypsyShop.model
{
   import ddt.events.GypsyShopEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import gypsyShop.ctrl.GypsyShopManager;
   
   public class GypsyNPCModel extends EventDispatcher
   {
      
      private static var instance:GypsyNPCModel;
      
      private var _isStart:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      public function GypsyNPCModel(single:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyNPCModel
      {
         if(!instance)
         {
            instance = new GypsyNPCModel(new inner());
         }
         return instance;
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(GypsyShopEvent.NPC_STATE_CHANGE,this.onNPCStateChange);
      }
      
      protected function onNPCStateChange(e:GypsyShopEvent) : void
      {
         var d:ByteArray = e.data;
         var isOpen:Boolean = d.readBoolean();
         if(isOpen)
         {
            this._isStart = true;
            GypsyShopManager.getInstance().showNPC();
         }
         else
         {
            this._isStart = false;
            GypsyShopManager.getInstance().hideNPC();
         }
         if(isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("gypsy.open"));
         }
         else if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("gypsy.close"));
         }
         this._isOpen = isOpen;
      }
      
      public function refreshNPCState() : void
      {
         if(this._isOpen)
         {
            this._isStart = true;
            GypsyShopManager.getInstance().showNPC();
         }
         else
         {
            this._isStart = false;
            GypsyShopManager.getInstance().hideNPC();
         }
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(GypsyShopEvent.NPC_STATE_CHANGE,this.onNPCStateChange);
      }
      
      public function isStart() : Boolean
      {
         return this._isStart;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
