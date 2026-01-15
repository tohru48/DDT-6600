package consortionBattle.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.view.ConsBatResurrectView;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import hall.player.HallPlayerBase;
   import hall.player.HallPlayerView;
   
   public class ConsortiaBattlePlayer extends HallPlayerBase implements Disposeable
   {
      
      public static const CLICK:String = "consBatPlayerClick";
      
      private var _playerData:ConsortiaBattlePlayerInfo;
      
      private var _swordIcon:MovieClip;
      
      private var _consortiaNameTxt:FilterFrameText;
      
      private var _tombstone:MovieClip;
      
      private var _fighting:MovieClip;
      
      private var _resurrectView:ConsBatResurrectView;
      
      private var _resurrectCartoon:MovieClip;
      
      private var _winningStreakMc:MovieClip;
      
      private var _character:Sprite;
      
      private var _currentWalkStartPoint:Point;
      
      private var _isJustWin:Boolean;
      
      private var _walkSpeed:Number;
      
      private var timeNum:int;
      
      public function ConsortiaBattlePlayer(playerData:ConsortiaBattlePlayerInfo, callBack:Function = null)
      {
         this._playerData = playerData;
         super(playerData,callBack);
         this._character = character;
         _petsDis = HallPlayerView.petsDisInfo.disDic[this._playerData.MountsType];
         this.initView();
         this.initEvent();
         this.setPlayerWalkSpeed();
      }
      
      private function setPlayerWalkSpeed() : void
      {
         if(this._playerData.MountsType > 0)
         {
            this._walkSpeed = 0.25;
         }
         else
         {
            this._walkSpeed = 0.15;
         }
      }
      
      protected function initView() : void
      {
         this._consortiaNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.consortiaNameTxt");
         this._consortiaNameTxt.text = this._playerData.consortiaName;
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            this._consortiaNameTxt.textColor = 65280;
         }
         else if(this._playerData.selfOrEnemy == 1)
         {
            this._consortiaNameTxt.textColor = 52479;
         }
         else
         {
            this._consortiaNameTxt.textColor = 16711680;
         }
         addChild(this._consortiaNameTxt);
         this._tombstone = ComponentFactory.Instance.creat("asset.consortiaBattle.tombstone");
         PositionUtils.setPos(this._tombstone,"consortiaBattle.tombstonePos");
         this._tombstone.gotoAndStop(1);
         this._tombstone.visible = false;
         addChild(this._tombstone);
         this._fighting = ComponentFactory.Instance.creat("asset.consortiaBattle.fighting");
         PositionUtils.setPos(this._fighting,"consortiaBattle.fightingPos");
         this._fighting.gotoAndStop(2);
         this._fighting.visible = false;
         addChild(this._fighting);
         this._winningStreakMc = ComponentFactory.Instance.creat("asset.consortiaBattle.winningStreak.iconMc");
         PositionUtils.setPos(this._winningStreakMc,"consortiaBattle.winningStreakMcPos");
         this._winningStreakMc.gotoAndStop(1);
         addChild(this._winningStreakMc);
         this.refreshStatus();
      }
      
      public function refreshStatus() : void
      {
         var time:Timer = null;
         var timeOffset:int = int((this._playerData.tombstoneEndTime.getTime() - TimeManager.Instance.Now().getTime()) / 1000);
         if(this.isInTomb && timeOffset <= 0)
         {
            this.resurrectHandler();
            return;
         }
         if(timeOffset > 0)
         {
            this._character.visible = false;
            setPetsVisible(false);
            this._fighting.gotoAndStop(2);
            this._fighting.visible = false;
            this._tombstone.visible = true;
            this._tombstone.gotoAndPlay(1);
            this.timeNum = timeOffset;
            time = new Timer(3000,1);
            time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
            time.start();
            this._consortiaNameTxt.y = -79;
         }
         else if(this._playerData.status == 2)
         {
            this._character.visible = true;
            setPetsVisible(true);
            this._fighting.gotoAndStop(1);
            this._fighting.visible = true;
            this._tombstone.visible = false;
            this._tombstone.gotoAndStop(1);
            this._consortiaNameTxt.y = -160;
            this._fighting.y = this._consortiaNameTxt.y - 25;
         }
         else
         {
            this._character.visible = true;
            setPetsVisible(true);
            this._fighting.gotoAndStop(2);
            if(this._fighting.visible)
            {
               this._isJustWin = true;
               setTimeout(this.canClickedFight,7000);
            }
            this._fighting.visible = false;
            this._tombstone.visible = false;
            this._tombstone.gotoAndStop(1);
            this._consortiaNameTxt.y = -playerHeight;
         }
         if(this._playerData.winningStreak >= 10)
         {
            this._winningStreakMc.gotoAndStop(4);
         }
         else if(this._playerData.winningStreak >= 6)
         {
            this._winningStreakMc.gotoAndStop(3);
         }
         else if(this._playerData.winningStreak >= 3)
         {
            this._winningStreakMc.gotoAndStop(2);
         }
         else if(this._playerData.failBuffCount > 0)
         {
            this._winningStreakMc.gotoAndStop(5);
         }
         else
         {
            this._winningStreakMc.gotoAndStop(1);
         }
         this._winningStreakMc.y = this._consortiaNameTxt.y - 25;
         if(this._winningStreakMc.currentFrame > 1 && this._fighting.visible)
         {
            this._fighting.y = this._consortiaNameTxt.y - 40;
         }
         this.visible = ConsortiaBattleManager.instance.judgePlayerVisible(this);
         if(Boolean(parent))
         {
            playerPoint = this._playerData.pos;
         }
      }
      
      private function __timeComplete(e:TimerEvent) : void
      {
         (e.target as Timer).stop();
         (e.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
         this.createRrsurrectView(this.timeNum);
      }
      
      private function canClickedFight() : void
      {
         this._isJustWin = false;
      }
      
      private function createRrsurrectView(total:int) : void
      {
         var tmp:Point = null;
         if(Boolean(this._resurrectView))
         {
            return;
         }
         if(this._playerData == null)
         {
            return;
         }
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            this._resurrectView = new ConsBatResurrectView(total);
            tmp = this.localToGlobal(new Point(-113,-121));
            this._resurrectView.x = tmp.x;
            this._resurrectView.y = tmp.y;
            LayerManager.Instance.addToLayer(this._resurrectView,LayerManager.GAME_DYNAMIC_LAYER);
         }
      }
      
      private function resurrectHandler() : void
      {
         if(Boolean(this._resurrectView))
         {
            ObjectUtils.disposeObject(this._resurrectView);
            this._resurrectView = null;
         }
         this._resurrectCartoon = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectCartoon");
         this._resurrectCartoon.addEventListener(Event.COMPLETE,this.cartoonCompleteHandler,false,0,true);
         this._resurrectCartoon.gotoAndPlay(1);
         addChild(this._resurrectCartoon);
      }
      
      private function cartoonCompleteHandler(event:Event) : void
      {
         if(Boolean(this._resurrectCartoon))
         {
            this._resurrectCartoon.removeEventListener(Event.COMPLETE,this.cartoonCompleteHandler);
            removeChild(this._resurrectCartoon);
            this._resurrectCartoon = null;
         }
         this._tombstone.visible = false;
         this.refreshStatus();
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_MOVEMENT));
         }
      }
      
      protected function initEvent() : void
      {
         playerHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         playerHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         playerHitArea.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      override protected function __onMouseClick(event:MouseEvent) : void
      {
         if(this.isCanBeFight)
         {
            if(this._isJustWin)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.justWinProtectTxt"),0,true);
            }
            else
            {
               dispatchEvent(new Event(CLICK,true));
            }
         }
      }
      
      override protected function __onMouseOver(event:MouseEvent) : void
      {
         if(this.isCanBeFight)
         {
            setCharacterFilter(true);
            this.showSwordMouse();
         }
      }
      
      private function showSwordMouse() : void
      {
         if(!this._swordIcon)
         {
            this._swordIcon = ComponentFactory.Instance.creat("asset.consortiaBattle.overEnemySword");
            this._swordIcon.mouseChildren = false;
            this._swordIcon.mouseEnabled = false;
            LayerManager.Instance.addToLayer(this._swordIcon,LayerManager.GAME_DYNAMIC_LAYER);
         }
         Mouse.hide();
         this._swordIcon.visible = true;
         playerHitArea.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         this._swordIcon.x = event.stageX;
         this._swordIcon.y = event.stageY;
      }
      
      private function hideSwordMouse() : void
      {
         if(Boolean(playerHitArea))
         {
            playerHitArea.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
         if(Boolean(this._swordIcon))
         {
            this._swordIcon.visible = false;
         }
         Mouse.show();
      }
      
      override protected function __onMouseOut(event:MouseEvent) : void
      {
         if(this.isEnemy)
         {
            setCharacterFilter(false);
            this.hideSwordMouse();
         }
      }
      
      public function get isEnemy() : Boolean
      {
         return Boolean(this._playerData) && this._playerData.selfOrEnemy == 2;
      }
      
      private function get isCanBeFight() : Boolean
      {
         return this.isEnemy && !this._tombstone.visible && !this._fighting.visible && ConsortiaBattleManager.instance.beforeStartTime <= 0;
      }
      
      public function set setSceneCharacterDirectionDefault(value:SceneCharacterDirection) : void
      {
         if(value == SceneCharacterDirection.LT || value == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(value == SceneCharacterDirection.LB || value == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      public function get isCanWalk() : Boolean
      {
         return !this._tombstone.visible && !this._fighting.visible;
      }
      
      public function updatePlayer() : void
      {
         this.refreshCharacterState();
         this.characterMirror();
         this.playerWalkPath();
         update();
      }
      
      public function refreshCharacterState() : void
      {
         if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
      }
      
      private function characterMirror() : void
      {
         var height:int = playerHeight;
         if(!isDefaultCharacter)
         {
            this.character.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
            this.character.x = sceneCharacterDirection.isMirror ? playerWidth / 2 : -playerWidth / 2;
            this.playerHitArea.scaleX = this.character.scaleX;
            this.playerHitArea.x = this.character.x;
         }
         else
         {
            this.character.scaleX = 1;
            this.character.x = -60;
            this.playerHitArea.scaleX = 1;
            this.playerHitArea.x = this.character.x;
            height = 175;
         }
         this.character.y = -height + 12;
         this.playerHitArea.y = this.character.y;
      }
      
      private function playerWalkPath() : void
      {
         if(_walkPath != null && _walkPath.length > 0 && this._playerData.walkPath.length > 0 && _walkPath != this._playerData.walkPath)
         {
            this.fixPlayerPath();
         }
         if(this._playerData && this._playerData.walkPath && this._playerData.walkPath.length <= 0 && !_tween.isPlaying)
         {
            return;
         }
         this.playerWalk(this._playerData.walkPath);
      }
      
      private function fixPlayerPath() : void
      {
         var lastPath:Array = null;
         if(this._playerData.currentWalkStartPoint == null)
         {
            return;
         }
         var startPointIndex:int = -1;
         for(var i:int = 0; i < _walkPath.length; i++)
         {
            if(_walkPath[i].x == this._playerData.currentWalkStartPoint.x && _walkPath[i].y == this._playerData.currentWalkStartPoint.y)
            {
               startPointIndex = i;
               break;
            }
         }
         if(startPointIndex > 0)
         {
            lastPath = _walkPath.slice(0,startPointIndex);
            this._playerData.walkPath = lastPath.concat(this._playerData.walkPath);
         }
      }
      
      override public function playerWalk(walkPathArray:Array) : void
      {
         var dirction:SceneCharacterDirection = null;
         var dis:Number = NaN;
         if(_walkPath != null && _tween.isPlaying && _walkPath == this.playerData.walkPath)
         {
            return;
         }
         _walkPath = this.playerData.walkPath;
         if(Boolean(_walkPath) && _walkPath.length > 0)
         {
            this._currentWalkStartPoint = _walkPath[0];
            dirction = this.setPlayerDirection();
            if(dirction != sceneCharacterDirection)
            {
               sceneCharacterDirection = dirction;
               updatePetsPos();
            }
            this.characterDirectionChange(true);
            dis = Point.distance(this._currentWalkStartPoint,playerPoint);
            _tween.start(dis / this._walkSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
            _walkPath.shift();
         }
         else
         {
            this.characterDirectionChange(false);
         }
      }
      
      private function setPlayerDirection() : SceneCharacterDirection
      {
         var direction:SceneCharacterDirection = null;
         direction = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
         if(this._playerData.IsMounts)
         {
            if(direction == SceneCharacterDirection.LT)
            {
               direction = SceneCharacterDirection.LB;
            }
            else if(direction == SceneCharacterDirection.RT)
            {
               direction = SceneCharacterDirection.RB;
            }
         }
         return direction;
      }
      
      public function get playerData() : ConsortiaBattlePlayerInfo
      {
         return this._playerData;
      }
      
      public function get isInTomb() : Boolean
      {
         return this._tombstone.visible;
      }
      
      public function get isInFighting() : Boolean
      {
         return this._fighting.visible;
      }
      
      private function characterDirectionChange(actionFlag:Boolean) : void
      {
         if(actionFlag)
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      protected function removeEvent() : void
      {
      }
      
      public function get currentWalkStartPoint() : Point
      {
         return this._currentWalkStartPoint;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._playerData = null;
         ObjectUtils.disposeObject(this._swordIcon);
         this._swordIcon = null;
         ObjectUtils.disposeObject(this._consortiaNameTxt);
         this._consortiaNameTxt = null;
         ObjectUtils.disposeObject(this._tombstone);
         this._tombstone = null;
         ObjectUtils.disposeObject(_petsMovie);
         _petsMovie = null;
         if(Boolean(this._fighting))
         {
            this._fighting.gotoAndStop(2);
         }
         ObjectUtils.disposeObject(this._fighting);
         this._fighting = null;
         if(Boolean(this._resurrectView))
         {
            ObjectUtils.disposeObject(this._resurrectView);
            this._resurrectView = null;
         }
         if(Boolean(this._resurrectCartoon))
         {
            this._resurrectCartoon.removeEventListener(Event.COMPLETE,this.cartoonCompleteHandler);
            removeChild(this._resurrectCartoon);
            this._resurrectCartoon = null;
         }
         this._character = null;
         super.dispose();
      }
   }
}

