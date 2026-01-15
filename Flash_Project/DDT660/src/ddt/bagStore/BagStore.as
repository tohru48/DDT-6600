package ddt.bagStore
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import store.StoreController;
   
   public class BagStore extends EventDispatcher
   {
      
      private static var _instance:BagStore;
      
      public static var OPEN_BAGSTORE:String = "openBagStore";
      
      public static var CLOSE_BAGSTORE:String = "closeBagStore";
      
      public static const GENERAL:String = "general";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const BAG_STORE:String = "bag_store";
      
      public static const FORGE_STORE:String = "forge_store";
      
      private var _tipPanelNumber:int = 0;
      
      private var _passwordOpen:Boolean = true;
      
      private var _controllerInstance:StoreController;
      
      private var _storeOpenAble:Boolean = false;
      
      private var _isFromBagFrame:Boolean = false;
      
      private var _isFromShop:Boolean = false;
      
      private var _isFromConsortionBankFrame:Boolean = false;
      
      private var _type:String = "bag_store";
      
      private var _index:int = 0;
      
      private var _isInBagStoreFrame:Boolean;
      
      public function BagStore(target:IEventDispatcher = null)
      {
         super();
         this._controllerInstance = new StoreController();
      }
      
      public static function get instance() : BagStore
      {
         if(_instance == null)
         {
            _instance = new BagStore();
         }
         return _instance;
      }
      
      public function show(type:String = "bag_store", index:int = 0) : void
      {
         this._type = type;
         if(this._type == FORGE_STORE)
         {
            this._index = index;
         }
         else
         {
            this._index = 0;
         }
         try
         {
            this.createStoreFrame(type);
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,_UIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__progressShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSTORE);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._UIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
      }
      
      public function set isInBagStoreFrame(value:Boolean) : void
      {
         this._isInBagStoreFrame = value;
      }
      
      public function get isInBagStoreFrame() : Boolean
      {
         return this._isInBagStoreFrame;
      }
      
      private function createStoreFrame(type:String) : void
      {
         var _frame:BagStoreFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame");
         this._controllerInstance.Model.loadBagData();
         _frame.controller = this._controllerInstance;
         _frame.show(type,this._index);
         this.storeOpenAble = true;
         dispatchEvent(new Event(OPEN_BAGSTORE));
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDTSTORE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function _UIComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDTSTORE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._UIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            this.createStoreFrame(this._type);
         }
      }
      
      public function closed() : void
      {
         if(this._isFromBagFrame)
         {
            BagAndInfoManager.Instance.showBagAndInfo();
            dispatchEvent(new Event(CLOSE_BAGSTORE));
            this._isFromBagFrame = false;
         }
         if(this._isFromConsortionBankFrame)
         {
            ConsortionModelControl.Instance.alertBankFrame();
            this._isFromConsortionBankFrame = false;
         }
      }
      
      public function get tipPanelNumber() : int
      {
         return this._tipPanelNumber;
      }
      
      public function set tipPanelNumber(value:int) : void
      {
         this._tipPanelNumber = value;
      }
      
      public function reduceTipPanelNumber() : void
      {
         --this._tipPanelNumber;
      }
      
      public function get passwordOpen() : Boolean
      {
         return this._passwordOpen;
      }
      
      public function set passwordOpen(value:Boolean) : void
      {
         this._passwordOpen = value;
      }
      
      public function set storeOpenAble(value:Boolean) : void
      {
         this._storeOpenAble = value;
      }
      
      public function get storeOpenAble() : Boolean
      {
         return this._storeOpenAble;
      }
      
      public function set isFromBagFrame(value:Boolean) : void
      {
         this._isFromBagFrame = value;
         if(this._isFromBagFrame)
         {
            BagAndInfoManager.Instance.hideBagAndInfo();
         }
      }
      
      public function get isFromBagFrame() : Boolean
      {
         return this._isFromBagFrame;
      }
      
      public function set isFromConsortionBankFrame(value:Boolean) : void
      {
         this._isFromConsortionBankFrame = value;
         if(this._isFromConsortionBankFrame)
         {
            ConsortionModelControl.Instance.hideBankFrame();
         }
      }
      
      public function set isFromShop(value:Boolean) : void
      {
         this._isFromShop = value;
      }
      
      public function get isFromShop() : Boolean
      {
         return this._isFromShop;
      }
      
      public function get controllerInstance() : StoreController
      {
         return this._controllerInstance;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._controllerInstance))
         {
            ObjectUtils.disposeObject(this._controllerInstance);
         }
         this._controllerInstance = null;
      }
   }
}

