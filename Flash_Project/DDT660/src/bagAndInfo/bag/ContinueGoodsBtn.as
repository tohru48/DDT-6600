package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.data.EquipType;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.goods.AddPricePanel;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ContinueGoodsBtn extends TextButton implements IDragable
   {
      
      public var _isContinueGoods:Boolean;
      
      public function ContinueGoodsBtn()
      {
         super();
         this._isContinueGoods = false;
         this.addEvt();
      }
      
      private function addEvt() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function removeEvt() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function clickthis(e:MouseEvent) : void
      {
         var dragAsset:Bitmap = null;
         SoundManager.instance.play("008");
         if(this._isContinueGoods == false)
         {
            this._isContinueGoods = true;
            dragAsset = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.continueIconAsset");
            DragManager.startDrag(this,this,dragAsset,e.stageX,e.stageY,DragEffect.MOVE,false);
         }
         else
         {
            this._isContinueGoods = false;
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         var cell:BagCell = null;
         if(this._isContinueGoods && effect.target is BagCell)
         {
            cell = effect.target as BagCell;
            cell.locked = false;
            this._isContinueGoods = false;
            if(ShopManager.Instance.canAddPrice(cell.itemInfo.TemplateID) && cell.itemInfo.getRemainDate() != int.MAX_VALUE && !EquipType.isProp(cell.itemInfo))
            {
               AddPricePanel.Instance.setInfo(cell.itemInfo,false);
               AddPricePanel.Instance.show();
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            return;
         }
         this._isContinueGoods = false;
      }
      
      public function get isContinueGoods() : Boolean
      {
         return this._isContinueGoods;
      }
   }
}

