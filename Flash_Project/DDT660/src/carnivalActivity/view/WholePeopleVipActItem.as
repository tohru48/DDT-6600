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
   
   public class WholePeopleVipActItem extends CarnivalActivityItem
   {
      
      private var _selfGrade:int = -1;
      
      private var _personNum:int = -1;
      
      private var _vipGd:int;
      
      private var _addedNum:int = -1;
      
      private var _addedVipGd:int;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _tipStr:String = "";
      
      private var _tipSp:WholePeopleTipSp;
      
      private var _awardCount:int;
      
      private var _getCount:int = -1;
      
      public function WholePeopleVipActItem(type:int, info:GiftBagInfo, index:int)
      {
         super(type,info,index);
      }
      
      override protected function initItem() : void
      {
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         for(var i:int = 0; i < _info.giftConditionArr.length; i++)
         {
            if(_info.giftConditionArr[i].conditionIndex == 0)
            {
               this._selfGrade = _info.giftConditionArr[i].conditionValue;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 1)
            {
               this._vipGd = _info.giftConditionArr[i].conditionValue;
               this._personNum = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 2)
            {
               this._addedVipGd = _info.giftConditionArr[i].conditionValue;
               this._addedNum = _info.giftConditionArr[i].remain1;
            }
            else if(_info.giftConditionArr[i].conditionIndex == 3)
            {
               this._getCount = _info.giftConditionArr[i].conditionValue;
            }
         }
         var desc:String = "";
         if(this._addedNum != -1)
         {
            desc = LanguageMgr.GetTranslation("wholePeople.vip.descTxt3",this._addedVipGd,this._addedNum);
            if(this._selfGrade != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.vip.tipTxt",this._selfGrade);
            }
         }
         else if(this._personNum != -1)
         {
            desc = LanguageMgr.GetTranslation("wholePeople.vip.descTxt2",this._vipGd,this._personNum);
            if(this._selfGrade != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.vip.tipTxt",this._selfGrade);
            }
         }
         else
         {
            desc = LanguageMgr.GetTranslation("wholePeople.vip.descTxt1",this._selfGrade);
         }
         _descTxt.text = desc;
      }
      
      override public function updateView() : void
      {
         var addedNum:int = 0;
         var personNum:int = 0;
         var selfGrade:int = 0;
         var info:PlayerCurInfo = null;
         var addedBoolean:Boolean = false;
         var canGet:Boolean = false;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(info in _statusArr)
         {
            if(info.statusID == 0)
            {
               selfGrade = info.statusValue;
            }
            else if(info.statusID == this._vipGd)
            {
               personNum = info.statusValue;
            }
            else if(info.statusID == this._addedVipGd)
            {
               addedNum = info.statusValue;
            }
         }
         addedBoolean = this._addedNum != -1 ? int(addedNum / this._addedNum) > _giftCurInfo.times : true;
         var personBoolean:Boolean = this._personNum != -1 ? personNum >= this._personNum : true;
         var selfBoolean:Boolean = this._selfGrade != -1 ? selfGrade >= this._selfGrade : true;
         var timeBoolean:Boolean = this._getCount == 0 ? true : _giftCurInfo.times < this._getCount;
         canGet = CarnivalActivityManager.instance.canGetAward() && addedBoolean && personBoolean && selfBoolean && timeBoolean;
         if(this._addedNum != -1)
         {
            ObjectUtils.disposeObject(_getBtn);
            _getBtn = null;
            if(canGet && int(addedNum / this._addedNum) - _giftCurInfo.times >= 1)
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
               this._btnTxt.text = "(" + (int(addedNum / this._addedNum) - _giftCurInfo.times) + ")";
               this._awardCount = int(addedNum / this._addedNum) - _giftCurInfo.times;
            }
            else
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(_getBtn);
            }
            _getBtn.enable = canGet && int(addedNum / this._addedNum) - _giftCurInfo.times >= 1;
            _getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
            PositionUtils.setPos(_getBtn,"carnivalAct.getButtonPos");
            _awardCountTxt.text = "" + addedNum;
         }
         else if(this._personNum != -1)
         {
            _awardCountTxt.text = personNum + "/" + this._personNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = canGet && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _descTxt.y += 9;
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
         if(this._addedNum != -1)
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

