package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import horse.HorseManager;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class HorseDarenItem extends CarnivalActivityItem
   {
      
      private var _horseGrade:int;
      
      private var _horseStar:int;
      
      private var _horseSkillType:int;
      
      private var _horseSkillGrade:int;
      
      private var _reallyHorseGrade:int;
      
      public function HorseDarenItem(type:int, info:GiftBagInfo, index:int)
      {
         super(type,info,index);
      }
      
      override protected function initItem() : void
      {
         var skillName:String = null;
         for(var i:int = 0; i < _info.giftConditionArr.length; i++)
         {
            if(CarnivalActivityManager.instance.currentChildType == 0)
            {
               if(_info.giftConditionArr[i].conditionIndex == 0)
               {
                  this._horseGrade = _info.giftConditionArr[i].conditionValue;
                  this._reallyHorseGrade = _info.giftConditionArr[i].remain1;
               }
               else
               {
                  this._horseStar = _info.giftConditionArr[i].conditionValue;
               }
            }
            else if(_info.giftConditionArr[i].conditionIndex == 0)
            {
               this._horseSkillType = _info.giftConditionArr[i].conditionValue;
            }
            else
            {
               this._horseSkillGrade = _info.giftConditionArr[i].conditionValue;
            }
         }
         if(_sumCount != 0)
         {
            _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
            addChild(_awardCountTxt);
         }
         else
         {
            _descTxt.y += 9;
         }
         if(CarnivalActivityManager.instance.currentChildType == 0)
         {
            _descTxt.text = LanguageMgr.GetTranslation("horseDaren.grade.descTxt",this._horseGrade,this._horseStar);
         }
         else
         {
            skillName = HorseManager.instance.getHorseSkillName(this._horseSkillType,this._horseSkillGrade);
            _descTxt.text = LanguageMgr.GetTranslation("horseDaren.skill.descTxt",skillName);
         }
      }
      
      override public function updateView() : void
      {
         var grade:int = 0;
         var currentGrade:int = 0;
         var skillGrade:int = 0;
         var currentSkillGrade:int = 0;
         var info:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(info in _statusArr)
         {
            if(CarnivalActivityManager.instance.currentChildType == 0)
            {
               if(info.statusID == 0)
               {
                  grade = info.statusValue;
               }
               else if(info.statusID == 1)
               {
                  currentGrade = info.statusValue;
               }
            }
            else if(info.statusID == this._horseSkillType)
            {
               skillGrade = info.statusValue;
            }
            else if(info.statusID == this._horseSkillType + 100)
            {
               currentSkillGrade = info.statusValue;
            }
         }
         if(CarnivalActivityManager.instance.currentChildType == 0)
         {
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && this._reallyHorseGrade > grade && this._reallyHorseGrade <= currentGrade;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && this._horseSkillGrade > skillGrade && this._horseSkillGrade <= currentSkillGrade;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         if(Boolean(_awardCountTxt))
         {
            _awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (_sumCount - _giftCurInfo.allGiftGetTimes);
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(_alreadyGetBtn);
         _alreadyGetBtn = null;
         super.dispose();
      }
   }
}

