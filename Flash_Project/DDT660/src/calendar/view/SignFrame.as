package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SignFrame extends Frame
   {
      
      private var _signCalendar:ICalendar;
      
      private var _model:CalendarModel;
      
      public function SignFrame(model:CalendarModel, data:* = null)
      {
         super();
         this.initView(model,data);
         this.addEvent();
      }
      
      private function initView(pData:*, data:*) : void
      {
         this._signCalendar = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarState",[pData]);
         addToContent(this._signCalendar as DisplayObject);
         if(Boolean(this._signCalendar))
         {
            this._signCalendar.setData(data);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      private function __response(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CalendarManager.getInstance().close();
               this.dispose();
         }
      }
      
      private function __getFocus(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._signCalendar);
         this._signCalendar = null;
         super.dispose();
      }
   }
}

