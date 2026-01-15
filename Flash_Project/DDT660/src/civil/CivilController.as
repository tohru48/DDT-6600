package civil
{
   import cityWide.CityWideManager;
   import civil.view.CivilRegisterFrame;
   import civil.view.CivilView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.CivilMemberListAnalyze;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.net.URLVariables;
   
   public class CivilController extends BaseStateView
   {
      
      private var _model:CivilModel;
      
      private var _view:CivilView;
      
      private var _register:CivilRegisterFrame;
      
      public function CivilController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         SocketManager.Instance.out.sendCurrentState(1);
         this.init(data);
         MainToolBar.Instance.show();
      }
      
      private function init(entered:Boolean = true) : void
      {
         this._model = new CivilModel(entered);
         this.loadCivilMemberList(1,!PlayerManager.Instance.Self.Sex);
         this._model.sex = !PlayerManager.Instance.Self.Sex;
         this._view = new CivilView(this,this._model);
         addChild(this._view);
         CityWideManager.Instance.toSendOpenCityWide();
      }
      
      override public function dispose() : void
      {
         this._model.dispose();
         this._model = null;
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         if(Boolean(this._register))
         {
            this._register.removeEventListener(Event.COMPLETE,this.__onRegisterComplete);
            this._register.dispose();
            this._register = null;
         }
      }
      
      public function Register() : void
      {
         this._register = ComponentFactory.Instance.creatComponentByStylename("civil.register.CivilRegisterFrame");
         this._register.model = this._model;
         this._register.addEventListener(Event.COMPLETE,this.__onRegisterComplete);
         LayerManager.Instance.addToLayer(this._register,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onRegisterComplete(evt:Event) : void
      {
         this._register.removeEventListener(Event.COMPLETE,this.__onRegisterComplete);
         ObjectUtils.disposeObject(this._register);
         this._register = null;
      }
      
      public function get currentcivilInfo() : CivilPlayerInfo
      {
         if(Boolean(this._model))
         {
            return this._model.currentcivilItemInfo;
         }
         return null;
      }
      
      public function set currentcivilInfo(value:CivilPlayerInfo) : void
      {
         if(Boolean(this._model))
         {
            this._model.currentcivilItemInfo = value;
         }
      }
      
      public function upLeftView(info:CivilPlayerInfo) : void
      {
         if(Boolean(this._model))
         {
            this._model.currentcivilItemInfo = info;
         }
      }
      
      public function loadCivilMemberList(page:int = 0, sex:Boolean = true, name:String = "") : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = page;
         args["name"] = name;
         args["sex"] = sex;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MarryInfoPageList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.infoError");
         loader.analyzer = new CivilMemberListAnalyze(this.__loadCivilMemberList);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("aler"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function __loadCivilMemberList(action:CivilMemberListAnalyze) : void
      {
         if(Boolean(this._model))
         {
            if(this._model.TotalPage != action._totalPage)
            {
               this._model.TotalPage = action._totalPage;
            }
            this._model.civilPlayers = action.civilMemberList;
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(next);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.CIVIL;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}

