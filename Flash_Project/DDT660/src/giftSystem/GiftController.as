package giftSystem
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.RequestVairableCreater;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLVariables;
   import giftSystem.analyze.RecordAnalyzer;
   import giftSystem.data.RecordInfo;
   import giftSystem.view.ClearingInterface;
   
   public class GiftController extends EventDispatcher
   {
      
      private static var _instance:GiftController;
      
      public static const RECEIVEDPATH:String = "GiftRecieveLog.ashx";
      
      public static const SENDEDPATH:String = "GiftSendLog.ashx";
      
      private var _recordInfo:RecordInfo;
      
      private var _rebackName:String = "";
      
      private var _alertFrame:BaseAlerFrame;
      
      private var _canActive:Boolean;
      
      private var _path:String;
      
      private var _inChurch:Boolean;
      
      private var _CI:ClearingInterface;
      
      public function GiftController(target:IEventDispatcher = null)
      {
         super(target);
         this.initEvent();
      }
      
      public static function get Instance() : GiftController
      {
         if(_instance == null)
         {
            _instance = new GiftController();
         }
         return _instance;
      }
      
      public function get canActive() : Boolean
      {
         return this._canActive;
      }
      
      public function set canActive(value:Boolean) : void
      {
         this._canActive = value;
      }
      
      public function get inChurch() : Boolean
      {
         return this._inChurch;
      }
      
      public function set inChurch(value:Boolean) : void
      {
         this._inChurch = value;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_SEND_GIFTS,this.__sendStatus);
         BagAndInfoManager.Instance.addEventListener(Event.CLOSE,this.__bagCloseHandler);
      }
      
      private function __sendStatus(event:CrazyTankSocketEvent) : void
      {
         var sended:Boolean = event.pkg.readBoolean();
         if(sended)
         {
            this.loadRecord(SENDEDPATH,PlayerManager.Instance.Self.ID);
         }
         dispatchEvent(new GiftEvent(GiftEvent.SEND_GIFT_RETURN,sended.toString()));
      }
      
      public function loadRecord(path:String, userID:int) : void
      {
         this._path = path;
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["userID"] = userID;
         var record:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(path),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         record.loadErrorMessage = LanguageMgr.GetTranslation("ddt.giftSystem.loadRecord.error");
         record.analyzer = new RecordAnalyzer(this.__setupRecord);
         record.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(record);
      }
      
      public function get recordInfo() : RecordInfo
      {
         return this._recordInfo;
      }
      
      private function __setupRecord(analyzer:RecordAnalyzer) : void
      {
         this._recordInfo = analyzer.info;
         dispatchEvent(new GiftEvent(GiftEvent.LOAD_RECORD_COMPLETE,this._path));
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get rebackName() : String
      {
         return this._rebackName;
      }
      
      public function set rebackName(value:String) : void
      {
         if(this._rebackName == value)
         {
            return;
         }
         this._rebackName = value;
      }
      
      public function RebackClick(value:String) : void
      {
         this.rebackName = value;
         this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.giftSystem.RebackMenu.alert",this.rebackName),LanguageMgr.GetTranslation("ok"),"",false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__responsehandler);
      }
      
      private function __responsehandler(event:FrameEvent) : void
      {
         if(Boolean(this._alertFrame))
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
            this._alertFrame.dispose();
            this._alertFrame = null;
            dispatchEvent(new GiftEvent(GiftEvent.REBACK_GIFT));
         }
      }
      
      public function openClearingInterface(info:ShopItemInfo) : void
      {
         this._CI = null;
         this._CI = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface");
         this._CI.setName(this._rebackName);
         this._CI.info = info;
         LayerManager.Instance.addToLayer(this._CI,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __bagCloseHandler(event:Event) : void
      {
         if(Boolean(this._alertFrame))
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
            this._alertFrame.dispose();
            this._alertFrame = null;
         }
      }
   }
}

