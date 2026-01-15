package catchbeast
{
   import catchbeast.date.CatchBeastPackageType;
   import catchbeast.view.CatchBeastView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class CatchBeastManager extends EventDispatcher
   {
      
      private static var _instance:CatchBeastManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public var RoomType:int = 0;
      
      private var _isBegin:Boolean;
      
      private var _catchBeastView:CatchBeastView;
      
      public function CatchBeastManager()
      {
         super();
      }
      
      public static function get instance() : CatchBeastManager
      {
         if(!_instance)
         {
            _instance = new CatchBeastManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_BEGIN,this.__addCatchBeastBtn);
      }
      
      public function get isBegin() : Boolean
      {
         return this._isBegin;
      }
      
      protected function __addCatchBeastBtn(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         event = null;
         switch(cmd)
         {
            case CatchBeastPackageType.CATCHBEAST_BEGIN:
               this.openOrclose(pkg);
               break;
            case CatchBeastPackageType.CATCHBEAST_VIEWINFO:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,pkg);
               break;
            case CatchBeastPackageType.CATCHBEAST_GETAWARD:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,pkg);
               break;
            case CatchBeastPackageType.CATCHBEAST_BUYBUFF:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,pkg);
               break;
            case CatchBeastPackageType.CATCHBEAST_CHALLENGE:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_CHALLENGE,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isBegin = pkg.readBoolean();
         if(this._isBegin)
         {
            this.createCatchBeastBtn();
         }
         else
         {
            this.deleteCatchBeastBtn();
         }
      }
      
      public function createCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CATCHBEAST,true);
      }
      
      public function deleteCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CATCHBEAST,false);
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showCatchBeastFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CATCH_BEAST);
         }
      }
      
      public function hide() : void
      {
         this.RoomType = 0;
         if(this._catchBeastView != null)
         {
            this._catchBeastView.dispose();
         }
         this._catchBeastView = null;
      }
      
      public function onCatchBeastShow(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.show();
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CATCH_BEAST)
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
         if(event.module == UIModuleTypes.CATCH_BEAST)
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
      
      private function showCatchBeastFrame() : void
      {
         this._catchBeastView = ComponentFactory.Instance.creatComponentByStylename("catchBeast.CatchBeastView");
         this._catchBeastView.show();
      }
   }
}

