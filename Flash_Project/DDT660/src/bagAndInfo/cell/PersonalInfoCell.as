package bagAndInfo.cell
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gemstone.info.GemstoneInfo;
   import petsBag.controller.PetBagController;
   
   public class PersonalInfoCell extends BagCell
   {
      
      public var gemstoneList:Vector.<GemstoneInfo>;
      
      private var _isGemstone:Boolean = false;
      
      private var _shineObject:MovieClip;
      
      public function PersonalInfoCell(index:int = 0, info:ItemTemplateInfo = null, showLoading:Boolean = true)
      {
         super(index,info,showLoading);
         _bg.visible = false;
         _picPos = new Point(2,0);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.onClick);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               SoundManager.instance.play("008");
               locked = true;
            }
         }
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
      }
      
      protected function onClick(evt:InteractiveEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      protected function onDoubleClick(evt:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(Boolean(info))
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var alert:BaseAlerFrame = null;
         var toPlace:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            effect.action = DragEffect.NONE;
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info))
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               return;
            }
            if(info.Place < 29 && info.BagType != BagInfo.PROPBAG)
            {
               return;
            }
            if((info.BindType == 1 || info.BindType == 2 || info.BindType == 3) && info.IsBinds == false && info.TemplateID != EquipType.WISHBEAD_ATTACK && info.TemplateID != EquipType.WISHBEAD_DEFENSE && info.TemplateID != EquipType.WISHBEAD_AGILE)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onBindResponse);
               temInfo = info;
               DragManager.acceptDrag(this,DragEffect.NONE);
               return;
            }
            if(PlayerManager.Instance.Self.canEquip(info))
            {
               if(this.getCellIndex(info).indexOf(place) != -1)
               {
                  toPlace = place;
               }
               else
               {
                  toPlace = PlayerManager.Instance.getDressEquipPlace(info);
               }
               if(!PetBagController.instance().petModel.currentPetInfo)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace,info.Count);
                  effect.action = DragEffect.NONE;
                  DragManager.acceptDrag(this,DragEffect.MOVE);
                  return;
               }
               if(info.CategoryID == 50 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 0)
               {
                  SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,0);
               }
               else if(info.CategoryID == 51 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 1)
               {
                  SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,1);
               }
               else if(info.CategoryID == 52 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 2)
               {
                  SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,2);
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace,info.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
      }
      
      override protected function createLoading() : void
      {
         super.createLoading();
         PositionUtils.setPos(_loadingasset,"ddt.personalInfocell.loadingPos");
      }
      
      override public function checkOverDate() : void
      {
         if(Boolean(_bgOverDate))
         {
            _bgOverDate.visible = false;
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function __onBindResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onBindResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendBindDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var toPlace:int = 0;
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            toPlace = PlayerManager.Instance.getDressEquipPlace(temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,toPlace);
         }
      }
      
      private function sendBindDefy() : void
      {
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,_place,temInfo.Count);
         }
      }
      
      private function getCellIndex(info:ItemTemplateInfo) : Array
      {
         if(EquipType.isWeddingRing(info))
         {
            return [9,10,16];
         }
         switch(info.CategoryID)
         {
            case EquipType.HEAD:
               return [0];
            case EquipType.GLASS:
               return [1];
            case EquipType.HAIR:
               return [2];
            case EquipType.EFF:
               return [3];
            case EquipType.CLOTH:
               return [4];
            case EquipType.FACE:
               return [5];
            case EquipType.ARM:
               return [6];
            case EquipType.ARMLET:
            case EquipType.TEMPARMLET:
               return [7,8];
            case EquipType.RING:
            case EquipType.TEMPRING:
               return [9,10];
            case EquipType.SUITS:
               return [11];
            case EquipType.NECKLACE:
               return [12];
            case EquipType.WING:
               return [13];
            case EquipType.CHATBALL:
               return [14];
            case EquipType.OFFHAND:
               return [15];
            default:
               return [-1];
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            effect.action = DragEffect.NONE;
            super.dragStop(effect);
         }
         locked = false;
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
      }
      
      public function shine() : void
      {
         if(this._shineObject == null)
         {
            this._shineObject = ComponentFactory.Instance.creatCustomObject("asset.core.playerInfoCellShine") as MovieClip;
         }
         addChild(this._shineObject);
         this._shineObject.gotoAndPlay(1);
      }
      
      public function stopShine() : void
      {
         if(this._shineObject != null && this.contains(this._shineObject))
         {
            removeChild(this._shineObject);
         }
         if(this._shineObject != null)
         {
            this._shineObject.gotoAndStop(1);
         }
      }
      
      override public function updateCount() : void
      {
         if(Boolean(_tbxCount))
         {
            if(_info && itemInfo && itemInfo.Count > 1)
            {
               _tbxCount.text = String(itemInfo.Count);
               _tbxCount.visible = true;
               addChild(_tbxCount);
            }
            else
            {
               _tbxCount.visible = false;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._shineObject != null)
         {
            ObjectUtils.disposeAllChildren(this._shineObject);
         }
         this._shineObject = null;
         super.dispose();
      }
   }
}

