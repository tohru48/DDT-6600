package petsBag.view
{
   import bagAndInfo.bag.BagView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.PetsBagManager;
   import petsBag.controller.PetBagController;
   import store.HelpFrame;
   
   public class PetsView extends Frame
   {
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _bottom:ScaleBitmapImage;
      
      private var _petsBagOutView:PetsBagOutView;
      
      private var _bagView:BagView;
      
      public function PetsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("petBag.view.titleText");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.helpBtn");
         addToContent(this._helpBtn);
         this._bottom = ComponentFactory.Instance.creatComponentByStylename("petsBag.petsView.frameBottom");
         addToContent(this._bottom);
         this._petsBagOutView = ComponentFactory.Instance.creatCustomObject("petsBagOutPnl");
         addToContent(this._petsBagOutView);
         this._petsBagOutView.infoPlayer = PlayerManager.Instance.Self;
         PetBagController.instance().view = this._petsBagOutView;
         this._bagView = new BagView();
         this._bagView.sortBagEnable = false;
         this._bagView.breakBtnEnable = false;
         this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         this._bagView.isScreenFood = true;
         this._bagView.setBagType(BagView.PET);
         this._bagView.info = PlayerManager.Instance.Self;
         this._bagView.enableOrdisableSB(true);
         this._bagView.showOrHideSB(true);
         this._bagView.enableDressSelectedBtn(false);
         this._bagView.deleteButtonForPet();
         PlayerManager.Instance.Self.PropBag.sortBag(5,PlayerManager.Instance.Self.getBag(5),0,48,false);
         PositionUtils.setPos(this._bagView,"petsBagView.bagView.pos");
         addToContent(this._bagView);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onPetsHelp);
         this._bagView.addEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.addEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.addEventListener(BagView.TABCHANGE,this.__changeHandler);
         PetsBagManager.instance.addEventListener("equitClick",this._clickEquit);
      }
      
      private function _clickEquit(e:Event) : void
      {
         this._bagView.setBagType(BagView.EQUIP);
      }
      
      private function __startShine(event:CellEvent) : void
      {
         if(event.data is ItemTemplateInfo)
         {
            if((event.data as ItemTemplateInfo).CategoryID == EquipType.FOOD)
            {
               if(Boolean(this._petsBagOutView))
               {
                  this._petsBagOutView.startShine();
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_ARM)
            {
               if(Boolean(this._petsBagOutView))
               {
                  this._petsBagOutView.playShined(0);
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_CLOTH)
            {
               if(Boolean(this._petsBagOutView))
               {
                  this._petsBagOutView.playShined(2);
               }
            }
            else if((event.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_HEAD)
            {
               if(Boolean(this._petsBagOutView))
               {
                  this._petsBagOutView.playShined(1);
               }
            }
         }
      }
      
      private function __stopShine(event:CellEvent) : void
      {
         if(Boolean(this._petsBagOutView))
         {
            this._petsBagOutView.stopShine();
         }
         if(Boolean(this._petsBagOutView))
         {
            this._petsBagOutView.stopShined(0);
         }
         if(Boolean(this._petsBagOutView))
         {
            this._petsBagOutView.stopShined(1);
         }
         if(Boolean(this._petsBagOutView))
         {
            this._petsBagOutView.stopShined(2);
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
      }
      
      protected function __onPetsHelp(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("petsBag.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("petsBag.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.petsBag.readme");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onPetsHelp);
         this._bagView.removeEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.removeEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.removeEventListener(BagView.TABCHANGE,this.__changeHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               PetsBagManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._petsBagOutView))
         {
            ObjectUtils.disposeObject(this._petsBagOutView);
         }
         this._petsBagOutView = null;
         PetBagController.instance().view = null;
         if(Boolean(this._bottom))
         {
            ObjectUtils.disposeObject(this._bottom);
         }
         this._bottom = null;
         if(Boolean(this._bagView))
         {
            ObjectUtils.disposeObject(this._bagView);
         }
         this._bagView = null;
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

