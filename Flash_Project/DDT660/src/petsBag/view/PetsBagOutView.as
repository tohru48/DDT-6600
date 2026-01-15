package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import pet.sprite.PetSpriteController;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.view.item.FeedItem;
   import road7th.data.DictionaryEvent;
   import road7th.utils.StringHelper;
   import store.HelpFrame;
   import trainer.data.ArrowType;
   
   public class PetsBagOutView extends PetsBagView
   {
      
      private var _rePetNameBtn:TextButton;
      
      private var _revertPetBtn:TextButton;
      
      private var _feedItem:FeedItem;
      
      private var _releaseBtn:TextButton;
      
      private var _convertBtn:TextButton;
      
      private var _unFightBtn:TextButton;
      
      private var _petGameSkillPnl:PetGameSkillPnl;
      
      private var _fightSkillLbl:FilterFrameText;
      
      private var _bg2:Bitmap;
      
      private var _feedBtn:TextButton;
      
      private var _groomBtn:SimpleBitmapButton;
      
      public function PetsBagOutView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._bg2 = ComponentFactory.Instance.creat("assets.petsBag.bg1");
         addChild(this._bg2);
         this._rePetNameBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.rePetName");
         this._rePetNameBtn.text = LanguageMgr.GetTranslation("ddt.pets.rePetName");
         addChild(this._rePetNameBtn);
         this._releaseBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.releaseName");
         this._releaseBtn.text = LanguageMgr.GetTranslation("ddt.pets.release");
         addChild(this._releaseBtn);
         this._convertBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.convert");
         this._convertBtn.text = LanguageMgr.GetTranslation("ddt.pets.convert");
         addChild(this._convertBtn);
         this._revertPetBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.revertPet");
         this._revertPetBtn.text = LanguageMgr.GetTranslation("ddt.pets.revert");
         addChild(this._revertPetBtn);
         this._feedItem = ComponentFactory.Instance.creat("petsBag.feedItem");
         addChild(this._feedItem);
         this._unFightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.unFight");
         addChild(this._unFightBtn);
         this._unFightBtn.text = LanguageMgr.GetTranslation("ddt.pets.unfight");
         this._petGameSkillPnl = ComponentFactory.Instance.creat("petsBag.petGameSkillPnl");
         addChild(this._petGameSkillPnl);
         _petSkillPnl = ComponentFactory.Instance.creat("petsBag.petSkillPnl",[false]);
         addChild(_petSkillPnl);
         this._fightSkillLbl = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.fightSkill");
         addChild(this._fightSkillLbl);
         this._fightSkillLbl.text = LanguageMgr.GetTranslation("ddt.pets.fightSkill");
         _fightBtn.filters = null;
         _fightBtn.mouseChildren = true;
         _fightBtn.mouseEnabled = true;
         _fightBtn.visible = false;
         this._unFightBtn.visible = false;
         this._feedBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.feed");
         addChild(this._feedBtn);
         this._feedBtn.text = LanguageMgr.GetTranslation("ddt.pets.feed");
         this._groomBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.groom");
         addChild(this._groomBtn);
         this.petFarmGuilde();
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_LABEL);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.FEED_PET,50,"farmTrainer.feedPetArrowPos","asset.farmTrainer.feedPet","farmTrainer.feedPetTipPos",this);
         }
         if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] > 0)
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.CHOOSE_PET_SKILL,30,"farmTrainer.petSkillConfigArrowPos","asset.farmTrainer.petSkillConfig","farmTrainer.petSkillConfigTipPos",this);
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._rePetNameBtn.addEventListener(MouseEvent.CLICK,this.__rePetName);
         this._releaseBtn.addEventListener(MouseEvent.CLICK,this.__releasePet);
         this._convertBtn.addEventListener(MouseEvent.CLICK,this.__convertPet);
         this._revertPetBtn.addEventListener(MouseEvent.CLICK,this.__revertPet);
         this._unFightBtn.addEventListener(MouseEvent.CLICK,this.__unFight);
         _fightBtn.addEventListener(MouseEvent.CLICK,this.__fight);
         this._feedBtn.addEventListener(MouseEvent.CLICK,this.__feedPet);
         this._groomBtn.addEventListener(MouseEvent.CLICK,this.__groomPet);
      }
      
      override protected function __onChange(event:Event) : void
      {
         super.__onChange(event);
         this.switchFightUnFight(Boolean(_currentPet) && !_currentPet.IsEquip);
      }
      
      override public function set infoPlayer(value:PlayerInfo) : void
      {
         super.infoPlayer = value;
         this.addInfoChangeEvent();
         if(Boolean(PetBagController.instance().petModel.currentPetInfo) && PetBagController.instance().petModel.currentPetInfo.IsEquip)
         {
            if(PetBagController.instance().petModel.currentPetInfo.Hunger / PetHappyBar.fullHappyValue < 0.5)
            {
               SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place,false);
               PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
            }
         }
      }
      
      override public function updatePetBagView() : void
      {
         super.updatePetBagView();
         if(!hasPet)
         {
            this.mouseChildren = true;
            this.clearInfo();
            this._petGameSkillPnl.mouseChildren = false;
            _fightBtn.visible = hasPet;
            this._unFightBtn.visible = hasPet;
         }
         else
         {
            this.switchFightUnFight(Boolean(_currentPet) && !_currentPet.IsEquip);
         }
         this.updateGameSkill();
         if(_currentPet && _currentPet.GP > 0 && !_currentPet.IsEquip)
         {
            this._revertPetBtn.enable = true;
         }
         else
         {
            this._revertPetBtn.enable = false;
         }
      }
      
      private function updateGameSkill() : void
      {
         this._petGameSkillPnl.pet = PetBagController.instance().petModel.currentPetInfo;
      }
      
      private function addInfoChangeEvent() : void
      {
         _infoPlayer.pets.addEventListener(DictionaryEvent.UPDATE,this.__updateInfoChange);
         _infoPlayer.pets.addEventListener(DictionaryEvent.ADD,this.__updateInfoChange);
         _infoPlayer.pets.addEventListener(DictionaryEvent.REMOVE,this.__updateInfoChange);
      }
      
      private function removeInfoChangeEvent() : void
      {
         _infoPlayer.pets.removeEventListener(DictionaryEvent.UPDATE,this.__updateInfoChange);
         _infoPlayer.pets.removeEventListener(DictionaryEvent.ADD,this.__updateInfoChange);
         _infoPlayer.pets.removeEventListener(DictionaryEvent.REMOVE,this.__updateInfoChange);
      }
      
      private function __updateInfoChange(e:DictionaryEvent) : void
      {
         var currentPet:PetInfo = null;
         var updatePetinfo:PetInfo = e.data as PetInfo;
         if(Boolean(updatePetinfo))
         {
            switch(e.type)
            {
               case DictionaryEvent.ADD:
                  _petMoveScroll.refreshPetInfo(updatePetinfo,1);
                  break;
               case DictionaryEvent.UPDATE:
                  _petMoveScroll.refreshPetInfo(updatePetinfo);
                  currentPet = PetBagController.instance().petModel.currentPetInfo;
                  if(Boolean(currentPet) && currentPet.Place == updatePetinfo.Place)
                  {
                     PetBagController.instance().petModel.currentPetInfo = updatePetinfo;
                  }
                  break;
               case DictionaryEvent.REMOVE:
                  _petMoveScroll.refreshPetInfo(updatePetinfo,2);
                  if(_infoPlayer.pets.length > 0)
                  {
                     PetBagController.instance().petModel.currentPetInfo = getFirstPet(_infoPlayer);
                  }
                  else
                  {
                     PetBagController.instance().petModel.currentPetInfo = null;
                  }
            }
         }
         this.updatePetBagView();
      }
      
      private function __rePetName(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alertRePetName:RePetNameFrame = ComponentFactory.Instance.creat("petsBag.rePetNameFrame");
         alertRePetName.addEventListener(FrameEvent.RESPONSE,this.__AlertRePetNameResponse);
         alertRePetName.show();
      }
      
      protected function __AlertRePetNameResponse(evt:FrameEvent) : void
      {
         var alert:RePetNameFrame = evt.currentTarget as RePetNameFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__AlertRePetNameResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(BuriedManager.Instance.checkMoney(false,RePetNameFrame.RENAME_NEED_MONEY))
               {
                  alert.dispose();
                  return;
               }
               if(Boolean(PetBagController.instance().petModel.currentPetInfo) && alert.petName.length > 0)
               {
                  SocketManager.Instance.out.sendPetRename(PetBagController.instance().petModel.currentPetInfo.Place,alert.petName,false);
               }
               alert.dispose();
               break;
         }
      }
      
      protected function __revertPet(event:MouseEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pets.revertPetAlertMsg",StringHelper.trim(PetBagController.instance().petModel.currentPetInfo.Name)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertRevertPet);
         }
      }
      
      protected function __alertRevertPet(event:FrameEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pets.revertPetCostMsg",PetconfigAnalyzer.PetCofnig.RecycleCost),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
               alertAsk.addEventListener(FrameEvent.RESPONSE,this.__revertPetCostConfirm);
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertRevertPet);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function __revertPetCostConfirm(event:FrameEvent) : void
      {
         var index:int = 0;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(BuriedManager.Instance.checkMoney(event.currentTarget.isBand,PetconfigAnalyzer.PetCofnig.RecycleCost))
               {
                  return;
               }
               index = _petMoveScroll.currentPage * 5 + _petMoveScroll.selectedIndex;
               SocketManager.Instance.out.sendRevertPet(index,event.currentTarget.isBand);
               break;
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__revertPetCostConfirm);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __convertPet(event:MouseEvent) : void
      {
         var flag:int = 0;
         var alertAsk2:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpPetInfo:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(Boolean(tmpPetInfo))
         {
            flag = PetconfigAnalyzer.PetCofnig.NotRemoveStar;
            if(tmpPetInfo.StarLevel >= PetconfigAnalyzer.PetCofnig.NotRemoveStar)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.convertCannotTxt"));
            }
            else if(tmpPetInfo.StarLevel >= PetconfigAnalyzer.PetCofnig.HighRemoveStar)
            {
               alertAsk2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.farms.convertPet",tmpPetInfo.StarLevel),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               alertAsk2.enterEnable = false;
               alertAsk2.addEventListener(FrameEvent.RESPONSE,this.__alertReleasePet2);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.convertCannotTxt2"));
            }
         }
      }
      
      private function __releasePet(e:MouseEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpPetInfo:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(Boolean(tmpPetInfo))
         {
            if(tmpPetInfo.StarLevel >= PetconfigAnalyzer.PetCofnig.NotRemoveStar)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.releaseCannotTxt"));
            }
            else
            {
               alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.farms.releasePet",StringHelper.trim(PetBagController.instance().petModel.currentPetInfo.Name)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertReleasePet);
            }
         }
      }
      
      private function __alertReleasePet(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.pets.length == 1 || PlayerManager.Instance.Self.currentPet == PetBagController.instance().petModel.currentPetInfo)
               {
                  PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
               }
               SocketManager.Instance.out.sendReleasePet(PetBagController.instance().petModel.currentPetInfo.Place);
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __alertReleasePet2(event:FrameEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.farms.releasePet3",PetconfigAnalyzer.PetCofnig.HighRemoveStarCost),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
               alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertReleasePet3);
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet2);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __alertReleasePet3(event:FrameEvent) : void
      {
         var tmpIsBind:Boolean = false;
         var tmpNeedMoney:int = 0;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               tmpIsBind = (event.currentTarget as SimpleAlert).isBand;
               tmpNeedMoney = PetconfigAnalyzer.PetCofnig.HighRemoveStarCost;
               if(tmpIsBind && PlayerManager.Instance.Self.BandMoney >= tmpNeedMoney || PlayerManager.Instance.Self.Money >= tmpNeedMoney)
               {
                  if(PlayerManager.Instance.Self.pets.length == 1 || PlayerManager.Instance.Self.currentPet == PetBagController.instance().petModel.currentPetInfo)
                  {
                     PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
                  }
                  SocketManager.Instance.out.sendReleasePet(PetBagController.instance().petModel.currentPetInfo.Place,true,tmpIsBind);
               }
               else
               {
                  LeavePageManager.showFillFrame();
               }
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet3);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __unFight(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place,false);
         }
         PetSpriteController.Instance.dispatchEvent(new Event(PetSpriteController.SHOWPET_TIP));
         PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function __fight(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place);
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.FIGHT_PET);
               PetBagController.instance().showPetFarmGuildArrow(ArrowType.FEED_PET,50,"farmTrainer.feedPetArrowPos","asset.farmTrainer.feedPet","farmTrainer.feedPetTipPos",this);
            }
         }
         PetSpriteController.Instance.dispatchEvent(new Event(Event.OPEN));
      }
      
      private function switchFightUnFight(bool:Boolean = true) : void
      {
         _fightBtn.visible = bool;
         this._unFightBtn.visible = !bool;
      }
      
      private function __feedPet(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            if(!this._feedItem.itemInfo)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.feedNoFood"));
               return;
            }
            if(PetBagController.instance().petModel.currentPetInfo.Level == 60 || PetBagController.instance().petModel.currentPetInfo.Level == PlayerManager.Instance.Self.Grade)
            {
               if(PetBagController.instance().petModel.currentPetInfo.Hunger == PetconfigAnalyzer.PetCofnig.MaxHunger)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.hungerFull"));
                  return;
               }
            }
            SocketManager.Instance.out.sendPetFeed(this._feedItem.itemInfo.Place,this._feedItem.itemInfo.BagType,PetBagController.instance().petModel.currentPetInfo.Place);
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.FEED_PET);
            }
         }
      }
      
      public function startShine() : void
      {
         if(!hasPet)
         {
            return;
         }
         this._feedItem.startShine();
      }
      
      public function stopShine() : void
      {
         this._feedItem.stopShine();
      }
      
      public function clearInfo() : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         this._feedItem.info = null;
      }
      
      private function __help(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("petsBag.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("petsBag.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.petsBag.readme");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __groomPet(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PetsAdvancedManager.Instance.showPetsAdvancedFrame();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._rePetNameBtn.removeEventListener(MouseEvent.CLICK,this.__rePetName);
         this._revertPetBtn.removeEventListener(MouseEvent.CLICK,this.__revertPet);
         this._releaseBtn.removeEventListener(MouseEvent.CLICK,this.__releasePet);
         this._convertBtn.removeEventListener(MouseEvent.CLICK,this.__convertPet);
         this._unFightBtn.removeEventListener(MouseEvent.CLICK,this.__unFight);
         _fightBtn.removeEventListener(MouseEvent.CLICK,this.__fight);
         this.removeInfoChangeEvent();
         if(Boolean(this._feedBtn))
         {
            this._feedBtn.removeEventListener(MouseEvent.CLICK,this.__feedPet);
         }
         this._groomBtn.removeEventListener(MouseEvent.CLICK,this.__groomPet);
      }
      
      public function getUnLockItemIndex() : int
      {
         if(Boolean(this._petGameSkillPnl))
         {
            return this._petGameSkillPnl.UnLockItemIndex;
         }
         return -1;
      }
      
      override public function dispose() : void
      {
         this.clearInfo();
         this.removeEvent();
         this.removeInfoChangeEvent();
         PetBagController.instance().petModel.currentPetInfo = null;
         super.dispose();
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
         }
         if(Boolean(this._fightSkillLbl))
         {
            ObjectUtils.disposeObject(this._fightSkillLbl);
            this._fightSkillLbl = null;
         }
         if(Boolean(this._petGameSkillPnl))
         {
            ObjectUtils.disposeObject(this._petGameSkillPnl);
            this._petGameSkillPnl = null;
         }
         if(Boolean(this._unFightBtn))
         {
            ObjectUtils.disposeObject(this._unFightBtn);
            this._unFightBtn = null;
         }
         if(Boolean(this._releaseBtn))
         {
            ObjectUtils.disposeObject(this._releaseBtn);
            this._releaseBtn = null;
         }
         if(Boolean(this._feedItem))
         {
            ObjectUtils.disposeObject(this._feedItem);
            this._feedItem = null;
         }
         if(Boolean(this._rePetNameBtn))
         {
            ObjectUtils.disposeObject(this._rePetNameBtn);
            this._rePetNameBtn = null;
         }
         if(Boolean(this._revertPetBtn))
         {
            ObjectUtils.disposeObject(this._revertPetBtn);
            this._revertPetBtn = null;
         }
         if(Boolean(this._feedBtn))
         {
            ObjectUtils.disposeObject(this._feedBtn);
            this._feedBtn = null;
         }
         if(Boolean(this._convertBtn))
         {
            ObjectUtils.disposeObject(this._convertBtn);
            this._convertBtn = null;
         }
         ObjectUtils.disposeObject(this._groomBtn);
         this._groomBtn = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

