package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class CalendarState extends Sprite implements ICalendar
   {
      
      private var _calendarGrid:CalendarGrid;
      
      private var _awardBar:SignAwardBar;
      
      private var _model:CalendarModel;
      
      public function CalendarState(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._calendarGrid = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarGrid",[this._model]);
         addChild(this._calendarGrid);
         this._awardBar = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignAwardBar",[this._model]);
         addChild(this._awardBar);
      }
      
      public function setData(val:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._calendarGrid);
         this._calendarGrid = null;
         ObjectUtils.disposeObject(this._awardBar);
         this._awardBar = null;
         this._model = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

