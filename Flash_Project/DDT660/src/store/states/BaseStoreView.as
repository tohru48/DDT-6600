package store.states
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.IStoreViewBG;
   import store.StoreController;
   import store.StoreMainView;
   import store.StoreTips;
   import store.StrengthDataManager;
   import store.data.StoreModel;
   import store.events.ChoosePanelEvnet;
   import store.events.StoreDargEvent;
   import store.events.StoreIIEvent;
   import store.view.Compose.StoreIIComposeBG;
   import store.view.ConsortiaRateManager;
   import store.view.embed.StoreEmbedBG;
   import store.view.fusion.StoreIIFusionBG;
   import store.view.storeBag.StoreBagCell;
   import store.view.storeBag.StoreBagController;
   import store.view.strength.StoreIIStrengthBG;
   import store.view.transfer.StoreIITransferBG;
   
   public class BaseStoreView extends Sprite implements Disposeable
   {
      
      protected var _controller:StoreController;
      
      protected var _model:StoreModel;
      
      public var _storeview:StoreMainView;
      
      protected var _tip:StoreTips;
      
      protected var _storeBag:StoreBagController;
      
      private var _soundTimer:Timer;
      
      protected var _guideEmbed:MovieClip;
      
      private var _type:String;
      
      private var _consortiaManagerBtn:TextButton;
      
      private var _consortiaBtnEffect:MovieImage;
      
      private var _tipFlag:Boolean;
      
      public function BaseStoreView(controller:StoreController, ctype:String)
      {
         super();
         this._controller = controller;
         this._model = this._controller.Model;
         this.init();
         this.initEvent();
         this.type = ctype;
         this._soundTimer = new Timer(7500,1);
      }
      
      private function init() : void
      {
         var title:Image = ComponentFactory.Instance.creatComponentByStylename("ddt.bagStore.BagStoreFrameTitle");
         var contentBg:DisplayObject = ComponentFactory.Instance.creatCustomObject("ddtstore.BagStoreFrame.ContentBg");
         addChild(contentBg);
         this._consortiaManagerBtn = ComponentFactory.Instance.creat("ddtstore.BagStoreFrame.GuildManagerBtn");
         this._consortiaManagerBtn.text = LanguageMgr.GetTranslation("store.view.GuildManagerText");
         this._consortiaManagerBtn.visible = false;
         this._storeview = ComponentFactory.Instance.creat("ddtstore.MainView");
         addChild(this._storeview);
         this._storeBag = new StoreBagController(this._model);
         addChild(this._storeBag.getView());
         this._tip = ComponentFactory.Instance.creat("ddtstore.storeTip");
         addChild(this._tip);
      }
      
      protected function initEvent() : void
      {
         this._consortiaManagerBtn.addEventListener(MouseEvent.CLICK,this.assetBtnClickHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,this.__showTipsIII);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,this.__showTip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,this.__showTipsIII);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_ADVANCE,this.__showExaltTips);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_REFINERY,this.__showTipsIII);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EMBED,this.__showTipsIII);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,this.__openHoleComplete);
         this._storeBag.getView().addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._storeBag.getView().addEventListener(StoreDargEvent.START_DARG,this.startShine);
         this._storeBag.getView().addEventListener(StoreDargEvent.STOP_DARG,this.stopShine);
         this._storeview.addEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
         this._storeview.addEventListener(StoreIIEvent.EMBED_CLICK,this.embedClickHandler);
         this._storeview.addEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._changeConsortia);
         this._storeview.StrengthPanel.addEventListener(StoreIIStrengthBG.WEAPONUPGRADESPLAY,this.__weaponUpgradesPlay);
      }
      
      protected function removeEvent() : void
      {
         this._consortiaManagerBtn.removeEventListener(MouseEvent.CLICK,this.assetBtnClickHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,this.__showTipsIII);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,this.__showTip);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_ADVANCE,this.__showExaltTips);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,this.__showTipsIII);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_REFINERY,this.__showTipsIII);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_EMBED,this.__showTipsIII);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,this.__openHoleComplete);
         this._storeBag.getView().removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._storeBag.getView().removeEventListener(StoreDargEvent.START_DARG,this.startShine);
         this._storeBag.getView().removeEventListener(StoreDargEvent.STOP_DARG,this.stopShine);
         this._storeview.removeEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
         this._storeview.removeEventListener(StoreIIEvent.EMBED_CLICK,this.embedClickHandler);
         this._storeview.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._changeConsortia);
         this._storeview.StrengthPanel.removeEventListener(StoreIIStrengthBG.WEAPONUPGRADESPLAY,this.__weaponUpgradesPlay);
      }
      
      public function setAutoLinkNum(num:int) : void
      {
         this._model.NeedAutoLink = num;
      }
      
      private function refresh(evt:ChoosePanelEvnet) : void
      {
         this._model.currentPanel = evt.currentPanle;
         this._storeBag.setList(this._model);
         this._storeBag.changeMsg(this._model.currentPanel + 1);
      }
      
      private function __cellDoubleClick(evt:CellEvent) : void
      {
         evt.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            SoundManager.instance.play("008");
            BaglockedManager.Instance.show();
            return;
         }
         var sourceCell:BagCell = evt.data as StoreBagCell;
         var currentPanel:IStoreViewBG = this._storeview.currentPanel;
         currentPanel.dragDrop(sourceCell);
      }
      
      private function autoLink(bagType:int, pos:int) : void
      {
         var sourceCell:BagCell = null;
         var currentPanel:IStoreViewBG = this._storeview.currentPanel;
         if(bagType == BagInfo.EQUIPBAG)
         {
            sourceCell = this._storeBag.getEquipCell(pos);
         }
         else
         {
            sourceCell = this._storeBag.getPropCell(pos);
         }
         currentPanel.dragDrop(sourceCell);
      }
      
      private function startShine(evt:StoreDargEvent) : void
      {
         var spnl:StoreIIStrengthBG = null;
         var cpnl:StoreIIComposeBG = null;
         var fpnl:StoreIIFusionBG = null;
         var currentPanel:IStoreViewBG = this._storeview.currentPanel;
         if(currentPanel is StoreIIStrengthBG)
         {
            spnl = currentPanel as StoreIIStrengthBG;
            if(evt.sourceInfo.CanEquip)
            {
               spnl.startShine(1);
            }
            else if(EquipType.isStrengthStone(evt.sourceInfo))
            {
               spnl.startShine(0);
            }
         }
         else if(currentPanel is StoreIIComposeBG)
         {
            cpnl = currentPanel as StoreIIComposeBG;
            if(evt.sourceInfo.CanEquip)
            {
               cpnl.startShine(1);
            }
            else if(evt.sourceInfo.Property1 == StoneType.COMPOSE)
            {
               cpnl.startShine(2);
            }
            else if(evt.sourceInfo.Property1 == StoneType.LUCKY)
            {
               cpnl.startShine(0);
            }
         }
         else if(currentPanel is StoreIIFusionBG)
         {
            fpnl = currentPanel as StoreIIFusionBG;
            if(evt.sourceInfo.Property1 == StoneType.FORMULA)
            {
               fpnl.startShine(0);
            }
            else if(EquipType.isFusion(evt.sourceInfo))
            {
               fpnl.startShine(1);
               fpnl.startShine(2);
               fpnl.startShine(3);
               fpnl.startShine(4);
            }
         }
         else if(currentPanel is StoreEmbedBG)
         {
            if(evt.sourceInfo.CanEquip)
            {
               (currentPanel as StoreEmbedBG).startShine();
            }
            else
            {
               if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "1")
               {
                  (currentPanel as StoreEmbedBG).stoneStartShine(1,evt.sourceInfo as InventoryItemInfo);
               }
               if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "2")
               {
                  (currentPanel as StoreEmbedBG).stoneStartShine(2,evt.sourceInfo as InventoryItemInfo);
               }
               if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "3")
               {
                  (currentPanel as StoreEmbedBG).stoneStartShine(3,evt.sourceInfo as InventoryItemInfo);
               }
            }
            currentPanel = null;
         }
      }
      
      private function stopShine(evt:StoreDargEvent) : void
      {
         if(this._storeview.currentPanel is StoreIIStrengthBG)
         {
            (this._storeview.currentPanel as StoreIIStrengthBG).stopShine();
         }
         else if(this._storeview.currentPanel is StoreIIComposeBG)
         {
            (this._storeview.currentPanel as StoreIIComposeBG).stopShine();
         }
         else if(this._storeview.currentPanel is StoreIIFusionBG)
         {
            (this._storeview.currentPanel as StoreIIFusionBG).stopShine();
         }
         else if(this._storeview.currentPanel is StoreIITransferBG)
         {
            (this._storeview.currentPanel as StoreIITransferBG).stopShine();
         }
         else if(this._storeview.currentPanel is StoreEmbedBG)
         {
            (this._storeview.currentPanel as StoreEmbedBG).stopShine();
         }
      }
      
      private function __weaponUpgradesPlay(e:Event) : void
      {
         var info:InventoryItemInfo = null;
         var storeIIStrengthBG:StoreIIStrengthBG = this._storeview.StrengthPanel;
         TaskManager.instance.checkHighLight();
         this._tip.showStrengthSuccess(storeIIStrengthBG.getStrengthItemCellInfo(),this._tipFlag);
         if(this._tipFlag)
         {
            info = storeIIStrengthBG.getStrengthItemCellInfo();
            this.appearHoleTips(info);
            this.checkHasStrengthLevelThree(info);
         }
      }
      
      private function __showTip(evt:CrazyTankSocketEvent) : void
      {
         this._tip.isDisplayerTip = true;
         var success:int = evt.pkg.readByte();
         this._tipFlag = evt.pkg.readBoolean();
         var storeIIStrengthBG:StoreIIStrengthBG = this._storeview.currentPanel as StoreIIStrengthBG;
         if(success != 0)
         {
            if(success == 1)
            {
               storeIIStrengthBG.starMoviePlay();
            }
            else if(success == 2)
            {
               this._tip.showFiveFail();
            }
            else if(success == 3)
            {
               ConsortiaRateManager.instance.reset();
            }
         }
      }
      
      protected function __showExaltTips(event:CrazyTankSocketEvent) : void
      {
         var success:int = event.pkg.readByte();
         var lucky:int = event.pkg.readInt();
         if(success == 0)
         {
            this._tip.showSuccess();
            StrengthDataManager.instance.exaltFinish();
         }
         else
         {
            StrengthDataManager.instance.exaltFail(lucky);
         }
      }
      
      private function checkHasStrengthLevelThree(info:InventoryItemInfo) : void
      {
         if(PlayerManager.Instance.Self.Grade < 15 && this._model.checkEmbeded() && SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] == undefined && info.StrengthenLevel == 3)
         {
            SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] = true;
            SharedManager.Instance.save();
         }
      }
      
      private function __showTipsIII(evt:CrazyTankSocketEvent) : void
      {
         this._tip.isDisplayerTip = true;
         var success:int = evt.pkg.readByte();
         if(success == 0)
         {
            switch(evt.type)
            {
               case CrazyTankSocketEvent.ITEM_TRANSFER:
                  this._tip.showSuccess(StoreTips.TRANSFER);
                  if(this._storeview.currentPanel is StoreIITransferBG)
                  {
                     (this._storeview.currentPanel as StoreIITransferBG).clearTransferItemCell();
                  }
                  break;
               case CrazyTankSocketEvent.ITEM_EMBED:
                  this._tip.showSuccess(StoreTips.EMBED);
                  break;
               default:
                  this._tip.showSuccess();
            }
         }
         else if(success == 1)
         {
            switch(evt.type)
            {
               case CrazyTankSocketEvent.ITEM_ADVANCE:
                  break;
               default:
                  this._tip.showFail();
            }
         }
         else if(success == 3)
         {
            ConsortiaRateManager.instance.reset();
         }
      }
      
      private function __openHoleComplete(evt:CrazyTankSocketEvent) : void
      {
         var embedPannel:StoreEmbedBG = null;
         this._tip.isDisplayerTip = true;
         var success:int = evt.pkg.readByte();
         var isLvUp:Boolean = evt.pkg.readBoolean();
         var hole:int = evt.pkg.readInt();
         if(success == 0)
         {
            embedPannel = this._storeview.currentPanel as StoreEmbedBG;
            if(isLvUp)
            {
               SoundManager.instance.pauseMusic();
               SoundManager.instance.play("063",false,false);
               this._soundTimer.reset();
               this._soundTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__soundComplete);
               this._soundTimer.start();
               embedPannel.holeLvUp(hole - 1);
            }
         }
         else if(success == 1)
         {
            this._tip.showFail();
         }
      }
      
      private function __soundComplete(event:TimerEvent) : void
      {
         this._soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__soundComplete);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
      }
      
      private function __showTipII(evt:CrazyTankSocketEvent) : void
      {
      }
      
      private function appearHoleTips(info:InventoryItemInfo) : void
      {
         SoundManager.instance.play("1001");
      }
      
      private function showHoleTip(info:InventoryItemInfo) : void
      {
         if(info.CategoryID == 1)
         {
            if(info.StrengthenLevel == 3 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenProperty"));
            }
            if(info.StrengthenLevel == 6)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenDefense"));
            }
         }
         if(info.CategoryID == 5)
         {
            if(info.StrengthenLevel == 3 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenProperty"));
            }
            if(info.StrengthenLevel == 6)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenDefense"));
            }
         }
         if(info.CategoryID == 7)
         {
            if(info.StrengthenLevel == 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenAttack"));
            }
            if(info.StrengthenLevel == 6 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenProperty"));
            }
         }
      }
      
      private function assetBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      protected function matteGuideEmbed() : void
      {
         this._guideEmbed = ComponentFactory.Instance.creat("asset.ddtstore.TutorialStepAsset");
         this._guideEmbed.gotoAndStop(1);
         LayerManager.Instance.addToLayer(this._guideEmbed,LayerManager.GAME_TOP_LAYER);
      }
      
      private function embedClickHandler(event:StoreIIEvent) : void
      {
         if(Boolean(this._guideEmbed))
         {
            this._guideEmbed.gotoAndStop(6);
         }
      }
      
      private function embedInfoChangeHandler(event:StoreIIEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(Boolean(this._guideEmbed))
         {
            this._guideEmbed.gotoAndStop(11);
            event.stopImmediatePropagation();
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("store.states.embedTitle"),LanguageMgr.GetTranslation("tank.view.store.matteTips"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.info.showCancel = false;
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._response);
         }
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK || evt.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.okFunction();
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function okFunction() : void
      {
         if(Boolean(this._guideEmbed))
         {
            ObjectUtils.disposeObject(this._guideEmbed);
         }
         this._guideEmbed = null;
      }
      
      public function set type(cType:String) : void
      {
         this._consortiaManagerBtn.visible = PlayerManager.Instance.Self.ConsortiaID != 0 ? true : false;
      }
      
      private function _changeConsortia(e:Event) : void
      {
         this._consortiaManagerBtn.visible = PlayerManager.Instance.Self.ConsortiaID != 0 ? true : false;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(Boolean(this._storeview))
         {
            if(visible)
            {
               this._storeview.refreshCurrentPanel();
            }
            else
            {
               this._storeview.deleteSomeDataTemp();
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._storeview))
         {
            ObjectUtils.disposeObject(this._storeview);
         }
         this._storeview = null;
         if(Boolean(this._tip))
         {
            ObjectUtils.disposeObject(this._tip);
         }
         this._tip = null;
         if(Boolean(this._consortiaManagerBtn))
         {
            ObjectUtils.disposeObject(this._consortiaManagerBtn);
         }
         this._consortiaManagerBtn = null;
         if(Boolean(this._consortiaBtnEffect))
         {
            ObjectUtils.disposeObject(this._consortiaBtnEffect);
         }
         this._consortiaBtnEffect = null;
         if(Boolean(this._guideEmbed))
         {
            ObjectUtils.disposeObject(this._guideEmbed);
         }
         this._guideEmbed = null;
         if(Boolean(this._storeBag))
         {
            ObjectUtils.disposeObject(this._storeBag);
         }
         this._storeBag = null;
         this._controller = null;
         this._model.currentPanel = StoreMainView.STRENGTH;
         this._model = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

