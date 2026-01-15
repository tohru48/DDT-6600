package gypsyShop.model
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.GypsyShopEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import gypsyShop.I.IGypsyShopViewModel;
   import gypsyShop.ctrl.GypsyShopManager;
   
   public class GypsyShopModel extends EventDispatcher implements IGypsyShopViewModel
   {
      
      private static var instance:GypsyShopModel;
      
      private var _curRefreshedTimes:int;
      
      private var _itemCount:int;
      
      private var _itemDataList:Vector.<GypsyItemData>;
      
      private var _buyResult:Object;
      
      private var _listRareItemTempleteIDs:Vector.<int>;
      
      public function GypsyShopModel(single:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyShopModel
      {
         if(!instance)
         {
            instance = new GypsyShopModel(new inner());
         }
         return instance;
      }
      
      public function requestManualRefreshList() : void
      {
         GameInSocketOut.sendGypsyManualRefreshItemList();
      }
      
      public function requestBuyItem(id:int) : void
      {
         GameInSocketOut.sendGypsyBuy(id,GypsyPurchaseModel.getInstance().getUseBind());
      }
      
      public function requestRareList() : void
      {
         GameInSocketOut.sendGypsyRefreshRareList();
      }
      
      public function requestRefreshList() : void
      {
         GameInSocketOut.sendGypsyRefreshItemList();
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(GypsyShopEvent.GOT_NEW_ITEM_LIST,this.onItemListUpdated);
         SocketManager.Instance.addEventListener(GypsyShopEvent.ON_BUY_RESULT,this.onBuyResult);
         SocketManager.Instance.addEventListener(GypsyShopEvent.ON_RARE_ITEM_UPDATED,this.onRareItemListUpdated);
      }
      
      protected function onRareItemListUpdated(e:GypsyShopEvent) : void
      {
         var templeteID:int = 0;
         var bytes:ByteArray = e.data;
         var rareItemNum:int = bytes.readInt();
         this._listRareItemTempleteIDs = new Vector.<int>();
         while(Boolean(bytes.bytesAvailable))
         {
            templeteID = bytes.readInt();
            this._listRareItemTempleteIDs.push(templeteID);
         }
         GypsyShopManager.getInstance().newRareItemsUpdate();
      }
      
      protected function onBuyResult(e:GypsyShopEvent) : void
      {
         var _canBuy:int = 0;
         var bytes:ByteArray = e.data;
         var _id:int = bytes.readInt();
         var _isSucc:Boolean = bytes.readBoolean();
         this._buyResult = null;
         if(_isSucc)
         {
            _canBuy = bytes.readInt();
            this._buyResult = {
               "id":_id,
               "canBuy":_canBuy
            };
            GypsyShopManager.getInstance().updateBuyResult();
         }
      }
      
      protected function onItemListUpdated(e:GypsyShopEvent) : void
      {
         var id:int = 0;
         var unit:int = 0;
         var price:int = 0;
         var num:int = 0;
         var templeteID:int = 0;
         var canBuy:int = 0;
         var bytes:ByteArray = e.data;
         this._curRefreshedTimes = bytes.readInt();
         this._itemCount = bytes.readInt();
         this._itemDataList = new Vector.<GypsyItemData>();
         while(bytes.bytesAvailable > 0)
         {
            id = bytes.readInt();
            unit = bytes.readInt();
            price = bytes.readInt();
            num = bytes.readInt();
            templeteID = bytes.readInt();
            canBuy = bytes.readInt();
            this._itemDataList.push(new GypsyItemData(id,unit,price,templeteID,num,canBuy));
         }
         GypsyShopManager.getInstance().newItemListUpdate();
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(GypsyShopEvent.GOT_NEW_ITEM_LIST,this.onItemListUpdated);
         SocketManager.Instance.removeEventListener(GypsyShopEvent.ON_BUY_RESULT,this.onBuyResult);
         SocketManager.Instance.removeEventListener(GypsyShopEvent.ON_RARE_ITEM_UPDATED,this.onRareItemListUpdated);
      }
      
      public function getNeedMoneyTotal() : int
      {
         return this._curRefreshedTimes * this._curRefreshedTimes * 30 + 500;
      }
      
      public function getUpdateTime() : String
      {
         return null;
      }
      
      public function getRareItemsList() : Vector.<InventoryItemInfo>
      {
         return null;
      }
      
      public function getHonour() : int
      {
         return 0;
      }
      
      public function get itemCount() : int
      {
         return this._itemCount;
      }
      
      public function get curRefreshedTimes() : int
      {
         return this._curRefreshedTimes;
      }
      
      public function get itemDataList() : Vector.<GypsyItemData>
      {
         return this._itemDataList;
      }
      
      public function get buyResult() : Object
      {
         return this._buyResult;
      }
      
      public function get listRareItemTempleteIDs() : Vector.<int>
      {
         return this._listRareItemTempleteIDs;
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
