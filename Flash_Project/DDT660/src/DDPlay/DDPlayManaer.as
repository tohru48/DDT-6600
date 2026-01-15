package DDPlay
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
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class DDPlayManaer extends EventDispatcher
   {
      
      private static var _instance:DDPlayManaer;
      
      public static const UPDATE_SCORE:String = "update_score";
      
      private static var loadComplete:Boolean = false;
      
      private static var useFirst:Boolean = true;
      
      public var isOpen:Boolean;
      
      public var DDPlayScore:int;
      
      public var DDPlayMoney:int;
      
      public var exchangeFold:int;
      
      public var beginDate:Date;
      
      public var endDate:Date;
      
      private var _ddPlayView:DDPlayView;
      
      public function DDPlayManaer(ddplay:DDPlayInstance, target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : DDPlayManaer
      {
         var ddplayinstance:DDPlayInstance = null;
         if(_instance == null)
         {
            ddplayinstance = new DDPlayInstance();
            _instance = new DDPlayManaer(ddplayinstance);
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DDPLAY_BEGIN,this.__addDDPlayBtn);
      }
      
      protected function __addDDPlayBtn(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         event = null;
         switch(cmd)
         {
            case DDPlayType.DDPLAY_BEGIN:
               this.openOrClose(pkg);
               break;
            case DDPlayType.ENTER_DDPLAY:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_ENTER,pkg);
               break;
            case DDPlayType.DDPLAY_START:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_START,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function openOrClose(pkg:PackageIn) : void
      {
         this.isOpen = pkg.readBoolean();
         this.beginDate = pkg.readDate();
         this.endDate = pkg.readDate();
         this.DDPlayMoney = pkg.readInt();
         this.exchangeFold = pkg.readInt();
         if(this.isOpen)
         {
            this.createDDPlayBtn();
         }
         else
         {
            this.deleteDDPlayBtn();
         }
      }
      
      public function createDDPlayBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.DDPLAY,true);
      }
      
      public function deleteDDPlayBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.DDPLAY,false);
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showDDPlayView();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDPLAY);
         }
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
         if(event.module == UIModuleTypes.DDPLAY)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDPLAY)
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
      
      private function showDDPlayView() : void
      {
         this._ddPlayView = ComponentFactory.Instance.creatComponentByStylename("ddPlay.view.ddPlayView");
         this._ddPlayView.show();
      }
   }
}

class DDPlayInstance
{
   
   public function DDPlayInstance()
   {
      super();
   }
}
