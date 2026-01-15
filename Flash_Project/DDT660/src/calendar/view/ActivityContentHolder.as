package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ActivityContentHolder extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _contentArea:TextArea;
      
      public function ActivityContentHolder()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityContentBg");
         addChild(this._back);
      }
      
      override public function get height() : Number
      {
         return this._back.height;
      }
      
      public function setContent(info:ActiveEventsInfo) : void
      {
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._contentArea);
         this._contentArea = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

