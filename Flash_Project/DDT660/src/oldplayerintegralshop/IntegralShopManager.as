package oldplayerintegralshop
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import oldplayerintegralshop.view.IntegralShopView;
   
   public class IntegralShopManager extends EventDispatcher
   {
      
      private static var _instance:IntegralShopManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _integralShopView:IntegralShopView;
      
      private var _integralNum:int;
      
      public function IntegralShopManager()
      {
         super();
      }
      
      public static function get instance() : IntegralShopManager
      {
         if(!_instance)
         {
            _instance = new IntegralShopManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showIntegralShopFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.INTEGRAL_SHOP);
         }
      }
      
      public function hide() : void
      {
         if(this._integralShopView != null)
         {
            this._integralShopView.dispose();
         }
         this._integralShopView = null;
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.INTEGRAL_SHOP)
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
         if(event.module == UIModuleTypes.INTEGRAL_SHOP)
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
      
      private function showIntegralShopFrame() : void
      {
         this._integralShopView = ComponentFactory.Instance.creatComponentByStylename("oldplayerintegralshop.IntegralShopView");
         this._integralShopView.show();
      }
      
      public function get integralNum() : int
      {
         return this._integralNum;
      }
      
      public function set integralNum(value:int) : void
      {
         this._integralNum = value;
      }
   }
}

