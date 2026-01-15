package chickActivation.view
{
   import bagAndInfo.cell.BagCell;
   import chickActivation.ChickActivationManager;
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Sprite;
   
   public class ChickActivationItems extends Sprite implements Disposeable
   {
      
      private var _arrData:Array;
      
      private var _items:Sprite;
      
      private var _itemsPanel:ScrollPanel;
      
      public function ChickActivationItems()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemsPanel = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.itemsScrollPanel");
         addChild(this._itemsPanel);
         this._items = new Sprite();
         this._itemsPanel.setView(this._items);
         this._itemsPanel.invalidateViewport();
      }
      
      public function update($arr:Array) : void
      {
         this._arrData = $arr;
         this.updateView();
         this._itemsPanel.invalidateViewport();
      }
      
      private function updateView() : void
      {
         var i:int = 0;
         var _cell:BagCell = null;
         ObjectUtils.disposeAllChildren(this._items);
         if(Boolean(this._arrData))
         {
            for(i = 0; i < this._arrData.length; i++)
            {
               _cell = this.createCell(this._arrData[i]);
               _cell.x = i % 5 * 105;
               _cell.y = int(i / 5) * 80 + 5;
               this._items.addChild(_cell);
            }
         }
      }
      
      private function createCell($info:ChickActivationInfo) : BagCell
      {
         var itemInfo:InventoryItemInfo = ChickActivationManager.instance.model.getInventoryItemInfo($info);
         if(itemInfo == null)
         {
            return null;
         }
         var _cell:BagCell = new BagCell(0,itemInfo,true,ComponentFactory.Instance.creatBitmap("assets.chickActivation.itemBg"));
         _cell.width = 64;
         _cell.height = 64.1;
         _cell.setCount(itemInfo.Count);
         return _cell;
      }
      
      public function get arrData() : Array
      {
         return this._arrData;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._items))
         {
            ObjectUtils.disposeAllChildren(this._items);
            ObjectUtils.disposeObject(this._items);
            this._items = null;
         }
         ObjectUtils.disposeObject(this._itemsPanel);
         this._itemsPanel = null;
         this._arrData = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

