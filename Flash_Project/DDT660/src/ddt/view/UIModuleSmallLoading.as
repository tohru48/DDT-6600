package ddt.view
{
   import com.pickgliss.utils.ClassUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="close",type="flash.events.Event")]
   public class UIModuleSmallLoading extends EventDispatcher
   {
      
      private static var _instance:UIModuleSmallLoading;
      
      private static var _loadingInstance:*;
      
      private static const SMALL_LOADING_CLASS:String = "SmallLoading";
      
      public function UIModuleSmallLoading()
      {
         super();
      }
      
      public static function get Instance() : UIModuleSmallLoading
      {
         if(_instance == null)
         {
            _instance = new UIModuleSmallLoading();
            _loadingInstance = ClassUtils.getDefinition(SMALL_LOADING_CLASS)["Instance"];
            _loadingInstance.addEventListener(Event.CLOSE,__onCloseClick);
         }
         return _instance;
      }
      
      private static function __onCloseClick(event:Event) : void
      {
         _instance.dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function show(blackGound:Boolean = true, autoRemoveChild:Boolean = true) : void
      {
         _loadingInstance.show(blackGound,autoRemoveChild);
      }
      
      public function hide() : void
      {
         _loadingInstance.hide();
      }
      
      public function set progress(p:int) : void
      {
         _loadingInstance.progress = p;
      }
      
      public function get progress() : int
      {
         return _loadingInstance.progress;
      }
   }
}

