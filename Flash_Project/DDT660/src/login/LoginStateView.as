package login
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.LoginAnalyzer;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.character.BaseLightLayer;
   import ddt.view.character.ILayer;
   import ddt.view.character.LayerFactory;
   import ddt.view.character.ShowCharacterLoader;
   import ddt.view.character.SinpleLightLayer;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import login.view.ChooseRoleFrame;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class LoginStateView extends BaseStateView
   {
      
      private static var w:String = "abcdefghijklmnopqrstuvwxyz";
      
      private var _shape:Shape;
      
      public function LoginStateView()
      {
         super();
      }
      
      public static function creatLoginLoader(nickname:String, callBack:Function) : RequestLoader
      {
         var acc:AccountInfo = PlayerManager.Instance.Account;
         var date:Date = new Date();
         var temp:ByteArray = new ByteArray();
         temp.writeShort(date.fullYearUTC);
         temp.writeByte(date.monthUTC + 1);
         temp.writeByte(date.dateUTC);
         temp.writeByte(date.hoursUTC);
         temp.writeByte(date.minutesUTC);
         temp.writeByte(date.secondsUTC);
         var tempPassword:String = "";
         for(var i:int = 0; i < 6; i++)
         {
            tempPassword += w.charAt(int(Math.random() * 26));
         }
         temp.writeUTFBytes(acc.Account + "," + acc.Password + "," + tempPassword + "," + nickname);
         var p:String = CrytoUtils.rsaEncry4(acc.Key,temp);
         var variables:URLVariables = RequestVairableCreater.creatWidthKey(false);
         variables["p"] = p;
         variables["v"] = Version.Build;
         variables["site"] = PathManager.solveConfigSite();
         variables["rid"] = PlayerManager.Instance.Self.rid;
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("Login.ashx"),BaseLoader.REQUEST_LOADER,variables);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,__onLoadLoginError);
         var analyzer:LoginAnalyzer = new LoginAnalyzer(callBack);
         analyzer.tempPassword = tempPassword;
         loader.analyzer = analyzer;
         return loader;
      }
      
      private static function __onLoadLoginError(event:LoaderEvent) : void
      {
         LeavePageManager.leaveToLoginPurely();
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = (event.loader.loadErrorMessage == null ? "" : event.loader.loadErrorMessage + "\n") + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert("警告：",msg,"確 認");
         alert.addEventListener(FrameEvent.RESPONSE,__onAlertResponse);
      }
      
      private static function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private static function onLoginComplete(analyzer:LoginAnalyzer) : void
      {
         var perloader:ShowCharacterLoader = new ShowCharacterLoader(PlayerManager.Instance.Self);
         perloader.needMultiFrames = false;
         perloader.setFactory(LayerFactory.instance);
         perloader.load(onPreLoadComplete);
         var light:BaseLightLayer = new BaseLightLayer(PlayerManager.Instance.Self.Nimbus);
         light.load(onLayerComplete);
         var sinple:SinpleLightLayer = new SinpleLightLayer(PlayerManager.Instance.Self.Nimbus);
         sinple.load(onLayerComplete);
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && !StartupResourceLoader.firstEnterHall)
         {
            StartupResourceLoader.Instance.addEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE,onUserGuildResourceComplete);
            StartupResourceLoader.Instance.addUserGuildResource();
         }
         else if(ServerManager.Instance.canAutoLogin())
         {
            ServerManager.Instance.connentCurrentServer();
         }
         else
         {
            StartupResourceLoader.Instance.finishLoadingProgress();
         }
      }
      
      private static function onUserGuildResourceComplete(evt:Event) : void
      {
         StartupResourceLoader.Instance.removeEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE,onUserGuildResourceComplete);
         if(ServerManager.Instance.canAutoLogin())
         {
            ServerManager.Instance.connentCurrentServer();
         }
         else
         {
            StartupResourceLoader.Instance.finishLoadingProgress();
         }
      }
      
      private static function onLayerComplete(layer:ILayer) : void
      {
         layer.dispose();
      }
      
      private static function onPreLoadComplete(loader:ShowCharacterLoader) : void
      {
         loader.destory();
      }
      
      override public function getType() : String
      {
         return StateType.LOGIN;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         this._shape = new Shape();
         this._shape.graphics.beginFill(0,1);
         this._shape.graphics.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         this._shape.graphics.endFill();
         addChild(this._shape);
         if(SelectListManager.Instance.mustShowSelectWindow)
         {
            this.loadLoginRes();
         }
         else
         {
            this.loginCurrentRole();
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         super.leaving(next);
         if(Boolean(this._shape))
         {
            ObjectUtils.disposeObject(this._shape);
         }
         this._shape = null;
      }
      
      private function __onShareAlertResponse(event:FrameEvent) : void
      {
         LoaderSavingManager.loadFilesInLocal();
         if(LoaderSavingManager.ReadShareError)
         {
            MessageTipManager.getInstance().show("请清除缓存后再重新登录");
         }
         else
         {
            LeavePageManager.leaveToLoginPath();
         }
      }
      
      private function loadLoginRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LOGIN);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onLoginResComplete(evt:UIModuleEvent) : void
      {
         var chooseRoleFrame:ChooseRoleFrame = null;
         if(evt.module == UIModuleTypes.LOGIN)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
            UIModuleSmallLoading.Instance.hide();
            chooseRoleFrame = ComponentFactory.Instance.creatComponentByStylename("ChooseRoleFrame");
            chooseRoleFrame.addEventListener(Event.COMPLETE,this.__onChooseRoleComplete);
            LayerManager.Instance.addToLayer(chooseRoleFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
            NoviceDataManager.instance.saveNoviceData(210,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      private function __onLoginResError(evt:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
      }
      
      private function loginCurrentRole() : void
      {
         var loader:RequestLoader = creatLoginLoader(SelectListManager.Instance.currentLoginRole.NickName,onLoginComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __onChooseRoleComplete(event:Event) : void
      {
         var chooseRoleFrame:ChooseRoleFrame = event.currentTarget as ChooseRoleFrame;
         chooseRoleFrame.removeEventListener(Event.COMPLETE,this.__onChooseRoleComplete);
         chooseRoleFrame.dispose();
         this.loginCurrentRole();
      }
   }
}

