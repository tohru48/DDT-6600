package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class WholePeoplePetActItem extends CarnivalActivityItem
   {
      
      private var _selfNeedPetNum:int = -1;
      
      private var _selfNeedPetStar:int;
      
      private var _personNeedPetNum:int = -1;
      
      private var _personNeedPetStar:int;
      
      private var _addedNeedPetNum:int = -1;
      
      private var _addedNeedPetStar:int;
      
      private var _getCount:int = -1;
      
      private var _addedIsSuperPet:Boolean;
      
      private var _personIsSuperPet:Boolean;
      
      private var _selfIsSuperPet:Boolean;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _tipStr:String = "";
      
      private var _tipSp:WholePeopleTipSp;
      
      private var _awardCount:int;
      
      public function WholePeoplePetActItem(type:int, info:GiftBagInfo, index:int)
      {
         super(type,info,index);
      }
      
      override protected function initItem() : void
      {
         var temp:int = 0;
         var selfTemp:int = 0;
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         for(var j:int = 0; j < _info.giftConditionArr.length; j++)
         {
            if(_info.giftConditionArr[j].conditionIndex == 4)
            {
               this._selfIsSuperPet = true;
            }
            else if(_info.giftConditionArr[j].conditionIndex == 5)
            {
               this._personIsSuperPet = true;
            }
            else if(_info.giftConditionArr[j].conditionIndex == 6)
            {
               this._addedIsSuperPet = true;
            }
         }
         for(var i:int = 0; i < _info.giftConditionArr.length; i++)
         {
            if(_info.giftConditionArr[i].conditionIndex == (this._selfIsSuperPet ? 4 : 0))
            {
               this._selfNeedPetStar = _info.giftConditionArr[i].conditionValue;
               this._selfNeedPetNum = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == (this._personIsSuperPet ? 5 : 1))
            {
               this._personNeedPetStar = _info.giftConditionArr[i].conditionValue;
               this._personNeedPetNum = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == (this._addedIsSuperPet ? 6 : 2))
            {
               this._addedNeedPetStar = _info.giftConditionArr[i].conditionValue;
               this._addedNeedPetNum = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 3)
            {
               this._getCount = _info.giftConditionArr[i].conditionValue;
            }
         }
         var desc:String = "";
         if(this._addedNeedPetNum != -1)
         {
            temp = this._addedIsSuperPet ? 6 : 3;
            selfTemp = this._selfIsSuperPet ? 6 : 3;
            desc = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + temp,this._addedNeedPetNum,this._addedIsSuperPet ? this._addedNeedPetStar - 10 : this._addedNeedPetStar);
            if(this._selfNeedPetNum != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.pet.tipTxt" + selfTemp,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
            }
         }
         else if(this._personNeedPetNum != -1)
         {
            temp = this._personIsSuperPet ? 5 : 2;
            selfTemp = this._selfIsSuperPet ? 5 : 2;
            desc = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + temp,this._personNeedPetNum,this._personIsSuperPet ? this._personNeedPetStar - 10 : this._personNeedPetStar);
            if(this._selfNeedPetNum != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.pet.tipTxt" + selfTemp,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
            }
         }
         else
         {
            temp = this._selfIsSuperPet ? 4 : 1;
            desc = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + temp,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
         }
         _descTxt.text = desc;
      }
      
      override public function updateView() : void
      {
         var addedNum:int = 0;
         var personNum:int = 0;
         var selfNum:int = 0;
         var info:PlayerCurInfo = null;
         var addedBoolean:Boolean = false;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(info in _statusArr)
         {
            if(info.statusID >= this._selfNeedPetStar + (this._selfIsSuperPet ? 200 : 0) && info.statusID < 50 + (this._selfIsSuperPet ? 200 : 0))
            {
               selfNum += info.statusValue;
            }
            else if(info.statusID == this._personNeedPetStar + (this._personIsSuperPet ? 300 : 100))
            {
               personNum = info.statusValue;
            }
            else if(info.statusID == this._addedNeedPetStar + (this._addedIsSuperPet ? 300 : 100))
            {
               addedNum = info.statusValue;
            }
         }
         addedBoolean = this._addedNeedPetNum != -1 ? int(addedNum / this._addedNeedPetNum) > _giftCurInfo.times : true;
         var personBoolean:Boolean = this._personNeedPetNum != -1 ? personNum >= this._personNeedPetNum : true;
         var selfBoolean:Boolean = this._selfNeedPetNum != -1 ? selfNum >= this._selfNeedPetNum : true;
         var timeBoolean:Boolean = this._getCount == 0 ? true : _giftCurInfo.times < this._getCount;
         var canGet:Boolean = CarnivalActivityManager.instance.canGetAward() && addedBoolean && personBoolean && selfBoolean && timeBoolean;
         if(this._addedNeedPetNum != -1)
         {
            ObjectUtils.disposeObject(_getBtn);
            _getBtn = null;
            if(canGet && int(addedNum / this._addedNeedPetNum) - _giftCurInfo.times >= 1)
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               addChild(_getBtn);
               addChild(this._btnTxt);
               this._btnTxt.x = _getBtn.x + 49;
               this._btnTxt.y = _getBtn.y + 8;
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._tipsBtn.x = _getBtn.x + 45;
               this._tipsBtn.y = _getBtn.y - 16;
               addChild(this._tipsBtn);
               this._btnTxt.text = "(" + (int(addedNum / this._addedNeedPetNum) - _giftCurInfo.times) + ")";
               this._awardCount = int(addedNum / this._addedNeedPetNum) - _giftCurInfo.times;
            }
            else
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(_getBtn);
            }
            _getBtn.enable = canGet && int(addedNum / this._addedNeedPetNum) - _giftCurInfo.times >= 1;
            _getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
            PositionUtils.setPos(_getBtn,"carnivalAct.getButtonPos");
            _awardCountTxt.text = "" + addedNum;
         }
         else if(this._personNeedPetNum != -1)
         {
            _awardCountTxt.text = personNum + "/" + this._personNeedPetNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = canGet && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _awardCountTxt.text = selfNum + "/" + this._selfNeedPetNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = canGet && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         if(this._tipStr != "")
         {
            if(!_getBtn.enable)
            {
               this._tipSp = new WholePeopleTipSp();
               addChild(this._tipSp);
               this._tipSp.graphics.beginFill(16777215,0);
               this._tipSp.graphics.drawRect(0,0,_getBtn.width,_getBtn.height);
               this._tipSp.graphics.endFill();
               this._tipSp.width = this._tipSp.displayWidth;
               this._tipSp.height = this._tipSp.displayHeight;
               PositionUtils.setPos(this._tipSp,"carnivalAct.getButtonPos");
               this._tipSp.tipStyle = "ddt.view.tips.OneLineTip";
               this._tipSp.tipDirctions = "0,5";
               this._tipSp.tipData = this._tipStr;
            }
            else
            {
               _getBtn.tipStyle = "ddt.view.tips.OneLineTip";
               _getBtn.tipDirctions = "0,5";
               _getBtn.tipData = this._tipStr;
            }
         }
      }
      
      override protected function __getAwardHandler(event:MouseEvent) : void
      {
         if(getTimer() - CarnivalActivityManager.instance.lastClickTime < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
            return;
         }
         CarnivalActivityManager.instance.lastClickTime = getTimer();
         SoundManager.instance.playButtonSound();
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var info:SendGiftInfo = new SendGiftInfo();
         info.activityId = _info.activityId;
         info.giftIdArr = [_info.giftbagId];
         if(this._addedNeedPetNum != -1)
         {
            info.awardCount = this._awardCount;
         }
         else
         {
            info.awardCount = 1;
         }
         sendInfoVec.push(info);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._tipSp);
         this._tipSp = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
         super.dispose();
      }
   }
}

