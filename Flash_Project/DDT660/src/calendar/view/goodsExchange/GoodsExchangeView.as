package calendar.view.goodsExchange
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import road7th.utils.DateUtils;
   
   public class GoodsExchangeView extends Sprite implements Disposeable
   {
      
      private static var HAVE_GOODS_CELL_COUNT:int = 8;
      
      private static var EXCHANGE_GOODS_CELL_COUNT:int = 6;
      
      private var _time:Bitmap;
      
      private var _actTimeText:FilterFrameText;
      
      private var _actTime:FilterFrameText;
      
      private var _haveImg:Bitmap;
      
      private var _haveGoodsExplain:FilterFrameText;
      
      private var _haveGoodsBox:SimpleTileList;
      
      private var _line:Bitmap;
      
      private var _exchangImg:Bitmap;
      
      private var _exchangGoodsExplain:FilterFrameText;
      
      private var _exchangGoodsCountText:FilterFrameText;
      
      private var _exchangGoodsCount:FilterFrameText;
      
      private var _awardBtnGroup:SelectedButtonGroup;
      
      private var _awardBtn1:SelectedButton;
      
      private var _awardBtn2:SelectedButton;
      
      private var _awardBtn3:SelectedButton;
      
      private var _awardBtn4:SelectedButton;
      
      private var _exchangGoodsBox:SimpleTileList;
      
      private var _awardBg1:MutipleImage;
      
      private var _awardBg2:Scale9CornerImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _goodsExchangeInfoVector:Vector.<GoodsExchangeInfo>;
      
      private var _count:int = 1;
      
      private var _haveGoodsCount:int;
      
      private var _activeEventsInfo:ActiveEventsInfo;
      
      private var _awardIndex:int = 0;
      
      private var _cellVector:Vector.<GoodsExchangeCell>;
      
      private var _ifNoneGoods:Boolean;
      
      public function GoodsExchangeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.showTime();
         this.haveGoods();
         this.exchangGoods();
      }
      
      private function showTime() : void
      {
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         PositionUtils.setPos(this._time,"ddtcalendar.GoodsExchangeView.timeImgPos");
         addChild(this._time);
         this._actTimeText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTimeText");
         this._actTimeText.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.actTimeText");
         addChild(this._actTimeText);
         this._actTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTime");
         addChild(this._actTime);
      }
      
      private function haveGoods() : void
      {
         this._haveImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
         PositionUtils.setPos(this._haveImg,"ddtcalendar.GoodsExchangeView.HaveImgPos");
         this._haveGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoodsExplain");
         this._haveGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.haveGoodsExplainText");
         addChild(this._haveGoodsExplain);
         this._haveGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.haveGoodsBox",[4]);
         addChild(this._haveGoodsBox);
         this._line = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(this._line,"ddtcalendar.exchange.LinePos");
         addChild(this._line);
      }
      
      private function exchangGoods() : void
      {
         this._awardBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBack");
         addChild(this._awardBg1);
         this._awardBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardScoreBg");
         addChild(this._awardBg2);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.TextFieldBg");
         addChild(this._textBg);
         this._exchangImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         PositionUtils.setPos(this._exchangImg,"ddtcalendar.GoodsExchangeView.changeImgPos");
         addChild(this._exchangImg);
         this._exchangGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsExplain");
         this._exchangGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsExplainText");
         addChild(this._exchangGoodsExplain);
         this._exchangGoodsCountText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCountText");
         this._exchangGoodsCountText.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsCountText");
         addChild(this._exchangGoodsCountText);
         this._exchangGoodsCount = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCount");
         this._exchangGoodsCount.text = "1";
         this._exchangGoodsCount.restrict = "0-9";
         addChild(this._exchangGoodsCount);
         this._awardBtnGroup = new SelectedButtonGroup();
         this._awardBtn1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn1");
         addChild(this._awardBtn1);
         this._awardBtn2 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn2");
         addChild(this._awardBtn2);
         this._awardBtn3 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn3");
         addChild(this._awardBtn3);
         this._awardBtn4 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn4");
         addChild(this._awardBtn4);
         this._awardBtnGroup.addSelectItem(this._awardBtn1);
         this._awardBtnGroup.addSelectItem(this._awardBtn2);
         this._awardBtnGroup.addSelectItem(this._awardBtn3);
         this._awardBtnGroup.addSelectItem(this._awardBtn4);
         this._awardBtnGroup.selectIndex = 0;
         this._exchangGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.exchangeGoodsBox",[6]);
         addChild(this._exchangGoodsBox);
      }
      
      private function initEvent() : void
      {
         this._awardBtn1.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._awardBtn2.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._awardBtn3.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._awardBtn4.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._exchangGoodsCount.addEventListener(MouseEvent.CLICK,this.__countClickHandler);
         this._exchangGoodsCount.addEventListener(KeyboardEvent.KEY_DOWN,this.__countOnKeyDown);
         this._exchangGoodsCount.addEventListener(Event.CHANGE,this.__countChangeHandler);
      }
      
      private function __clickBtn(event:MouseEvent) : void
      {
         this._exchangGoodsCount.text = "1";
         this.count = 0;
         SoundManager.instance.play("008");
         this._awardIndex = this._awardBtnGroup.selectIndex;
      }
      
      private function __changeHandler(event:Event) : void
      {
         var index:int = this._awardBtnGroup.selectIndex;
         this._haveGoodsCount = 0;
         this.updateHaveGoodsBox(index);
         this.updateExchangeGoodsBox(index);
      }
      
      private function __countClickHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      private function __countOnKeyDown(event:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
      }
      
      private function __countChangeHandler(event:Event) : void
      {
         var temp:String = null;
         if(this._exchangGoodsCount.text == "")
         {
            this._exchangGoodsCount.text = "1";
         }
         else if(this._exchangGoodsCount.text != "0")
         {
            temp = this._exchangGoodsCount.text.substr(0,1);
            if(temp == "0")
            {
               this._exchangGoodsCount.text = this._exchangGoodsCount.text.substring(1);
            }
         }
         if(int(this._exchangGoodsCount.text) > this._haveGoodsCount)
         {
            if(this._haveGoodsCount == 0)
            {
               this._exchangGoodsCount.text = "1";
            }
            else
            {
               this._exchangGoodsCount.text = this._haveGoodsCount.toString();
            }
         }
         this.count = int(this._exchangGoodsCount.text);
      }
      
      public function setData(info:ActiveEventsInfo) : void
      {
         this._activeEventsInfo = info;
         this._goodsExchangeInfoVector = new Vector.<GoodsExchangeInfo>();
         var tempArray:Array = CalendarManager.getInstance().activeExchange;
         var count:int = int(tempArray.length);
         for(var i:int = 0; i < count; i++)
         {
            if(this._activeEventsInfo.ActiveID == tempArray[i].ActiveID)
            {
               this._goodsExchangeInfoVector.push(tempArray[i]);
            }
         }
         this.updateTimeShow();
         this.updateHaveGoodsBox(0);
         this.updateExchangeGoodsBox(0);
      }
      
      private function updateTimeShow() : void
      {
         var startDate:Date = DateUtils.getDateByStr(this._activeEventsInfo.StartDate);
         var endDate:Date = DateUtils.getDateByStr(this._activeEventsInfo.EndDate);
         this._actTime.text = this.addZero(startDate.fullYear) + "." + this.addZero(startDate.month + 1) + "." + this.addZero(startDate.date);
         this._actTime.text += "-" + this.addZero(endDate.fullYear) + "." + this.addZero(endDate.month + 1) + "." + this.addZero(endDate.date);
      }
      
      private function addZero(value:Number) : String
      {
         var result:String = null;
         if(value < 10)
         {
            result = "0" + value.toString();
         }
         else
         {
            result = value.toString();
         }
         return result;
      }
      
      private function updateHaveGoodsBox(index:int) : void
      {
         var cell:GoodsExchangeCell = null;
         var j:int = 0;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this._ifNoneGoods = false;
         this.cleanCell();
         this._haveGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._haveGoodsBox);
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var i:int = 0; i < count; i++)
         {
            if(this._goodsExchangeInfoVector[i].ItemType == index * 2)
            {
               this._goodsExchangeInfoVector[i].Num = this.count;
               cell = new GoodsExchangeCell(this._goodsExchangeInfoVector[i]);
               this.getLeastCount(cell);
               this._haveGoodsBox.addChild(cell);
               tempCount += 1;
               this._cellVector.push(cell);
            }
         }
         if(tempCount < HAVE_GOODS_CELL_COUNT)
         {
            for(j = tempCount; j < HAVE_GOODS_CELL_COUNT; j++)
            {
               this._haveGoodsBox.addChild(new GoodsExchangeCell(null));
            }
         }
         if(tempCount == 0)
         {
            this.getLeastCount(null);
            this._exchangGoodsCount.text = "0";
         }
         this.checkBtn();
      }
      
      private function updateExchangeGoodsBox(index:int) : void
      {
         var j:int = 0;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this._exchangGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._exchangGoodsBox);
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var i:int = 0; i < count; i++)
         {
            if(this._goodsExchangeInfoVector[i].ItemType == index * 2 + 1)
            {
               this._goodsExchangeInfoVector[i].Num = this.count;
               this._exchangGoodsBox.addChild(new GoodsExchangeCell(this._goodsExchangeInfoVector[i],this._activeEventsInfo.ActiveType,false));
               tempCount += 1;
            }
         }
         if(count < EXCHANGE_GOODS_CELL_COUNT)
         {
            for(j = tempCount; j < EXCHANGE_GOODS_CELL_COUNT; j++)
            {
               this._exchangGoodsBox.addChild(new GoodsExchangeCell(null));
            }
         }
      }
      
      private function cleanCell() : void
      {
         var cell:GoodsExchangeCell = null;
         for each(cell in this._cellVector)
         {
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._cellVector = new Vector.<GoodsExchangeCell>();
      }
      
      public function sendGoods() : void
      {
         var sendGoodsExchangeInfo:SendGoodsExchangeInfo = null;
         var boo:Boolean = false;
         var sendGoodsExchangeInfos:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         for(var i:int = 0; i < this._cellVector.length; i++)
         {
            sendGoodsExchangeInfo = new SendGoodsExchangeInfo();
            if(!this._cellVector[i].info || !this._cellVector[i].itemInfo)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warningIII"));
               return;
            }
            sendGoodsExchangeInfo.id = this._cellVector[i].info.TemplateID;
            sendGoodsExchangeInfo.place = this._cellVector[i].itemInfo.Place;
            sendGoodsExchangeInfo.bagType = this._cellVector[i].itemInfo.BagType;
            sendGoodsExchangeInfos.push(sendGoodsExchangeInfo);
            if(this._cellVector[i].needCount - this.count <= 0)
            {
               boo = true;
            }
         }
         this._exchangGoodsCount.text = "1";
         SocketManager.Instance.out.sendGoodsExchange(sendGoodsExchangeInfos,this._activeEventsInfo.ActiveID,this.count,this._awardIndex);
         this._count = 1;
         if(boo)
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,false));
         }
      }
      
      private function getLeastCount(cell:GoodsExchangeCell) : void
      {
         if(cell == null)
         {
            this._haveGoodsCount = 0;
            if(this._count != 0)
            {
               this._count = 0;
            }
            return;
         }
         var itemCount:int = cell.needCount;
         if(this._ifNoneGoods == true)
         {
            return;
         }
         if(itemCount == 0)
         {
            this._ifNoneGoods = true;
            this._haveGoodsCount = 0;
         }
         else if(this._haveGoodsCount == 0)
         {
            this._haveGoodsCount = itemCount;
         }
         else
         {
            this._haveGoodsCount = this._haveGoodsCount > itemCount ? itemCount : this._haveGoodsCount;
         }
      }
      
      private function get count() : int
      {
         return this._count;
      }
      
      private function set count(value:int) : void
      {
         this._count = value == 0 ? 1 : value;
         this.__changeHandler(null);
      }
      
      private function checkBtn() : void
      {
         if(this._haveGoodsCount == 0 || this._exchangGoodsCount.text == "0")
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,false));
         }
         else
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,true));
         }
      }
      
      private function removeView() : void
      {
         if(Boolean(this._time))
         {
            ObjectUtils.disposeObject(this._time);
            this._time = null;
         }
         if(Boolean(this._actTimeText))
         {
            ObjectUtils.disposeObject(this._actTimeText);
            this._actTimeText = null;
         }
         if(Boolean(this._actTime))
         {
            ObjectUtils.disposeObject(this._actTime);
            this._actTime = null;
         }
         if(Boolean(this._haveImg))
         {
            ObjectUtils.disposeObject(this._haveImg);
            this._haveImg = null;
         }
         if(Boolean(this._haveGoodsExplain))
         {
            ObjectUtils.disposeObject(this._haveGoodsExplain);
            this._haveGoodsExplain = null;
         }
         if(Boolean(this._haveGoodsBox))
         {
            ObjectUtils.disposeObject(this._haveGoodsBox);
            this._haveGoodsBox = null;
         }
         if(Boolean(this._line))
         {
            ObjectUtils.disposeObject(this._line);
            this._line = null;
         }
         if(Boolean(this._exchangImg))
         {
            ObjectUtils.disposeObject(this._exchangImg);
            this._exchangImg = null;
         }
         if(Boolean(this._exchangGoodsExplain))
         {
            ObjectUtils.disposeObject(this._exchangGoodsExplain);
            this._exchangGoodsExplain = null;
         }
         if(Boolean(this._exchangGoodsCountText))
         {
            ObjectUtils.disposeObject(this._exchangGoodsCountText);
            this._exchangGoodsCountText = null;
         }
         if(Boolean(this._exchangGoodsBox))
         {
            ObjectUtils.disposeObject(this._exchangGoodsBox);
            this._exchangGoodsBox = null;
         }
         if(Boolean(this._awardBg1))
         {
            ObjectUtils.disposeObject(this._awardBg1);
            this._awardBg1 = null;
         }
         if(Boolean(this._awardBg2))
         {
            ObjectUtils.disposeObject(this._awardBg2);
            this._awardBg2 = null;
         }
         if(Boolean(this._awardBtn1))
         {
            ObjectUtils.disposeObject(this._awardBtn1);
            this._awardBtn1 = null;
         }
         if(Boolean(this._awardBtn2))
         {
            ObjectUtils.disposeObject(this._awardBtn2);
            this._awardBtn2 = null;
         }
         if(Boolean(this._awardBtn3))
         {
            ObjectUtils.disposeObject(this._awardBtn3);
            this._awardBtn3 = null;
         }
         if(Boolean(this._awardBtn4))
         {
            ObjectUtils.disposeObject(this._awardBtn4);
            this._awardBtn4 = null;
         }
         if(Boolean(this._textBg))
         {
            ObjectUtils.disposeObject(this._textBg);
            this._textBg = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._awardBtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         if(Boolean(this._awardBtn1))
         {
            this._awardBtn1.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         if(Boolean(this._awardBtn2))
         {
            this._awardBtn2.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         if(Boolean(this._awardBtn3))
         {
            this._awardBtn3.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         if(Boolean(this._awardBtn4))
         {
            this._awardBtn4.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         this._exchangGoodsCount.removeEventListener(MouseEvent.CLICK,this.__countClickHandler);
         this._exchangGoodsCount.removeEventListener(KeyboardEvent.KEY_DOWN,this.__countOnKeyDown);
         this._exchangGoodsCount.removeEventListener(Event.CHANGE,this.__countChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

