package store.view.shortcutBuy
{
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortcutBuyList extends Sprite implements Disposeable
   {
      
      private var _list:SimpleTileList;
      
      private var _cells:Vector.<ShortcutBuyCell>;
      
      private var _cow:int;
      
      public function ShortcutBuyList()
      {
         super();
      }
      
      public function setup(itemIDs:Array) : void
      {
         this._cow = Math.ceil(itemIDs.length / 4);
         this.init();
         this.createCells(itemIDs);
      }
      
      private function init() : void
      {
         this._cells = new Vector.<ShortcutBuyCell>();
         this._list = new SimpleTileList(4);
         this._list.hSpace = 30;
         this._list.vSpace = 40;
         addChild(this._list);
      }
      
      override public function get height() : Number
      {
         return this._list.height;
      }
      
      private function createCells(itemIDs:Array) : void
      {
         var info:ItemTemplateInfo = null;
         var cell:ShortcutBuyCell = null;
         this._list.beginChanges();
         for(var i:int = 0; i < itemIDs.length; i++)
         {
            info = ItemManager.Instance.getTemplateById(itemIDs[i]);
            cell = new ShortcutBuyCell(info);
            cell.info = info;
            cell.addEventListener(MouseEvent.CLICK,this.cellClickHandler);
            cell.buttonMode = true;
            cell.showBg();
            this._list.addChild(cell);
            this._cells.push(cell);
         }
         this._list.commitChanges();
      }
      
      public function shine() : void
      {
         var cell:ShortcutBuyCell = null;
         for each(cell in this._cells)
         {
            cell.hideBg();
            cell.startShine();
         }
      }
      
      public function noShine() : void
      {
         var cell:ShortcutBuyCell = null;
         for each(cell in this._cells)
         {
            cell.stopShine();
            cell.showBg();
         }
      }
      
      private function cellClickHandler(evt:MouseEvent) : void
      {
         var cell:ShortcutBuyCell = null;
         SoundManager.instance.play("008");
         for each(cell in this._cells)
         {
            cell.selected = false;
            this.noShine();
         }
         ShortcutBuyCell(evt.currentTarget).selected = true;
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function get selectedItemID() : int
      {
         var cell:ShortcutBuyCell = null;
         for each(cell in this._cells)
         {
            if(cell.selected)
            {
               return cell.info.TemplateID;
            }
         }
         return -1;
      }
      
      public function set selectedItemID(value:int) : void
      {
         var cell:ShortcutBuyCell = null;
         for each(cell in this._cells)
         {
            if(cell.info.TemplateID == value)
            {
               cell.selected = true;
               return;
            }
         }
      }
      
      public function set selectedIndex(value:int) : void
      {
         var i:int = 0;
         var tmpLength:int = int(this._cells.length);
         if(value >= 0 && value < tmpLength)
         {
            for(i = 0; i < tmpLength; i++)
            {
               if(i == value)
               {
                  this._cells[i].selected = true;
               }
               else
               {
                  this._cells[i].selected = false;
               }
            }
         }
      }
      
      public function get list() : SimpleTileList
      {
         return this._list;
      }
      
      public function dispose() : void
      {
         var cell:ShortcutBuyCell = null;
         for each(cell in this._cells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.cellClickHandler);
            ObjectUtils.disposeObject(cell);
         }
         this._cells = null;
         this._list.disposeAllChildren();
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

