package AvatarCollection
{
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionItemVo;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.ShopType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionManager extends EventDispatcher
   {
      
      private static var _instance:AvatarCollectionManager;
      
      public static const REFRESH_VIEW:String = "avatar_collection_refresh_view";
      
      public static const DATA_COMPLETE:String = "avatar_collection_data_complete";
      
      public var isDataComplete:Boolean;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _maleUnitList:Array;
      
      private var _femaleUnitList:Array;
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      private var _maleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _femaleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _isHasCheckedBuy:Boolean = false;
      
      public var isCheckedAvatarTime:Boolean = false;
      
      public var isSkipFromHall:Boolean = false;
      
      public var skipId:int;
      
      public var skipIdArray:Array;
      
      public var skipFlag:Boolean;
      
      public function AvatarCollectionManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : AvatarCollectionManager
      {
         if(_instance == null)
         {
            _instance = new AvatarCollectionManager();
         }
         return _instance;
      }
      
      public function get maleUnitList() : Array
      {
         return this._maleUnitList;
      }
      
      public function get femaleUnitList() : Array
      {
         return this._femaleUnitList;
      }
      
      public function getItemListById(sex:int, id:int) : Array
      {
         if(sex == 1)
         {
            return this._maleItemDic[id].list;
         }
         return this._femaleItemDic[id].list;
      }
      
      public function unitListDataSetup(analyzer:AvatarCollectionUnitDataAnalyzer) : void
      {
         this._maleUnitDic = analyzer.maleUnitDic;
         this._femaleUnitDic = analyzer.femaleUnitDic;
         this._maleUnitList = this._maleUnitDic.list;
         this._femaleUnitList = this._femaleUnitDic.list;
      }
      
      public function itemListDataSetup(analyzer:AvatarCollectionItemDataAnalyzer) : void
      {
         this._maleItemDic = analyzer.maleItemDic;
         this._femaleItemDic = analyzer.femaleItemDic;
         this._maleItemList = analyzer.maleItemList;
         this._femaleItemList = analyzer.femaleItemList;
      }
      
      public function initShopItemInfoList() : void
      {
         var maleTypeArray:Array = null;
         var tmplen:int = 0;
         var i:int = 0;
         var femaleTypeArray:Array = null;
         var tmplen2:int = 0;
         var k:int = 0;
         if(!this._maleShopItemInfoList)
         {
            this._maleShopItemInfoList = new Vector.<ShopItemInfo>();
            maleTypeArray = [ShopType.MONEY_M_CLOTH,ShopType.MONEY_M_HAT,ShopType.MONEY_M_GLASS,ShopType.MONEY_M_HAIR,ShopType.MONEY_M_EYES,ShopType.MONEY_M_LIANSHI,ShopType.MONEY_M_WING];
            tmplen = int(maleTypeArray.length);
            for(i = 0; i < tmplen; i++)
            {
               this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(maleTypeArray[i]));
            }
            this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
         if(!this._femaleShopItemInfoList)
         {
            this._femaleShopItemInfoList = new Vector.<ShopItemInfo>();
            femaleTypeArray = [ShopType.MONEY_F_CLOTH,ShopType.MONEY_F_HAT,ShopType.MONEY_F_GLASS,ShopType.MONEY_F_HAIR,ShopType.MONEY_F_EYES,ShopType.MONEY_F_LIANSHI,ShopType.MONEY_F_WING];
            tmplen2 = int(femaleTypeArray.length);
            for(k = 0; k < tmplen2; k++)
            {
               this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(femaleTypeArray[k]));
            }
            this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
      }
      
      public function checkItemCanBuy() : void
      {
         var tmpItem:AvatarCollectionItemVo = null;
         var tmpItem2:AvatarCollectionItemVo = null;
         var tmpShopItem:ShopItemInfo = null;
         var tmpShopItem2:ShopItemInfo = null;
         if(this._isHasCheckedBuy)
         {
            return;
         }
         for each(tmpItem in this._maleItemList)
         {
            tmpItem.canBuyStatus = 0;
            for each(tmpShopItem in this._maleShopItemInfoList)
            {
               if(tmpItem.itemId == tmpShopItem.TemplateID)
               {
                  tmpItem.canBuyStatus = 1;
                  tmpItem.buyPrice = tmpShopItem.getItemPrice(1).moneyValue;
                  tmpItem.isDiscount = tmpShopItem.isDiscount;
                  tmpItem.goodsId = tmpShopItem.GoodsID;
                  break;
               }
            }
         }
         for each(tmpItem2 in this._femaleItemList)
         {
            tmpItem2.canBuyStatus = 0;
            for each(tmpShopItem2 in this._femaleShopItemInfoList)
            {
               if(tmpItem2.itemId == tmpShopItem2.TemplateID)
               {
                  tmpItem2.canBuyStatus = 1;
                  tmpItem2.buyPrice = tmpShopItem2.getItemPrice(1).moneyValue;
                  tmpItem2.isDiscount = tmpShopItem2.isDiscount;
                  tmpItem2.goodsId = tmpShopItem2.GoodsID;
                  break;
               }
            }
         }
         this._isHasCheckedBuy = true;
      }
      
      public function getShopItemInfoByItemId(itemId:int, sex:int) : ShopItemInfo
      {
         var tmpItemList:Vector.<ShopItemInfo> = null;
         var tmp:ShopItemInfo = null;
         if(sex == 1)
         {
            tmpItemList = this._maleShopItemInfoList;
         }
         else
         {
            tmpItemList = this._femaleShopItemInfoList;
         }
         for each(tmp in tmpItemList)
         {
            if(itemId == tmp.TemplateID)
            {
               return tmp;
            }
         }
         return null;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AVATAR_COLLECTION,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case AvatarCollectionPackageType.GET_ALL_INFO:
               this.getAllInfoHandler(pkg);
               break;
            case AvatarCollectionPackageType.ACTIVE:
               this.activeHandler(pkg);
               break;
            case AvatarCollectionPackageType.DELAY_TIME:
               this.delayTimeHandler(pkg);
         }
      }
      
      private function getAllInfoHandler(pkg:PackageIn) : void
      {
         var id:int = 0;
         var sex:int = 0;
         var unitVo:AvatarCollectionUnitVo = null;
         var itemVoDic:DictionaryData = null;
         var itemCount:int = 0;
         var k:int = 0;
         var itemId:int = 0;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            sex = pkg.readInt();
            if(sex == 1)
            {
               unitVo = this._maleUnitDic[id];
               itemVoDic = this._maleItemDic[id];
            }
            else
            {
               unitVo = this._femaleUnitDic[id];
               itemVoDic = this._femaleItemDic[id];
            }
            itemCount = pkg.readInt();
            for(k = 0; k < itemCount; k++)
            {
               itemId = pkg.readInt();
               if(Boolean(itemVoDic[itemId]))
               {
                  (itemVoDic[itemId] as AvatarCollectionItemVo).isActivity = true;
               }
            }
            unitVo.endTime = pkg.readDate();
         }
         this.isDataComplete = true;
         dispatchEvent(new Event(DATA_COMPLETE));
      }
      
      private function activeHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var itemId:int = pkg.readInt();
         var sex:int = pkg.readInt();
         if(sex == 1)
         {
            (this._maleItemDic[id][itemId] as AvatarCollectionItemVo).isActivity = true;
         }
         else
         {
            (this._femaleItemDic[id][itemId] as AvatarCollectionItemVo).isActivity = true;
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      private function delayTimeHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var sex:int = pkg.readInt();
         if(sex == 1)
         {
            (this._maleUnitDic[id] as AvatarCollectionUnitVo).endTime = pkg.readDate();
         }
         else
         {
            (this._femaleUnitDic[id] as AvatarCollectionUnitVo).endTime = pkg.readDate();
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      public function loadResModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.AVATAR_COLLECTION);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.AVATAR_COLLECTION)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.AVATAR_COLLECTION)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

