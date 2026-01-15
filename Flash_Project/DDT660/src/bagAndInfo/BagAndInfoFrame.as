package bagAndInfo
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.info.PlayerInfoView;
   import beadSystem.views.BeadInfoView;
   import cardSystem.data.CardInfo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import flash.events.Event;
   import petsBag.controller.PetBagController;
   import petsBag.view.PetsBagOutView;
   import playerDress.PlayerDressManager;
   import playerDress.views.PlayerDressView;
   import texpSystem.view.TexpView;
   
   public class BagAndInfoFrame extends Sprite implements Disposeable
   {
      
      private var _info:SelfInfo;
      
      public var _infoView:PlayerInfoView;
      
      private var _texpView:TexpView;
      
      public var _bagView:BagView;
      
      private var _petsView:PetsBagOutView;
      
      private var _beadInfoView:BeadInfoView;
      
      private var _playerDressView:PlayerDressView;
      
      private var _currentType:int;
      
      private var _visible:Boolean = false;
      
      private var _isFirstOpenBead:Boolean = true;
      
      private var _isLoadBeadComplete:Boolean = false;
      
      private var _isLoadStoreComplete:Boolean = false;
      
      public function BagAndInfoFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
         addChild(this._bagView);
         this._infoView = ComponentFactory.Instance.creatCustomObject("bagAndInfoPersonalInfoView");
         this._infoView.showSelfOperation = true;
         addChild(this._infoView);
      }
      
      private function initEvents() : void
      {
         this._bagView.addEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.addEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.addEventListener(BagView.TABCHANGE,this.__changeHandler);
      }
      
      private function removeEvents() : void
      {
         this._bagView.removeEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.removeEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.removeEventListener(BagView.TABCHANGE,this.__changeHandler);
      }
      
      public function set isScreenFood(value:Boolean) : void
      {
         this._bagView.isScreenFood = value;
      }
      
      public function switchShow(type:int, bagtype:int = 0) : void
      {
         this.info = PlayerManager.Instance.Self;
         this._currentType = type;
         this._bagView.enableOrdisableSB(true);
         this._bagView.showOrHideSB(true);
         if(type == BagAndGiftFrame.BAGANDINFO)
         {
            if(Boolean(this._texpView))
            {
               this._texpView.visible = false;
            }
            if(Boolean(this._petsView))
            {
               this._petsView.visible = false;
            }
            this.bagType = bagtype;
            this._bagView.itemtabBtn = 1;
            this._bagView.isNeedCard(true);
            this._bagView.tableEnable = true;
            this._bagView.cardbtnVible = false;
            this._bagView.sortBagEnable = true;
            this._bagView.breakBtnEnable = true;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this._infoView.visible = bagtype == 8 ? false : true;
         }
         else if(type == BagAndGiftFrame.TEXPVIEW)
         {
            this._infoView.visible = false;
            this._bagView.tableEnable = false;
            this._bagView.itemtabBtn = 2;
            this._bagView.isNeedCard(false);
            this._bagView.cardbtnVible = true;
            this._bagView.cardbtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.sortBagEnable = false;
            this._bagView.breakBtnEnable = false;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.enableDressSelectedBtn(false);
            this.showTexpView();
         }
         else if(type == BagAndGiftFrame.PETVIEW)
         {
            this._infoView.visible = false;
            this._bagView.tableEnable = false;
            this._bagView.isNeedCard(false);
            this._bagView.cardbtnVible = true;
            this._bagView.sortBagEnable = false;
            this._bagView.breakBtnEnable = false;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.cardbtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.enableDressSelectedBtn(false);
            this.showPetsView();
         }
         else if(type == BagAndGiftFrame.BEADVIEW)
         {
            this._infoView.visible = false;
            this._bagView.itemtabBtn = 3;
            this._bagView.isNeedCard(true);
            this._bagView.tableEnable = true;
            this._bagView.cardbtnVible = false;
            this._bagView.sortBagEnable = true;
            this._bagView.breakBtnEnable = true;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this.bagType = BagView.BEAD;
            this._currentType = BagAndGiftFrame.BEADVIEW;
            this.showBeadInfoView();
            this._bagView.enableOrdisableSB(false);
         }
      }
      
      public function clearTexpInfo() : void
      {
         if(Boolean(this._texpView))
         {
            this._texpView.clearInfo();
         }
         if(Boolean(this._petsView))
         {
            this._petsView.clearInfo();
         }
      }
      
      private function showTexpView() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.main");
               addChild(this._texpView);
            }
            if(Boolean(this._petsView))
            {
               this._petsView.visible = false;
            }
            this.bagType = BagView.PROP;
            this._texpView.visible = true;
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
            this.showTexpView();
         }
      }
      
      private function showPetsView() : void
      {
         try
         {
            if(this._petsView == null)
            {
               this._petsView = ComponentFactory.Instance.creatCustomObject("petsBagOutPnl");
               addChild(this._petsView);
            }
            if(Boolean(this._texpView))
            {
               this._texpView.visible = false;
            }
            this.bagType = BagView.PET;
            this._petsView.visible = true;
            this._petsView.infoPlayer = PlayerManager.Instance.Self;
            PetBagController.instance().view = this._petsView;
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onPetsSmallLoadingClose);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createPets);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onPetsUIProgress);
         }
      }
      
      private function __createPets(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onPetsSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onPetsUIProgress);
            this.showPetsView();
         }
      }
      
      private function __onPetsSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onPetsSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onPetsUIProgress);
      }
      
      private function __onPetsUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         if(this._bagView.bagType == BagAndGiftFrame.BEADVIEW)
         {
            this._currentType = BagAndGiftFrame.BEADVIEW;
            this.showBeadInfoView();
            this._bagView.switchButtomVisible(false);
            if(Boolean(this._playerDressView))
            {
               this._playerDressView.visible = false;
            }
            return;
         }
         this._bagView.switchButtomVisible(true);
         if(Boolean(this._beadInfoView))
         {
            this._beadInfoView.visible = false;
         }
         if(this._bagView.bagType == BagAndGiftFrame.DRESSVIEW)
         {
            this._currentType = BagAndGiftFrame.DRESSVIEW;
            PlayerDressManager.instance.loadPlayerDressModule(this.showPlayerDressView);
            return;
         }
         if(Boolean(this._playerDressView))
         {
            this._playerDressView.visible = false;
         }
         if(this._currentType != BagAndGiftFrame.CARDVIEW && this._currentType != BagAndGiftFrame.PETVIEW && this._currentType != BagAndGiftFrame.TEXPVIEW)
         {
            this._infoView.switchShow(false);
            this._infoView.visible = true;
         }
      }
      
      private function showPlayerDressView() : void
      {
         if(!this._playerDressView)
         {
            this._playerDressView = ComponentFactory.Instance.creatCustomObject("playerDress.playerDressView");
            addChild(this._playerDressView);
         }
         else
         {
            this._playerDressView.visible = true;
            this._playerDressView.updateModel();
         }
         if(Boolean(this._petsView))
         {
            this._petsView.visible = false;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.visible = false;
         }
         if(Boolean(this._infoView))
         {
            this._infoView.visible = false;
         }
      }
      
      private function showBeadInfoView() : void
      {
         if(this._isFirstOpenBead)
         {
            this._isLoadBeadComplete = false;
            this._isLoadStoreComplete = false;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadBeadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadBeadInProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTBEAD);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSTORE);
         }
         else
         {
            if(!this._beadInfoView)
            {
               this._beadInfoView = ComponentFactory.Instance.creatCustomObject("beadInfoView");
               addChild(this._beadInfoView);
               this._bagView.initBeadButton();
            }
            else
            {
               this._beadInfoView.visible = true;
            }
            if(Boolean(this._petsView))
            {
               this._petsView.visible = false;
            }
            if(Boolean(this._texpView))
            {
               this._texpView.visible = false;
            }
            if(Boolean(this._infoView))
            {
               this._infoView.visible = false;
            }
         }
      }
      
      private function __onLoadBeadInProgress(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDTBEAD || pEvent.module == UIModuleTypes.DDTSTORE)
         {
            UIModuleSmallLoading.Instance.progress = pEvent.loader.progress * 100;
         }
      }
      
      private function __onLoadBeadComplete(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDTBEAD)
         {
            this._isLoadBeadComplete = true;
         }
         if(pEvent.module == UIModuleTypes.DDTSTORE)
         {
            this._isLoadStoreComplete = true;
         }
         if(this._isLoadBeadComplete && this._isLoadStoreComplete)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadBeadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadBeadInProgress);
            UIModuleSmallLoading.Instance.hide();
            this._isFirstOpenBead = false;
            this.showBeadInfoView();
         }
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadBeadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadBeadInProgress);
      }
      
      private function __stopShine(event:CellEvent) : void
      {
         this._infoView.stopShine();
         if(Boolean(this._beadInfoView))
         {
            this._beadInfoView.stopShine();
         }
         if(Boolean(this._texpView))
         {
            this._texpView.stopShine();
         }
         if(Boolean(this._petsView))
         {
            this._petsView.stopShine();
         }
         if(Boolean(this._petsView))
         {
            this._petsView.stopShined(0);
         }
         if(Boolean(this._petsView))
         {
            this._petsView.stopShined(1);
         }
         if(Boolean(this._petsView))
         {
            this._petsView.stopShined(2);
         }
      }
      
      private function __startShine(event:CellEvent) : void
      {
         if(event.data is ItemTemplateInfo)
         {
            if((event.data as ItemTemplateInfo).CategoryID == EquipType.TEXP)
            {
               if(Boolean(this._texpView))
               {
                  this._texpView.startShine();
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.FOOD)
            {
               if(Boolean(this._petsView))
               {
                  this._petsView.startShine();
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_ARM)
            {
               if(Boolean(this._petsView))
               {
                  this._petsView.playShined(0);
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_CLOTH)
            {
               if(Boolean(this._petsView))
               {
                  this._petsView.playShined(2);
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_HEAD)
            {
               if(Boolean(this._petsView))
               {
                  this._petsView.playShined(1);
               }
            }
            else if((event.data as ItemTemplateInfo).Property1 != "31")
            {
               this._infoView.startShine(event.data as ItemTemplateInfo);
            }
            else
            {
               this._beadInfoView.startShine(event.data as ItemTemplateInfo);
            }
         }
         else if(event.data is CardInfo)
         {
            this._infoView.cardEquipShine(event.data as CardInfo);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._texpView))
         {
            this._texpView.dispose();
            this._texpView = null;
         }
         if(Boolean(this._beadInfoView))
         {
            this._beadInfoView.dispose();
         }
         this._bagView.dispose();
         this._bagView = null;
         this._infoView.dispose();
         this._infoView = null;
         this._info = null;
         if(Boolean(this._petsView))
         {
            this._petsView.dispose();
            this._petsView = null;
         }
         ObjectUtils.disposeObject(this._playerDressView);
         this._playerDressView = null;
         PlayerDressManager.instance.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(value:SelfInfo) : void
      {
         this._info = value;
         this._infoView.info = value;
         this._bagView.info = value;
         this._infoView.allowLvIconClick();
      }
      
      public function set bagType(value:int) : void
      {
         this._bagView.setBagType(value);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

