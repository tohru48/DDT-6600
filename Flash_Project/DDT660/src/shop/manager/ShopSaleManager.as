package shop.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.ShopType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import shop.view.ShopSaleFrame;
   
   public class ShopSaleManager
   {
      
      private static var _instance:ShopSaleManager;
      
      private var _shopSaleList:Vector.<ShopItemInfo>;
      
      private var _oldGoodsList:Vector.<ShopItemInfo>;
      
      private var _goodsBuyMaxNum:int = 0;
      
      private var _view:ShopSaleFrame;
      
      public var isOpenIcon:Boolean;
      
      public function ShopSaleManager()
      {
         super();
         this._shopSaleList = ShopManager.Instance.getValidGoodByType(ShopType.SALE_SHOP);
         this._oldGoodsList = ShopManager.Instance.getValidGoodByType(ShopType.SHOP_PAST_PRICE);
      }
      
      public static function get Instance() : ShopSaleManager
      {
         if(_instance == null)
         {
            _instance = new ShopSaleManager();
         }
         return _instance;
      }
      
      public function checkOpenShopSale() : void
      {
         if(this.isOpenIcon)
         {
            if(!this.isOpen)
            {
               this.removeEnterIcon();
            }
            else
            {
               this.checkStaleDatedShop();
            }
         }
         else if(this.isOpen)
         {
            this.addEnterIcon();
         }
      }
      
      public function get isOpen() : Boolean
      {
         if(this._shopSaleList.length > 0)
         {
            return this._shopSaleList[0].isValid;
         }
         return false;
      }
      
      public function addEnterIcon() : void
      {
         this.isOpenIcon = true;
         HallIconManager.instance.updateSwitchHandler(HallIconType.SALESHOP,this.isOpenIcon);
      }
      
      public function removeEnterIcon() : void
      {
         this.isOpenIcon = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.SALESHOP,this.isOpenIcon);
         if(Boolean(this._view))
         {
            this._view.dispose();
            this._view = null;
         }
      }
      
      public function get shopSaleList() : Vector.<ShopItemInfo>
      {
         return this._shopSaleList;
      }
      
      public function getGoodsOldPriceByID(value:int) : int
      {
         var i:ShopItemInfo = null;
         for each(i in this._oldGoodsList)
         {
            if(i.TemplateID == value)
            {
               return i.getItemPrice(1).moneyValue;
            }
         }
         return 0;
      }
      
      public function set goodsBuyMaxNum(value:int) : void
      {
         this._goodsBuyMaxNum = value;
      }
      
      public function get goodsBuyMaxNum() : int
      {
         return this._goodsBuyMaxNum;
      }
      
      private function createSaleFrame() : void
      {
         this._view = ComponentFactory.Instance.creat("ddtshop.view.ShopSaleFrame");
         this._view.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onFrameClose(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this._view.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._view.dispose();
            this._view = null;
         }
      }
      
      private function checkStaleDatedShop() : void
      {
         var copyShopSaleList:Vector.<ShopItemInfo> = null;
         var item:ShopItemInfo = null;
         if(Boolean(this._view))
         {
            copyShopSaleList = new Vector.<ShopItemInfo>();
            for each(item in this._shopSaleList)
            {
               if(item.isValid)
               {
                  copyShopSaleList.push(item);
               }
            }
            if(this._shopSaleList.length == copyShopSaleList.length)
            {
               return;
            }
            this._shopSaleList = copyShopSaleList;
            this._view.updateSaleGoods();
         }
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSHOP);
      }
      
      private function _onLoadingCloseHandle(e:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleSmallLoading.Instance.hide();
      }
      
      private function __onLoadComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.DDTSHOP)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            this.createSaleFrame();
         }
      }
      
      private function __onProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.DDTSHOP)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
   }
}

