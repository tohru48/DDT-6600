package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.data.EquipType;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   
   public class SellGoodsBtn extends TextButton implements IDragable
   {
      
      public static const StopSell:String = "stopsell";
      
      public var isActive:Boolean = false;
      
      private var sellFrame:SellGoodsFrame;
      
      private var lightingFilter:ColorMatrixFilter;
      
      private var _dragTarget:BagCell;
      
      public function SellGoodsBtn()
      {
         super();
         this.init();
      }
      
      override protected function init() : void
      {
         buttonMode = true;
         super.init();
      }
      
      public function dragStart(stageX:Number, stageY:Number) : void
      {
         this.isActive = true;
         var dragAsset:Bitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.sellIconAsset");
         DragManager.startDrag(this,this,dragAsset,stageX,stageY,DragEffect.MOVE,false);
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         var cell:BagCell = null;
         this.isActive = false;
         if(PlayerManager.Instance.Self.bagLocked && effect.target is ICell)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(effect.action == DragEffect.MOVE && effect.target is ICell)
         {
            cell = effect.target as BagCell;
            if(Boolean(cell) && Boolean(cell.info))
            {
               if(EquipType.isValuableEquip(cell.info))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
                  cell.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else if(EquipType.isPetSpeciallFood(cell.info))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                  cell.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else if(cell.info.CategoryID == 34)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                  cell.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else
               {
                  this._dragTarget = cell;
                  this.showSellFrame();
               }
            }
            else
            {
               dispatchEvent(new Event(StopSell));
            }
         }
         else
         {
            dispatchEvent(new Event(StopSell));
         }
      }
      
      private function showSellFrame() : void
      {
         SoundManager.instance.play("008");
         if(this.sellFrame == null)
         {
            this.sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
            this.sellFrame.itemInfo = this._dragTarget.itemInfo;
            this.sellFrame.addEventListener(SellGoodsFrame.CANCEL,this.cancelBack);
            this.sellFrame.addEventListener(SellGoodsFrame.OK,this.confirmBack);
         }
         LayerManager.Instance.addToLayer(this.sellFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function confirmBack(event:Event) : void
      {
         if(Boolean(stage))
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
         this.__disposeSellFrame();
      }
      
      private function setUpLintingFilter() : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([1,0,0,0,25]);
         matrix = matrix.concat([0,1,0,0,25]);
         matrix = matrix.concat([0,0,1,0,25]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(matrix);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._dragTarget))
         {
            this._dragTarget.locked = false;
         }
         PlayerManager.Instance.Self.Bag.unLockAll();
         this.__disposeSellFrame();
         super.dispose();
      }
      
      private function __disposeSellFrame() : void
      {
         if(Boolean(this.sellFrame))
         {
            this.sellFrame.removeEventListener(SellGoodsFrame.CANCEL,this.cancelBack);
            this.sellFrame.removeEventListener(SellGoodsFrame.OK,this.confirmBack);
            this.sellFrame.dispose();
         }
         this.sellFrame = null;
      }
      
      private function cancelBack(event:Event) : void
      {
         if(Boolean(this._dragTarget))
         {
            this._dragTarget.locked = false;
         }
         if(Boolean(stage))
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
         this.__disposeSellFrame();
      }
   }
}

