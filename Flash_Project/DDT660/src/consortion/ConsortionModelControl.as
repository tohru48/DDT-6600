package consortion
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.analyze.ConsortiaAnalyze;
   import consortion.analyze.ConsortiaBossDataAnalyzer;
   import consortion.analyze.ConsortionApplyListAnalyzer;
   import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
   import consortion.analyze.ConsortionDutyListAnalyzer;
   import consortion.analyze.ConsortionEventListAnalyzer;
   import consortion.analyze.ConsortionInventListAnalyzer;
   import consortion.analyze.ConsortionLevelUpAnalyzer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import consortion.analyze.ConsortionPollListAnalyzer;
   import consortion.analyze.ConsortionSkillInfoAnalyzer;
   import consortion.analyze.PersonalRankAnalyze;
   import consortion.data.BadgeInfo;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import consortion.rank.HelpFrame;
   import consortion.rank.RankFrame;
   import consortion.view.boss.ConsortiaBossFrame;
   import consortion.view.selfConsortia.ConsortionBankFrame;
   import consortion.view.selfConsortia.ConsortionQuitFrame;
   import consortion.view.selfConsortia.ConsortionShopFrame;
   import consortion.view.selfConsortia.ManagerFrame;
   import consortion.view.selfConsortia.TakeInMemberFrame;
   import consortion.view.selfConsortia.TaxFrame;
   import consortion.view.selfConsortia.consortiaTask.ConsortiaTaskModel;
   import ddt.constants.CacheConsts;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import email.manager.MailManager;
   import flash.display.InteractiveObject;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   import room.transnational.SnapAction;
   import trainer.controller.SystemOpenPromptManager;
   
   public class ConsortionModelControl extends EventDispatcher
   {
      
      private static var _instance:ConsortionModelControl;
      
      private var _model:ConsortionModel;
      
      private var _taskModel:ConsortiaTaskModel;
      
      private var str:String;
      
      private var _invateID:int;
      
      private var _enterConfirm:SimpleAlert;
      
      private var _consortionBankFrame:ConsortionBankFrame;
      
      private var _bossConfigDataList:Array;
      
      public var isShowBossOpenTip:Boolean = false;
      
      public var isBossOpen:Boolean = false;
      
      public function ConsortionModelControl()
      {
         super();
         this._model = new ConsortionModel();
         this._taskModel = new ConsortiaTaskModel();
         this.addEvent();
      }
      
      public static function get Instance() : ConsortionModelControl
      {
         if(_instance == null)
         {
            _instance = new ConsortionModelControl();
         }
         return _instance;
      }
      
      public function get model() : ConsortionModel
      {
         return this._model;
      }
      
      public function get TaskModel() : ConsortiaTaskModel
      {
         return this._taskModel;
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN,this.__consortiaTryIn);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,this.__tryInDel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,this.__consortiaTryInPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DISBAND,this.__consortiaDisband);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE,this.__consortiaInvate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,this.__consortiaInvitePass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CREATE,this.__consortiaCreate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,this.__consortiaPlacardUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,this.__onConsortiaEquipControl);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,this.__givceOffer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RESPONSE,this.__consortiaResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RENEGADE,this.__renegadeUser);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,this.__onConsortiaLevelUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,this.__oncharmanChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,this.__consortiaUserUpGrade);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,this.__consortiaDescriptionUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKILL_SOCKET,this.__skillChangehandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,this.__consortiaMailMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_BADGE,this.__buyBadgeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_OPEN_CLOSE,this.bossOpenCloseHandler);
      }
      
      private function __consortiaResponse(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var id:int = 0;
         var name:String = null;
         var memberInfo:ConsortiaPlayerInfo = null;
         var isInvent:Boolean = false;
         var inventID:int = 0;
         var inventName:String = null;
         var state:int = 0;
         var msgTxt1:String = null;
         var consortiaID:int = 0;
         var isKick:Boolean = false;
         var kickName:String = null;
         var unkwon1:int = 0;
         var unkwon2:String = null;
         var unkwon3:int = 0;
         var intviteName:String = null;
         var unkwon4:int = 0;
         var consortiaName:String = null;
         var myid:int = 0;
         var myname:String = null;
         var myLevel:int = 0;
         var subType:int = 0;
         var consortiaId:int = 0;
         var playerId:int = 0;
         var playerName:String = null;
         var dutyLeve:int = 0;
         var dName:String = null;
         var rights:int = 0;
         var handleID:int = 0;
         var handleName:String = null;
         var consortiaId9:int = 0;
         var playerId9:int = 0;
         var playerName9:String = null;
         var riches:int = 0;
         var msgTxt10:String = null;
         var t:int = 0;
         var msgTxt5:String = null;
         var context:String = null;
         var lastFocusObject:InteractiveObject = null;
         var msgTxt6:String = null;
         var msgTxt7:String = null;
         var msgTxt9:String = null;
         pkg = event.pkg;
         var type:int = pkg.readByte();
         switch(type)
         {
            case 1:
               memberInfo = new ConsortiaPlayerInfo();
               memberInfo.privateID = pkg.readInt();
               isInvent = pkg.readBoolean();
               memberInfo.ConsortiaID = pkg.readInt();
               memberInfo.ConsortiaName = pkg.readUTF();
               memberInfo.ID = pkg.readInt();
               memberInfo.NickName = pkg.readUTF();
               inventID = pkg.readInt();
               inventName = pkg.readUTF();
               memberInfo.DutyID = pkg.readInt();
               memberInfo.DutyName = pkg.readUTF();
               memberInfo.Offer = pkg.readInt();
               memberInfo.RichesOffer = pkg.readInt();
               memberInfo.RichesRob = pkg.readInt();
               memberInfo.LastDate = pkg.readDateString();
               memberInfo.Grade = pkg.readInt();
               memberInfo.DutyLevel = pkg.readInt();
               state = pkg.readInt();
               memberInfo.playerState = new PlayerState(state);
               memberInfo.Sex = pkg.readBoolean();
               memberInfo.Right = pkg.readInt();
               memberInfo.WinCount = pkg.readInt();
               memberInfo.TotalCount = pkg.readInt();
               memberInfo.EscapeCount = pkg.readInt();
               memberInfo.Repute = pkg.readInt();
               memberInfo.LoginName = pkg.readUTF();
               memberInfo.FightPower = pkg.readInt();
               memberInfo.AchievementPoint = pkg.readInt();
               memberInfo.honor = pkg.readUTF();
               memberInfo.UseOffer = pkg.readInt();
               if(!(isInvent && memberInfo.ID == PlayerManager.Instance.Self.ID))
               {
                  if(memberInfo.ID == PlayerManager.Instance.Self.ID)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.one",memberInfo.ConsortiaName));
                  }
               }
               msgTxt1 = "";
               if(memberInfo.ID == PlayerManager.Instance.Self.ID)
               {
                  this.setPlayerConsortia(memberInfo.ConsortiaID,memberInfo.ConsortiaName);
                  this.getConsortionMember(this.memberListComplete);
                  this.getConsortionList(this.selfConsortionComplete,1,6,memberInfo.ConsortiaName,-1,-1,-1,memberInfo.ConsortiaID);
                  if(isInvent)
                  {
                     msgTxt1 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.isInvent.msg",memberInfo.ConsortiaName);
                  }
                  else
                  {
                     msgTxt1 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.pass",memberInfo.ConsortiaName);
                  }
                  if(StateManager.currentStateType == StateType.CONSORTIA)
                  {
                     dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
                  }
                  TaskManager.instance.requestClubTask();
                  if(PathManager.solveExternalInterfaceEnabel())
                  {
                     ExternalInterfaceManager.sendToAgent(5,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,memberInfo.ConsortiaName);
                  }
               }
               else
               {
                  this._model.addMember(memberInfo);
                  msgTxt1 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.player",memberInfo.NickName);
               }
               msgTxt1 = StringHelper.rePlaceHtmlTextField(msgTxt1);
               ChatManager.Instance.sysChatYellow(msgTxt1);
               break;
            case 2:
               id = pkg.readInt();
               PlayerManager.Instance.Self.consortiaInfo.Level = 0;
               this.setPlayerConsortia();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.your"));
               this.getConsortionMember();
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.disband"));
               if(StateManager.currentStateType == StateType.CONSORTIA)
               {
                  StateManager.back();
               }
               break;
            case 3:
               id = pkg.readInt();
               consortiaID = pkg.readInt();
               isKick = pkg.readBoolean();
               name = pkg.readUTF();
               kickName = pkg.readUTF();
               if(PlayerManager.Instance.Self.ID == id)
               {
                  this.setPlayerConsortia();
                  this.getConsortionMember();
                  TaskManager.instance.onGuildUpdate();
                  msgTxt5 = "";
                  if(isKick)
                  {
                     msgTxt5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.delect",kickName);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.hit"));
                  }
                  else
                  {
                     msgTxt5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leave");
                  }
                  if(StateManager.currentStateType == StateType.CONSORTIA)
                  {
                     StateManager.back();
                  }
                  msgTxt5 = StringHelper.rePlaceHtmlTextField(msgTxt5);
                  ChatManager.Instance.sysChatRed(msgTxt5);
               }
               else
               {
                  this.removeConsortiaMember(id,isKick,kickName);
               }
               break;
            case 4:
               this._invateID = pkg.readInt();
               unkwon1 = pkg.readInt();
               unkwon2 = pkg.readUTF();
               unkwon3 = pkg.readInt();
               intviteName = pkg.readUTF();
               unkwon4 = pkg.readInt();
               consortiaName = pkg.readUTF();
               if(SharedManager.Instance.showCI)
               {
                  if(this.str != intviteName)
                  {
                     SoundManager.instance.play("018");
                     context = intviteName + LanguageMgr.GetTranslation("tank.manager.PlayerManager.come",consortiaName);
                     context = StringHelper.rePlaceHtmlTextField(context);
                     lastFocusObject = StageReferance.stage.focus;
                     if(Boolean(this._enterConfirm))
                     {
                        this._enterConfirm.removeEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
                        ObjectUtils.disposeObject(this._enterConfirm);
                        this._enterConfirm = null;
                     }
                     if(CacheSysManager.isLock(CacheConsts.TRANSNATIONAL))
                     {
                        CacheSysManager.getInstance().cache(CacheConsts.TRANSNATIONAL,new SnapAction(this.__enterConsortiaConfirm,LanguageMgr.GetTranslation("tank.manager.PlayerManager.request"),context,LanguageMgr.GetTranslation("tank.manager.PlayerManager.sure"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuse"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,CacheConsts.ALERT_IN_FIGHT));
                     }
                     else
                     {
                        this._enterConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.manager.PlayerManager.request"),context,LanguageMgr.GetTranslation("tank.manager.PlayerManager.sure"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuse"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,CacheConsts.ALERT_IN_FIGHT) as SimpleAlert;
                        this._enterConfirm.frameMiniW = 400;
                        this._enterConfirm.addEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
                     }
                     this.str = intviteName;
                     if(lastFocusObject is TextField)
                     {
                        if(TextField(lastFocusObject).type == TextFieldType.INPUT)
                        {
                           StageReferance.stage.focus = lastFocusObject;
                        }
                     }
                  }
               }
               break;
            case 5:
               break;
            case 6:
               myid = pkg.readInt();
               myname = pkg.readUTF();
               myLevel = pkg.readInt();
               if(PlayerManager.Instance.Self.ConsortiaID == myid)
               {
                  PlayerManager.Instance.Self.consortiaInfo.Level = myLevel;
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgrade",myLevel,this._model.getLevelData(myLevel).Count));
                  TaskManager.instance.requestClubTask();
                  SoundManager.instance.play("1001");
                  this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
                  TaskManager.instance.onGuildUpdate();
               }
               break;
            case 7:
               break;
            case 8:
               subType = pkg.readByte();
               consortiaId = pkg.readInt();
               playerId = pkg.readInt();
               playerName = pkg.readUTF();
               dutyLeve = pkg.readInt();
               dName = pkg.readUTF();
               rights = pkg.readInt();
               handleID = pkg.readInt();
               handleName = pkg.readUTF();
               if(subType != 1)
               {
                  if(subType == 2)
                  {
                     this.updateDutyInfo(dutyLeve,dName,rights);
                  }
                  else if(subType == 3)
                  {
                     this.upDateSelfDutyInfo(dutyLeve,dName,rights);
                  }
                  else if(subType == 4)
                  {
                     this.upDateSelfDutyInfo(dutyLeve,dName,rights);
                  }
                  else if(subType == 5)
                  {
                     this.upDateSelfDutyInfo(dutyLeve,dName,rights);
                  }
                  else if(subType == 6)
                  {
                     this.updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
                     msgTxt6 = "";
                     if(playerId == PlayerManager.Instance.Self.ID)
                     {
                        msgTxt6 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youUpgrade",handleName,dName);
                     }
                     else if(playerId == handleID)
                     {
                        msgTxt6 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeSelf",playerName,dName);
                     }
                     else
                     {
                        msgTxt6 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeOther",handleName,playerName,dName);
                     }
                     msgTxt6 = StringHelper.rePlaceHtmlTextField(msgTxt6);
                     ChatManager.Instance.sysChatYellow(msgTxt6);
                  }
                  else if(subType == 7)
                  {
                     this.updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
                     msgTxt7 = "";
                     if(playerId == PlayerManager.Instance.Self.ID)
                     {
                        msgTxt7 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youDemotion",handleName,dName);
                     }
                     else if(playerId == handleID)
                     {
                        msgTxt7 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionSelf",playerName,dName);
                     }
                     else
                     {
                        msgTxt7 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionOther",handleName,playerName,dName);
                     }
                     msgTxt7 = StringHelper.rePlaceHtmlTextField(msgTxt7);
                     ChatManager.Instance.sysChatYellow(msgTxt7);
                  }
                  else if(subType == 8)
                  {
                     this.updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
                     SoundManager.instance.play("1001");
                  }
                  else if(subType == 9)
                  {
                     this.updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
                     PlayerManager.Instance.Self.consortiaInfo.ChairmanName = playerName;
                     msgTxt9 = "<" + playerName + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.up") + dName;
                     msgTxt9 = StringHelper.rePlaceHtmlTextField(msgTxt9);
                     ChatManager.Instance.sysChatYellow(msgTxt9);
                     SoundManager.instance.play("1001");
                  }
               }
               break;
            case 9:
               consortiaId9 = pkg.readInt();
               playerId9 = pkg.readInt();
               playerName9 = pkg.readUTF();
               riches = pkg.readInt();
               if(consortiaId9 != PlayerManager.Instance.Self.ConsortiaID)
               {
                  return;
               }
               msgTxt10 = "";
               if(PlayerManager.Instance.Self.ID == playerId9)
               {
                  msgTxt10 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionSelf",riches);
               }
               else
               {
                  msgTxt10 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionOther",playerName9,riches);
               }
               ChatManager.Instance.sysChatYellow(msgTxt10);
               break;
            case 10:
               this.consortiaUpLevel(10,pkg.readInt(),pkg.readUTF(),pkg.readInt());
               break;
            case 11:
               this.consortiaUpLevel(11,pkg.readInt(),pkg.readUTF(),pkg.readInt());
               break;
            case 12:
               this.consortiaUpLevel(12,pkg.readInt(),pkg.readUTF(),pkg.readInt());
               break;
            case 13:
               this.consortiaUpLevel(13,pkg.readInt(),pkg.readUTF(),pkg.readInt());
               break;
            case 14:
               t = pkg.readInt();
               switch(t)
               {
                  case 1:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = true;
                     break;
                  case 2:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
                     break;
                  case 3:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
               }
               break;
            case 15:
               pkg.readInt();
               ChatManager.Instance.sysChatYellow(pkg.readUTF());
               break;
            case 16:
               this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         }
      }
      
      private function consortiaUpLevel(type:int, id:int, name:String, level:int) : void
      {
         if(id != PlayerManager.Instance.Self.ConsortiaID)
         {
            return;
         }
         SoundManager.instance.play("1001");
         var tipText:String = "";
         if(type == 10)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop",level);
            }
            else
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop2",level);
            }
            PlayerManager.Instance.Self.consortiaInfo.ShopLevel = level;
         }
         else if(type == 11)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore",level);
            }
            else
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore2",level);
            }
            PlayerManager.Instance.Self.consortiaInfo.SmithLevel = level;
         }
         else if(type == 12)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith",level);
            }
            else
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith2",level);
            }
            PlayerManager.Instance.Self.consortiaInfo.StoreLevel = level;
         }
         else if(type == 13)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSkill",level);
            }
            else
            {
               tipText = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSkill2",level);
            }
            PlayerManager.Instance.Self.consortiaInfo.BufferLevel = level;
         }
         ChatManager.Instance.sysChatYellow(tipText);
         this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         TaskManager.instance.onGuildUpdate();
      }
      
      private function updateDutyInfo(dutyLevel:int, dutyName:String, right:int) : void
      {
         var i:ConsortiaPlayerInfo = null;
         for each(i in this._model.memberList)
         {
            if(i.DutyLevel == dutyLevel)
            {
               i.DutyLevel == dutyLevel;
               i.DutyName = dutyName;
               i.Right = right;
               this._model.updataMember(i);
            }
         }
      }
      
      private function upDateSelfDutyInfo(dutyLevel:int, dutyName:String, right:int) : void
      {
         var i:ConsortiaPlayerInfo = null;
         for each(i in this._model.memberList)
         {
            if(i.ID == PlayerManager.Instance.Self.ID)
            {
               PlayerManager.Instance.Self.beginChanges();
               i.DutyLevel = PlayerManager.Instance.Self.DutyLevel = dutyLevel;
               i.DutyName = PlayerManager.Instance.Self.DutyName = dutyName;
               i.Right = PlayerManager.Instance.Self.Right = right;
               PlayerManager.Instance.Self.commitChanges();
               this._model.updataMember(i);
            }
         }
      }
      
      private function updateConsortiaMemberDuty(playerId:int, dutyLevel:int, dutyName:String, right:int) : void
      {
         var i:ConsortiaPlayerInfo = null;
         for each(i in this._model.memberList)
         {
            if(i.ID == playerId)
            {
               i.beginChanges();
               i.DutyLevel = dutyLevel;
               i.DutyName = dutyName;
               i.Right = right;
               if(i.ID == PlayerManager.Instance.Self.ID)
               {
                  PlayerManager.Instance.Self.beginChanges();
                  PlayerManager.Instance.Self.DutyLevel = dutyLevel;
                  PlayerManager.Instance.Self.DutyName = dutyName;
                  PlayerManager.Instance.Self.Right = right;
                  PlayerManager.Instance.Self.consortiaInfo.Level = PlayerManager.Instance.Self.consortiaInfo.Level == 0 ? 1 : PlayerManager.Instance.Self.consortiaInfo.Level;
                  PlayerManager.Instance.Self.commitChanges();
                  this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.consortiaInfo.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.consortiaInfo.ConsortiaID);
               }
               i.commitChanges();
               this._model.updataMember(i);
            }
         }
      }
      
      private function removeConsortiaMember(id:int, isKick:Boolean, kickName:String) : void
      {
         var i:ConsortiaPlayerInfo = null;
         var msgTxt:String = null;
         for each(i in this._model.memberList)
         {
            if(i.ID == id)
            {
               msgTxt = "";
               if(isKick)
               {
                  msgTxt = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortia",kickName,i.NickName);
               }
               else
               {
                  msgTxt = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leaveconsortia",i.NickName);
               }
               msgTxt = StringHelper.rePlaceHtmlTextField(msgTxt);
               ChatManager.Instance.sysChatYellow(msgTxt);
               this._model.removeMember(i);
            }
         }
      }
      
      private function __enterConsortiaConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
         if(Boolean(frame))
         {
            ObjectUtils.disposeObject(frame);
            frame = null;
         }
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.accpetConsortiaInvent();
         }
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.rejectConsortiaInvent();
         }
      }
      
      private function accpetConsortiaInvent() : void
      {
         SocketManager.Instance.out.sendConsortiaInvatePass(this._invateID);
         this.str = "";
      }
      
      private function rejectConsortiaInvent() : void
      {
         SocketManager.Instance.out.sendConsortiaInvateDelete(this._invateID);
         this.str = "";
      }
      
      private function __givceOffer(e:CrazyTankSocketEvent) : void
      {
         var num:int = e.pkg.readInt();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isSuccess)
         {
            PlayerManager.Instance.Self.consortiaInfo.Riches += Math.floor(Number(num / 2));
            this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer = this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer + Math.floor(Number(num / 2));
            TaskManager.instance.onGuildUpdate();
         }
      }
      
      private function __onConsortiaEquipControl(evt:CrazyTankSocketEvent) : void
      {
         var list:Vector.<ConsortiaAssetLevelOffer> = null;
         var i:int = 0;
         var isSuccess:Boolean = evt.pkg.readBoolean();
         if(isSuccess)
         {
            list = new Vector.<ConsortiaAssetLevelOffer>();
            for(i = 0; i < 7; i++)
            {
               list[i] = new ConsortiaAssetLevelOffer();
               if(i < 5)
               {
                  list[i].Type = 1;
                  list[i].Level = i + 1;
               }
               else if(i == 5)
               {
                  list[i].Type = 2;
               }
               else
               {
                  list[i].Type = 3;
               }
            }
            list[0].Riches = evt.pkg.readInt();
            list[1].Riches = evt.pkg.readInt();
            list[2].Riches = evt.pkg.readInt();
            list[3].Riches = evt.pkg.readInt();
            list[4].Riches = evt.pkg.readInt();
            list[5].Riches = evt.pkg.readInt();
            list[6].Riches = evt.pkg.readInt();
            if(PlayerManager.Instance.Self.ID == PlayerManager.Instance.Self.consortiaInfo.ChairmanID)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.onConsortiaEquipControl.executeSuccess"));
            }
            this._model.useConditionList = list;
         }
         else if(PlayerManager.Instance.Self.ID == PlayerManager.Instance.Self.consortiaInfo.ChairmanID)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.onConsortiaEquipControl.executeFail"));
         }
      }
      
      private function __consortiaTryIn(evt:CrazyTankSocketEvent) : void
      {
         var id:int = evt.pkg.readInt();
         var isScuess:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isScuess)
         {
            this.getApplyRecordList(this.applyListComplete,PlayerManager.Instance.Self.ID);
         }
      }
      
      private function __tryInDel(evt:CrazyTankSocketEvent) : void
      {
         var id:int = evt.pkg.readInt();
         var isScuss:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isScuss)
         {
            this._model.deleteOneApplyRecord(id);
         }
      }
      
      private function __consortiaTryInPass(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isSuccess)
         {
            this._model.deleteOneApplyRecord(id);
         }
      }
      
      private function __consortiaInvate(evt:CrazyTankSocketEvent) : void
      {
         var name:String = evt.pkg.readUTF();
         var isSuccess:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
      }
      
      private function __consortiaInvitePass(evt:CrazyTankSocketEvent) : void
      {
         var unkwon:int = evt.pkg.readInt();
         var success:Boolean = evt.pkg.readBoolean();
         var id:int = evt.pkg.readInt();
         var name:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(evt.pkg.readUTF());
         if(success)
         {
            this.setPlayerConsortia(id,name);
            this.getConsortionMember(this.memberListComplete);
            this.getConsortionList(this.selfConsortionComplete,1,6,name,-1,-1,-1,id);
         }
      }
      
      private function __consortiaCreate(evt:CrazyTankSocketEvent) : void
      {
         var n:String = evt.pkg.readUTF();
         var isSucuess:Boolean = evt.pkg.readBoolean();
         var id:int = evt.pkg.readInt();
         var cName:String = evt.pkg.readUTF();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         var level:int = evt.pkg.readInt();
         var dutyName:String = evt.pkg.readUTF();
         var right:int = evt.pkg.readInt();
         if(isSucuess)
         {
            this.setPlayerConsortia(id,n);
            this.getConsortionMember(this.memberListComplete);
            this.getConsortionList(this.selfConsortionComplete,1,6,n,-1,-1,-1,id);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
            TaskManager.instance.requestClubTask();
            if(PathManager.solveExternalInterfaceEnabel())
            {
               ExternalInterfaceManager.sendToAgent(4,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,cName);
            }
         }
      }
      
      private function __consortiaDisband(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var msgii:String = null;
         if(evt.pkg.readBoolean())
         {
            if(evt.pkg.readInt() == PlayerManager.Instance.Self.ID)
            {
               this.setPlayerConsortia();
               if(StateManager.currentStateType == StateType.CONSORTIA)
               {
                  StateManager.back();
               }
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.manager.PlayerManager.msg"));
               MessageTipManager.getInstance().show(evt.pkg.readUTF());
            }
         }
         else
         {
            id = evt.pkg.readInt();
            msgii = evt.pkg.readUTF();
            MessageTipManager.getInstance().show(msgii);
         }
      }
      
      private function __consortiaPlacardUpdate(evt:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.consortiaInfo.Placard = evt.pkg.readUTF();
         var isSuccess:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
      }
      
      private function __renegadeUser(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
      }
      
      private function __onConsortiaLevelUp(e:CrazyTankSocketEvent) : void
      {
         var type:int = e.pkg.readByte();
         var level:int = e.pkg.readByte();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isSuccess)
         {
            switch(type)
            {
               case 1:
                  PlayerManager.Instance.Self.consortiaInfo.Level = level;
                  break;
               case 2:
                  PlayerManager.Instance.Self.consortiaInfo.StoreLevel = level;
                  break;
               case 3:
                  PlayerManager.Instance.Self.consortiaInfo.ShopLevel = level;
                  break;
               case 4:
                  PlayerManager.Instance.Self.consortiaInfo.SmithLevel = level;
                  break;
               case 5:
                  PlayerManager.Instance.Self.consortiaInfo.BufferLevel = level;
            }
         }
      }
      
      private function __oncharmanChange(e:CrazyTankSocketEvent) : void
      {
         var nick:String = e.pkg.readUTF();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
      }
      
      private function __consortiaUserUpGrade(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var isUpGrade:Boolean = e.pkg.readBoolean();
         var isSuccess:Boolean = e.pkg.readBoolean();
         var msg:String = e.pkg.readUTF();
         if(isUpGrade)
         {
            if(isSuccess)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upsuccess"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upfalse"));
            }
         }
         else if(isSuccess)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downsuccess"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downfalse"));
         }
      }
      
      private function __consortiaDescriptionUpdate(evt:CrazyTankSocketEvent) : void
      {
         var description:String = evt.pkg.readUTF();
         var isSuccess:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         if(isSuccess)
         {
            PlayerManager.Instance.Self.consortiaInfo.Description = description;
         }
      }
      
      private function __skillChangehandler(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var b:Boolean = false;
         var beginDate:Date = null;
         var validDay:int = 0;
         var len:int = evt.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            id = evt.pkg.readInt();
            b = evt.pkg.readBoolean();
            beginDate = evt.pkg.readDate();
            validDay = evt.pkg.readInt();
            this._model.updateSkillInfo(id,b,beginDate,validDay);
         }
         if(len > 0)
         {
            this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         }
         dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_STATE_CHANGE));
      }
      
      private function __consortiaMailMessage(evt:CrazyTankSocketEvent) : void
      {
         var str:String = evt.pkg.readUTF();
         var quitConsortiaConfirm:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),str,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         quitConsortiaConfirm.moveEnable = false;
         quitConsortiaConfirm.addEventListener(FrameEvent.RESPONSE,this.__quitConsortiaResponse);
      }
      
      private function __quitConsortiaResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__quitConsortiaResponse);
         frame.dispose();
         frame = null;
      }
      
      private function setPlayerConsortia(id:uint = 0, name:String = "") : void
      {
         PlayerManager.Instance.Self.ConsortiaName = name;
         PlayerManager.Instance.Self.ConsortiaID = id;
         if(id == 0)
         {
            PlayerManager.Instance.Self.consortiaInfo.Level = 0;
         }
      }
      
      public function memberListComplete(analyzer:ConsortionMemberAnalyer) : void
      {
         this._model.memberList = analyzer.consortionMember;
         TaskManager.instance.onGuildUpdate();
      }
      
      public function clubSearchConsortions(anlyzer:ConsortionListAnalyzer) : void
      {
         this._model.consortionList = anlyzer.consortionList;
         this._model.consortionsListTotalCount = Math.ceil(anlyzer.consortionsTotalCount / ConsortionModel.ConsortionListEachPageNum);
      }
      
      public function selfConsortionComplete(anlyzer:ConsortionListAnalyzer) : void
      {
         if(anlyzer.consortionList.length > 0)
         {
            PlayerManager.Instance.Self.consortiaInfo = anlyzer.consortionList[0] as ConsortiaInfo;
         }
      }
      
      public function applyListComplete(anlyzer:ConsortionApplyListAnalyzer) : void
      {
         this._model.myApplyList = anlyzer.applyList;
         this._model.applyListTotalCount = anlyzer.totalCount;
      }
      
      public function InventListComplete(anlyzer:ConsortionInventListAnalyzer) : void
      {
         this._model.inventList = anlyzer.inventList;
         this._model.inventListTotalCount = anlyzer.totalCount;
      }
      
      private function levelUpInfoComplete(anlyzer:ConsortionLevelUpAnalyzer) : void
      {
         this._model.levelUpData = anlyzer.levelUpData;
      }
      
      public function eventListComplete(anlyzer:ConsortionEventListAnalyzer) : void
      {
         this._model.eventList = anlyzer.eventList;
      }
      
      public function useConditionListComplete(anlyzer:ConsortionBuildingUseConditionAnalyer) : void
      {
         this._model.useConditionList = anlyzer.useConditionList;
      }
      
      public function dutyListComplete(anlyzer:ConsortionDutyListAnalyzer) : void
      {
         this._model.dutyList = anlyzer.dutyList;
      }
      
      public function pollListComplete(anlyzer:ConsortionPollListAnalyzer) : void
      {
         this._model.pollList = anlyzer.pollList;
      }
      
      public function skillInfoListComplete(anlyzer:ConsortionSkillInfoAnalyzer) : void
      {
         this._model.skillInfoList = anlyzer.skillInfoList;
      }
      
      public function getConsortionList(callBackFun:Function, page:int = 1, size:int = 6, name:String = "", order:int = -1, openApply:int = -1, level:int = -1, ConsortiaID:int = -1) : void
      {
         name = name.replace(/<|>/g,"");
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = page;
         args["size"] = size;
         args["name"] = name;
         args["level"] = level;
         args["ConsortiaID"] = ConsortiaID;
         args["order"] = order;
         args["openApply"] = openApply;
         var loadConsortias:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loadConsortias.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaListError");
         loadConsortias.analyzer = new ConsortionListAnalyzer(callBackFun);
         loadConsortias.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loadConsortias);
      }
      
      public function getApplyRecordList(callBackFun:Function, playerID:int = -1, consortiaID:int = -1) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = 1;
         args["size"] = 1000;
         args["order"] = -1;
         args["consortiaID"] = consortiaID;
         args["applyID"] = -1;
         args["userID"] = playerID;
         args["userLevel"] = -1;
         var loadConsortiaApplyUsersList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaApplyUsersList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loadConsortiaApplyUsersList.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
         loadConsortiaApplyUsersList.analyzer = new ConsortionApplyListAnalyzer(callBackFun);
         loadConsortiaApplyUsersList.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loadConsortiaApplyUsersList);
      }
      
      public function getInviteRecordList(callBackFun:Function) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = 1;
         args["size"] = 1000;
         args["order"] = -1;
         args["userID"] = PlayerManager.Instance.Self.ID;
         args["inviteID"] = -1;
         var loadConsortiaInventList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaInviteUsersList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loadConsortiaInventList.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
         loadConsortiaInventList.analyzer = new ConsortionInventListAnalyzer(callBackFun);
         loadConsortiaInventList.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loadConsortiaInventList);
      }
      
      public function getConsortionMember(callBackFun:Function = null) : void
      {
         var args:URLVariables = null;
         var loadSelfConsortiaMemberList:BaseLoader = null;
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._model.memberList.clear();
         }
         else
         {
            args = RequestVairableCreater.creatWidthKey(true);
            args["page"] = 1;
            args["size"] = 10000;
            args["order"] = -1;
            args["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
            args["userID"] = -1;
            args["state"] = -1;
            args["rnd"] = Math.random();
            loadSelfConsortiaMemberList = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
            loadSelfConsortiaMemberList.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMemberInfoError");
            loadSelfConsortiaMemberList.analyzer = new ConsortionMemberAnalyer(callBackFun);
            loadSelfConsortiaMemberList.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            LoadResourceManager.Instance.startLoad(loadSelfConsortiaMemberList);
         }
      }
      
      public function getLevelUpInfo() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var loadConsortiaLevelData:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaLevelList.xml"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loadConsortiaLevelData.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaLevelError");
         loadConsortiaLevelData.analyzer = new ConsortionLevelUpAnalyzer(this.levelUpInfoComplete);
         loadConsortiaLevelData.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loadConsortiaLevelData;
      }
      
      public function loadEventList(callBackFun:Function, consortiaID:int = -1) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = 1;
         args["size"] = 50;
         args["order"] = -1;
         args["consortiaID"] = consortiaID;
         var eventList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaEventList.ashx"),BaseLoader.REQUEST_LOADER,args);
         eventList.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadEventList.fail");
         eventList.analyzer = new ConsortionEventListAnalyzer(callBackFun);
         eventList.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(eventList);
      }
      
      public function loadUseConditionList(callBackFun:Function, consortionID:int = -1) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["consortiaID"] = consortionID;
         args["level"] = -1;
         args["type"] = -1;
         var loadConsortiaAssetRight:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaEquipControlList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loadConsortiaAssetRight.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadUseCondition.fail");
         loadConsortiaAssetRight.analyzer = new ConsortionBuildingUseConditionAnalyer(callBackFun);
         loadConsortiaAssetRight.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loadConsortiaAssetRight);
      }
      
      public function loadDutyList(callBackFun:Function, consortiaID:int = -1, dutyID:int = -1) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = 1;
         args["size"] = 1000;
         args["ConsortiaID"] = consortiaID;
         args["order"] = -1;
         args["dutyID"] = dutyID;
         var loadConsortiaDutyList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaDutyList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loadConsortiaDutyList.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadDutyListError");
         loadConsortiaDutyList.analyzer = new ConsortionDutyListAnalyzer(callBackFun);
         loadConsortiaDutyList.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loadConsortiaDutyList);
      }
      
      public function loadPollList(consortionID:int) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["ConsortiaID"] = consortionID;
         var pollListLoader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaCandidateList.ashx"),BaseLoader.REQUEST_LOADER,args);
         pollListLoader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.pollload.error");
         pollListLoader.analyzer = new ConsortionPollListAnalyzer(this.pollListComplete);
         pollListLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(pollListLoader);
      }
      
      public function loadSkillInfoList() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaBufferTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.skillInfo.loadError");
         loader.analyzer = new ConsortionSkillInfoAnalyzer(this.skillInfoListComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
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
      
      private function __buyBadgeHandler(event:CrazyTankSocketEvent) : void
      {
         var badgeInfo:BadgeInfo = null;
         var pkg:PackageIn = event.pkg;
         var consortiaID:int = pkg.readInt();
         var badgeID:int = pkg.readInt();
         var validdate:int = pkg.readInt();
         var beginTime:Date = pkg.readDate();
         var result:Boolean = pkg.readBoolean();
         if(consortiaID == PlayerManager.Instance.Self.ConsortiaID)
         {
            PlayerManager.Instance.Self.consortiaInfo.BadgeBuyTime = DateUtils.dateFormat(beginTime);
            PlayerManager.Instance.Self.consortiaInfo.BadgeID = badgeID;
            PlayerManager.Instance.Self.consortiaInfo.ValidDate = validdate;
            PlayerManager.Instance.Self.badgeID = badgeID;
            badgeInfo = BadgeInfoManager.instance.getBadgeInfoByID(badgeID);
            PlayerManager.Instance.Self.consortiaInfo.Riches -= badgeInfo.Cost;
         }
      }
      
      public function getPerRank() : void
      {
         var urlVariables:URLVariables = new URLVariables();
         urlVariables.UserID = PlayerManager.Instance.Self.ID;
         urlVariables.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("ConsortiaWarPlayerRank.ashx"),BaseLoader.REQUEST_LOADER,urlVariables);
         loader.analyzer = new PersonalRankAnalyze(this.perRankPayHander);
      }
      
      private function perRankPayHander(analyze:PersonalRankAnalyze) : void
      {
         ConsortionModelControl.Instance.dispatchEvent(new ConsortionEvent(ConsortionEvent.PERSONER_RANK_LIST,analyze.dataList));
      }
      
      public function getConsortionRank() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("ConsortiaWarConsortiaRank.ashx"),BaseLoader.REQUEST_LOADER);
         loader.analyzer = new ConsortiaAnalyze(this.ConsortiaRankPayHander);
      }
      
      private function ConsortiaRankPayHander(analyze:ConsortiaAnalyze) : void
      {
         ConsortionModelControl.Instance.dispatchEvent(new ConsortionEvent(ConsortionEvent.CLUB_RANK_LIST,analyze.dataList));
      }
      
      public function alertTaxFrame() : void
      {
         var taxFrame:TaxFrame = ComponentFactory.Instance.creatComponentByStylename("taxFrame");
         LayerManager.Instance.addToLayer(taxFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function alertManagerFrame() : void
      {
         var managerFrame:ManagerFrame = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame");
         LayerManager.Instance.addToLayer(managerFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadUseConditionList(this.useConditionListComplete,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function rankFrame() : void
      {
         var frame:RankFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.RankFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.getPerRank();
      }
      
      public function alertShopFrame() : void
      {
         var shop:ConsortionShopFrame = ComponentFactory.Instance.creatComponentByStylename("consortionShopFrame");
         LayerManager.Instance.addToLayer(shop,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadUseConditionList(this.useConditionListComplete,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function alertBankFrame() : void
      {
         this._consortionBankFrame = ComponentFactory.Instance.creatComponentByStylename("consortionBankFrame");
         LayerManager.Instance.addToLayer(this._consortionBankFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function hideBankFrame() : void
      {
         ObjectUtils.disposeObject(this._consortionBankFrame);
         this._consortionBankFrame = null;
      }
      
      public function clearReference() : void
      {
         this._consortionBankFrame = null;
      }
      
      public function openHelpView() : void
      {
         var frame:HelpFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.helpFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function alertTakeInFrame() : void
      {
         var takeIn:TakeInMemberFrame = ComponentFactory.Instance.creatComponentByStylename("takeInMemberFrame");
         LayerManager.Instance.addToLayer(takeIn,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.getApplyRecordList(this.applyListComplete,-1,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function alertQuitFrame() : void
      {
         var quitFrame:ConsortionQuitFrame = ComponentFactory.Instance.creatComponentByStylename("consortionQuitFrame");
         LayerManager.Instance.addToLayer(quitFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function bossConfigDataSetup(analyzer:ConsortiaBossDataAnalyzer) : void
      {
         this._bossConfigDataList = analyzer.dataList;
      }
      
      public function get bossCallCondition() : int
      {
         if(Boolean(this._bossConfigDataList) && this._bossConfigDataList.length > 0)
         {
            return this._bossConfigDataList[0].level;
         }
         return 100;
      }
      
      public function getCallExtendBossCostRich(type:int, totalLevel:int = 0) : int
      {
         var tmpTotalLevel:int = 0;
         var conInfo:ConsortiaInfo = PlayerManager.Instance.Self.consortiaInfo;
         if(totalLevel == 0)
         {
            tmpTotalLevel = conInfo.Level + conInfo.SmithLevel + conInfo.ShopLevel + conInfo.StoreLevel + conInfo.BufferLevel;
         }
         else
         {
            tmpTotalLevel = totalLevel;
         }
         var rich:int = 100001;
         var len:int = int(this._bossConfigDataList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(tmpTotalLevel < this._bossConfigDataList[i].level)
            {
               break;
            }
            if(type == 1)
            {
               rich = int(this._bossConfigDataList[i].callBossRich);
            }
            else
            {
               rich = int(this._bossConfigDataList[i].extendTimeRich);
            }
         }
         return rich;
      }
      
      public function getCallBossCostRich(level:int) : int
      {
         return this._bossConfigDataList[level - 1].callBossRich;
      }
      
      public function getCanCallBossMaxLevel(totalLevel:int = 0) : int
      {
         var tmpTotalLevel:int = 0;
         var conInfo:ConsortiaInfo = PlayerManager.Instance.Self.consortiaInfo;
         if(totalLevel == 0)
         {
            tmpTotalLevel = conInfo.Level + conInfo.SmithLevel + conInfo.ShopLevel + conInfo.StoreLevel + conInfo.BufferLevel;
         }
         else
         {
            tmpTotalLevel = totalLevel;
         }
         var len:int = int(this._bossConfigDataList.length);
         var tmpMax:int = 1;
         for(var i:int = len - 1; i >= 0; i--)
         {
            if(tmpTotalLevel >= this._bossConfigDataList[i].level)
            {
               tmpMax = i + 1;
               break;
            }
         }
         return tmpMax;
      }
      
      public function getRequestCallBossLevel(level:int) : int
      {
         return this._bossConfigDataList[level - 1].level;
      }
      
      private function bossOpenCloseHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readByte();
         if(type == 0)
         {
            this.isShowBossOpenTip = true;
            this.isBossOpen = true;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossOpenTipTxt"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.consortia.bossOpenTipTxt"));
            if(StateManager.currentStateType == StateType.MAIN)
            {
               SystemOpenPromptManager.instance.showFrame();
            }
         }
         else if(type == 3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossExtendTipTxt"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.consortia.bossExtendTipTxt"));
         }
         else
         {
            this.isShowBossOpenTip = false;
            this.isBossOpen = false;
            if(type == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossCloseTipTxt"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.consortia.bossCloseTipTxt"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossCloseTipTxt2"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.consortia.bossCloseTipTxt2"));
            }
            LoadResourceManager.Instance.startLoad(MailManager.Instance.getAllEmailLoader());
         }
      }
      
      public function openBossFrame() : void
      {
         var bossFrame:ConsortiaBossFrame = null;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            bossFrame = ComponentFactory.Instance.creatComponentByStylename("consortia.boss.frame");
            LayerManager.Instance.addToLayer(bossFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
   }
}

