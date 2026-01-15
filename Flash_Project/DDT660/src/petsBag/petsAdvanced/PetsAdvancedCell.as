package petsBag.petsAdvanced
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class PetsAdvancedCell extends Sprite implements Disposeable
   {
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _bagCell:BagCell;
      
      private var _count:int;
      
      public function PetsAdvancedCell()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         switch(PetsAdvancedManager.Instance.currentViewType)
         {
            case 1:
               info.TemplateID = 11162;
               break;
            case 2:
               info.TemplateID = 11163;
               break;
            case 4:
               info.TemplateID = 201567;
         }
         info = ItemManager.fill(info);
         info.BindType = 4;
         this._bagCell = new BagCell(0);
         this._bagCell.info = info;
         this._bagCell.PicPos = new Point(9,9);
         this._bagCell.setBgVisible(false);
         this._bagCell.setContentSize(59,59);
         this.updateCount();
         addChild(this._bagCell);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.buybtn");
         addChild(this._buyBtn);
         this._buyBtn.visible = false;
      }
      
      public function getExpOfBagcell() : int
      {
         return int(this._bagCell.info.Property2);
      }
      
      public function getTempleteId() : int
      {
         return this._bagCell.info.TemplateID;
      }
      
      public function getPropName() : String
      {
         return this._bagCell.info.Name;
      }
      
      public function getCount() : int
      {
         return this._count;
      }
      
      public function updateCount() : void
      {
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._count = bagInfo.getItemCountByTemplateId(this._bagCell.info.TemplateID);
         this._bagCell.setCount(this._count);
         this._bagCell.refreshTbxPos();
      }
      
      private function addEvent() : void
      {
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         addEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      protected function __updateBag(event:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var info:InventoryItemInfo = null;
         var bag:BagInfo = event.target as BagInfo;
         var changes:Dictionary = event.changedSlots;
         for each(i in changes)
         {
            info = bag.getItemAt(i.Place);
            if(Boolean(info) && (info.TemplateID == 11162 || info.TemplateID == 11163 || info.TemplateID == 201567))
            {
               this.updateCount();
            }
         }
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         this._buyBtn.visible = false;
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         this._buyBtn.visible = true;
      }
      
      protected function __buyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = this._bagCell.info.TemplateID;
         _quick.recordLastBuyCount = true;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyHandler);
         removeEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

