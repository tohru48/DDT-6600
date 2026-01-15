package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import flash.geom.Point;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistOrderList extends Sprite implements Disposeable
   {
      
      private var _currenItem:TofflistOrderItem;
      
      private var _items:Vector.<TofflistOrderItem>;
      
      private var _list:VBox;
      
      public function TofflistOrderList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         this.clearList();
         this._items = null;
         ObjectUtils.disposeObject(this._currenItem);
         this._currenItem = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
      }
      
      public function items($list:Array, page:int = 1) : void
      {
         var item:TofflistOrderItem = null;
         var currentItem:TofflistOrderItem = null;
         this.clearList();
         if(!$list || $list.length == 0)
         {
            return;
         }
         var length:int = $list.length > page * 8 ? page * 8 : int($list.length);
         for(var i:int = (page - 1) * 8; i < length; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("tofflist.orderItem");
            item.index = i + 1;
            item.info = $list[i];
            this._list.addChild(item);
            this._items.push(item);
            item.addEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT,this.__itemChange);
         }
         if(this._list.getChildAt(0) is TofflistOrderItem)
         {
            currentItem = this._list.getChildAt(0) as TofflistOrderItem;
            currentItem.isSelect = true;
         }
         else
         {
            TofflistModel.currentText = "";
            TofflistModel.currentIndex = 0;
            TofflistModel.currentPlayerInfo = null;
         }
      }
      
      public function showHline(points:Vector.<Point>) : void
      {
         var item:TofflistOrderItem = null;
         for each(item in this._items)
         {
            item.showHLine(points);
         }
      }
      
      private function __itemChange(evt:TofflistEvent) : void
      {
         if(Boolean(this._currenItem))
         {
            this._currenItem.isSelect = false;
         }
         this._currenItem = evt.data as TofflistOrderItem;
         TofflistModel.currentConsortiaInfo = this._currenItem.consortiaInfo;
         TofflistModel.currentText = this._currenItem.currentText;
         TofflistModel.currentIndex = this._currenItem.index;
         TofflistModel.mountsLevelInfo = this._currenItem.MountsLevel;
         TofflistModel.currentPlayerInfo = this._currenItem.info as PlayerInfo;
      }
      
      private function addEvent() : void
      {
      }
      
      public function clearList() : void
      {
         var item:TofflistOrderItem = null;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i] as TofflistOrderItem;
            item.removeEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT,this.__itemChange);
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._items = new Vector.<TofflistOrderItem>();
         this._currenItem = null;
         TofflistModel.currentText = "";
         TofflistModel.currentIndex = 0;
         TofflistModel.currentPlayerInfo = null;
      }
      
      private function init() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("tofflist.orderlist.vboxContainer");
         addChild(this._list);
         this._items = new Vector.<TofflistOrderItem>();
      }
   }
}

