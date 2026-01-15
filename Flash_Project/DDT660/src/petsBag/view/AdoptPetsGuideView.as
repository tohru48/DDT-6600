package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import farm.control.FarmComposeHouseController;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import pet.date.PetTemplateInfo;
   import pet.sprite.PetSpriteController;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.AdoptItem;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   
   public class AdoptPetsGuideView extends Frame
   {
      
      private var _adoptBtn:SimpleBitmapButton;
      
      private var _listView:SimpleTileList;
      
      private var _petsImgVec:Vector.<AdoptItem>;
      
      public var currentPet:AdoptItem;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _titleBg:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _refreshVolumeImg:Bitmap;
      
      private var _refreshVolumeTxt:FilterFrameText;
      
      private var _desBg:ScaleBitmapImage;
      
      private var _descList:Array = new Array(LanguageMgr.GetTranslation("ddt.farm.petguide1"),LanguageMgr.GetTranslation("ddt.farm.petguide2"),LanguageMgr.GetTranslation("ddt.farm.petguide3"),LanguageMgr.GetTranslation("ddt.farm.petguide4"));
      
      private var _refreshPetPnl:RefreshPetAlertFrame;
      
      public function AdoptPetsGuideView()
      {
         super();
         this._petsImgVec = new Vector.<AdoptItem>();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         SocketManager.Instance.out.sendRefreshPet();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_ADOPT_PET);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.SELECT_PET,-150,"farmTrainer.selectPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.selectPetTipPos",this);
         }
      }
      
      private function initView() : void
      {
         this._bg2 = ComponentFactory.Instance.creat("farm.adoptPetsView.bg2");
         addToContent(this._bg2);
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.adoptPets");
         addChild(this._titleBg);
         this._desBg = ComponentFactory.Instance.creatComponentByStylename("farm.adoptPetsView.descBg2");
         addToContent(this._desBg);
         this._adoptBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.adopt");
         addToContent(this._adoptBtn);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptdescTitle");
         this._refreshTimerTxt.text = LanguageMgr.GetTranslation("ddt.farms.desc");
         addToContent(this._refreshTimerTxt);
         this._listView = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petAdop",[4]);
         addToContent(this._listView);
         this._refreshVolumeImg = ComponentFactory.Instance.creatBitmap("assets.farm.petRecommendImg");
         addToContent(this._refreshVolumeImg);
         this._refreshVolumeTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptdesctxt");
         addToContent(this._refreshVolumeTxt);
         this.updateAdoptBtnStatus();
      }
      
      private function update(pets:Array) : void
      {
         var petIcon:AdoptItem = null;
         var petInfo:PetTemplateInfo = null;
         if(!pets || pets.length < 1)
         {
            return;
         }
         this.removeItem();
         for each(petInfo in pets)
         {
            petIcon = ComponentFactory.Instance.creat("farm.petAdoptItem",[petInfo]);
            this._petsImgVec.push(petIcon);
         }
         this.currentPet = null;
         this.addItem();
         this.updateAdoptBtnStatus();
      }
      
      private function updateRefreshVolume() : void
      {
         this._refreshVolumeTxt.text = FarmComposeHouseController.instance().refreshVolume();
      }
      
      public function updateTimer(timeStr:String) : void
      {
      }
      
      private function addItem() : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            if(index > 3)
            {
               return;
            }
            this._petsImgVec[index].addEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._listView.addChild(this._petsImgVec[index]);
         }
      }
      
      private function updateAdoptBtnStatus() : void
      {
         this._adoptBtn.enable = this._petsImgVec.length > 0 && Boolean(this.currentPet) ? true : false;
      }
      
      private function removeItem() : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            this._petsImgVec[index].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._petsImgVec[index].dispose();
            this._petsImgVec[index] = null;
         }
         this._petsImgVec.splice(0,this._petsImgVec.length);
      }
      
      private function removeItemByPetInfo(petInfo:PetInfo) : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            if(Boolean(this._petsImgVec[index].info))
            {
               if(this._petsImgVec[index].info.TemplateID == petInfo.TemplateID && this._petsImgVec[index].info.Place == petInfo.Place)
               {
                  this._petsImgVec[index].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
                  this._petsImgVec[index].dispose();
                  this._petsImgVec[index] = null;
                  this._petsImgVec.splice(index,1);
                  PetBagController.instance().petModel.adoptPets.remove(petInfo.Place);
                  break;
               }
            }
         }
      }
      
      private function __petItemClick(e:PetItemEvent) : void
      {
         var index:int = 0;
         SoundManager.instance.play("008");
         this.currentPet = e.data as AdoptItem;
         if(Boolean(this.currentPet))
         {
            this.setSelectUnSelect(this.currentPet);
            index = int(this._petsImgVec.indexOf(this.currentPet));
            if(index > 0 && index < 4)
            {
               this._refreshVolumeTxt.text = "   " + this._descList[index];
            }
            else
            {
               this._refreshVolumeTxt.text = this.currentPet.info.Description;
            }
         }
         this.updateAdoptBtnStatus();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.SELECT_PET);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.ADOPT_PET,-150,"farmTrainer.adoptPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.adoptPetTipPos",this);
         }
      }
      
      private function setSelectUnSelect(currentPetItem:AdoptItem, select:Boolean = false) : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            if(Boolean(this._petsImgVec[index]) && this._petsImgVec[index] != currentPetItem)
            {
               this._petsImgVec[index].isSelect = select;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._adoptBtn.addEventListener(MouseEvent.CLICK,this.__adoptPet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __bagUpdate(event:Event) : void
      {
         this.updateRefreshVolume();
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __updateRefreshPet(e:CrazyTankSocketEvent) : void
      {
         var place:int = 0;
         var ptid:int = 0;
         var p:PetInfo = null;
         var skillCount:int = 0;
         var k:int = 0;
         var petskill:PetSkill = null;
         var skillid:int = 0;
         var pkg:PackageIn = e.pkg;
         var isUpdate:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            if(isUpdate)
            {
               place = pkg.readInt();
               ptid = pkg.readInt();
               p = new PetInfo();
               p.TemplateID = ptid;
               PetInfoManager.fillPetInfo(p);
               p.Name = pkg.readUTF();
               p.Attack = pkg.readInt();
               p.Defence = pkg.readInt();
               p.Luck = pkg.readInt();
               p.Agility = pkg.readInt();
               p.Blood = pkg.readInt();
               p.Damage = pkg.readInt();
               p.Guard = pkg.readInt();
               p.AttackGrow = pkg.readInt();
               p.DefenceGrow = pkg.readInt();
               p.LuckGrow = pkg.readInt();
               p.AgilityGrow = pkg.readInt();
               p.BloodGrow = pkg.readInt();
               p.DamageGrow = pkg.readInt();
               p.GuardGrow = pkg.readInt();
               p.Level = pkg.readInt();
               p.GP = pkg.readInt();
               p.MaxGP = pkg.readInt();
               p.Hunger = pkg.readInt();
               p.MP = pkg.readInt();
               skillCount = pkg.readInt();
               for(k = 0; k < skillCount; k++)
               {
                  skillid = pkg.readInt();
                  petskill = new PetSkill(skillid);
                  p.addSkill(petskill);
                  pkg.readInt();
               }
               p.MaxActiveSkillCount = pkg.readInt();
               p.MaxStaticSkillCount = pkg.readInt();
               p.MaxSkillCount = pkg.readInt();
               p.Place = place;
               if(p.Place != -1)
               {
                  PetBagController.instance().petModel.adoptPets.add(p.Place,p);
               }
            }
            else
            {
               place = pkg.readInt();
               ptid = pkg.readInt();
               p = new PetInfo();
               p.TemplateID = ptid;
               PetInfoManager.fillPetInfo(p);
               p.Name = pkg.readUTF();
               p.Attack = pkg.readInt();
               p.Defence = pkg.readInt();
               p.Luck = pkg.readInt();
               p.Agility = pkg.readInt();
               p.Blood = pkg.readInt();
               p.Damage = pkg.readInt();
               p.Guard = pkg.readInt();
               p.AttackGrow = pkg.readInt();
               p.DefenceGrow = pkg.readInt();
               p.LuckGrow = pkg.readInt();
               p.AgilityGrow = pkg.readInt();
               p.BloodGrow = pkg.readInt();
               p.DamageGrow = pkg.readInt();
               p.GuardGrow = pkg.readInt();
               p.Level = pkg.readInt();
               p.GP = pkg.readInt();
               p.MaxGP = pkg.readInt();
               p.Hunger = pkg.readInt();
               p.MP = pkg.readInt();
               skillCount = pkg.readInt();
               for(k = 0; k < skillCount; k++)
               {
                  skillid = pkg.readInt();
                  petskill = new PetSkill(skillid);
                  p.addSkill(petskill);
                  pkg.readInt();
               }
               p.MaxActiveSkillCount = pkg.readInt();
               p.MaxStaticSkillCount = pkg.readInt();
               p.MaxSkillCount = pkg.readInt();
               p.Place = place;
               if(p.Place != -1)
               {
                  PetBagController.instance().petModel.adoptPets.add(p.Place,p);
               }
            }
         }
         this.update(PetBagController.instance().petModel.adoptPets.list);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._adoptBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
      }
      
      private function __adoptPet(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertTitle")," ",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlertTwo",90,false);
         alert.info.customPos = PositionUtils.creatPoint("farmSimpleAlertButtonPos");
         alert.titleOuterRectPosString = "130,11,5";
         alert.info.dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
         alert.info.buttonGape = 90;
         var msgText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("farmSimpleAlert.textStyle");
         msgText.text = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertContonet");
         alert.addToContent(msgText);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
      }
      
      private function __refreshPet(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var refreshNeed:int = int(LanguageMgr.GetTranslation("ddt.pet.refreshNeed"));
         var ff:Number = PlayerManager.Instance.Self.Money;
         if(PlayerManager.Instance.Self.Money < refreshNeed && int(this._refreshVolumeTxt.text) <= 0)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         this.refeshPet();
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function refeshPet() : void
      {
         var alert:BaseAlerFrame = null;
         if(FarmComposeHouseController.instance().isFourStarPet(PetBagController.instance().petModel.adoptPets.list))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlertTitle"),LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlertContonetI"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlert",60,false);
            alert.addEventListener(FrameEvent.RESPONSE,this.__RefreshResponseI);
            alert.titleOuterRectPosString = "206,10,5";
            return;
         }
         this.refreshPetAlert();
      }
      
      private function refreshPetAlert() : void
      {
         if(SharedManager.Instance.isRefreshPet)
         {
            SocketManager.Instance.out.sendRefreshPet(true,this._refreshPetPnl.isBand);
            return;
         }
         this._refreshPetPnl = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPetAlertFrame.confirmRefresh");
         LayerManager.Instance.addToLayer(this._refreshPetPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._refreshPetPnl.addEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
      }
      
      private function __RefreshResponseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__RefreshResponseI);
         alert.dispose();
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.refreshPetAlert();
         }
      }
      
      private function __onAdoptResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
         alert.dispose();
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(Boolean(this.currentPet) && Boolean(this.currentPet.info as PetInfo))
            {
               SocketManager.Instance.out.sendAdoptPet((this.currentPet.info as PetInfo).Place);
               this.removeItemByPetInfo(this.currentPet.info);
               this.currentPet = null;
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.ADOPT_PET);
               }
               PetSpriteController.Instance.dispatchEvent(new Event(Event.OPEN));
            }
            this.dispose();
         }
         if(Boolean(this._adoptBtn))
         {
            this.updateAdoptBtnStatus();
         }
      }
      
      private function __onRefreshResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(BuriedManager.Instance.checkMoney(false,PetconfigAnalyzer.PetCofnig.AdoptRefereshCost))
            {
               return;
            }
            SocketManager.Instance.out.sendRefreshPet(true,this._refreshPetPnl.isBand);
         }
         this._refreshPetPnl.removeEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
         this._refreshPetPnl.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeItem();
         if(Boolean(this._titleBg))
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
         }
         if(Boolean(this._refreshTimerTxt))
         {
            ObjectUtils.disposeObject(this._refreshTimerTxt);
            this._refreshTimerTxt = null;
         }
         if(Boolean(this.currentPet))
         {
            ObjectUtils.disposeObject(this.currentPet);
            this.currentPet = null;
         }
         if(Boolean(this._listView))
         {
            ObjectUtils.disposeObject(this._listView);
            this._listView = null;
         }
         if(Boolean(this._adoptBtn))
         {
            ObjectUtils.disposeObject(this._adoptBtn);
            this._adoptBtn = null;
         }
         if(Boolean(this._refreshVolumeImg))
         {
            ObjectUtils.disposeObject(this._refreshVolumeImg);
            this._refreshVolumeImg = null;
         }
         if(Boolean(this._refreshVolumeTxt))
         {
            ObjectUtils.disposeObject(this._refreshVolumeTxt);
            this._refreshVolumeTxt = null;
         }
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

