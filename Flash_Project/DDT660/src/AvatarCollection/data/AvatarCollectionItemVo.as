package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   
   public class AvatarCollectionItemVo
   {
      
      public var id:int;
      
      public var itemId:int;
      
      public var sex:int;
      
      public var proArea:String;
      
      public var needGold:int;
      
      public var isActivity:Boolean;
      
      public var buyPrice:int = -1;
      
      public var isDiscount:int = -1;
      
      public var goodsId:int = -1;
      
      private var _canBuyStatus:int = -1;
      
      public function AvatarCollectionItemVo()
      {
         super();
      }
      
      public function get isHas() : Boolean
      {
         var equipBag:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.EQUIPBAG);
         return Boolean(equipBag.getItemByTemplateId(this.itemId));
      }
      
      public function get itemInfo() : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(this.itemId);
      }
      
      public function get canBuyStatus() : int
      {
         var tmp:ShopItemInfo = null;
         if(this._canBuyStatus == -1)
         {
            tmp = AvatarCollectionManager.instance.getShopItemInfoByItemId(this.itemId,this.sex);
            if(Boolean(tmp))
            {
               this._canBuyStatus = 1;
               this.buyPrice = tmp.getItemPrice(1).moneyValue;
               this.isDiscount = tmp.isDiscount;
               this.goodsId = tmp.GoodsID;
            }
            else
            {
               this._canBuyStatus = 0;
            }
         }
         return this._canBuyStatus;
      }
      
      public function set canBuyStatus(value:int) : void
      {
         this._canBuyStatus = value;
      }
   }
}

