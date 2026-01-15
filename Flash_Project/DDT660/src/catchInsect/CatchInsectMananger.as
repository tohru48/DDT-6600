package catchInsect
{
   import catchInsect.data.CatchInsectItemInfo;
   import catchInsect.data.CatchInsectPackageType;
   import catchInsect.event.CatchInsectEvent;
   import catchInsect.loader.LoaderCatchInsectUIModule;
   import catchInsect.model.CatchInsectModel;
   import catchInsect.player.PlayerVO;
   import catchInsect.view.CatchInsectCheckGeinFrame;
   import catchInsect.view.CatchInsectChooseFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.player.SelfInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class CatchInsectMananger extends EventDispatcher
   {
      
      public static var isFrameChristmas:Boolean;
      
      public static var isToRoom:Boolean;
      
      private static var _instance:CatchInsectMananger;
      
      public static const UPDATE_INFO:String = "updateInfo";
      
      private var _self:SelfInfo;
      
      private var _model:CatchInsectModel;
      
      private var _isShowIcon:Boolean = false;
      
      private var _hallStateView:HallStateView;
      
      private var _catchInsectIcon:MovieClip;
      
      private var _checkGeinFrame:CatchInsectCheckGeinFrame;
      
      private var _mapPath:String;
      
      private var _appearPos:Array = new Array();
      
      private var _catchInsectInfo:CatchInsectItemInfo;
      
      public var isReConnect:Boolean = false;
      
      public var loadUiModuleComplete:Boolean = false;
      
      public const CATCH_MADMAN:int = 620;
      
      public const CATCH_MASTER:int = 619;
      
      public const CATCH_EXPERT:int = 621;
      
      public const UANG:int = 626;
      
      public const DRAGONFLY:int = 618;
      
      public const CICADA:int = 629;
      
      private var _chooseRoomFrame:CatchInsectChooseFrame;
      
      public function CatchInsectMananger()
      {
         super();
      }
      
      public static function get instance() : CatchInsectMananger
      {
         if(!_instance)
         {
            _instance = new CatchInsectMananger();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new CatchInsectModel();
         this._self = new SelfInfo();
         SocketManager.Instance.addEventListener(CatchInsectEvent.CATCH_INSECT,this.pkgHandler);
      }
      
      private function pkgHandler(e:CatchInsectEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e.cmd;
         var event:CatchInsectEvent = null;
         switch(cmd)
         {
            case CatchInsectPackageType.OPEN_OR_CLOSE:
               this.openOrclose(pkg);
               break;
            case CatchInsectPackageType.ENTER_SCENE:
               this.enterScene(pkg);
               break;
            case CatchInsectPackageType.ADDPLAYER:
               event = new CatchInsectEvent(CatchInsectEvent.ADDPLAYER_ROOM,pkg);
               break;
            case CatchInsectPackageType.MOVE:
               event = new CatchInsectEvent(CatchInsectEvent.MOVE,pkg);
               break;
            case CatchInsectPackageType.PLAYER_STATUE:
               event = new CatchInsectEvent(CatchInsectEvent.PLAYER_STATUE,pkg);
               break;
            case CatchInsectPackageType.REMOVE_PLAYER:
               event = new CatchInsectEvent(CatchInsectEvent.REMOVE_PLAYER,pkg);
               break;
            case CatchInsectPackageType.MONSTER:
               event = new CatchInsectEvent(CatchInsectEvent.MONSTER,pkg);
               break;
            case CatchInsectPackageType.UPDATE_INFO:
               this.updateScore(pkg);
               break;
            case CatchInsectPackageType.UPDATE_AREA_RANK:
               event = new CatchInsectEvent(CatchInsectEvent.UPDATE_AREA_RANK,pkg);
               break;
            case CatchInsectPackageType.AREA_SELF_INFO:
               event = new CatchInsectEvent(CatchInsectEvent.AREA_SELF_INFO,pkg);
               break;
            case CatchInsectPackageType.UPDATE_LOCAL_RANK:
               event = new CatchInsectEvent(CatchInsectEvent.UPDATE_LOCAL_RANK,pkg);
               break;
            case CatchInsectPackageType.LOCAL_SELF_INFO:
               event = new CatchInsectEvent(CatchInsectEvent.LOCAL_SELF_INFO,pkg);
               break;
            case CatchInsectPackageType.CAKE_STATUS:
               event = new CatchInsectEvent(CatchInsectEvent.CAKE_STATUS,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function updateScore(pkg:PackageIn) : void
      {
         this.model.score = pkg.readInt();
         this.model.avaibleScore = pkg.readInt();
         this.model.prizeStatus = pkg.readInt();
         dispatchEvent(new Event(UPDATE_INFO));
      }
      
      private function enterScene(pkg:PackageIn) : void
      {
         this._model.isEnter = pkg.readBoolean();
         if(this._model.isEnter)
         {
            this.initSceneData();
         }
         else
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      public function initSceneData() : void
      {
         this._mapPath = LoaderCatchInsectUIModule.Instance.getCatchInsectResource() + "/map/CatchInsectMap.swf";
         this._catchInsectInfo.playerDefaultPos = new Point(500,500);
         this._catchInsectInfo.myPlayerVO.playerPos = this._catchInsectInfo.playerDefaultPos;
         this._catchInsectInfo.myPlayerVO.playerStauts = 0;
         LoaderCatchInsectUIModule.Instance.loadMap();
      }
      
      public function reConnectCatchInectFunc() : void
      {
         isToRoom = true;
         SocketManager.Instance.out.requestCakeStatus();
         if(!this.loadUiModuleComplete)
         {
            this.reConnect();
         }
         else
         {
            this.isReConnect = false;
            StateManager.setState(StateType.CATCH_INSECT);
         }
      }
      
      public function reConnect() : void
      {
         this.isReConnect = true;
         LoaderCatchInsectUIModule.Instance.loadUIModule(this.reConnectLoadUiComplete);
      }
      
      private function reConnectLoadUiComplete() : void
      {
         this.loadUiModuleComplete = true;
         SocketManager.Instance.out.enterOrLeaveInsectScene(0);
      }
      
      public function openCheckGeinFrame() : void
      {
         this._checkGeinFrame = ComponentFactory.Instance.creatComponentByStylename("catchInsect.checkGeinFrame");
         LayerManager.Instance.addToLayer(this._checkGeinFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._checkGeinFrame.addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(evt:FrameEvent) : void
      {
         this._checkGeinFrame.removeEventListener(FrameEvent.RESPONSE,this.__response);
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._checkGeinFrame.dispose();
            this._checkGeinFrame = null;
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._model.isOpen = pkg.readBoolean();
         this.showEnterIcon(this._model.isOpen);
      }
      
      public function showEnterIcon(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CATCHINSECT,flag);
         if(flag)
         {
            this._catchInsectInfo = new CatchInsectItemInfo();
            this._catchInsectInfo.myPlayerVO = new PlayerVO();
         }
         else if(StateManager.currentStateType == StateType.CATCH_INSECT)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      public function loaderCatchInsectFrame() : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("catchInsect.Icon.NoEnter"));
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderCatchInsectUIModule.Instance.loadUIModule(this.doOpenCatchInsectFrame);
         }
      }
      
      private function doOpenCatchInsectFrame() : void
      {
         this.loadUiModuleComplete = true;
         if(this._model.isOpen)
         {
            this._chooseRoomFrame = ComponentFactory.Instance.creatComponentByStylename("catchInsect.chooseFrame");
            LayerManager.Instance.addToLayer(this._chooseRoomFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function get catchInsectInfo() : CatchInsectItemInfo
      {
         return this._catchInsectInfo;
      }
      
      public function disposeEnterIcon() : void
      {
         if(Boolean(this._chooseRoomFrame))
         {
            this._chooseRoomFrame.dispose();
            this._chooseRoomFrame = null;
         }
      }
      
      public function exitGame() : void
      {
         GameInSocketOut.sendGamePlayerExit();
      }
      
      public function get model() : CatchInsectModel
      {
         return this._model;
      }
      
      public function get mapPath() : String
      {
         return this._mapPath;
      }
      
      public function get catchInsectIcon() : MovieClip
      {
         return this._catchInsectIcon;
      }
   }
}

