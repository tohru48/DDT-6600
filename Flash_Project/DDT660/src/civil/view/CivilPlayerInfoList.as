package civil.view
{
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CivilPlayerInfoList extends Sprite implements Disposeable
   {
      
      private static const MAXITEM:int = 9;
      
      private var _currentItem:CivilPlayerItemFrame;
      
      private var _items:Vector.<CivilPlayerItemFrame>;
      
      private var _infoItems:Array;
      
      private var _list:VBox;
      
      private var _model:CivilModel;
      
      private var _selectedItem:CivilPlayerItemFrame;
      
      public function CivilPlayerInfoList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._infoItems = [];
         this._list = ComponentFactory.Instance.creatComponentByStylename("civil.memberList");
         addChild(this._list);
         this._items = new Vector.<CivilPlayerItemFrame>();
      }
      
      public function MemberList($list:Array) : void
      {
         var item:CivilPlayerItemFrame = null;
         this.clearList();
         if(!$list || $list.length == 0)
         {
            return;
         }
         var length:int = $list.length > MAXITEM ? MAXITEM : int($list.length);
         for(var i:int = 0; i < length; i++)
         {
            item = new CivilPlayerItemFrame(i);
            item.info = $list[i];
            item.addEventListener(MouseEvent.CLICK,this.__onItemClick);
            this._list.addChild(item);
            this._items.push(item);
            if(i == 0)
            {
               this.selectedItem = item;
            }
         }
      }
      
      public function clearList() : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(MouseEvent.CLICK,this.__onItemClick);
            ObjectUtils.disposeObject(this._items[i]);
            this._items[i] = null;
         }
         this._items = new Vector.<CivilPlayerItemFrame>();
         this._selectedItem = null;
         this._currentItem = null;
         this._infoItems = [];
      }
      
      public function upItem($info:CivilPlayerInfo) : void
      {
         var item:CivilPlayerItemFrame = null;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i] as CivilPlayerItemFrame;
            if(item.info.info.ID == $info.info.ID)
            {
               item.info = $info;
               break;
            }
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            if(this._model.hasEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE))
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      private function __civilListHandle(e:CivilEvent) : void
      {
         var i:int = 0;
         var item:CivilPlayerItemFrame = null;
         if(this._model.civilPlayers == null)
         {
            return;
         }
         this.clearList();
         var data:Array = this._model.civilPlayers;
         var length:int = data.length > MAXITEM ? MAXITEM : int(data.length);
         if(length <= 0)
         {
            this.selectedItem = null;
         }
         else
         {
            for(i = 0; i < length; i++)
            {
               item = new CivilPlayerItemFrame(i);
               item.info = data[i];
               this._list.addChild(item);
               this._items.push(item);
               if(i == 0)
               {
                  this.selectedItem = item;
               }
               item.addEventListener(MouseEvent.CLICK,this.__onItemClick);
            }
         }
      }
      
      private function __onItemClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:CivilPlayerItemFrame = evt.currentTarget as CivilPlayerItemFrame;
         if(!item.selected)
         {
            this.selectedItem = item;
         }
      }
      
      public function get selectedItem() : CivilPlayerItemFrame
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(val:CivilPlayerItemFrame) : void
      {
         var item:CivilPlayerItemFrame = null;
         if(this._selectedItem != val)
         {
            item = this._selectedItem;
            this._selectedItem = val;
            if(Boolean(this._selectedItem))
            {
               this._selectedItem.selected = true;
               this._model.currentcivilItemInfo = this._selectedItem.info;
            }
            else
            {
               this._model.currentcivilItemInfo = null;
            }
            if(Boolean(item))
            {
               item.selected = false;
            }
            dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE,val));
         }
      }
      
      public function get model() : CivilModel
      {
         return this._model;
      }
      
      public function set model(val:CivilModel) : void
      {
         if(this._model != val)
         {
            if(Boolean(this._model))
            {
               this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
            this._model = val;
            if(Boolean(this._model))
            {
               this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__civilListHandle);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         this.model = null;
         this._infoItems = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

