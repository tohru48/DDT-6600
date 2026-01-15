package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFightPropertyData;
   import petsBag.event.PetsAdvancedEvent;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.view.item.PetPropButton;
   
   public class PetsBagView extends Sprite implements Disposeable
   {
      
      private var _bgPet:DisplayObject;
      
      protected var _bgSkillPnl:DisplayObject;
      
      protected var _petMoveScroll:PetMoveScroll;
      
      protected var _petName:FilterFrameText;
      
      private var _fightPowerImg:Bitmap;
      
      private var _fightPowrTxt:FilterFrameText;
      
      protected var _showPet:ShowPet;
      
      protected var _happyBarPet:PetHappyBar;
      
      protected var _petExpProgress:PetExpProgress;
      
      protected var _petSkillPnl:PetSkillPnl;
      
      protected var _attackPbtn:PetPropButton;
      
      protected var _defencePbtn:PetPropButton;
      
      protected var _HPPbtn:PetPropButton;
      
      protected var _agilityPbtn:PetPropButton;
      
      protected var _luckPbtn:PetPropButton;
      
      protected var _fightBtn:TextButton;
      
      private var _petSkillLbl:FilterFrameText;
      
      protected var _infoPlayer:PlayerInfo;
      
      protected var _currentPet:PetInfo;
      
      protected var _downArowImg:Bitmap;
      
      protected var _downArowText:Bitmap;
      
      protected var _currentGradeInfo:PetFightPropertyData;
      
      protected var _downArowTextData:Array = ["100","40","20","0"];
      
      protected var _currentPetHappyStar:int = -1;
      
      public function PetsBagView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set infoPlayer(value:PlayerInfo) : void
      {
         if(this._infoPlayer == value)
         {
            return;
         }
         this._infoPlayer = value;
         if(!this._infoPlayer)
         {
            return;
         }
         this._petMoveScroll.infoPlayer = this._infoPlayer;
         PetBagController.instance().petModel.currentPetInfo = this.getFirstPet(this._infoPlayer);
         this._currentPet = PetBagController.instance().petModel.currentPetInfo;
         this.updatePetBagView();
      }
      
      public function playShined(type:int) : void
      {
         this._showPet.getBagCell(type).shinePlay();
      }
      
      public function stopShined(type:int) : void
      {
         this._showPet.getBagCell(type).shineStop();
      }
      
      protected function getFirstPet(player:PlayerInfo) : PetInfo
      {
         var resultPet:PetInfo = null;
         var i:int = 0;
         if(Boolean(player.currentPet))
         {
            resultPet = player.currentPet;
         }
         else
         {
            for(i = 0; i < player.pets.length; i++)
            {
               if(Boolean(player.pets[i]))
               {
                  return player.pets[i];
               }
            }
         }
         return resultPet;
      }
      
      protected function initView() : void
      {
         this._bgPet = ComponentFactory.Instance.creat("assets.petsBag.BG");
         addChild(this._bgPet);
         this._bgSkillPnl = ComponentFactory.Instance.creat("petsBag.SkillPnl.myBG");
         addChild(this._bgSkillPnl);
         this._petMoveScroll = new PetMoveScroll();
         addChild(this._petMoveScroll);
         this._petName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.PetName");
         addChild(this._petName);
         this._showPet = ComponentFactory.Instance.creat("petsBag.showPet");
         addChild(this._showPet);
         this._happyBarPet = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyBar");
         addChild(this._happyBarPet);
         this._petExpProgress = ComponentFactory.Instance.creatComponentByStylename("petExpProgress");
         addChild(this._petExpProgress);
         this._attackPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.attack");
         addChild(this._attackPbtn);
         this._defencePbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.defence");
         addChild(this._defencePbtn);
         this._HPPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.HP");
         addChild(this._HPPbtn);
         this._agilityPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.agility");
         addChild(this._agilityPbtn);
         this._luckPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.luck");
         addChild(this._luckPbtn);
         this._attackPbtn.propName = LanguageMgr.GetTranslation("attack");
         this._defencePbtn.propName = LanguageMgr.GetTranslation("defence");
         this._HPPbtn.propName = LanguageMgr.GetTranslation("MaxHp");
         this._agilityPbtn.propName = LanguageMgr.GetTranslation("agility");
         this._luckPbtn.propName = LanguageMgr.GetTranslation("luck");
         this._fightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.fight");
         addChild(this._fightBtn);
         this._fightBtn.text = LanguageMgr.GetTranslation("ddt.pets.fight");
         this._fightBtn.mouseChildren = false;
         this._fightBtn.mouseEnabled = false;
         this._fightBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._petSkillLbl = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.petSkill");
         addChild(this._petSkillLbl);
         this._petSkillLbl.text = LanguageMgr.GetTranslation("ddt.pets.petSkill");
         this.updateProperByPetStatus();
         this._downArowImg = ComponentFactory.Instance.creatBitmap("assets.petsBag.downArowImg");
         addChild(this._downArowImg);
      }
      
      protected function initEvent() : void
      {
         PetBagController.instance().petModel.addEventListener(Event.CHANGE,this.__onChange);
         PetsAdvancedManager.Instance.addEventListener(PetsAdvancedEvent.EVOLUTION_COMPLETE,this.__evolutionSuccessHandler);
      }
      
      protected function __evolutionSuccessHandler(event:Event) : void
      {
         if(!this._currentPet.IsEquip)
         {
            return;
         }
         this.updatePetsPropByEvolution();
         this.updatePropertyTip();
      }
      
      protected function removeEvent() : void
      {
         PetBagController.instance().petModel.removeEventListener(Event.CHANGE,this.__onChange);
         PetsAdvancedManager.Instance.removeEventListener(PetsAdvancedEvent.EVOLUTION_COMPLETE,this.__evolutionSuccessHandler);
      }
      
      protected function __onChange(event:Event) : void
      {
         if(PetBagController.instance().isOtherPetViewOpen)
         {
            return;
         }
         this._currentPet = PetBagController.instance().petModel.currentPetInfo;
         if(Boolean(this._currentPet))
         {
            this.updatePetBagView();
         }
         this._petMoveScroll.updateSelect();
      }
      
      public function get hasPet() : Boolean
      {
         return Boolean(this._infoPlayer) && this._infoPlayer.pets.list.length > 0;
      }
      
      public function updatePetBagView() : void
      {
         if(!this.hasPet)
         {
            this.mouseChildren = false;
            this.disableAllObj();
            this._petExpProgress.noPet();
         }
         var currentPet:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         this._petName.text = Boolean(currentPet) ? currentPet.Name : "";
         this._petExpProgress.setProgress(Boolean(currentPet) ? currentPet.GP : 0,Boolean(currentPet) ? currentPet.MaxGP : 0);
         this.updatePetsPropByEvolution();
         this._happyBarPet.info = currentPet;
         this.updateSkill();
         this.updateProperByPetStatus();
         this.updatePetSatiation();
         ShowPet.isPetEquip = false;
         this._showPet.update();
      }
      
      public function updatePetsPropByEvolution() : void
      {
         var info:PetFightPropertyData = null;
         var currentPet:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         for each(info in PetsAdvancedManager.Instance.evolutionDataList)
         {
            if(this._infoPlayer.evolutionGrade == 0)
            {
               this._currentGradeInfo = new PetFightPropertyData();
               break;
            }
            if(info.ID == this._infoPlayer.evolutionGrade)
            {
               this._currentGradeInfo = info;
               break;
            }
         }
         if(!this._currentGradeInfo)
         {
            this._currentGradeInfo = new PetFightPropertyData();
         }
         if(Boolean(currentPet))
         {
            this._attackPbtn.propValue = currentPet.IsEquip ? currentPet.Attack + this._currentGradeInfo.Attack : currentPet.Attack;
            this._defencePbtn.propValue = currentPet.IsEquip ? currentPet.Defence + this._currentGradeInfo.Defence : currentPet.Defence;
            this._HPPbtn.propValue = currentPet.IsEquip ? currentPet.Blood + this._currentGradeInfo.Blood : currentPet.Blood;
            this._agilityPbtn.propValue = currentPet.IsEquip ? currentPet.Agility + this._currentGradeInfo.Agility : currentPet.Agility;
            this._luckPbtn.propValue = currentPet.IsEquip ? currentPet.Luck + this._currentGradeInfo.Lucky : currentPet.Luck;
         }
      }
      
      protected function updatePropertyTip() : void
      {
         if(Boolean(this._currentPet) && Boolean(this._currentGradeInfo))
         {
            this._attackPbtn.currentPropValue = this._currentPet.Attack;
            this._attackPbtn.addedPropValue = this._currentPet.IsEquip ? this._currentGradeInfo.Attack : 0;
            this._defencePbtn.currentPropValue = this._currentPet.Defence;
            this._defencePbtn.addedPropValue = this._currentPet.IsEquip ? this._currentGradeInfo.Defence : 0;
            this._agilityPbtn.currentPropValue = this._currentPet.Agility;
            this._agilityPbtn.addedPropValue = this._currentPet.IsEquip ? this._currentGradeInfo.Agility : 0;
            this._luckPbtn.currentPropValue = this._currentPet.Luck;
            this._luckPbtn.addedPropValue = this._currentPet.IsEquip ? this._currentGradeInfo.Lucky : 0;
            this._HPPbtn.currentPropValue = this._currentPet.Blood;
            this._HPPbtn.addedPropValue = this._currentPet.IsEquip ? this._currentGradeInfo.Blood : 0;
            this._attackPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
            this._defencePbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
            this._agilityPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
            this._luckPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
            this._HPPbtn.property = LanguageMgr.GetTranslation("ddt.pets.hp");
         }
      }
      
      public function addPetEquip(date:InventoryItemInfo) : void
      {
         this._showPet.addPetEquip(date);
      }
      
      public function delPetEquip(petIndex:int, type:int) : void
      {
         this._showPet.delPetEquip(type);
      }
      
      protected function updatePetSatiation() : void
      {
         var petHappyStar:int = 0;
         if(Boolean(PetBagController.instance().petModel) && Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            petHappyStar = PetBagController.instance().petModel.currentPetInfo.PetHappyStar;
            if(this._currentPetHappyStar != petHappyStar)
            {
               if(Boolean(this._downArowText))
               {
                  ObjectUtils.disposeObject(this._downArowText);
               }
               this._downArowText = null;
               if(petHappyStar == 1 || petHappyStar == 2)
               {
                  this._downArowText = ComponentFactory.Instance.creatBitmap("assets.petsBag.downArowText" + this._downArowTextData[petHappyStar]);
                  this._downArowText.x = this._downArowImg.x + (this._downArowImg.width - this._downArowText.width) / 2;
                  this._downArowText.y = this._downArowImg.y + this._downArowImg.height;
                  addChild(this._downArowText);
                  this.setDownArowVisible(true);
               }
               else
               {
                  this.setDownArowVisible(false);
               }
               this._currentPetHappyStar = petHappyStar;
            }
         }
         else
         {
            this.setDownArowVisible(false);
         }
      }
      
      protected function setDownArowVisible(value:Boolean) : void
      {
         if(Boolean(this._downArowImg))
         {
            this._downArowImg.visible = value;
         }
      }
      
      protected function updateProperByPetStatus(isNomal:Boolean = true) : void
      {
         var currentPercent:Number = NaN;
         var addTipDesc:String = null;
         this.updatePropertyTip();
         if(Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            currentPercent = PetBagController.instance().petModel.currentPetInfo.Hunger / PetHappyBar.fullHappyValue;
            addTipDesc = "";
            this._attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail");
            this._defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail");
            this._agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail");
            this._luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail");
            this._HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail");
            this._attackPbtn.propColor = 16774857;
            this._defencePbtn.propColor = 16774857;
            this._agilityPbtn.propColor = 16774857;
            this._luckPbtn.propColor = 16774857;
            this._HPPbtn.propColor = 16774857;
            this._attackPbtn.valueFilterString = 1;
            this._agilityPbtn.valueFilterString = 1;
            this._luckPbtn.valueFilterString = 1;
            this._HPPbtn.valueFilterString = 1;
            this._defencePbtn.valueFilterString = 1;
            if(currentPercent < 0.8)
            {
               addTipDesc = PetBagController.instance().petModel.currentPetInfo.PetHappyStar > 0 ? LanguageMgr.GetTranslation("ddt.pets.petHappyDesc",PetHappyBar.petPercentArray[PetBagController.instance().petModel.currentPetInfo.PetHappyStar]) : LanguageMgr.GetTranslation("ddt.pets.petUnFight");
            }
            this._attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail") + addTipDesc;
            this._defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail") + addTipDesc;
            this._agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail") + addTipDesc;
            this._luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail") + addTipDesc;
            this._HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail") + addTipDesc;
         }
      }
      
      protected function updateSkill() : void
      {
         var currentPet:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         var petSkillAll:Array = Boolean(currentPet) ? currentPet.skills : [];
         if(Boolean(this._petSkillPnl))
         {
            this._petSkillPnl.itemInfo = petSkillAll;
         }
      }
      
      protected function disableAllObj() : void
      {
         var childObj:DisplayObject = null;
         for(var index:int = 0; index < this.numChildren; index++)
         {
            childObj = getChildAt(index);
            if(childObj is InteractiveObject)
            {
               this.disableObj(childObj as InteractiveObject);
            }
         }
      }
      
      protected function disableObj(obj:InteractiveObject) : void
      {
         obj.mouseEnabled = false;
      }
      
      protected function enableObj(obj:InteractiveObject) : void
      {
         obj.mouseEnabled = true;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bgPet))
         {
            ObjectUtils.disposeObject(this._bgPet);
            this._bgPet = null;
         }
         if(Boolean(this._bgSkillPnl))
         {
            ObjectUtils.disposeObject(this._bgSkillPnl);
            this._bgSkillPnl = null;
         }
         if(Boolean(this._petMoveScroll))
         {
            ObjectUtils.disposeObject(this._petMoveScroll);
            this._petMoveScroll = null;
         }
         if(Boolean(this._petName))
         {
            ObjectUtils.disposeObject(this._petName);
            this._petName = null;
         }
         if(Boolean(this._showPet))
         {
            ObjectUtils.disposeObject(this._showPet);
            this._showPet = null;
         }
         if(Boolean(this._happyBarPet))
         {
            ObjectUtils.disposeObject(this._happyBarPet);
            this._happyBarPet = null;
         }
         if(Boolean(this._petExpProgress))
         {
            ObjectUtils.disposeObject(this._petExpProgress);
            this._petExpProgress = null;
         }
         if(Boolean(this._petSkillPnl))
         {
            ObjectUtils.disposeObject(this._petSkillPnl);
            this._petSkillPnl = null;
         }
         if(Boolean(this._attackPbtn))
         {
            ObjectUtils.disposeObject(this._attackPbtn);
            this._attackPbtn = null;
         }
         if(Boolean(this._defencePbtn))
         {
            ObjectUtils.disposeObject(this._defencePbtn);
            this._defencePbtn = null;
         }
         if(Boolean(this._HPPbtn))
         {
            ObjectUtils.disposeObject(this._HPPbtn);
            this._HPPbtn = null;
         }
         if(Boolean(this._agilityPbtn))
         {
            ObjectUtils.disposeObject(this._agilityPbtn);
            this._agilityPbtn = null;
         }
         if(Boolean(this._luckPbtn))
         {
            ObjectUtils.disposeObject(this._luckPbtn);
            this._luckPbtn = null;
         }
         if(Boolean(this._fightBtn))
         {
            ObjectUtils.disposeObject(this._fightBtn);
            this._fightBtn = null;
         }
         if(Boolean(this._petSkillLbl))
         {
            ObjectUtils.disposeObject(this._petSkillLbl);
            this._petSkillLbl = null;
         }
         if(Boolean(this._downArowText))
         {
            ObjectUtils.disposeObject(this._downArowText);
            this._downArowText = null;
         }
         if(Boolean(this._downArowImg))
         {
            ObjectUtils.disposeObject(this._downArowImg);
            this._downArowImg = null;
         }
         this._infoPlayer = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

