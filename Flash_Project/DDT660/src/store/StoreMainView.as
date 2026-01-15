package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import store.events.ChoosePanelEvnet;
   import store.events.StoreIIEvent;
   import store.newFusion.view.FusionNewMainView;
   import store.view.Compose.StoreIIComposeBG;
   import store.view.exalt.StoreExaltBG;
   import store.view.strength.StoreIIStrengthBG;
   import store.view.transfer.StoreIITransferBG;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class StoreMainView extends Sprite implements Disposeable
   {
      
      public static const STRENGTH:int = 0;
      
      public static const COMPOSE:int = 1;
      
      public static const FUSION:int = 2;
      
      public static const LIANGHUA:int = 4;
      
      public static const TRANSF:int = 5;
      
      public static const EXALT:int = 3;
      
      private var _composePanel:StoreIIComposeBG;
      
      private var _strengthPanel:StoreIIStrengthBG;
      
      private var _newFusionView:FusionNewMainView;
      
      private var _transferPanel:StoreIITransferBG;
      
      private var _exaltPanel:StoreExaltBG;
      
      private var _currentPanelIndex:int;
      
      private var _tabSelectedButtonContainer:VBox;
      
      private var _tabSelectedButtonGroup:SelectedButtonGroup;
      
      private var strength_btn:SelectedButton;
      
      private var compose_btn:SelectedButton;
      
      private var fusion_btn:SelectedButton;
      
      private var transf_Btn:SelectedButton;
      
      private var _exaltBtn:SelectedButton;
      
      private var bg:ScaleFrameImage;
      
      private var _embedBtn_shine:MovieImage;
      
      private var _disEnabledFilters:Array;
      
      public function StoreMainView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._tabSelectedButtonGroup = new SelectedButtonGroup();
         this._tabSelectedButtonContainer = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.TabSelectedBtnContainer");
         this.bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.MainViewBg");
         addChild(this.bg);
         this.strength_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.StrengthenTabBtn");
         this._tabSelectedButtonContainer.addChild(this.strength_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.strength_btn);
         if(!this._disEnabledFilters)
         {
            this._disEnabledFilters = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
         }
         this._exaltBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.exaltBtn");
         this._tabSelectedButtonContainer.addChild(this._exaltBtn);
         this._tabSelectedButtonGroup.addSelectItem(this._exaltBtn);
         if(PathManager.exaltEnable)
         {
            this._exaltBtn.enable = true;
            this._exaltBtn.filters = null;
         }
         else
         {
            this._exaltBtn.enable = false;
            this._exaltBtn.filters = this._disEnabledFilters;
         }
         this.compose_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.ComposeTabBtn");
         this._tabSelectedButtonContainer.addChild(this.compose_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.compose_btn);
         this.transf_Btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.TransferTabBtn");
         this._tabSelectedButtonContainer.addChild(this.transf_Btn);
         this._tabSelectedButtonGroup.addSelectItem(this.transf_Btn);
         this.fusion_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.FusionTabBtn");
         this._tabSelectedButtonContainer.addChild(this.fusion_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.fusion_btn);
         this._embedBtn_shine = ComponentFactory.Instance.creatComponentByStylename("ddtstore.embed_btnMC");
         addChild(this._embedBtn_shine);
         this._tabSelectedButtonGroup.selectIndex = 0;
         addChild(this._tabSelectedButtonContainer);
         this._strengthPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBGView");
         this._composePanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIICompose");
         this._transferPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransfer");
         this._exaltPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.exalt.StoreExaltBG");
         addChild(this._strengthPanel);
         this._strengthPanel.show();
         addChild(this._composePanel);
         addChild(this._transferPanel);
         addChild(this._exaltPanel);
         this._embedBtn_shine.mouseEnabled = false;
         this._embedBtn_shine.mouseChildren = false;
         this._embedBtn_shine.movie.gotoAndStop(1);
         this.bg.setFrame(1);
         this._tabSelectedButtonContainer.arrange();
         this.currentPanelIndex = STRENGTH;
         this.changeToTab(this.currentPanelIndex);
      }
      
      public function changeToConsortiaState() : void
      {
         this._strengthPanel.consortiaRate();
      }
      
      public function changeToBaseState() : void
      {
         this._strengthPanel.consortiaRate();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._tabSelectedButtonGroup.addEventListener(Event.CHANGE,this.__groupChangeHandler);
         this.strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.addEventListener(MouseEvent.CLICK,this.__composeClick);
         this.fusion_btn.addEventListener(MouseEvent.CLICK,this.__fusionClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this._exaltBtn.addEventListener(MouseEvent.CLICK,this.__exaltBtnClick);
         this._strengthPanel.addEventListener(Event.CHANGE,this.changeHandler);
      }
      
      protected function __exaltBtnClick(event:MouseEvent) : void
      {
         this.bg.visible = true;
         if(this.currentPanelIndex == EXALT)
         {
            return;
         }
         this.currentPanelIndex = EXALT;
         this.changeToTab(this.currentPanelIndex);
      }
      
      protected function __groupChangeHandler(event:Event) : void
      {
         this._tabSelectedButtonContainer.arrange();
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this.strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.removeEventListener(MouseEvent.CLICK,this.__composeClick);
         this.fusion_btn.removeEventListener(MouseEvent.CLICK,this.__fusionClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this._strengthPanel.removeEventListener(Event.CHANGE,this.changeHandler);
         this._exaltBtn.removeEventListener(MouseEvent.CLICK,this.__exaltBtnClick);
      }
      
      private function changeHandler(evt:Event) : void
      {
         this._embedBtn_shine.movie.gotoAndStop(1);
      }
      
      private function __updateStoreBag(evt:BagEvent) : void
      {
         this.currentPanel.refreshData(evt.changedSlots);
      }
      
      public function set currentPanelIndex(cp:int) : void
      {
         this._currentPanelIndex = cp;
         dispatchEvent(new ChoosePanelEvnet(this._currentPanelIndex));
      }
      
      public function get currentPanelIndex() : int
      {
         return this._currentPanelIndex;
      }
      
      public function get currentPanel() : IStoreViewBG
      {
         switch(this.currentPanelIndex)
         {
            case STRENGTH:
               return this._strengthPanel;
            case COMPOSE:
               return this._composePanel;
            case FUSION:
               if(!this._newFusionView)
               {
                  this._newFusionView = new FusionNewMainView();
                  PositionUtils.setPos(this._newFusionView,"store.newFusion.mainViewPos");
                  addChild(this._newFusionView);
               }
               return this._newFusionView;
            case TRANSF:
               return this._transferPanel;
            case EXALT:
               return this._exaltPanel;
            default:
               return null;
         }
      }
      
      public function get StrengthPanel() : StoreIIStrengthBG
      {
         return this._strengthPanel;
      }
      
      private function __strengthClick(evt:MouseEvent) : void
      {
         this.bg.visible = true;
         if(this.currentPanelIndex == STRENGTH)
         {
            return;
         }
         this.currentPanelIndex = STRENGTH;
         if(evt == null)
         {
            this.changeToTab(this.currentPanelIndex,false);
         }
         else
         {
            this.changeToTab(this.currentPanelIndex);
         }
      }
      
      private function __composeClick(evt:MouseEvent) : void
      {
         this.bg.visible = true;
         if(this.currentPanelIndex == COMPOSE)
         {
            return;
         }
         this.currentPanelIndex = COMPOSE;
         this.changeToTab(this.currentPanelIndex);
      }
      
      public function skipFromWantStrong(skipType:int) : void
      {
         this.currentPanelIndex = skipType;
         if(skipType == COMPOSE)
         {
            this._tabSelectedButtonGroup.selectIndex = 2;
         }
         else if(skipType == FUSION)
         {
            this._tabSelectedButtonGroup.selectIndex = 4;
         }
         else if(skipType == EXALT)
         {
            this._tabSelectedButtonGroup.selectIndex = 1;
         }
         else if(skipType == TRANSF)
         {
            this._tabSelectedButtonGroup.selectIndex = 3;
         }
         this.changeToTab(this.currentPanelIndex);
      }
      
      private function __fusionClick(evt:MouseEvent) : void
      {
         if(this.currentPanelIndex == FUSION)
         {
            return;
         }
         this.currentPanelIndex = FUSION;
         this.changeToTab(this.currentPanelIndex);
         this.bg.visible = false;
      }
      
      private function __lianhuaClick(evt:MouseEvent) : void
      {
      }
      
      private function __transferClick(evt:MouseEvent) : void
      {
         this.bg.visible = true;
         if(this.currentPanelIndex == TRANSF)
         {
            return;
         }
         this.currentPanelIndex = TRANSF;
         this.changeToTab(this.currentPanelIndex);
      }
      
      private function changeToTab(panelIndex:int, playMusic:Boolean = true) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         SoundManager.instance.play("008");
         this._composePanel.hide();
         this._strengthPanel.hide();
         if(Boolean(this._newFusionView))
         {
            this._newFusionView.hide();
         }
         this._transferPanel.hide();
         this._exaltPanel.hide();
         if(Boolean(this.currentPanel))
         {
            this.currentPanel.show();
         }
         this.bg.setFrame(panelIndex + 1);
         this._embedBtn_shine.movie.gotoAndStop(1);
         this.judgePointComposeArrow();
      }
      
      private function judgePointComposeArrow() : void
      {
         var tmpInfo:QuestInfo = null;
         if(this.currentPanelIndex != COMPOSE)
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_COMPOSE))
            {
               tmpInfo = TaskManager.instance.getQuestByID(566);
               if(TaskManager.instance.isAvailableQuest(tmpInfo,true) && !tmpInfo.isCompleted)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.COM_WEAPON,270,new Point(57,348),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
            }
         }
      }
      
      private function __openAssetManager(evt:MouseEvent) : void
      {
      }
      
      private function sortBtn() : void
      {
         addChild(this.fusion_btn);
         addChild(this.transf_Btn);
         addChild(this.compose_btn);
         addChild(this._exaltBtn);
         addChild(this.strength_btn);
      }
      
      public function shineEmbedBtn() : void
      {
         addChild(this._embedBtn_shine);
         this._embedBtn_shine.movie.play();
      }
      
      private function embedInfoChangeHandler(event:StoreIIEvent) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
      }
      
      public function refreshCurrentPanel() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._composePanel.hide();
         this._strengthPanel.hide();
         if(Boolean(this._newFusionView))
         {
            this._newFusionView.hide();
         }
         this._transferPanel.hide();
         this._exaltPanel.hide();
         if(Boolean(this.currentPanel))
         {
            this.currentPanel.show();
         }
      }
      
      public function deleteSomeDataTemp() : void
      {
         this._strengthPanel.hide();
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._composePanel))
         {
            ObjectUtils.disposeObject(this._composePanel);
         }
         this._composePanel = null;
         if(Boolean(this._strengthPanel))
         {
            ObjectUtils.disposeObject(this._strengthPanel);
         }
         this._strengthPanel = null;
         ObjectUtils.disposeObject(this._newFusionView);
         this._newFusionView = null;
         if(Boolean(this._transferPanel))
         {
            ObjectUtils.disposeObject(this._transferPanel);
         }
         this._transferPanel = null;
         ObjectUtils.disposeObject(this._exaltPanel);
         this._exaltPanel = null;
         ObjectUtils.disposeObject(this._exaltBtn);
         this._exaltBtn = null;
         if(Boolean(this.bg))
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         if(Boolean(this._tabSelectedButtonContainer))
         {
            this._tabSelectedButtonContainer.dispose();
            this._tabSelectedButtonContainer = null;
         }
         if(Boolean(this._tabSelectedButtonGroup))
         {
            ObjectUtils.disposeObject(this._tabSelectedButtonGroup);
         }
         this._tabSelectedButtonGroup = null;
         if(Boolean(this.strength_btn))
         {
            ObjectUtils.disposeObject(this.strength_btn);
         }
         this.strength_btn = null;
         if(Boolean(this.transf_Btn))
         {
            ObjectUtils.disposeObject(this.transf_Btn);
         }
         this.transf_Btn = null;
         if(Boolean(this.compose_btn))
         {
            ObjectUtils.disposeObject(this.compose_btn);
         }
         this.compose_btn = null;
         if(Boolean(this._embedBtn_shine))
         {
            ObjectUtils.disposeObject(this._embedBtn_shine);
         }
         this._embedBtn_shine = null;
         if(Boolean(this.fusion_btn))
         {
            ObjectUtils.disposeObject(this.fusion_btn);
         }
         this.fusion_btn = null;
         SocketManager.Instance.out.sendClearStoreBag();
         SocketManager.Instance.out.sendSaveDB();
         TaskManager.instance.addEquipUpdateListener();
         NewHandContainer.Instance.clearArrowByID(ArrowType.COM_WEAPON);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

