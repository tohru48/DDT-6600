package playerDress
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   import playerDress.data.PlayerDressEvent;
   import playerDress.views.DressBagView;
   import playerDress.views.PlayerDressView;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class PlayerDressManager
   {
      
      private static var _instance:PlayerDressManager;
      
      public var currentIndex:int;
      
      public var modelArr:Array = [];
      
      private var _funcArr:Array;
      
      private var _funcParamsArr:Array;
      
      private var _dressView:PlayerDressView;
      
      private var _dressBag:DressBagView;
      
      public var showBind:Boolean = true;
      
      public function PlayerDressManager()
      {
         super();
         this._funcArr = [];
         this._funcParamsArr = [];
      }
      
      public static function get instance() : PlayerDressManager
      {
         if(!_instance)
         {
            _instance = new PlayerDressManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(PlayerDressEvent.GET_DRESS_MODEL,this.setDressModelArr);
         SocketManager.Instance.addEventListener(PlayerDressEvent.CURRENT_MODEL,this.setCurrentModel);
         SocketManager.Instance.addEventListener(PlayerDressEvent.LOCK_DRESSBAG,this.unlockDressBag);
      }
      
      protected function setCurrentModel(event:PlayerDressEvent) : void
      {
         var items:DictionaryData = null;
         var arr:Array = null;
         var i:int = 0;
         var item:InventoryItemInfo = null;
         var pkg:PackageIn = event.pkg;
         this.currentIndex = pkg.readInt();
         if(this.currentIndex == -1)
         {
            SocketManager.Instance.out.setCurrentModel(0);
            items = PlayerManager.Instance.Self.Bag.items;
            arr = [];
            for(i = 0; i <= DressModel.DRESS_LEN - 1; i++)
            {
               item = items[DressUtils.getBagItems(i)];
               if(Boolean(item))
               {
                  arr.push(item.Place);
               }
            }
            SocketManager.Instance.out.saveDressModel(0,arr);
         }
      }
      
      protected function setDressModelArr(event:PlayerDressEvent) : void
      {
         var modelId:int = 0;
         var dressCount:int = 0;
         var dressArr:Array = null;
         var j:int = 0;
         var vo:DressVo = null;
         var pkg:PackageIn = event.pkg;
         var modelCount:int = pkg.readInt();
         for(var i:int = 0; i <= modelCount - 1; i++)
         {
            modelId = pkg.readInt();
            dressCount = pkg.readInt();
            dressArr = [];
            for(j = 0; j <= dressCount - 1; j++)
            {
               vo = new DressVo();
               vo.itemId = pkg.readInt();
               vo.templateId = pkg.readInt();
               dressArr.push(vo);
            }
            this.modelArr[modelId] = dressArr;
         }
         if(Boolean(this.dressView))
         {
            this.dressView.setBtnsStatus();
         }
      }
      
      protected function unlockDressBag(event:PlayerDressEvent) : void
      {
         if(Boolean(this._dressBag))
         {
            this._dressBag.baglist.unlockBag();
         }
         SocketManager.Instance.out.sendModifyNewPlayerDress();
         SocketManager.Instance.dispatchEvent(new PlayerDressEvent(PlayerDressEvent.UPDATE_PLAYERINFO));
      }
      
      public function lockDressBag() : void
      {
         if(Boolean(this._dressBag))
         {
            this._dressBag.baglist.locked = true;
         }
      }
      
      public function loadPlayerDressModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._funcArr.push(complete);
         this._funcParamsArr.push(completeParams);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PLAYER_DRESS);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.PLAYER_DRESS)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         var i:int = 0;
         if(event.module == UIModuleTypes.PLAYER_DRESS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            for(i = 0; i <= this._funcArr.length - 1; i++)
            {
               (this._funcArr[i] as Function).apply(null,this._funcParamsArr[i]);
            }
            this._funcArr = [];
            this._funcParamsArr = [];
         }
      }
      
      public function putOnDress(item:InventoryItemInfo) : void
      {
         this._dressView.putOnDress(item);
      }
      
      public function set dressView(value:PlayerDressView) : void
      {
         this._dressView = value;
      }
      
      public function set dressBag(value:DressBagView) : void
      {
         this._dressBag = value;
      }
      
      public function get dressView() : PlayerDressView
      {
         return this._dressView;
      }
      
      public function dispose() : void
      {
         this._dressView = null;
         this._dressBag = null;
      }
   }
}

