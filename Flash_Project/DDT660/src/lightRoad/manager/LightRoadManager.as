package lightRoad.manager
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import lightRoad.data.LightRoadPackageType;
   import lightRoad.dataAnalyzer.LightRoadDataAnalyzer;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.loader.LoaderLightRoadUIModule;
   import lightRoad.model.LightRoadModel;
   import lightRoad.view.LightRoadHelpFrame;
   import lightRoad.view.MainFrame;
   import road7th.comm.PackageIn;
   
   public class LightRoadManager extends EventDispatcher
   {
      
      private static var _instance:LightRoadManager;
      
      private var _model:LightRoadModel;
      
      private var _MainFrame:MainFrame;
      
      private var _ShowMainFrame:Boolean = false;
      
      public function LightRoadManager(pct:PrivateClass)
      {
         super();
         if(pct == null)
         {
            throw new Error("错误：LightRoadManager类属于单例，请使用本类的istance获取实例");
         }
      }
      
      public static function get instance() : LightRoadManager
      {
         if(LightRoadManager._instance == null)
         {
            LightRoadManager._instance = new LightRoadManager(new PrivateClass());
         }
         return LightRoadManager._instance;
      }
      
      public function get ShowMainFrame() : Boolean
      {
         return this._ShowMainFrame;
      }
      
      public function set ShowMainFrame(Type:Boolean) : void
      {
         this._ShowMainFrame = Type;
      }
      
      public function get model() : LightRoadModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         if(this._model == null)
         {
            this._model = new LightRoadModel();
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.pkgHandler);
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         if(pkg != null)
         {
            this._model.isOpen = pkg.readBoolean();
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            this.dispose();
         }
      }
      
      private function upActivationDate(pkg:PackageIn) : void
      {
         if(pkg != null)
         {
            this.model.thingsIntType = pkg.readInt();
            this.model.ActivityStartTime = pkg.readUTF();
            this.model.ActivityEndTime = pkg.readUTF();
            this.upDataThingsType();
            this.upDataPointType();
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.UPMAINFRAMEDATA));
         }
      }
      
      private function upThingsDate(pkg:PackageIn) : void
      {
         if(pkg != null)
         {
            this.model.thingsIntType = pkg.readInt();
            this.upDataThingsType();
            this.upDataPointType();
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.UPMAINFRAMEDATA));
         }
      }
      
      public function returnPointType(step:int) : Boolean
      {
         return (this.model.thingsIntType >> step & 1) == 0;
      }
      
      private function hideEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIGHTROAD,false);
      }
      
      public function showEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIGHTROAD,true);
      }
      
      public function templateDataSetup(analyzer:DataAnalyzer) : void
      {
         var TopN:int = 0;
         var tempStr:String = null;
         var tempArray:Array = null;
         var i:int = 0;
         var len:int = 0;
         var j:int = 0;
         var len2:int = 0;
         var temp:LightGiftInfo = null;
         if(analyzer is LightRoadDataAnalyzer)
         {
            this.model.initThingsArray();
            TopN = int(this.model.thingsXYArray.length);
            tempStr = "";
            tempArray = LightRoadDataAnalyzer(analyzer).dataList;
            i = 0;
            len = int(tempArray.length);
            j = 0;
            len2 = 0;
            for(i = 0; i < len; i++)
            {
               temp = tempArray[i] as LightGiftInfo;
               temp.Space = i + 1;
               this.model.thingsArray.push(temp);
            }
            this.upDataThingsType();
            this.upDataPointType();
         }
      }
      
      private function upDataThingsType() : void
      {
         var i:int = 0;
         var len:int = 0;
         len = int(this.model.thingsType.length);
         for(i = 0; i < len; i++)
         {
            if(this.returnPointType(i))
            {
               this.model.thingsType[i] = 0;
            }
            else
            {
               this.model.thingsType[i] = 1;
            }
         }
         len = int(this.model.thingsType.length);
         for(i = 0; i < len; i++)
         {
            this.model.thingsArray[i].GetType = this.model.thingsType[i];
         }
      }
      
      private function upDataPointType() : void
      {
         var i:int = 0;
         var len:int = int(this.model.pointGroup.length);
         var space:int = 0;
         for(i = 0; i < len; i++)
         {
            space = this.model.pointGroup[i][0] - 1;
            this.model.thingsArray[space].Type = 1;
         }
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case LightRoadPackageType.ACTIVATIONTYPE:
               this.openOrclose(pkg);
               break;
            case LightRoadPackageType.INACVATION:
               this.upActivationDate(pkg);
               break;
            case LightRoadPackageType.UPTHINGSMESSAGE:
               this.upThingsDate(pkg);
         }
      }
      
      public function onClicklightRoadIcon(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.lightRoadLevel)
         {
            ServerConfigManager.instance.AuctionRate;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lightRoad.MainFrame.PlayerGradeText",ServerConfigManager.instance.lightRoadLevel));
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderLightRoadUIModule.Instance.loadUIModule(this.doOpenLightRoadFrame);
         }
      }
      
      public function dealWhithLightRoadEvent(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case LightRoadPackageType.CLOSEMAINFRAME:
               this.closeMainFrame();
               break;
            case LightRoadPackageType.OPENHELPRAME:
               this.openHelpHandler();
         }
      }
      
      public function doOpenLightRoadFrame() : void
      {
         if(StateManager.currentStateType != StateType.MAIN)
         {
            StateManager.setState(StateType.LIGHTROAD_WINDOW);
         }
         else
         {
            this._ShowMainFrame = true;
            this.createMainFrame();
         }
      }
      
      public function createMainFrame() : void
      {
         if(!this._ShowMainFrame)
         {
            return;
         }
         SocketManager.Instance.out.sendLightRoadStarEnter();
         this._ShowMainFrame = false;
         this.closeMainFrame();
         this._MainFrame = ComponentFactory.Instance.creatComponentByStylename("lightRoad.MainFrame");
         LayerManager.Instance.addToLayer(this._MainFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._MainFrame.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.dealWhithLightRoadEvent);
      }
      
      public function closeMainFrame() : void
      {
         if(Boolean(this._MainFrame))
         {
            this._MainFrame.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.dealWhithLightRoadEvent);
            this._MainFrame.dispose();
            this._MainFrame = null;
         }
      }
      
      public function DrawThings(Space:int) : void
      {
         SocketManager.Instance.out.lightRoadPointWork(Space);
      }
      
      private function openHelpHandler() : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("lightRoad.HelpPrompt");
         var helpPage:LightRoadHelpFrame = ComponentFactory.Instance.creat("LightRoad.HelpFrame");
         helpPage.setView(helpBd);
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._MainFrame))
         {
            this.closeMainFrame();
         }
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
