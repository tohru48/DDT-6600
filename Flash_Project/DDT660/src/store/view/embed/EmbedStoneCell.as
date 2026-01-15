package store.view.embed
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.model.BeadModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
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
   import ddt.view.tips.MultipleLineTip;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.utils.MovieClipWrapper;
   import store.events.EmbedBackoutEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class EmbedStoneCell extends BaseCell
   {
      
      public static const Close:int = -1;
      
      public static const Empty:int = 0;
      
      public static const Full:int = 1;
      
      public static const ATTACK:int = 1;
      
      public static const DEFENSE:int = 2;
      
      public static const ATTRIBUTE:int = 3;
      
      public static const BEAD_STATE_CHANGED:String = "beadEmbed";
      
      private var _id:int;
      
      private var _state:int = -1;
      
      private var _stoneType:int;
      
      private var _shiner:ShineObject;
      
      private var _tipPanel:Sprite;
      
      private var _tipDerial:Boolean;
      
      private var tipSprite:Sprite;
      
      private var _tipOne:MultipleLineTip;
      
      private var _tipTwo:OneLineTip;
      
      private var _openGrid:ScaleFrameImage;
      
      private var _openBG:Bitmap;
      
      private var _closeStrip:Bitmap;
      
      private var _SelectedImage:Image;
      
      private var _holeLv:int = -1;
      
      private var _holeExp:int = -1;
      
      private var _dragBeadPic:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _lockIcon:Bitmap;
      
      private var _selected:Boolean = false;
      
      private var _isOpend:Boolean = false;
      
      private var _itemInfo:InventoryItemInfo;
      
      private var _beadInfo:InventoryItemInfo;
      
      private var _Player:PlayerInfo;
      
      public function EmbedStoneCell(id:int, stoneType:int)
      {
         var bgBit:Bitmap = null;
         var bg:Sprite = new Sprite();
         if(id == 31)
         {
            bgBit = ComponentFactory.Instance.creatBitmap("beadSystem.upgradeBG");
         }
         else
         {
            bgBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EmbedCellBG");
         }
         bg.addChild(bgBit);
         super(bg,_info);
         this._id = id;
         this._stoneType = stoneType;
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.EmbedStoneCellShine"));
         this._shiner.mouseChildren = this._shiner.mouseEnabled = this._shiner.visible = false;
         addChild(this._shiner);
         if(this._id != 31)
         {
            this._openBG = ComponentFactory.Instance.creatBitmap("beadSystem.embedBG");
            addChildAt(this._openBG,0);
         }
         if(this._id <= 12)
         {
            this._closeStrip = ComponentFactory.Instance.creatBitmap("beadSystem.unOpenedBG");
         }
         else
         {
            this._closeStrip = ComponentFactory.Instance.creatBitmap("beadSystem.disopened.bg");
         }
         addChild(this._closeStrip);
         if(this._id < 6)
         {
            this.open();
         }
         this._tipOne = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.MultipleLineTip");
         this._tipTwo = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCellCloseTip");
         this._tipTwo.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.closeOpenHole");
         if(this._id > 12 && this._id != 31)
         {
            this._SelectedImage = ComponentFactory.Instance.creatComponentByStylename("beadSystem.openHoleSelectedImage");
            this._SelectedImage.visible = false;
            addChild(this._SelectedImage);
         }
         this.initEvents();
         if(this._id <= 12 && this._id >= 4)
         {
            this.setTipTwoData(this._id);
         }
      }
      
      private function setTipTwoData(pID:int) : void
      {
         switch(pID)
         {
            case 6:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",15);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 15)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 15)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 7:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",18);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 18)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 18)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 8:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",21);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 21)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 21)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 9:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",24);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 24)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 24)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 10:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",27);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 27)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 27)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 11:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",30);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 30)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 30)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            case 12:
               this._tipTwo.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipLvOpenHole",33);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
               if(PlayerManager.Instance.Self.Grade >= 33)
               {
                  this.open();
               }
               if(Boolean(this.otherPlayer))
               {
                  if(this.otherPlayer.Grade < 33)
                  {
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
               }
               break;
            default:
               this._tipTwo.tipData = "";
         }
      }
      
      public function LockBead() : Boolean
      {
         if(!this.itemInfo)
         {
            return false;
         }
         if(!this.itemInfo.IsUsed)
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = true;
               setChildIndex(this._lockIcon,numChildren - 1);
            }
            else
            {
               this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
               this._lockIcon.scaleY = 0.7;
               this._lockIcon.scaleX = 0.7;
               this.addChild(this._lockIcon);
               setChildIndex(this._lockIcon,numChildren - 1);
            }
            SocketManager.Instance.out.sendBeadLock(this.ID);
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            SocketManager.Instance.out.sendBeadLock(this.ID);
         }
         return true;
      }
      
      private function __changeHandler(event:PlayerPropertyEvent) : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         this.setTipTwoData(this.ID);
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         if(Boolean(this._SelectedImage))
         {
            this._SelectedImage.visible = value;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function holeLvUp() : void
      {
         var mc:MovieClip = null;
         mc = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedHoleExpUp");
         mc.scaleY = 0.4;
         mc.scaleX = 0.4;
         mc.y = 42;
         var movie:MovieClipWrapper = new MovieClipWrapper(mc,true,true);
         addChild(movie.movie);
         BeadModel.isHoleOpendComplete = false;
      }
      
      public function get ID() : int
      {
         return this._id;
      }
      
      override public function get allowDrag() : Boolean
      {
         return true;
      }
      
      private function initEvents() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         if(!this._Player)
         {
            if(this._state != Close && _info == null)
            {
               this._tipOne.x = localToGlobal(new Point(width,height)).x + 8;
               this._tipOne.y = localToGlobal(new Point(width,height)).y + 8;
               LayerManager.Instance.addToLayer(this._tipOne,LayerManager.GAME_TOP_LAYER);
               return;
            }
            if(!this.isOpend && _info == null)
            {
               this._tipTwo.x = localToGlobal(new Point(width,height)).x + 8;
               this._tipTwo.y = localToGlobal(new Point(width,height)).y + 8;
               LayerManager.Instance.addToLayer(this._tipTwo,LayerManager.GAME_TOP_LAYER);
            }
         }
      }
      
      private function __clickHandler(event:InteractiveEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      private function __doubleClick(event:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(Boolean(_info))
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      public function showTip(evt:MouseEvent) : void
      {
      }
      
      public function closeTip(evt:MouseEvent) : void
      {
         super.onMouseOut(evt);
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         if(this._state == Full && !this._tipDerial && _info != null)
         {
            dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this._id,info.TemplateID));
         }
         if(this._state != Close && _info == null)
         {
            if(Boolean(this._tipOne.parent))
            {
               this._tipOne.parent.removeChild(this._tipOne);
            }
            return;
         }
         if(!this.isOpend && _info == null)
         {
            super.onMouseOut(evt);
            if(Boolean(this._tipTwo.parent))
            {
               this._tipTwo.parent.removeChild(this._tipTwo);
            }
         }
      }
      
      public function open() : void
      {
         if(this._stoneType == -1)
         {
            return;
         }
         this._state = Empty;
         if(Boolean(this._closeStrip))
         {
            this._closeStrip.visible = false;
         }
         this._isOpend = true;
      }
      
      public function get isOpend() : Boolean
      {
         return this._isOpend;
      }
      
      public function set HoleExp(value:int) : void
      {
         this._holeExp = value;
      }
      
      public function get HoleExp() : int
      {
         return this._holeExp;
      }
      
      public function set HoleLv(value:int) : void
      {
         this._holeLv = value;
         if(this._holeLv >= 0 && this._stoneType == ATTRIBUTE && this._id > 4)
         {
            switch(this._holeLv)
            {
               case 1:
                  this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv,4);
                  break;
               case 2:
                  this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv,8);
                  break;
               case 3:
                  this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv,12);
                  break;
               case 4:
                  this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv,16);
                  break;
               case 5:
                  this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv,19);
            }
         }
         if(this._holeLv > 0)
         {
            this.open();
         }
      }
      
      public function get HoleLv() : int
      {
         return this._holeLv;
      }
      
      public function set StoneType(value:int) : void
      {
         var str:String = null;
         this._stoneType = value;
         if(this.ID != 31)
         {
            switch(this._stoneType)
            {
               case ATTACK:
                  str = LanguageMgr.GetTranslation("tank.store.embedCell.attack");
                  break;
               case DEFENSE:
                  str = LanguageMgr.GetTranslation("tank.store.embedCell.defense");
                  break;
               case ATTRIBUTE:
                  str = LanguageMgr.GetTranslation("tank.store.embedCell.attribute");
                  break;
               default:
                  str = null;
            }
            if(Boolean(str))
            {
               this._tipOne.tipData = str;
            }
         }
         else
         {
            this._tipOne.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.tipFeedHole");
         }
      }
      
      public function get StoneType() : int
      {
         return this._stoneType;
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               locked = true;
               this.dragHidePicTxt();
               this._openBG.visible = true;
            }
         }
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
         if(this.itemInfo.IsUsed && Boolean(this._lockIcon))
         {
            this._lockIcon.visible = true;
         }
      }
      
      public function set itemInfo(value:InventoryItemInfo) : void
      {
         this._itemInfo = value;
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._itemInfo;
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         var vFormatStr:String = null;
         if(Boolean(_info))
         {
            _tipData = null;
            locked = false;
            if(Boolean(this._nameTxt))
            {
               this._nameTxt.htmlText = "";
               this._nameTxt.visible = false;
            }
         }
         super.info = value;
         _info = value;
         if(Boolean(_info))
         {
            if(!this._nameTxt)
            {
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadCellEquip.name");
               this._nameTxt.mouseEnabled = false;
               addChild(this._nameTxt);
            }
            this.setChildIndex(this._nameTxt,this.numChildren - 1);
            vFormatStr = beadSystemManager.Instance.getBeadNameTextFormatStyle(this.itemInfo.Hole1);
            this._nameTxt.textFormatStyle = vFormatStr;
            this._nameTxt.visible = true;
            tipStyle = "core.GoodsTip";
            _tipData = new GoodTipInfo();
            GoodTipInfo(_tipData).itemInfo = _info;
            if(this.itemInfo.Hole2 > 0)
            {
               GoodTipInfo(_tipData).exp = this.itemInfo.Hole2;
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[this.itemInfo.Hole1 + 1];
               GoodTipInfo(_tipData).beadName = info.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + this.itemInfo.Hole1;
               this._nameTxt.htmlText = BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + this.itemInfo.Hole1;
            }
            else
            {
               GoodTipInfo(_tipData).exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel];
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel + 1];
               this._nameTxt.htmlText = BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel;
               GoodTipInfo(_tipData).beadName = info.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(value.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel;
            }
            if(this.itemInfo.IsUsed)
            {
               if(Boolean(this._lockIcon))
               {
                  this._lockIcon.visible = true;
                  setChildIndex(this._lockIcon,numChildren - 1);
               }
               else
               {
                  this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
                  this._lockIcon.scaleY = 0.7;
                  this._lockIcon.scaleX = 0.7;
                  this.addChild(this._lockIcon);
               }
            }
            else if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            this.disposeDragBeadPic();
            if(Boolean(this._nameTxt))
            {
               this._nameTxt.visible = false;
            }
         }
         if(Boolean(this._openBG))
         {
            if(Boolean(value))
            {
               this._openBG.visible = false;
            }
            else
            {
               this._openBG.visible = true;
            }
         }
      }
      
      public function close() : void
      {
         this._state = Close;
         if(Boolean(this._closeStrip))
         {
            this._closeStrip.visible = true;
         }
         this.info = null;
         tipData = null;
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
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
         var bindAlert:BaseAlerFrame = null;
         if(this.isOpend)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               DragManager.acceptDrag(this);
               BaglockedManager.Instance.show();
               return;
            }
            sourceInfo = effect.data as InventoryItemInfo;
            if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
            {
               effect.action = DragEffect.NONE;
               if(this.ID != 31 && !this.isRightType(sourceInfo))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.notType"));
               }
               else if(!beadSystemManager.Instance.judgeLevel(sourceInfo.Hole1,this._holeLv) && 13 <= this.ID && this.ID <= 18)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipDonotAdaptLevel"));
               }
               else
               {
                  this._beadInfo = sourceInfo;
                  if(this.itemInfo && int(this.itemInfo.Hole1) == 19 && !(effect.source is EmbedStoneCell) && effect.source is EmbedUpLevelCell)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
                     return;
                  }
                  if(this.itemInfo && int(this.itemInfo.Hole1) == 1 && !(effect.source is EmbedStoneCell) && effect.source is EmbedUpLevelCell)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.lvOneCanntUpgrade"));
                  }
                  if(!this._beadInfo.IsBinds)
                  {
                     bindAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
                     bindAlert.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
                  }
                  else
                  {
                     this.itemInfo = sourceInfo;
                     this.info = sourceInfo;
                     SocketManager.Instance.out.sendBeadEquip(sourceInfo.Place,this._id);
                  }
                  dispatchEvent(new Event(BEAD_STATE_CHANGED));
                  this._tipDerial = false;
               }
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoAccessEquipBead"));
         }
         DragManager.acceptDrag(this);
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_EQUIPBEAD))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_EQUIPBEAD);
            BeadLeadManager.Instance.leadCandleStick(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            SharedManager.Instance.beadLeadTaskStep = 6;
            SharedManager.Instance.save();
         }
      }
      
      protected function __onBindRespones(pEvent:FrameEvent) : void
      {
         switch(pEvent.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.itemInfo = this._beadInfo;
               this.info = this._beadInfo;
               if(this.StoneType == int(this._beadInfo.Property2))
               {
                  SocketManager.Instance.out.sendBeadEquip(this._beadInfo.Place,this._id);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.notType"));
               }
         }
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(pEvent.currentTarget);
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
         if(this.ID != 31)
         {
            if(Boolean(this._openBG))
            {
               this._openBG.visible = false;
            }
         }
         locked = false;
         super.dragStop(effect);
      }
      
      private function isRightType(item:InventoryItemInfo) : Boolean
      {
         return item.Property2 == this._stoneType.toString();
      }
      
      public function get tipDerial() : Boolean
      {
         return this._tipDerial;
      }
      
      public function set tipDerial(value:Boolean) : void
      {
         this._tipDerial = value;
      }
      
      public function startShine() : void
      {
         this._shiner.scaleX = this._shiner.scaleY = 0.8;
         this._shiner.x = this._shiner.y = 3;
         this._shiner.visible = true;
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
         this._shiner.visible = false;
      }
      
      public function hasDrill() : Boolean
      {
         return EquipType.isDrill(_info as InventoryItemInfo);
      }
      
      public function get otherPlayer() : PlayerInfo
      {
         return this._Player;
      }
      
      public function set otherPlayer(value:PlayerInfo) : void
      {
         this._Player = value;
         if(Boolean(this._Player))
         {
            if(this._id <= 12 && this._id >= 4)
            {
               this.setTipTwoData(this._id);
            }
         }
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
      
      override public function dispose() : void
      {
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClick);
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         if(Boolean(this._tipOne))
         {
            ObjectUtils.disposeObject(this._tipOne);
         }
         this._tipOne = null;
         if(Boolean(this._tipTwo))
         {
            ObjectUtils.disposeObject(this._tipTwo);
         }
         this._tipTwo = null;
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(Boolean(this._openGrid))
         {
            ObjectUtils.disposeObject(this._openGrid);
         }
         this._openGrid = null;
         if(Boolean(this._closeStrip))
         {
            ObjectUtils.disposeObject(this._closeStrip);
         }
         this._closeStrip = null;
         ObjectUtils.disposeObject(this._SelectedImage);
         this._SelectedImage = null;
         super.dispose();
      }
      
      public function get state() : int
      {
         return this._state;
      }
   }
}

