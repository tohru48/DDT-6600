package newTitle
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import newTitle.data.NewTitleDataAnalyz;
   import newTitle.data.NewTitleModel;
   import newTitle.view.NewTitleFrame;
   import road7th.comm.PackageIn;
   
   public class NewTitleManager extends EventDispatcher
   {
      
      private static var _instance:NewTitleManager;
      
      public static var FIRST_TITLEID:int = 602;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public var ShowTitle:Boolean = true;
      
      private var _titleInfo:Dictionary;
      
      private var _titleArray:Array;
      
      private var _titleFrame:NewTitleFrame;
      
      public function NewTitleManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : NewTitleManager
      {
         if(!_instance)
         {
            _instance = new NewTitleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_HIDE_TITLE,this.__onGetHideTitleFlag);
      }
      
      protected function __onGetHideTitleFlag(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         NewTitleManager.instance.ShowTitle = !pkg.readBoolean();
      }
      
      public function newTitleDataSetup(analyzer:NewTitleDataAnalyz) : void
      {
         var id:String = null;
         this._titleInfo = analyzer.list;
         this._titleArray = [];
         for(id in this._titleInfo)
         {
            this._titleArray.push(this._titleInfo[id]);
         }
         this._titleArray.sortOn("Order",Array.NUMERIC);
      }
      
      public function getTitleByName(name:String) : NewTitleModel
      {
         var title:NewTitleModel = null;
         for(var i:int = 0; i < this._titleArray.length; i++)
         {
            if(this._titleArray[i].Name == name)
            {
               title = this._titleArray[i];
               break;
            }
         }
         return title;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showTitleFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWTITLE_VIEW);
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.NEWTITLE_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.NEWTITLE_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showTitleFrame() : void
      {
         this._titleFrame = ComponentFactory.Instance.creatComponentByStylename("newTitle.newTitleView");
         this._titleFrame.show();
      }
      
      public function hide() : void
      {
         this._titleFrame.dispose();
         this._titleFrame = null;
      }
      
      public function get titleInfo() : Dictionary
      {
         return this._titleInfo;
      }
      
      public function get titleArray() : Array
      {
         return this._titleArray;
      }
   }
}

