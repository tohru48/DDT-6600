package game.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import bombKing.BombKingManager;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayPool;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BitmapManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.states.BaseStateView;
   import ddt.utils.MenoryUtil;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ICharacter;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatBugleView;
   import ddt.view.chat.chatBall.ChatBallBoss;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.ViewEachPlayerAction;
   import game.animations.DirectionMovingAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.view.buff.SelfBuffBar;
   import game.view.control.ControlState;
   import game.view.control.FightControlBar;
   import game.view.control.LiveState;
   import game.view.map.MapView;
   import game.view.playerThumbnail.PlayerThumbnailController;
   import game.view.propContainer.PlayerStateContainer;
   import kingBless.KingBlessManager;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import phy.math.EulerVector;
   import rescue.components.RescueRoomItemView;
   import rescue.components.RescueScoreAlertView;
   import rescue.data.RescueRoomInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.data.StringObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import worldboss.WorldBossManager;
   
   public class GameViewBase extends BaseStateView
   {
      
      protected var _arrowLeft:SpringArrowView;
      
      protected var _arrowRight:SpringArrowView;
      
      protected var _arrowUp:SpringArrowView;
      
      protected var _arrowDown:SpringArrowView;
      
      protected var _selfUsedProp:PlayerStateContainer;
      
      protected var _leftPlayerView:LeftPlayerCartoonView;
      
      protected var _missionHelp:DungeonHelpView;
      
      protected var _fightControlBar:FightControlBar;
      
      protected var _cs:ControlState;
      
      protected var _vane:VaneView;
      
      protected var _playerThumbnailLController:PlayerThumbnailController;
      
      protected var _map:MapView;
      
      protected var _players:Dictionary;
      
      protected var _gameInfo:GameInfo;
      
      protected var _selfGamePlayer:GameLocalPlayer;
      
      protected var _selfBuffBar:SelfBuffBar;
      
      protected var _selfMarkBar:SelfMarkBar;
      
      protected var _achievBar:FightAchievBar;
      
      protected var _redScore:int;
      
      protected var _blueScore:int;
      
      private var redScoreMc:FilterFrameText;
      
      private var blueScoreMc:FilterFrameText;
      
      protected var _bitmapMgr:BitmapManager;
      
      protected var _kingblessIcon:Image;
      
      protected var _gameTrusteeshipView:GameTrusteeshipView;
      
      protected var _gameCountDownView:GameCountDownView;
      
      private var _damageView:DamageView;
      
      private var _rescueRoomItemView:RescueRoomItemView;
      
      private var _rescueScoreView:RescueScoreAlertView;
      
      private var _messageBtn:BaseButton;
      
      private var _pirateBall:ChatBallBoss;
      
      public var explorersLiving:Living;
      
      private var _exitRoomTypeArray:Array = [RoomInfo.FRESHMAN_ROOM,RoomInfo.WORLD_BOSS_FIGHT,RoomInfo.CONSORTIA_BATTLE,RoomInfo.CAMPBATTLE_BATTLE,RoomInfo.SEVEN_DOUBLE,RoomInfo.RING_STATION,RoomInfo.CHRISTMAS_ROOM,RoomInfo.CATCH_BEAST,RoomInfo.BOMB_KING,RoomInfo.CHRISTMAS_ROOM,RoomInfo.CATCH_BEAST,RoomInfo.CONSORTIA_MATCH_SCORE,RoomInfo.CONSORTIA_MATCH_RANK,RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE,RoomInfo.CONSORTIA_MATCH_RANK_WHOLE,RoomInfo.CATCH_INSECT_ROOM,RoomInfo.ACTIVITY_DUNGEON_ROOM,RoomInfo.STONEEXPLORE_ROOM];
      
      protected var _barrier:DungeonInfoView;
      
      private const GUIDEID:int = 10029;
      
      protected var _barrierVisible:Boolean = true;
      
      private var _self:LocalPlayer;
      
      private var _level:int;
      
      private var _gameLiving:GameLiving;
      
      private var _selfGameLiving:GamePlayer;
      
      private var _allLivings:DictionaryData;
      
      private var _mass:Number = 10;
      
      private var _gravityFactor:Number = 70;
      
      protected var _windFactor:Number = 240;
      
      private var _powerRef:Number = 1;
      
      private var _reangle:Number = 0;
      
      private var _dt:Number = 0.04;
      
      private var _arf:Number;
      
      private var _gf:Number;
      
      private var _ga:Number;
      
      private var _mapWind:Number = 0;
      
      private var _wa:Number;
      
      private var _ef:Point = new Point(0,0);
      
      private var _shootAngle:Number;
      
      private var _state:Boolean = false;
      
      private var _useAble:Boolean = false;
      
      private var _stateFlag:int;
      
      private var _currentLivID:int;
      
      private var _collideRect:Rectangle = new Rectangle(-45,-30,100,80);
      
      private var _drawRoute:Sprite;
      
      public function GameViewBase()
      {
         super();
      }
      
      private function updateScore() : void
      {
         this.redScoreMc.text = this.redScore + "";
         this.blueScoreMc.text = this.blueScore + "";
      }
      
      public function get blueScore() : int
      {
         return this._blueScore;
      }
      
      public function set blueScore(value:int) : void
      {
         this._blueScore = value;
         this._gameInfo.blueScore = value;
         this.updateScore();
      }
      
      public function get redScore() : int
      {
         return this._redScore;
      }
      
      public function set redScore(value:int) : void
      {
         this._redScore = value;
         this._gameInfo.redScore = value;
         this.updateScore();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function fadingComplete() : void
      {
         super.fadingComplete();
         if(this._barrierVisible)
         {
            this.drawMissionInfo();
         }
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         var player:Living = null;
         var thumbnailPos:Point = null;
         super.enter(prev,data);
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         SharedManager.Instance.propTransparent = false;
         this._gameInfo = GameManager.Instance.Current;
         MainToolBar.Instance.hide();
         LayerManager.Instance.clearnStageDynamic();
         ChatBugleView.instance.hide();
         PlayerManager.Instance.Self.TempBag.clearnAll();
         GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
         for each(player in this._gameInfo.livings)
         {
            if(player is Player)
            {
               Player(player).isUpGrade = false;
               Player(player).LockState = false;
            }
         }
         this._map = this.newMap();
         this._map.gameView = this;
         this._map.x = this._map.y = 0;
         addChild(this._map);
         this._map.smallMap.x = StageReferance.stageWidth - this._map.smallMap.width - 1;
         this._map.smallMap.enableExit = BombKingManager.instance.Recording ? true : this._exitRoomTypeArray.indexOf(this._gameInfo.roomType) == -1;
         addChild(this._map.smallMap);
         this._map.smallMap.hideSpliter();
         this._selfMarkBar = new SelfMarkBar(GameManager.Instance.Current.selfGamePlayer,this);
         this._selfMarkBar.x = 500;
         this._selfMarkBar.y = 79;
         this._fightControlBar = new FightControlBar(this._gameInfo.selfGamePlayer,this);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE,this.__selfDie);
         this._leftPlayerView = new LeftPlayerCartoonView();
         this._vane = new VaneView();
         this._vane.setUpCenter(446,0);
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this.bifenView();
         }
         else
         {
            addChild(this._vane);
         }
         SoundManager.instance.playGameBackMusic(this._map.info.BackMusic);
         this._arrowUp = new SpringArrowView(DirectionMovingAnimation.UP,this._map);
         this._arrowDown = new SpringArrowView(DirectionMovingAnimation.DOWN,this._map);
         this._arrowLeft = new SpringArrowView(DirectionMovingAnimation.RIGHT,this._map);
         this._arrowRight = new SpringArrowView(DirectionMovingAnimation.LEFT,this._map);
         addChild(this._arrowUp);
         addChild(this._arrowDown);
         addChild(this._arrowLeft);
         addChild(this._arrowRight);
         this._selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar",[this,this._arrowDown]);
         if(GameManager.Instance.Current.mapIndex != 1405)
         {
            if(RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM || GameManager.Instance.Current.roomType != FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
            {
               addChildAt(this._selfBuffBar,this.numChildren - 1);
            }
         }
         if(GameManager.Instance.Current.gameMode == 25)
         {
            NoviceDataManager.instance.saveNoviceData(430,PathManager.userName(),PathManager.solveRequestPath());
         }
         this._players = new Dictionary();
         SharedManager.Instance.addEventListener(Event.CHANGE,this.__soundChange);
         this.__soundChange(null);
         var self:LocalPlayer = this._gameInfo.selfGamePlayer;
         if(!BombKingManager.instance.Recording && !RoomManager.Instance.current.selfRoomPlayer.isViewer && self.isLiving)
         {
            this._cs = this._fightControlBar.setState(FightControlBar.LIVE);
         }
         this.setupGameData();
         this._playerThumbnailLController = new PlayerThumbnailController(this._gameInfo);
         thumbnailPos = ComponentFactory.Instance.creatCustomObject("asset.game.ThumbnailLPos");
         this._playerThumbnailLController.x = thumbnailPos.x;
         this._playerThumbnailLController.y = thumbnailPos.y;
         addChildAt(this._playerThumbnailLController,getChildIndex(this._map.smallMap));
         ChatManager.Instance.state = ChatManager.CHAT_GAME_STATE;
         ChatManager.Instance.view.visible = true;
         addChild(ChatManager.Instance.view);
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.loadWeakGuild();
         }
         this.defaultForbidDragFocus();
         this.initEvent();
         this.wishInit();
         this.kingBlessIconInit();
         this.initGameCountDownView();
         this.resetPlayerCharacters();
         if(this.isShowTrusteeship())
         {
            this._gameTrusteeshipView = ComponentFactory.Instance.creatCustomObject("game.view.gameTrusteeshipView");
            addChild(this._gameTrusteeshipView);
         }
         this.initDiePlayer();
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            this._damageView = new DamageView();
            addChild(this._damageView);
            PositionUtils.setPos(this._damageView,"asset.game.damageViewPos");
         }
         else if(RoomManager.Instance.current.type == RoomInfo.RESCUE)
         {
            this._rescueRoomItemView = new RescueRoomItemView();
            addChild(this._rescueRoomItemView);
            PositionUtils.setPos(this._rescueRoomItemView,"rescue.roomInfo.viewPos");
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RESCUE_ITEM_INFO,this.__updateRescueItemInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_SCORE,this.__addRescueScore);
         }
      }
      
      private function bifenView() : void
      {
         var bifenBg:Bitmap = ComponentFactory.Instance.creatBitmap("fightFootballTime.game.scoreBG");
         addChild(bifenBg);
         var bifen:Sprite = new Sprite();
         this.redScoreMc = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.gameview.RedScoreTxt");
         PositionUtils.setPos(this.redScoreMc,"fightFootballTime.gameview.redScorepos");
         this.blueScoreMc = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.gameview.BlueScoreTxt");
         PositionUtils.setPos(this.blueScoreMc,"fightFootballTime.gameview.blueScorepos");
         var bihao:Bitmap = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.bihao");
         PositionUtils.setPos(bihao,"fightFootballTime.gameview.bihaopos");
         this.redScoreMc.text = 0 + "";
         this.blueScoreMc.text = 0 + "";
         bifen.addChild(this.redScoreMc);
         bifen.addChild(this.blueScoreMc);
         bifen.addChild(bihao);
         PositionUtils.setPos(bifen,"fightFootballTime.gameview.bifenpos");
         addChild(bifen);
      }
      
      protected function __addRescueScore(event:CrazyTankSocketEvent) : void
      {
         var npcY:int = 0;
         var value:int = 0;
         var pkg:PackageIn = event.pkg;
         var npcX:int = pkg.readInt();
         npcY = pkg.readInt();
         value = pkg.readInt();
         if(!this._rescueScoreView)
         {
            this._rescueScoreView = new RescueScoreAlertView();
            this._map.addChild(this._rescueScoreView);
         }
         this._rescueScoreView.x = npcX;
         this._rescueScoreView.y = npcY - 50;
         this._rescueScoreView.setData(value);
         this._rescueScoreView.visible = true;
         setTimeout(this.setScoreViewInvisible,1000);
      }
      
      private function setScoreViewInvisible() : void
      {
         this._rescueScoreView.visible = false;
      }
      
      protected function __updateRescueItemInfo(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var info:RescueRoomInfo = new RescueRoomInfo();
         info.sceneId = pkg.readInt();
         info.score = pkg.readInt();
         info.defaultArrow = pkg.readInt();
         info.arrow = pkg.readInt();
         info.bloodBag = pkg.readInt();
         info.kingBless = pkg.readInt();
         if(Boolean(this._rescueRoomItemView))
         {
            this._rescueRoomItemView.update(info);
         }
         if(Boolean(this._barrier))
         {
            this._barrier.setRescueArrow(info.defaultArrow + info.arrow);
         }
         var ls:LiveState = this._cs as LiveState;
         if(Boolean(ls))
         {
            ls.rescuePropBar.setKingBlessCount(info.kingBless);
         }
      }
      
      public function addMessageBtn() : void
      {
         if(!this._messageBtn)
         {
            this._messageBtn = ComponentFactory.Instance.creatComponentByStylename("game.view.activityDungeonView.messageBtn");
            this._messageBtn.addEventListener(MouseEvent.CLICK,this.__onMessageClick);
            this._map.addChild(this._messageBtn);
         }
      }
      
      protected function __onMessageClick(event:MouseEvent) : void
      {
         this._messageBtn.visible = false;
         if(Boolean(this.explorersLiving))
         {
            this.explorersLiving.say(LanguageMgr.GetTranslation("activity.dungeonView.pirateSay" + GameManager.Instance.currentNum));
         }
      }
      
      private function initGameCountDownView() : void
      {
         var totalTime:int = 0;
         var roomType:int = RoomManager.Instance.current.type;
         if(roomType == RoomInfo.CONSORTIA_BATTLE)
         {
            totalTime = 300 - int((TimeManager.Instance.Now().getTime() - GameManager.Instance.Current.startTime.getTime()) / 1000);
            this._gameCountDownView = new GameCountDownView(totalTime);
            this._gameCountDownView.x = this._map.smallMap.x - this._gameCountDownView.width - 1;
            this._gameCountDownView.y = 2;
            addChild(this._gameCountDownView);
         }
      }
      
      private function isShowTrusteeship() : Boolean
      {
         if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.LEAGE_ROOM || RoomManager.Instance.current.type == RoomInfo.GUILD_LEAGE_MODE || RoomManager.Instance.current.type == RoomInfo.GUILD_LEAGE_MODE || RoomManager.Instance.current.type == RoomInfo.SCORE_ROOM || RoomManager.Instance.current.type == RoomInfo.SINGLE_BATTLE || RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ENCOUNTER_ROOM)
         {
            return true;
         }
         return false;
      }
      
      public function updateDamageView() : void
      {
         this._damageView.updateView();
      }
      
      protected function kingBlessIconInit() : void
      {
         var roomType:int = 0;
         if(KingBlessManager.instance.openType > 0)
         {
            roomType = RoomManager.Instance.current.type;
            if(roomType == RoomInfo.DUNGEON_ROOM || roomType == RoomInfo.ACADEMY_DUNGEON_ROOM || roomType == RoomInfo.LANBYRINTH_ROOM)
            {
               this._kingblessIcon = ComponentFactory.Instance.creatComponentByStylename("game.kingbless.addPropertyBuffIcon");
               this._kingblessIcon.visible = false;
               this._kingblessIcon.tipData = KingBlessManager.instance.getOneBuffData(KingBlessManager.STRENGTH_ENCHANCE);
               addChild(this._kingblessIcon);
            }
         }
      }
      
      private function resetPlayerCharacters() : void
      {
         var p:GameLiving = null;
         for each(p in this._players)
         {
            if(Boolean(p.info.character))
            {
               p.info.character.resetShowBitmapBig();
               p.info.character.showWing = true;
               p.info.character.show();
            }
         }
      }
      
      protected function __wishClick(pEvent:Event) : void
      {
         this._selfUsedProp.info.addState(0);
      }
      
      protected function __selfDie(event:LivingEvent) : void
      {
         var living:Living = null;
         var self:Living = event.currentTarget as Living;
         var team:DictionaryData = this._gameInfo.findTeam(self.team);
         for each(living in team)
         {
            if(living.isLiving)
            {
               this._fightControlBar.setState(FightControlBar.SOUL);
               return;
            }
         }
         ObjectUtils.disposeObject(this._selfBuffBar);
         this._selfBuffBar = null;
         ObjectUtils.disposeObject(this._kingblessIcon);
         this._kingblessIcon = null;
      }
      
      protected function drawMissionInfo() : void
      {
         if(this._gameInfo.roomType >= 2 && this._gameInfo.roomType != RoomInfo.FIGHT_LIB_ROOM && this._gameInfo.roomType != RoomInfo.ENCOUNTER_ROOM && this._gameInfo.roomType != RoomInfo.FIGHTGROUND_ROOM && this._gameInfo.roomType != RoomInfo.CONSORTIA_BATTLE && this._gameInfo.roomType != RoomInfo.RING_STATION && this._gameInfo.roomType != RoomInfo.SINGLE_BATTLE && this._gameInfo.roomType != RoomInfo.BOMB_KING && this._gameInfo.gameMode != GameManager.CAMP_BATTLE_MODEL_PVP && this._gameInfo.roomType != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            this._map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
            if(!this._barrier)
            {
               this._barrier = new DungeonInfoView(this._map.smallMap.titleBar.turnButton,this);
               this._barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
               this._barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            }
            if(!this._missionHelp)
            {
               this._missionHelp = new DungeonHelpView(this._map.smallMap.titleBar.turnButton,this._barrier,this);
               addChild(this._missionHelp);
            }
            this._barrier.open();
         }
      }
      
      protected function __updateSmallMapView(event:GameEvent) : void
      {
         var mission:MissionInfo = GameManager.Instance.Current.missionInfo;
         if(mission.currentValue1 != -1 && mission.totalValue1 > 0)
         {
            this._map.smallMap.setBarrier(mission.currentValue1,mission.totalValue1);
         }
      }
      
      protected function __dungeonHelpChanged(event:GameEvent) : void
      {
         var bounds:Rectangle = null;
         if(Boolean(this._missionHelp))
         {
            if(event.data)
            {
               if(this._missionHelp.opened)
               {
                  bounds = this._barrier.getBounds(this);
                  bounds.height = 1;
                  bounds.width = 1;
                  this._missionHelp.close(bounds);
               }
               else
               {
                  this._missionHelp.open();
               }
            }
            else if(this._missionHelp.opened)
            {
               bounds = this._map.smallMap.titleBar.turnButton.getBounds(this);
               this._missionHelp.close(bounds);
            }
         }
      }
      
      protected function __dungeonVisibleChanged(evt:DungeonInfoEvent) : void
      {
         if(Boolean(this._barrier) && this._barrierVisible)
         {
            if(Boolean(this._barrier.parent))
            {
               this._barrier.close();
            }
            else
            {
               this._barrier.open();
            }
         }
      }
      
      private function __onMissonHelpClick(event:MouseEvent) : void
      {
         StageReferance.stage.focus = this._map;
      }
      
      protected function initEvent() : void
      {
         this._playerThumbnailLController.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailControlHandle);
      }
      
      private function addPlayerHander(e:DictionaryEvent) : void
      {
         var player:GamePlayer = null;
         var movie:ICharacter = null;
         var character:ICharacter = null;
         var info:* = e.data;
         if(info is Player)
         {
            if(!info.movie)
            {
               movie = CharactoryFactory.createCharacter(info.playerInfo,"game");
               movie.show();
               info.movie = GameCharacter(movie);
            }
            if(!info.character)
            {
               character = CharactoryFactory.createCharacter(info.playerInfo,"show");
               ShowCharacter(character).show();
               info.character = ShowCharacter(character);
            }
            player = new GamePlayer(info,info.character,GameCharacter(movie));
            this._map.addPhysical(player);
            this._players[info] = player;
            this._playerThumbnailLController.addNewLiving(info);
         }
      }
      
      protected function loadWeakGuild() : void
      {
         this._vane.visible = PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_SHOW))
         {
            setTimeout(this.propOpenShow,2000,"asset.trainer.openVane");
            SocketManager.Instance.out.syncWeakStep(Step.VANE_SHOW);
         }
      }
      
      private function isWishGuideLoad() : Boolean
      {
         return true;
      }
      
      private function propOpenShow(mcStr:String) : void
      {
         var mc:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(mcStr),true,true);
         LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_UI_LAYER,false);
      }
      
      protected function newMap() : MapView
      {
         if(Boolean(this._map))
         {
            throw new Error(LanguageMgr.GetTranslation("tank.game.mapGenerated"));
         }
         return new MapView(this._gameInfo,this._gameInfo.loaderMap);
      }
      
      private function __soundChange(evt:Event) : void
      {
         var mapSound:SoundTransform = new SoundTransform();
         if(SharedManager.Instance.allowSound)
         {
            mapSound.volume = SharedManager.Instance.soundVolumn / 100;
            this.soundTransform = mapSound;
         }
         else
         {
            mapSound.volume = 0;
            this.soundTransform = mapSound;
         }
      }
      
      public function restoreSmallMap() : void
      {
         this._map.smallMap.restore();
      }
      
      protected function disposeUI() : void
      {
         if(Boolean(this._missionHelp))
         {
            this._missionHelp.removeEventListener(MouseEvent.CLICK,this.__onMissonHelpClick);
            ObjectUtils.disposeObject(this._missionHelp);
            this._missionHelp = null;
         }
         if(Boolean(this._arrowDown))
         {
            this._arrowDown.dispose();
         }
         if(Boolean(this._arrowUp))
         {
            this._arrowUp.dispose();
         }
         if(Boolean(this._arrowLeft))
         {
            this._arrowLeft.dispose();
         }
         if(Boolean(this._arrowRight))
         {
            this._arrowRight.dispose();
         }
         this._arrowDown = null;
         this._arrowLeft = null;
         this._arrowRight = null;
         this._arrowUp = null;
         ObjectUtils.disposeObject(this._achievBar);
         this._achievBar = null;
         if(Boolean(this._playerThumbnailLController))
         {
            this._playerThumbnailLController.dispose();
         }
         this._playerThumbnailLController = null;
         ObjectUtils.disposeObject(this._selfUsedProp);
         this._selfUsedProp = null;
         if(Boolean(this._leftPlayerView))
         {
            this._leftPlayerView.dispose();
         }
         this._leftPlayerView = null;
         if(Boolean(this._cs))
         {
            this._cs.leaving();
         }
         this._cs = null;
         ObjectUtils.disposeObject(this._fightControlBar);
         this._fightControlBar = null;
         ObjectUtils.disposeObject(this._selfMarkBar);
         this._selfMarkBar = null;
         if(Boolean(this._selfBuffBar))
         {
            ObjectUtils.disposeObject(this._selfBuffBar);
         }
         this._selfBuffBar = null;
         if(Boolean(this._vane))
         {
            this._vane.dispose();
            this._vane = null;
         }
         DisplayPool.Instance.clearAll();
         ObjectUtils.disposeObject(this._kingblessIcon);
         this._kingblessIcon = null;
         ObjectUtils.disposeObject(this._gameCountDownView);
         this._gameCountDownView = null;
         if(Boolean(this._damageView))
         {
            this._damageView.dispose();
            this._damageView = null;
         }
         ObjectUtils.disposeObject(this._rescueRoomItemView);
         this._rescueRoomItemView = null;
         ObjectUtils.disposeObject(this._rescueScoreView);
         this._rescueScoreView = null;
         if(Boolean(this._messageBtn))
         {
            this._messageBtn.removeEventListener(MouseEvent.CLICK,this.__onMessageClick);
            this._messageBtn.dispose();
            this._messageBtn = null;
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         super.leaving(next);
         this.disposeUI();
         this.wishRemoveEvent();
         this.removeGameData();
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         this._map.smallMap.titleBar.removeEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
         PlayerInfoViewControl.clearView();
         LayerManager.Instance.clearnGameDynamic();
         removeChild(this._map);
         this._map.dispose();
         this._map = null;
         SharedManager.Instance.removeEventListener(Event.CHANGE,this.__soundChange);
         ObjectUtils.disposeObject(this._missionHelp);
         this._missionHelp = null;
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__selfDie);
         IMEManager.enable();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         MenoryUtil.clearMenory();
         if(Boolean(this._barrier))
         {
            this._barrier.removeEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
            this._barrier.removeEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            ObjectUtils.disposeObject(this._barrier);
            this._barrier = null;
         }
         ObjectUtils.disposeObject(this._drawRoute);
         this._drawRoute = null;
         this._self = null;
         this._selfGameLiving = null;
         this._allLivings = null;
         this._gameLiving = null;
         ObjectUtils.disposeObject(this._gameTrusteeshipView);
         this._gameTrusteeshipView = null;
         this.wishRemoveEvent();
         ObjectUtils.disposeObject(this._drawRoute);
         this._drawRoute = null;
         WorldBossManager.Instance.isLoadingState = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.RESCUE_ITEM_INFO,this.__updateRescueItemInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_SCORE,this.__addRescueScore);
      }
      
      protected function setupGameData() : void
      {
         var info:Living = null;
         var view:GameLiving = null;
         var p:Player = null;
         var rp:RoomPlayer = null;
         var KEY:String = null;
         var movie:ICharacter = null;
         var character:ICharacter = null;
         var list:Array = new Array();
         for each(info in this._gameInfo.livings)
         {
            if(info is Player)
            {
               p = info as Player;
               rp = RoomManager.Instance.current.findPlayerByID(p.playerInfo.ID);
               if(!p.movie)
               {
                  movie = CharactoryFactory.createCharacter(p.playerInfo,"game");
                  movie.show();
                  p.movie = GameCharacter(movie);
               }
               if(!p.character)
               {
                  character = CharactoryFactory.createCharacter(p.playerInfo,"show");
                  ShowCharacter(character).show();
                  p.character = ShowCharacter(character);
               }
               if(p.isSelf)
               {
                  view = new GameLocalPlayer(this._gameInfo.selfGamePlayer,p.character,p.movie);
                  this._selfGamePlayer = view as GameLocalPlayer;
               }
               else
               {
                  view = new GamePlayer(p,p.character,p.movie);
               }
               if(Boolean(p.movie))
               {
                  p.movie.setDefaultAction(p.movie.standAction);
                  p.movie.doAction(p.movie.standAction);
               }
               for(KEY in p.outProperty)
               {
                  this.setProperty(view,KEY,p.outProperty[KEY]);
               }
               list.push(view);
               this._map.addPhysical(view);
               this._players[info] = view;
            }
         }
         this._map.wind = GameManager.Instance.Current.wind;
         this._map.currentTurn = 1;
         this._vane.initialize();
         this._vane.update(this._map.wind);
         this._map.act(new ViewEachPlayerAction(this._map,list));
      }
      
      protected function setProperty(obj:GameLiving, property:String, value:String) : void
      {
         var LockType:int = 0;
         var lockState:Boolean = false;
         var info:Living = null;
         var vo:StringObject = new StringObject(value);
         switch(property)
         {
            case "system":
               if(Boolean(obj))
               {
                  LockType = 0;
                  lockState = vo.getBoolean();
                  info = obj.info;
                  info.LockType = LockType;
                  info.LockState = lockState;
                  if(obj.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = lockState;
                     GameManager.Instance.Current.selfGamePlayer.lockFly = lockState;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = lockState;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !lockState;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !lockState;
                     GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = !lockState;
                  }
               }
               break;
            case "systemII":
               if(Boolean(obj))
               {
                  LockType = 0;
                  lockState = vo.getBoolean();
                  info = obj.info;
                  if(obj.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockFly = lockState;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = lockState;
                     GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = !lockState;
                  }
               }
               break;
            case "propzxc":
               if(Boolean(obj))
               {
                  LockType = 3;
                  lockState = vo.getBoolean();
                  info = obj.info;
                  info.LockType = LockType;
                  info.LockState = lockState;
                  if(obj.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = lockState;
                  }
               }
               break;
            case "silencedSpecial":
               if(Boolean(obj))
               {
                  LockType = 3;
                  lockState = vo.getBoolean();
                  info = obj.info;
                  info.LockType = LockType;
                  info.LockState = lockState;
                  if(obj.info.isSelf)
                  {
                     if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM && RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM)
                     {
                        GameManager.Instance.Current.selfGamePlayer.lockFly = lockState;
                     }
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = lockState;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = lockState;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !lockState;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !lockState;
                  }
               }
               break;
            case "silenced":
               if(Boolean(obj))
               {
                  LockType = 1;
                  lockState = vo.getBoolean();
                  info = obj.info;
                  info.LockType = LockType;
                  info.LockState = lockState;
                  if(obj.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !lockState;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !lockState;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = lockState;
                  }
               }
               break;
            case "nofly":
               LockType = 2;
               lockState = vo.getBoolean();
               info = obj.info;
               info.LockType = LockType;
               info.LockState = lockState;
               if(obj.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockFly = lockState;
               }
               break;
            case "silenceMany":
               LockType = 1;
               lockState = vo.getBoolean();
               info = obj.info;
               if(lockState)
               {
                  info.addBuff(BuffManager.creatBuff(BuffType.LockState));
               }
               else
               {
                  info.removeBuff(BuffType.LockState);
               }
               if(obj.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = lockState;
                  GameManager.Instance.Current.selfGamePlayer.lockFly = lockState;
                  GameManager.Instance.Current.selfGamePlayer.lockRightProp = lockState;
               }
               break;
            case "hideBossThumbnail":
               if(Boolean(obj))
               {
                  this._playerThumbnailLController.removeThumbnailContainer();
               }
               break;
            case "energy":
               if(Boolean(obj))
               {
                  obj.info.maxEnergy = vo.getNumber();
                  obj.info.energy = vo.getNumber();
               }
               break;
            case "energy2":
               if(Boolean(obj))
               {
                  obj.info.energy = vo.getNumber();
               }
               break;
            default:
               obj.setProperty(property,value);
         }
      }
      
      private function initDiePlayer() : void
      {
         var info:Living = null;
         for each(info in this._gameInfo.livings)
         {
            if(info.blood <= 0)
            {
               info.reset();
               info.die(true);
               if(Boolean(this._gameTrusteeshipView))
               {
                  this._gameTrusteeshipView.visible = false;
               }
            }
         }
      }
      
      private function removeGameData() : void
      {
         var view:GameLiving = null;
         for each(view in this._players)
         {
            view.dispose();
            delete this._players[view.info];
         }
         this._players = null;
         this._selfGamePlayer = null;
         this._gameInfo = null;
         this._barrierVisible = true;
      }
      
      public function addLiving($living:Living) : void
      {
      }
      
      private function updatePlayerState(info:Living) : void
      {
         if(this._selfUsedProp == null)
         {
            this._selfUsedProp = new PlayerStateContainer(12);
            PositionUtils.setPos(this._selfUsedProp,"asset.game.selfUsedProp");
            addChild(this._selfUsedProp);
         }
         if(Boolean(this._selfUsedProp))
         {
            this._selfUsedProp.disposeAllChildren();
         }
         if(Boolean(this._selfUsedProp) && Boolean(this._selfBuffBar))
         {
            this._selfUsedProp.x = this._selfBuffBar.right;
         }
         if(info is TurnedLiving)
         {
            this._selfUsedProp.info = TurnedLiving(info);
         }
         if(GameManager.Instance.Current.selfGamePlayer.isAutoGuide && GameManager.Instance.Current.currentLiving.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
         {
            MessageTipManager.getInstance().show(String(GameManager.Instance.Current.selfGamePlayer.LivingID),3);
         }
      }
      
      public function setCurrentPlayer(info:Living) : void
      {
         if(info && info.isSelf && info.isLiving)
         {
            if(Boolean(this._kingblessIcon))
            {
               this._kingblessIcon.visible = true;
               PositionUtils.setPos(this._kingblessIcon,"game.kingbless.addPropertyBuffIconPos2");
            }
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.propertyWaterBuffBarVisible = true;
            }
         }
         else
         {
            if(Boolean(this._kingblessIcon))
            {
               this._kingblessIcon.visible = false;
            }
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.propertyWaterBuffBarVisible = false;
            }
         }
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.visible = false;
            }
         }
         else if(Boolean(this._selfBuffBar))
         {
            this._selfBuffBar.visible = true;
         }
         if(!BombKingManager.instance.Recording && !RoomManager.Instance.current.selfRoomPlayer.isViewer && info && Boolean(this._selfBuffBar))
         {
            this._selfBuffBar.drawBuff(info,this._kingblessIcon);
         }
         if(Boolean(this._leftPlayerView))
         {
            this._leftPlayerView.info = info;
         }
         this._map.bringToFront(info);
         if(Boolean(this._map.currentPlayer) && !(info is TurnedLiving))
         {
            this._map.currentPlayer.isAttacking = false;
            this._map.currentPlayer = null;
         }
         else
         {
            this._map.currentPlayer = info as TurnedLiving;
         }
         this.updatePlayerState(info);
         if(Boolean(this._leftPlayerView))
         {
            addChildAt(this._leftPlayerView,this.numChildren - 3);
         }
         var self:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         if(Boolean(this._map.currentPlayer))
         {
            if(Boolean(self))
            {
               self.soulPropEnabled = !self.isLiving && this._map.currentPlayer.team == self.team;
            }
         }
         else if(Boolean(self))
         {
            self.soulPropEnabled = false;
         }
         if(info && info.isSelf && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            if(Boolean(this._kingblessIcon))
            {
               this._kingblessIcon.visible = false;
               PositionUtils.setPos(this._kingblessIcon,"game.kingbless.addPropertyBuffIconPos2");
            }
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.propertyWaterBuffBarVisible = false;
            }
         }
      }
      
      public function updateControlBarState(info:Living) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(GameManager.Instance.Current.selfGamePlayer.LockState)
         {
            this.setPropBarClickEnable(false,true);
            return;
         }
         if(info is TurnedLiving && info.isLiving && GameManager.Instance.Current.selfGamePlayer.canUseProp(info as TurnedLiving))
         {
            this.setPropBarClickEnable(true,false);
         }
         else if(Boolean(info))
         {
            if(!(!GameManager.Instance.Current.selfGamePlayer.isLiving && info.isSelf))
            {
               if(!(!GameManager.Instance.Current.selfGamePlayer.isLiving && GameManager.Instance.Current.selfGamePlayer.team != info.team))
               {
                  this.setPropBarClickEnable(true,false);
               }
            }
         }
         else
         {
            this.setPropBarClickEnable(true,false);
         }
      }
      
      protected function setPropBarClickEnable(clickAble:Boolean, isGray:Boolean) : void
      {
         GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = clickAble;
         if(RoomManager.Instance.current.type != RoomInfo.RING_STATION)
         {
            GameManager.Instance.Current.selfGamePlayer.customPropEnabled = clickAble;
         }
      }
      
      protected function gameOver() : void
      {
         this._map.smallMap.enableExit = false;
         if(!NewHandGuideManager.Instance.isNewHandFB())
         {
            SoundManager.instance.stopMusic();
         }
         else
         {
            SoundManager.instance.setMusicVolumeByRatio(0.5);
         }
         this.setPropBarClickEnable(false,false);
         this._leftPlayerView.gameOver();
         this._leftPlayerView.visible = false;
         if(Boolean(this._selfMarkBar))
         {
            this._selfMarkBar.shutdown();
         }
         if(NoviceDataManager.instance.firstEnterGame)
         {
            NoviceDataManager.instance.firstEnterGame = false;
            NoviceDataManager.instance.saveNoviceData(440,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      protected function set barrierInfo(evt:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._barrier))
         {
            this._barrier.barrierInfoHandler(evt);
         }
      }
      
      protected function set arrowHammerEnable(b:Boolean) : void
      {
      }
      
      public function blockHammer() : void
      {
      }
      
      public function allowHammer() : void
      {
      }
      
      protected function defaultForbidDragFocus() : void
      {
      }
      
      protected function setBarrierVisible(v:Boolean) : void
      {
         this._barrierVisible = v;
      }
      
      protected function setVaneVisible(v:Boolean) : void
      {
         this._vane.visible = v;
      }
      
      protected function setPlayerThumbVisible(v:Boolean) : void
      {
         this._playerThumbnailLController.visible = v;
      }
      
      protected function setEnergyVisible(v:Boolean) : void
      {
         var ls:LiveState = this._cs as LiveState;
         if(Boolean(ls))
         {
            ls.setEnergyVisible(v);
         }
      }
      
      public function setRecordRotation() : void
      {
      }
      
      public function get map() : MapView
      {
         return this._map;
      }
      
      protected function set mapWind(value:Number) : void
      {
         this._mapWind = value;
         if(this._useAble)
         {
            this.showShoot();
         }
      }
      
      public function get currentLivID() : int
      {
         return this._currentLivID;
      }
      
      public function set currentLivID(value:int) : void
      {
         this._currentLivID = value;
         this.showFightPower();
         this.drawRouteLine(this._currentLivID);
         if(Boolean(this._map))
         {
            this._map.smallMap.drawRouteLine(this._currentLivID);
         }
      }
      
      private function showFightPower() : void
      {
         var targetLiving:Living = null;
         if(this._currentLivID != -1 && Boolean(this._allLivings[this._currentLivID]))
         {
            targetLiving = this._allLivings[this._currentLivID] as Living;
            this._selfGameLiving.setFightPower(targetLiving.fightPower);
         }
      }
      
      private function wishInit() : void
      {
         this._self = GameManager.Instance.Current.selfGamePlayer;
         this._selfGameLiving = this._map.getPhysical(this._self.LivingID) as GamePlayer;
         this._allLivings = GameManager.Instance.Current.livings;
         this._drawRoute = new Sprite();
         this._map.addChild(this._drawRoute);
         this.currentLivID = -1;
         this._gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.addPlayerHander);
         this._self.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeAngle);
         this._self.addEventListener(LivingEvent.POS_CHANGED,this.__changeAngle);
         this._self.addEventListener(LivingEvent.DIR_CHANGED,this.__changeAngle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WISHOFDD,this.__wishofdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         RoomManager.Instance.addEventListener(RoomManager.PLAYER_ROOM_EXIT,this.__playerExit);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__KeyDown);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RESCUE_KING_BLESS,this.__useRescueKingBless);
      }
      
      private function wishRemoveEvent() : void
      {
         if(Boolean(this._self))
         {
            this._self.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__changeAngle);
            this._self.removeEventListener(LivingEvent.POS_CHANGED,this.__changeAngle);
            this._self.removeEventListener(LivingEvent.DIR_CHANGED,this.__changeAngle);
         }
         if(Boolean(this._gameInfo))
         {
            this._gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.addPlayerHander);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WISHOFDD,this.__wishofdd);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         RoomManager.Instance.removeEventListener(RoomManager.PLAYER_ROOM_EXIT,this.__playerExit);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__KeyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.RESCUE_KING_BLESS,this.__useRescueKingBless);
      }
      
      private function __useRescueKingBless(event:CrazyTankSocketEvent) : void
      {
         var pwind:Number = NaN;
         var pkg:PackageIn = event.pkg;
         var isShoot:Boolean = pkg.readBoolean();
         if(isShoot)
         {
            pwind = pkg.readInt();
            this._mapWind = pwind / 10 * this._windFactor;
            this._useAble = true;
            this.showShoot();
         }
      }
      
      protected function __KeyDown(event:KeyboardEvent) : void
      {
         var liv:Living = null;
         var i:int = 0;
         var tmpArr:Array = [];
         if(event.keyCode == KeyStroke.VK_V.getCode())
         {
            for each(liv in this._allLivings)
            {
               if(!(liv.isHidden || liv.team == GameManager.Instance.Current.selfGamePlayer.team || !liv.isLiving || liv.LivingID == this._self.LivingID))
               {
                  tmpArr.push(liv);
               }
            }
            for(i = 0; i <= tmpArr.length - 1; i++)
            {
               if((tmpArr[i] as Living).LivingID == this.currentLivID)
               {
                  if(i >= tmpArr.length - 1)
                  {
                     i = 0;
                  }
                  else
                  {
                     i++;
                  }
                  break;
               }
            }
            if(i <= tmpArr.length - 1)
            {
               this.currentLivID = tmpArr[i].LivingID;
            }
         }
      }
      
      protected function showShoot() : void
      {
         var enemyPos:Point = null;
         var liv:Living = null;
         var power:Number = NaN;
         var xS_Lef_E:Boolean = false;
         var yS_Up_E:Boolean = false;
         var shootpos:Point = this._selfGameLiving.body.localToGlobal(new Point(30,-20));
         shootpos = this._map.globalToLocal(shootpos);
         this._shootAngle = this._self.calcBombAngle();
         this._arf = this._map.airResistance;
         this._gf = this._map.gravity * this._mass * this._gravityFactor;
         this._ga = this._gf / this._mass;
         this._wa = this._mapWind / this._mass;
         for each(liv in this._allLivings)
         {
            liv.route = null;
            if(!(liv.isHidden || liv.team == GameManager.Instance.Current.selfGamePlayer.team || !liv.isLiving || liv.LivingID == this._self.LivingID))
            {
               enemyPos = liv.pos;
               if(this._self.isLiving && this._self.isAttacking)
               {
                  liv.route = null;
                  xS_Lef_E = true;
                  yS_Up_E = true;
                  if(shootpos.x > enemyPos.x)
                  {
                     xS_Lef_E = false;
                  }
                  if(shootpos.y > enemyPos.y)
                  {
                     yS_Up_E = false;
                  }
                  if(this.judgeMaxPower(shootpos,enemyPos,this._shootAngle,xS_Lef_E,yS_Up_E))
                  {
                     power = this.getPower(0,2000,shootpos,enemyPos,this._shootAngle,xS_Lef_E,yS_Up_E);
                  }
                  else
                  {
                     power = 2100;
                  }
                  this._stateFlag = 0;
                  if(power > 2000)
                  {
                     if(liv.state)
                     {
                        this._stateFlag = 1;
                     }
                     else
                     {
                        this._stateFlag = 2;
                     }
                     liv.state = false;
                  }
                  else
                  {
                     if(liv.state)
                     {
                        this._stateFlag = 3;
                     }
                     else
                     {
                        this._stateFlag = 4;
                     }
                     liv.state = true;
                  }
                  this._gameLiving = this._map.getPhysical(liv.LivingID) as GameLiving;
                  if(this._stateFlag == 1 || this._stateFlag == 2)
                  {
                     liv.route = null;
                  }
                  else
                  {
                     liv.route = this.getRouteData(power,this._shootAngle,shootpos,enemyPos);
                  }
                  liv.fightPower = Number((power * 100 / 2000).toFixed(1));
               }
            }
         }
         if(this.currentLivID == -1 || !this._allLivings[this.currentLivID].route)
         {
            this.currentLivID = this.calculateRecent();
         }
         else
         {
            this.currentLivID = this.currentLivID;
         }
      }
      
      private function judgeMaxPower(shootPos:Point, enemyPos:Point, shootAngle:Number, xS_Lef_E:Boolean, yS_Up_E:Boolean) : Boolean
      {
         var Ex:EulerVector = null;
         var Ey:EulerVector = null;
         var vx:int = 0;
         var vy:int = 0;
         vx = 2000 * Math.cos(shootAngle / 180 * Math.PI);
         Ex = new EulerVector(shootPos.x,vx,this._wa);
         vy = 2000 * Math.sin(shootAngle / 180 * Math.PI);
         Ey = new EulerVector(shootPos.y,vy,this._ga);
         var timeTemp:Boolean = false;
         while(true)
         {
            if(xS_Lef_E)
            {
               if(Ex.x0 > this._map.bound.width)
               {
                  return true;
               }
               if(Ex.x0 < this._map.bound.x || Ey.x0 > this._map.bound.height)
               {
                  return false;
               }
            }
            else
            {
               if(Ex.x0 < this._map.bound.x)
               {
                  break;
               }
               if(Ex.x0 > this._map.bound.width || Ey.x0 > this._map.bound.height)
               {
                  return false;
               }
            }
            if(this.ifHit(Ex.x0,Ey.x0,enemyPos))
            {
               return true;
            }
            Ex.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            Ey.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            if(xS_Lef_E && yS_Up_E)
            {
               if(Ey.x0 > enemyPos.y)
               {
                  if(Ex.x0 < enemyPos.x)
                  {
                     return false;
                  }
                  return true;
               }
            }
            else if(xS_Lef_E && !yS_Up_E)
            {
               if(!timeTemp)
               {
                  if(Ex.x0 > enemyPos.x)
                  {
                     return false;
                  }
                  if(Ey.x0 < enemyPos.y)
                  {
                     timeTemp = true;
                  }
               }
               else if(timeTemp)
               {
                  if(Ey.x0 > enemyPos.y)
                  {
                     if(Ex.x0 < enemyPos.x)
                     {
                        return false;
                     }
                     return true;
                  }
               }
            }
            else if(!xS_Lef_E && !yS_Up_E)
            {
               if(!timeTemp)
               {
                  if(Ex.x0 < enemyPos.x)
                  {
                     return false;
                  }
                  if(Ey.x0 < enemyPos.y)
                  {
                     timeTemp = true;
                  }
               }
               else if(timeTemp)
               {
                  if(Ey.x0 > enemyPos.y)
                  {
                     if(Ex.x0 < enemyPos.x)
                     {
                        return true;
                     }
                     return false;
                  }
               }
            }
            else if(!xS_Lef_E && yS_Up_E)
            {
               if(Ey.x0 > enemyPos.y)
               {
                  if(Ex.x0 < enemyPos.x)
                  {
                     return true;
                  }
                  return false;
               }
            }
         }
         return true;
      }
      
      protected function getPower(min:Number, max:Number, shootPos:Point, enemyPos:Point, shootAngle:Number, xS_Lef_E:Boolean, yS_Up_E:Boolean) : Number
      {
         var Ex:EulerVector = null;
         var Ey:EulerVector = null;
         var vx:int = 0;
         var vy:int = 0;
         var power:int = (min + max) / 2;
         if(power <= min || power >= max)
         {
            return power;
         }
         vx = power * Math.cos(shootAngle / 180 * Math.PI);
         Ex = new EulerVector(shootPos.x,vx,this._wa);
         vy = power * Math.sin(shootAngle / 180 * Math.PI);
         Ey = new EulerVector(shootPos.y,vy,this._ga);
         var timeTemp:Boolean = false;
         while(true)
         {
            if(xS_Lef_E)
            {
               if(Ex.x0 > this._map.bound.width)
               {
                  power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  break;
               }
               if(Ey.x0 > this._map.bound.height)
               {
                  power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  break;
               }
               if(Ex.x0 < this._map.bound.x)
               {
                  return 2100;
               }
            }
            else
            {
               if(Ex.x0 < this._map.bound.x)
               {
                  power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  break;
               }
               if(Ey.x0 > this._map.bound.height)
               {
                  power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  break;
               }
               if(Ex.x0 > this._map.bound.width)
               {
                  return 2100;
               }
            }
            if(this.ifHit(Ex.x0,Ey.x0,enemyPos))
            {
               return power;
            }
            Ex.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            Ey.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            if(xS_Lef_E && yS_Up_E)
            {
               if(Ey.x0 > enemyPos.y)
               {
                  if(Ex.x0 < enemyPos.x)
                  {
                     power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  }
                  else
                  {
                     power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  }
                  break;
               }
            }
            else if(xS_Lef_E && !yS_Up_E)
            {
               if(!timeTemp)
               {
                  if(Ex.x0 > enemyPos.x)
                  {
                     power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     break;
                  }
                  if(Ey.x0 < enemyPos.y)
                  {
                     timeTemp = true;
                  }
               }
               else if(timeTemp)
               {
                  if(Ey.x0 > enemyPos.y)
                  {
                     if(Ex.x0 < enemyPos.x)
                     {
                        power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     }
                     else
                     {
                        power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     }
                     break;
                  }
               }
            }
            else if(!xS_Lef_E && !yS_Up_E)
            {
               if(!timeTemp)
               {
                  if(Ex.x0 < enemyPos.x)
                  {
                     power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     break;
                  }
                  if(Ey.x0 < enemyPos.y)
                  {
                     timeTemp = true;
                  }
               }
               else if(timeTemp)
               {
                  if(Ey.x0 > enemyPos.y)
                  {
                     if(Ex.x0 > enemyPos.x)
                     {
                        power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     }
                     else
                     {
                        power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                     }
                     break;
                  }
               }
            }
            else if(!xS_Lef_E && yS_Up_E)
            {
               if(Ey.x0 > enemyPos.y)
               {
                  if(Ex.x0 > enemyPos.x)
                  {
                     power = this.getPower(power,max,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  }
                  else
                  {
                     power = this.getPower(min,power,shootPos,enemyPos,shootAngle,xS_Lef_E,yS_Up_E);
                  }
                  break;
               }
            }
         }
         return power;
      }
      
      protected function ifHit(bulletX:Number, bulletY:Number, enemyPos:Point) : Boolean
      {
         if(bulletX > enemyPos.x - 15 && bulletX < enemyPos.x + 20 && bulletY > enemyPos.y - 20 && bulletY < enemyPos.y + 30)
         {
            return true;
         }
         return false;
      }
      
      private function isOutOfMap(ex:EulerVector, ey:EulerVector) : Boolean
      {
         if(ex.x0 < this._map.bound.x || ex.x0 > this._map.bound.width || ey.x0 > this._map.bound.height)
         {
            return true;
         }
         return false;
      }
      
      private function drawRouteLine(id:int) : void
      {
         var liv:Living = null;
         this._drawRoute.graphics.clear();
         for each(liv in this._allLivings)
         {
            liv.currentSelectId = id;
         }
         if(id < 0)
         {
            return;
         }
         var living:Living = this._allLivings[id];
         if(!living)
         {
            return;
         }
         var data:Vector.<Point> = living.route;
         if(!data || data.length == 0)
         {
            return;
         }
         var enemyLiving:GamePlayer = this._map.getPhysical(id) as GamePlayer;
         this._collideRect.x = living.pos.x - 50;
         this._collideRect.y = living.pos.y - 50;
         this._drawRoute.graphics.lineStyle(2,16711680,0.5);
         var length:int = int(data.length);
         for(var i:int = 0; i < length - 1; i++)
         {
            this.drawDashed(this._drawRoute.graphics,data[i],data[i + 1],8,5);
         }
      }
      
      private function getRouteData(power:Number, shootAngle:Number, shootPos:Point, enemyPos:Point) : Vector.<Point>
      {
         var Ex:EulerVector = null;
         var Ey:EulerVector = null;
         var vx:int = 0;
         var vy:int = 0;
         if(power > 2000)
         {
            return null;
         }
         vx = power * Math.cos(shootAngle / 180 * Math.PI);
         Ex = new EulerVector(shootPos.x,vx,this._wa);
         vy = power * Math.sin(shootAngle / 180 * Math.PI);
         Ey = new EulerVector(shootPos.y,vy,this._ga);
         var ary:Vector.<Point> = new Vector.<Point>();
         ary.push(new Point(shootPos.x,shootPos.y));
         while(!this.isOutOfMap(Ex,Ey))
         {
            if(this.ifHit(Ex.x0,Ey.x0,enemyPos))
            {
               return ary;
            }
            Ex.ComputeOneEulerStep(this._mass,this._arf,this._mapWind,this._dt);
            Ey.ComputeOneEulerStep(this._mass,this._arf,this._gf,this._dt);
            ary.push(new Point(Ex.x0,Ey.x0));
         }
         return ary;
      }
      
      public function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         if(!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0)
         {
            return;
         }
         var Ox:Number = beginPoint.x;
         var Oy:Number = beginPoint.y;
         var radian:Number = Math.atan2(endPoint.y - Oy,endPoint.x - Ox);
         var totalLen:Number = Point.distance(beginPoint,endPoint);
         var currLen:Number = 0;
         while(currLen <= totalLen)
         {
            if(this._collideRect.contains(x,y))
            {
               return;
            }
            x = Ox + Math.cos(radian) * currLen;
            y = Oy + Math.sin(radian) * currLen;
            graphics.moveTo(x,y);
            currLen += width;
            if(currLen > totalLen)
            {
               currLen = totalLen;
            }
            x = Ox + Math.cos(radian) * currLen;
            y = Oy + Math.sin(radian) * currLen;
            graphics.lineTo(x,y);
            currLen += grap;
         }
      }
      
      private function drawArrow(graphics:Graphics, start:Point, end:Point, angle:Number, length:int) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         if(!start || !end || !angle || length <= 0)
         {
            return;
         }
         var radian:Number = Math.atan2(end.y - start.y,end.x - start.x);
         angle = angle * Math.PI / 180;
         graphics.moveTo(end.x,end.y);
         x = end.x + Math.cos(radian + angle) * length;
         y = end.y + Math.sin(radian + angle) * length;
         graphics.lineTo(x,y);
         graphics.moveTo(end.x,end.y);
         x = end.x + Math.cos(radian - angle) * length;
         y = end.y + Math.sin(radian - angle) * length;
         graphics.lineTo(x,y);
      }
      
      private function __playerChange(event:CrazyTankSocketEvent) : void
      {
         var liv:Living = null;
         this._drawRoute.graphics.clear();
         this._useAble = false;
         this.currentLivID = -1;
         for each(liv in this._allLivings)
         {
            liv.state = false;
         }
      }
      
      private function __playerExit(e:Event) : void
      {
         if(this._useAble)
         {
            this.currentLivID = this.calculateRecent();
         }
      }
      
      protected function __changeAngle(event:LivingEvent) : void
      {
         if(this._useAble)
         {
            this.showShoot();
         }
      }
      
      protected function __wishofdd(event:CrazyTankSocketEvent) : void
      {
         var pwind:Number = NaN;
         var pwind2:Number = NaN;
         var shoot:Boolean = event.pkg.readBoolean();
         if(shoot)
         {
            pwind = event.pkg.readInt();
            this._mapWind = pwind / 10 * this._windFactor;
            this._useAble = true;
            this.showShoot();
         }
         else
         {
            pwind2 = event.pkg.readInt();
            this._useAble = false;
         }
      }
      
      private function __thumbnailControlHandle(e:GameEvent) : void
      {
         this.currentLivID = e.data as int;
      }
      
      private function calculateRecent() : int
      {
         var liv:Living = null;
         var livRoute:Vector.<Point> = null;
         var length:int = 0;
         var distance:int = 0;
         var min:int = int.MAX_VALUE;
         var ret:int = -1;
         for each(liv in this._allLivings)
         {
            if(Boolean(liv.route))
            {
               if(RoomManager.Instance.current.type == RoomInfo.RESCUE || !(liv is SmallEnemy))
               {
                  livRoute = liv.route;
                  length = int(livRoute.length);
                  if(length >= 2)
                  {
                     distance = this.getDistance(livRoute[0],livRoute[length - 1]);
                     if(distance < min)
                     {
                        min = distance;
                        ret = liv.LivingID;
                     }
                  }
               }
            }
         }
         return ret;
      }
      
      private function getDistance(start:Point, end:Point) : int
      {
         return (end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y);
      }
      
      public function get barrier() : DungeonInfoView
      {
         return this._barrier;
      }
      
      public function get messageBtn() : BaseButton
      {
         return this._messageBtn;
      }
   }
}

