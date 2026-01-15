package consortionBattle.view
{
   import church.view.churchScene.MoonSceneMap;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import consortionBattle.player.ConsortiaBattlePlayer;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import hall.event.NewHallEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class ConsortiaBattleMapView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [3208,2000];
      
      protected var _mapClassDefinition:String;
      
      protected var _playerModel:DictionaryData;
      
      protected var _bgLayer:Sprite;
      
      protected var _articleLayer:Sprite;
      
      protected var _decorationLayer:Sprite;
      
      protected var _meshLayer:Sprite;
      
      protected var _sceneScene:SceneScene;
      
      protected var _selfPlayer:ConsortiaBattlePlayer;
      
      protected var _lastClick:Number = 0;
      
      protected var _clickInterval:Number = 200;
      
      protected var _mouseMovie:MovieClip;
      
      protected var _characters:DictionaryData;
      
      protected var _clickEnemy:ConsortiaBattlePlayer;
      
      protected var _judgeCreateCount:int = 0;
      
      public function ConsortiaBattleMapView(mapClassDefinition:String, playerModel:DictionaryData)
      {
         super();
         this._mapClassDefinition = mapClassDefinition;
         this._playerModel = playerModel;
         this.initData();
         this.initMap();
         this.initMouseMovie();
         this.initSceneScene();
         this.initEvent();
         this.initBeforeTimeView();
      }
      
      private function initBeforeTimeView() : void
      {
         var beforeTimeView:ConsBatBeforeTimer = null;
         var tmpTime:int = ConsortiaBattleManager.instance.beforeStartTime;
         if(tmpTime > 0)
         {
            beforeTimeView = new ConsBatBeforeTimer(tmpTime);
            LayerManager.Instance.addToLayer(beforeTimeView,LayerManager.GAME_DYNAMIC_LAYER,true);
         }
      }
      
      protected function initData() : void
      {
         this._characters = new DictionaryData(true);
      }
      
      protected function initMap() : void
      {
         var mesh:Sprite = null;
         var bgSize:Sprite = null;
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this._mapClassDefinition) as Class)() as MovieClip;
         var acticle:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         mesh = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         bgSize = mapRes.getChildByName("bgSize") as Sprite;
         var decoration:Sprite = mapRes.getChildByName("decoration") as Sprite;
         this._bgLayer = bg == null ? new Sprite() : bg;
         this._articleLayer = acticle == null ? new Sprite() : acticle;
         this._decorationLayer = decoration == null ? new Sprite() : decoration;
         this._decorationLayer.mouseEnabled = false;
         this._decorationLayer.mouseChildren = false;
         this._meshLayer = mesh == null ? new Sprite() : mesh;
         this._meshLayer.alpha = 0;
         this._meshLayer.mouseChildren = false;
         this._meshLayer.mouseEnabled = false;
         this.addChild(this._bgLayer);
         this.addChild(this._articleLayer);
         this.addChild(this._decorationLayer);
         this.addChild(this._meshLayer);
         if(Boolean(bgSize))
         {
            MAP_SIZE[0] = bgSize.width;
            MAP_SIZE[1] = bgSize.height;
         }
         else
         {
            MAP_SIZE[0] = bg.width;
            MAP_SIZE[1] = bg.height;
         }
      }
      
      protected function initMouseMovie() : void
      {
         var mvClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.consortiaBattle.MouseClickMovie") as Class;
         this._mouseMovie = new mvClass() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._bgLayer.addChild(this._mouseMovie);
      }
      
      protected function initSceneScene() : void
      {
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._playerModel.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._playerModel.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._playerModel.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayerStatus);
         addEventListener(ConsortiaBattlePlayer.CLICK,this.playerClickHandler);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.MOVE_PLAYER,this.movePlayer);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.HIDE_RECORD_CHANGE,this.hidePlayer);
         PlayerManager.Instance.addEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      protected function __onSetSelfPlayerPos(event:NewHallEvent) : void
      {
         this.__click(event.data[0]);
      }
      
      private function hidePlayer(event:Event) : void
      {
         var tmp:ConsortiaBattlePlayer = null;
         for each(tmp in this._characters)
         {
            tmp.visible = ConsortiaBattleManager.instance.judgePlayerVisible(tmp);
         }
      }
      
      private function playerClickHandler(event:Event) : void
      {
         this._clickEnemy = event.target as ConsortiaBattlePlayer;
      }
      
      protected function __addPlayer(event:DictionaryEvent) : void
      {
         var player:ConsortiaBattlePlayerInfo = event.data as ConsortiaBattlePlayerInfo;
         var loadingPlayer:ConsortiaBattlePlayer = new ConsortiaBattlePlayer(player,this.addPlayerCallBack);
      }
      
      protected function addPlayerCallBack(scencPlayer:ConsortiaBattlePlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!this._articleLayer || !scencPlayer)
            {
               return;
            }
            scencPlayer.playerPoint = scencPlayer.playerData.pos;
            scencPlayer.sceneCharacterStateType = "natural";
            scencPlayer.setSceneCharacterDirectionDefault = scencPlayer.sceneCharacterDirection = SceneCharacterDirection.RB;
            if(!this._selfPlayer && scencPlayer.playerData.id == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer = scencPlayer;
               this._articleLayer.addChild(this._selfPlayer);
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this._selfPlayer.mouseEnabled = this._selfPlayer.mouseChildren = false;
               this.setCenter(null,false);
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
               SocketManager.Instance.out.sendConsBatRequestPlayerInfo();
               SocketManager.Instance.out.sendConsBatConfirmEnter();
            }
            else
            {
               this._articleLayer.addChild(scencPlayer);
               scencPlayer.mouseEnabled = false;
            }
            this._characters.add(scencPlayer.playerData.id,scencPlayer);
         }
      }
      
      protected function __removePlayer(event:DictionaryEvent) : void
      {
         var id:int = (event.data as ConsortiaBattlePlayerInfo).id;
         var player:ConsortiaBattlePlayer = this._characters[id] as ConsortiaBattlePlayer;
         this._characters.remove(id);
         if(player == this._clickEnemy)
         {
            this._clickEnemy = null;
         }
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
      
      protected function __updatePlayerStatus(event:DictionaryEvent) : void
      {
         var player:ConsortiaBattlePlayer = null;
         var id:int = (event.data as ConsortiaBattlePlayerInfo).id;
         if(Boolean(this._characters[id]))
         {
            player = this._characters[id] as ConsortiaBattlePlayer;
            player.refreshStatus();
         }
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            if(Boolean(this._mouseMovie))
            {
               this._mouseMovie.gotoAndStop(1);
            }
         }
      }
      
      public function setCenter(event:SceneCharacterEvent = null, isReturn:Boolean = true, pos:Point = null) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         var tmpPos:Point = null;
         if(!this._selfPlayer && !pos || isReturn && ConsortiaBattleManager.instance.beforeStartTime > 0)
         {
            return;
         }
         if(Boolean(this._selfPlayer))
         {
            tmpPos = this._selfPlayer.playerPoint;
         }
         else
         {
            tmpPos = pos;
         }
         xf = -(tmpPos.x - MoonSceneMap.GAME_WIDTH / 2);
         yf = -(tmpPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < MoonSceneMap.GAME_WIDTH - MAP_SIZE[0])
         {
            xf = MoonSceneMap.GAME_WIDTH - MAP_SIZE[0];
         }
         if(yf > 0)
         {
            yf = 0;
         }
         if(yf < MoonSceneMap.GAME_HEIGHT - MAP_SIZE[1])
         {
            yf = MoonSceneMap.GAME_HEIGHT - MAP_SIZE[1];
         }
         x = xf;
         y = yf;
      }
      
      protected function __click(event:MouseEvent) : void
      {
         if(!this._selfPlayer || !this._selfPlayer.isCanWalk)
         {
            return;
         }
         var targetPoint:Point = this.globalToLocal(new Point(event.stageX,event.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this._sceneScene.hit(targetPoint))
            {
               this._selfPlayer.playerData.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,targetPoint);
               this._selfPlayer.playerData.walkPath.shift();
               this._selfPlayer.playerData.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this._selfPlayer.playerData.walkPath.concat());
               this._mouseMovie.x = targetPoint.x;
               this._mouseMovie.y = targetPoint.y;
               this._mouseMovie.play();
            }
         }
      }
      
      protected function sendMyPosition(p:Array) : void
      {
         var i:uint = 0;
         for(var arr:Array = []; i < p.length; )
         {
            arr.push(int(p[i].x),int(p[i].y));
            i++;
         }
         var pathStr:String = arr.toString();
         SocketManager.Instance.out.sendConsBatMove(p[p.length - 1].x,p[p.length - 1].y,pathStr);
      }
      
      protected function movePlayer(event:ConsBatEvent) : void
      {
         var tmpPlayer:ConsortiaBattlePlayer = null;
         var id:int = int(event.data.id);
         var p:Array = event.data.path;
         if(Boolean(this._characters[id]))
         {
            tmpPlayer = this._characters[id] as ConsortiaBattlePlayer;
            tmpPlayer.playerData.walkPath = p;
            tmpPlayer.isWalkPathChange = true;
            tmpPlayer.playerWalk(p);
         }
      }
      
      protected function updateMap(event:Event) : void
      {
         var player:ConsortiaBattlePlayer = null;
         ++this._judgeCreateCount;
         if(this._judgeCreateCount > 25)
         {
            ConsortiaBattleManager.instance.judgeCreatePlayer(this.x,this.y);
            this._judgeCreateCount = 0;
         }
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(player in this._characters)
         {
            player.updatePlayer();
         }
         this.BuildEntityDepth();
         this.judgeEnemy();
      }
      
      protected function judgeEnemy() : void
      {
         if(!this._clickEnemy || !this._selfPlayer)
         {
            return;
         }
         if(Point.distance(new Point(this._selfPlayer.x,this._selfPlayer.y),new Point(this._clickEnemy.x,this._clickEnemy.y)) < 100)
         {
            SocketManager.Instance.out.sendConsBatChallenge(this._clickEnemy.playerData.id);
            this._clickEnemy = null;
         }
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
         var count:int = this._articleLayer.numChildren;
         for(var i:int = 0; i < count - 1; i++)
         {
            obj = this._articleLayer.getChildAt(i);
            depth = this.getPointDepth(obj.x,obj.y);
            minDepth = Number.MAX_VALUE;
            for(j = i + 1; j < count; j++)
            {
               temp = this._articleLayer.getChildAt(j);
               tempDepth = this.getPointDepth(temp.x,temp.y);
               if(tempDepth < minDepth)
               {
                  minIndex = j;
                  minDepth = tempDepth;
               }
            }
            if(depth > minDepth)
            {
               this._articleLayer.swapChildrenAt(i,minIndex);
            }
         }
      }
      
      protected function getPointDepth(x:Number, y:Number) : Number
      {
         return MAP_SIZE[0] * y + x;
      }
      
      public function addSelfPlayer() : void
      {
         var tmpSelfData:ConsortiaBattlePlayerInfo = null;
         var tmp:ConsortiaBattlePlayer = null;
         if(!this._selfPlayer)
         {
            tmpSelfData = ConsortiaBattleManager.instance.getPlayerInfo(PlayerManager.Instance.Self.ID);
            tmp = new ConsortiaBattlePlayer(tmpSelfData,this.addPlayerCallBack);
            this.setCenter(null,false,tmpSelfData.pos);
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         }
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         }
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayerStatus);
         }
         removeEventListener(ConsortiaBattlePlayer.CLICK,this.playerClickHandler);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.MOVE_PLAYER,this.movePlayer);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.HIDE_RECORD_CHANGE,this.hidePlayer);
         PlayerManager.Instance.removeEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._playerModel = null;
         if(Boolean(this._mouseMovie))
         {
            this._mouseMovie.gotoAndStop(1);
         }
         ObjectUtils.disposeAllChildren(this._articleLayer);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._sceneScene))
         {
            this._sceneScene.dispose();
         }
         this._bgLayer = null;
         this._articleLayer = null;
         this._decorationLayer = null;
         this._meshLayer = null;
         this._sceneScene = null;
         this._selfPlayer = null;
         this._clickEnemy = null;
         this._mouseMovie = null;
         this._characters = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

