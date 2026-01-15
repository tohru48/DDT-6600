package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetStarExpData;
   import petsBag.event.PetsAdvancedEvent;
   import petsBag.view.item.StarBar;
   import road7th.comm.PackageIn;
   
   public class PetsRisingStarView extends PetsAdvancedView
   {
      
      private var _starBar:StarBar;
      
      private var _maxStarTxt:FilterFrameText;
      
      private var _helpTxt1:FilterFrameText;
      
      private var _helpTxt2:FilterFrameText;
      
      private var _helpTxt3:FilterFrameText;
      
      private var _petStarInfo:PetStarExpData;
      
      private var _oldPropArr:Array;
      
      private var _oldGrowArr:Array;
      
      private var _propLevelArr_one:Array;
      
      private var _propLevelArr_two:Array;
      
      private var _propLevelArr_three:Array;
      
      private var _growLevelArr_one:Array;
      
      private var _growLevelArr_two:Array;
      
      private var _growLevelArr_three:Array;
      
      public function PetsRisingStarView()
      {
         super(1);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._maxStarTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         this._maxStarTxt.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.maxStarTxt");
         PositionUtils.setPos(this._maxStarTxt,"petsBag.risingStar.maxStarPos");
         addChild(this._maxStarTxt);
         if(_petInfo.StarLevel == 5)
         {
            this._maxStarTxt.visible = true;
         }
         else
         {
            this._maxStarTxt.visible = false;
            this._starBar = new StarBar();
            this._starBar.starNum(_petInfo.StarLevel + 1);
            PositionUtils.setPos(this._starBar,"petsBag.risingStar.nextStarPos");
            addChild(this._starBar);
         }
         this._helpTxt1 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt1);
         this._helpTxt1.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt1");
         this._helpTxt2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt2);
         this._helpTxt2.y = this._helpTxt1.y + 25;
         this._helpTxt2.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt2");
         this._helpTxt3 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt3);
         this._helpTxt3.y = this._helpTxt2.y + 25;
         this._helpTxt3.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt3");
         if(_petInfo.StarLevel >= 5)
         {
            _btn.enable = false;
         }
      }
      
      override protected function initData() : void
      {
         super.initData();
         this.updateData();
      }
      
      private function updateData() : void
      {
         var info:PetStarExpData = null;
         var i:int = 0;
         var petTempleteInfo:PetTemplateInfo = null;
         var propArr:Array = null;
         var growArr:Array = null;
         var k:int = 0;
         var p1:int = 0;
         var p2:int = 0;
         var p3:int = 0;
         for each(info in PetsAdvancedManager.Instance.risingStarDataList)
         {
            if(info.OldID == _petInfo.TemplateID)
            {
               this._petStarInfo = info;
               _progress.max = this._petStarInfo.Exp;
               _progress.setProgress(_petInfo.currentStarExp);
               break;
            }
         }
         if(_petInfo.StarLevel >= 5)
         {
            _tip.tipData = "0/0";
            for(i = 0; i < 5; i++)
            {
               _itemVector[i].setData(i,0,0);
            }
            _progress.maxAdvancedGrade();
         }
         else if(Boolean(this._petStarInfo))
         {
            petTempleteInfo = PetInfoManager.getPetByTemplateID(this._petStarInfo.NewID);
            if(!petTempleteInfo)
            {
               return;
            }
            this._oldPropArr = [petTempleteInfo.HighBlood,petTempleteInfo.HighAttack,petTempleteInfo.HighDefence,petTempleteInfo.HighAgility,petTempleteInfo.HighLuck];
            this._oldGrowArr = [petTempleteInfo.HighBloodGrow,petTempleteInfo.HighAttackGrow,petTempleteInfo.HighDefenceGrow,petTempleteInfo.HighAgilityGrow,petTempleteInfo.HighLuckGrow];
            this._propLevelArr_one = this._oldPropArr;
            this._growLevelArr_one = this.getAddedPropArr(1,this._oldGrowArr);
            this._propLevelArr_two = this._oldPropArr;
            this._growLevelArr_two = this.getAddedPropArr(2,this._oldGrowArr);
            this._propLevelArr_three = this._oldPropArr;
            this._growLevelArr_three = this.getAddedPropArr(3,this._oldGrowArr);
            if(_petInfo.Level < 30)
            {
               for(p1 = 0; p1 < this._propLevelArr_one.length; p1++)
               {
                  this._propLevelArr_one[p1] += (_petInfo.Level - 1) * this._growLevelArr_one[p1] - _currentPropArr[p1];
                  this._growLevelArr_one[p1] -= _currentGrowArr[p1];
                  this._propLevelArr_one[p1] = Math.ceil(this._propLevelArr_one[p1] / 10) / 10;
                  this._growLevelArr_one[p1] = Math.ceil(this._growLevelArr_one[p1] / 10) / 10;
               }
               propArr = this._propLevelArr_one;
               growArr = this._growLevelArr_one;
            }
            else if(_petInfo.Level < 50)
            {
               for(p2 = 0; p2 < this._propLevelArr_two.length; p2++)
               {
                  this._propLevelArr_two[p2] += (_petInfo.Level - 30) * this._growLevelArr_two[p2] + 29 * this._growLevelArr_one[p2] - _currentPropArr[p2];
                  this._growLevelArr_two[p2] -= _currentGrowArr[p2];
                  this._propLevelArr_two[p2] = Math.ceil(this._propLevelArr_two[p2] / 10) / 10;
                  this._growLevelArr_two[p2] = Math.ceil(this._growLevelArr_two[p2] / 10) / 10;
               }
               propArr = this._propLevelArr_two;
               growArr = this._growLevelArr_two;
            }
            else
            {
               for(p3 = 0; p3 < this._propLevelArr_three.length; p3++)
               {
                  this._propLevelArr_three[p3] += (_petInfo.Level - 50) * this._growLevelArr_three[p3] + 20 * this._growLevelArr_two[p3] + 29 * this._growLevelArr_one[p3] - _currentPropArr[p3];
                  this._growLevelArr_three[p3] -= _currentGrowArr[p3];
                  this._propLevelArr_three[p3] = Math.ceil(this._propLevelArr_three[p3] / 10) / 10;
                  this._growLevelArr_three[p3] = Math.ceil(this._growLevelArr_three[p3] / 10) / 10;
               }
               propArr = this._propLevelArr_three;
               growArr = this._growLevelArr_three;
            }
            for(k = 0; k < 5; k++)
            {
               _itemVector[k].setData(k,propArr[k],growArr[k]);
            }
         }
      }
      
      private function getAddedPropArr(grade:int, propArr:Array) : Array
      {
         var arr:Array = new Array();
         arr.push(propArr[0] * Math.pow(2,grade - 1));
         for(var i:int = 1; i < 5; i++)
         {
            arr.push(propArr[i] * Math.pow(1.5,grade - 1));
         }
         return arr;
      }
      
      override protected function __enterFrame(event:Event) : void
      {
         if(!_starMc)
         {
            return;
         }
         if(_starMc.currentFrame == 100)
         {
            _petsBasicInfoView.dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.STARORGRADE_MOVIE_COMPLETE));
            playNumMovie();
            updatePetData();
            this.updateData();
         }
         else if(_starMc.currentFrame >= 110)
         {
            _starMc.stop();
            removeChild(_starMc);
            this.updateView();
            _starMc = null;
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function updateView() : void
      {
         _petsBasicInfoView.updateStar(_petInfo.StarLevel);
         if(_petInfo.StarLevel < 5)
         {
            this._starBar.starNum(_petInfo.StarLevel + 1);
         }
         else
         {
            ObjectUtils.disposeObject(this._starBar);
            this._starBar = null;
            this._maxStarTxt.visible = true;
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_RISINGSTAR,this.__risingStarHandler);
      }
      
      protected function __risingStarHandler(event:CrazyTankSocketEvent) : void
      {
         _petInfo = PetBagController.instance().petModel.currentPetInfo;
         var pkg:PackageIn = event.pkg;
         var success:Boolean = pkg.readBoolean();
         if(success)
         {
            _btn.enable = false;
         }
         _bagCell.updateCount();
         _progress.setProgress(_petInfo.currentStarExp,success);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_RISINGSTAR,this.__risingStarHandler);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._starBar);
         this._starBar = null;
         ObjectUtils.disposeObject(this._maxStarTxt);
         this._maxStarTxt = null;
         ObjectUtils.disposeObject(this._helpTxt1);
         this._helpTxt1 = null;
         ObjectUtils.disposeObject(this._helpTxt2);
         this._helpTxt2 = null;
         ObjectUtils.disposeObject(this._helpTxt3);
         this._helpTxt3 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

