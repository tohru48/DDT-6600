package collectionTask.view
{
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import collectionTask.CollectionTaskManager;
   import collectionTask.event.CollectionTaskEvent;
   import collectionTask.model.CollectionTaskModel;
   import collectionTask.player.CollectionTaskPlayer;
   import collectionTask.vo.CollectionRobertVo;
   import collectionTask.vo.PlayerVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
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
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CollectionTaskSceneMap extends Sprite implements Disposeable
   {
      
      private var _model:CollectionTaskModel;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      protected var animalLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      private var _sceneMapVO:SceneMapVO;
      
      public var _selfPlayer:CollectionTaskPlayer;
      
      private var _currentLoadingPlayer:CollectionTaskPlayer;
      
      private var _mouseMovie:MovieClip;
      
      protected var _characters:DictionaryData;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _players:DictionaryData;
      
      private var _red_tree:MovieClip;
      
      private var _green_tree:MovieClip;
      
      private var _yellow_tree:MovieClip;
      
      private var _bee_BoxUp:MovieClip;
      
      private var _bee_BoxDown:MovieClip;
      
      private var _movieClipId:int;
      
      private var _collectMovie:MovieClip;
      
      private var _movieClipPosVector:Vector.<Point>;
      
      private var _playCollectMovieFunc:Function;
      
      private var _stopCollectFunc:Function;
      
      private var _addRobertCount:int;
      
      private var _addRobertTimer:Timer;
      
      protected var reference:CollectionTaskPlayer;
      
      public function CollectionTaskSceneMap(model:CollectionTaskModel, scene:SceneScene, data:DictionaryData, bg:Sprite, mesh:Sprite, animal:Sprite = null, sky:Sprite = null, article:Sprite = null)
      {
         super();
         this._model = model;
         this.sceneScene = scene;
         this._players = data;
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
         this.animalLayer = animal == null ? new Sprite() : animal;
         this.articleLayer = article == null ? new Sprite() : article;
         this.skyLayer = sky == null ? new Sprite() : sky;
         addChild(this.bgLayer);
         addChild(this.animalLayer);
         addChild(this.meshLayer);
         addChild(this.skyLayer);
         addChild(this.articleLayer);
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._movieClipPosVector = new Vector.<Point>();
         this._movieClipPosVector.push(new Point(260,475),new Point(584,500),new Point(480,790),new Point(750,520),new Point(700,820));
         this._characters = new DictionaryData(true);
         this._mouseMovie = ComponentFactory.Instance.creat("asset.collectionTask.MouseClickMovie");
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this._red_tree = this.skyLayer.getChildByName("red_tree") as MovieClip;
         this._green_tree = this.skyLayer.getChildByName("green_tree") as MovieClip;
         this._yellow_tree = this.skyLayer.getChildByName("yellow_tree") as MovieClip;
         this._bee_BoxUp = this.skyLayer.getChildByName("bee_BoxUp") as MovieClip;
         this._bee_BoxDown = this.skyLayer.getChildByName("bee_BoxDown") as MovieClip;
         this._lastClick = 0;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._red_tree.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._green_tree.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._yellow_tree.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._bee_BoxUp.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._bee_BoxDown.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._players.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._players.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         CollectionTaskManager.Instance.addEventListener(CollectionTaskEvent.REMOVE_ROBERT,this.__removeRebortPlayer);
         this._model.addEventListener(CollectionTaskEvent.PLAYER_NAME_VISIBLE,this._menuChangeHandler);
         this._model.addEventListener(CollectionTaskEvent.PLAYER_CHATBALL_VISIBLE,this._menuChangeHandler);
         this._model.addEventListener(CollectionTaskEvent.PLAYER_VISIBLE,this._menuChangeHandler);
      }
      
      protected function _menuChangeHandler(event:CollectionTaskEvent) : void
      {
         switch(event.type)
         {
            case CollectionTaskEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
               break;
            case CollectionTaskEvent.PLAYER_CHATBALL_VISIBLE:
               this.chatBallVisible();
               break;
            case CollectionTaskEvent.PLAYER_VISIBLE:
               this.playerVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var player:CollectionTaskPlayer = null;
         for each(player in this._characters)
         {
            if(player.ID != this._selfPlayer.ID)
            {
               player.isShowName = this._model.playerNameVisible;
            }
         }
      }
      
      public function chatBallVisible() : void
      {
         var player:CollectionTaskPlayer = null;
         for each(player in this._characters)
         {
            if(player.ID != this._selfPlayer.ID)
            {
               player.isChatBall = this._model.playerChatBallVisible;
            }
         }
      }
      
      public function playerVisible() : void
      {
         var player:CollectionTaskPlayer = null;
         for each(player in this._characters)
         {
            if(player.ID != this._selfPlayer.ID)
            {
               player.isShowPlayer = this._model.playerVisible;
            }
         }
      }
      
      protected function __collectHandler(event:MouseEvent) : void
      {
         if(CollectionTaskManager.Instance.isTaskComplete || event.currentTarget == this._collectMovie && CollectionTaskManager.Instance.isCollecting)
         {
            return;
         }
         switch(event.currentTarget)
         {
            case this._red_tree:
               this._movieClipId = 3;
               CollectionTaskManager.Instance.collectedId = 11499;
               break;
            case this._green_tree:
               this._movieClipId = 1;
               CollectionTaskManager.Instance.collectedId = 11495;
               break;
            case this._yellow_tree:
               this._movieClipId = 2;
               CollectionTaskManager.Instance.collectedId = 11497;
               break;
            case this._bee_BoxUp:
               this._movieClipId = 4;
               CollectionTaskManager.Instance.collectedId = 11783;
               break;
            case this._bee_BoxDown:
               this._movieClipId = 5;
               CollectionTaskManager.Instance.collectedId = 11783;
         }
         this._collectMovie = event.currentTarget as MovieClip;
         var targetPoint:Point = this._movieClipPosVector[this._movieClipId - 1];
         this.checkPonitDistance(targetPoint);
      }
      
      public function checkPonitDistance(p:Point) : void
      {
         if(!this._selfPlayer)
         {
            return;
         }
         var fp:Point = this._selfPlayer.playerPoint;
         var dis:int = Math.abs(Point.distance(fp,p));
         if(dis > 50)
         {
            if(CollectionTaskManager.Instance.isCollecting)
            {
               this._stopCollectFunc();
            }
            this._mouseMovie.gotoAndStop(1);
            CollectionTaskManager.Instance.isClickCollection = true;
            this._selfPlayer.walk(p,this._playCollectMovieFunc);
            this.sendMyPosition(this._selfPlayer.playerVO.walkPath.concat());
         }
         else if(!CollectionTaskManager.Instance.isCollecting)
         {
            this._playCollectMovieFunc();
         }
      }
      
      public function setPlayProgressFunc(fun:Function = null) : void
      {
         this._playCollectMovieFunc = fun;
      }
      
      public function setStopProgressFunc(fun:Function = null) : void
      {
         this._stopCollectFunc = fun;
      }
      
      protected function __removeRebortPlayer(event:CollectionTaskEvent) : void
      {
         var key:String = event.robertNickName;
         var player:CollectionTaskPlayer = this._characters[key] as CollectionTaskPlayer;
         this._characters.remove(key);
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
      
      protected function __removePlayer(event:DictionaryEvent) : void
      {
         var info:PlayerInfo = (event.data as PlayerVO).playerInfo;
         var id:int = info.ID;
         var player:CollectionTaskPlayer = this._characters[id] as CollectionTaskPlayer;
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
      
      protected function __addPlayer(event:DictionaryEvent) : void
      {
         var playerVO:PlayerVO = event.data as PlayerVO;
         this._currentLoadingPlayer = new CollectionTaskPlayer(playerVO,this.addPlayerCallBack);
      }
      
      protected function __click(event:MouseEvent) : void
      {
         var playerTargetPoint:Point = null;
         if(!this._selfPlayer)
         {
            return;
         }
         var targetPoint:Point = this.globalToLocal(new Point(event.stageX,event.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(targetPoint))
            {
               if(CollectionTaskManager.Instance.isCollecting)
               {
                  this._stopCollectFunc();
               }
               CollectionTaskManager.Instance.isClickCollection = false;
               playerTargetPoint = new Point(targetPoint.x,targetPoint.y + 15);
               this._selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this._selfPlayer.playerPoint,playerTargetPoint);
               this._selfPlayer.playerVO.walkPath.shift();
               this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint,this._selfPlayer.playerVO.walkPath[0]);
               this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this._selfPlayer.playerVO.walkPath.concat());
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
         SocketManager.Instance.out.sendCollectionSceneMove(p[p.length - 1].x,p[p.length - 1].y,pathStr);
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         var player:CollectionTaskPlayer = null;
         if(Boolean(this._characters[id]))
         {
            player = this._characters[id] as CollectionTaskPlayer;
            player.playerVO.walkPath = p;
            player.playerWalk(p);
         }
      }
      
      protected function updateMap(event:Event) : void
      {
         var player:CollectionTaskPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(player in this._characters)
         {
            player.updatePlayer();
            if(player.playerVO.playerInfo.ID != this._selfPlayer.ID)
            {
               player.isChatBall = this._model.playerChatBallVisible;
               player.isShowName = this._model.playerNameVisible;
               player.isShowPlayer = this._model.playerVisible;
            }
         }
         this.BuildEntityDepth();
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
      
      public function addRobertPlayer(len:int) : void
      {
         this._addRobertCount = 10 - len;
         if(len < 10)
         {
            this._addRobertTimer = new Timer(5000,this._addRobertCount);
            this._addRobertTimer.addEventListener(TimerEvent.TIMER,this.__addRebortPlayerHandler);
            this._addRobertTimer.start();
         }
      }
      
      private function __addRebortPlayerHandler(event:TimerEvent) : void
      {
         if(this._characters.length >= 10 || this._addRobertCount == 0)
         {
            this._addRobertTimer.removeEventListener(TimerEvent.TIMER,this.__addRebortPlayerHandler);
            this._addRobertTimer.stop();
            this._addRobertTimer = null;
            return;
         }
         var robertInfo:CollectionRobertVo = CollectionTaskManager.Instance.collectionTaskInfoList[this._addRobertCount];
         var playerVO:PlayerVO = new PlayerVO();
         var info:PlayerInfo = new PlayerInfo();
         info.NickName = robertInfo.NickName;
         info.Sex = robertInfo.Sex == 0;
         info.Style = robertInfo.Style;
         playerVO.playerInfo = info;
         playerVO.playerPos = this.sceneMapVO.defaultPos;
         playerVO.isRobert = true;
         --this._addRobertCount;
         this._currentLoadingPlayer = new CollectionTaskPlayer(playerVO,this.addPlayerCallBack);
      }
      
      public function addSelfPlayer() : void
      {
         var selfPlayerVO:PlayerVO = null;
         if(!this._selfPlayer)
         {
            selfPlayerVO = new PlayerVO();
            selfPlayerVO.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new CollectionTaskPlayer(selfPlayerVO,this.addPlayerCallBack);
         }
      }
      
      private function addPlayerCallBack(player:CollectionTaskPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!this.articleLayer || !player)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            player.sceneScene = this.sceneScene;
            player.setSceneCharacterDirectionDefault = player.sceneCharacterDirection = player.playerVO.scenePlayerDirection;
            if(!this._selfPlayer && player.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               player.playerVO.playerPos = this._sceneMapVO.defaultPos;
               this._selfPlayer = player;
               this.articleLayer.addChild(this._selfPlayer);
               this.ajustScreen(this._selfPlayer);
               this.setCenter();
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this.articleLayer.addChild(player);
            }
            player.playerPoint = player.playerVO.playerPos;
            player.sceneCharacterStateType = "natural";
            if(!player.playerVO.isRobert)
            {
               this._characters.add(player.playerVO.playerInfo.ID,player);
            }
            else
            {
               this._characters.add(player.playerVO.playerInfo.NickName,player);
               player.robertWalk(this._movieClipPosVector);
            }
            player.isShowName = this._model.playerNameVisible;
            player.isChatBall = this._model.playerChatBallVisible;
            player.isShowPlayer = this._model.playerVisible;
         }
      }
      
      public function get characters() : DictionaryData
      {
         return this._characters;
      }
      
      public function set sceneMapVO(value:SceneMapVO) : void
      {
         this._sceneMapVO = value;
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
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
            xf = -(this._sceneMapVO.defaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            yf = -(this._sceneMapVO.defaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
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
      
      protected function ajustScreen(churchPlayer:CollectionTaskPlayer) : void
      {
         if(churchPlayer == null)
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
         this.reference = churchPlayer;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._red_tree.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._green_tree.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._yellow_tree.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._bee_BoxUp.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._bee_BoxDown.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._players.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._players.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         CollectionTaskManager.Instance.removeEventListener(CollectionTaskEvent.REMOVE_ROBERT,this.__removeRebortPlayer);
         this._model.removeEventListener(CollectionTaskEvent.PLAYER_NAME_VISIBLE,this._menuChangeHandler);
         this._model.removeEventListener(CollectionTaskEvent.PLAYER_CHATBALL_VISIBLE,this._menuChangeHandler);
         this._model.removeEventListener(CollectionTaskEvent.PLAYER_VISIBLE,this._menuChangeHandler);
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         var player:CollectionTaskPlayer = null;
         this.removeEvent();
         this._sceneMapVO = null;
         if(Boolean(this.articleLayer))
         {
            for(i = this.articleLayer.numChildren; i > 0; i--)
            {
               player = this.articleLayer.getChildAt(i - 1) as CollectionTaskPlayer;
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
         if(Boolean(this._selfPlayer))
         {
            if(Boolean(this._selfPlayer.parent))
            {
               this._selfPlayer.parent.removeChild(this._selfPlayer);
            }
            this._selfPlayer.dispose();
         }
         this._selfPlayer = null;
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
         if(Boolean(this.animalLayer) && Boolean(this.animalLayer.parent))
         {
            this.animalLayer.parent.removeChild(this.animalLayer);
         }
         this.animalLayer = null;
         this.sceneScene = null;
         ObjectUtils.disposeObject(this._collectMovie);
         this._collectMovie = null;
         ObjectUtils.disposeObject(this._red_tree);
         this._red_tree = null;
         ObjectUtils.disposeObject(this._green_tree);
         this._green_tree = null;
         ObjectUtils.disposeObject(this._yellow_tree);
         this._yellow_tree = null;
         ObjectUtils.disposeObject(this._bee_BoxDown);
         this._bee_BoxDown = null;
         ObjectUtils.disposeObject(this._bee_BoxUp);
         this._bee_BoxUp = null;
         if(Boolean(this._addRobertTimer))
         {
            this._addRobertTimer.removeEventListener(TimerEvent.TIMER,this.__addRebortPlayerHandler);
            this._addRobertTimer.stop();
            this._addRobertTimer = null;
         }
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

