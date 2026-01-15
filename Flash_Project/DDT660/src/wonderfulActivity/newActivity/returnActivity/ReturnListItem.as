package wonderfulActivity.newActivity.returnActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.items.PrizeListItem;
   
   public class ReturnListItem extends Sprite implements Disposeable
   {
      
      private var _back:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _prizeHBox:HBox;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var type:int;
      
      private var actId:String;
      
      private var giftInfo:GiftBagInfo;
      
      private var condition:int;
      
      public function ReturnListItem(type:int, actId:String)
      {
         super();
         this.type = type;
         this.actId = actId;
         this.initView();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.listItem");
         addChild(this._back);
         if(this.type == 0)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.returnItem.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.returnActivity.Hbox");
         addChild(this._prizeHBox);
      }
      
      public function setData(desc:String, info:GiftBagInfo) : void
      {
         var gift:GiftRewardInfo = null;
         var prizeItem:PrizeListItem = null;
         this.giftInfo = info;
         this.condition = this.giftInfo.giftConditionArr[0].conditionValue;
         this._nameTxt.text = desc.replace(/{\d+}/g,this.condition);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         var rewardArr:Vector.<GiftRewardInfo> = this.giftInfo.giftRewardArr;
         for(var i:int = 0; i <= rewardArr.length - 1; i++)
         {
            gift = rewardArr[i];
            prizeItem = new PrizeListItem();
            prizeItem.initView(i);
            prizeItem.setCellData(gift);
            this._prizeHBox.addChild(prizeItem);
         }
      }
      
      public function setStatus(payValue:int, giftStatusDic:Dictionary) : void
      {
         var remain:int = 0;
         this.clearBtn();
         var alreadyGet:int = (giftStatusDic[this.giftInfo.giftbagId] as GiftCurInfo).times;
         var canReget:int = this.giftInfo.giftConditionArr[2].conditionValue;
         if(canReget == 0)
         {
            remain = int(Math.floor(payValue / this.condition)) - alreadyGet;
            if(remain > 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
               addChild(this._btn);
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               this._btnTxt.text = "(" + remain + ")";
               this._btn.addChild(this._btnTxt);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._btn.addChild(this._tipsBtn);
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClicks);
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(this._btn);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._tipsBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._btn.addChild(this._tipsBtn);
               this._btn.enable = false;
            }
         }
         else if(alreadyGet == 0)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
            addChild(this._btn);
            this._btn.enable = false;
            if(payValue >= this.condition)
            {
               this._btn.enable = true;
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
            }
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
            this._btn.enable = false;
            addChild(this._btn);
         }
      }
      
      protected function getRewardBtnClicks(event:MouseEvent) : void
      {
         var getAwardInfo:SendGiftInfo = new SendGiftInfo();
         getAwardInfo.activityId = this.actId;
         var tmpArr:Array = [];
         tmpArr.push(this.giftInfo.giftbagId);
         getAwardInfo.giftIdArr = tmpArr;
         var data:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         data.push(getAwardInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(data);
         this._btn.enable = false;
      }
      
      protected function getRewardBtnClick(event:MouseEvent) : void
      {
         var getAwardInfo:SendGiftInfo = new SendGiftInfo();
         getAwardInfo.activityId = this.actId;
         var tmpArr:Array = [];
         tmpArr.push(this.giftInfo.giftbagId);
         getAwardInfo.giftIdArr = tmpArr;
         var data:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         data.push(getAwardInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(data);
         if(Boolean(this._btn))
         {
            ObjectUtils.disposeObject(this._btn);
            this._btn = null;
         }
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
         this._btn.enable = false;
         addChild(this._btn);
      }
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
   }
}

