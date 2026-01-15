package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RoomListMapTipPanel extends Sprite implements Disposeable
   {
      
      public static const FB_CHANGE:String = "fbChange";
      
      private var _bg:ScaleBitmapImage;
      
      private var _listContent:VBox;
      
      private var _itemArray:Array;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      private var _list:ScrollPanel;
      
      private var _value:int;
      
      public function RoomListMapTipPanel(cellWidth:int, cellheight:int)
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
         this._value = 10000;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.tipItemBg");
         this._bg.width = this._cellWidth;
         this._bg.height = 0;
         addChild(this._bg);
         this._listContent = new VBox();
         this._itemArray = [];
         this._list = UICreatShortcut.creatAndAdd("asset.ddtroomList.RoomListMapTipPanel.SrollPanel",this);
         this._list.setView(this._listContent);
      }
      
      public function addItem(id:int) : void
      {
         var item:MapItemView = null;
         var size:Point = null;
         if(PathManager.solveDungeonOpenList && PathManager.solveDungeonOpenList.indexOf(String(id)) != -1 || id == 13 || id == 14)
         {
            item = new MapItemView(id,this._cellWidth,this._cellheight);
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._listContent.addChild(item);
            this._itemArray.push(item);
            size = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.RoomListMapTipPanel.BGSize");
            this._bg.width = size.x;
            this._bg.height = size.y;
            this._list.invalidateViewport();
         }
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         this._value = (event.target as MapItemView).id;
         dispatchEvent(new Event(FB_CHANGE));
         this.visible = false;
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            (this._itemArray[i] as MapItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[i] as MapItemView).dispose();
         }
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         ObjectUtils.disposeObject(this._listContent);
         this._listContent = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
      }
   }
}

