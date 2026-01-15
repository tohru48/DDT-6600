package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import petsBag.data.PetFightPropertyData;
   import petsBag.event.PetsAdvancedEvent;
   import road7th.comm.PackageIn;
   
   public class PetsEvolutionView extends PetsAdvancedView
   {
      
      private var _attackTxt:FilterFrameText;
      
      private var _attackAddedTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _defenceAddedTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _agilityAddedTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _luckAddedTxt:FilterFrameText;
      
      private var _hpTxt:FilterFrameText;
      
      private var _hpAddedTxt:FilterFrameText;
      
      private var _txt:FilterFrameText;
      
      private var _evolutionGradeTxt:FilterFrameText;
      
      private var _currentGradeInfo:PetFightPropertyData;
      
      private var _nextGradeInfo:PetFightPropertyData;
      
      public function PetsEvolutionView()
      {
         super(2);
      }
      
      override protected function initView() : void
      {
         super.initView();
         PositionUtils.setPos(_vBox,"petsBag.evolution.vBoxPos");
         this._evolutionGradeTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionGradeTxt");
         addChild(this._evolutionGradeTxt);
         this._evolutionGradeTxt.text = "LV." + _self.evolutionGrade;
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._attackTxt);
         this._attackTxt.text = LanguageMgr.GetTranslation("attack");
         PositionUtils.setPos(this._attackTxt,"petsBag.evolution.attackPos");
         this._attackAddedTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.propValueTxt");
         addChild(this._attackAddedTxt);
         this._attackAddedTxt.x = 107;
         this._attackAddedTxt.y = this._attackTxt.y;
         this._attackAddedTxt.text = "0";
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._defenceTxt);
         this._defenceTxt.text = LanguageMgr.GetTranslation("defence");
         PositionUtils.setPos(this._defenceTxt,"petsBag.evolution.defencePos");
         this._defenceAddedTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.propValueTxt");
         addChild(this._defenceAddedTxt);
         this._defenceAddedTxt.x = 107;
         this._defenceAddedTxt.y = this._defenceTxt.y;
         this._defenceAddedTxt.text = "0";
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._agilityTxt);
         this._agilityTxt.text = LanguageMgr.GetTranslation("agility");
         PositionUtils.setPos(this._agilityTxt,"petsBag.evolution.agilityPos");
         this._agilityAddedTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.propValueTxt");
         addChild(this._agilityAddedTxt);
         this._agilityAddedTxt.x = 107;
         this._agilityAddedTxt.y = this._agilityTxt.y;
         this._agilityAddedTxt.text = "0";
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._luckTxt);
         this._luckTxt.text = LanguageMgr.GetTranslation("luck");
         PositionUtils.setPos(this._luckTxt,"petsBag.evolution.hurtPos");
         this._luckAddedTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.propValueTxt");
         addChild(this._luckAddedTxt);
         this._luckAddedTxt.x = 250;
         this._luckAddedTxt.y = this._luckTxt.y;
         this._luckAddedTxt.text = "0";
         this._hpTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._hpTxt);
         this._hpTxt.text = LanguageMgr.GetTranslation("MaxHp");
         PositionUtils.setPos(this._hpTxt,"petsBag.evolution.hpPos");
         this._hpAddedTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.propValueTxt");
         addChild(this._hpAddedTxt);
         this._hpAddedTxt.x = 250;
         this._hpAddedTxt.y = this._hpTxt.y;
         this._hpAddedTxt.text = "0";
         this._txt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.Txt");
         addChild(this._txt);
         this._txt.text = LanguageMgr.GetTranslation("ddt.pets.evolution.helpTxt");
         if(_self.evolutionGrade >= PetsAdvancedManager.Instance.evolutionDataList.length)
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
         var info:PetFightPropertyData = null;
         var addedPropArr:Array = null;
         for each(info in PetsAdvancedManager.Instance.evolutionDataList)
         {
            if(_self.evolutionGrade == 0)
            {
               this._currentGradeInfo = new PetFightPropertyData();
            }
            if(info.ID == _self.evolutionGrade)
            {
               this._currentGradeInfo = info;
            }
            else if(info.ID == _self.evolutionGrade + 1)
            {
               this._nextGradeInfo = info;
            }
         }
         if(this._currentGradeInfo == null)
         {
            return;
         }
         var blood:int = _petInfo.IsEquip ? _petInfo.Blood + this._currentGradeInfo.Blood : _petInfo.Blood;
         var attack:int = _petInfo.IsEquip ? _petInfo.Attack + this._currentGradeInfo.Attack : _petInfo.Attack;
         var defence:int = _petInfo.IsEquip ? _petInfo.Defence + this._currentGradeInfo.Defence : _petInfo.Defence;
         var agility:int = _petInfo.IsEquip ? _petInfo.Agility + this._currentGradeInfo.Agility : _petInfo.Agility;
         var luck:int = _petInfo.IsEquip ? _petInfo.Luck + this._currentGradeInfo.Lucky : _petInfo.Luck;
         var propArr:Array = [blood,attack,defence,agility,luck];
         if(_self.evolutionGrade >= PetsAdvancedManager.Instance.evolutionDataList.length)
         {
            _tip.tipData = "0/0";
            _progress.maxAdvancedGrade();
            addedPropArr = [0,0,0,0,0];
         }
         else if(Boolean(this._nextGradeInfo))
         {
            _progress.max = this._nextGradeInfo.Exp - this._currentGradeInfo.Exp;
            _progress.setProgress(_self.evolutionExp - this._currentGradeInfo.Exp);
            addedPropArr = [this._nextGradeInfo.Blood - this._currentGradeInfo.Blood,this._nextGradeInfo.Attack - this._currentGradeInfo.Attack,this._nextGradeInfo.Defence - this._currentGradeInfo.Defence,this._nextGradeInfo.Agility - this._currentGradeInfo.Agility,this._nextGradeInfo.Lucky - this._currentGradeInfo.Lucky];
         }
         for(var i:int = 0; i < _itemVector.length; i++)
         {
            _itemVector[i].setData(i,propArr[i],addedPropArr[i]);
         }
         this.setAddedTxt();
      }
      
      private function setAddedTxt() : void
      {
         this._attackAddedTxt.text = "" + this._currentGradeInfo.Attack;
         this._defenceAddedTxt.text = "" + this._currentGradeInfo.Defence;
         this._agilityAddedTxt.text = "" + this._currentGradeInfo.Agility;
         this._luckAddedTxt.text = "" + this._currentGradeInfo.Lucky;
         this._hpAddedTxt.text = "" + this._currentGradeInfo.Blood;
      }
      
      override protected function __enterFrame(event:Event) : void
      {
         if(!_gradeMc)
         {
            return;
         }
         if(_gradeMc.currentFrame >= 19)
         {
            _gradeMc.stop();
            removeChild(_gradeMc);
            _gradeMc = null;
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this.updateData();
            this._evolutionGradeTxt.text = "LV." + _self.evolutionGrade;
            _petsBasicInfoView.dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.STARORGRADE_MOVIE_COMPLETE));
            playNumMovie();
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_EVOLUTION,this.__evolutionHandler);
      }
      
      protected function __evolutionHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var success:Boolean = pkg.readBoolean();
         if(success)
         {
            _btn.enable = false;
            PetsAdvancedManager.Instance.dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.EVOLUTION_COMPLETE));
         }
         _bagCell.updateCount();
         _progress.setProgress(_self.evolutionExp - this._currentGradeInfo.Exp,success);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_EVOLUTION,this.__evolutionHandler);
      }
      
      override public function dispose() : void
      {
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         super.dispose();
      }
   }
}

