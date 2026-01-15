package oldplayergetticket
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class GetTicketManager extends EventDispatcher
   {
      
      private static var _instance:GetTicketManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _getTicketView:GetTicketView;
      
      private var _money:int;
      
      private var _level:int;
      
      private var _levelMoney:int;
      
      public function GetTicketManager()
      {
         super();
         this.initEvent();
      }
      
      public static function get instance() : GetTicketManager
      {
         if(!_instance)
         {
            _instance = new GetTicketManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         addEventListener(GetTicketEvent.GETTICKET_DATA,this.getTicketData);
      }
      
      protected function getTicketData(event:GetTicketEvent) : void
      {
         this._money = event.money;
         this._level = event.level;
         this._levelMoney = event.levelMoney;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showGetTicketFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GETTICKET_VIEW);
         }
      }
      
      public function hide() : void
      {
         if(this._getTicketView != null)
         {
            this._getTicketView.dispose();
         }
         this._getTicketView = null;
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GETTICKET_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.REGRESS_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showGetTicketFrame() : void
      {
         this._getTicketView = ComponentFactory.Instance.creatComponentByStylename("oldplayer.getTicket");
         this._getTicketView.setViewData(this._money,this._level,this._levelMoney);
         this._getTicketView.show();
      }
   }
}

