package worldboss.view
{
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import hall.event.NewHallEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossRoomModel;
   import worldboss.player.PlayerVO;
   import worldboss.player.WorldRoomPlayer;
   
   public class WorldBossScneneMap extends Sprite implements Disposeable
   {
      
      public static const SCENE_ALLOW_FIRES:int = 6;
      
      private const CLICK_INTERVAL:Number = 200;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      public var selfPlayer:WorldRoomPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:WorldRoomPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:WorldBossRoomModel;
      
      private var _worldboss:MovieClip;
      
      private var _worldboss_mc:MovieClip;
      
      private var _worldboss_sky:MovieClip;
      
      private var armyPos:Point;
      
      private var decorationLayer:Sprite;
      
      private var _timerStartGame:Timer;
      
      private var _isShowOther:Boolean = true;
      
      private var _beforeTimeView:WorldBossBeforeTimer;
      
      private var r:int = 250;
      
      private var auto:Point;
      
      private var autoMove:Boolean = false;
      
      private var clickAgain:Boolean = false;
      
      private var _entering:Boolean = false;
      
      private var _isFight:Boolean = false;
      
      private var _frame_name:String = "stand";
      
      protected var reference:WorldRoomPlayer;
      
      public function WorldBossScneneMap(model:WorldBossRoomModel, sceneScene:SceneScene, data:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite = null, sky:Sprite = null, decoration:Sprite = null)
      {
         super();
         this._model = model;
         this.sceneScene = sceneScene;
         this._data = data;
         if(bg == null)
         {
            this.bgLayer = new Sprite();
         }
         else
         {
            this.bgLayer = bg;
         }
         this.meshLayer = mesh == null ? new Sprite() : mesh;
         this.meshLayer.alpha = 0;
         this.articleLayer = acticle == null ? new Sprite() : acticle;
         this.decorationLayer = decoration == null ? new Sprite() : decoration;
         this.skyLayer = sky == null ? new Sprite() : sky;
         this.decorationLayer.mouseEnabled = false;
         this.decorationLayer.mouseChildren = false;
         this.addChild(this.bgLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.decorationLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
         this.initBoss();
         this.initBeforeTimeView();
         WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.HIDE_PLAYER_CHANGE,false));
      }
      
      private function initBeforeTimeView() : void
      {
         var tmpTime:int = WorldBossManager.Instance.beforeStartTime;
         if(tmpTime > 0)
         {
            this.hideBoss();
            this._beforeTimeView = new WorldBossBeforeTimer(tmpTime);
            this._beforeTimeView.addEventListener(Event.COMPLETE,this.beforeTimeEndHandler,false,0,true);
            LayerManager.Instance.addToLayer(this._beforeTimeView,LayerManager.GAME_DYNAMIC_LAYER,true);
         }
      }
      
      private function beforeTimeEndHandler(event:Event) : void
      {
         this.disposeBeforeTimeView();
         this.showBoss();
      }
      
      private function disposeBeforeTimeView() : void
      {
         if(Boolean(this._beforeTimeView))
         {
            this._beforeTimeView.removeEventListener(Event.COMPLETE,this.beforeTimeEndHandler);
            ObjectUtils.disposeObject(this._beforeTimeView);
            this._beforeTimeView = null;
         }
      }
      
      private function hideBoss() : void
      {
         if(Boolean(this._worldboss))
         {
            this._worldboss.visible = false;
         }
         if(Boolean(this._worldboss_mc))
         {
            this._worldboss_mc.visible = false;
         }
         if(Boolean(this._worldboss_sky))
         {
            this._worldboss_sky.visible = false;
         }
         if(Boolean(this.bgLayer) && Boolean(this.bgLayer.getChildByName("prompt")))
         {
            this.bgLayer.getChildByName("prompt").visible = false;
         }
      }
      
      private function showBoss() : void
      {
         if(Boolean(this._worldboss))
         {
            this._worldboss.visible = true;
         }
         if(Boolean(this._worldboss_mc))
         {
            this._worldboss_mc.visible = true;
         }
         if(Boolean(this._worldboss_sky))
         {
            this._worldboss_sky.visible = true;
         }
         if(Boolean(this.bgLayer) && Boolean(this.bgLayer.getChildByName("prompt")))
         {
            this.bgLayer.getChildByName("prompt").visible = true;
         }
      }
      
      private function initBoss() : void
      {
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this._worldboss = this.skyLayer.getChildByName("worldboss_mc") as MovieClip;
            this._worldboss.addEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
            this._worldboss.buttonMode = true;
            this._worldboss_mc = this.bgLayer.getChildByName("worldboss") as MovieClip;
            this._worldboss_sky = this.bgLayer.getChildByName("worldboss_sky") as MovieClip;
            this.armyPos = new Point(this.bgLayer.getChildByName("armyPos").x,this.bgLayer.getChildByName("armyPos").y);
         }
         if(WorldBossManager.Instance.bossInfo.fightOver)
         {
            this._worldboss.parent.removeChild(this._worldboss);
            this._worldboss_mc.parent.removeChild(this._worldboss_mc);
            this._worldboss_sky.visible = false;
            this.removePrompt();
         }
      }
      
      private function _enterWorldBossGame(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.autoMove || this.selfPlayer.playerVO.playerStauts != 1 || !this.selfPlayer.getCanAction() || this._entering)
         {
            return;
         }
         if(this.checkCanStartGame() && getTimer() - this._lastClick > this._clickInterval)
         {
            SoundManager.instance.play("008");
            this._mouseMovie.gotoAndStop(1);
            this._lastClick = getTimer();
            if(this.checkDistance())
            {
               this.CreateStartGame();
            }
            else if(Boolean(this.auto) && !this.sceneScene.hit(this.auto))
            {
               this.autoMove = true;
               this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
               this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint,this.auto);
               this.selfPlayer.playerVO.walkPath.shift();
               this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.playerVO.walkPath[0]);
               this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
            }
         }
      }
      
      private function checkDistance() : Boolean
      {
         var k:Number = NaN;
         var disX:Number = this.selfPlayer.x - this.armyPos.x;
         var disY:Number = this.selfPlayer.y - this.armyPos.y;
         if(Math.pow(disX,2) + Math.pow(disY,2) > Math.pow(this.r,2))
         {
            k = Math.atan2(disY,disX);
            this.auto = new Point(this.armyPos.x,this.armyPos.y);
            this.auto.x += (disX > 0 ? 1 : -1) * Math.abs(Math.cos(k) * this.r);
            this.auto.y += (disY > 0 ? 1 : -1) * Math.abs(Math.sin(k) * this.r);
            return false;
         }
         return true;
      }
      
      private function checkCanStartGame() : Boolean
      {
         var result:Boolean = true;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            result = false;
         }
         return result;
      }
      
      public function set enterIng(value:Boolean) : void
      {
         this._entering = value;
      }
      
      public function removePrompt() : void
      {
         if(Boolean(this.bgLayer.getChildByName("prompt")))
         {
            this.bgLayer.removeChild(this.bgLayer.getChildByName("prompt"));
         }
      }
      
      private function CreateStartGame() : void
      {
         if(this._entering)
         {
            return;
         }
         if(WorldBossManager.Instance.bossInfo.need_ticket_count == 0)
         {
            this._entering = true;
            this.startGame();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.tickets.propInfo",WorldBossManager.Instance.bossInfo.need_ticket_count),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(WorldBossManager.Instance.bossInfo.ticketID) > 0)
               {
                  this.startGame();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.tickets.none"),0,true);
                  this.autoMove = false;
               }
               alert.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               alert.dispose();
               this.autoMove = false;
         }
      }
      
      private function startGame() : void
      {
         if(!WorldBossManager.Instance.isLoadingState)
         {
            SocketManager.Instance.out.createUserGuide(14);
         }
      }
      
      protected function __startFight(event:Event) : void
      {
         this._isFight = true;
         this._timerStartGame = new Timer(2000,1);
         this._timerStartGame.addEventListener(TimerEvent.TIMER,this.timeStartGame);
         this._timerStartGame.start();
         this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
      }
      
      private function timeStartGame(event:TimerEvent) : void
      {
         this.CreateStartGame();
         this._timerStartGame.stop();
         this._timerStartGame.removeEventListener(TimerEvent.TIMER,this.timeStartGame);
         this._timerStartGame = null;
      }
      
      private function __stopFight(e:Event) : void
      {
         this.enterIng = false;
      }
      
      private function __arrive(e:SceneCharacterEvent) : void
      {
         if(this.autoMove)
         {
            this.CreateStartGame();
         }
      }
      
      public function gameOver() : void
      {
         this._worldboss.mouseEnabled = false;
         this._worldboss.removeEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
         if(!WorldBossManager.Instance.bossInfo.isLiving)
         {
            this._worldboss_mc.gotoAndPlay("out");
         }
         else
         {
            this._worldboss_mc.gotoAndPlay("outB");
         }
         this._worldboss_sky.visible = false;
         this.removePrompt();
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      public function set sceneMapVO(value:SceneMapVO) : void
      {
         this._sceneMapVO = value;
      }
      
      protected function init() : void
      {
         this._characters = new DictionaryData(true);
         var mvClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.worldboss.room.MouseClickMovie") as Class;
         this._mouseMovie = new mvClass() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL,this.__onRoomFull);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.STOPFIGHT,this.__stopFight);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.STARTFIGHT,this.__startFight);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.HIDE_PLAYER_CHANGE,this._hideOtherPlayer);
         PlayerManager.Instance.addEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      protected function __onSetSelfPlayerPos(event:NewHallEvent) : void
      {
         this.__click(event.data[0]);
      }
      
      private function _hideOtherPlayer(event:WorldBossRoomEvent) : void
      {
         var worldRoomPlayer:WorldRoomPlayer = null;
         this._isShowOther = event.data as Boolean;
         if(Boolean(this._characters))
         {
            for each(worldRoomPlayer in this._characters)
            {
               if(worldRoomPlayer.ID != PlayerManager.Instance.Self.ID)
               {
                  worldRoomPlayer.visible = this._isShowOther;
               }
            }
         }
      }
      
      private function __onRoomFull(pEvent:WorldBossRoomEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.room.roomFull"),0,true);
         this._entering = false;
      }
      
      private function menuChange(evt:WorldBossRoomEvent) : void
      {
         switch(evt.type)
         {
            case WorldBossRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var worldRoomPlayer:WorldRoomPlayer = null;
         for each(worldRoomPlayer in this._characters)
         {
            worldRoomPlayer.isShowName = this._model.playerNameVisible;
         }
      }
      
      protected function updateMap(event:Event) : void
      {
         var player:WorldRoomPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(player in this._characters)
         {
            player.updatePlayer();
            player.isShowName = this._model.playerNameVisible;
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(event:MouseEvent) : void
      {
         if(!this.selfPlayer || this.selfPlayer.playerVO.playerStauts != 1 || !this.selfPlayer.getCanAction())
         {
            return;
         }
         var targetPoint:Point = this.globalToLocal(new Point(event.stageX,event.stageY));
         this.autoMove = false;
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(targetPoint))
            {
               this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint,targetPoint);
               this.selfPlayer.playerVO.walkPath.shift();
               this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.playerVO.walkPath[0]);
               this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
               this._mouseMovie.x = targetPoint.x;
               this._mouseMovie.y = targetPoint.y;
               this._mouseMovie.play();
            }
         }
      }
      
      public function sendMyPosition(p:Array) : void
      {
         var i:uint = 0;
         for(var arr:Array = []; i < p.length; )
         {
            arr.push(int(p[i].x),int(p[i].y));
            i++;
         }
         var pathStr:String = arr.toString();
         SocketManager.Instance.out.sendWorldBossRoomMove(p[p.length - 1].x,p[p.length - 1].y,pathStr);
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         var worldRoomPlayer:WorldRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            worldRoomPlayer = this._characters[id] as WorldRoomPlayer;
            if(!worldRoomPlayer.getCanAction())
            {
               worldRoomPlayer.playerVO.playerStauts = 1;
               worldRoomPlayer.setStatus();
            }
            worldRoomPlayer.playerVO.walkPath = p;
            worldRoomPlayer.playerWalk(p);
         }
      }
      
      public function updatePlayersStauts(id:int, stauts:int, point:Point) : void
      {
         var worldRoomPlayer:WorldRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            worldRoomPlayer = this._characters[id] as WorldRoomPlayer;
            if(stauts == 1 && worldRoomPlayer.playerVO.playerStauts == 3)
            {
               worldRoomPlayer.playerVO.playerStauts = stauts;
               worldRoomPlayer.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
               worldRoomPlayer.setStatus();
            }
            else if(stauts == 2)
            {
               if(!worldRoomPlayer.getCanAction())
               {
                  worldRoomPlayer.playerVO.playerStauts = 1;
                  worldRoomPlayer.setStatus();
               }
               worldRoomPlayer.playerVO.playerStauts = stauts;
               worldRoomPlayer.isReadyFight = true;
               worldRoomPlayer.addEventListener(WorldBossRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
               worldRoomPlayer.playerVO.walkPath = [point];
               worldRoomPlayer.playerWalk([point]);
            }
            else
            {
               worldRoomPlayer.playerVO.playerStauts = stauts;
               worldRoomPlayer.setStatus();
            }
         }
      }
      
      public function __otherPlayrStartFight(evt:WorldBossRoomEvent) : void
      {
         var worldRoomPlayer:WorldRoomPlayer = evt.currentTarget as WorldRoomPlayer;
         worldRoomPlayer.removeEventListener(WorldBossRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
         worldRoomPlayer.sceneCharacterDirection = SceneCharacterDirection.getDirection(worldRoomPlayer.playerPoint,this.armyPos);
         worldRoomPlayer.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         worldRoomPlayer.isReadyFight = false;
         worldRoomPlayer.setStatus();
      }
      
      public function updateSelfStatus(value:int) : void
      {
         if(this.selfPlayer.playerVO.playerStauts == 3)
         {
            this.selfPlayer.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this._entering = false;
         }
         this.selfPlayer.playerVO.playerStauts = value;
         this.selfPlayer.setStatus();
         SocketManager.Instance.out.sendWorldBossRoomStauts(value);
         this.checkGameOver();
         if(this._frame_name == "out" || this._frame_name == "outB")
         {
            this.selfPlayer.playerVO.playerStauts = 1;
            this.selfPlayer.setStatus();
            SocketManager.Instance.out.sendWorldBossRoomStauts(1);
         }
      }
      
      public function checkSelfStatus() : int
      {
         return this.selfPlayer.playerVO.playerStauts;
      }
      
      public function playerRevive(id:int) : void
      {
         var worldRoomPlayer:WorldRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            worldRoomPlayer = this._characters[id] as WorldRoomPlayer;
            worldRoomPlayer.revive();
            this.selfPlayer.playerVO.playerStauts = 1;
            this._entering = false;
            if(WorldBossManager.Instance.BossResourceId == "4")
            {
               this.selfPlayer.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
               this.ajustScreen(this.selfPlayer);
               this.setCenter();
            }
         }
         if(this._isFight)
         {
            SocketManager.Instance.out.createUserGuide(14);
            this._isFight = false;
         }
      }
      
      private function worldBoss_mc_gotoAndplay() : void
      {
         this._worldboss_mc.gotoAndPlay(this._frame_name);
      }
      
      private function checkGameOver() : Boolean
      {
         if(WorldBossManager.Instance.bossInfo.fightOver && Boolean(this._worldboss))
         {
            this._worldboss.mouseEnabled = false;
            this._worldboss.removeEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
            if(!WorldBossManager.Instance.bossInfo.isLiving)
            {
               this._frame_name = "out";
            }
            else if(WorldBossManager.Instance.bossInfo.getLeftTime() == 0)
            {
               this._frame_name = "outB";
            }
            setTimeout(this.worldBoss_mc_gotoAndplay,1500);
            this._worldboss_sky.visible = false;
         }
         return WorldBossManager.Instance.bossInfo.fightOver;
      }
      
      public function setCenter(event:SceneCharacterEvent = null) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         if(Boolean(this.reference))
         {
            xf = -(this.reference.x - MoonSceneMap.GAME_WIDTH / 2);
            yf = -(this.reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         else
         {
            xf = -(WorldBossManager.Instance.bossInfo.playerDefaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            yf = -(WorldBossManager.Instance.bossInfo.playerDefaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW)
         {
            xf = MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW;
         }
         if(yf > 0)
         {
            yf = 0;
         }
         if(yf < MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH)
         {
            yf = MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH;
         }
         x = xf;
         y = yf;
         var point:Point = this.globalToLocal(new Point(700,300));
         this._worldboss_sky.x = point.x;
         this._worldboss_sky.y = point.y;
      }
      
      public function addSelfPlayer() : void
      {
         var selfPlayerVO:PlayerVO = null;
         if(!this.selfPlayer)
         {
            selfPlayerVO = WorldBossManager.Instance.bossInfo.myPlayerVO;
            selfPlayerVO.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new WorldRoomPlayer(selfPlayerVO,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(worldRoomPlayer:WorldRoomPlayer) : void
      {
         if(worldRoomPlayer == null)
         {
            if(Boolean(this.reference))
            {
               this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.reference = null;
            }
            return;
         }
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this.reference = worldRoomPlayer;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(event:DictionaryEvent) : void
      {
         var playerVO:PlayerVO = event.data as PlayerVO;
         this._currentLoadingPlayer = new WorldRoomPlayer(playerVO,this.addPlayerCallBack);
         if(playerVO.playerInfo.ID != PlayerManager.Instance.Self.ID)
         {
            this._currentLoadingPlayer.visible = this._isShowOther;
         }
      }
      
      private function addPlayerCallBack(worldRoomPlayer:WorldRoomPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!this.articleLayer || !worldRoomPlayer)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            worldRoomPlayer.sceneScene = this.sceneScene;
            worldRoomPlayer.setSceneCharacterDirectionDefault = worldRoomPlayer.sceneCharacterDirection = worldRoomPlayer.playerVO.scenePlayerDirection;
            if(!this.selfPlayer && worldRoomPlayer.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               worldRoomPlayer.playerVO.playerPos = worldRoomPlayer.playerVO.playerPos;
               this.selfPlayer = worldRoomPlayer;
               this.articleLayer.addChild(this.selfPlayer);
               this.ajustScreen(this.selfPlayer);
               this.setCenter();
               if(this.selfPlayer.isInitialized)
               {
                  this.selfPlayer.setStatus();
               }
               this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this.articleLayer.addChild(worldRoomPlayer);
            }
            worldRoomPlayer.playerPoint = worldRoomPlayer.playerVO.playerPos;
            worldRoomPlayer.sceneCharacterStateType = "natural";
            this._characters.add(worldRoomPlayer.playerVO.playerInfo.ID,worldRoomPlayer);
            worldRoomPlayer.isShowName = this._model.playerNameVisible;
            if(worldRoomPlayer.playerVO.playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
               worldRoomPlayer.visible = this._isShowOther;
            }
         }
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __removePlayer(event:DictionaryEvent) : void
      {
         var id:int = (event.data as PlayerVO).playerInfo.ID;
         var player:WorldRoomPlayer = this._characters[id] as WorldRoomPlayer;
         this._characters.remove(id);
         if(Boolean(player))
         {
            if(Boolean(player.parent))
            {
               player.parent.removeChild(player);
            }
            player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            player.dispose();
         }
         player = null;
      }
      
      protected function BuildEntityDepth() : void
      {
         var obj:DisplayObject = null;
         var depth:Number = NaN;
         var minIndex:int = 0;
         var minDepth:Number = NaN;
         var j:int = 0;
         var temp:DisplayObject = null;
         var tempDepth:Number = NaN;
         var count:int = this.articleLayer.numChildren;
         for(var i:int = 0; i < count - 1; i++)
         {
            obj = this.articleLayer.getChildAt(i);
            depth = this.getPointDepth(obj.x,obj.y);
            minDepth = Number.MAX_VALUE;
            for(j = i + 1; j < count; j++)
            {
               temp = this.articleLayer.getChildAt(j);
               tempDepth = this.getPointDepth(temp.x,temp.y);
               if(tempDepth < minDepth)
               {
                  minIndex = j;
                  minDepth = tempDepth;
               }
            }
            if(depth > minDepth)
            {
               this.articleLayer.swapChildrenAt(i,minIndex);
            }
         }
      }
      
      protected function getPointDepth(x:Number, y:Number) : Number
      {
         return this.sceneMapVO.mapW * y + x;
      }
      
      protected function removeEvent() : void
      {
         this._model.removeEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(Boolean(this.selfPlayer))
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL,this.__onRoomFull);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.STOPFIGHT,this.__stopFight);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.STARTFIGHT,this.__startFight);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.HIDE_PLAYER_CHANGE,this._hideOtherPlayer);
         PlayerManager.Instance.removeEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      public function dispose() : void
      {
         var p:WorldRoomPlayer = null;
         var i:int = 0;
         var player:WorldRoomPlayer = null;
         this.removeEvent();
         if(Boolean(this._timerStartGame))
         {
            this._timerStartGame.stop();
            this._timerStartGame.removeEventListener(TimerEvent.TIMER,this.timeStartGame);
            this._timerStartGame = null;
         }
         this._data.clear();
         this._data = null;
         this._sceneMapVO = null;
         for each(p in this._characters)
         {
            if(Boolean(p.parent))
            {
               p.parent.removeChild(p);
            }
            p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            p.dispose();
            p = null;
         }
         this._characters.clear();
         this._characters = null;
         if(Boolean(this.articleLayer))
         {
            for(i = this.articleLayer.numChildren; i > 0; i--)
            {
               player = this.articleLayer.getChildAt(i - 1) as WorldRoomPlayer;
               if(Boolean(player))
               {
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(Boolean(player.parent))
                  {
                     player.parent.removeChild(player);
                  }
                  player.dispose();
               }
               player = null;
               try
               {
                  this.articleLayer.removeChildAt(i - 1);
               }
               catch(e:RangeError)
               {
               }
            }
            if(Boolean(this.articleLayer) && Boolean(this.articleLayer.parent))
            {
               this.articleLayer.parent.removeChild(this.articleLayer);
            }
         }
         this.articleLayer = null;
         if(Boolean(this.selfPlayer))
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
            if(Boolean(this.selfPlayer.parent))
            {
               this.selfPlayer.parent.removeChild(this.selfPlayer);
            }
            this.selfPlayer.dispose();
         }
         this.selfPlayer = null;
         if(Boolean(this._currentLoadingPlayer))
         {
            if(Boolean(this._currentLoadingPlayer.parent))
            {
               this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
            }
            this._currentLoadingPlayer.dispose();
         }
         this._currentLoadingPlayer = null;
         if(Boolean(this._mouseMovie) && Boolean(this._mouseMovie.parent))
         {
            this._mouseMovie.parent.removeChild(this._mouseMovie);
         }
         this._mouseMovie = null;
         if(Boolean(this.meshLayer) && Boolean(this.meshLayer.parent))
         {
            this.meshLayer.parent.removeChild(this.meshLayer);
         }
         this.meshLayer = null;
         if(Boolean(this.bgLayer) && Boolean(this.bgLayer.parent))
         {
            this.bgLayer.parent.removeChild(this.bgLayer);
         }
         this.bgLayer = null;
         if(Boolean(this.skyLayer) && Boolean(this.skyLayer.parent))
         {
            this.skyLayer.parent.removeChild(this.skyLayer);
         }
         this.skyLayer = null;
         this.sceneScene = null;
         this.disposeBeforeTimeView();
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

