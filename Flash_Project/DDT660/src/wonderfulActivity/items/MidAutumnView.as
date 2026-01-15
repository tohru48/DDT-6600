package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import calendar.view.ICalendar;
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import calendar.view.goodsExchange.SendGoodsExchangeInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import road7th.utils.DateUtils;
   import wonderfulActivity.event.ActivityEvent;
   
   public class MidAutumnView extends Sprite implements ICalendar
   {
      
      private static var HAVE_GOODS_CELL_COUNT:int = 20;
      
      private static var EXCHANGE_GOODS_CELL_COUNT:int = 5;
      
      private var _activityInfo:ActiveEventsInfo;
      
      private var _goodsExchangeInfoVector:Vector.<GoodsExchangeInfo>;
      
      private var _cellVector:Vector.<ActivitySeedCell>;
      
      private var _exchangeCellVec:Vector.<ActivitySeedCell>;
      
      private var _bg:Bitmap;
      
      private var _activityTime:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _haveGoodsBox:SimpleTileList;
      
      private var _exchangeGoodsBox:SimpleTileList;
      
      private var _getAwardFlag:Boolean = true;
      
      public function MidAutumnView()
      {
         super();
         this.initview();
      }
      
      private function initview() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activity.midautumnbg");
         addChild(this._bg);
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.actTime");
         addChild(this._activityTime);
         this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.description");
         PositionUtils.setPos(this._description,"ddtcalendar.midAutumnView.description");
         addChild(this._description);
         this._haveGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.midAutumnView.haveGoodsBox",[4]);
         addChild(this._haveGoodsBox);
         this._exchangeGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.midAutumnView.exchangeGoodsBox",[1]);
         addChild(this._exchangeGoodsBox);
      }
      
      public function setData(val:* = null) : void
      {
         var tempArray:Array = null;
         var count:int = 0;
         var i:int = 0;
         this._activityInfo = val as ActiveEventsInfo;
         if(Boolean(this._activityInfo))
         {
            this._goodsExchangeInfoVector = new Vector.<GoodsExchangeInfo>();
            tempArray = CalendarManager.getInstance().activeExchange;
            count = int(tempArray.length);
            for(i = 0; i < count; i++)
            {
               if(this._activityInfo.ActiveID == tempArray[i].ActiveID)
               {
                  this._goodsExchangeInfoVector.push(tempArray[i]);
               }
            }
            this.updateTimeShow();
            this.updateDescription();
            this.updateHaveGoodsBox();
            this.updateExchangeGoodsBox();
            this.addAwardAnimation();
         }
      }
      
      private function updateDescription() : void
      {
         this._description.text = this._activityInfo.Description;
      }
      
      private function addAwardAnimation() : void
      {
         var length:int = int(this._cellVector.length);
         for(var i:int = 0; i < length; i++)
         {
            if(i % 4 == 0)
            {
               this._getAwardFlag = true;
            }
            if(this._cellVector[i].needCount < 0)
            {
               this._getAwardFlag = false;
               this._cellVector[i].addSeedBtn();
            }
            else if(i % 4 == 3 && this._getAwardFlag)
            {
               this._exchangeCellVec[int(i / 4)].addAwardAnimation();
               this._exchangeCellVec[int(i / 4)].addEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            }
         }
      }
      
      private function __updateCellCount(event:ActivityEvent) : void
      {
         this.setGetAwardBtnEnable(event.id);
      }
      
      private function setGetAwardBtnEnable(idNum:int) : void
      {
         if(this._cellVector[idNum].needCount < 0)
         {
            setTimeout(this.removeAnimation,2500,idNum);
         }
      }
      
      private function removeAnimation(idNum:int) : void
      {
         this._cellVector[idNum].addSeedBtn();
         var id:int = int(idNum / 4);
         this._exchangeCellVec[id].removeFireworkAnimation();
         this._exchangeCellVec[id].removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
      }
      
      protected function __seedGood(event:ActivityEvent) : void
      {
         var sendGoodsExchangeInfo:SendGoodsExchangeInfo = null;
         var id:int = event.id;
         var sendGoodsExchangeInfos:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         var length:int = id * 4 + 4;
         for(var i:int = id * 4; i < length; i++)
         {
            sendGoodsExchangeInfo = new SendGoodsExchangeInfo();
            sendGoodsExchangeInfo.id = this._cellVector[i].info.TemplateID;
            if(!this._cellVector[i].itemInfo)
            {
               return;
            }
            sendGoodsExchangeInfo.place = this._cellVector[i].itemInfo.Place;
            sendGoodsExchangeInfo.bagType = this._cellVector[i].itemInfo.BagType;
            sendGoodsExchangeInfos.push(sendGoodsExchangeInfo);
         }
         SocketManager.Instance.out.sendGoodsExchange(sendGoodsExchangeInfos,this._activityInfo.ActiveID,1,id);
      }
      
      private function updateTimeShow() : void
      {
         var startDate:Date = DateUtils.getDateByStr(this._activityInfo.StartDate);
         var endDate:Date = DateUtils.getDateByStr(this._activityInfo.EndDate);
         this._activityTime.text = this.addZero(startDate.fullYear) + "." + this.addZero(startDate.month + 1) + "." + this.addZero(startDate.date);
         this._activityTime.text += "-" + this.addZero(endDate.fullYear) + "." + this.addZero(endDate.month + 1) + "." + this.addZero(endDate.date);
      }
      
      private function updateHaveGoodsBox() : void
      {
         var i:int = 0;
         var cell:ActivitySeedCell = null;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this.cleanCell();
         this._haveGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._haveGoodsBox);
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var j:int = 0; j < 5; j++)
         {
            for(i = 0; i < count; i++)
            {
               if(this._goodsExchangeInfoVector[i].ItemType == j * 2)
               {
                  cell = new ActivitySeedCell(this._goodsExchangeInfoVector[i],this._activityInfo.ActiveType,this._cellVector.length);
                  this._haveGoodsBox.addChild(cell);
                  cell.addEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
                  tempCount += 1;
                  this._cellVector.push(cell);
                  if(tempCount >= HAVE_GOODS_CELL_COUNT)
                  {
                     break;
                  }
               }
            }
         }
      }
      
      private function updateExchangeGoodsBox() : void
      {
         var i:int = 0;
         var exchangeCell:ActivitySeedCell = null;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this.cleanExchangeCell();
         this._exchangeGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._exchangeGoodsBox);
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var j:int = 0; j < 5; j++)
         {
            for(i = 0; i < count; i++)
            {
               if(this._goodsExchangeInfoVector[i].ItemType == j * 2 + 1)
               {
                  exchangeCell = new ActivitySeedCell(this._goodsExchangeInfoVector[i],this._activityInfo.ActiveType,this._exchangeCellVec.length,false);
                  this._exchangeGoodsBox.addChild(exchangeCell);
                  this._exchangeCellVec.push(exchangeCell);
                  tempCount += 1;
                  if(tempCount >= EXCHANGE_GOODS_CELL_COUNT)
                  {
                     break;
                  }
               }
            }
         }
      }
      
      private function cleanCell() : void
      {
         var cell:ActivitySeedCell = null;
         for each(cell in this._cellVector)
         {
            cell.removeEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._cellVector = new Vector.<ActivitySeedCell>();
      }
      
      private function cleanExchangeCell() : void
      {
         var cell:ActivitySeedCell = null;
         for each(cell in this._exchangeCellVec)
         {
            cell.removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._exchangeCellVec = new Vector.<ActivitySeedCell>();
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
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         this.cleanCell();
         this.cleanExchangeCell();
         if(Boolean(this._activityTime))
         {
            this._activityTime.dispose();
            this._activityTime = null;
         }
         if(Boolean(this._description))
         {
            this._description.dispose();
            this._description = null;
         }
         if(Boolean(this._haveGoodsBox))
         {
            this._haveGoodsBox.dispose();
            this._haveGoodsBox = null;
         }
         if(Boolean(this._exchangeGoodsBox))
         {
            this._exchangeGoodsBox.dispose();
            this._exchangeGoodsBox = null;
         }
      }
   }
}

