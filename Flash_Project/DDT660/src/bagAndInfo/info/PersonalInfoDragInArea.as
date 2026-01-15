package bagAndInfo.info
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import petsBag.controller.PetBagController;
   
   public class PersonalInfoDragInArea extends Sprite implements IAcceptDrag
   {
      
      private var temInfo:InventoryItemInfo;
      
      private var temEffect:DragEffect;
      
      public function PersonalInfoDragInArea()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,450,310);
         graphics.endFill();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if((info.BindType == 1 || info.BindType == 2 || info.BindType == 3) && info.IsBinds == false && info.TemplateID != EquipType.WISHBEAD_ATTACK && info.TemplateID != EquipType.WISHBEAD_DEFENSE && info.TemplateID != EquipType.WISHBEAD_AGILE)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.temInfo = info;
            this.temEffect = effect;
            DragManager.acceptDrag(this,DragEffect.NONE);
            return;
         }
         if(Boolean(info))
         {
            effect.action = DragEffect.NONE;
            if(info.Place < 31)
            {
               DragManager.acceptDrag(this);
            }
            else if(PlayerManager.Instance.Self.canEquip(info))
            {
               if(info.CategoryID == 50 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(info.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(info.CategoryID == 51 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(info.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(info.CategoryID == 52 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(info.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else
               {
                  if(info.CategoryID == 52 || info.CategoryID == 51 || info.CategoryID == 50)
                  {
                     DragManager.acceptDrag(this);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petEquipLevelNo"));
                     return;
                  }
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(info),info.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               alert.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         if(Boolean(this.temInfo))
         {
            this.temEffect.action = DragEffect.NONE;
            if(this.temInfo.Place < 31)
            {
               DragManager.acceptDrag(this);
            }
            else if(PlayerManager.Instance.Self.canEquip(this.temInfo))
            {
               if(!PetBagController.instance().petModel.currentPetInfo)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(this.temInfo),this.temInfo.Count);
                  return;
               }
               if(this.temInfo.CategoryID == 50)
               {
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(this.temInfo.CategoryID == 51)
               {
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(this.temInfo.CategoryID == 52)
               {
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(this.temInfo),this.temInfo.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}

