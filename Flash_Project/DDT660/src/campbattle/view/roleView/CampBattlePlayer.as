package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class CampBattlePlayer extends CampBaseRole
   {
      
      public var scene:SceneScene;
      
      protected var tombstone:MovieClip;
      
      protected var fighting:MovieClip;
      
      protected var capture:Bitmap;
      
      private var _walkOverHander:Function;
      
      private var _targetID:int;
      
      private var _targetZoneID:int;
      
      private var _nameTxt:FilterFrameText;
      
      private var _resurrectCartoon:MovieClip;
      
      private var _currentWalkStartPoint:Point;
      
      private var _walkSpeed:Number;
      
      public function CampBattlePlayer(playerInfo:RoleData = null, callBack:Function = null)
      {
         super(playerInfo,callBack);
         if(!playerInfo)
         {
            return;
         }
         _playerInfo = playerInfo;
         this.setPlayerInfo(playerInfo);
         this.setPlayerWalkSpeed();
      }
      
      private function setPlayerWalkSpeed() : void
      {
         if(this.playerInfo.IsMounts)
         {
            this._walkSpeed = 0.25;
         }
         else
         {
            this._walkSpeed = 0.15;
         }
      }
      
      public function setPlayerInfo(playerInfo:RoleData = null) : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         x = playerInfo.posX;
         y = playerInfo.posY;
         this.character.x = -playerWidth / 2;
         this.character.y = -playerHeight;
         this.initStatus();
         this.setStateType(playerInfo.stateType);
         this.setCaptureVisible(playerInfo.isCapture);
      }
      
      private function initStatus() : void
      {
         this._resurrectCartoon = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectCartoon");
         this._resurrectCartoon.addEventListener(Event.COMPLETE,this.cartoonCompleteHandler,false,0,true);
         this._resurrectCartoon.gotoAndStop(1);
         this._resurrectCartoon.visible = false;
         addChild(this._resurrectCartoon);
         this.tombstone = ComponentFactory.Instance.creat("campbattle.tombstone");
         this.tombstone.visible = false;
         addChild(this.tombstone);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt1");
         this._nameTxt.text = _playerInfo.name;
         this._nameTxt.x = this.character.x + (playerWidth / 2 - this._nameTxt.width / 2);
         this._nameTxt.y = -playerHeight + 10;
         addChild(this._nameTxt);
         this.fighting = ComponentFactory.Instance.creat("campbattle.fighting");
         this.fighting.x = -1;
         this.fighting.y = this._nameTxt.y - 20;
         this.fighting.visible = false;
         addChild(this.fighting);
         this.capture = ComponentFactory.Instance.creat("asset.campbattle.capture.Samll");
         this.capture.x = this._nameTxt.x - this.capture.width - 2;
         this.capture.y = this._nameTxt.y;
         this.capture.visible = false;
         addChild(this.capture);
      }
      
      public function setCaptureVisible(bool:Boolean) : void
      {
         this.capture.visible = bool;
         _playerInfo.isCapture = bool;
      }
      
      private function cartoonCompleteHandler(e:Event) : void
      {
         this._resurrectCartoon.gotoAndStop(1);
         this._resurrectCartoon.visible = false;
      }
      
      public function setStateType(type:int) : void
      {
         this.tombstone.visible = false;
         this.fighting.visible = false;
         this._resurrectCartoon.visible = false;
         switch(type)
         {
            case 0:
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
            case 1:
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
               if(_playerInfo.isDead)
               {
                  _playerInfo.isDead = false;
                  this._resurrectCartoon.visible = true;
                  this._resurrectCartoon.gotoAndPlay(1);
               }
               break;
            case 2:
               this.fighting.visible = true;
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
               break;
            case 3:
               break;
            case 4:
               this.character.visible = false;
               this.tombstone.visible = true;
               _playerInfo.isDead = true;
               this._nameTxt.y = this.tombstone.y - 80;
         }
         _playerInfo.stateType = type;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.fighting))
         {
            while(Boolean(this.fighting.numChildren))
            {
               ObjectUtils.disposeObject(this.fighting.getChildAt(0));
            }
         }
         if(Boolean(this.tombstone))
         {
            while(Boolean(this.tombstone.numChildren))
            {
               ObjectUtils.disposeObject(this.tombstone.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this.fighting);
         ObjectUtils.disposeObject(this.capture);
         ObjectUtils.disposeObject(this.tombstone);
         ObjectUtils.disposeObject(this._nameTxt);
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         super.dispose();
      }
      
      protected function enterFrameHander(e:Event) : void
      {
         update();
         this.playerWalkPath();
         this.characterMirror();
      }
      
      public function walk(p:Point, fun:Function = null, id:int = 0, zoneID:int = 0) : void
      {
         if(!this.scene)
         {
            return;
         }
         walkPath = [];
         this._targetID = id;
         this._targetZoneID = zoneID;
         walkPath = this.scene.searchPath(playerPoint,p);
         walkPath.shift();
         isWalkPathChange = true;
         this._walkOverHander = fun;
      }
      
      protected function characterMirror() : void
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
      
      protected function playerWalkPath() : void
      {
         if((!walkPath || walkPath.length <= 0) && !_tween.isPlaying)
         {
            return;
         }
         this.playerWalk(walkPath);
      }
      
      override public function playerWalk(walkPath:Array) : void
      {
         var dis:Number = NaN;
         if(_walkPath != null && !isWalkPathChange && _tween.isPlaying)
         {
            return;
         }
         _walkPath = walkPath;
         isWalkPathChange = false;
         if(Boolean(_walkPath) && _walkPath.length > 0)
         {
            this._currentWalkStartPoint = _walkPath[0] as Point;
            sceneCharacterDirection = this.setPlayerDirection();
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
            dis = Point.distance(this._currentWalkStartPoint,playerPoint);
            _tween.start(dis / this._walkSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
            _walkPath.shift();
         }
         else
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
      }
      
      private function setPlayerDirection() : SceneCharacterDirection
      {
         var direction:SceneCharacterDirection = null;
         direction = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
         if(_playerInfo.IsMounts)
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
      
      private function characterDirectionChange(e:SceneCharacterEvent) : void
      {
         if(Boolean(e.data))
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
         else
         {
            if(this._walkOverHander != null)
            {
               if(this._targetID != 0 && this._targetZoneID != 0)
               {
                  this._walkOverHander(this._targetZoneID,this._targetID);
               }
               else if(this._targetID != 0)
               {
                  this._walkOverHander(this._targetID);
               }
               else
               {
                  this._walkOverHander();
               }
            }
            _playerInfo.posX = x;
            _playerInfo.posY = y;
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
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
      }
      
      public function get playerInfo() : RoleData
      {
         return _playerInfo;
      }
   }
}

