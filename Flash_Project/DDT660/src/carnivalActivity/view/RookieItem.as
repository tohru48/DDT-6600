package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import ddt.manager.LanguageMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class RookieItem extends CarnivalActivityItem
   {
      
      private var _fightPower:int = -1;
      
      private var _fightPowerRankOne:int = -1;
      
      private var _fightPowerRankTwo:int = -1;
      
      public function RookieItem(type:int, info:GiftBagInfo, index:int)
      {
         super(type,info,index);
      }
      
      override protected function initData() : void
      {
         for(var i:int = 0; i < _info.giftConditionArr.length; i++)
         {
            if(_info.giftConditionArr[i].conditionIndex == 0)
            {
               this._fightPower = _info.giftConditionArr[i].conditionValue;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 1)
            {
               this._fightPowerRankOne = _info.giftConditionArr[i].conditionValue;
               this._fightPowerRankTwo = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 100)
            {
               _sumCount = _info.giftConditionArr[i].conditionValue;
            }
         }
      }
      
      override public function updateView() : void
      {
         var power:int = 0;
         var rank:int = 0;
         var info:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(info in _statusArr)
         {
            if(info.statusID == 0)
            {
               power = info.statusValue;
            }
            else
            {
               rank = info.statusValue;
            }
         }
         if(this._fightPower != -1)
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt3",this._fightPower);
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && power >= this._fightPower;
         }
         else if(this._fightPowerRankOne == this._fightPowerRankTwo)
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt1",this._fightPowerRankOne);
            _getBtn.enable = CarnivalActivityManager.instance.rookieRankCanGetAward() && _giftCurInfo.times == 0 && rank >= this._fightPowerRankOne;
         }
         else
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt2",this._fightPowerRankOne,this._fightPowerRankTwo);
            _getBtn.enable = CarnivalActivityManager.instance.rookieRankCanGetAward() && _giftCurInfo.times == 0 && rank >= this._fightPowerRankOne && rank <= this._fightPowerRankTwo;
         }
         _allGiftAlreadyGetCount = _giftCurInfo.allGiftGetTimes;
         if(Boolean(_awardCountTxt))
         {
            _awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (_sumCount - _allGiftAlreadyGetCount);
         }
         _alreadyGetBtn.visible = _giftCurInfo.times > 0;
         _getBtn.visible = !_alreadyGetBtn.visible;
      }
   }
}

