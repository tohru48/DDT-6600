package farm.view.compose.item
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import shop.view.ShopItemCell;
   
   public class FarmHouseItem extends Sprite implements Disposeable
   {
      
      public static const HOUSE_ITEM_WIDTH:int = 72;
      
      protected var _itemBg:DisplayObject;
      
      private var _itemCell:ShopItemCell;
      
      private var _index:int;
      
      private var _info:InventoryItemInfo;
      
      private var _count:FilterFrameText;
      
      public function FarmHouseItem(index:int = -1)
      {
         super();
         this._index = index;
         this.initContent();
      }
      
      protected function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creat("asset.farm.baseImage5");
         addChild(this._itemBg);
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,62,62);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 50;
         addChild(this._itemCell);
         this._count = ComponentFactory.Instance.creatComponentByStylename("farm.housepnl.count");
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set info(info:InventoryItemInfo) : void
      {
         if(this._info == info)
         {
            return;
         }
         this._info = info;
         this._itemCell.info = info;
         if(Boolean(this._info))
         {
            this._count.text = this._info.Count.toString();
            addChild(this._count);
         }
         else
         {
            this._count.text = "";
         }
      }
      
      public function dispose() : void
      {
         this._info = null;
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

