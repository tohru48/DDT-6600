package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ActivityList extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _list:ScrollPanel;
      
      private var _model:CalendarModel;
      
      private var _activityMenu:ActivityMenu;
      
      public function ActivityList(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityListBg");
         addChild(this._back);
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityList");
         addChild(this._list);
         this._activityMenu = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityMenu",[this._model]);
         this._list.setView(this._activityMenu);
      }
      
      private function addEvent() : void
      {
         this._activityMenu.addEventListener(ActivityMenu.MENU_REFRESH,this.menuItemClick);
      }
      
      private function removeEvent() : void
      {
         this._activityMenu.removeEventListener(ActivityMenu.MENU_REFRESH,this.menuItemClick);
      }
      
      private function menuItemClick(event:Event) : void
      {
         this._list.invalidateViewport();
      }
      
      public function setActivityDate(date:Date) : void
      {
         this._activityMenu.setActivityDate(date);
         this._list.invalidateViewport();
      }
      
      public function showByQQ(activeID:int) : void
      {
         this._activityMenu.showByQQ(activeID);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._activityMenu);
         this._activityMenu = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

