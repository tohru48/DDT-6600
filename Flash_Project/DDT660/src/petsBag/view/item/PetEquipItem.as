package petsBag.view.item
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import petsBag.PetsBagManager;
   import petsBag.view.ShowPet;
   
   public class PetEquipItem extends Sprite
   {
      
      private var _back:Bitmap;
      
      private var _cell:BagCell;
      
      public var id:int;
      
      private var _shiner:ShineObject;
      
      public function PetEquipItem(type:int)
      {
         super();
         this.initView(type);
      }
      
      private function initView(type:int) : void
      {
         this._back = ComponentFactory.Instance.creat("assets.petsBag.equip" + String(type));
         addChild(this._back);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.petBagSystem.cellShine"));
         this._shiner.x = -5;
         this._shiner.y = -4;
         this._shiner.width = 48;
         this._shiner.height = 48;
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
      }
      
      public function shinePlay() : void
      {
         this._shiner.shine();
      }
      
      public function shineStop() : void
      {
         this._shiner.stopShine();
      }
      
      private function onClick(e:InteractiveEvent) : void
      {
         if(Boolean(this._cell))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this._cell));
            PetsBagManager.instance.dispatchEvent(new Event("equitClick"));
         }
      }
      
      protected function onDoubleClick(event:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(Boolean(this._cell))
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      public function initBagCell(data:InventoryItemInfo) : void
      {
         this.clearBagCell();
         ShowPet.isPetEquip = true;
         this._cell = new BagCell(0,data);
         this._cell.allowDrag = true;
         addChild(this._cell);
      }
      
      public function clearBagCell() : void
      {
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         this.clearBagCell();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
      }
   }
}

