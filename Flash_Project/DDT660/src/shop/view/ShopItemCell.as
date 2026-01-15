package shop.view
{
   import bagAndInfo.cell.BaseCell;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ShopItemCell extends BaseCell
   {
      
      private var _shopItemInfo:ShopCarItemInfo;
      
      protected var _cellSize:uint = 60;
      
      public function ShopItemCell(bg:DisplayObject, info:ItemTemplateInfo = null, showLoading:Boolean = true, showTip:Boolean = true)
      {
         super(bg,info,showLoading,showTip);
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(value:ShopCarItemInfo) : void
      {
         this._shopItemInfo = value;
      }
      
      public function set cellSize(value:uint) : void
      {
         this._cellSize = value;
         this.updateSize(_pic);
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         var scale:Number = NaN;
         PositionUtils.setPos(sp,"ddtshop.ItemCellStartPos");
         if(sp.height >= this._cellSize && this._cellSize >= sp.width || sp.height >= sp.width && sp.width >= this._cellSize || this._cellSize >= sp.height && sp.height >= sp.width)
         {
            scale = sp.height / this._cellSize;
         }
         else
         {
            scale = sp.width / this._cellSize;
         }
         sp.height /= scale;
         sp.width /= scale;
         sp.x += (this._cellSize - sp.width) / 2;
         sp.y += (this._cellSize - sp.height) / 2;
      }
      
      override protected function updateSizeII(sp:Sprite) : void
      {
         sp.height = 70;
         sp.width = 70;
         PositionUtils.setPos(sp,"ddtshop.ItemCellStartPos");
      }
      
      override protected function createLoading() : void
      {
         super.createLoading();
         this.updateSize(_loadingasset);
      }
      
      public function set tipInfo(value:ShopItemInfo) : void
      {
         if(!value)
         {
            return;
         }
         tipData = value;
      }
      
      override public function dispose() : void
      {
         this._shopItemInfo = null;
         super.dispose();
      }
   }
}

