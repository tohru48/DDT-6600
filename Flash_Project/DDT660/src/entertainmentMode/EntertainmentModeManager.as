package entertainmentMode
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import entertainmentMode.data.EntertainmentPackageType;
   import entertainmentMode.model.EntertainmentModel;
   import entertainmentMode.view.EntertainmentModeView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import roomList.LookupEnumerate;
   
   public class EntertainmentModeManager extends EventDispatcher
   {
      
      private static var _instance:EntertainmentModeManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _frameView:EntertainmentModeView;
      
      public var isopen:Boolean = false;
      
      public var openTime:String;
      
      public function EntertainmentModeManager()
      {
         super();
      }
      
      public static function get instance() : EntertainmentModeManager
      {
         if(!_instance)
         {
            _instance = new EntertainmentModeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function show() : void
      {
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.entertainmentMode.gradeMin"));
            return;
         }
         if(loadComplete)
         {
            this.showFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ENTERTAINMENT_MODE);
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTERTAINMENT,this.__handler);
      }
      
      private function removeEvent() : void
      {
      }
      
      private function __handler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var beginTime:Date = null;
         var endTime:Date = null;
         var day:String = null;
         pkg = e.pkg;
         switch(e._cmd)
         {
            case EntertainmentPackageType.BUY_ICON:
               EntertainmentModel.instance.score = pkg.readInt();
               break;
            case EntertainmentPackageType.GET_SCORE:
               this.isopen = pkg.readBoolean();
               beginTime = pkg.readDate();
               endTime = pkg.readDate();
               day = String(beginTime.fullYear) + "-" + String(beginTime.month + 1) + "-" + String(beginTime.date);
               this.openTime = day + " " + beginTime.hours + ":" + (beginTime.minutes < 10 ? "0" + String(beginTime.minutes) : beginTime.minutes) + "-" + endTime.hours + ":" + (endTime.minutes < 10 ? "0" + String(endTime.minutes) : endTime.minutes);
               this.showHideIcon(this.isopen);
         }
      }
      
      public function showHideIcon(bol:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ENTERTAINMENT,bol);
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ENTERTAINMENT_MODE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ENTERTAINMENT_MODE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.showFrame();
         }
      }
      
      public function hide() : void
      {
         if(this._frameView != null)
         {
            this._frameView.dispose();
         }
         this._frameView = null;
         this.removeEvent();
      }
      
      private function showFrame() : void
      {
         this._frameView = ComponentFactory.Instance.creatComponentByStylename("entertainment.EntertainmentModeView");
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOMLIST_ENTERTAINMENT);
         this._frameView.show();
      }
   }
}

