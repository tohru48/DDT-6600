package church.view.churchScene
{
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.player.ChurchPlayer;
   import church.view.churchFire.ChurchFireEffectPlayer;
   import church.vo.PlayerVO;
   import church.vo.SceneMapVO;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class SceneMap extends Sprite
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
      
      protected var _selfPlayer:ChurchPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:ChurchPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:ChurchRoomModel;
      
      protected var reference:ChurchPlayer;
      
      public function SceneMap(model:ChurchRoomModel, sceneScene:SceneScene, data:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite = null, sky:Sprite = null)
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
         this.skyLayer = sky == null ? new Sprite() : sky;
         this.addChild(this.meshLayer);
         this.addChild(this.bgLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
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
         var mvClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.church.room.MouseClickMovie") as Class;
         this._mouseMovie = new mvClass() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         this._model.addEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
      }
      
      private function menuChange(evt:WeddingRoomEvent) : void
      {
         switch(evt.type)
         {
            case WeddingRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
               break;
            case WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE:
               this.chatBallVisible();
               break;
            case WeddingRoomEvent.PLAYER_FIRE_VISIBLE:
               this.fireVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var churchPlayer:ChurchPlayer = null;
         for each(churchPlayer in this._characters)
         {
            churchPlayer.isShowName = this._model.playerNameVisible;
         }
      }
      
      public function chatBallVisible() : void
      {
         var churchPlayer:ChurchPlayer = null;
         for each(churchPlayer in this._characters)
         {
            churchPlayer.isChatBall = this._model.playerChatBallVisible;
         }
      }
      
      public function fireVisible() : void
      {
      }
      
      protected function updateMap(event:Event) : void
      {
         var player:ChurchPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(player in this._characters)
         {
            player.updatePlayer();
            player.isChatBall = this._model.playerChatBallVisible;
            player.isShowName = this._model.playerNameVisible;
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(event:MouseEvent) : void
      {
         var targetPoint:Point = null;
         if(!this._selfPlayer)
         {
            return;
         }
         targetPoint = this.globalToLocal(new Point(event.stageX,event.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(targetPoint))
            {
               this._selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this._selfPlayer.playerPoint,targetPoint);
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
         SocketManager.Instance.out.sendChurchMove(p[p.length - 1].x,p[p.length - 1].y,pathStr);
      }
      
      public function useFire(playerID:int, fireTemplateID:int) : void
      {
         var churchFireEffectPlayer:ChurchFireEffectPlayer = null;
         if(this._characters[playerID] == null)
         {
            return;
         }
         if(Boolean(this._characters[playerID]))
         {
            if(playerID == PlayerManager.Instance.Self.ID)
            {
               this._model.fireEnable = false;
               if(!this._model.playerFireVisible)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.SceneMap.lihua"));
               }
            }
            churchFireEffectPlayer = new ChurchFireEffectPlayer(fireTemplateID);
            churchFireEffectPlayer.addEventListener(Event.COMPLETE,this.fireCompleteHandler);
            churchFireEffectPlayer.owerID = playerID;
            if(this._model.playerFireVisible)
            {
               churchFireEffectPlayer.x = (this._characters[playerID] as ChurchPlayer).x;
               churchFireEffectPlayer.y = (this._characters[playerID] as ChurchPlayer).y - 190;
               addChild(churchFireEffectPlayer);
            }
            churchFireEffectPlayer.firePlayer();
         }
      }
      
      protected function fireCompleteHandler(e:Event) : void
      {
         var fire:ChurchFireEffectPlayer = e.currentTarget as ChurchFireEffectPlayer;
         fire.removeEventListener(Event.COMPLETE,this.fireCompleteHandler);
         if(fire.owerID == PlayerManager.Instance.Self.ID)
         {
            this._model.fireEnable = true;
         }
         if(Boolean(fire.parent))
         {
            fire.parent.removeChild(fire);
         }
         fire.dispose();
         fire = null;
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         var churchPlayer:ChurchPlayer = null;
         if(Boolean(this._characters[id]))
         {
            churchPlayer = this._characters[id] as ChurchPlayer;
            churchPlayer.playerVO.walkPath = p;
            churchPlayer.playerWalk(p);
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
      
      public function addSelfPlayer() : void
      {
         var selfPlayerVO:PlayerVO = null;
         if(!this._selfPlayer)
         {
            selfPlayerVO = new PlayerVO();
            selfPlayerVO.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ChurchPlayer(selfPlayerVO,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(churchPlayer:ChurchPlayer) : void
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
      
      protected function __addPlayer(event:DictionaryEvent) : void
      {
         var playerVO:PlayerVO = event.data as PlayerVO;
         this._currentLoadingPlayer = new ChurchPlayer(playerVO,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(churchPlayer:ChurchPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!this.articleLayer || !churchPlayer)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            churchPlayer.sceneScene = this.sceneScene;
            churchPlayer.setSceneCharacterDirectionDefault = churchPlayer.sceneCharacterDirection = churchPlayer.playerVO.scenePlayerDirection;
            if(!this._selfPlayer && churchPlayer.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               churchPlayer.playerVO.playerPos = this._sceneMapVO.defaultPos;
               this._selfPlayer = churchPlayer;
               this.articleLayer.addChild(this._selfPlayer);
               this.ajustScreen(this._selfPlayer);
               this.setCenter();
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this.articleLayer.addChild(churchPlayer);
            }
            churchPlayer.playerPoint = churchPlayer.playerVO.playerPos;
            churchPlayer.sceneCharacterStateType = "natural";
            this._characters.add(churchPlayer.playerVO.playerInfo.ID,churchPlayer);
            churchPlayer.isShowName = this._model.playerNameVisible;
            churchPlayer.isChatBall = this._model.playerChatBallVisible;
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
         var player:ChurchPlayer = this._characters[id] as ChurchPlayer;
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
      
      public function setSalute(id:int) : void
      {
      }
      
      protected function removeEvent() : void
      {
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
      }
      
      public function dispose() : void
      {
         var p:ChurchPlayer = null;
         var i:int = 0;
         var player:ChurchPlayer = null;
         this.removeEvent();
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
               player = this.articleLayer.getChildAt(i - 1) as ChurchPlayer;
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
         this.sceneScene = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

