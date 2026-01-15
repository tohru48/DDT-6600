package petsBag.view.item
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.viewx.FarmFieldBlock;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.view.PetFoodNumberSelectFrame;
   
   public class FeedItem extends BaseCell
   {
      
      protected var _tbxCount:FilterFrameText;
      
      private var _shiner:ShineObject;
      
      public function FeedItem()
      {
         _bg = ComponentFactory.Instance.creatBitmap("assets.petsBag.petFeedPnlBg");
         this.initView();
         super(_bg,null,false);
      }
      
      private function initView() : void
      {
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.petBagSystem.cellShine"));
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
      }
      
      public function startShine() : void
      {
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
      }
      
      public function updateCount() : void
      {
         if(Boolean(this._tbxCount))
         {
            if(_info && this.itemInfo && this.itemInfo.MaxCount > 1)
            {
               this._tbxCount.text = String(this.itemInfo.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      private function __updateStoreBag(evt:BagEvent) : void
      {
         var p:String = null;
         var place:int = 0;
         for(p in evt.changedSlots)
         {
            place = int(p);
            if(place == 0)
            {
               this.info = PlayerManager.Instance.Self.StoreBag.items[0];
            }
         }
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         if(Boolean(_info) && allowDrag)
         {
            SoundManager.instance.play("008");
            dragStart();
         }
      }
      
      override protected function removeEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         super.removeEvent();
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return _info as InventoryItemInfo;
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         this.updateCount();
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var alert:PetFoodNumberSelectFrame = null;
         var needMaxFood:int = 0;
         if(!this.mouseEnabled)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(sourceInfo) && sourceInfo.CategoryID == EquipType.FOOD)
         {
            if(EquipType.isPetSpeciallFood(sourceInfo))
            {
               if(Boolean(info))
               {
                  SocketManager.Instance.out.sendClearStoreBag();
               }
               effect.action = DragEffect.NONE;
               SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,-1,1);
            }
            else
            {
               alert = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame");
               alert.foodInfo = sourceInfo;
               alert.petInfo = PetBagController.instance().petModel.currentPetInfo;
               alert.addEventListener(FrameEvent.RESPONSE,this.__onFoodAmountResponse);
               needMaxFood = this.needMaxFood(PetBagController.instance().petModel.currentPetInfo.Hunger,int(sourceInfo.Property1));
               if(PetBagController.instance().petModel.currentPetInfo.Level == 60 || PetBagController.instance().petModel.currentPetInfo.Level == PlayerManager.Instance.Self.Grade)
               {
                  alert.show(needMaxFood);
               }
               else
               {
                  alert.show(sourceInfo.Count);
               }
            }
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
         else
         {
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
         }
      }
      
      private function needMaxFood(hunger:int, addHunger:int) : int
      {
         var maxFood:int = 0;
         var limitHunger:int = PetconfigAnalyzer.PetCofnig.MaxHunger - hunger;
         return int(Math.ceil(limitHunger / Number(addHunger)));
      }
      
      protected function __onFoodAmountResponse(event:FrameEvent) : void
      {
         var frame:PetFoodNumberSelectFrame = null;
         var foodInfo:InventoryItemInfo = null;
         SoundManager.instance.play("008");
         frame = PetFoodNumberSelectFrame(event.currentTarget);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               frame.dispose();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               foodInfo = frame.foodInfo;
               if(Boolean(info))
               {
                  SocketManager.Instance.out.sendClearStoreBag();
               }
               SocketManager.Instance.out.sendMoveGoods(foodInfo.BagType,foodInfo.Place,BagInfo.STOREBAG,0,frame.amount,true);
               frame.dispose();
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         var $info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(effect.action == DragEffect.MOVE && effect.target == null)
         {
            if(Boolean($info) && $info.BagType == 11)
            {
               effect.action = DragEffect.NONE;
               super.dragStop(effect);
            }
            else if(Boolean($info) && $info.BagType == 12)
            {
               locked = false;
            }
            else
            {
               locked = false;
            }
         }
         else if(effect.action == DragEffect.SPLIT && effect.target == null)
         {
            locked = false;
         }
         else if(effect.target is FarmFieldBlock)
         {
            locked = false;
         }
         else
         {
            super.dragStop(effect);
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._tbxCount))
         {
            ObjectUtils.disposeObject(this._tbxCount);
            this._tbxCount = null;
         }
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

