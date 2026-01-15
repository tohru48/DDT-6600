package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ActivityMenu extends Sprite implements Disposeable
   {
      
      public static const MENU_REFRESH:String = "activitymenu_refresh";
      
      private var _cells:Vector.<ActivityCell> = new Vector.<ActivityCell>();
      
      private var _model:CalendarModel;
      
      private var _contentHolder:ActivityContentHolder;
      
      private var _selectedItem:ActivityCell;
      
      public function ActivityMenu(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
      }
      
      private function cleanCells() : void
      {
         var cell:ActivityCell = this._cells.shift();
         while(cell != null)
         {
            ObjectUtils.disposeObject(cell);
            cell.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            cell = this._cells.shift();
         }
      }
      
      public function setActivityDate(date:Date) : void
      {
         var active:ActiveEventsInfo = null;
         var cell:ActivityCell = null;
         this.cleanCells();
         var len:int = int(this._model.eventActives.length);
         for(var i:int = 0; i < len; i++)
         {
            active = this._model.eventActives[i];
            if(this.isInValidDate(date,active,this.isAfterToday(date)))
            {
               if(!(this.isAfterToday(date) && !active.IsAdvance && !this.isActivityStartedAndInProgress(date,active)))
               {
                  cell = new ActivityCell(active);
                  cell.y = i * 54;
                  cell.addEventListener(MouseEvent.CLICK,this.__cellClick);
                  addChild(cell);
                  this._cells.push(cell);
               }
            }
         }
         if(this._cells.length > 0)
         {
            this.setSeletedItem(this._cells[0]);
            CalendarManager.getInstance().setState(this._cells[0].info);
            this._contentHolder.visible = true;
         }
         else if(date.time != this._model.today.time)
         {
            this._contentHolder.visible = false;
         }
         else
         {
            this._contentHolder.visible = false;
         }
      }
      
      private function isActivityStartedAndInProgress(date:Date, activity:ActiveEventsInfo) : Boolean
      {
         var now:Date = TimeManager.Instance.Now();
         var newDate:Date = new Date(date.fullYear,date.month,date.date,date.hours,date.minutes,date.seconds);
         var activityDate:Date = new Date(activity.start.fullYear,activity.start.month,activity.start.date,activity.start.hours,activity.start.minutes,activity.start.seconds);
         return now.time > activityDate.time && newDate.time > activityDate.time;
      }
      
      private function isInValidDate(date:Date, activeInfo:ActiveEventsInfo, ignoreConcreteTime:Boolean = false) : Boolean
      {
         var newDate:Date = null;
         var newActiveDateStart:Date = null;
         var newActiveDateEnd:Date = null;
         if(ignoreConcreteTime)
         {
            newDate = new Date(date.fullYear,date.month,date.date);
            newActiveDateStart = new Date(activeInfo.start.fullYear,activeInfo.start.month,activeInfo.start.date);
            newActiveDateEnd = new Date(activeInfo.end.fullYear,activeInfo.end.month,activeInfo.end.date);
         }
         else
         {
            newDate = new Date(date.fullYear,date.month,date.date,date.hours,date.minutes,date.seconds);
            newActiveDateStart = new Date(activeInfo.start.fullYear,activeInfo.start.month,activeInfo.start.date,activeInfo.start.hours,activeInfo.start.minutes,activeInfo.start.seconds);
            newActiveDateEnd = new Date(activeInfo.end.fullYear,activeInfo.end.month,activeInfo.end.date,activeInfo.end.hours,activeInfo.end.minutes,activeInfo.end.seconds);
         }
         if(newDate.time <= newActiveDateEnd.time && newDate.time >= newActiveDateStart.time)
         {
            return true;
         }
         return false;
      }
      
      private function isBeforeToday(date:Date) : Boolean
      {
         var newDate:Date = new Date(date.fullYear,date.month,date.date);
         return newDate <= TimeManager.Instance.Now();
      }
      
      private function isAfterToday(date:Date) : Boolean
      {
         var newDate:Date = new Date(date.fullYear,date.month,date.date);
         return newDate > TimeManager.Instance.Now();
      }
      
      private function configUI() : void
      {
         this._contentHolder = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityContentHolder");
      }
      
      public function setSeletedItem(item:ActivityCell) : void
      {
         var idx:int = 0;
         var len:int = 0;
         var i:int = 0;
         if(item != this._selectedItem)
         {
            if(Boolean(this._selectedItem))
            {
               this._selectedItem.selected = false;
            }
            this._selectedItem = item;
            this._selectedItem.selected = true;
            addChildAt(this._contentHolder,0);
            idx = int(this._cells.indexOf(this._selectedItem));
            len = int(this._cells.length);
            for(i = 0; i < len; i++)
            {
               if(i <= idx)
               {
                  this._cells[i].y = i * 54;
               }
               else
               {
                  this._cells[i].y = i * 54 + this._contentHolder.height - 53;
               }
            }
            this._contentHolder.y = this._selectedItem.y + 33;
            dispatchEvent(new Event(MENU_REFRESH));
         }
      }
      
      private function __cellClick(event:MouseEvent) : void
      {
         var item:ActivityCell = event.currentTarget as ActivityCell;
         this.setSeletedItem(item);
         CalendarManager.getInstance().setState(item.info);
         SoundManager.instance.play("008");
      }
      
      override public function get height() : Number
      {
         var h:int = 0;
         if(this._cells.length == 1)
         {
            h = this._contentHolder.y + this._contentHolder.height;
         }
         else if(this._cells.length > 0)
         {
            h = 53 * this._cells.length + this._contentHolder.height - 28;
         }
         return h;
      }
      
      public function showByQQ(activeID:int) : void
      {
         var cell:ActivityCell = null;
         for each(cell in this._cells)
         {
            if(cell.info.ActiveID == activeID)
            {
               cell.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               cell.openCell();
               this._contentHolder.visible = true;
               break;
            }
         }
      }
      
      public function dispose() : void
      {
         var cell:ActivityCell = this._cells.shift();
         while(cell != null)
         {
            ObjectUtils.disposeObject(cell);
            cell.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            cell = this._cells.shift();
         }
         ObjectUtils.disposeObject(this._contentHolder);
         this._contentHolder = null;
         this._selectedItem = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

