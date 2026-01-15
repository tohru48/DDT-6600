package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.BagInfo;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import farm.control.FarmComposeHouseController;
   import farm.viewx.newPet.NewPetViewFrame;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingBless.KingBlessManager;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.AdoptItemInfo;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.AdoptItem;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   
   public class AdoptPetsView extends Frame
   {
      
      private var _adoptBtn:SimpleBitmapButton;
      
      private var _adoptItemBtn:SimpleBitmapButton;
      
      private var _refreshBtn:TextButton;
      
      private var _listView:SimpleTileList;
      
      private var _petsImgVec:Vector.<AdoptItem>;
      
      public var currentPet:AdoptItem;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _titleBg:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _refreshTimer:Timer;
      
      private var _refreshVolumeImg:Bitmap;
      
      private var _refreshVolumeTxt:FilterFrameText;
      
      private var _refreshVolumeTxtBG:ScaleBitmapImage;
      
      private var _refreshVolumeTip:StripTip;
      
      private var _newPetView:NewPetViewFrame;
      
      private var _petCreditTxt:Bitmap;
      
      private var _petCreditNum:FilterFrameText;
      
      private var _refreshPetPnl:RefreshPetAlertFrame;
      
      private var _isband:Boolean;
      
      public function AdoptPetsView()
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
         this.updateTimer(FarmComposeHouseController.instance().getNextUpdatePetTimes());
         this.updateRefreshVolume();
         this.__updatePetScore();
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
         this._adoptBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.adopt");
         addToContent(this._adoptBtn);
         this._adoptItemBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.adoptItem");
         this._adoptItemBtn.visible = false;
         addToContent(this._adoptItemBtn);
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.refresh");
         addToContent(this._refreshBtn);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptRefreshTimer");
         addToContent(this._refreshTimerTxt);
         this._refreshVolumeTxtBG = ComponentFactory.Instance.creatComponentByStylename("farmHouse.adoptRefreshVolumeTxtBG");
         addToContent(this._refreshVolumeTxtBG);
         this._listView = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petAdop",[4]);
         addToContent(this._listView);
         this._refreshVolumeImg = ComponentFactory.Instance.creatBitmap("assets.farm.petRefreshVolumeImg");
         addToContent(this._refreshVolumeImg);
         this._refreshVolumeTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptRefreshVolumeTxt");
         addToContent(this._refreshVolumeTxt);
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._petCreditTxt = ComponentFactory.Instance.creat("assets.farmShop.petCreditTxt");
            this._petCreditNum = ComponentFactory.Instance.creatComponentByStylename("farm.text.petCreditNum");
            addToContent(this._petCreditTxt);
            addToContent(this._petCreditNum);
         }
         this._refreshVolumeTip = ComponentFactory.Instance.creat("farm.refreshVolumeStripTip");
         addToContent(this._refreshVolumeTip);
         this._refreshVolumeTip.setView(this._refreshVolumeImg);
         this._refreshVolumeTip.tipData = LanguageMgr.GetTranslation("ddt.farms.petRefreshVolume");
         this._refreshVolumeTip.width = this._refreshVolumeImg.width;
         this._refreshVolumeTip.height = this._refreshVolumeImg.height;
         this._refreshTimer = new Timer(60 * 1000);
         this._refreshTimer.start();
         this.updateAdoptBtnStatus();
         this.refreshPetBtn(null);
      }
      
      private function update(pets:Array, items:Array) : void
      {
         var petIcon:AdoptItem = null;
         var petInfo:PetTemplateInfo = null;
         if(Boolean(pets) && pets.length >= 1)
         {
            this.removeItem();
            for each(petInfo in pets)
            {
               petIcon = ComponentFactory.Instance.creat("farm.petAdoptItem",[petInfo]);
               this._petsImgVec.push(petIcon);
            }
         }
         this.updateItems(items);
         this.currentPet = null;
         this.addItem();
         this.updateAdoptBtnStatus();
      }
      
      private function updateRefreshVolume() : void
      {
         this._refreshVolumeTxt.text = FarmComposeHouseController.instance().refreshVolume();
      }
      
      private function __updatePetScore(e:CrazyTankSocketEvent = null) : void
      {
         if(Boolean(this._petCreditNum))
         {
            this._petCreditNum.text = PlayerManager.Instance.Self.petScore.toString();
         }
      }
      
      public function updateTimer(timeStr:String) : void
      {
         this._refreshTimerTxt.text = timeStr;
      }
      
      private function addItem() : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            this._petsImgVec[index].addEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._listView.addChild(this._petsImgVec[index]);
         }
      }
      
      private function updateAdoptBtnStatus() : void
      {
         this._adoptBtn.enable = this._petsImgVec.length > 0 && Boolean(this.currentPet) ? true : false;
         this._adoptItemBtn.enable = true;
         if(Boolean(this.currentPet))
         {
            this._adoptItemBtn.visible = this.currentPet.isGoodItem;
            this._adoptBtn.visible = !this.currentPet.isGoodItem;
         }
         this._refreshBtn.enable = true;
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
      
      private function removeItemByPlace(place:int) : void
      {
         for(var index:int = 0; index < this._petsImgVec.length; index++)
         {
            if(Boolean(this._petsImgVec[index].itemInfo) && place == this._petsImgVec[index].place)
            {
               this._petsImgVec[index].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
               this._petsImgVec[index].dispose();
               this._petsImgVec[index] = null;
               this._petsImgVec.splice(index,1);
               PetBagController.instance().petModel.adoptItems.remove(place);
               break;
            }
         }
      }
      
      private function __petItemClick(e:PetItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.currentPet = e.data as AdoptItem;
         if(Boolean(this.currentPet))
         {
            this.setSelectUnSelect(this.currentPet);
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
         this._adoptItemBtn.addEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.__refreshPet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._refreshTimer.addEventListener(TimerEvent.TIMER,this.__refreshUpdatePet);
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__bagUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePetScore);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_BUFF_DATA_EVENT,this.refreshPetBtn);
      }
      
      private function refreshPetBtn(event:Event) : void
      {
         var freeCount:int = KingBlessManager.instance.getOneBuffData(KingBlessManager.PET_REFRESH);
         if(freeCount > 0)
         {
            PositionUtils.setPos(this._adoptBtn,"assets.farm.adoptBtnPos1");
            this._refreshBtn.text = LanguageMgr.GetTranslation("ddt.farms.petFreeRefresh",freeCount);
            PositionUtils.setPos(this._refreshBtn,"assets.farm.petFreeRefreshPos");
         }
         else
         {
            PositionUtils.setPos(this._adoptBtn,"assets.farm.adoptBtnPos2");
            this._refreshBtn.text = LanguageMgr.GetTranslation("ddt.farms.refresh");
            PositionUtils.setPos(this._refreshBtn,"assets.farm.petRefreshPos");
         }
      }
      
      private function __bagUpdate(event:Event) : void
      {
         this.updateRefreshVolume();
      }
      
      private function __refreshUpdatePet(e:TimerEvent) : void
      {
         this.updateTimer(FarmComposeHouseController.instance().getNextUpdatePetTimes());
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
         var item:AdoptItemInfo = null;
         var pkg:PackageIn = e.pkg;
         var isUpdate:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         PetBagController.instance().petModel.adoptPets.clear();
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
               else
               {
                  PetBagController.instance().newPetInfo = p;
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
               else
               {
                  PetBagController.instance().newPetInfo = p;
               }
            }
         }
         PetBagController.instance().petModel.adoptItems.clear();
         count = pkg.readInt();
         for(var j:int = 0; j < count; j++)
         {
            item = new AdoptItemInfo();
            item.place = pkg.readInt();
            item.itemTemplateId = pkg.readInt();
            item.itemAmount = pkg.readInt();
            PetBagController.instance().petModel.adoptItems.add(item.place,item);
         }
         this.update(PetBagController.instance().petModel.adoptPets.list,PetBagController.instance().petModel.adoptItems.list);
         if(!this._newPetView)
         {
            this._newPetView = ComponentFactory.Instance.creatComponentByStylename("farm.newPetViewFrame");
            this._newPetView.petInfo = PetBagController.instance().newPetInfo;
            this._newPetView.addEventListener("newPetFrameClose",this.__onNewPetFrameClose);
            addChild(this._newPetView);
            this.setChildIndex(this._newPetView,0);
         }
      }
      
      private function __onNewPetFrameClose(pEvent:Event) : void
      {
         this._newPetView.removeEventListener("newPetFrameClose",this.__onNewPetFrameClose);
         TweenMax.to(this,0.2,{"x":255});
      }
      
      private function updateItems(items:Array) : void
      {
         var item:AdoptItem = null;
         var info:AdoptItemInfo = null;
         if(!items || items.length < 1)
         {
            return;
         }
         for each(info in items)
         {
            item = ComponentFactory.Instance.creat("farm.petAdoptItem",[null]);
            item.itemAmount = info.itemAmount;
            item.place = info.place;
            item.itemTemplateId = info.itemTemplateId;
            this._petsImgVec.push(item);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._adoptBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._adoptItemBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.__refreshPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePetScore);
         if(Boolean(this._refreshTimer))
         {
            this._refreshTimer.stop();
            this._refreshTimer.removeEventListener(TimerEvent.TIMER,this.__refreshUpdatePet);
            this._refreshTimer = null;
         }
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_BUFF_DATA_EVENT,this.refreshPetBtn);
      }
      
      private function __adoptPet(e:MouseEvent) : void
      {
         var title:String = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.currentPet.isGoodItem)
         {
            title = LanguageMgr.GetTranslation("ddt.farms.adoptItemAlertTitle");
         }
         else
         {
            title = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertTitle");
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(title," ",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlertTwo",60,false);
         alert.titleOuterRectPosString = "131,12,5";
         alert.info.customPos = PositionUtils.creatPoint("farmSimpleAlertButtonPos");
         alert.info.dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
         var msgText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("farmSimpleAlert.textStyle");
         if(this.currentPet.isGoodItem)
         {
            msgText.text = LanguageMgr.GetTranslation("ddt.farms.adoptItemsAlertContonet");
         }
         else
         {
            msgText.text = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertContonet");
         }
         alert.addToContent(msgText);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
      }
      
      private function __refreshPet(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var refreshNeed:int = int(LanguageMgr.GetTranslation("ddt.pet.refreshNeed"));
         var ff:Number = PlayerManager.Instance.Self.Money;
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
         if(KingBlessManager.instance.getOneBuffData(KingBlessManager.PET_REFRESH) > 0 || int(FarmComposeHouseController.instance().refreshVolume()) > 0)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._refreshBtn.enable = false;
            SocketManager.Instance.out.sendRefreshPet(true);
            return;
         }
         if(SharedManager.Instance.isRefreshPet)
         {
            if(BuriedManager.Instance.checkMoney(SharedManager.Instance.isRefreshBand,PetconfigAnalyzer.PetCofnig.AdoptRefereshCost))
            {
               SharedManager.Instance.isRefreshPet = false;
               this._refreshPetPnl = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPetAlertFrame.confirmRefresh");
               LayerManager.Instance.addToLayer(this._refreshPetPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._refreshPetPnl.addEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
               return;
            }
            SocketManager.Instance.out.sendRefreshPet(true,SharedManager.Instance.isRefreshBand);
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
            }
            else if(Boolean(this.currentPet) && Boolean(this.currentPet.itemInfo))
            {
               SocketManager.Instance.out.sendAdoptPet(this.currentPet.place);
               this.removeItemByPlace(this.currentPet.place);
               this.currentPet = null;
            }
         }
         this.updateAdoptBtnStatus();
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
            SocketManager.Instance.out.sendRefreshPet(true,false);
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
         if(Boolean(this._refreshBtn))
         {
            ObjectUtils.disposeObject(this._refreshBtn);
            this._refreshBtn = null;
         }
         if(Boolean(this._adoptBtn))
         {
            ObjectUtils.disposeObject(this._adoptBtn);
            this._adoptBtn = null;
         }
         if(Boolean(this._adoptItemBtn))
         {
            ObjectUtils.disposeObject(this._adoptItemBtn);
            this._adoptItemBtn = null;
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
         if(Boolean(this._petCreditTxt))
         {
            ObjectUtils.disposeObject(this._petCreditTxt);
            this._petCreditTxt = null;
         }
         if(Boolean(this._petCreditNum))
         {
            ObjectUtils.disposeObject(this._petCreditNum);
            this._petCreditNum = null;
         }
         if(Boolean(this._refreshVolumeTxtBG))
         {
            ObjectUtils.disposeObject(this._refreshVolumeTxtBG);
            this._refreshVolumeTxtBG = null;
         }
         if(Boolean(this._refreshVolumeTip))
         {
            ObjectUtils.disposeObject(this._refreshVolumeTip);
            this._refreshVolumeTip = null;
         }
         if(Boolean(this._newPetView))
         {
            ObjectUtils.disposeObject(this._newPetView);
         }
         this._newPetView = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

