package shop.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import farm.viewx.shop.FarmShopPayPnl;
   import flash.display.DisplayObject;
   import shop.view.BuyMultiGoodsView;
   import shop.view.BuySingleGoodsView;
   
   public class ShopBuyManager
   {
      
      private static var _instance:ShopBuyManager;
      
      public static var crrItemId:int;
      
      public var view:DisplayObject;
      
      private var farmview:DisplayObject;
      
      public function ShopBuyManager()
      {
         super();
      }
      
      public static function get Instance() : ShopBuyManager
      {
         if(_instance == null)
         {
            _instance = new ShopBuyManager();
         }
         return _instance;
      }
      
      public static function calcPrices(list:Vector.<ShopCarItemInfo>) : Array
      {
         var totalPrice:ItemPrice = new ItemPrice(null,null,null);
         var g:int = 0;
         var m:int = 0;
         var l:int = 0;
         for(var i:int = 0; i < list.length; i++)
         {
            totalPrice.addItemPrice(list[i].getCurrentPrice());
         }
         g = totalPrice.goldValue;
         m = totalPrice.moneyValue;
         l = totalPrice.bandDdtMoneyValue;
         return [g,m,l];
      }
      
      public function buy($goodsID:int, isDiscount:int = 1, type:int = 1, isSale:Boolean = false) : void
      {
         this.view = new BuySingleGoodsView(type);
         LayerManager.Instance.addToLayer(this.view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         BuySingleGoodsView(this.view).isDisCount = isDiscount == 1 ? false : true;
         BuySingleGoodsView(this.view).isSale = isSale;
         BuySingleGoodsView(this.view).goodsID = $goodsID;
      }
      
      public function buyFarmShop($goodsID:int, $shopType:int = 88) : void
      {
         this.farmview = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopPayPnl.shopPay");
         FarmShopPayPnl(this.farmview).goodsID = $goodsID;
         FarmShopPayPnl(this.farmview).shopType = $shopType;
         LayerManager.Instance.addToLayer(this.farmview,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function buyAvatar(info:PlayerInfo) : void
      {
         var item:InventoryItemInfo = null;
         var shopitem:ShopItemInfo = null;
         var shopCarItem:ShopCarItemInfo = null;
         var items:Array = [];
         var buyArr:Vector.<ShopCarItemInfo> = new Vector.<ShopCarItemInfo>();
         if(Boolean(info.Bag.items[0]))
         {
            items.push(info.Bag.items[0]);
         }
         if(Boolean(info.Bag.items[1]))
         {
            items.push(info.Bag.items[1]);
         }
         if(Boolean(info.Bag.items[2]))
         {
            items.push(info.Bag.items[2]);
         }
         if(Boolean(info.Bag.items[3]))
         {
            items.push(info.Bag.items[3]);
         }
         if(Boolean(info.Bag.items[4]))
         {
            items.push(info.Bag.items[4]);
         }
         if(Boolean(info.Bag.items[5]))
         {
            items.push(info.Bag.items[5]);
         }
         if(Boolean(info.Bag.items[11]))
         {
            items.push(info.Bag.items[11]);
         }
         if(Boolean(info.Bag.items[13]))
         {
            items.push(info.Bag.items[13]);
         }
         for each(item in items)
         {
            shopitem = ShopManager.Instance.getMoneyShopItemByTemplateID(item.TemplateID,true);
            if(shopitem == null)
            {
               shopitem = ShopManager.Instance.getGiftShopItemByTemplateID(item.TemplateID,true);
            }
            if(shopitem != null)
            {
               shopCarItem = new ShopCarItemInfo(shopitem.GoodsID,shopitem.TemplateID);
               ObjectUtils.copyProperties(shopCarItem,shopitem);
               shopCarItem.Color = item.Color;
               shopCarItem.skin = item.Skin;
               buyArr.push(shopCarItem);
            }
         }
         if(buyArr.length == 0 || buyArr.length < items.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail"));
         }
         if(buyArr.length > 0)
         {
            this.buyMutiGoods(buyArr);
         }
      }
      
      public function buyMutiGoods(goods:Vector.<ShopCarItemInfo>) : void
      {
         this.view = new BuyMultiGoodsView();
         BuyMultiGoodsView(this.view).setGoods(goods);
         BuyMultiGoodsView(this.view).show();
      }
      
      public function get isShow() : Boolean
      {
         return Boolean(this.view) && Boolean(this.view.parent);
      }
      
      public function dispose() : void
      {
         if(Boolean(this.view) && Boolean(this.view.parent))
         {
            Disposeable(this.view).dispose();
            this.view = null;
         }
         if(Boolean(this.farmview) && Boolean(this.farmview.parent))
         {
            Disposeable(this.farmview).dispose();
            this.farmview = null;
         }
      }
   }
}

