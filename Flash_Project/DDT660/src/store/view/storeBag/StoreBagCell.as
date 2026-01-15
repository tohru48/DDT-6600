package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import store.StrengthDataManager;
   import store.events.StoreDargEvent;
   
   public class StoreBagCell extends BagCell
   {
      
      private var _light:Boolean;
      
      public function StoreBagCell(index:int, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:Sprite = null)
      {
         super(index,info,showLoading,bg);
         _isShowIsUsedBitmap = true;
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var dragItemInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(!this.checkBagType(dragItemInfo))
         {
            return;
         }
         if(StrengthDataManager.instance.autoFusion)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            return;
         }
         SocketManager.Instance.out.sendMoveGoods(dragItemInfo.BagType,dragItemInfo.Place,bagType,this.getPlace(dragItemInfo),1);
         effect.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && Boolean(stage))
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,true))
            {
               locked = true;
               dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.START_DARG,true));
            }
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         var $info:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            effect.action = DragEffect.NONE;
            super.dragStop(effect);
            BaglockedManager.Instance.show();
            dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
            return;
         }
         if(effect.action == DragEffect.MOVE && effect.target == null)
         {
            locked = false;
            $info = effect.data as InventoryItemInfo;
            sellItem($info);
         }
         else if(effect.action == DragEffect.SPLIT && effect.target == null)
         {
            locked = false;
         }
         else
         {
            super.dragStop(effect);
         }
         dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
      }
      
      private function getPlace(dragItemInfo:InventoryItemInfo) : int
      {
         return -1;
      }
      
      private function checkBagType(info:InventoryItemInfo) : Boolean
      {
         if(info == null)
         {
            return false;
         }
         if(info.BagType == bagType)
         {
            return false;
         }
         if(info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12)
         {
            if(bagType == BagInfo.EQUIPBAG)
            {
               return false;
            }
            return true;
         }
         if(bagType == BagInfo.EQUIPBAG)
         {
            return true;
         }
         return false;
      }
      
      public function set light(value:Boolean) : void
      {
         if(this._light == value)
         {
            return;
         }
         this._light = value;
         if(value)
         {
            this.showEffect();
         }
         else
         {
            this.hideEffect();
         }
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3,
               "inner":true
            }
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
      }
      
      override public function dispose() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
         super.dispose();
      }
   }
}

