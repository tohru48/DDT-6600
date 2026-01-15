package activeEvents
{
   import activeEvents.data.ActiveEventsInfo;
   import activeEvents.view.ActiveMainFrame;
   import activeEvents.view.ActiveSubFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ActiveController extends EventDispatcher
   {
      
      private static var _instance:ActiveController;
      
      private var _activeMainFrame:ActiveMainFrame;
      
      private var _activeSubFrame:ActiveSubFrame;
      
      public function ActiveController()
      {
         super();
      }
      
      public static function get instance() : ActiveController
      {
         if(!_instance)
         {
            _instance = new ActiveController();
         }
         return _instance;
      }
      
      public function get actives() : Array
      {
         return ActiveEventsManager.Instance.model.actives;
      }
      
      public function set activeMainFrame(value:ActiveMainFrame) : void
      {
         this._activeMainFrame = value;
      }
      
      public function set activeSubFrame(value:ActiveSubFrame) : void
      {
         this._activeSubFrame = value;
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ACTIVE_EVENTS);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __activeProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      private function __activeComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ACTIVE_EVENTS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
            if(!this._activeMainFrame)
            {
               this._activeMainFrame = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeMainFrame");
               this._activeMainFrame.control = this;
               this._activeMainFrame.show();
            }
            else
            {
               this.closeAllFrame();
            }
         }
      }
      
      public function get isShowing() : Boolean
      {
         return this._activeMainFrame != null && this._activeMainFrame.parent != null;
      }
      
      public function closeAllFrame() : void
      {
         if(Boolean(this._activeMainFrame))
         {
            this._activeMainFrame.dispose();
            this._activeMainFrame = null;
         }
         if(Boolean(this._activeSubFrame))
         {
            this._activeSubFrame.dispose();
            this._activeSubFrame = null;
         }
      }
      
      public function closeSubFrame() : void
      {
         if(Boolean(this._activeSubFrame))
         {
            this._activeSubFrame.dispose();
            this._activeSubFrame = null;
         }
      }
      
      public function openSubFrame($itemInfo:ActiveEventsInfo) : void
      {
         if(!this._activeSubFrame)
         {
            this._activeSubFrame = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeSubFrame");
            this._activeSubFrame.control = this;
         }
         this._activeSubFrame.show();
         this._activeSubFrame.x = this._activeMainFrame.x + this._activeMainFrame.width;
         this._activeSubFrame.y = this._activeMainFrame.y;
         this._activeSubFrame.receiveItem($itemInfo);
      }
   }
}

