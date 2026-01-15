package kingDivision.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import shop.view.ShopItemCell;
   
   public class RewardGoodsListItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemCell:BagCell;
      
      public function RewardGoodsListItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.rewardView.goodsbg");
         this._itemCell = new BagCell(0,null,true,this._bg);
         this._itemCell.buttonMode = true;
         this._itemCell.width = 47;
         this._itemCell.height = 47;
         PositionUtils.setPos(this._itemCell,"rewardGoodsListItem.cellPos");
         addChild(this._bg);
         addChild(this._itemCell);
      }
      
      public function goodsInfo(value:int, ac:int, dc:int, agc:int, lc:int, count:int, isBind:Boolean, validDate:int) : void
      {
         var itemInfo:InventoryItemInfo = null;
         itemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = value;
         ItemManager.fill(itemInfo);
         itemInfo.AttackCompose = ac;
         itemInfo.DefendCompose = dc;
         itemInfo.AgilityCompose = agc;
         itemInfo.LuckCompose = lc;
         itemInfo.Count = count;
         itemInfo.IsBinds = isBind;
         itemInfo.ValidDate = validDate;
         this._itemCell.info = itemInfo;
         if(itemInfo.Count > 1)
         {
            this._itemCell.setCount(itemInfo.Count);
         }
         else
         {
            this._itemCell.setCountNotVisible();
         }
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,46,46);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemCell = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

