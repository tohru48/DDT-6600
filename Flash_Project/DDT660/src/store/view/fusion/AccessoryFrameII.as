package store.view.fusion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import store.events.StoreIIEvent;
   
   public class AccessoryFrameII extends Frame
   {
      
      private var _list:SimpleTileList;
      
      private var _bg:Shape;
      
      private var _items:Array;
      
      private var _area:AccessoryDragInArea;
      
      public function AccessoryFrameII()
      {
         super();
         this.initII();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("store.view.fusion.AccessoryFrame.add");
         this._bg = new Shape();
         this._bg.graphics.lineStyle(1,16777215);
         this._bg.graphics.beginFill(7760227,1);
         this._bg.graphics.drawRect(0,0,224,172);
         this._bg.graphics.endFill();
         addToContent(this._bg);
         this._list = new SimpleTileList(3);
         addToContent(this._list);
         this._items = new Array();
         this.initList();
      }
      
      private function initList() : void
      {
         var item:Bitmap = null;
         var cell:AccessoryItemCell = null;
         this.clearList();
         for(var i:int = 5; i < 11; i++)
         {
            item = ComponentFactory.Instance.creatBitmap("asset.ddtstore.FusionGoodsiBG");
            cell = new AccessoryItemCell(i);
            cell.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items.push(cell);
            this._list.addChild(item);
         }
         this._area = new AccessoryDragInArea(this._items);
         this._list.parent.addChildAt(this._area,0);
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.ITEM_CLICK));
      }
      
      public function clearList() : void
      {
         var cell:AccessoryItemCell = null;
         this._list.disposeAllChildren();
         for(var i:int = 0; i < this._items.length; i++)
         {
            cell = this._items[i] as AccessoryItemCell;
            cell.removeEventListener(Event.CHANGE,this.__itemInfoChange);
            cell.dispose();
         }
         this._items = new Array();
      }
      
      public function get isBinds() : Boolean
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(Boolean(this._items[i]) && Boolean(this._items[i].info) && Boolean(this._items[i].info.IsBinds))
            {
               return true;
            }
         }
         return false;
      }
      
      public function setItemInfo(index:int, info:ItemTemplateInfo) : void
      {
         this._items[index - 5].info = info;
      }
      
      public function listEmpty() : void
      {
         var cell:AccessoryItemCell = null;
         for(var i:int = 0; i < this._items.length; i++)
         {
            cell = this._items[i] as AccessoryItemCell;
         }
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function getCount() : Number
      {
         var count:Number = 0;
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i] != null && this._items[i].info != null)
            {
               count++;
            }
         }
         return count;
      }
      
      public function containsItem(item:InventoryItemInfo) : Boolean
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i] != null && this._items[i].itemInfo == item)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getAllAccessory() : Array
      {
         var data1:Array = null;
         var data:Array = new Array();
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i] != null && this._items[i].info != null)
            {
               data1 = new Array();
               data1.push(this._items[i].info.BagType);
               data1.push(this._items[i].place);
               data.push(data1);
            }
         }
         return data;
      }
      
      override public function dispose() : void
      {
         this.clearList();
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

