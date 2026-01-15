package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.QualityType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class DailyGiftItem extends CarnivalActivityItem
   {
      
      private var _count:int;
      
      private var _temId:int;
      
      private var _getGoodsType:int;
      
      private var _beadGrade:int;
      
      private var _magicStoneQuality:int;
      
      private var _actType:int;
      
      public function DailyGiftItem(type:int, info:GiftBagInfo, index:int)
      {
         super(type,info,index);
      }
      
      override protected function initItem() : void
      {
         var quality:int = 0;
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         for(var i:int = 0; i < _info.giftConditionArr.length; i++)
         {
            if(_info.giftConditionArr[i].conditionIndex == 0)
            {
               this._actType = 1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 1)
            {
               this._actType = 2;
               this._count = _info.giftConditionArr[i].remain1;
               this._getGoodsType = int(_info.giftConditionArr[i].remain2);
               if(this._getGoodsType == 2)
               {
                  this._beadGrade = _info.giftConditionArr[i].conditionValue;
               }
               else
               {
                  this._magicStoneQuality = _info.giftConditionArr[i].conditionValue;
               }
            }
            else if(_info.giftConditionArr[i].conditionIndex == 2)
            {
               this._actType = 3;
            }
            else if(_info.giftConditionArr[i].conditionIndex != 3)
            {
               if(_info.giftConditionArr[i].conditionIndex > 50 && _info.giftConditionArr[i].conditionIndex < 100)
               {
                  this._temId = _info.giftConditionArr[i].conditionValue;
                  this._count = _info.giftConditionArr[i].remain1;
               }
            }
         }
         _descTxt.height *= 2;
         if(this._actType == 1)
         {
            _descTxt.y -= 8;
            _awardCountTxt.y += 7;
            _descTxt.text = LanguageMgr.GetTranslation("dailyGift.useType.descTxt",this._count,ItemManager.Instance.getTemplateById(this._temId).Name);
         }
         else if(this._actType == 2)
         {
            if(this._getGoodsType == 1)
            {
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count);
            }
            else if(this._getGoodsType == 2)
            {
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count,this._beadGrade);
            }
            else
            {
               quality = this._magicStoneQuality / 100;
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count,QualityType.QUALITY_STRING[quality]);
            }
         }
         else
         {
            _descTxt.y -= 8;
            _awardCountTxt.y += 7;
            _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.plantTxt",this._count,ItemManager.Instance.getTemplateById(this._temId).Name);
         }
      }
      
      override public function updateView() : void
      {
         var magicStoneInfo:PlayerCurInfo = null;
         var beadInfo:PlayerCurInfo = null;
         var info:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(info in _statusArr)
         {
            if(this._actType == 1 || this._actType == 3)
            {
               if(info.statusID == this._temId)
               {
                  _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && info.statusValue >= this._count;
                  _awardCountTxt.text = info.statusValue + "/" + this._count;
               }
            }
            else if(this._getGoodsType == 3)
            {
               if(info.statusID == this._magicStoneQuality)
               {
                  magicStoneInfo = info;
               }
            }
            else if(this._getGoodsType == 2)
            {
               if(info.statusID == this._beadGrade)
               {
                  beadInfo = info;
               }
            }
            else
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && info.statusValue >= this._count;
               _awardCountTxt.text = info.statusValue + "/" + this._count;
            }
         }
         if(this._actType == 2)
         {
            if(this._getGoodsType == 3)
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && Boolean(magicStoneInfo) ? _giftCurInfo.times == 0 && magicStoneInfo.statusValue >= this._count : false;
               _awardCountTxt.text = (Boolean(magicStoneInfo) ? magicStoneInfo.statusValue : 0) + "/" + this._count;
            }
            else if(this._getGoodsType == 2)
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && Boolean(beadInfo) ? _giftCurInfo.times == 0 && beadInfo.statusValue >= this._count : false;
               _awardCountTxt.text = (Boolean(beadInfo) ? beadInfo.statusValue : 0) + "/" + this._count;
            }
         }
         _alreadyGetBtn.visible = _giftCurInfo.times > 0;
         _getBtn.visible = !_alreadyGetBtn.visible;
      }
   }
}

