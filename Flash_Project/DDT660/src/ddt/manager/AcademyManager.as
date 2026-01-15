package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.AcademyMemberListAnalyze;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.AcademyPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.academyCommon.data.SimpleMessger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class AcademyManager extends EventDispatcher
   {
      
      private static var _instance:AcademyManager;
      
      public static const SELF_DESCRIBE:String = "selfDescribe";
      
      public static const LEVEL_GAP:int = 5;
      
      public static const TARGET_PLAYER_MIN_LEVEL:int = 12;
      
      public static const FARM_PLAYER_MIN_LEVEL:int = 25;
      
      public static const ACADEMY_LEVEL_MIN:int = 21;
      
      public static const ACADEMY_LEVEL_MAX:int = 20;
      
      public static const RECOMMEND_MAX_NUM:int = 3;
      
      public static const GRADUATE_NUM:Array = [1,5,10,50,99];
      
      public static const MASTER:Boolean = false;
      
      public static const APPSHIP:Boolean = true;
      
      public static const ACADEMY:Boolean = true;
      
      public static const RECOMMEND:Boolean = false;
      
      public static const NONE_STATE:int = 0;
      
      public static const APPRENTICE_STATE:int = 1;
      
      public static const MASTER_STATE:int = 2;
      
      public static const MASTER_FULL_STATE:int = 3;
      
      public var isShowRecommend:Boolean = true;
      
      public var freezesDate:Date;
      
      public var selfIsRegister:Boolean;
      
      public var isSelfPublishEquip:Boolean;
      
      private var _showMessage:Boolean = true;
      
      private var _recommendPlayers:Vector.<AcademyPlayerInfo>;
      
      private var _myAcademyPlayers:DictionaryData;
      
      private var _messgers:Vector.<SimpleMessger>;
      
      private var _selfDescribe:String;
      
      public function AcademyManager()
      {
         super();
      }
      
      public static function get Instance() : AcademyManager
      {
         if(_instance == null)
         {
            _instance = new AcademyManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
         this._messgers = new Vector.<SimpleMessger>();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER,this.__apprenticeSystemAnswer);
      }
      
      private function __apprenticeSystemAnswer(event:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var name:String = null;
         var message:String = null;
         var ID:int = 0;
         var Name:String = null;
         var Message:String = null;
         var removeID:int = 0;
         var graduateType:int = 0;
         var graduateID:int = 0;
         var graduateName:String = null;
         var masetrOrApprentceID:int = 0;
         var nickName:String = null;
         var messageI:String = null;
         var isGotoAcademy:Boolean = false;
         var type:int = event.pkg.readByte();
         switch(type)
         {
            case AcademyPackageType.ACADEMY_FOR_APPRENTICE:
               id = event.pkg.readInt();
               name = event.pkg.readUTF();
               message = event.pkg.readUTF();
               if(SharedManager.Instance.unAcceptAnswer.indexOf(id) < 0)
               {
                  AcademyFrameManager.Instance.showAcademyAnswerMasterFrame(id,name,message);
               }
               break;
            case AcademyPackageType.ACADEMY_FOR_MASTER:
               ID = event.pkg.readInt();
               Name = event.pkg.readUTF();
               Message = event.pkg.readUTF();
               if(PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
               {
                  return;
               }
               if(SharedManager.Instance.unAcceptAnswer.indexOf(ID) < 0)
               {
                  AcademyFrameManager.Instance.showAcademyAnswerApprenticeFrame(ID,Name,Message);
               }
               break;
            case AcademyPackageType.UPDATE_APP_STATES:
               PlayerManager.Instance.Self.apprenticeshipState = event.pkg.readInt();
               PlayerManager.Instance.Self.masterID = event.pkg.readInt();
               PlayerManager.Instance.Self.setMasterOrApprentices(event.pkg.readUTF());
               removeID = event.pkg.readInt();
               PlayerManager.Instance.Self.graduatesCount = event.pkg.readInt();
               PlayerManager.Instance.Self.honourOfMaster = event.pkg.readUTF();
               PlayerManager.Instance.Self.freezesDate = event.pkg.readDate();
               if(Boolean(this._myAcademyPlayers) && removeID != -1)
               {
                  this._myAcademyPlayers.remove(removeID);
               }
               if(Boolean(this._myAcademyPlayers) && PlayerManager.Instance.Self.apprenticeshipState == NONE_STATE)
               {
                  this._myAcademyPlayers.clear();
               }
               if(PlayerManager.Instance.Self.apprenticeshipState != NONE_STATE)
               {
                  TaskManager.instance.requestCanAcceptTask();
               }
               break;
            case AcademyPackageType.APPRENTICE_GRADUTE:
               graduateType = event.pkg.readInt();
               graduateID = event.pkg.readInt();
               graduateName = event.pkg.readUTF();
               if(graduateType == 0)
               {
                  AcademyFrameManager.Instance.showApprenticeGraduate();
               }
               else if(graduateType == 1)
               {
                  AcademyFrameManager.Instance.showMasterGraduate(graduateName);
               }
               break;
            case AcademyPackageType.APPRENTICE_CONFIRM:
            case AcademyPackageType.MASTER_CONFIRM:
               masetrOrApprentceID = event.pkg.readInt();
               nickName = event.pkg.readUTF();
               break;
            case AcademyPackageType.APPRENTICESHIPSYSTEM_ALERT:
               messageI = event.pkg.readUTF();
               isGotoAcademy = event.pkg.readBoolean();
               this.academyAlert(messageI,isGotoAcademy);
         }
      }
      
      private function academyAlert(message:String, isGotoAcademy:Boolean) : void
      {
         var alert:BaseAlerFrame = null;
         if(isGotoAcademy)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),message,LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__onCancel);
         }
         else if(!this.isFighting())
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),message,LanguageMgr.GetTranslation("ddt.manager.AcademyManager.alertSubmit"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else if(StateManager.currentStateType == StateType.HOT_SPRING_ROOM || StateManager.currentStateType == StateType.CHURCH_ROOM)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),message,LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__onCancel);
         }
      }
      
      private function __onCancel(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (event.currentTarget as BaseAlerFrame).dispose();
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (event.currentTarget as BaseAlerFrame).dispose();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      public function loadAcademyMemberList(callback:Function, requestType:Boolean = true, appshipStateType:Boolean = false, page:int = 1, name:String = "", grade:int = 0, sex:Boolean = true, isReturnSelf:Boolean = false) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["requestType"] = requestType;
         args["appshipStateType"] = appshipStateType;
         args["page"] = page;
         args["name"] = name;
         args["Grade"] = grade;
         args["sex"] = sex;
         args["isReturnSelf"] = isReturnSelf;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ApprenticeshipClubList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.infoError");
         loader.analyzer = new AcademyMemberListAnalyze(callback);
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
      
      public function recommend() : void
      {
         if(this.isOpenSpace(PlayerManager.Instance.Self) || !this.isRecommend())
         {
            return;
         }
         if(!DateUtils.isToday(new Date(PlayerManager.Instance.Self.LastDate)) || !SharedManager.Instance.isRecommend)
         {
            this._showMessage = false;
            if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
            {
               this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,MASTER,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
            }
            else
            {
               this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,APPSHIP,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
            }
         }
      }
      
      public function recommends() : void
      {
         this._showMessage = true;
         if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
         {
            this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,MASTER,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
         }
         else
         {
            this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,APPSHIP,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
         }
      }
      
      private function __recommendPlayersComplete(action:AcademyMemberListAnalyze) : void
      {
         this._recommendPlayers = action.academyMemberList;
         if(this._recommendPlayers.length >= 3)
         {
            if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
            {
               AcademyFrameManager.Instance.showAcademyApprenticeMainFrame();
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyMasterMainFrame();
            }
         }
         else if(this._showMessage)
         {
            if(PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.analyze.AcademyMemberListAnalyze.info"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.analyze.AcademyMemberListAnalyze.infoI"));
            }
         }
         this.isShowRecommend = false;
      }
      
      public function get recommendPlayers() : Vector.<AcademyPlayerInfo>
      {
         return this._recommendPlayers;
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function myAcademy() : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["RelationshipID"] = PlayerManager.Instance.Self.masterID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("UserApprenticeshipInfoList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         loader.analyzer = new MyAcademyPlayersAnalyze(this.__myAcademyPlayersComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __myAcademyPlayersComplete(action:MyAcademyPlayersAnalyze) : void
      {
         this._myAcademyPlayers = action.myAcademyPlayers;
         if(this._myAcademyPlayers.length == 0)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
         {
            AcademyFrameManager.Instance.showMyAcademyApprenticeFrame();
         }
         else
         {
            AcademyFrameManager.Instance.showMyAcademyMasterFrame();
         }
      }
      
      public function compareState(targetPlayer:BasePlayer, currentPlayer:PlayerInfo) : Boolean
      {
         if(currentPlayer.Grade < TARGET_PLAYER_MIN_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning6"));
            return false;
         }
         if(targetPlayer.Grade < TARGET_PLAYER_MIN_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningII"));
            return false;
         }
         if(currentPlayer.apprenticeshipState == APPRENTICE_STATE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.WarningApprenticeState"));
            return false;
         }
         if(currentPlayer.apprenticeshipState == MASTER_FULL_STATE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.WarningMasterFullState"));
            return false;
         }
         if(currentPlayer.Grade >= ACADEMY_LEVEL_MIN)
         {
            if(targetPlayer.Grade >= ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningIII"));
               return false;
            }
            if(currentPlayer.Grade - targetPlayer.Grade >= LEVEL_GAP)
            {
               return true;
            }
            if(currentPlayer.Grade - targetPlayer.Grade < LEVEL_GAP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning"));
               return false;
            }
         }
         else
         {
            if(targetPlayer.Grade < ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningIIII"));
               return false;
            }
            if(targetPlayer.Grade - currentPlayer.Grade >= LEVEL_GAP)
            {
               return true;
            }
            if(targetPlayer.Grade - currentPlayer.Grade < LEVEL_GAP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningI"));
               return false;
            }
         }
         return false;
      }
      
      public function gotoAcademyState() : void
      {
         var alert:BaseAlerFrame = null;
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.FRESHMAN_ROOM1 || StateManager.currentStateType == StateType.FRESHMAN_ROOM2)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning10"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         (event.currentTarget as BaseAlerFrame).dispose();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      public function getMasterHonorLevel(value:int) : int
      {
         var level:int = 0;
         for(var i:int = 0; i < GRADUATE_NUM.length; i++)
         {
            if(value >= GRADUATE_NUM[i])
            {
               level++;
            }
         }
         return level;
      }
      
      public function isFreezes(requestType:Boolean) : Boolean
      {
         var serverDate:Date = TimeManager.Instance.serverDate;
         if(PlayerManager.Instance.Self.freezesDate > serverDate)
         {
            if(requestType)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.academyManager.Freezes"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.academyManager.FreezesII"));
            }
            return false;
         }
         return true;
      }
      
      public function set messgers(value:Vector.<SimpleMessger>) : void
      {
         this._messgers = value;
      }
      
      public function get messgers() : Vector.<SimpleMessger>
      {
         return this._messgers;
      }
      
      public function showAlert() : void
      {
         while(this.messgers.length != 0)
         {
            if(Boolean(this.messgers[0]) && this.messgers[0].type == SimpleMessger.ANSWER_APPRENTICE)
            {
               AcademyFrameManager.Instance.showAcademyAnswerApprenticeFrame(this.messgers[0].id,this.messgers[0].name,this.messgers[0].messger);
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyAnswerMasterFrame(this.messgers[0].id,this.messgers[0].name,this.messgers[0].messger);
            }
            this.messgers.shift();
         }
      }
      
      public function isFighting() : Boolean
      {
         if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.HOT_SPRING_ROOM && StateManager.currentStateType != StateType.CHURCH_ROOM && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            return false;
         }
         return true;
      }
      
      public function isRecommend() : Boolean
      {
         return AcademyManager.Instance.isShowRecommend && !SharedManager.Instance.isRecommend && PlayerManager.Instance.Self.Grade > AcademyManager.TARGET_PLAYER_MIN_LEVEL && (PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.NONE_STATE || PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.MASTER_STATE);
      }
      
      public function isOpenSpace(info:BasePlayer) : Boolean
      {
         return info.Grade < ACADEMY_LEVEL_MIN && info.Grade > ACADEMY_LEVEL_MAX;
      }
      
      public function get selfDescribe() : String
      {
         return this._selfDescribe;
      }
      
      public function set selfDescribe(value:String) : void
      {
         this._selfDescribe = value;
         dispatchEvent(new Event(SELF_DESCRIBE));
      }
   }
}

