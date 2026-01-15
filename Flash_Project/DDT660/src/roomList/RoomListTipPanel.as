package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RoomListTipPanel extends Sprite implements Disposeable
   {
      
      public static const HARD_LV_CHANGE:String = "hardLvChange";
      
      private var _bg:ScaleBitmapImage;
      
      private var _list:VBox;
      
      private var _itemArray:Array;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      private var _value:int;
      
      public function RoomListTipPanel(cellWidth:int, cellheight:int)
      {
         this._cellWidth = cellWidth;
         this._cellheight = cellheight;
         super();
         this.init();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function resetValue() : void
      {
         this._value = LookupEnumerate.DUNGEON_LIST_ALL;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.tipItemBg");
         this._bg.width = this._cellWidth;
         this._bg.height = 0;
         addChild(this._bg);
         this._list = new VBox();
         addChild(this._list);
         this._itemArray = [];
      }
      
      public function addItem(itemBg:Bitmap, value:int) : void
      {
         var item:TipItemView = new TipItemView(itemBg,value,this._cellWidth,this._cellheight);
         item.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._list.addChild(item);
         this._itemArray.push(item);
         this._bg.height += this._cellheight + 1;
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         this._value = (event.target as TipItemView).value;
         dispatchEvent(new Event(HARD_LV_CHANGE));
         this.visible = false;
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            (this._itemArray[i] as TipItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[i] as TipItemView).dispose();
         }
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         if(Boolean(this._list) && Boolean(this._list.parent))
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._bg) && Boolean(this._bg.parent))
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

