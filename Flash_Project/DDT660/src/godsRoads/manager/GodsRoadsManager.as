package godsRoads.manager
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import godsRoads.analyze.GodsRoadsDataAnalyzer;
   import godsRoads.data.GodsRoadsMissionVo;
   import godsRoads.data.GodsRoadsPkgType;
   import godsRoads.data.GodsRoadsStepVo;
   import godsRoads.data.GodsRoadsVo;
   import godsRoads.model.GodsRoadsModel;
   import godsRoads.view.GodsRoadsView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GodsRoadsManager extends EventDispatcher
   {
      
      private static var _instance:GodsRoadsManager;
      
      public var _model:GodsRoadsModel;
      
      private var _isOpen:Boolean = false;
      
      public var _view:GodsRoadsView;
      
      private var _func:Function;
      
      private var _xml:XML;
      
      private var _funcParams:Array = [];
      
      public var lastStep:int = 0;
      
      public var lastMssion:int = 0;
      
      public function GodsRoadsManager(privateClass:PrivateClass)
      {
         super();
         this._model = new GodsRoadsModel();
      }
      
      public static function get instance() : GodsRoadsManager
      {
         if(GodsRoadsManager._instance == null)
         {
            GodsRoadsManager._instance = new GodsRoadsManager(new PrivateClass());
         }
         return GodsRoadsManager._instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GODS_ROADS,this.pkgHandler);
      }
      
      public function loadGodsRoadsModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GODSROADS);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GODSROADS)
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
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GODSROADS)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var flag:Boolean = false;
         pkg = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case GodsRoadsPkgType.GODS_ROADS_OPEN:
               this._isOpen = pkg.readBoolean();
               if(this._isOpen)
               {
                  this.showGodsRoads();
               }
               else
               {
                  this.hideGodsRoadsIcon();
               }
               break;
            case GodsRoadsPkgType.ENTER_GODS_ROADS:
               this.doOpenGodsRoads(pkg);
               break;
            case GodsRoadsPkgType.GET_AWARDS:
               flag = pkg.readBoolean();
               if(flag)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.godsRoads.getawards"));
               }
               this.sendEnter();
         }
      }
      
      public function changeSteps(lv:int) : void
      {
         this._view.changeSteps(lv);
      }
      
      public function templateDataSetup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is GodsRoadsDataAnalyzer)
         {
            this._model.missionInfo = GodsRoadsDataAnalyzer(analyzer).dataList;
         }
         dispatchEvent(new Event("XMLdata_Complete"));
      }
      
      public function showGodsRoads() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GODSROADS,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.GODSROADS,true,10);
         }
      }
      
      private function hideGodsRoadsIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GODSROADS,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.GODSROADS,false);
      }
      
      public function openGodsRoads(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
            return;
         }
         this.loadGodsRoadsModule(this.sendEnter);
      }
      
      private function sendEnter() : void
      {
         SocketManager.Instance.out.enterGodsRoads();
      }
      
      private function doOpenGodsRoads(pkg:PackageIn) : void
      {
         var sVo:GodsRoadsStepVo = null;
         var ii:int = 0;
         var k:int = 0;
         var mVo:GodsRoadsMissionVo = null;
         var j:int = 0;
         var id:int = 0;
         var item:ItemTemplateInfo = null;
         var aVo:InventoryItemInfo = null;
         var idd:int = 0;
         var itemm:ItemTemplateInfo = null;
         var aaVo:InventoryItemInfo = null;
         this._model.godsRoadsData = new GodsRoadsVo();
         var vo:GodsRoadsVo = this._model.godsRoadsData;
         vo.Level = pkg.readInt();
         vo.currentLevel = pkg.readInt();
         vo.steps = new Vector.<GodsRoadsStepVo>();
         for(var i:int = 0; i < vo.Level; i++)
         {
            sVo = new GodsRoadsStepVo();
            sVo.isGetAwards = pkg.readBoolean();
            sVo.missionsNum = pkg.readInt();
            sVo.currentStep = i + 1;
            sVo.awards = [];
            sVo.missionVos = [];
            for(ii = 0; ii < sVo.missionsNum; ii++)
            {
               mVo = new GodsRoadsMissionVo();
               mVo.ID = pkg.readInt();
               mVo.isFinished = pkg.readBoolean();
               mVo.condition1 = pkg.readInt();
               mVo.condition2 = pkg.readInt();
               mVo.condition3 = pkg.readInt();
               mVo.condition4 = pkg.readInt();
               mVo.isGetAwards = pkg.readBoolean();
               mVo.awardsNum = pkg.readInt();
               mVo.awards = [];
               for(j = 0; j < mVo.awardsNum; j++)
               {
                  id = pkg.readInt();
                  item = ItemManager.Instance.getTemplateById(id);
                  aVo = new InventoryItemInfo();
                  ObjectUtils.copyProperties(aVo,item);
                  aVo.TemplateID = id;
                  aVo.StrengthenLevel = pkg.readInt();
                  aVo.Count = pkg.readInt();
                  aVo.ValidDate = pkg.readInt();
                  aVo.AttackCompose = pkg.readInt();
                  aVo.DefendCompose = pkg.readInt();
                  aVo.AgilityCompose = pkg.readInt();
                  aVo.LuckCompose = pkg.readInt();
                  aVo.IsBinds = pkg.readBoolean();
                  mVo.awards.push(aVo);
               }
               sVo.missionVos.push(mVo);
            }
            vo.steps.push(sVo);
            sVo.awadsNum = pkg.readInt();
            for(k = 0; k < sVo.awadsNum; k++)
            {
               idd = pkg.readInt();
               itemm = ItemManager.Instance.getTemplateById(idd);
               aaVo = new InventoryItemInfo();
               ObjectUtils.copyProperties(aaVo,itemm);
               aaVo.TemplateID = idd;
               aaVo.StrengthenLevel = pkg.readInt();
               aaVo.Count = pkg.readInt();
               aaVo.ValidDate = pkg.readInt();
               aaVo.AttackCompose = pkg.readInt();
               aaVo.DefendCompose = pkg.readInt();
               aaVo.AgilityCompose = pkg.readInt();
               aaVo.LuckCompose = pkg.readInt();
               aaVo.IsBinds = pkg.readBoolean();
               sVo.awards.push(aaVo);
            }
         }
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creat("godsRoads.GodsRoadsView");
            this._view.initView();
            this._view.titleText = LanguageMgr.GetTranslation("ddt.godsRoads.title");
            this._view.addEventListener(Event.REMOVED_FROM_STAGE,this.disposeView);
            LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._view.updateView(this._model,this.lastStep,this.lastMssion);
      }
      
      private function disposeView(e:Event) : void
      {
         this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.disposeView);
         this._view = null;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get XMLData() : XML
      {
         return this._xml;
      }
      
      public function set XMLData(val:XML) : void
      {
         this._xml = val;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
