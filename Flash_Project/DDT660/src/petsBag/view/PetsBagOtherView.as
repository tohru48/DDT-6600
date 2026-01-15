package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFightPropertyData;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   
   public class PetsBagOtherView extends PetsBagView
   {
      
      public function PetsBagOtherView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         _petSkillPnl = ComponentFactory.Instance.creat("petsBag.petSkillPnl",[true]);
         addChild(_petSkillPnl);
         _bgSkillPnl.width = 408;
         _fightBtn.visible = false;
         PetBagController.instance().isOtherPetViewOpen = true;
      }
      
      override public function set infoPlayer(value:PlayerInfo) : void
      {
         if(_infoPlayer == value)
         {
            return;
         }
         _infoPlayer = value;
         if(!_infoPlayer)
         {
            return;
         }
         _petMoveScroll.infoPlayer = _infoPlayer;
         _currentPet = getFirstPet(_infoPlayer);
         this.updatePetBagView();
      }
      
      override public function updatePetBagView() : void
      {
         if(!hasPet)
         {
            this.mouseChildren = false;
            disableAllObj();
            _petExpProgress.noPet();
         }
         var currentPet:PetInfo = _currentPet;
         _petName.text = Boolean(currentPet) ? currentPet.Name : "";
         _petExpProgress.setProgress(Boolean(currentPet) ? currentPet.GP : 0,Boolean(currentPet) ? currentPet.MaxGP : 0);
         this.updatePetsPropByEvolution();
         _happyBarPet.info = currentPet;
         this.updateSkill();
         this.updateProperByPetStatus();
         this.updatePetSatiation();
         _showPet.update2(currentPet);
      }
      
      override protected function __onChange(event:Event) : void
      {
         _currentPet = PetBagController.instance().petModel.currentPetInfo;
         if(Boolean(_currentPet))
         {
            this.updatePetBagView();
         }
         _petMoveScroll.updateSelect();
      }
      
      override public function updatePetsPropByEvolution() : void
      {
         var info:PetFightPropertyData = null;
         var currentPet:PetInfo = _currentPet;
         for each(info in PetsAdvancedManager.Instance.evolutionDataList)
         {
            if(_infoPlayer.evolutionGrade == 0)
            {
               _currentGradeInfo = new PetFightPropertyData();
               break;
            }
            if(info.ID == _infoPlayer.evolutionGrade)
            {
               _currentGradeInfo = info;
               break;
            }
         }
         if(!_currentGradeInfo)
         {
            _currentGradeInfo = new PetFightPropertyData();
         }
         if(Boolean(currentPet))
         {
            _attackPbtn.propValue = currentPet.IsEquip ? currentPet.Attack + _currentGradeInfo.Attack : currentPet.Attack;
            _defencePbtn.propValue = currentPet.IsEquip ? currentPet.Defence + _currentGradeInfo.Defence : currentPet.Defence;
            _HPPbtn.propValue = currentPet.IsEquip ? currentPet.Blood + _currentGradeInfo.Blood : currentPet.Blood;
            _agilityPbtn.propValue = currentPet.IsEquip ? currentPet.Agility + _currentGradeInfo.Agility : currentPet.Agility;
            _luckPbtn.propValue = currentPet.IsEquip ? currentPet.Luck + _currentGradeInfo.Lucky : currentPet.Luck;
         }
      }
      
      override protected function updatePetSatiation() : void
      {
         var petHappyStar:int = 0;
         if(Boolean(PetBagController.instance().petModel) && Boolean(_currentPet))
         {
            petHappyStar = _currentPet.PetHappyStar;
            if(_currentPetHappyStar != petHappyStar)
            {
               if(Boolean(_downArowText))
               {
                  ObjectUtils.disposeObject(_downArowText);
               }
               _downArowText = null;
               if(petHappyStar == 1 || petHappyStar == 2)
               {
                  _downArowText = ComponentFactory.Instance.creatBitmap("assets.petsBag.downArowText" + _downArowTextData[petHappyStar]);
                  _downArowText.x = _downArowImg.x + (_downArowImg.width - _downArowText.width) / 2;
                  _downArowText.y = _downArowImg.y + _downArowImg.height;
                  addChild(_downArowText);
                  setDownArowVisible(true);
               }
               else
               {
                  setDownArowVisible(false);
               }
               _currentPetHappyStar = petHappyStar;
            }
         }
         else
         {
            setDownArowVisible(false);
         }
      }
      
      override protected function updateSkill() : void
      {
         var currentPet:PetInfo = _currentPet;
         var petSkillAll:Array = Boolean(currentPet) ? currentPet.skills : [];
         if(Boolean(_petSkillPnl))
         {
            _petSkillPnl.itemInfo = petSkillAll;
         }
      }
      
      override protected function updateProperByPetStatus(isNomal:Boolean = true) : void
      {
         var currentPercent:Number = NaN;
         var addTipDesc:String = null;
         updatePropertyTip();
         if(Boolean(_currentPet))
         {
            currentPercent = _currentPet.Hunger / PetHappyBar.fullHappyValue;
            addTipDesc = "";
            _attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail");
            _defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail");
            _agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail");
            _luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail");
            _HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail");
            _attackPbtn.propColor = 16774857;
            _defencePbtn.propColor = 16774857;
            _agilityPbtn.propColor = 16774857;
            _luckPbtn.propColor = 16774857;
            _HPPbtn.propColor = 16774857;
            _attackPbtn.valueFilterString = 1;
            _agilityPbtn.valueFilterString = 1;
            _luckPbtn.valueFilterString = 1;
            _HPPbtn.valueFilterString = 1;
            _defencePbtn.valueFilterString = 1;
            if(currentPercent < 0.8)
            {
               addTipDesc = _currentPet.PetHappyStar > 0 ? LanguageMgr.GetTranslation("ddt.pets.petHappyDesc",PetHappyBar.petPercentArray[_currentPet.PetHappyStar]) : LanguageMgr.GetTranslation("ddt.pets.petUnFight");
            }
            _attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail") + addTipDesc;
            _defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail") + addTipDesc;
            _agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail") + addTipDesc;
            _luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail") + addTipDesc;
            _HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail") + addTipDesc;
         }
      }
      
      override public function dispose() : void
      {
         PetBagController.instance().isOtherPetViewOpen = false;
         super.dispose();
      }
   }
}

