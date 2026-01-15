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
   import road7th.utils.DateUtils;
   import wonderfulActivity.event.ActivityEvent;
   
   public class NationalDayView extends Sprite implements ICalendar
   {
      
      private var _bg:Bitmap;
      
      private var _activityTime:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _activityInfo:ActiveEventsInfo;
      
      private var _goodsExchangeInfoVector:Vector.<GoodsExchangeInfo>;
      
      private var _cellVector:Vector.<ActivitySeedCell>;
      
      private var _haveGoodsBox1:SimpleTileList;
      
      private var _haveGoodsBox2:SimpleTileList;
      
      private var _haveGoodsBox3:SimpleTileList;
      
      private var _haveGoodsBox:Vector.<SimpleTileList>;
      
      private var _exchangeCellVec:Vector.<ActivitySeedCell>;
      
      public function NationalDayView()
      {
         super();
         this.initview();
      }
      
      private function initview() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activity.nationalbg");
         addChild(this._bg);
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.actTime");
         PositionUtils.setPos(this._activityTime,"ddtcalendar.nationalDayView.timePos");
         addChild(this._activityTime);
         this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.description");
         PositionUtils.setPos(this._description,"ddtcalendar.nationalDayView.description");
         addChild(this._description);
         this._haveGoodsBox1 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox1",[4]);
         addChild(this._haveGoodsBox1);
         this._haveGoodsBox2 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox2",[4]);
         addChild(this._haveGoodsBox2);
         this._haveGoodsBox3 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox3",[4]);
         addChild(this._haveGoodsBox3);
         this._haveGoodsBox = new Vector.<SimpleTileList>();
         this._haveGoodsBox.push(this._haveGoodsBox1);
         this._haveGoodsBox.push(this._haveGoodsBox2);
         this._haveGoodsBox.push(this._haveGoodsBox3);
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
         var id:int = 0;
         var num:int = 4;
         var length:int = int(this._cellVector.length);
         var getAwardFlag:Boolean = true;
         for(var i:int = 0; i < length; i++)
         {
            if(i == 0 || i == 4 || i == 12)
            {
               num += i;
               getAwardFlag = true;
            }
            if(this._cellVector[i].needCount < 0)
            {
               getAwardFlag = false;
            }
            else if(i % num == 3 && getAwardFlag)
            {
               id = i < 4 ? 0 : (i < 12 ? 1 : 2);
               this._exchangeCellVec[id].addFireworkAnimation(id);
               this._exchangeCellVec[id].addEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            }
         }
      }
      
      private function __updateCellCount(event:ActivityEvent) : void
      {
         this.setGetAwardBtnEnable(event.id);
      }
      
      private function setGetAwardBtnEnable(idNum:int) : void
      {
         var id:int = 0;
         if(this._cellVector[idNum].needCount < 0)
         {
            id = idNum < 4 ? 0 : (idNum < 12 ? 1 : 2);
            this._exchangeCellVec[id].removeFireworkAnimation();
            this._exchangeCellVec[id].removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
         }
      }
      
      protected function __seedGood(event:ActivityEvent) : void
      {
         var sendGoodsExchangeInfo:SendGoodsExchangeInfo = null;
         var id:int = event.id;
         var start:int = 0;
         var length:int = 0;
         if(id == 0)
         {
            start = 0;
            length = 4;
         }
         else if(id == 1)
         {
            start = 4;
            length = 12;
         }
         else
         {
            start = 12;
            length = 24;
         }
         var sendGoodsExchangeInfos:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         for(var i:int = start; i < length; i++)
         {
            sendGoodsExchangeInfo = new SendGoodsExchangeInfo();
            sendGoodsExchangeInfo.id = this._cellVector[i].info.TemplateID;
            sendGoodsExchangeInfo.place = this._cellVector[i].itemInfo.Place;
            sendGoodsExchangeInfo.bagType = this._cellVector[i].itemInfo.BagType;
            sendGoodsExchangeInfos.push(sendGoodsExchangeInfo);
         }
         SocketManager.Instance.out.sendGoodsExchange(sendGoodsExchangeInfos,this._activityInfo.ActiveID,1,id);
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
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var j:int = 0; j < 3; j++)
         {
            this._haveGoodsBox[j].disposeAllChildren();
            ObjectUtils.removeChildAllChildren(this._haveGoodsBox[j]);
            for(i = 0; i < count; i++)
            {
               if(this._goodsExchangeInfoVector[i].ItemType == j * 2)
               {
                  cell = new ActivitySeedCell(this._goodsExchangeInfoVector[i],this._activityInfo.ActiveType,this._cellVector.length);
                  this._haveGoodsBox[j].addChild(cell);
                  cell.addEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
                  tempCount += 1;
                  this._cellVector.push(cell);
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
         var count:int = int(this._goodsExchangeInfoVector.length);
         var tempCount:int = 0;
         for(var j:int = 0; j < 5; j++)
         {
            for(i = 0; i < count; i++)
            {
               if(this._goodsExchangeInfoVector[i].ItemType == j * 2 + 1)
               {
                  this.setFireworkTemplateID(this._goodsExchangeInfoVector[i]);
                  exchangeCell = new ActivitySeedCell(this._goodsExchangeInfoVector[i],this._activityInfo.ActiveType,this._exchangeCellVec.length,false);
                  addChild(exchangeCell);
                  this._exchangeCellVec.push(exchangeCell);
                  PositionUtils.setPos(exchangeCell,"ddtcalendar.nationalDayView.fireworkPos" + this._exchangeCellVec.length);
                  tempCount += 1;
               }
            }
         }
      }
      
      private function setFireworkTemplateID(info:GoodsExchangeInfo) : void
      {
         if(info.TemplateID > 112333 && info.TemplateID < 112337)
         {
            info.TemplateID -= 100616;
         }
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
      
      private function updateTimeShow() : void
      {
         var startDate:Date = DateUtils.getDateByStr(this._activityInfo.StartDate);
         var endDate:Date = DateUtils.getDateByStr(this._activityInfo.EndDate);
         this._activityTime.text = this.addZero(startDate.fullYear) + "." + this.addZero(startDate.month + 1) + "." + this.addZero(startDate.date);
         this._activityTime.text += "-" + this.addZero(endDate.fullYear) + "." + this.addZero(endDate.month + 1) + "." + this.addZero(endDate.date);
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
         for(var i:int = 0; i < this._haveGoodsBox.length; i++)
         {
            this._haveGoodsBox[i].dispose();
            this._haveGoodsBox[i] = null;
         }
         this._haveGoodsBox.length = 0;
         this._haveGoodsBox = null;
      }
   }
}

