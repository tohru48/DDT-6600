package growthPackage
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import growthPackage.event.GrowthPackageEvent;
   import growthPackage.model.GrowthPackageModel;
   import growthPackage.view.GrowthPackageFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GrowthPackageManager extends EventDispatcher
   {
      
      private static var _instance:GrowthPackageManager;
      
      public static var indexMax:int = 9;
      
      private var _model:GrowthPackageModel;
      
      private var growthPackageIsOpen:Boolean;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function GrowthPackageManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : GrowthPackageManager
      {
         if(!_instance)
         {
            _instance = new GrowthPackageManager();
         }
         return _instance;
      }
      
      public function get model() : GrowthPackageModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new GrowthPackageModel();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GROWTHPACKAGE,this.__growthPackageHandler);
         this.model.addEventListener(GrowthPackageEvent.ICON_CLOSE,this.__iconCloseHandler);
      }
      
      private function __growthPackageHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readInt();
         switch(cmd)
         {
            case GrowthPackageType.GROWTHPACKAGE_OPEN:
               this.updateData(pkg);
               break;
            case GrowthPackageType.GROWTHPACKAGE_UPDATEDATA:
               this.updateData(pkg);
               break;
            case GrowthPackageType.GROWTHPACKAGE_ISOPEN:
               this.isOpenHandler(pkg);
         }
      }
      
      private function updateData(pkg:PackageIn) : void
      {
         this.model.isBuy = pkg.readInt();
         var arr:Array = new Array();
         for(var i:int = 0; i < indexMax; i++)
         {
            arr.push(pkg.readInt());
         }
         this.model.isCompleteList = arr;
         this.model.dataChange(GrowthPackageEvent.DATA_CHANGE);
      }
      
      private function isOpenHandler(pkg:PackageIn) : void
      {
         this.growthPackageIsOpen = pkg.readBoolean();
         this.showEnterIcon();
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this.model.itemInfoList = dataList;
      }
      
      private function __iconCloseHandler(evt:GrowthPackageEvent) : void
      {
         this.disposeEnterIcon();
      }
      
      public function showEnterIcon() : void
      {
         if(this.model.isShowIcon && this.growthPackageIsOpen)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GROWTHPACKAGE,true);
         }
         else
         {
            this.disposeEnterIcon();
         }
      }
      
      public function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GROWTHPACKAGE,false);
      }
      
      public function onClickIcon(e:MouseEvent) : void
      {
         var loader:BaseLoader = null;
         if(Boolean(this.model.itemInfoList))
         {
            this.loadUIModule(this.showFrame);
         }
         else
         {
            loader = LoaderCreate.Instance.createActivitySystemItemsLoader();
            loader.addEventListener(Event.COMPLETE,this.__dataLoaderCompleteHandler);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function __dataLoaderCompleteHandler(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__dataLoaderCompleteHandler);
         this.loadUIModule(this.showFrame);
      }
      
      public function showBuyFrame() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var buyPrice:Number = ServerConfigManager.instance.growthPackagePrice;
         var _buyFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.growthPackage.buyPriceMsg",buyPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _buyFrame.addEventListener(FrameEvent.RESPONSE,this.__onBuyFrameResponse);
      }
      
      private function __onBuyFrameResponse(evt:FrameEvent) : void
      {
         var buyPrice:Number = NaN;
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            buyPrice = ServerConfigManager.instance.growthPackagePrice;
            if(PlayerManager.Instance.Self.Money < buyPrice)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendGrowthPackageOpen();
            }
         }
         var _tipsframe:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         _tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onBuyFrameResponse);
         ObjectUtils.disposeAllChildren(_tipsframe);
         ObjectUtils.disposeObject(_tipsframe);
         _tipsframe = null;
      }
      
      public function showFrame() : void
      {
         var frame:GrowthPackageFrame = ComponentFactory.Instance.creatComponentByStylename("GrowthPackageFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GROWTH_PACKAGE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GROWTH_PACKAGE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GROWTH_PACKAGE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

