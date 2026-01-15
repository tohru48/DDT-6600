package witchBlessing
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
   import witchBlessing.data.WitchBlessingModel;
   import witchBlessing.data.WitchBlessingPackageType;
   import witchBlessing.view.WitchBlessingMainView;
   
   public class WitchBlessingManager extends EventDispatcher
   {
      
      private static var _instance:WitchBlessingManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _frame:WitchBlessingMainView;
      
      private var _model:WitchBlessingModel;
      
      public function WitchBlessingManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : WitchBlessingManager
      {
         if(_instance == null)
         {
            _instance = new WitchBlessingManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new WitchBlessingModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WITCHBLESSING_DATA,this.__witchBlessingHandle);
      }
      
      public function get model() : WitchBlessingModel
      {
         return this._model;
      }
      
      public function get frame() : WitchBlessingMainView
      {
         return this._frame;
      }
      
      public function isOpen() : Boolean
      {
         return this._model.isOpen;
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this._model.itemInfoList = dataList;
      }
      
      private function __witchBlessingHandle(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case WitchBlessingPackageType.WITCHBLESSING_OPEN_CLOSE:
               this.isOpenIcon(pkg);
               break;
            case WitchBlessingPackageType.WITCHBLESSING_INFO:
               this.enterView(pkg);
               break;
            case WitchBlessingPackageType.WITCHBLESSING_BLESS:
         }
      }
      
      private function enterView(pkg:PackageIn) : void
      {
         this._model.isDouble = pkg.readBoolean();
         this._model.totalExp = pkg.readInt();
         this._model.lv1GetAwardsTimes = pkg.readInt();
         this._model.lv1CD = pkg.readInt();
         this._model.lv2GetAwardsTimes = pkg.readInt();
         this._model.lv2CD = pkg.readInt();
         this._model.lv3GetAwardsTimes = pkg.readInt();
         this._model.lv3CD = pkg.readInt();
         if(loadComplete)
         {
            this.showMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WITCH_BLESSING);
         }
      }
      
      public function testEnter() : void
      {
         if(loadComplete)
         {
            this.showMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WITCH_BLESSING);
         }
      }
      
      public function isOpenIcon(pkg:PackageIn) : void
      {
         this._model.isOpen = pkg.readBoolean();
         this._model.startDate = pkg.readDate();
         this._model.endDate = pkg.readDate();
         HallIconManager.instance.updateSwitchHandler(HallIconType.WITCHBLESSING,this._model.isOpen);
      }
      
      public function onClickIcon() : void
      {
         SocketManager.Instance.out.witchBlessing_enter();
      }
      
      private function showMainView() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.show();
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.WitchBlessingMainView");
            this._frame.show();
         }
         this._frame.flushData();
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WITCH_BLESSING)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __completeShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WITCH_BLESSING)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showMainView();
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._frame))
         {
            this._frame = null;
         }
      }
   }
}

