package ddt.manager
{
   import baglocked.BaglockedManager;
   import campbattle.CampBattleManager;
   import church.events.WeddingRoomEvent;
   import church.view.ChurchAlertFrame;
   import church.view.weddingRoom.frame.WeddingRoomGiftFrameView;
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.ServerInfo;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ChargePackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import ddt.view.common.church.ChurchDialogueAgreePropose;
   import ddt.view.common.church.ChurchDialogueRejectPropose;
   import ddt.view.common.church.ChurchDialogueUnmarried;
   import ddt.view.common.church.ChurchInviteFrame;
   import ddt.view.common.church.ChurchMarryApplySuccess;
   import ddt.view.common.church.ChurchProposeFrame;
   import ddt.view.common.church.ChurchProposeResponseFrame;
   import ddtBuried.BuriedManager;
   import email.manager.MailManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import luckStar.manager.LuckStarManager;
   import road7th.comm.PackageIn;
   import road7th.utils.StringHelper;
   
   public class ChurchManager extends EventDispatcher
   {
      
      private static var _instance:ChurchManager;
      
      private static const WEDDING_SCENE:Boolean = false;
      
      private static const MOON_SCENE:Boolean = true;
      
      public static const CIVIL_PLAYER_INFO_MODIFY:String = "civilplayerinfomodify";
      
      public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
      
      public static const SUBMIT_REFUND:String = "submitRefund";
      
      private var _currentScene:Boolean = false;
      
      private var _churchDialogueUnmarried:ChurchDialogueUnmarried;
      
      private var _churchProposeFrame:ChurchProposeFrame;
      
      private var _proposeResposeFrame:ChurchProposeResponseFrame;
      
      private var _churchMarryApplySuccess:ChurchMarryApplySuccess;
      
      private var _alertMarried:BaseAlerFrame;
      
      public var _weddingSuccessfulComplete:Boolean;
      
      public var _selfRoom:ChurchRoomInfo;
      
      private var _currentRoom:ChurchRoomInfo;
      
      private var _mapLoader01:BaseLoader;
      
      private var _mapLoader02:BaseLoader;
      
      private var _isRemoveLoading:Boolean = true;
      
      private var _userID:int;
      
      public var isUnwedding:Boolean;
      
      private var money:int;
      
      private var _weddingRoomGiftFrameView:WeddingRoomGiftFrameView;
      
      private var marryApplyList:Array = new Array();
      
      private var _churchDialogueAgreePropose:ChurchDialogueAgreePropose;
      
      private var _churchDialogueRejectPropose:ChurchDialogueRejectPropose;
      
      private var unwedingmsg:String;
      
      private var _linkServerInfo:ServerInfo;
      
      public function ChurchManager()
      {
         super();
      }
      
      public static function get instance() : ChurchManager
      {
         if(!_instance)
         {
            _instance = new ChurchManager();
         }
         return _instance;
      }
      
      public function get currentScene() : Boolean
      {
         return this._currentScene;
      }
      
      public function set currentScene(value:Boolean) : void
      {
         if(this._currentScene == value)
         {
            return;
         }
         this._currentScene = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.SCENE_CHANGE,this._currentScene));
      }
      
      public function get selfRoom() : ChurchRoomInfo
      {
         return this._selfRoom;
      }
      
      public function set selfRoom(value:ChurchRoomInfo) : void
      {
         this._selfRoom = value;
      }
      
      public function set currentRoom(value:ChurchRoomInfo) : void
      {
         if(this._currentRoom == value)
         {
            return;
         }
         this._currentRoom = value;
         this.onChurchRoomInfoChange();
      }
      
      public function get currentRoom() : ChurchRoomInfo
      {
         return this._currentRoom;
      }
      
      private function onChurchRoomInfoChange() : void
      {
         if(this._currentRoom != null)
         {
            this.loadMap();
         }
      }
      
      public function loadMap() : void
      {
         this._mapLoader01 = LoadResourceManager.Instance.createLoader(PathManager.solveChurchSceneSourcePath("Map01"),BaseLoader.MODULE_LOADER);
         this._mapLoader01.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoadResourceManager.Instance.startLoad(this._mapLoader01);
         this._mapLoader02 = LoadResourceManager.Instance.createLoader(PathManager.solveChurchSceneSourcePath("Map02"),BaseLoader.MODULE_LOADER);
         this._mapLoader02.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoadResourceManager.Instance.startLoad(this._mapLoader02);
      }
      
      protected function onMapSrcLoadedComplete(event:LoaderEvent = null) : void
      {
         if(this._mapLoader01.isSuccess && this._mapLoader02.isSuccess)
         {
            this.tryLoginScene();
         }
      }
      
      public function tryLoginScene() : void
      {
         if(StateManager.getState(StateType.CHURCH_ROOM) == null)
         {
            this._isRemoveLoading = false;
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsClose);
         }
         StateManager.setState(StateType.CHURCH_ROOM);
      }
      
      private function __loadingIsClose(event:Event) : void
      {
         this._isRemoveLoading = true;
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         SocketManager.Instance.out.sendExitRoom();
      }
      
      public function removeLoadingEvent() : void
      {
         if(!this._isRemoveLoading)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         }
      }
      
      public function closeRefundView() : void
      {
         if(Boolean(this._weddingRoomGiftFrameView))
         {
            if(Boolean(this._weddingRoomGiftFrameView.parent))
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.dispose();
            this._weddingRoomGiftFrameView = null;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,this.__roomLogin);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_STATE,this.__updateSelfRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_STATUS,this.__showPropose);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY,this.__marryApply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY_REPLY,this.__marryApplyReply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIVORCE_APPLY,this.__divorceApply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE,this.__churchInvite);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYPROP_GET,this.__marryPropGet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AMARRYINFO_REFRESH,this.__upCivilPlayerView);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYINFO_GET,this.__getMarryInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYROOMSENDGIFT,this.__showGiftView);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REQUEST_FRIENDS_PAY,this.reqeustPayHander);
         this.addEventListener(ChurchManager.SUBMIT_REFUND,this.__onSubmitRefund);
      }
      
      private function reqeustPayHander(e:CrazyTankSocketEvent) : void
      {
         var name:String = null;
         var cmd:int = e.pkg.readByte();
         if(cmd == ChargePackageType.Request_For_Divorce)
         {
            this.isUnwedding = true;
            this._userID = e.pkg.readInt();
            name = e.pkg.readUTF();
            this.money = e.pkg.readInt();
            this.unwedingmsg = LanguageMgr.GetTranslation("ddt.friendPay.action",name,this.money);
            if(!CampBattleManager.instance.model.isFighting)
            {
               this.openAlert();
            }
         }
      }
      
      public function openAlert() : void
      {
         this.isUnwedding = false;
         var confirmFrame:ChurchAlertFrame = ComponentFactory.Instance.creat("church.view.ChurchAlertFrame");
         confirmFrame.setTxt(this.unwedingmsg);
         LayerManager.Instance.addToLayer(confirmFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.reponseHander);
      }
      
      private function reponseHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(BuriedManager.Instance.checkMoney(false,this.money))
            {
               return;
            }
            SocketManager.Instance.out.isAcceptPay(true,this._userID);
         }
         else if(e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SocketManager.Instance.out.isAcceptPay(false,this._userID);
         }
         var confirmFrame:ChurchAlertFrame = e.currentTarget as ChurchAlertFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reponseHander);
         confirmFrame.dispose();
         confirmFrame = null;
      }
      
      private function __onSubmitRefund(e:Event) : void
      {
         SocketManager.Instance.out.refund();
      }
      
      private function __upCivilPlayerView(e:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.MarryInfoID = e.pkg.readInt();
         var note:Boolean = e.pkg.readBoolean();
         if(note)
         {
            PlayerManager.Instance.Self.ID = e.pkg.readInt();
            PlayerManager.Instance.Self.IsPublishEquit = e.pkg.readBoolean();
            PlayerManager.Instance.Self.Introduction = e.pkg.readUTF();
         }
         dispatchEvent(new Event(CIVIL_PLAYER_INFO_MODIFY));
      }
      
      private function __getMarryInfo(e:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.Introduction = e.pkg.readUTF();
         PlayerManager.Instance.Self.IsPublishEquit = e.pkg.readBoolean();
         dispatchEvent(new Event(CIVIL_SELFINFO_CHANGE));
      }
      
      public function __showPropose(event:CrazyTankSocketEvent) : void
      {
         var spouseID:int = event.pkg.readInt();
         var isMarried:Boolean = event.pkg.readBoolean();
         if(isMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.married"));
         }
         else if(PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.youMarried"));
         }
         else
         {
            this._churchProposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeFrame");
            this._churchProposeFrame.addEventListener(Event.CLOSE,this.churchProposeFrameClose);
            this._churchProposeFrame.spouseID = spouseID;
            this._churchProposeFrame.show();
         }
      }
      
      private function __showGiftView(e:CrazyTankSocketEvent) : void
      {
         e.pkg.readByte();
         var needTotalMoney:int = e.pkg.readInt();
         if(Boolean(this._weddingRoomGiftFrameView))
         {
            if(Boolean(this._weddingRoomGiftFrameView.parent))
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.dispose();
            this._weddingRoomGiftFrameView = null;
         }
         else
         {
            this._weddingRoomGiftFrameView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameView");
            this._weddingRoomGiftFrameView.addEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.txtMoney = needTotalMoney.toString();
            this._weddingRoomGiftFrameView.show();
         }
      }
      
      private function closeRoomGift(evt:Event = null) : void
      {
         if(Boolean(this._weddingRoomGiftFrameView))
         {
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            if(Boolean(this._weddingRoomGiftFrameView.parent))
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.dispose();
         }
         this._weddingRoomGiftFrameView = null;
      }
      
      private function churchProposeFrameClose(evt:Event) : void
      {
         if(Boolean(this._churchProposeFrame))
         {
            this._churchProposeFrame.removeEventListener(Event.CLOSE,this.churchProposeFrameClose);
            if(Boolean(this._churchProposeFrame.parent))
            {
               this._churchProposeFrame.parent.removeChild(this._churchProposeFrame);
            }
         }
         this._churchProposeFrame = null;
      }
      
      private function __marryApply(event:CrazyTankSocketEvent) : void
      {
         var spouseID:int = event.pkg.readInt();
         var spouseName:String = event.pkg.readUTF();
         var str:String = event.pkg.readUTF();
         var answerId:int = event.pkg.readInt();
         if(spouseID == PlayerManager.Instance.Self.ID)
         {
            this._churchMarryApplySuccess = ComponentFactory.Instance.creat("common.church.ChurchMarryApplySuccess");
            this._churchMarryApplySuccess.addEventListener(Event.CLOSE,this.churchMarryApplySuccessClose);
            this._churchMarryApplySuccess.show();
            return;
         }
         if(this.checkMarryApplyList(answerId))
         {
            return;
         }
         this.marryApplyList.push(answerId);
         SoundManager.instance.play("018");
         this._proposeResposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeResponseFrame");
         this._proposeResposeFrame.addEventListener(Event.CLOSE,this.ProposeResposeFrameClose);
         this._proposeResposeFrame.spouseID = spouseID;
         this._proposeResposeFrame.spouseName = spouseName;
         this._proposeResposeFrame.answerId = answerId;
         this._proposeResposeFrame.love = str;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._proposeResposeFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND));
         }
         else if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this._proposeResposeFrame.show));
         }
         else if(StateManager.currentStateType == "login")
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(this._proposeResposeFrame.show));
         }
         else
         {
            this._proposeResposeFrame.show();
         }
      }
      
      private function checkMarryApplyList(id:int) : Boolean
      {
         for(var i:int = 0; i < this.marryApplyList.length; i++)
         {
            if(id == this.marryApplyList[i])
            {
               return true;
            }
         }
         return false;
      }
      
      private function churchMarryApplySuccessClose(evt:Event) : void
      {
         if(Boolean(this._churchMarryApplySuccess))
         {
            this._churchMarryApplySuccess.removeEventListener(Event.CLOSE,this.churchMarryApplySuccessClose);
            if(Boolean(this._churchMarryApplySuccess.parent))
            {
               this._churchMarryApplySuccess.parent.removeChild(this._churchMarryApplySuccess);
            }
            this._churchMarryApplySuccess.dispose();
         }
         this._churchMarryApplySuccess = null;
      }
      
      private function ProposeResposeFrameClose(evt:Event) : void
      {
         if(Boolean(this._proposeResposeFrame))
         {
            this._proposeResposeFrame.removeEventListener(Event.CLOSE,this.ProposeResposeFrameClose);
            if(Boolean(this._proposeResposeFrame.parent))
            {
               this._proposeResposeFrame.parent.removeChild(this._proposeResposeFrame);
            }
            this._proposeResposeFrame.dispose();
         }
         this._proposeResposeFrame = null;
      }
      
      private function __marryApplyReply(event:CrazyTankSocketEvent) : void
      {
         var msg:ChatData = null;
         var msgTxt:String = null;
         var spouseID:int = event.pkg.readInt();
         var result:Boolean = event.pkg.readBoolean();
         var spouseName:String = event.pkg.readUTF();
         var isApplicant:Boolean = event.pkg.readBoolean();
         if(result)
         {
            PlayerManager.Instance.Self.IsMarried = true;
            PlayerManager.Instance.Self.SpouseID = spouseID;
            PlayerManager.Instance.Self.SpouseName = spouseName;
            TaskManager.instance.onMarriaged();
            TaskManager.instance.requestCanAcceptTask();
            if(PathManager.solveExternalInterfaceEnabel())
            {
               ExternalInterfaceManager.sendToAgent(7,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,"",spouseName);
            }
         }
         if(isApplicant)
         {
            msg = new ChatData();
            msgTxt = "";
            if(result)
            {
               msg.channel = ChatInputView.SYS_NOTICE;
               msgTxt = "<" + spouseName + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.isApplicant");
               this._churchDialogueAgreePropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueAgreePropose");
               this._churchDialogueAgreePropose.msgInfo = spouseName;
               this._churchDialogueAgreePropose.addEventListener(Event.CLOSE,this.churchDialogueAgreeProposeClose);
               if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
               {
                  CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this._churchDialogueAgreePropose));
               }
               else
               {
                  this._churchDialogueAgreePropose.show();
               }
            }
            else
            {
               msg.channel = ChatInputView.SYS_TIP;
               msgTxt = "<" + spouseName + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuseMarry");
               if(Boolean(this._churchDialogueRejectPropose))
               {
                  this._churchDialogueRejectPropose.dispose();
                  this._churchDialogueRejectPropose = null;
               }
               this._churchDialogueRejectPropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueRejectPropose");
               this._churchDialogueRejectPropose.msgInfo = spouseName;
               this._churchDialogueRejectPropose.addEventListener(Event.CLOSE,this.churchDialogueRejectProposeClose);
               if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
               {
                  CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._churchDialogueRejectPropose,LayerManager.GAME_DYNAMIC_LAYER,LayerManager.BLCAK_BLOCKGOUND,"018",true));
               }
               else
               {
                  this._churchDialogueRejectPropose.show();
               }
            }
            msg.msg = StringHelper.rePlaceHtmlTextField(msgTxt);
            ChatManager.Instance.chat(msg);
         }
         else if(result)
         {
            this._alertMarried = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.youAndOtherMarried",spouseName),LanguageMgr.GetTranslation("ok"),"",false,false,false,0,CacheConsts.ALERT_IN_FIGHT);
            this._alertMarried.addEventListener(FrameEvent.RESPONSE,this.marriedResponse);
         }
      }
      
      private function marriedResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(Boolean(this._alertMarried))
               {
                  if(Boolean(this._alertMarried.parent))
                  {
                     this._alertMarried.parent.removeChild(this._alertMarried);
                  }
                  this._alertMarried.dispose();
               }
               this._alertMarried = null;
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function churchDialogueRejectProposeClose(evt:Event) : void
      {
         if(Boolean(this._churchDialogueRejectPropose))
         {
            this._churchDialogueRejectPropose.removeEventListener(Event.CLOSE,this.churchDialogueRejectProposeClose);
            if(Boolean(this._churchDialogueRejectPropose.parent))
            {
               this._churchDialogueRejectPropose.parent.removeChild(this._churchDialogueRejectPropose);
            }
            this._churchDialogueRejectPropose.dispose();
         }
         this._churchDialogueRejectPropose = null;
      }
      
      private function churchDialogueAgreeProposeClose(evt:Event) : void
      {
         if(Boolean(this._churchDialogueAgreePropose))
         {
            this._churchDialogueAgreePropose.removeEventListener(Event.CLOSE,this.churchDialogueAgreeProposeClose);
            if(Boolean(this._churchDialogueAgreePropose.parent))
            {
               this._churchDialogueAgreePropose.parent.removeChild(this._churchDialogueAgreePropose);
            }
            this._churchDialogueAgreePropose.dispose();
         }
         this._churchDialogueAgreePropose = null;
      }
      
      private function __divorceApply(event:CrazyTankSocketEvent) : void
      {
         var result:Boolean = event.pkg.readBoolean();
         var isActive:Boolean = event.pkg.readBoolean();
         if(!result)
         {
            return;
         }
         PlayerManager.Instance.Self.IsMarried = false;
         PlayerManager.Instance.Self.SpouseID = 0;
         PlayerManager.Instance.Self.SpouseName = "";
         ChurchManager.instance.selfRoom = null;
         if(!isActive)
         {
            SoundManager.instance.play("018");
            this._churchDialogueUnmarried = ComponentFactory.Instance.creat("ddt.common.church.ChurchDialogueUnmarried");
            if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._churchDialogueUnmarried,LayerManager.GAME_DYNAMIC_LAYER,LayerManager.BLCAK_BLOCKGOUND));
            }
            else if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this._churchDialogueUnmarried.show));
            }
            else
            {
               this._churchDialogueUnmarried.show();
            }
            this._churchDialogueUnmarried.addEventListener(Event.CLOSE,this.churchDialogueUnmarriedClose);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.divorce"));
         }
         PlayerManager.Instance.Self.isFirstDivorce = 1;
         if(StateManager.currentStateType == StateType.CHURCH_ROOM && (this.currentRoom.brideID == PlayerManager.Instance.Self.ID || this.currentRoom.createID == PlayerManager.Instance.Self.ID))
         {
            StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
         }
      }
      
      private function churchDialogueUnmarriedClose(evt:Event) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._churchDialogueUnmarried))
         {
            this._churchDialogueUnmarried.removeEventListener(Event.CLOSE,this.churchDialogueUnmarriedClose);
            if(Boolean(this._churchDialogueUnmarried.parent))
            {
               this._churchDialogueUnmarried.parent.removeChild(this._churchDialogueUnmarried);
            }
            this._churchDialogueUnmarried.dispose();
         }
         this._churchDialogueUnmarried = null;
      }
      
      private function __churchInvite(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var obj:Object = null;
         var invitePanel:ChurchInviteFrame = null;
         if(InviteManager.Instance.enabled)
         {
            pkg = event.pkg;
            obj = new Object();
            obj["inviteID"] = pkg.readInt();
            obj["inviteName"] = pkg.readUTF();
            obj["IsVip"] = pkg.readBoolean();
            obj["VIPLevel"] = pkg.readInt();
            obj["roomID"] = pkg.readInt();
            obj["roomName"] = pkg.readUTF();
            obj["pwd"] = pkg.readUTF();
            obj["sceneIndex"] = pkg.readInt();
            if(BuriedManager.Instance.isOpening)
            {
               return;
            }
            if(LuckStarManager.Instance.openState)
            {
               return;
            }
            if(PlayerManager.Instance.Self.playerState.StateID == 6)
            {
               return;
            }
            invitePanel = ComponentFactory.Instance.creatComponentByStylename("common.church.ChurchInviteFrame");
            invitePanel.msgInfo = obj;
            invitePanel.show();
            SoundManager.instance.play("018");
         }
      }
      
      private function __marryPropGet(event:CrazyTankSocketEvent) : void
      {
         var room:ChurchRoomInfo = null;
         var pkg:PackageIn = event.pkg;
         PlayerManager.Instance.Self.IsMarried = pkg.readBoolean();
         PlayerManager.Instance.Self.SpouseID = pkg.readInt();
         PlayerManager.Instance.Self.SpouseName = pkg.readUTF();
         var isCreatedMarryRoom:Boolean = pkg.readBoolean();
         var roomID:int = pkg.readInt();
         var isGotRing:Boolean = pkg.readBoolean();
         PlayerManager.Instance.Self.IsGotRing = isGotRing;
         if(isCreatedMarryRoom)
         {
            if(!ChurchManager.instance.selfRoom)
            {
               room = new ChurchRoomInfo();
               room.id = roomID;
               ChurchManager.instance.selfRoom = room;
            }
         }
         else
         {
            ChurchManager.instance.selfRoom = null;
         }
      }
      
      private function __roomLogin(event:CrazyTankSocketEvent) : void
      {
         var failType:int = 0;
         var roomId:int = 0;
         var msg:String = null;
         var _tipsMarryRoomframe:Frame = null;
         var pkg:PackageIn = event.pkg;
         var result:Boolean = pkg.readBoolean();
         if(!result)
         {
            failType = pkg.readInt();
            if(MailManager.Instance.linkChurchRoomId != -1 && (failType == 5 || failType == 6))
            {
               StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
               MailManager.Instance.hide();
            }
            else if(failType == 7)
            {
               roomId = pkg.readInt();
               this._linkServerInfo = ServerManager.Instance.getServerInfoByID(roomId);
               if(Boolean(this._linkServerInfo))
               {
                  msg = LanguageMgr.GetTranslation("ddt.church.serverInFail",this._linkServerInfo.Name,MailManager.Instance.linkChurchRoomId);
                  _tipsMarryRoomframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),msg,"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
                  _tipsMarryRoomframe.addEventListener(FrameEvent.RESPONSE,this.__tipsMarryRoomframeResponse);
               }
               else
               {
                  MailManager.Instance.linkChurchRoomId = -1;
               }
            }
            else
            {
               MailManager.Instance.linkChurchRoomId = -1;
            }
            return;
         }
         MailManager.Instance.linkChurchRoomId = -1;
         var room:ChurchRoomInfo = new ChurchRoomInfo();
         room.id = pkg.readInt();
         room.roomName = pkg.readUTF();
         room.mapID = pkg.readInt();
         room.valideTimes = pkg.readInt();
         room.currentNum = pkg.readInt();
         room.createID = pkg.readInt();
         room.createName = pkg.readUTF();
         room.groomID = pkg.readInt();
         room.groomName = pkg.readUTF();
         room.brideID = pkg.readInt();
         room.brideName = pkg.readUTF();
         room.creactTime = pkg.readDate();
         room.isStarted = pkg.readBoolean();
         var statu:int = pkg.readByte();
         if(statu == 1)
         {
            room.status = ChurchRoomInfo.WEDDING_NONE;
         }
         else
         {
            room.status = ChurchRoomInfo.WEDDING_ING;
         }
         room.discription = pkg.readUTF();
         room.canInvite = pkg.readBoolean();
         var sceneIndex:int = pkg.readInt();
         ChurchManager.instance.currentScene = sceneIndex == 1 ? false : true;
         room.isUsedSalute = pkg.readBoolean();
         this.currentRoom = room;
         if(this.isAdmin(PlayerManager.Instance.Self))
         {
            this.selfRoom = room;
         }
      }
      
      private function __tipsMarryRoomframeResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            ServerManager.Instance.current = this._linkServerInfo;
            ServerManager.Instance.connentCurrentServer();
            ServerManager.Instance.dispatchEvent(new Event(ServerManager.CHANGE_SERVER));
         }
         else
         {
            MailManager.Instance.linkChurchRoomId = -1;
         }
         this._linkServerInfo = null;
         var _tipsframe:Frame = Frame(evt.currentTarget);
         _tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__tipsMarryRoomframeResponse);
         ObjectUtils.disposeAllChildren(_tipsframe);
         ObjectUtils.disposeObject(_tipsframe);
         _tipsframe = null;
      }
      
      private function __updateSelfRoom(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var userID:int = pkg.readInt();
         var state:Boolean = pkg.readBoolean();
         if(!state)
         {
            this.selfRoom = null;
            return;
         }
         if(this.selfRoom == null)
         {
            this.selfRoom = new ChurchRoomInfo();
         }
         this.selfRoom.id = pkg.readInt();
         this.selfRoom.roomName = pkg.readUTF();
         this.selfRoom.mapID = pkg.readInt();
         this.selfRoom.valideTimes = pkg.readInt();
         this.selfRoom.createID = pkg.readInt();
         this.selfRoom.groomID = pkg.readInt();
         this.selfRoom.brideID = pkg.readInt();
         this.selfRoom.creactTime = pkg.readDate();
         this.selfRoom.isUsedSalute = pkg.readBoolean();
      }
      
      public function __removePlayer(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.clientId;
         if(id == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
         }
      }
      
      public function isAdmin(info:PlayerInfo) : Boolean
      {
         if(Boolean(this._currentRoom) && Boolean(info))
         {
            return info.ID == this._currentRoom.groomID || info.ID == this._currentRoom.brideID;
         }
         return false;
      }
      
      public function sendValidateMarry(info:BasePlayer) : void
      {
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notLvWoo"));
         }
         else if(info.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notOtherLvWoo"));
         }
         else if(PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.IsMarried"));
         }
         else if(PlayerManager.Instance.Self.Sex == info.Sex)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notAllow"));
         }
         else if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         else
         {
            SocketManager.Instance.out.sendValidateMarry(info.ID);
         }
      }
   }
}

