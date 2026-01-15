package chickActivation
{
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import chickActivation.view.ChickActivationViewFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ChickActivationManager extends EventDispatcher
   {
      
      private static var _instance:ChickActivationManager;
      
      private var _model:ChickActivationModel;
      
      public function ChickActivationManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : ChickActivationManager
      {
         if(_instance == null)
         {
            _instance = new ChickActivationManager();
         }
         return _instance;
      }
      
      public function get model() : ChickActivationModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new ChickActivationModel();
         this.initData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHICKACTIVATION_SYSTEM,this.__chickActivationHandler);
      }
      
      private function initData() : void
      {
         var qualityDic:Dictionary = new Dictionary();
         qualityDic["0,0,1"] = 1;
         qualityDic["0,0,2"] = 1;
         qualityDic["0,0,3"] = 1;
         qualityDic["0,0,4"] = 1;
         qualityDic["0,0,5"] = 1;
         qualityDic["0,0,6"] = 1;
         qualityDic["0,0,0"] = 1;
         qualityDic["0,2,5"] = 2;
         qualityDic["0,2,6"] = 2;
         qualityDic["0,2,0"] = 2;
         qualityDic["0,1"] = 3;
         qualityDic["0,3"] = 12;
         qualityDic["1,0,1"] = 101;
         qualityDic["1,0,2"] = 101;
         qualityDic["1,0,3"] = 101;
         qualityDic["1,0,4"] = 101;
         qualityDic["1,0,5"] = 101;
         qualityDic["1,0,6"] = 101;
         qualityDic["1,0,0"] = 101;
         qualityDic["1,2,5"] = 102;
         qualityDic["1,2,6"] = 102;
         qualityDic["1,2,0"] = 102;
         qualityDic["1,1"] = 103;
         this._model.qualityDic = qualityDic;
      }
      
      private function __chickActivationHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readInt();
         if(cmd == ChickActivationType.CHICKACTIVATION_LOGIN)
         {
            this.loginDataUpdate(pkg);
         }
         else if(cmd == ChickActivationType.CHICKACTIVATION_UPDATE)
         {
            this.dataUpdate(pkg);
         }
      }
      
      private function loginDataUpdate(pkg:PackageIn) : void
      {
         this.model.isKeyOpened = pkg.readInt();
         this.model.keyIndex = pkg.readInt();
         this.model.keyOpenedTime = pkg.readDate();
         this.model.keyOpenedType = pkg.readInt();
         var gainArr:Array = [];
         for(var i:int = 0; i < 12; i++)
         {
            gainArr.push(pkg.readInt());
         }
         this.model.gainArr = gainArr;
         this.model.dataChange(ChickActivationEvent.UPDATE_DATA);
      }
      
      private function dataUpdate(pkg:PackageIn) : void
      {
         var g:int = 0;
         this.model.isKeyOpened = pkg.readInt();
         this.model.keyIndex = pkg.readInt();
         this.model.keyOpenedTime = pkg.readDate();
         this.model.keyOpenedType = pkg.readInt();
         var gainArr:Array = [];
         for(var i:int = 0; i < 12; i++)
         {
            gainArr.push(pkg.readInt());
         }
         var temp1:int = -1;
         if(this.model.gainArr.length == 12)
         {
            for(g = 0; g < this.model.gainArr.length - 1; g++)
            {
               if(this.model.gainArr[g] != gainArr[g] && gainArr[g] > 0)
               {
                  temp1 = g;
                  break;
               }
            }
            if(temp1 != -1)
            {
               this.model.dataChange(ChickActivationEvent.GET_REWARD,temp1);
            }
         }
         this.model.gainArr = gainArr;
         this.model.dataChange(ChickActivationEvent.UPDATE_DATA);
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this.model.itemInfoList = dataList;
      }
      
      public function checkShowIcon() : void
      {
         this.model.isOpen = ServerConfigManager.instance.chickActivationIsOpen;
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHICKACTIVATION,this.model.isOpen);
      }
      
      public function showFrame() : void
      {
         var loader:BaseLoader = null;
         if(Boolean(this.model.itemInfoList))
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHICKACTIVATION);
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
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHICKACTIVATION);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CHICKACTIVATION)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         var frame:ChickActivationViewFrame = null;
         if(event.module == UIModuleTypes.CHICKACTIVATION)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            frame = ComponentFactory.Instance.creatComponentByStylename("ChickActivationViewFrame");
            LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            SocketManager.Instance.out.sendChickActivationQuery();
         }
      }
   }
}

