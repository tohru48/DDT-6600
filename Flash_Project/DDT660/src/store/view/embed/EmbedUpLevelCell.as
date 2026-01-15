package store.view.embed
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.data.BeadEvent;
   import beadSystem.model.BeadModel;
   import beadSystem.tips.BeadUpgradeTip;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class EmbedUpLevelCell extends BaseCell
   {
      
      private var _shiner:ShineObject;
      
      private var _beadPic:MovieClip;
      
      private var _dragBeadPic:MovieClip;
      
      private var _invenItemInfo:InventoryItemInfo;
      
      private var _nameTxt:FilterFrameText;
      
      private var _lockIcon:Bitmap;
      
      private var _upTip:BeadUpgradeTip;
      
      private var _previewArray:Bitmap;
      
      private var _upgradeMC:MovieClip;
      
      private var _itemInfo:InventoryItemInfo;
      
      public function EmbedUpLevelCell()
      {
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("beadSystem.upgradeBG");
         super(bg);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.EmbedStoneCellShine"));
         this._shiner.mouseChildren = this._shiner.mouseEnabled = this._shiner.visible = false;
         addChild(this._shiner);
         PlayerManager.Instance.Self.embedUpLevelCell = this;
         beadSystemManager.Instance.addEventListener(BeadEvent.PLAYUPGRADEMC,this.__startPlay);
      }
      
      private function __startPlay(pEvent:Event) : void
      {
         if(!this._upgradeMC)
         {
            this._upgradeMC = ClassUtils.CreatInstance("beadSystem.upgrade.MC");
            this._upgradeMC.x = 451;
            this._upgradeMC.y = 125;
            this._upgradeMC.addEventListener("upgradeBeadComplete",this.__onUpgradeComplete);
            LayerManager.Instance.addToLayer(this._upgradeMC,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,true);
            this._upgradeMC.gotoAndPlay(1);
         }
      }
      
      private function __onUpgradeComplete(pEvent:Event) : void
      {
         this._upgradeMC.removeEventListener("upgradeBeadComplete",this.__onUpgradeComplete);
         this._upgradeMC.stop();
         ObjectUtils.disposeObject(this._upgradeMC);
         this._upgradeMC = null;
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(Boolean(_info))
         {
            _tipData = null;
            locked = false;
            this.disposeBeadPic();
         }
         _info = value;
         if(Boolean(_info))
         {
            if(!this._nameTxt)
            {
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadCellEquip.name");
               this._nameTxt.mouseEnabled = false;
               addChild(this._nameTxt);
            }
            tipStyle = "beadSystem.tips.BeadUpgradeTip";
            _tipData = new GoodTipInfo();
            GoodTipInfo(_tipData).itemInfo = _info;
            if(this.itemInfo.Hole2 > 0)
            {
               GoodTipInfo(_tipData).exp = this.itemInfo.Hole2;
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[this.itemInfo.Hole1 + 1];
               GoodTipInfo(_tipData).beadName = info.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + this.itemInfo.Hole1;
            }
            else
            {
               GoodTipInfo(_tipData).exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel];
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel + 1];
               GoodTipInfo(_tipData).beadName = info.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel;
            }
            if(this.invenItemInfo.IsUsed)
            {
               if(Boolean(this._lockIcon))
               {
                  this._lockIcon.visible = true;
                  setChildIndex(this._lockIcon,numChildren - 1);
               }
               else
               {
                  this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
                  this._lockIcon.x = 5;
                  this._lockIcon.y = 5;
                  this.addChild(this._lockIcon);
                  setChildIndex(this._lockIcon,numChildren - 1);
               }
            }
            else if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            BeadModel.isBeadCellIsBind = this.itemInfo.IsBinds;
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            this.disposeDragBeadPic();
         }
         BeadModel.beadCanUpgrade = value == null ? false : true;
         dispatchEvent(new BeadEvent(BeadEvent.BEADCELLCHANGED,-1,value));
      }
      
      public function set itemInfo(value:InventoryItemInfo) : void
      {
         BeadModel.upgradeCellInfo = value;
         this._itemInfo = value;
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._itemInfo;
      }
      
      private function createBeadPic(value:ItemTemplateInfo) : void
      {
         if(this._invenItemInfo.Hole1 > 0)
         {
            this._beadPic = ClassUtils.CreatInstance("beadSystem.beadMC" + beadSystemManager.Instance.getBeadMcIndex(this.itemInfo.Hole1));
            this._beadPic.scaleX = 1;
            this._beadPic.scaleY = 1;
            this._beadPic.x = 2;
            this._beadPic.y = 2;
            addChild(this._beadPic);
         }
         else
         {
            this._beadPic = ComponentFactory.Instance.creat("beadSystem.bead" + beadSystemManager.Instance.getBeadMcIndex(BeadTemplateManager.Instance.GetBeadInfobyID(this.info.TemplateID).BaseLevel));
            this._beadPic.scaleX = 1;
            this._beadPic.scaleY = 1;
            this._beadPic.x = 2;
            this._beadPic.y = 2;
            addChild(this._beadPic);
         }
      }
      
      private function disposeBeadPic() : void
      {
         if(Boolean(this._beadPic))
         {
            ObjectUtils.disposeObject(this._beadPic);
            this._beadPic = null;
         }
      }
      
      private function disposeDragBeadPic() : void
      {
         if(Boolean(this._dragBeadPic))
         {
            this._dragBeadPic.gotoAndStop(this._dragBeadPic.totalFrames);
            ObjectUtils.disposeObject(this._dragBeadPic);
            this._dragBeadPic = null;
         }
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var sourceInfo:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            DragManager.acceptDrag(this);
            BaglockedManager.Instance.show();
            return;
         }
         sourceInfo = effect.data as InventoryItemInfo;
         if(sourceInfo.Hole1 == 19)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
            return;
         }
         if(sourceInfo.Hole1 == 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.lvOneCanntUpgrade"));
         }
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            this._invenItemInfo = sourceInfo;
            this._itemInfo = sourceInfo;
            this.info = sourceInfo;
            SocketManager.Instance.out.sendBeadEquip(sourceInfo.Place,31);
         }
         DragManager.acceptDrag(this);
         if(SharedManager.Instance.beadLeadTaskStep == 3 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= BagAndGiftFrame.BEAD_OPEN_LEVEL && PlayerManager.Instance.Self.Grade <= BagAndGiftFrame.BEAD_OPEN_LEVEL + 5)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_BEADUPDATESLOT);
               if(Boolean(BeadLeadManager.Instance.upLevelEffec))
               {
                  EffectManager.Instance.removeEffect(BeadLeadManager.Instance.upLevelEffec);
                  BeadLeadManager.Instance.upLevelEffec = null;
                  BeadLeadManager.Instance.upLevelCellSpaling = false;
               }
               BeadLeadManager.Instance.leadClickCombinBnt(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               SharedManager.Instance.beadLeadTaskStep = 4;
               SharedManager.Instance.save();
            }
         }
      }
      
      override public function dragStart() : void
      {
         SoundManager.instance.play("008");
         if(_info && !locked && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               this.dragHidePicTxt();
            }
         }
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         super.onMouseOut(evt);
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._upTip))
         {
            this._upTip.showTip(info);
         }
         super.onMouseOver(evt);
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(effect.action == DragEffect.MOVE && !effect.target)
         {
            effect.action = DragEffect.NONE;
         }
         this.disposeDragBeadPic();
         this.dragShowPicTxt();
         super.dragStop(effect);
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.scaleX = 0.8;
            sp.scaleY = 0.8;
            if(_picPos != null)
            {
               sp.x = _picPos.x;
            }
            else
            {
               sp.x = sp.x - sp.width / 2 + _contentWidth / 2;
            }
            if(_picPos != null)
            {
               sp.y = _picPos.y;
            }
            else
            {
               sp.y = sp.y - sp.height / 2 + _contentHeight / 2;
            }
         }
      }
      
      public function get invenItemInfo() : InventoryItemInfo
      {
         return this._invenItemInfo;
      }
      
      public function set invenItemInfo(value:InventoryItemInfo) : void
      {
         this._invenItemInfo = value;
      }
      
      private function dragHidePicTxt() : void
      {
         this._nameTxt.visible = false;
         if(Boolean(this._lockIcon))
         {
            this._lockIcon.visible = false;
         }
      }
      
      private function dragShowPicTxt() : void
      {
         this._nameTxt.visible = true;
         if(this.invenItemInfo.IsUsed && Boolean(this._lockIcon))
         {
            this._lockIcon.visible = true;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.info))
         {
            SocketManager.Instance.out.sendBeadEquip(31,-1);
         }
         if(Boolean(this._beadPic))
         {
            this.disposeBeadPic();
         }
         if(Boolean(this._dragBeadPic))
         {
            this.disposeDragBeadPic();
         }
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(Boolean(this._upgradeMC))
         {
            ObjectUtils.disposeObject(this._upgradeMC);
         }
         this._upgradeMC = null;
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_COMBINCLICK))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_COMBINCLICK);
         }
         beadSystemManager.Instance.removeEventListener(BeadEvent.PLAYUPGRADEMC,this.__startPlay);
         super.dispose();
      }
   }
}

