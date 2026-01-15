package christmas.view.playingSnowman
{
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.MonsterInfo;
   import christmas.manager.ChristmasManager;
   import christmas.manager.ChristmasMonsterManager;
   import christmas.model.ChristmasRoomModel;
   import christmas.player.ChristmasMonster;
   import christmas.player.ChristmasRoomPlayer;
   import christmas.player.PlayerVO;
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class ChristmasScneneMap extends Sprite implements Disposeable
   {
      
      private static var selectSpeek:int = 1;
      
      public static var packsNum:int = 2;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      protected var snowLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      public var selfPlayer:ChristmasRoomPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _currentLoadingPlayer:ChristmasRoomPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:ChristmasRoomModel;
      
      private var armyPos:Point;
      
      private var decorationLayer:Sprite;
      
      protected var _mapObjs:DictionaryData;
      
      protected var _monsters:DictionaryData;
      
      private var _snowMC:MovieClip;
      
      private var _snowCenterMc:MovieClip;
      
      private var _snowSpeakPng:Bitmap;
      
      private var _snowSpeak:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _mouseMovie:MovieClip;
      
      private var r:int = 250;
      
      private var auto:Point;
      
      private var autoMove:Boolean = false;
      
      private var _entering:Boolean = false;
      
      private var _speakTimer:Timer;
      
      private var _timeFive:Timer;
      
      private var endPoint:Point = new Point();
      
      protected var reference:ChristmasRoomPlayer;
      
      public function ChristmasScneneMap(model:ChristmasRoomModel, sceneScene:SceneScene, data:DictionaryData, objData:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite = null, sky:Sprite = null, decoration:Sprite = null, snow:Sprite = null)
      {
         super();
         this._model = model;
         this.sceneScene = sceneScene;
         this._data = data;
         this._mapObjs = objData;
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
         this.snowLayer = snow == null ? new Sprite() : snow;
         this.decorationLayer.mouseEnabled = false;
         this.decorationLayer.mouseChildren = false;
         this.addChild(this.bgLayer);
         this.addChild(this.snowLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.decorationLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
         this.initSnow();
      }
      
      private function initSnow() : void
      {
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this._snowCenterMc = this.snowLayer.getChildByName("snowCenter_MC") as MovieClip;
            this._snowCenterMc.visible = false;
            this._snowCenterMc.buttonMode = false;
            this._snowCenterMc.mouseEnabled = false;
            this._snowCenterMc.mouseChildren = false;
            this._snowCenterMc.gotoAndStop(1);
            this._snowMC = this.skyLayer.getChildByName("snow_mc") as MovieClip;
            this._snowMC.addEventListener(MouseEvent.CLICK,this._enterSnowNPC);
            this._snowMC.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
            this._snowMC.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
            this._snowMC.buttonMode = true;
         }
      }
      
      private function __onMouseOver(e:MouseEvent) : void
      {
         this._snowCenterMc.visible = true;
         this._snowCenterMc.gotoAndPlay(1);
      }
      
      private function __onMouseOut(e:MouseEvent) : void
      {
         this._snowCenterMc.visible = false;
         this._snowCenterMc.gotoAndStop(1);
      }
      
      private function _enterSnowNPC(e:MouseEvent) : void
      {
         SocketManager.Instance.out.getPacksToPlayer(0);
      }
      
      private function isPacksComplete(num:int = 1) : void
      {
         SocketManager.Instance.out.getPacksToPlayer(1);
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
         this._monsters = new DictionaryData(true);
         var mvClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.christmas.room.MouseClickMovie") as Class;
         this._mouseMovie = new mvClass() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this._snowSpeakPng = ComponentFactory.Instance.creatBitmap("asset.christmas.room.snowSpeakImg");
         this._snowSpeakPng.visible = false;
         this._snowSpeak = ComponentFactory.Instance.creatComponentByStylename("christmas.room.snowSpeakTxt");
         this._snowSpeak.visible = false;
         addChild(this._snowSpeakPng);
         addChild(this._snowSpeak);
         this.last_click = 0;
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this.armyPos = new Point(this.bgLayer.getChildByName("armyPos").x,this.bgLayer.getChildByName("armyPos").y);
         }
         this._speakTimer = new Timer(300000,0);
         this._speakTimer.addEventListener(TimerEvent.TIMER,this.__santaSpeakTimer);
         this._speakTimer.start();
      }
      
      private function __santaSpeakTimer(e:TimerEvent) : void
      {
         this._timeFive = new Timer(1000,5);
         this._timeFive.addEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
         this._timeFive.addEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         this._timeFive.start();
      }
      
      private function __santaSpeakFiveSeconds(e:TimerEvent) : void
      {
         if(selectSpeek % 2 == 0)
         {
            this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.santaSpeakFiveSecondsText");
         }
         else
         {
            this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.santaSpeakFiveSecondsText2");
         }
         this._snowSpeakPng.visible = true;
         this._snowSpeak.visible = true;
         ++selectSpeek;
      }
      
      public function stopAllTimer() : void
      {
         if(Boolean(this._timeFive))
         {
            this._timeFive.stop();
            this._timeFive.removeEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
            this._timeFive.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         }
         if(Boolean(this._speakTimer))
         {
            this._speakTimer.stop();
            this._speakTimer.removeEventListener(TimerEvent.TIMER,this.__santaSpeakTimer);
         }
      }
      
      private function __santaSpeakFiveSecondsComplete(e:TimerEvent) : void
      {
         (e.target as Timer).removeEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
         (e.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         (e.target as Timer).stop();
         this._snowSpeakPng.visible = false;
         this._snowSpeak.visible = false;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(ChristmasRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(ChristmasRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._mapObjs.addEventListener(DictionaryEvent.ADD,this.__addMonster);
         this._mapObjs.addEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
         this._mapObjs.addEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,this.__getPacks);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,this.__snowSpeak);
      }
      
      private function __getPacks(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var packsCount:Boolean = pkg.readBoolean();
         var indexPacks:int = pkg.readInt();
         var totalCount:int = pkg.readInt();
         var count:int = pkg.readInt();
         var poorCount:int = totalCount - count;
         if(indexPacks >= 2)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.full"),null,null,this,false);
            return;
         }
         var serTime:Number = ChristmasManager.instance.model.serverTime();
         if(serTime < 14)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.unfinished2",packsNum < 0 ? 0 : packsNum),null,null,this,false);
            return;
         }
         if(count < totalCount && packsCount && serTime >= 14)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.unfinished",packsNum < 0 ? 0 : packsNum),null,null,this,false);
            return;
         }
         if(!packsCount)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.room.packs.isFull"),null,null,this,false);
            return;
         }
         if(count >= totalCount && packsCount && serTime >= 14)
         {
            --packsNum;
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.complete",poorCount.toString()),this.isPacksComplete,null,this,false);
            return;
         }
      }
      
      private function __addMonster(pEvent:DictionaryEvent) : void
      {
         var monster:MonsterInfo = pEvent.data as MonsterInfo;
         var cMonster:ChristmasMonster = new ChristmasMonster(monster,monster.MonsterPos);
         this._monsters.add(monster.ID,cMonster);
         this.articleLayer.addChild(cMonster);
      }
      
      private function __removeMonster(pEvent:DictionaryEvent) : void
      {
         var monsterInfo:MonsterInfo = pEvent.data as MonsterInfo;
         var monster:ChristmasMonster = this._monsters[monsterInfo.ID] as ChristmasMonster;
         this._monsters.remove(monsterInfo.ID);
         monster.dispose();
      }
      
      private function __onMonsterUpdate(pEvent:DictionaryEvent) : void
      {
         var monsterInfo:MonsterInfo = pEvent.data as MonsterInfo;
         var monster:ChristmasMonster = this._monsters[monsterInfo.ID] as ChristmasMonster;
      }
      
      private function __snowSpeak(event:CrazyTankSocketEvent) : void
      {
         this._timer = new Timer(1000,10);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timeShowSnowSpeak);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeSnowSpeakComplete);
         this._timer.start();
      }
      
      private function __timeShowSnowSpeak(event:TimerEvent) : void
      {
         this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.snowSpeakText");
         this._snowSpeakPng.visible = true;
         this._snowSpeak.visible = true;
      }
      
      private function __timeSnowSpeakComplete(event:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timeShowSnowSpeak);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeSnowSpeakComplete);
         this._timer.stop();
         this._snowSpeakPng.visible = false;
         this._snowSpeak.visible = false;
      }
      
      private function menuChange(evt:ChristmasRoomEvent) : void
      {
         switch(evt.type)
         {
            case ChristmasRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var christmasRoomPlayer:ChristmasRoomPlayer = null;
         for each(christmasRoomPlayer in this._characters)
         {
            christmasRoomPlayer.isShowName = this._model.playerNameVisible;
         }
      }
      
      protected function updateMap(event:Event) : void
      {
         var player:ChristmasRoomPlayer = null;
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
         if(!this.selfPlayer || this.selfPlayer.playerVO.playerStauts != 0 || !this.selfPlayer.getCanAction())
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
         SocketManager.Instance.out.sendChristmasRoomMove(p[p.length - 1].x,p[p.length - 1].y,pathStr);
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         var christmasRoomPlayer:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            christmasRoomPlayer = this._characters[id] as ChristmasRoomPlayer;
            if(!christmasRoomPlayer.getCanAction())
            {
               christmasRoomPlayer.playerVO.playerStauts = 0;
               christmasRoomPlayer.setStatus();
            }
            christmasRoomPlayer.playerVO.walkPath = p;
            christmasRoomPlayer.playerWalk(p);
         }
      }
      
      public function updatePlayersStauts(id:int, stauts:int, point:Point) : void
      {
         var christmasRoomPlayer:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            christmasRoomPlayer = this._characters[id] as ChristmasRoomPlayer;
            if(stauts == 0)
            {
               christmasRoomPlayer.playerVO.playerStauts = stauts;
               christmasRoomPlayer.playerVO.playerPos = point;
               christmasRoomPlayer.setStatus();
            }
            else if(stauts == 1)
            {
               if(!christmasRoomPlayer.getCanAction())
               {
                  christmasRoomPlayer.playerVO.playerStauts = 0;
                  christmasRoomPlayer.setStatus();
               }
               christmasRoomPlayer.playerVO.playerStauts = stauts;
               christmasRoomPlayer.isReadyFight = true;
               christmasRoomPlayer.addEventListener(ChristmasRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
               christmasRoomPlayer.playerVO.walkPath = [point];
               christmasRoomPlayer.playerWalk([point]);
            }
            else
            {
               christmasRoomPlayer.playerVO.playerStauts = stauts;
               christmasRoomPlayer.setStatus();
            }
         }
      }
      
      public function __otherPlayrStartFight(evt:ChristmasRoomEvent) : void
      {
         var christmasRoomPlayer:ChristmasRoomPlayer = evt.currentTarget as ChristmasRoomPlayer;
         christmasRoomPlayer.removeEventListener(ChristmasRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
         christmasRoomPlayer.sceneCharacterDirection = SceneCharacterDirection.getDirection(christmasRoomPlayer.playerPoint,this.armyPos);
         christmasRoomPlayer.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         christmasRoomPlayer.isReadyFight = false;
         christmasRoomPlayer.setStatus();
      }
      
      public function updateSelfStatus(value:int) : void
      {
         if(Boolean(this.selfPlayer))
         {
            if(this.selfPlayer.playerVO.playerStauts == 2)
            {
               this.selfPlayer.playerVO.playerPos = ChristmasManager.instance.christmasInfo.playerDefaultPos;
               this.ajustScreen(this.selfPlayer);
               this.setCenter();
               this._entering = false;
            }
            this.selfPlayer.playerVO.playerStauts = value;
            this.selfPlayer.setStatus();
         }
      }
      
      public function checkSelfStatus() : int
      {
         return this.selfPlayer.playerVO.playerStauts;
      }
      
      public function playerRevive(id:int) : void
      {
         var christmasRoomPlayer:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[id]))
         {
            christmasRoomPlayer = this._characters[id] as ChristmasRoomPlayer;
            christmasRoomPlayer.revive();
            this.selfPlayer.playerVO.playerStauts = 0;
            this._entering = false;
         }
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
            xf = -(ChristmasManager.instance.christmasInfo.playerDefaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            yf = -(ChristmasManager.instance.christmasInfo.playerDefaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
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
      }
      
      public function addSelfPlayer() : void
      {
         var selfPlayerVO:PlayerVO = null;
         if(!this.selfPlayer)
         {
            selfPlayerVO = ChristmasManager.instance.christmasInfo.myPlayerVO;
            selfPlayerVO.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ChristmasRoomPlayer(selfPlayerVO,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(christmasRoomPlayer:ChristmasRoomPlayer) : void
      {
         if(christmasRoomPlayer == null)
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
         this.reference = christmasRoomPlayer;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(event:DictionaryEvent) : void
      {
         var playerVO:PlayerVO = event.data as PlayerVO;
         this._currentLoadingPlayer = new ChristmasRoomPlayer(playerVO,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(christmasRoomPlayer:ChristmasRoomPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!this.articleLayer || !christmasRoomPlayer)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            christmasRoomPlayer.sceneScene = this.sceneScene;
            christmasRoomPlayer.setSceneCharacterDirectionDefault = christmasRoomPlayer.sceneCharacterDirection = christmasRoomPlayer.playerVO.scenePlayerDirection;
            if(!this.selfPlayer && christmasRoomPlayer.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               christmasRoomPlayer.playerVO.playerPos = christmasRoomPlayer.playerVO.playerPos;
               this.selfPlayer = christmasRoomPlayer;
               this.articleLayer.addChild(this.selfPlayer);
               this.ajustScreen(this.selfPlayer);
               this.setCenter();
               this.selfPlayer.setStatus();
               this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this.articleLayer.addChild(christmasRoomPlayer);
            }
            christmasRoomPlayer.playerPoint = christmasRoomPlayer.playerVO.playerPos;
            christmasRoomPlayer.sceneCharacterStateType = "natural";
            this._characters.add(christmasRoomPlayer.playerVO.playerInfo.ID,christmasRoomPlayer);
            christmasRoomPlayer.isShowName = this._model.playerNameVisible;
         }
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var mon:ChristmasMonster = null;
         var pos:Point = null;
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
            mon = ChristmasMonsterManager.Instance.curMonster;
            if(Boolean(mon) && mon.MonsterState <= MonsterInfo.LIVIN)
            {
               pos = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x,this.selfPlayer.playerPoint.y + 50));
               if(mon.hitTestPoint(pos.x,pos.y) || mon.hitTestObject(this.selfPlayer))
               {
                  mon.StartFight();
               }
            }
         }
      }
      
      protected function __removePlayer(event:DictionaryEvent) : void
      {
         var id:int = (event.data as PlayerVO).playerInfo.ID;
         var player:ChristmasRoomPlayer = this._characters[id] as ChristmasRoomPlayer;
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
         this._model.removeEventListener(ChristmasRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(ChristmasRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._mapObjs.removeEventListener(DictionaryEvent.ADD,this.__addMonster);
         this._mapObjs.removeEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
         this._mapObjs.removeEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(Boolean(this.selfPlayer))
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         this._snowMC.removeEventListener(MouseEvent.CLICK,this._enterSnowNPC);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,this.__getPacks);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,this.__snowSpeak);
      }
      
      public function dispose() : void
      {
         var p:ChristmasRoomPlayer = null;
         var o:ChristmasMonster = null;
         var i:int = 0;
         var player:ChristmasRoomPlayer = null;
         this.removeEvent();
         if(Boolean(this._mapObjs))
         {
            this._mapObjs.clear();
            this._mapObjs = null;
         }
         if(Boolean(this._data))
         {
            this._data.clear();
            this._data = null;
         }
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
               player = this.articleLayer.getChildAt(i - 1) as ChristmasRoomPlayer;
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
         for each(o in this._monsters)
         {
            o.dispose();
            o = null;
         }
         this._monsters.clear();
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
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

