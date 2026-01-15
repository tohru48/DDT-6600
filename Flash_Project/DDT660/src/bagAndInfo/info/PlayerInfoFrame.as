package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import beadSystem.views.PlayerBeadInfoView;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import horse.view.HorseInfoView;
   import petsBag.view.PetsBagOtherView;
   import room.RoomManager;
   import texpSystem.view.TexpInfoView;
   import totem.TotemManager;
   import totem.view.TotemInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
      
      private var _BG:ScaleBitmapImage;
      
      private var _view:PlayerInfoView;
      
      private var _texpView:TexpInfoView;
      
      private var _horseView:HorseInfoView;
      
      private var _cardEquip:CardEquipView;
      
      private var _info:*;
      
      private var _petsView:PetsBagOtherView;
      
      private var _beadInfoView:PlayerBeadInfoView;
      
      private var _totemView:TotemInfoView;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _horseBtn:SelectedButton;
      
      private var _cardBtn:SelectedButton;
      
      private var _petBtn:SelectedButton;
      
      private var _beadBtn:SelectedButton;
      
      private var _totemBtn:SelectedButton;
      
      private var _hBox:HBox;
      
      private var _openTexp:Boolean;
      
      private var _openGift:Boolean;
      
      private var _openCard:Boolean;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         _titleText = LanguageMgr.GetTranslation("game.PlayerThumbnailTipItemText_0");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.playerInfoBtn");
         this._horseBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.horseInfoBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardInfoBtn");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.petInfoBtn");
         this._beadBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.beadInfoBtn");
         this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemInfoBtn");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._petBtn);
         addToContent(this._horseBtn);
         addToContent(this._cardBtn);
         addToContent(this._beadBtn);
         addToContent(this._totemBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._horseBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.addSelectItem(this._petBtn);
         this._btnGroup.addSelectItem(this._beadBtn);
         this._btnGroup.addSelectItem(this._totemBtn);
         this._btnGroup.selectIndex = 0;
         if(Boolean(RoomManager.Instance.current) && PlayerInfoViewControl._isBattle)
         {
            this._infoBtn.visible = false;
            this._petBtn.visible = false;
            this._horseBtn.visible = false;
            this._cardBtn.visible = false;
            this._totemBtn.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._horseBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._beadBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      private function __soundPlayer(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case 1:
               this.showHorseView();
               break;
            case BagAndGiftFrame.CARDVIEW:
               if(!this._openCard)
               {
                  SocketManager.Instance.out.getPlayerCardInfo(this._info.ID);
                  this._openCard = true;
               }
               this.showCardEquip();
               break;
            case BagAndGiftFrame.PETVIEW - 2:
               PlayerInfoViewControl.isOpenFromBag = false;
               this.showPetsView();
               break;
            case BagAndGiftFrame.BEADVIEW - 17:
               this.showBeadInfoView();
               break;
            case 5:
               this.showTotem();
         }
      }
      
      private function showTotem() : void
      {
         if(!this._totemView)
         {
            TotemManager.instance.loadTotemModule(this.doShowTotem);
         }
         else
         {
            this.setVisible(BagAndGiftFrame.TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = new TotemInfoView(this._info);
         addToContent(this._totemView);
         this.setVisible(BagAndGiftFrame.TOTEMVIEW);
      }
      
      private function setVisible(type:int) : void
      {
         if(Boolean(this._view))
         {
            this._view.visible = type == BagAndGiftFrame.BAGANDINFO || type == BagAndGiftFrame.CARDVIEW;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.visible = type == BagAndGiftFrame.TEXPVIEW;
         }
         if(Boolean(this._horseView))
         {
            this._horseView.visible = type == 1;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.visible = type == BagAndGiftFrame.PETVIEW;
         }
         if(Boolean(this._view) && this._view.visible)
         {
            this._view.switchShowII(type == BagAndGiftFrame.CARDVIEW);
         }
         if(Boolean(this._beadInfoView))
         {
            this._beadInfoView.visible = type == BagAndGiftFrame.BEADVIEW;
         }
         if(Boolean(this._totemView))
         {
            this._totemView.visible = type == BagAndGiftFrame.TOTEMVIEW;
         }
      }
      
      private function showBeadInfoView() : void
      {
         try
         {
            if(!this._beadInfoView)
            {
               this._beadInfoView = ComponentFactory.Instance.creatCustomObject("playerBeadInfoView");
               this._beadInfoView.playerInfo = this._info;
               addChild(this._beadInfoView);
            }
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTBEAD);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__showBeadInfoView);
         }
         this.setVisible(BagAndGiftFrame.BEADVIEW);
      }
      
      protected function __showBeadInfoView(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDTBEAD)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showBeadInfoView();
         }
      }
      
      private function showCardEquip() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.CARDVIEW);
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showTexpFrame() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoView.main");
               addToContent(this._texpView);
            }
            if(this._info)
            {
               this._texpView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.TEXPVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
         }
      }
      
      private function __createTexp(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDT_TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpFrame();
         }
      }
      
      private function showPetsView() : void
      {
         try
         {
            if(this._petsView == null)
            {
               this._petsView = ComponentFactory.Instance.creatCustomObject("petsBagOtherPnl.other");
               addToContent(this._petsView);
            }
            if(this._info)
            {
               this._petsView.infoPlayer = this._info;
            }
            this.setVisible(BagAndGiftFrame.PETVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createPets);
         }
      }
      
      private function __createPets(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            this.showPetsView();
         }
      }
      
      private function showHorseView() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.HORSE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(!this._horseView)
            {
               this._horseView = new HorseInfoView();
               PositionUtils.setPos(this._horseView,"PlayerInfoFrame.horseViewPos");
               addToContent(this._horseView);
            }
            this._horseView.info = this._info;
            this.setVisible(1);
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._horseBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._beadBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info($info:*) : void
      {
         this._info = $info;
         if(PlayerInfoViewControl._isBattle)
         {
            if(Boolean(this._view))
            {
               this._view.info = this._info;
            }
            return;
         }
         if(Boolean(this._view))
         {
            this._view.info = this._info;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.info = this._info;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.infoPlayer = this._info;
         }
         if(Boolean(this._horseView))
         {
            this._horseView.info = this._info;
         }
         if(this._info.Grade < 25 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 25 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 28 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._horseBtn.enable = false;
         }
         else
         {
            this._horseBtn.enable = true;
         }
         if(this._info.Grade < 14 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._cardBtn.enable = false;
         }
         else
         {
            this._cardBtn.enable = true;
         }
         if(this._info.Grade < 16 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._beadBtn.enable = false;
         }
         else
         {
            this._beadBtn.enable = true;
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._totemBtn.enable = false;
         }
         else
         {
            this._totemBtn.enable = true;
         }
      }
      
      public function setAchivEnable(val:Boolean) : void
      {
         this._view.setAchvEnable(val);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._infoBtn))
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(Boolean(this._horseBtn))
         {
            ObjectUtils.disposeObject(this._horseBtn);
         }
         this._horseBtn = null;
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._petBtn))
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(Boolean(this._totemBtn))
         {
            ObjectUtils.disposeObject(this._totemBtn);
            this._totemBtn = null;
         }
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this._texpView))
         {
            this._texpView.dispose();
         }
         this._texpView = null;
         if(Boolean(this._horseView))
         {
            this._horseView.dispose();
         }
         this._horseView = null;
         if(Boolean(this._petsView))
         {
            this._petsView.dispose();
            this._petsView = null;
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

