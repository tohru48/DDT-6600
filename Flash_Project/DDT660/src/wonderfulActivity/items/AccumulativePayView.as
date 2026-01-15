package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class AccumulativePayView extends Sprite implements IRightView
   {
      
      private static const LENGTH:int = 10;
      
      private static const LENGTH2:int = 8;
      
      private static const NUMBER:int = 5;
      
      private static const NUMBER2:int = 4;
      
      private static const PRIZE_LEN:int = 7;
      
      private var _content:Sprite;
      
      private var _bg:Bitmap;
      
      private var _title:Bitmap;
      
      private var _shadowBG:Bitmap;
      
      private var _progressBack1:ScaleBitmapImage;
      
      private var _progressBack2:ScaleBitmapImage;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArr:Array;
      
      private var _prizeBG:Bitmap;
      
      private var _prizeList:HBox;
      
      private var _prizeArr:Array;
      
      private var _alreadyPayTxt:FilterFrameText;
      
      private var _alreadyPayValue:FilterFrameText;
      
      private var _nextPrizeNeedTxt:FilterFrameText;
      
      private var _nextPrizeNeedValue:FilterFrameText;
      
      private var _getPrizeBtn:SimpleBitmapButton;
      
      private var _progressList:SimpleTileList;
      
      private var _progressArr:Array;
      
      private var _tip:OneLineTip;
      
      private var activityData:Dictionary;
      
      private var activityInitData:Dictionary;
      
      private var actId:String;
      
      private var accPayValue:int;
      
      private var giftCurInfoDic:Dictionary;
      
      private var giftData:Array;
      
      private var index:int;
      
      public function AccumulativePayView()
      {
         super();
      }
      
      public function init() : void
      {
         this.accPayValue = 0;
         this.index = -1;
         this._itemArr = [];
         this._progressArr = [];
         this._prizeArr = [];
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var item:AccumulativeItem = null;
         var progressLine:ScaleBitmapImage = null;
         var prizeItem:PrizeListItem = null;
         this._content = new Sprite();
         PositionUtils.setPos(this._content,"wonderful.Accumulative.ContentPos");
         this._bg = ComponentFactory.Instance.creat("wonderful.accumulative.BG");
         this._content.addChild(this._bg);
         this._title = ComponentFactory.Instance.creat("wonderful.accumulative.title");
         this._content.addChild(this._title);
         this._shadowBG = ComponentFactory.Instance.creat("wonderful.accumulative.shadowBG");
         this._content.addChild(this._shadowBG);
         this._progressBack1 = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progressBack");
         PositionUtils.setPos(this._progressBack1,"wonderful.Accumulative.ProgressBackPos1");
         this._content.addChild(this._progressBack1);
         this._progressBack2 = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progressBack");
         PositionUtils.setPos(this._progressBack2,"wonderful.Accumulative.ProgressBackPos2");
         this._content.addChild(this._progressBack2);
         this._itemList = ComponentFactory.Instance.creatCustomObject("wonderful.Accumulative.SimpleTileList",[NUMBER]);
         for(i = 1; i <= LENGTH; i++)
         {
            item = new AccumulativeItem();
            item.buttonMode = true;
            item.initView(i);
            item.turnGray(true);
            item.box.addEventListener(MouseEvent.CLICK,this.__itemBoxClick);
            this._itemList.addChild(item);
            this._itemArr.push(item);
         }
         this._content.addChild(this._itemList);
         this._prizeBG = ComponentFactory.Instance.creat("wonderful.accumulative.prizeBG");
         this._content.addChild(this._prizeBG);
         this._alreadyPayTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.alreadyPayTxt");
         this._alreadyPayTxt.text = LanguageMgr.GetTranslation("wonderful.accumulative.alreadyPayTxt");
         this._content.addChild(this._alreadyPayTxt);
         this._alreadyPayValue = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.alreadyPayValue");
         this._alreadyPayValue.text = "0";
         this._content.addChild(this._alreadyPayValue);
         this._nextPrizeNeedTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.nextPrizeNeedTxt");
         this._nextPrizeNeedTxt.text = LanguageMgr.GetTranslation("wonderful.accumulative.nextPrizeNeedTxt");
         this._content.addChild(this._nextPrizeNeedTxt);
         this._nextPrizeNeedValue = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.nextPrizeNeedValue");
         this._nextPrizeNeedValue.text = "9999";
         this._content.addChild(this._nextPrizeNeedValue);
         this._getPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.getPrizeBtn");
         this._getPrizeBtn.enable = false;
         this._content.addChild(this._getPrizeBtn);
         this._progressList = ComponentFactory.Instance.creatCustomObject("wonderful.Accumulative.progressList",[NUMBER2]);
         for(var k:int = 1; k <= LENGTH2; k++)
         {
            progressLine = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progress2");
            progressLine.visible = false;
            progressLine.addEventListener(MouseEvent.ROLL_OVER,this.progressBackOver);
            progressLine.addEventListener(MouseEvent.MOUSE_MOVE,this.progressBackOver);
            progressLine.addEventListener(MouseEvent.ROLL_OUT,this.progressBackOut);
            this._progressList.addChild(progressLine);
            this._progressArr.push(progressLine);
         }
         this._content.addChild(this._progressList);
         this._prizeList = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.Hbox");
         for(var j:int = 1; j <= PRIZE_LEN; j++)
         {
            prizeItem = new PrizeListItem();
            prizeItem.initView(j);
            this._prizeList.addChild(prizeItem);
            this._prizeArr.push(prizeItem);
         }
         this._content.addChild(this._prizeList);
         this._prizeList.refreshChildPos();
         this._tip = new OneLineTip();
         this._tip.visible = false;
         this._content.addChild(this._tip);
         addChild(this._content);
      }
      
      private function initData() : void
      {
         var key:String = null;
         var selectableIndex:int = 0;
         if(!this.checkData())
         {
            return;
         }
         var giftArr:Array = this.activityData[this.actId].giftbagArray;
         for(var i:int = 0; i <= giftArr.length - 1; i++)
         {
            if(this.accPayValue >= giftArr[i].giftConditionArr[0].conditionValue)
            {
               (this._itemArr[i] as AccumulativeItem).turnGray(false);
               (this._itemArr[i] as AccumulativeItem).glint(true);
               (this._itemArr[i] as AccumulativeItem).setNumber(giftArr[i].giftConditionArr[0].conditionValue);
               (this._itemArr[i] as AccumulativeItem).lightProgressPoint();
               this.index = i;
            }
         }
         var lastGetIndex:int = -1;
         for(var j:int = 0; j <= this.index; j++)
         {
            key = giftArr[j].giftbagId;
            if(this.giftCurInfoDic[key].times > 0)
            {
               (this._itemArr[j] as AccumulativeItem).glint(false);
            }
            else
            {
               lastGetIndex = j;
               this._getPrizeBtn.enable = true;
            }
         }
         if(lastGetIndex >= 0)
         {
            (this._itemArr[lastGetIndex] as AccumulativeItem).turnLight(true);
            this.showGift(lastGetIndex);
         }
         else
         {
            selectableIndex = this.index + 1 <= this._itemArr.length - 1 ? this.index + 1 : this.index;
            (this._itemArr[selectableIndex] as AccumulativeItem).turnLight(true);
            this.showGift(selectableIndex);
         }
         if(this.index + 1 <= giftArr.length - 1)
         {
            (this._itemArr[this.index + 1] as AccumulativeItem).setNumber(giftArr[this.index + 1].giftConditionArr[0].conditionValue);
            this._nextPrizeNeedValue.text = (giftArr[this.index + 1].giftConditionArr[0].conditionValue - this.accPayValue).toString();
         }
         else
         {
            this._nextPrizeNeedValue.text = "0";
         }
         this._alreadyPayValue.text = this.accPayValue.toString();
         this.showProgress(this.index);
         this._tip.tipData = this.accPayValue.toString();
      }
      
      private function checkData() : Boolean
      {
         var data:GmActivityInfo = null;
         this.activityData = WonderfulActivityManager.Instance.activityData;
         this.activityInitData = WonderfulActivityManager.Instance.activityInitData;
         for each(data in this.activityData)
         {
            if(data.activityType == WonderfulActivityTypeData.MAIN_PAY_ACTIVITY && data.activityChildType == WonderfulActivityTypeData.ACCUMULATIVE_PAY)
            {
               this.actId = data.activityId;
               break;
            }
         }
         if(this.actId == null || this.activityData[this.actId] == null)
         {
            return false;
         }
         if(this.activityInitData[this.actId] != null)
         {
            this.accPayValue = this.activityInitData[this.actId].statusArr[0].statusValue;
            this.giftCurInfoDic = this.activityInitData[this.actId].giftInfoDic;
         }
         return true;
      }
      
      private function initEvent() : void
      {
         this._getPrizeBtn.addEventListener(MouseEvent.CLICK,this.__GetPrizeBtnClick);
      }
      
      private function progressBackOver(event:MouseEvent) : void
      {
         this._tip.visible = true;
         this._tip.x = this._content.mouseX;
         this._tip.y = this._content.mouseY;
      }
      
      private function progressBackOut(event:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      private function showProgress(num:int) : void
      {
         var value:int = 0;
         var nextValue:int = 0;
         var pencent:Number = NaN;
         if(num < 0)
         {
            return;
         }
         var tmp:int = -1;
         for(var i:int = 0; i <= num; i++)
         {
            tmp++;
            if(i == 4 || i == 9)
            {
               tmp--;
            }
            this._progressArr[tmp].visible = true;
         }
         var arr:Array = this.activityData[this.actId].giftbagArray;
         if(num == 4 || num == 9 || num + 1 >= arr.length || tmp <= 0)
         {
            return;
         }
         value = int(arr[num].giftConditionArr[0].conditionValue);
         nextValue = int(arr[num + 1].giftConditionArr[0].conditionValue);
         pencent = (this.accPayValue - value) / (nextValue - value);
         (this._progressArr[tmp] as ScaleBitmapImage).scaleX = pencent;
      }
      
      private function showGift(num:int) : void
      {
         var gift:GiftRewardInfo = null;
         if(num < 0 || num > this.activityData[this.actId].giftbagArray.length - 1)
         {
            return;
         }
         var vec:Vector.<GiftRewardInfo> = this.activityData[this.actId].giftbagArray[num].giftRewardArr;
         this.clearPrizeArr();
         for(var i:int = 0; i <= vec.length - 1; i++)
         {
            gift = vec[i] as GiftRewardInfo;
            this._prizeArr[i].setCellData(gift);
         }
      }
      
      private function clearPrizeArr() : void
      {
         var item:PrizeListItem = null;
         for each(item in this._prizeArr)
         {
            item.setCellData(null);
         }
      }
      
      private function __GetPrizeBtnClick(event:MouseEvent) : void
      {
         var getAwardInfo:SendGiftInfo = new SendGiftInfo();
         getAwardInfo.activityId = this.actId;
         var bagArr:Array = this.activityData[this.actId].giftbagArray;
         var tmpArr:Array = [];
         for(var i:int = 0; i <= bagArr.length - 1; i++)
         {
            tmpArr.push(bagArr[i].giftbagId);
         }
         getAwardInfo.giftIdArr = tmpArr;
         var data:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         data.push(getAwardInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(data);
         for(var j:int = 0; j <= this.index; j++)
         {
            this._itemArr[j].glint(false);
         }
         this._getPrizeBtn.enable = false;
      }
      
      private function __itemBoxClick(event:MouseEvent) : void
      {
         var i:int = 0;
         var item:AccumulativeItem = event.target.parent as AccumulativeItem;
         var selectableIndex:int = this.index + 1 < this._itemArr.length ? this.index + 1 : this.index;
         if(item.index - 1 <= selectableIndex)
         {
            for(i = 0; i <= selectableIndex; i++)
            {
               (this._itemArr[i] as AccumulativeItem).turnLight(false);
            }
            item.turnLight(true);
            this.showGift(item.index - 1);
         }
      }
      
      private function removeEvents() : void
      {
         this._getPrizeBtn.removeEventListener(MouseEvent.CLICK,this.__GetPrizeBtnClick);
         for(var i:int = 0; i <= this._itemArr.length - 1; i++)
         {
            this._itemArr[i].box.removeEventListener(MouseEvent.CLICK,this.__itemBoxClick);
         }
         for(var j:int = 0; j <= this._progressArr.length - 1; j++)
         {
            this._progressArr[j].removeEventListener(MouseEvent.ROLL_OVER,this.progressBackOver);
            this._progressArr[j].removeEventListener(MouseEvent.MOUSE_MOVE,this.progressBackOver);
            this._progressArr[j].removeEventListener(MouseEvent.ROLL_OUT,this.progressBackOut);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._shadowBG))
         {
            ObjectUtils.disposeObject(this._shadowBG);
         }
         this._shadowBG = null;
         if(Boolean(this._progressBack1))
         {
            ObjectUtils.disposeObject(this._progressBack1);
         }
         this._progressBack1 = null;
         if(Boolean(this._progressBack2))
         {
            ObjectUtils.disposeObject(this._progressBack2);
         }
         this._progressBack2 = null;
         if(Boolean(this._prizeBG))
         {
            ObjectUtils.disposeObject(this._prizeBG);
         }
         this._prizeBG = null;
         if(Boolean(this._alreadyPayTxt))
         {
            ObjectUtils.disposeObject(this._alreadyPayTxt);
         }
         this._alreadyPayTxt = null;
         if(Boolean(this._alreadyPayValue))
         {
            ObjectUtils.disposeObject(this._alreadyPayValue);
         }
         this._alreadyPayValue = null;
         if(Boolean(this._nextPrizeNeedTxt))
         {
            ObjectUtils.disposeObject(this._nextPrizeNeedTxt);
         }
         this._nextPrizeNeedTxt = null;
         if(Boolean(this._nextPrizeNeedValue))
         {
            ObjectUtils.disposeObject(this._nextPrizeNeedValue);
         }
         this._nextPrizeNeedValue = null;
         if(Boolean(this._getPrizeBtn))
         {
            ObjectUtils.disposeObject(this._getPrizeBtn);
         }
         this._getPrizeBtn = null;
         if(Boolean(this._itemList))
         {
            ObjectUtils.disposeObject(this._itemList);
         }
         this._itemList = null;
         if(Boolean(this._prizeList))
         {
            ObjectUtils.disposeObject(this._prizeList);
         }
         this._prizeList = null;
         for(var i:int = 0; i <= this._itemArr.length - 1; i++)
         {
            if(Boolean(this._itemArr[i]))
            {
               ObjectUtils.disposeObject(this._itemArr[i]);
            }
            this._itemArr[i] = null;
         }
         if(Boolean(this._progressList))
         {
            ObjectUtils.disposeObject(this._progressList);
         }
         this._progressList = null;
         for(var j:int = 0; j <= this._progressArr.length - 1; j++)
         {
            if(Boolean(this._progressArr[j]))
            {
               ObjectUtils.disposeObject(this._progressArr[j]);
            }
            this._progressArr[j] = null;
         }
         for(var k:int = 0; k <= this._prizeArr.length - 1; k++)
         {
            if(Boolean(this._prizeArr[k]))
            {
               ObjectUtils.disposeObject(this._prizeArr[k]);
            }
            this._prizeArr[k] = null;
         }
         if(Boolean(this._tip))
         {
            ObjectUtils.disposeObject(this._tip);
         }
         this._tip = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

