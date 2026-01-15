package calendar.view
{
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class CalendarGrid extends Sprite implements Disposeable
   {
      
      private var _dayCells:Vector.<DayCell> = new Vector.<DayCell>();
      
      private var _model:CalendarModel;
      
      private var _monthField:FilterFrameText;
      
      private var _enMonthField:FilterFrameText;
      
      private var _dateField:FilterFrameText;
      
      private var _todyField:FilterFrameText;
      
      private var _back:DisplayObject;
      
      private var _front:DisplayObject;
      
      private var _backGrid:Shape;
      
      private var _title:DisplayObject;
      
      private var _vipBtn:BaseButton;
      
      private var _enYearField:FilterFrameText;
      
      private var _signField:FilterFrameText;
      
      private var _signFieldNumber:FilterFrameText;
      
      public function CalendarGrid(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         var topLeft:Point = null;
         var i:int = 0;
         var date:Date = null;
         var cell:DayCell = null;
         this._back = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarBackBg");
         addChild(this._back);
         this._title = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.CalendarGridTitleBg");
         addChild(this._title);
         var today:Date = this._model.today;
         this._monthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.NumMonthField");
         this._monthField.text = String(today.month + 1);
         addChild(this._monthField);
         this._enMonthField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.EnMonthField");
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + today.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         addChild(this._enMonthField);
         this._enYearField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.EnYearField");
         this._enYearField.text = today.fullYear + "";
         addChild(this._enYearField);
         this._todyField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.TodayField");
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",today.fullYear,today.month + 1,today.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + today.day);
         addChild(this._todyField);
         this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("vipView.OpenBtn");
         this._signField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.SignField");
         this._signField.text = LanguageMgr.GetTranslation("tank.calendar.grid.Sign",CalendarManager.getInstance().price);
         addChild(this._signField);
         this._signFieldNumber = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.SignFieldNumber");
         this._signFieldNumber.text = LanguageMgr.GetTranslation("tank.calendar.grid.signFieldNumber",CalendarManager.getInstance().price);
         addChild(this._signFieldNumber);
         topLeft = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarGrid.TopLeft");
         var last:Date = new Date();
         last.time = today.time;
         last.setDate(1);
         if(last.day != 0)
         {
            if(last.month > 0)
            {
               last.setMonth(today.month - 1,CalendarModel.getMonthMaxDay(today.month - 1,today.fullYear) - last.day + 1);
            }
            else
            {
               last.setFullYear(today.fullYear - 1,11,31 - last.day + 1);
            }
         }
         for(i = 0; i < 42; i++)
         {
            date = new Date();
            date.time = last.time + i * CalendarModel.MS_of_Day;
            cell = new DayCell(date,this._model);
            cell.x = topLeft.x + i % 7 * 57;
            cell.y = topLeft.y + Math.floor(i / 7) * 26;
            addChild(cell);
            this._dayCells.push(cell);
         }
      }
      
      private function drawLayer() : void
      {
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
         this._vipBtn.addEventListener(MouseEvent.CLICK,this.__getVip);
      }
      
      private function __getVip(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function __signCountChanged(event:Event) : void
      {
         var len:int = int(this._dayCells.length);
         for(var i:int = 0; i < len; i++)
         {
            this._dayCells[i].signed = this._model.hasSigned(this._dayCells[i].date);
         }
      }
      
      private function __todayChanged(event:Event) : void
      {
         var date:Date = null;
         var today:Date = this._model.today;
         this._monthField.text = String(today.month + 1);
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + today.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",today.fullYear,today.month + 1,today.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + today.day);
         var last:Date = new Date();
         last.time = today.time;
         last.setDate(1);
         if(last.day != 0)
         {
            if(last.month > 0)
            {
               last.setMonth(today.month - 1,CalendarModel.getMonthMaxDay(today.month - 1,today.fullYear) - last.day + 1);
            }
            else
            {
               last.setUTCFullYear(today.fullYear - 1,11,31 - last.day + 1);
            }
         }
         var len:int = int(this._dayCells.length);
         for(var i:int = 0; i < len; i++)
         {
            date = new Date();
            date.time = last.time + i * CalendarModel.MS_of_Day;
            this._dayCells[i].date = date;
            this._dayCells[i].signed = this._model.hasSigned(this._dayCells[i].date);
         }
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._backGrid);
         this._backGrid = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._monthField);
         this._monthField = null;
         ObjectUtils.disposeObject(this._enMonthField);
         this._enMonthField = null;
         ObjectUtils.disposeObject(this._todyField);
         this._todyField = null;
         ObjectUtils.disposeObject(this._enYearField);
         this._enYearField = null;
         var daycell:DayCell = this._dayCells.shift();
         while(daycell != null)
         {
            ObjectUtils.disposeObject(daycell);
            daycell = this._dayCells.shift();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

