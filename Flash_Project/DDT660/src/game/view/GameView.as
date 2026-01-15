package game.view
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.info.PlayerInfoViewControl;
   import bombKing.BombKingManager;
   import campbattle.CampBattleManager;
   import catchInsect.CatchInsectMananger;
   import christmas.controller.ChristmasRoomController;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.constants.CacheConsts;
   import ddt.data.BallInfo;
   import ddt.data.BuffType;
   import ddt.data.EquipType;
   import ddt.data.FightAchievModel;
   import ddt.data.FightBuffInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PhyobjEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.BallManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.InviteManager;
   import ddt.manager.ItemManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LoadBombManager;
   import ddt.manager.LogManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PageInterfaceManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SkillManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.utils.PositionUtils;
   import ddt.view.BackgoundView;
   import ddt.view.PropItemView;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ICharacter;
   import ddt.view.character.ShowCharacter;
   import drgnBoat.DrgnBoatManager;
   import escort.EscortManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.TryAgain;
   import game.actions.ChangeBallAction;
   import game.actions.ChangeNpcAction;
   import game.actions.ChangePlayerAction;
   import game.actions.GameOverAction;
   import game.actions.MissionOverAction;
   import game.actions.PickBoxAction;
   import game.actions.PrepareShootAction;
   import game.actions.ViewEachObjectAction;
   import game.model.GameInfo;
   import game.model.GameNeedMovieInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.MissionAgainInfo;
   import game.model.Pet;
   import game.model.Player;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.ActionType;
   import game.objects.ActivityDungeonNextView;
   import game.objects.AnimationObject;
   import game.objects.BombAction;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.objects.GameSmallEnemy;
   import game.objects.GameSysMsgType;
   import game.objects.SimpleBox;
   import game.objects.SimpleObject;
   import game.objects.TransmissionGate;
   import game.view.control.FightControlBar;
   import game.view.control.LiveState;
   import game.view.experience.ExpView;
   import hall.GameLoadingManager;
   import kingDivision.KingDivisionManager;
   import magicStone.stoneExploreView.StoneExploreModel;
   import magicStone.stoneExploreView.StoneExploreNextView;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import phy.object.PhysicalObj;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.transnational.TransnationalFightManager;
   import sevenDouble.SevenDoubleManager;
   import trainer.data.Step;
   
   public class GameView extends GameViewBase
   {
      
      private const ZXC_OFFSET:int = 24;
      
      protected var _msg:String = "";
      
      protected var _tipItems:Dictionary;
      
      protected var _tipLayers:Sprite;
      
      protected var _result:ExpView;
      
      private var _gameLivingArr:Array;
      
      private var _gameLivingIdArr:Array;
      
      private var _objectDic:Dictionary;
      
      private var _evtArray:Array = [GameManager.Instance.addLivingEvtVec,GameManager.Instance.setPropertyEvtVec,GameManager.Instance.livingFallingEvtVec,GameManager.Instance.livingShowBloodEvtVec,GameManager.Instance.addMapThingEvtVec,GameManager.Instance.livingActionMappingEvtVec,GameManager.Instance.updatePhysicObjectEvtVec,GameManager.Instance.playerBloodEvtVec];
      
      private var _evtFuncArray:Array;
      
      private var _animationArray:Array;
      
      private var nextBg:Bitmap;
      
      private var nextPlayerTxtRed:FilterFrameText;
      
      private var nextPlayerTxtBlue:FilterFrameText;
      
      private var _campBattleTerrace:Bitmap;
      
      private var _terraces:Dictionary;
      
      private var _firstEnter:Boolean = false;
      
      private var numCh:Number;
      
      private var _soundPlayFlag:Boolean;
      
      private var _ignoreSmallEnemy:Boolean;
      
      private var _boxArr:Array;
      
      private var finished:int = 0;
      
      private var total:int = 0;
      
      private var props:Array = [10467,10468,10469];
      
      private var _logTimer:Timer;
      
      private var _missionAgain:MissionAgainInfo;
      
      protected var _expView:ExpView;
      
      private var _isPVPover:Boolean;
      
      public function GameView()
      {
         this._evtFuncArray = [this.addliving,this.objectSetProperty,this.livingFalling,this.livingShowBlood,this.addMapThing,this.livingActionMapping,this.updatePhysicObject,this.playerBlood];
         super();
         Mouse.show();
      }
      
      public function playerBlood(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readByte();
         var blood:int = pkg.readInt();
         var addValue:int = pkg.readInt();
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            info.updateBlood(blood,type,addValue);
         }
      }
      
      private function loadResource() : void
      {
         var j:int = 0;
         if(!StartupResourceLoader.firstEnterHall)
         {
            for(j = 0; j < _gameInfo.neededMovies.length; j++)
            {
               if(_gameInfo.neededMovies[j].type == 2)
               {
                  _gameInfo.neededMovies[j].addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
                  _gameInfo.neededMovies[j].startLoad();
               }
            }
         }
      }
      
      private function __loaderComplete(event:LoaderEvent) : void
      {
         var p:SimpleObject = null;
         var j:int = 0;
         var k:int = 0;
         var flag:Boolean = false;
         event.target.removeEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         for each(p in this._objectDic)
         {
            if(p.shouldReCreate)
            {
               p.createMovieAfterLoadComplete();
            }
         }
         if(Boolean(this._gameLivingArr) && Boolean(this._gameLivingIdArr))
         {
            for(j = 0; j < this._gameLivingArr.length; j++)
            {
               (this._gameLivingArr[j] as GameLiving).replaceMovie();
               for(k = 0; k < this._gameLivingIdArr.length; k++)
               {
                  if(this._gameLivingArr[j].Id == this._gameLivingIdArr[k])
                  {
                     flag = true;
                     break;
                  }
               }
               _playerThumbnailLController.updateHeadFigure(this._gameLivingArr[j],flag);
            }
         }
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         var j:int = 0;
         GameManager.Instance.gameView = this;
         this._gameLivingArr = new Array();
         this._gameLivingIdArr = new Array();
         this._objectDic = new Dictionary();
         this._animationArray = new Array();
         GameLoadingManager.Instance.hide();
         super.enter(prev,data);
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this.initShowNextPlayer();
         }
         InviteManager.Instance.enabled = false;
         this.loadResource();
         KeyboardManager.getInstance().isStopDispatching = false;
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,false);
         _gameInfo.resetResultCard();
         _gameInfo.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.addEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         GameManager.Instance.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,this.__getTempItem);
         GameManager.Instance.addEventListener(GameEvent.ADDTERRACE,this.addTerraceHander);
         GameManager.Instance.addEventListener(GameEvent.DELTERRACE,this.delTerraceHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PICK_BOX,this.__pickBox);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,this.__livingSmallColorChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TRUSTEESHIP,this.__gameTrusteeship);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_REVIVE,this.__revivePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_STATUS,this.__fightStatusChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLEAR_DEBUFF,this.__clearDebuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_ANIMATION,this.__addAnimation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
         StatisticManager.Instance().startAction(StatisticManager.GAME,"yes");
         this._tipItems = new Dictionary(true);
         CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         BackgoundView.Instance.hide();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_TAKEOUTALL,this.__takeoutAll);
         GameManager.Instance.Current.addEventListener("showNextPlayer",this._showNextPlayer);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_END,this.__turnEnd);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_HOME,this.__turnHome);
         if(StartupResourceLoader.firstEnterHall)
         {
            this._firstEnter = true;
            StartupResourceLoader.Instance.addThirdGameUI();
            StartupResourceLoader.Instance.startLoadRelatedInfo();
         }
         else
         {
            this._firstEnter = false;
            BuffManager.startLoadBuffEffect();
         }
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_4) && _gameInfo.loaderMap.info.ID == 1120)
         {
            NoviceDataManager.instance.saveNoviceData(1070,PathManager.userName(),PathManager.solveRequestPath());
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_GUIDE_4);
         }
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.FIRST_ENTER_NESTTWO) && _gameInfo.loaderMap.info.ID == 1121)
         {
            NoviceDataManager.instance.saveNoviceData(1100,PathManager.userName(),PathManager.solveRequestPath());
         }
         this._terraces = new Dictionary();
         if(GameManager.Instance.isAddTerrce)
         {
            this.addTerrce(GameManager.Instance.terrceX,GameManager.Instance.terrceY,GameManager.Instance.terrceID);
         }
         var roomType:int = RoomManager.Instance.current.type;
         if(this.guideTip() && roomType != RoomInfo.DUNGEON_ROOM && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && roomType != RoomInfo.ACADEMY_DUNGEON_ROOM && !this.isNewHand())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.MessageTip.AutoGuidFightBegin"));
         }
         GameManager.Instance.viewCompleteFlag = true;
         for(var i:int = 0; i < this._evtFuncArray.length; i++)
         {
            for(j = 0; j < this._evtArray[i].length; j++)
            {
               this._evtFuncArray[i](this._evtArray[i][j]);
            }
            this._evtArray[i].length = 0;
         }
      }
      
      private function __turnEnd() : void
      {
      }
      
      private function __turnHome() : void
      {
      }
      
      private function addTerraceHander(e:GameEvent) : void
      {
         this.addTerrce(e.data[0],e.data[1],e.data[2]);
      }
      
      private function addTerrce(x:int, y:int, livingID:int) : void
      {
         var campBattleTerrace:Bitmap = null;
         if(Boolean(this._terraces[livingID]))
         {
            return;
         }
         campBattleTerrace = ComponentFactory.Instance.creat("camp.battle.terrace");
         campBattleTerrace.x = x - campBattleTerrace.width / 2;
         campBattleTerrace.y = y;
         _map.addChild(campBattleTerrace);
         this._terraces[livingID] = campBattleTerrace;
      }
      
      private function delTerraceHander(e:GameEvent) : void
      {
         var campBattleTerrace:Bitmap = this._terraces[e.data[0]];
         if(Boolean(campBattleTerrace))
         {
            campBattleTerrace.bitmapData.dispose();
            campBattleTerrace = null;
            delete this._terraces[e.data[0]];
         }
      }
      
      private function initShowNextPlayer() : void
      {
         this.nextBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.gameView.nextPlayer");
         this.nextPlayerTxtBlue = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.gameView.nextPlayerBlue");
         this.nextPlayerTxtRed = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.gameView.nextPlayerRed");
         this.nextBg.visible = false;
         this.nextPlayerTxtBlue.visible = false;
         this.nextPlayerTxtRed.visible = false;
         addChild(this.nextBg);
         addChild(this.nextPlayerTxtBlue);
         addChild(this.nextPlayerTxtRed);
      }
      
      private function _showNextPlayer(e:Event) : void
      {
         var name:String = null;
         var team:int = 0;
         var gameinfo:GameInfo = e.currentTarget as GameInfo;
         var nextPlayerId:int = gameinfo.nextPlayerId;
         var currentPlayerId:int = gameinfo.currentPlayerId;
         if(nextPlayerId == 0)
         {
            this.nextPlayerTxtBlue.visible = false;
            this.nextPlayerTxtRed.visible = false;
            this.nextBg.visible = false;
            return;
         }
         name = gameinfo.findPlayerByPlayerID(nextPlayerId).playerInfo.NickName;
         team = gameinfo.findPlayerByPlayerID(nextPlayerId).team;
         if(currentPlayerId == gameinfo.selfGamePlayer.playerInfo.ID)
         {
            this.nextPlayerTxtBlue.visible = false;
            this.nextPlayerTxtRed.visible = false;
            this.nextBg.visible = false;
         }
         else if(team == 1)
         {
            this.nextPlayerTxtBlue.text = name;
            this.nextPlayerTxtBlue.visible = true;
            this.nextPlayerTxtRed.visible = false;
            this.nextBg.visible = true;
         }
         else if(team == 2)
         {
            this.nextPlayerTxtRed.text = name;
            this.nextPlayerTxtRed.visible = true;
            this.nextPlayerTxtBlue.visible = false;
            this.nextBg.visible = true;
         }
      }
      
      private function __takeoutAll(e:CrazyTankSocketEvent) : void
      {
         if(FightFootballTimeManager.instance.takeoutAll)
         {
         }
      }
      
      private function dioposeTerraces() : void
      {
         var terrace:Bitmap = null;
         for each(terrace in this._terraces)
         {
            if(Boolean(terrace))
            {
               terrace.bitmapData.dispose();
            }
            terrace = null;
         }
         this._terraces = null;
      }
      
      private function retrunPlayer(id:int) : GamePlayer
      {
         var p:GamePlayer = null;
         for each(p in _players)
         {
            if(p.info.LivingID == id)
            {
               return p;
            }
         }
         return null;
      }
      
      private function addNewPlayerHander(event:CrazyTankSocketEvent) : void
      {
         var sex:Boolean = false;
         var Hide:int = 0;
         var Style:String = null;
         var Colors:String = null;
         var Skin:String = null;
         var r:int = 0;
         var pic:String = null;
         var date:String = null;
         var place:int = 0;
         var p:PetInfo = null;
         var ptd:int = 0;
         var activedSkillCount:int = 0;
         var k:int = 0;
         var splace:int = 0;
         var sid:int = 0;
         var deputyWeaponCount:int = 0;
         var buff:FightBuffInfo = null;
         var data:int = 0;
         var Buff:FightBuffInfo = null;
         var K:String = null;
         var Value:String = null;
         var gm:GameInfo = GameManager.Instance.Current;
         var pkg:PackageIn = event.pkg;
         var zoneID:int = pkg.readInt();
         var zoneName:String = pkg.readUTF();
         var id:int = pkg.readInt();
         var sp:PlayerInfo = new PlayerInfo();
         sp.beginChanges();
         var fp:RoomPlayer = RoomManager.Instance.current.findPlayerByID(id,zoneID);
         if(fp == null)
         {
            fp = new RoomPlayer(sp);
         }
         sp.ID = id;
         sp.ZoneID = zoneID;
         var nickName:String = pkg.readUTF();
         var isViewer:Boolean = pkg.readBoolean();
         if(isViewer && fp.place < 8)
         {
            fp.place = 8;
         }
         sp.NickName = nickName;
         sp.typeVIP = pkg.readByte();
         sp.VIPLevel = pkg.readInt();
         if(PlayerManager.Instance.isChangeStyleTemp(sp.ID))
         {
            pkg.readBoolean();
            pkg.readInt();
            pkg.readUTF();
            pkg.readUTF();
            pkg.readUTF();
         }
         else
         {
            sex = pkg.readBoolean();
            Hide = pkg.readInt();
            Style = pkg.readUTF();
            Colors = pkg.readUTF();
            Skin = pkg.readUTF();
            sp.Sex = sex;
            sp.Hide = Hide;
            sp.Style = Style;
            sp.Colors = Colors;
            sp.Skin = Skin;
         }
         sp.Grade = pkg.readInt();
         sp.Repute = pkg.readInt();
         sp.WeaponID = pkg.readInt();
         if(sp.WeaponID != 0)
         {
            r = pkg.readInt();
            pic = pkg.readUTF();
            date = pkg.readDateString();
         }
         sp.DeputyWeaponID = pkg.readInt();
         sp.pvpBadgeId = pkg.readInt();
         sp.Nimbus = pkg.readInt();
         sp.IsShowConsortia = pkg.readBoolean();
         sp.ConsortiaID = pkg.readInt();
         sp.ConsortiaName = pkg.readUTF();
         sp.badgeID = pkg.readInt();
         var unknown1:int = pkg.readInt();
         var unknown2:int = pkg.readInt();
         sp.WinCount = pkg.readInt();
         sp.TotalCount = pkg.readInt();
         sp.FightPower = pkg.readInt();
         sp.apprenticeshipState = pkg.readInt();
         sp.masterID = pkg.readInt();
         sp.setMasterOrApprentices(pkg.readUTF());
         sp.AchievementPoint = pkg.readInt();
         sp.honor = pkg.readUTF();
         sp.Offer = pkg.readInt();
         sp.DailyLeagueFirst = pkg.readBoolean();
         sp.DailyLeagueLastScore = pkg.readInt();
         sp.commitChanges();
         fp.playerInfo.IsMarried = pkg.readBoolean();
         if(fp.playerInfo.IsMarried)
         {
            fp.playerInfo.SpouseID = pkg.readInt();
            fp.playerInfo.SpouseName = pkg.readUTF();
         }
         fp.additionInfo.resetAddition();
         fp.additionInfo.GMExperienceAdditionType = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherExperienceAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.GMOfferAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherOfferAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.GMRichesAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherRichesAddition = Number(pkg.readInt() / 100);
         fp.team = pkg.readInt();
         gm.addRoomPlayer(fp);
         var livingID:int = pkg.readInt();
         var blood:int = pkg.readInt();
         var info:Player = new Player(fp.playerInfo,livingID,fp.team,blood);
         var count:int = pkg.readInt();
         for(var j:int = 0; j < count; j++)
         {
            place = pkg.readInt();
            p = sp.pets[place];
            ptd = pkg.readInt();
            if(p == null)
            {
               p = new PetInfo();
               p.TemplateID = ptd;
               PetInfoManager.fillPetInfo(p);
            }
            p.ID = pkg.readInt();
            p.Name = pkg.readUTF();
            p.UserID = pkg.readInt();
            p.Level = pkg.readInt();
            p.IsEquip = true;
            p.clearEquipedSkills();
            activedSkillCount = pkg.readInt();
            for(k = 0; k < activedSkillCount; k++)
            {
               splace = pkg.readInt();
               sid = pkg.readInt();
               p.equipdSkills.add(splace,sid);
            }
            p.Place = place;
            sp.pets.add(p.Place,p);
         }
         info.zoneName = zoneName;
         info.currentWeapInfo.refineryLevel = r;
         if(!fp.isViewer)
         {
            gm.addGamePlayer(info);
         }
         else
         {
            if(fp.isSelf)
            {
               gm.setSelfGamePlayer(info);
            }
            gm.addGameViewer(info);
         }
         var livingID1:int = pkg.readInt();
         var x:int = pkg.readInt();
         var y:int = pkg.readInt();
         info.pos = new Point(x,y);
         info.energy = 1;
         info.direction = pkg.readInt();
         var blood2:int = pkg.readInt();
         var maxBlood:int = pkg.readInt();
         info.team = pkg.readInt();
         var refineryLevel:int = pkg.readInt();
         if(info is LocalPlayer)
         {
            (info as LocalPlayer).deputyWeaponCount = pkg.readInt();
         }
         else
         {
            deputyWeaponCount = pkg.readInt();
         }
         info.powerRatio = pkg.readInt();
         info.dander = pkg.readInt();
         info.maxBlood = maxBlood;
         info.updateBlood(blood,0,0);
         info.wishKingCount = pkg.readInt();
         info.wishKingEnergy = pkg.readInt();
         info.currentWeapInfo.refineryLevel = refineryLevel;
         var count1:int = pkg.readInt();
         for(var t_j:int = 0; t_j < count1; t_j++)
         {
            buff = BuffManager.creatBuff(pkg.readInt());
            data = pkg.readInt();
            if(Boolean(buff))
            {
               buff.data = data;
               info.addBuff(buff);
            }
         }
         var buffCount:int = pkg.readInt();
         var buffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
         for(var l:int = 0; l < buffCount; l++)
         {
            Buff = BuffManager.creatBuff(pkg.readInt());
            info.outTurnBuffs.push(Buff);
         }
         var isFrost:Boolean = pkg.readBoolean();
         var isHide:Boolean = pkg.readBoolean();
         var isNoHole:Boolean = pkg.readBoolean();
         var sealSatesCount:int = pkg.readInt();
         var sealSates:Dictionary = new Dictionary();
         for(var I:int = 0; I < sealSatesCount; I++)
         {
            K = pkg.readUTF();
            Value = pkg.readUTF();
            sealSates[K] = Value;
         }
         if(isFrost)
         {
            isFrost = false;
         }
         info.isFrozen = isFrost;
         info.isHidden = isHide;
         info.isNoNole = isNoHole;
         info.outProperty = sealSates;
         if(RoomManager.Instance.current.type != 5 && Boolean(info.playerInfo.currentPet))
         {
            info.currentPet = new Pet(info.playerInfo.currentPet);
            this.petResLoad(info.playerInfo.currentPet);
         }
         var arr:Array = [fp];
         LoadBombManager.Instance.loadFullRoomPlayersBomb(arr);
         var movie:ICharacter = CharactoryFactory.createCharacter(info.playerInfo,"game");
         movie.show();
         var character:ICharacter = CharactoryFactory.createCharacter(info.playerInfo,"show");
         ShowCharacter(character).show();
         info.character = ShowCharacter(character);
         var player:GamePlayer = new GamePlayer(info,info.character,GameCharacter(movie));
         _map.addPhysical(player);
         _players[info] = player;
         _playerThumbnailLController.addNewLiving(info);
      }
      
      private function petResLoad(currentPet:PetInfo) : void
      {
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         if(Boolean(currentPet))
         {
            LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(currentPet.GameAssetUrl),BaseLoader.MODULE_LOADER);
            for each(skillid in currentPet.equipdSkills)
            {
               if(skillid > 0)
               {
                  skill = PetSkillManager.getSkillByID(skillid);
                  if(Boolean(skill.EffectPic))
                  {
                     LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(skill.EffectPic),BaseLoader.MODULE_LOADER);
                  }
                  if(skill.NewBallID != -1)
                  {
                     ball = BallManager.findBall(skill.NewBallID);
                     ball.loadBombAsset();
                     ball.loadCraterBitmap();
                  }
               }
            }
         }
      }
      
      protected function __pickBox(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var tmpArray:Array = [];
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            tmpArray.push(pkg.readInt());
         }
         _map.dropOutBox(tmpArray);
         this.hideAllOther();
      }
      
      private function guideTip() : Boolean
      {
         var liv:Living = null;
         var player:Player = null;
         if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
         {
            return false;
         }
         var _allLivings:DictionaryData = GameManager.Instance.Current.livings;
         if(!_allLivings)
         {
            return false;
         }
         for each(liv in _allLivings)
         {
            player = liv as Player;
            if(Boolean(player) && (liv as Player).playerInfo.Grade <= 15)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isNewHand() : Boolean
      {
         var mapId:int = RoomManager.Instance.current.mapId;
         if(mapId == 112 || mapId == 113 || mapId == 114 || mapId == 115 || mapId == 116)
         {
            return true;
         }
         return false;
      }
      
      private function __gameSysMessage(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var msgType:int = pkg.readInt();
         var msg:String = pkg.readUTF();
         var para:int = pkg.readInt();
         switch(msgType)
         {
            case GameSysMsgType.GET_ITEM_INVENTORY_FULL:
               MessageTipManager.getInstance().show(String(para),2);
         }
      }
      
      private function __fightAchievement(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var living:Living = null;
         var achiev:int = 0;
         var num:int = 0;
         var interval:int = 0;
         var now:int = 0;
         var animate:AchieveAnimation = null;
         if(PathManager.getFightAchieveEnable())
         {
            if(_achievBar == null)
            {
               _achievBar = ComponentFactory.Instance.creatCustomObject("FightAchievBar");
               addChild(_achievBar);
            }
            pkg = event.pkg;
            living = GameManager.Instance.Current.findLiving(pkg.clientId);
            achiev = pkg.readInt();
            num = pkg.readInt();
            interval = pkg.readInt();
            now = getTimer();
            animate = _achievBar.getAnimate(achiev);
            if(animate == null)
            {
               _achievBar.addAnimate(ComponentFactory.Instance.creatCustomObject("AchieveAnimation",[achiev,num,interval,now]));
            }
            else if(FightAchievModel.getInstance().isNumAchiev(achiev))
            {
               animate.setNum(num);
            }
            else
            {
               _achievBar.rePlayAnimate(animate);
            }
         }
      }
      
      private function onClick(event:MouseEvent) : void
      {
         var ch:DisplayObject = null;
         this.numCh = 0;
         for(var i:int = 0; i < stage.numChildren; i++)
         {
            ch = StageReferance.stage.getChildAt(i);
            ch.visible = true;
            ++this.numCh;
            if(ch is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(ch));
            }
         }
      }
      
      private function show(dis:DisplayObjectContainer) : void
      {
         var ch:DisplayObject = null;
         for(var i:int = 0; i < dis.numChildren; i++)
         {
            ch = dis.getChildAt(i);
            ch.visible = true;
            ++this.numCh;
            if(ch is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(ch));
            }
         }
      }
      
      private function __windChanged(e:GameEvent) : void
      {
         if(Boolean(_map))
         {
            _map.wind = e.data.wind;
            _vane.update(_map.wind,e.data.isSelfTurn,e.data.windNumArr);
         }
      }
      
      override public function getType() : String
      {
         return StateType.FIGHTING;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         var obj:SimpleObject = null;
         var simpleObj:SimpleObject = null;
         var i:int = 0;
         GameManager.Instance.viewCompleteFlag = false;
         InviteManager.Instance.enabled = true;
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onClick);
         SoundManager.instance.stopMusic();
         PageInterfaceManager.restorePageTitle();
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,true);
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         _gameInfo.removeEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         _gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.removeAllMonsters();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,this.__getTempItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PICK_BOX,this.__pickBox);
         GameManager.Instance.removeEventListener(GameEvent.ADDTERRACE,this.addTerraceHander);
         GameManager.Instance.removeEventListener(GameEvent.DELTERRACE,this.delTerraceHander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,this.__livingSmallColorChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TRUSTEESHIP,this.__gameTrusteeship);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,this.__revivePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_STATUS,this.__fightStatusChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CLEAR_DEBUFF,this.__clearDebuff);
         for each(obj in this._tipItems)
         {
            delete this._tipLayers[obj.Id];
            obj.dispose();
            obj = null;
         }
         this._tipItems = null;
         if(Boolean(this._tipLayers))
         {
            if(Boolean(this._tipLayers.parent))
            {
               this._tipLayers.parent.removeChild(this._tipLayers);
            }
         }
         this._tipLayers = null;
         _gameInfo.resetBossCardCnt();
         if(Boolean(this._expView))
         {
            this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         }
         super.leaving(next);
         if(StateManager.isExitRoom(next.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         else if(StateManager.isExitGame(next.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
         }
         BallManager.clearAsset();
         BackgoundView.Instance.show();
         PlayerInfoViewControl._isBattle = false;
         PlayerInfoViewControl.isOpenFromBag = false;
         CampBattleManager.instance.model.isFighting = false;
         this.dioposeTerraces();
         this._gameLivingArr = null;
         this._gameLivingIdArr = null;
         for each(simpleObj in this._objectDic)
         {
            delete this._objectDic[simpleObj.Id];
            simpleObj.dispose();
            simpleObj = null;
         }
         this._objectDic = null;
         for(i = 0; i < this._animationArray.length; i++)
         {
            this._animationArray[i].dispose();
            this._animationArray[i] = null;
         }
         GameManager.Instance.isAddTerrce = false;
         if(Boolean(this._logTimer))
         {
            this._logTimer.removeEventListener(TimerEvent.TIMER,this.logTimeHandler);
            this._logTimer.stop();
         }
         this._logTimer = null;
      }
      
      override public function addedToStage() : void
      {
         super.addedToStage();
         stage.focus = _map;
      }
      
      override public function getBackType() : String
      {
         if(_gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
         {
            return StateType.CHALLENGE_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.MATCH_ROOM)
         {
            return StateType.MATCH_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM)
         {
            return StateType.FIGHT_LIB;
         }
         if(_gameInfo.roomType == RoomInfo.FRESHMAN_ROOM)
         {
            if(StartupResourceLoader.firstEnterHall)
            {
               return StateType.FRESHMAN_ROOM2;
            }
            return StateType.FRESHMAN_ROOM1;
         }
         return StateType.DUNGEON_ROOM;
      }
      
      protected function __playerChange(event:CrazyTankSocketEvent) : void
      {
         var liv:Living = null;
         var ls:LiveState = null;
         var player:Player = null;
         var gameLiving:GameLiving = null;
         PageInterfaceManager.restorePageTitle();
         if(Boolean(_selfMarkBar))
         {
            _selfMarkBar.shutdown();
         }
         _map.currentFocusedLiving = null;
         var id:int = event.pkg.extend1;
         var info:Living = _gameInfo.findLiving(id);
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            player = info as Player;
            GameManager.Instance.Current.currentPlayerId = player.playerInfo.ID;
         }
         _gameInfo.currentLiving = info;
         if(info is TurnedLiving)
         {
            this._ignoreSmallEnemy = false;
            if(!info.isLiving)
            {
               setCurrentPlayer(null);
               return;
            }
            if(info.isBoss)
            {
               if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
               {
                  updateDamageView();
               }
            }
            if(info.playerInfo == PlayerManager.Instance.Self)
            {
               PageInterfaceManager.changePageTitle();
            }
            event.executed = false;
            this._soundPlayFlag = true;
            if(info is LocalPlayer && _gameTrusteeshipView && _gameTrusteeshipView.trusteeshipState)
            {
               new ChangePlayerAction(_map,info as TurnedLiving,event,event.pkg,0,0).executeAtOnce();
            }
            else
            {
               _map.act(new ChangePlayerAction(_map,info as TurnedLiving,event,event.pkg));
            }
         }
         else
         {
            _map.act(new ChangeNpcAction(this,_map,info as Living,event,event.pkg,this._ignoreSmallEnemy));
            if(!this._ignoreSmallEnemy)
            {
               this._ignoreSmallEnemy = true;
            }
         }
         var dic:DictionaryData = GameManager.Instance.Current.livings;
         for each(liv in dic)
         {
            gameLiving = this.getGameLivingByID(liv.LivingID) as GameLiving;
            if(Boolean(gameLiving))
            {
               gameLiving.fightPowerVisible = false;
            }
         }
         ls = _cs as LiveState;
         if(Boolean(ls))
         {
            if(Boolean(ls.rescuePropBar))
            {
               ls.rescuePropBar.setKingBlessEnable();
            }
            if(Boolean(ls.insectProBar))
            {
               ls.insectProBar.setEnable(true);
               ls.rightPropBar.showPropBar();
            }
            if(Boolean(ls.treasureLostProBar))
            {
               ls.treasureLostProBar.setEnable(true);
            }
         }
         PrepareShootAction.hasDoSkillAnimation = false;
      }
      
      private function __playMovie(event:CrazyTankSocketEvent) : void
      {
         var type:String = null;
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(living))
         {
            type = event.pkg.readUTF();
            living.playMovie(type);
            _map.bringToFront(living);
         }
      }
      
      private function __livingTurnRotation(event:CrazyTankSocketEvent) : void
      {
         var rota:int = 0;
         var roSpeed:Number = NaN;
         var type:String = null;
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(living))
         {
            rota = event.pkg.readInt() / 10;
            roSpeed = event.pkg.readInt() / 10;
            type = event.pkg.readUTF();
            living.turnRotation(rota,roSpeed,type);
            _map.bringToFront(living);
         }
      }
      
      public function addliving(event:CrazyTankSocketEvent) : void
      {
         var living:Living = null;
         var gameLiving:GameLiving = null;
         var Key:String = null;
         var KEY:String = null;
         var key:String = null;
         var value:String = null;
         var buff:FightBuffInfo = null;
         var K:String = null;
         var Value:String = null;
         var bossID:int = 0;
         var ls:LiveState = null;
         var pkg:PackageIn = event.pkg;
         var livingType:int = pkg.readByte();
         var ID:int = pkg.readInt();
         var Name:String = pkg.readUTF();
         var ActionMovie:String = pkg.readUTF();
         var specificAction:String = pkg.readUTF();
         var Pos:Point = new Point(pkg.readInt(),pkg.readInt());
         var currentHP:int = pkg.readInt();
         var MaxBoold:int = pkg.readInt();
         var team:int = pkg.readInt();
         var direction:int = pkg.readByte();
         var temp:int = pkg.readByte();
         var isBottom:Boolean = temp == 0 ? true : false;
         var isShowBlood:Boolean = pkg.readBoolean();
         var isShowSmallMapPoint:Boolean = pkg.readBoolean();
         var actionCount:int = pkg.readInt();
         var labelMapping:Dictionary = new Dictionary();
         for(var j:int = 0; j < actionCount; j++)
         {
            key = pkg.readUTF();
            value = pkg.readUTF();
            labelMapping[key] = value;
         }
         var buffCount:int = pkg.readInt();
         var buffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
         for(var i:int = 0; i < buffCount; i++)
         {
            buff = BuffManager.creatBuff(pkg.readInt());
            buffs.push(buff);
         }
         var isFrost:Boolean = pkg.readBoolean();
         var isHide:Boolean = pkg.readBoolean();
         var isNoHole:Boolean = pkg.readBoolean();
         var isBubble:Boolean = pkg.readBoolean();
         var sealSatesCount:int = pkg.readInt();
         var sealSates:Dictionary = new Dictionary();
         for(var I:int = 0; I < sealSatesCount; I++)
         {
            K = pkg.readUTF();
            Value = pkg.readUTF();
            sealSates[K] = Value;
         }
         if(Boolean(_map) && Boolean(_map.getPhysical(ID)))
         {
            _map.getPhysical(ID).dispose();
         }
         if(livingType != 4 && livingType != 5 && livingType != 6 && livingType != 12)
         {
            living = new SmallEnemy(ID,team,MaxBoold);
            living.typeLiving = livingType;
            living.actionMovieName = ActionMovie;
            living.direction = direction;
            living.pos = Pos;
            living.name = Name;
            living.isBottom = isBottom;
            living.isShowBlood = isShowBlood;
            living.isShowSmallMapPoint = isShowSmallMapPoint;
            _gameInfo.addGamePlayer(living);
            gameLiving = new GameSmallEnemy(living as SmallEnemy);
            this._gameLivingArr.push(gameLiving);
            if(currentHP != living.maxBlood)
            {
               living.initBlood(currentHP);
            }
            if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               explorersLiving = _gameInfo.findLivingByName(LanguageMgr.GetTranslation("activity.dungeonView.explorers"));
            }
         }
         else
         {
            living = new SimpleBoss(ID,team,MaxBoold);
            living.typeLiving = livingType;
            living.actionMovieName = ActionMovie;
            living.direction = direction;
            living.pos = Pos;
            living.name = Name;
            living.isBottom = isBottom;
            living.isShowBlood = isShowBlood;
            living.isShowSmallMapPoint = isShowSmallMapPoint;
            _gameInfo.addGamePlayer(living);
            gameLiving = new GameSimpleBoss(living as SimpleBoss);
            this._gameLivingArr.push(gameLiving);
            if(currentHP != living.maxBlood)
            {
               living.initBlood(currentHP);
            }
            if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               bossID = pkg.readInt();
               GameManager.Instance.bossName = Name;
               GameManager.Instance.currentNum = bossID - (bossID > 70003 ? 70002 : 70000);
               addMessageBtn();
               if(!this.barrier)
               {
                  fadingComplete();
               }
               this.barrier.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_ACTIVITYDUNGEON_INFO));
            }
            if(RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
            {
               ls = _cs as LiveState;
               if(Boolean(ls) && Boolean(ls.insectProBar))
               {
                  ls.insectProBar.showBallTips();
               }
            }
         }
         for(; i < buffs.length; i++)
         {
            living.addBuff(buffs[i]);
         }
         for(Key in labelMapping)
         {
            gameLiving.setActionMapping(Key,labelMapping[Key]);
         }
         gameLiving.name = Name;
         _map.addPhysical(gameLiving);
         if(currentHP != living.maxBlood)
         {
            living.initBlood(currentHP);
         }
         if(specificAction.length > 0)
         {
            gameLiving.doAction(specificAction);
         }
         else if(!labelMapping[Living.STAND_ACTION])
         {
            gameLiving.doAction(Living.BORN_ACTION);
         }
         else
         {
            gameLiving.doAction(Living.STAND_ACTION);
         }
         gameLiving.info.isFrozen = isFrost;
         gameLiving.info.isHidden = isHide;
         gameLiving.info.isNoNole = isNoHole;
         for(KEY in sealSates)
         {
            setProperty(gameLiving,KEY,sealSates[KEY]);
         }
         _playerThumbnailLController.addLiving(gameLiving);
         addChild(_playerThumbnailLController);
         if(living is SimpleBoss)
         {
            _map.setCenter(gameLiving.x,gameLiving.y - 150,false);
         }
         else
         {
            _map.setCenter(gameLiving.x,gameLiving.y - 150,true);
         }
      }
      
      protected function __addAnimation(event:CrazyTankSocketEvent) : void
      {
         var type:int = 0;
         var time:Number = NaN;
         var goodsStr:String = null;
         var goodsArr:Array = null;
         var isNext:Boolean = false;
         var i:int = 0;
         var nextView:ActivityDungeonNextView = null;
         var nextExploreView:StoneExploreNextView = null;
         var obj:AnimationObject = null;
         var pkg:PackageIn = event.pkg;
         type = pkg.readInt();
         var flag:Boolean = pkg.readBoolean();
         var id:int = pkg.readInt();
         time = pkg.readDate().time;
         if(RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM)
         {
            goodsStr = pkg.readUTF();
            goodsArr = goodsStr == "" ? [] : goodsStr.split("|");
            isNext = pkg.readBoolean();
         }
         var player:RoomPlayer = RoomManager.Instance.findRoomPlayer(id);
         var livingPlayer:Player = _gameInfo.findLivingByPlayerID(id,player.playerInfo.ZoneID);
         if(flag)
         {
            switch(type)
            {
               case 1:
                  nextView = new ActivityDungeonNextView(type,time);
                  PositionUtils.setPos(nextView,"game.view.activityDungeonNextView.viewPos");
                  if(player.isViewer || !livingPlayer.isLiving)
                  {
                     nextView.setBtnEnable();
                  }
                  this.hideView(false);
                  updateDamageView();
                  this._animationArray.push(nextView);
                  this.deleteAnimation(2);
                  break;
               case 2:
                  if(livingPlayer.isLiving)
                  {
                     obj = new AnimationObject(2,"asset.game.lightning");
                     PositionUtils.setPos(obj,"game.view.activityDungeon.lightningPos");
                     this._animationArray.push(obj);
                  }
                  break;
               case StoneExploreModel.NEXT_NUMBER:
                  nextExploreView = new StoneExploreNextView(type,isNext);
                  if(goodsArr != null && goodsArr.length > 0)
                  {
                     nextExploreView.setData(goodsArr);
                  }
                  else
                  {
                     nextExploreView.setQuitPos();
                  }
                  PositionUtils.setPos(nextExploreView,"game.view.StoneExploreNextView.nextExploreViewPos");
                  if(player.isViewer || !livingPlayer.isLiving)
                  {
                     nextExploreView.setBtnEnable();
                  }
                  this.hideView(false);
                  this._animationArray.push(nextExploreView);
                  this.deleteAnimation(2);
            }
            for(i = 0; i < this._animationArray.length; i++)
            {
               addChild(this._animationArray[i]);
            }
         }
         else
         {
            this.deleteAnimation(type);
            this.hideView(true);
            StageReferance.stage.focus = _map;
         }
      }
      
      public function deleteAnimation(type:int) : void
      {
         for(var i:int = 0; i < this._animationArray.length; i++)
         {
            if(type == this._animationArray[i].Id)
            {
               removeChild(this._animationArray[i]);
               this._animationArray[i].dispose();
               this._animationArray[i] = null;
               this._animationArray.splice(i,1);
            }
         }
      }
      
      public function hideView(flag:Boolean) : void
      {
         if(Boolean(_selfMarkBar))
         {
            _selfMarkBar.visible = flag;
         }
         if(Boolean(_cs))
         {
            _cs.visible = flag;
         }
         if(Boolean(_selfBuffBar))
         {
            _selfBuffBar.visible = flag;
         }
         if(Boolean(_kingblessIcon))
         {
            _kingblessIcon.visible = flag;
         }
         if(Boolean(_playerThumbnailLController))
         {
            _playerThumbnailLController.visible = flag;
         }
         if(Boolean(ChatManager.Instance.view))
         {
            ChatManager.Instance.view.visible = flag;
         }
         if(Boolean(_leftPlayerView))
         {
            _leftPlayerView.visible = flag;
         }
         if(Boolean(_vane))
         {
            _vane.visible = flag;
         }
         if(Boolean(_barrier))
         {
            _barrier.visible = flag;
         }
      }
      
      private function __addTipLayer(evt:CrazyTankSocketEvent) : void
      {
         var tipMovie:MovieClip = null;
         var c:Class = null;
         var mcw:MovieClipWrapper = null;
         var obj:SimpleObject = null;
         var id:int = evt.pkg.readInt();
         var type:int = evt.pkg.readInt();
         var px:int = evt.pkg.readInt();
         var py:int = evt.pkg.readInt();
         var model:String = evt.pkg.readUTF();
         var action:String = evt.pkg.readUTF();
         var pscale:int = evt.pkg.readInt();
         var protation:int = evt.pkg.readInt();
         if(type == 10)
         {
            if(ModuleLoader.hasDefinition(model))
            {
               c = ModuleLoader.getDefinition(model) as Class;
               tipMovie = new c() as MovieClip;
               mcw = new MovieClipWrapper(tipMovie,false,true);
               this.addTipSprite(mcw.movie);
               mcw.gotoAndPlay(1);
            }
         }
         else
         {
            if(Boolean(this._tipItems[id]))
            {
               obj = this._tipItems[id] as SimpleObject;
            }
            else
            {
               obj = new SimpleObject(id,type,model,action);
               this.addTipSprite(obj);
            }
            obj.playAction(action);
            this._tipItems[id] = obj;
         }
      }
      
      private function addTipSprite(obj:Sprite) : void
      {
         if(!this._tipLayers)
         {
            this._tipLayers = new Sprite();
            this._tipLayers.mouseEnabled = false;
            this._tipLayers.mouseChildren = false;
            addChild(this._tipLayers);
         }
         this._tipLayers.addChild(obj);
      }
      
      private function hideAllOther() : void
      {
         ObjectUtils.disposeObject(_selfMarkBar);
         _selfMarkBar = null;
         ObjectUtils.disposeObject(_cs);
         _cs = null;
         ObjectUtils.disposeObject(_selfBuffBar);
         _selfBuffBar = null;
         ObjectUtils.disposeObject(_kingblessIcon);
         _kingblessIcon = null;
         _playerThumbnailLController.visible = false;
         ChatManager.Instance.view.visible = false;
         _leftPlayerView.visible = false;
         _vane.visible = false;
         _barrier.visible = false;
      }
      
      public function addMapThing(evt:CrazyTankSocketEvent) : void
      {
         var Key:String = null;
         var key:String = null;
         var value:String = null;
         var id:int = evt.pkg.readInt();
         var type:int = evt.pkg.readInt();
         var px:int = evt.pkg.readInt();
         var py:int = evt.pkg.readInt();
         var model:String = evt.pkg.readUTF();
         var action:String = evt.pkg.readUTF();
         var pscaleX:int = evt.pkg.readInt();
         var pscaleY:int = evt.pkg.readInt();
         var protation:int = evt.pkg.readInt();
         var layer:int = evt.pkg.readInt();
         var containerID:int = evt.pkg.readInt();
         var labelMappingCount:int = evt.pkg.readInt();
         var labelMapping:Dictionary = new Dictionary();
         for(var j:int = 0; j < labelMappingCount; j++)
         {
            key = evt.pkg.readUTF();
            value = evt.pkg.readUTF();
            labelMapping[key] = value;
         }
         var obj:SimpleObject = null;
         switch(type)
         {
            case 1:
               obj = new SimpleBox(id,model);
               break;
            case 2:
               obj = new SimpleObject(id,1,model,action);
               break;
            case 3:
               obj = new TransmissionGate(id,type,"asset.game.transmitted",action);
               this.hideAllOther();
               break;
            default:
               obj = new SimpleObject(id,0,model,action,layer == 6);
         }
         obj.x = px;
         obj.y = py;
         obj.scaleX = pscaleX;
         obj.scaleY = pscaleY;
         obj.rotation = protation;
         for(Key in labelMapping)
         {
            obj.setActionMapping(Key,labelMapping[Key]);
         }
         if(type == 1)
         {
            this.addBox(obj);
         }
         this.addEffect(obj,containerID,layer);
      }
      
      private function addBox(obj:SimpleObject) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(!this._boxArr)
            {
               this._boxArr = new Array();
            }
            this._boxArr.push(obj);
         }
         else
         {
            this.addEffect(obj);
         }
      }
      
      private function addEffect(obj:SimpleObject, containerID:int = 0, layer:int = 0) : void
      {
         switch(containerID)
         {
            case -1:
               this.addStageCurtain(obj);
               break;
            case 0:
               _map.addPhysical(obj);
               this._objectDic[obj.Id] = obj;
               if(layer > 0 && layer != 6)
               {
                  _map.phyBringToFront(obj);
               }
               break;
            default:
               _map.addObject(obj);
               this.getGameLivingByID(containerID - 1).addChild(obj);
         }
      }
      
      public function updatePhysicObject(evt:CrazyTankSocketEvent) : void
      {
         var id:int = evt.pkg.readInt();
         var obj:SimpleObject = _map.getPhysical(id) as SimpleObject;
         if(!obj)
         {
            obj = this._tipItems[id] as SimpleObject;
         }
         var action:String = evt.pkg.readUTF();
         if(Boolean(obj))
         {
            obj.playAction(action);
         }
         var evtObj:PhyobjEvent = new PhyobjEvent(action);
         dispatchEvent(evtObj);
      }
      
      private function __applySkill(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var skill:int = pkg.readInt();
         var src:int = pkg.readInt();
         SkillManager.applySkillToLiving(skill,src,pkg);
      }
      
      private function __removeSkill(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var skill:int = pkg.readInt();
         var src:int = pkg.readInt();
         SkillManager.removeSkillFromLiving(skill,src,pkg);
      }
      
      private function __removePhysicObject(event:CrazyTankSocketEvent) : void
      {
         var simpleObj:SimpleObject = null;
         var objID:int = event.pkg.readInt();
         var obj:PhysicalObj = this.getGameLivingByID(objID);
         if(obj is GameSimpleBoss)
         {
            LogManager.getInstance().sendLog(GameSimpleBoss(obj).simpleBoss.actionMovieName);
         }
         if(Boolean(obj) && Boolean(obj.parent))
         {
            _map.removePhysical(obj);
         }
         if(Boolean(obj) && Boolean(obj.parent))
         {
            obj.parent.removeChild(obj);
         }
         if(Boolean(obj))
         {
            if(!(obj is GameLiving) || GameLiving(obj).isExist)
            {
               obj.dispose();
            }
         }
         if(Boolean(this._objectDic[objID]))
         {
            simpleObj = this._objectDic[objID];
            delete this._objectDic[objID];
            simpleObj.dispose();
            simpleObj = null;
         }
      }
      
      private function __focusOnObject(event:CrazyTankSocketEvent) : void
      {
         var type:int = event.pkg.readInt();
         var list:Array = [];
         var obj:Object = new Object();
         obj.x = event.pkg.readInt();
         obj.y = event.pkg.readInt();
         list.push(obj);
         _map.act(new ViewEachObjectAction(_map,list,type));
      }
      
      private function __barrierInfoHandler(evt:CrazyTankSocketEvent) : void
      {
         barrierInfo = evt;
      }
      
      private function __livingMoveto(event:CrazyTankSocketEvent) : void
      {
         var from:Point = null;
         var pt:Point = null;
         var speed:int = 0;
         var actionType:String = null;
         var endAction:String = null;
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(living))
         {
            from = new Point(event.pkg.readInt(),event.pkg.readInt());
            pt = new Point(event.pkg.readInt(),event.pkg.readInt());
            speed = event.pkg.readInt();
            actionType = event.pkg.readUTF();
            endAction = event.pkg.readUTF();
            living.pos = from;
            living.moveTo(0,pt,0,true,actionType,speed,endAction);
            _map.bringToFront(living);
         }
      }
      
      public function livingFalling(event:CrazyTankSocketEvent) : void
      {
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         var pt:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
         var speed:int = event.pkg.readInt();
         var actionType:String = event.pkg.readUTF();
         var fallType:int = event.pkg.readInt();
         if(Boolean(living))
         {
            living.fallTo(pt,speed,actionType,fallType);
            if(pt.y - living.pos.y > 50)
            {
               _map.setCenter(pt.x,pt.y - 150,false);
            }
            _map.bringToFront(living);
         }
      }
      
      private function __livingJump(event:CrazyTankSocketEvent) : void
      {
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         var pt:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
         var speed:int = event.pkg.readInt();
         var actionType:String = event.pkg.readUTF();
         var jumpType:int = event.pkg.readInt();
         living.jumpTo(pt,speed,actionType,jumpType);
         _map.bringToFront(living);
      }
      
      private function __livingBeat(event:CrazyTankSocketEvent) : void
      {
         var target:Living = null;
         var damage:int = 0;
         var targetBlood:int = 0;
         var dander:int = 0;
         var attackEffect:int = 0;
         var obj:Object = null;
         var pkg:PackageIn = event.pkg;
         var attacker:Living = _gameInfo.findLiving(pkg.extend1);
         var action:String = pkg.readUTF();
         var length:uint = uint(pkg.readInt());
         var arg:Array = new Array();
         for(var i:uint = 0; i < length; i++)
         {
            target = _gameInfo.findLiving(pkg.readInt());
            damage = pkg.readInt();
            targetBlood = pkg.readInt();
            dander = pkg.readInt();
            attackEffect = pkg.readInt();
            obj = new Object();
            obj["action"] = action;
            obj["target"] = target;
            obj["damage"] = damage;
            obj["targetBlood"] = targetBlood;
            obj["dander"] = dander;
            obj["attackEffect"] = attackEffect;
            arg.push(obj);
            if(target && target.isPlayer() && target.isLiving)
            {
               (target as Player).dander = dander;
            }
         }
         if(Boolean(attacker))
         {
            attacker.beat(arg);
         }
      }
      
      private function __livingSay(event:CrazyTankSocketEvent) : void
      {
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(!living || !living.isLiving)
         {
            return;
         }
         var msg:String = event.pkg.readUTF();
         var type:int = event.pkg.readInt();
         _map.bringToFront(living);
         living.say(msg,type);
      }
      
      private function __livingRangeAttacking(e:CrazyTankSocketEvent) : void
      {
         var livingID:int = 0;
         var damage:int = 0;
         var blood:int = 0;
         var dander:int = 0;
         var attackEffect:int = 0;
         var living:Living = null;
         var count:int = e.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            livingID = e.pkg.readInt();
            damage = e.pkg.readInt();
            blood = e.pkg.readInt();
            dander = e.pkg.readInt();
            attackEffect = e.pkg.readInt();
            living = _gameInfo.findLiving(livingID);
            if(Boolean(living))
            {
               living.isHidden = false;
               living.isFrozen = false;
               living.updateBlood(blood,attackEffect);
               living.showAttackEffect(1);
               _map.bringToFront(living);
               if(living.isSelf)
               {
                  _map.setCenter(living.pos.x,living.pos.y,false);
               }
               if(living.isPlayer() && living.isLiving)
               {
                  (living as Player).dander = dander;
               }
            }
         }
      }
      
      private function __livingDirChanged(event:CrazyTankSocketEvent) : void
      {
         var dir:int = 0;
         var living:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(living))
         {
            dir = event.pkg.readInt();
            living.direction = dir;
            _map.bringToFront(living);
         }
      }
      
      private function __removePlayer(event:DictionaryEvent) : void
      {
         this._msg = RoomManager.Instance._removeRoomMsg;
         var info:Player = event.data as Player;
         var player:GamePlayer = _players[info];
         if(Boolean(player) && Boolean(info))
         {
            if(_map.currentPlayer == info)
            {
               setCurrentPlayer(null);
            }
            if(info.isSelf)
            {
               if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
               {
                  StateManager.setState(StateType.MATCH_ROOM);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.CHRISTMAS_ROOM)
               {
                  if(ChristmasRoomController.isTimeOver)
                  {
                     ChristmasRoomController.isTimeOver = false;
                     StateManager.setState(StateType.MAIN);
                  }
                  else
                  {
                     ChristmasManager.isToRoom = true;
                     StateManager.setState(StateType.CHRISTMAS_ROOM);
                  }
               }
               else if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_SCORE || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_RANK || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
               {
                  KingDivisionManager.Instance.openFrame = true;
                  StateManager.setState(StateType.MAIN);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.CATCH_BEAST)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
               {
                  CatchInsectMananger.instance.reConnectCatchInectFunc();
               }
               else if(RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM)
               {
                  StateManager.setState(StateType.MAIN);
               }
            }
            _map.removePhysical(player);
            player.dispose();
            delete _players[info];
         }
      }
      
      private function __beginShoot(event:CrazyTankSocketEvent) : void
      {
         var gameplayer:GamePlayer = null;
         if(_map.currentPlayer && _map.currentPlayer.isPlayer() && event.pkg.clientId != _map.currentPlayer.playerInfo.ID && _gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM && _gameInfo.roomType != RoomInfo.STONEEXPLORE_ROOM)
         {
            _map.executeAtOnce();
            _map.setCenter(_map.currentPlayer.pos.x,_map.currentPlayer.pos.y - 150,false);
            gameplayer = _players[_map.currentPlayer];
         }
         if(_gameInfo.roomType != RoomInfo.STONEEXPLORE_ROOM && _gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || _map.currentPlayer && _map.currentPlayer.isPlayer() && event.pkg.clientId == _map.currentPlayer.playerInfo.ID)
         {
            setPropBarClickEnable(false,false);
            PrepareShootAction.hasDoSkillAnimation = false;
         }
      }
      
      protected function __shoot(event:CrazyTankSocketEvent) : void
      {
         var self:LocalPlayer = null;
         var windPower:Number = NaN;
         var windDic:Boolean = false;
         var windPowerNum0:int = 0;
         var windPowerNum1:int = 0;
         var windPowerNum2:int = 0;
         var windNumArr:Array = null;
         var list:Array = null;
         var count:Number = NaN;
         var i:uint = 0;
         var petAttackCount:int = 0;
         var targets:Array = null;
         var k:int = 0;
         var act:int = 0;
         var actionName:String = null;
         var flag:Boolean = false;
         var b:Bomb = null;
         var bid:int = 0;
         var damagePlus:Number = NaN;
         var damageMinus:Number = NaN;
         var bombDamageModifier:Number = NaN;
         var len:int = 0;
         var lastTime:int = 0;
         var bombAction:BombAction = null;
         var j:int = 0;
         var targetId:int = 0;
         var target:Living = null;
         var damage:int = 0;
         var blood:int = 0;
         var dander:int = 0;
         var obj:Object = null;
         var targetPoint:Point = null;
         var beatInfo:Dictionary = null;
         var petBomb:Bomb = null;
         var handPlayerId:int = 0;
         var team1:int = 0;
         var count1:int = 0;
         var m:int = 0;
         var currentlivingID:int = 0;
         var currentScore:int = 0;
         EnergyView.canPower = false;
         var pkg:PackageIn = event.pkg;
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            self = GameManager.Instance.Current.selfGamePlayer;
            windPower = pkg.readInt() / 10;
            windDic = pkg.readBoolean();
            windPowerNum0 = pkg.readByte();
            windPowerNum1 = pkg.readByte();
            windPowerNum2 = pkg.readByte();
            windNumArr = [windDic,windPowerNum0,windPowerNum1,windPowerNum2];
            GameManager.Instance.Current.setWind(windPower,info.isSelf,windNumArr);
            list = new Array();
            count = pkg.readInt();
            for(i = 0; i < count; i++)
            {
               b = new Bomb();
               b.number = pkg.readInt();
               b.shootCount = pkg.readInt();
               b.IsHole = pkg.readBoolean();
               b.Id = pkg.readInt();
               b.X = pkg.readInt();
               b.Y = pkg.readInt();
               b.VX = pkg.readInt();
               b.VY = pkg.readInt();
               bid = pkg.readInt();
               b.Template = BallManager.findBall(bid);
               b.Actions = new Array();
               b.changedPartical = pkg.readUTF();
               damagePlus = pkg.readInt() / 1000;
               damageMinus = pkg.readInt() / 1000;
               bombDamageModifier = damagePlus * damageMinus;
               b.damageMod = bombDamageModifier;
               len = pkg.readInt();
               for(j = 0; j < len; j++)
               {
                  lastTime = pkg.readInt();
                  bombAction = new BombAction(lastTime,pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt());
                  b.Actions.push(bombAction);
                  if((RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM) && info.isPlayer() && bombAction.type == 5)
                  {
                     info.damageNum += bombAction.param2;
                  }
               }
               list.push(b);
            }
            info.shoot(list,event);
            petAttackCount = pkg.readInt();
            targets = [];
            for(k = 0; k < petAttackCount; k++)
            {
               targetId = pkg.readInt();
               target = _gameInfo.findLiving(targetId);
               damage = pkg.readInt();
               blood = pkg.readInt();
               dander = pkg.readInt();
               obj = {
                  "target":target,
                  "hp":blood,
                  "damage":damage,
                  "dander":dander
               };
               targets.push(obj);
            }
            act = pkg.readInt();
            actionName = "attack" + act.toString();
            if(_gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
            {
               act = 0;
            }
            if(act != 0)
            {
               targetPoint = null;
               if(list.length == 3)
               {
                  targetPoint = Bomb(list[1]).target;
               }
               else if(list.length == 1)
               {
                  targetPoint = Bomb(list[0]).target;
               }
               beatInfo = Player(info).currentPet.petBeatInfo;
               beatInfo["actionName"] = actionName;
               beatInfo["targetPoint"] = targetPoint;
               beatInfo["targets"] = targets;
               petBomb = Bomb(list[list.length == 3 ? 1 : 0]);
               petBomb.Actions.push(new BombAction(0,ActionType.PET,event.pkg.extend1,0,0,0));
            }
            flag = pkg.readBoolean();
            if(_gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
            {
               redScore = pkg.readInt();
               blueScore = pkg.readInt();
               handPlayerId = pkg.readInt();
               team1 = pkg.readInt();
               count1 = pkg.readInt();
               for(m = 0; m < count1; m++)
               {
                  currentlivingID = pkg.readInt();
                  currentScore = pkg.readInt();
                  if(self.playerInfo.ID == handPlayerId)
                  {
                     PlayerManager.Instance.Self.scoreArr.push(currentScore);
                  }
               }
            }
         }
      }
      
      private function __suicide(event:CrazyTankSocketEvent) : void
      {
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            info.die();
         }
      }
      
      private function __changeBall(event:CrazyTankSocketEvent) : void
      {
         var player:Player = null;
         var isSpecialSkill:Boolean = false;
         var currentBomb:int = 0;
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info) && info is Player)
         {
            player = info as Player;
            isSpecialSkill = event.pkg.readBoolean();
            currentBomb = event.pkg.readInt();
            _map.act(new ChangeBallAction(player,isSpecialSkill,currentBomb));
         }
      }
      
      private function __playerUsingItem(event:CrazyTankSocketEvent) : void
      {
         var dis:DisplayObject = null;
         var propAnimationName:String = null;
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readByte();
         var place:int = pkg.readInt();
         var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(pkg.readInt());
         if(this.props.indexOf(item.TemplateID) != -1)
         {
            EnergyView.canPower = true;
         }
         var from:Living = _gameInfo.findLiving(pkg.extend1);
         var to:Living = _gameInfo.findLiving(pkg.readInt());
         var autoMessage:Boolean = pkg.readBoolean();
         if(Boolean(from) && Boolean(item))
         {
            if(from.isPlayer())
            {
               if(item.CategoryID == EquipType.Freeze)
               {
                  Player(from).skill == -1;
               }
               if(!(from as Player).isSelf)
               {
                  if(item.CategoryID == EquipType.OFFHAND || item.CategoryID == EquipType.TEMP_OFFHAND)
                  {
                     dis = (from as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
                     dis.x += 7;
                     (from as Player).useItemByIcon(dis);
                  }
                  else
                  {
                     (from as Player).useItem(item);
                     propAnimationName = EquipType.hasPropAnimation(item);
                     if(propAnimationName != null && to && to.LivingID != from.LivingID)
                     {
                        to.showEffect(propAnimationName);
                     }
                  }
               }
            }
            if(_map.currentPlayer && to.team == _map.currentPlayer.team && (RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM || (from as Player).isSelf))
            {
               _map.currentPlayer.addState(item.TemplateID);
            }
            if(!to.isLiving)
            {
               if(to.isPlayer())
               {
                  (to as Player).addState(item.TemplateID);
               }
            }
            if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM && RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM)
            {
               if(!from.isLiving && to && from.team == to.team)
               {
                  MessageTipManager.getInstance().show(from.LivingID + "|" + item.TemplateID,1);
               }
               if(autoMessage)
               {
                  MessageTipManager.getInstance().show(String(to.LivingID),3);
               }
            }
         }
      }
      
      private function __updateBuff(evt:CrazyTankSocketEvent) : void
      {
         var buff:FightBuffInfo = null;
         var pkg:PackageIn = evt.pkg;
         var livingid:int = pkg.extend1;
         var buffid:int = pkg.readInt();
         var enable:Boolean = pkg.readBoolean();
         var living:Living = _gameInfo.findLiving(livingid);
         if(living is LocalPlayer)
         {
            if(enable)
            {
               (living as LocalPlayer).usePassBall = true;
            }
            else
            {
               (living as LocalPlayer).usePassBall = false;
            }
         }
         if(Boolean(living) && buffid != -1)
         {
            if(enable)
            {
               buff = BuffManager.creatBuff(buffid);
               living.addBuff(buff);
            }
            else
            {
               living.removeBuff(buffid);
            }
         }
      }
      
      private function __updatePetBuff(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var livingid:int = pkg.extend1;
         var buffid:int = pkg.readInt();
         var buffName:String = pkg.readUTF();
         var description:String = pkg.readUTF();
         var buffPic:String = pkg.readUTF();
         var buffEffect:String = pkg.readUTF();
         var enable:Boolean = pkg.readBoolean();
         var living:Living = _gameInfo.findLiving(livingid);
         var buff:FightBuffInfo = new FightBuffInfo(buffid);
         buff.buffPic = buffPic;
         buff.buffEffect = buffEffect;
         buff.type = BuffType.PET_BUFF;
         var buffItem:Object = BuffManager.getBuffById(buffid);
         if(Boolean(buffItem))
         {
            buff.buffName = buffItem.Name;
            buff.description = buffItem.Description;
         }
         else
         {
            buff.buffName = buffName;
            buff.description = description;
         }
         if(Boolean(living))
         {
            if(enable)
            {
               living.addPetBuff(buff);
            }
            else
            {
               living.removePetBuff(buff);
            }
         }
      }
      
      private function __startMove(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var info:Player = _gameInfo.findPlayer(event.pkg.extend1);
         var flag:Boolean = pkg.readBoolean();
         if(flag)
         {
            if(!info.playerInfo.isSelf || BombKingManager.instance.Recording)
            {
               this.playerMove(pkg,info);
            }
         }
         else
         {
            this.playerMove(pkg,info);
         }
      }
      
      private function playerMove(pkg:PackageIn, info:Player) : void
      {
         var pickBoxActs:Array = null;
         var len:int = 0;
         var j:int = 0;
         var act:PickBoxAction = null;
         var type:int = pkg.readByte();
         var target:Point = new Point(pkg.readInt(),pkg.readInt());
         var dir:int = pkg.readByte();
         var isLiving:Boolean = pkg.readBoolean();
         if(type == 2)
         {
            pickBoxActs = [];
            len = pkg.readInt();
            for(j = 0; j < len; j++)
            {
               act = new PickBoxAction(pkg.readInt(),pkg.readInt());
               pickBoxActs.push(act);
            }
            if(Boolean(info))
            {
               info.playerMoveTo(type,target,dir,isLiving,pickBoxActs);
            }
         }
         else if(Boolean(info))
         {
            info.playerMoveTo(type,target,dir,isLiving);
         }
      }
      
      private function __onLivingBoltmove(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            info.pos = new Point(pkg.readInt(),pkg.readInt());
         }
      }
      
      private function __changWind(event:CrazyTankSocketEvent) : void
      {
         var _pkg:PackageIn = event.pkg;
         _map.wind = _pkg.readInt() / 10;
         var windDic:Boolean = _pkg.readBoolean();
         var windPowerNum0:int = _pkg.readByte();
         var windPowerNum1:int = _pkg.readByte();
         var windPowerNum2:int = _pkg.readByte();
         var windNumArr:Array = new Array();
         windNumArr = [windDic,windPowerNum0,windPowerNum1,windPowerNum2];
         _vane.update(_map.wind,false,windNumArr);
      }
      
      private function __playerNoNole(evt:CrazyTankSocketEvent) : void
      {
         var info:Living = _gameInfo.findLiving(evt.pkg.extend1);
         if(Boolean(info))
         {
            info.isNoNole = evt.pkg.readBoolean();
         }
      }
      
      private function __onChangePlayerTarget(evt:CrazyTankSocketEvent) : void
      {
         var id:int = evt.pkg.readInt();
         if(id == 0)
         {
            if(Boolean(_playerThumbnailLController))
            {
               _playerThumbnailLController.currentBoss = null;
            }
            return;
         }
         var info:Living = _gameInfo.findLiving(id);
         this._gameLivingIdArr.push(id);
         _playerThumbnailLController.currentBoss = info;
      }
      
      public function objectSetProperty(evt:CrazyTankSocketEvent) : void
      {
         var obj:GameLiving = this.getGameLivingByID(evt.pkg.extend1) as GameLiving;
         if(!obj)
         {
            return;
         }
         var property:String = evt.pkg.readUTF();
         var value:String = evt.pkg.readUTF();
         setProperty(obj,property,value);
      }
      
      private function __usePetSkill(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var livingID:int = pkg.extend1;
         var skillID:int = pkg.readInt();
         var isUse:Boolean = pkg.readBoolean();
         var info:Player = _gameInfo.findPlayer(livingID);
         var skillFrom:int = pkg.readInt();
         if(skillFrom == 2)
         {
            info.useHorseSkill(skillID,isUse,pkg.readInt());
         }
         else
         {
            if(info && info.currentPet && isUse)
            {
               info.usePetSkill(skillID,isUse);
               if(PetSkillManager.getSkillByID(skillID).BallType == PetSkillTemplateInfo.BALL_TYPE_2)
               {
                  info.isAttacking = false;
                  GameManager.Instance.Current.selfGamePlayer.beginShoot();
               }
            }
            if(!isUse)
            {
               GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.PETSKILL_USED_FAIL));
            }
         }
      }
      
      private function __petBeat(event:CrazyTankSocketEvent) : void
      {
         var targetid:int = 0;
         var target:Living = null;
         var dam:int = 0;
         var targetHp:int = 0;
         var dander:int = 0;
         var obj:Object = null;
         var pkg:PackageIn = event.pkg;
         var playerid:int = pkg.extend1;
         var p:Player = _gameInfo.findPlayer(playerid);
         var targetLen:int = pkg.readInt();
         var targets:Array = [];
         for(var i:int = 0; i < targetLen; i++)
         {
            targetid = pkg.readInt();
            target = _gameInfo.findLiving(targetid);
            dam = pkg.readInt();
            targetHp = pkg.readInt();
            dander = pkg.readInt();
            obj = {
               "target":target,
               "hp":targetHp,
               "damage":dam,
               "dander":dander
            };
            targets.push(obj);
         }
         var act:int = pkg.readInt();
         var actionName:String = "attack" + act.toString();
         var pt:Point = new Point(pkg.readInt(),pkg.readInt());
         p.petBeat(actionName,pt,targets);
      }
      
      private function __playerHide(event:CrazyTankSocketEvent) : void
      {
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            info.isHidden = event.pkg.readBoolean();
         }
      }
      
      private function __gameOver(event:CrazyTankSocketEvent) : void
      {
         GameManager.Instance.currentNum = 0;
         this.gameOver();
         _map.act(new GameOverAction(_map,event,this.showExpView));
      }
      
      public function logTimeHandler(event:TimerEvent = null) : void
      {
         _map.traceCurrentAction();
      }
      
      private function __missionOver(event:CrazyTankSocketEvent) : void
      {
         var key:String = null;
         this.gameOver();
         this._missionAgain = new MissionAgainInfo();
         this._missionAgain.value = _gameInfo.missionInfo.tryagain;
         var roomPlayers:DictionaryData = RoomManager.Instance.current.players;
         for(key in roomPlayers)
         {
            if(RoomPlayer(roomPlayers[key]).isHost)
            {
               this._missionAgain.host = RoomPlayer(roomPlayers[key]).playerInfo.NickName;
            }
            if(RoomPlayer(roomPlayers[key]).isSelf)
            {
               if(!GameManager.Instance.Current.selfGamePlayer.petSkillEnabled)
               {
                  GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
               }
            }
         }
         _map.act(new MissionOverAction(_map,event,this.showExpView));
         if(GameManager.GAME_CAN_NOT_EXIT_SEND_LOG == 1 && (_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM || _gameInfo.roomType == RoomInfo.STONEEXPLORE_ROOM))
         {
            if(!this._logTimer)
            {
               this._logTimer = new Timer(15000,10);
               this._logTimer.addEventListener(TimerEvent.TIMER,this.logTimeHandler,false,0,true);
            }
            this._logTimer.start();
         }
      }
      
      override protected function gameOver() : void
      {
         PageInterfaceManager.restorePageTitle();
         super.gameOver();
         KeyboardManager.getInstance().isStopDispatching = true;
      }
      
      private function showTryAgain() : void
      {
         var tryagain:TryAgain = new TryAgain(this._missionAgain);
         tryagain.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         tryagain.addEventListener(GameEvent.GIVEUP,this.__giveup);
         tryagain.addEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         tryagain.show();
         addChild(tryagain);
      }
      
      private function __tryAgainTimeOut(event:GameEvent) : void
      {
         event.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         event.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         event.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(event.currentTarget);
         if(Boolean(this._expView))
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function showExpView() : void
      {
         var time:int = 0;
         var urlVar:URLVariables = null;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         var roomtype:int = GameManager.Instance.Current.roomType;
         if(Boolean(ChatManager.Instance.input.parent))
         {
            ChatManager.Instance.switchVisible();
         }
         disposeUI();
         MenoryUtil.clearMenory();
         if(GameManager.Instance.Current.roomType == 14)
         {
            StateManager.setState(StateType.WORLDBOSS_ROOM);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            StateManager.setState(StateType.MAIN);
            TransnationalFightManager.Instance.isfromTransnational = true;
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_BOSS)
         {
            StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_BATTLE)
         {
            StateManager.setState(StateType.CONSORTIA_BATTLE_SCENE);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            StateManager.setState(StateType.MATCH_ROOM);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_SCORE || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_RANK || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE || GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
         {
            KingDivisionManager.Instance.openFrame = true;
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CHRISTMAS_ROOM)
         {
            if(ChristmasRoomController.isTimeOver)
            {
               ChristmasRoomController.isTimeOver = false;
               StateManager.setState(StateType.MAIN);
               return;
            }
            ChristmasManager.isToRoom = true;
            StateManager.setState(StateType.CHRISTMAS_ROOM);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.STONEEXPLORE_ROOM)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.SEVEN_DOUBLE)
         {
            if(SevenDoubleManager.instance.isStart)
            {
               StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
            }
            else if(EscortManager.instance.isStart)
            {
               StateManager.setState(StateType.ESCORT);
            }
            else if(DrgnBoatManager.instance.isStart)
            {
               StateManager.setState(StateType.DRGN_BOAT);
            }
            else
            {
               StateManager.setState(StateType.MAIN);
            }
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CATCH_BEAST)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.FARM_BOSS)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.BOMB_KING)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.RING_STATION)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CATCH_INSECT_ROOM)
         {
            CatchInsectMananger.instance.reConnectCatchInectFunc();
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CAMPBATTLE_BATTLE)
         {
            SocketManager.Instance.out.returnToPve();
            return;
         }
         if(!this._firstEnter)
         {
            this._expView = new ExpView(_map.mapBitmap);
            this._expView.addEventListener(GameEvent.EXPSHOWED,this.__expShowed);
            addChild(this._expView);
            this._expView.show();
         }
         else
         {
            if(ApplicationDomain.currentDomain.hasDefinition("RegisterLuncher"))
            {
               if(getDefinitionByName("RegisterLuncher").newBieTime != -1)
               {
                  time = getTimer() - getDefinitionByName("RegisterLuncher").newBieTime;
                  urlVar = new URLVariables();
                  urlVar.id = PlayerManager.Instance.Self.ID;
                  urlVar.type = 3;
                  urlVar.time = time;
                  urlVar.grade = PlayerManager.Instance.Self.Grade;
                  urlVar.serverID = PlayerManager.Instance.Self.ZoneID;
                  url = new URLRequest(PathManager.solveRequestPath("LogTime.ashx"));
                  url.method = URLRequestMethod.POST;
                  url.data = urlVar;
                  loader = new URLLoader();
                  loader.load(url);
               }
            }
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function __expShowed(event:GameEvent) : void
      {
         var living:Living = null;
         var viewer:Living = null;
         this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         for each(living in _gameInfo.livings.list)
         {
            if(living.isSelf)
            {
               if(Player(living).isWin && Boolean(this._missionAgain))
               {
                  this._missionAgain.win = true;
               }
               if(Player(living).hasLevelAgain && Boolean(this._missionAgain))
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         for each(viewer in _gameInfo.viewers.list)
         {
            if(viewer.isSelf)
            {
               if(Player(viewer).isWin && Boolean(this._missionAgain))
               {
                  this._missionAgain.win = true;
               }
               if(Player(viewer).hasLevelAgain && Boolean(this._missionAgain))
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         if((GameManager.isDungeonRoom(_gameInfo) || GameManager.isAcademyRoom(_gameInfo)) && _gameInfo.missionInfo.tryagain > 0)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer && !this._missionAgain.win)
            {
               this.showTryAgain();
               if(Boolean(this._expView))
               {
                  this._expView.visible = false;
               }
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._missionAgain.win)
            {
               if(Boolean(this._expView))
               {
                  this._expView.close();
               }
               this._expView = null;
            }
            else if(!_gameInfo.selfGamePlayer.isWin)
            {
               if(GameManager.isLanbyrinthRoom(_gameInfo))
               {
                  GameInSocketOut.sendGamePlayerExit();
                  if(Boolean(this._expView))
                  {
                     this._expView.visible = false;
                  }
                  this._expView = null;
               }
               else
               {
                  this.showTryAgain();
                  if(Boolean(this._expView))
                  {
                     this._expView.visible = false;
                  }
               }
            }
            else
            {
               this._expView.showCard();
               this._expView = null;
            }
         }
         else if(GameManager.isFightLib(_gameInfo))
         {
            this._expView.close();
            this._expView = null;
         }
         else if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._expView.close();
            this._expView = null;
         }
         else
         {
            this._expView.showCard();
            this._expView = null;
         }
      }
      
      private function __giveup(event:GameEvent) : void
      {
         event.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         event.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         event.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(event.currentTarget);
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(GameManager.MissionGiveup,true);
         }
         if(Boolean(this._expView))
         {
            this._expView.close();
            this._expView = null;
         }
      }
      
      private function __tryAgain(event:GameEvent) : void
      {
         event.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         event.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         event.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(event.currentTarget);
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer || GameManager.Instance.TryAgain == GameManager.MissionAgain)
         {
            GameManager.Instance.Current.hasNextMission = true;
         }
         if(RoomManager.Instance.current.type != RoomInfo.LANBYRINTH_ROOM)
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function __dander(event:CrazyTankSocketEvent) : void
      {
         var d:int = 0;
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info) && info is Player)
         {
            d = event.pkg.readInt();
            (info as Player).dander = d;
         }
      }
      
      private function __reduceDander(event:CrazyTankSocketEvent) : void
      {
         var d:int = 0;
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info) && info is Player)
         {
            d = event.pkg.readInt();
            (info as Player).reduceDander(d);
         }
      }
      
      private function __changeState(evt:CrazyTankSocketEvent) : void
      {
         var info:Living = _gameInfo.findLiving(evt.pkg.extend1);
         if(Boolean(info))
         {
            info.State = evt.pkg.readInt();
            _map.setCenter(info.pos.x,info.pos.y,true);
         }
      }
      
      private function __selfObtainItem(event:BagEvent) : void
      {
         var info:InventoryItemInfo = null;
         var item:PropInfo = null;
         var mc:MovieClipWrapper = null;
         var propback:AutoDisappear = null;
         var prop:AutoDisappear = null;
         var propcite:AutoDisappear = null;
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM || _gameInfo.roomType == RoomInfo.CATCH_INSECT_ROOM || _gameInfo.roomType == RoomInfo.TREASURELOST_ROOM || _gameInfo.roomType == RoomInfo.STONEEXPLORE_ROOM)
         {
            return;
         }
         for each(info in event.changedSlots)
         {
            item = new PropInfo(info);
            item.Place = info.Place;
            if(Boolean(PlayerManager.Instance.Self.FightBag.getItemAt(info.Place)))
            {
               if(_gameInfo.gameMode != RoomInfo.ENTERTAINMENT_ROOM && _gameInfo.gameMode != RoomInfo.ENTERTAINMENT_ROOM_PK)
               {
                  propback = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropBgAsset"),3);
                  propback.x = _vane.x - propback.width / 2 + 48;
                  propback.y = _selfMarkBar.y + _selfMarkBar.height + 70;
                  LayerManager.Instance.addToLayer(propback,LayerManager.GAME_DYNAMIC_LAYER,false);
                  prop = new AutoDisappear(PropItemView.createView(item.Template.Pic,62,62),3);
                  prop.x = _vane.x - prop.width / 2 + 47;
                  prop.y = _selfMarkBar.y + _selfMarkBar.height + 70;
                  LayerManager.Instance.addToLayer(prop,LayerManager.GAME_DYNAMIC_LAYER,false);
                  propcite = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropCiteAsset"),3);
                  propcite.x = _vane.x - propcite.width / 2 + 45;
                  propcite.y = _selfMarkBar.y + _selfMarkBar.height + 70;
                  LayerManager.Instance.addToLayer(propcite,LayerManager.GAME_DYNAMIC_LAYER,false);
               }
               mc = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.zxcTip"),true,true);
               mc.movie.x += mc.movie.width * info.Place - this.ZXC_OFFSET * info.Place;
               LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_UI_LAYER,false);
            }
         }
      }
      
      private function __getTempItem(evt:BagEvent) : void
      {
         var playSound:Boolean = GameManager.Instance.selfGetItemShowAndSound(evt.changedSlots);
         if(playSound && this._soundPlayFlag)
         {
            this._soundPlayFlag = false;
            SoundManager.instance.play("1001");
         }
      }
      
      private function __forstPlayer(event:CrazyTankSocketEvent) : void
      {
         var info:Living = _gameInfo.findLiving(event.pkg.extend1);
         if(Boolean(info))
         {
            info.isFrozen = event.pkg.readBoolean();
         }
      }
      
      private function __changeShootCount(event:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType != RoomInfo.STONEEXPLORE_ROOM || _gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || event.pkg.extend1 == _gameInfo.selfGamePlayer.LivingID)
         {
            _gameInfo.selfGamePlayer.shootCount = event.pkg.readByte();
         }
      }
      
      private function __playSound(event:CrazyTankSocketEvent) : void
      {
         var soundID:String = event.pkg.readUTF();
         SoundManager.instance.initSound(soundID);
         SoundManager.instance.play(soundID);
      }
      
      private function __controlBGM(evt:CrazyTankSocketEvent) : void
      {
         if(evt.pkg.readBoolean())
         {
            SoundManager.instance.resumeMusic();
         }
         else
         {
            SoundManager.instance.pauseMusic();
         }
      }
      
      private function __forbidDragFocus(evt:CrazyTankSocketEvent) : void
      {
         var _allowDrag:Boolean = evt.pkg.readBoolean();
         _map.smallMap.allowDrag = _allowDrag;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = _allowDrag;
      }
      
      override protected function defaultForbidDragFocus() : void
      {
         _map.smallMap.allowDrag = true;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = true;
      }
      
      private function __topLayer(evt:CrazyTankSocketEvent) : void
      {
         var living:Living = _gameInfo.findLiving(evt.pkg.readInt());
         if(Boolean(living))
         {
            _map.bringToFront(living);
         }
      }
      
      private function __loadResource(event:CrazyTankSocketEvent) : void
      {
         var needMovie:GameNeedMovieInfo = null;
         var count:int = event.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            needMovie = new GameNeedMovieInfo();
            needMovie.type = event.pkg.readInt();
            needMovie.path = event.pkg.readUTF();
            needMovie.classPath = event.pkg.readUTF();
            needMovie.startLoad();
         }
      }
      
      public function livingShowBlood(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         var value:Boolean = Boolean(event.pkg.readInt());
         if(Boolean(_map))
         {
            if(Boolean(_map.getPhysical(id)))
            {
               (_map.getPhysical(id) as GameLiving).showBlood(value);
            }
         }
      }
      
      public function livingActionMapping(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         var source:String = event.pkg.readUTF();
         var target:String = event.pkg.readUTF();
         if(Boolean(_map.getPhysical(id)))
         {
            _map.getPhysical(id).setActionMapping(source,target);
         }
      }
      
      private function __livingSmallColorChange(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         var colorIndex:int = event.pkg.readByte();
         if(Boolean(_map.getPhysical(id)) && _map.getPhysical(id) is GameLiving)
         {
            (_map.getPhysical(id) as GameLiving).changeSmallViewColor(colorIndex);
         }
      }
      
      private function __revivePlayer(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var blood:Number = pkg.readLong();
         var posX:int = pkg.readInt();
         var posY:int = pkg.readInt();
         var tmp:GamePlayer = this.retrunPlayer(id);
         if(Boolean(tmp) && !tmp.info.isLiving)
         {
            tmp.info.revive();
            tmp.pos = new Point(posX,posY);
            tmp.info.updateBlood(blood,0,blood);
            tmp.revive();
            tmp.info.dispatchEvent(new LivingEvent(LivingEvent.REVIVE));
            if(tmp is GameLocalPlayer)
            {
               _fightControlBar.setState(FightControlBar.LIVE);
               _selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar",[this,_arrowDown]);
               if(GameManager.Instance.Current.mapIndex != 1405 && RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM)
               {
                  addChildAt(_selfBuffBar,this.numChildren - 1);
               }
               kingBlessIconInit();
            }
         }
      }
      
      public function revivePlayerChangePlayer(id:int) : void
      {
         var tmp:GamePlayer = this.retrunPlayer(id);
         if(Boolean(tmp) && !tmp.info.isLiving)
         {
            tmp.info.revive();
            tmp.revive();
            tmp.info.dispatchEvent(new LivingEvent(LivingEvent.REVIVE));
            if(tmp is GameLocalPlayer)
            {
               _fightControlBar.setState(FightControlBar.LIVE);
               _selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar",[this,_arrowDown]);
               if(RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM && GameManager.Instance.Current.mapIndex != 1405)
               {
                  addChildAt(_selfBuffBar,this.numChildren - 1);
               }
               kingBlessIconInit();
            }
         }
      }
      
      private function __gameTrusteeship(event:CrazyTankSocketEvent) : void
      {
         var livingID:int = 0;
         var player:Player = null;
         var len:int = event.pkg.readInt();
         if(len == 0)
         {
            return;
         }
         for(var i:int = 0; i <= len - 1; i++)
         {
            livingID = event.pkg.readInt();
            player = _gameInfo.findPlayer(livingID);
            player.playerInfo.isTrusteeship = event.pkg.readBoolean();
         }
      }
      
      private function __fightStatusChange(event:CrazyTankSocketEvent) : void
      {
         var livingID:int = event.pkg.extend1;
         var player:Player = _gameInfo.findPlayer(livingID);
         if(Boolean(player))
         {
            player.playerInfo.fightStatus = event.pkg.readInt();
         }
      }
      
      private function __skipNextHandler(event:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM || _gameInfo.roomType == RoomInfo.STONEEXPLORE_ROOM)
         {
            if(ServerConfigManager.instance.isTanabataTreasure)
            {
               setTimeout(this.delayFocusSimpleBoss,250);
            }
         }
      }
      
      private function __onDropItemComplete(pEvent:CrazyTankSocketEvent) : void
      {
         var length:int = 0;
         var i:int = 0;
         var itemId:int = 0;
         var count:int = 0;
         var disOb:DisplayObject = null;
         var goodInfo:ItemTemplateInfo = null;
         var cell:BaseCell = null;
         var p1:Point = null;
         var p2:Point = null;
         var dropGoods:DropGoods = null;
         var pkg:PackageIn = pEvent.pkg;
         if(pkg.bytesAvailable < 1)
         {
            return;
         }
         var bx:int = pkg.readInt();
         var by:int = pkg.readInt();
         var typeNum:int = pkg.readInt();
         for(var j:int = 0; j < typeNum; j++)
         {
            length = pkg.readInt();
            for(i = 0; i < length; i++)
            {
               itemId = pkg.readInt();
               count = pkg.readInt();
               itemId = EquipType.filterEquiqItemId(itemId);
               goodInfo = ItemManager.Instance.getTemplateById(itemId);
               cell = new BaseCell(new Sprite(),goodInfo,false,false);
               cell.setContentSize(40,40);
               disOb = cell;
               p1 = new Point(bx,by);
               if(Boolean(_selfGamePlayer))
               {
                  p2 = new Point(_selfGamePlayer.x,_selfGamePlayer.y - 30);
               }
               GameManager.Instance.setDropData(itemId,count);
               dropGoods = new DropGoods(this.map,disOb,p1,p2,count);
               GameManager.Instance.dropGoodslist.push(dropGoods);
            }
         }
      }
      
      private function __clearDebuff(event:CrazyTankSocketEvent) : void
      {
         var tmpLivingID:int = event.pkg.readInt();
         var tmpPlayer:GamePlayer = this.retrunPlayer(tmpLivingID);
         if(Boolean(tmpPlayer))
         {
            tmpPlayer.clearDebuff();
         }
      }
      
      private function delayFocusSimpleBoss() : void
      {
         if(!_map)
         {
            return;
         }
         var tmps:GameSimpleBoss = _map.getOneSimpleBoss;
         if(Boolean(tmps))
         {
            tmps.needFocus(0,0,{"priority":3});
         }
      }
      
      private function getGameLivingByID(id:int) : PhysicalObj
      {
         if(!_map)
         {
            return null;
         }
         return _map.getPhysical(id);
      }
      
      private function addStageCurtain(obj:SimpleObject) : void
      {
         obj.movie.addEventListener("playEnd",function():void
         {
            obj.movie.stop();
            if(Boolean(obj.parent))
            {
               obj.parent.removeChild(obj);
            }
            obj.dispose();
            obj = null;
         });
         addChild(obj);
      }
   }
}

