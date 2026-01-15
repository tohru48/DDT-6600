package ddtBuried.role
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.player.PlayerInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Timer;
   import magpieBridge.event.MagpieBridgeEvent;
   import worldboss.player.WorldRoomPlayerBase;
   
   public class BuriedPlayer extends WorldRoomPlayerBase
   {
      
      private var _sceneCharacterDirection:Object;
      
      private var _timer:Timer;
      
      private var _walkArray:Array;
      
      private var _oldIndex:int;
      
      private var index:int;
      
      private var _isWalk:Boolean;
      
      private var _isMir:Boolean;
      
      private var _light:MovieClip;
      
      public function BuriedPlayer(playerInfo:PlayerInfo, callBack:Function = null)
      {
         super(playerInfo,callBack);
         this._light = ComponentFactory.Instance.creat("buried.dice.footLigth");
         this._light.x = -282;
         this._light.y = 38;
         this.character.y = 15;
         addChild(this._light);
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
      }
      
      private function enterFrameHander(e:Event) : void
      {
         update();
      }
      
      public function refreshCharacterState() : void
      {
         if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
      }
      
      public function set setSceneCharacterDirectionDefault(value:SceneCharacterDirection) : void
      {
         if(sceneCharacterStateType == "natural")
         {
            sceneCharacterActionType = "naturalStandFront";
         }
      }
      
      private function characterMirror($x:int) : void
      {
         if(!isDefaultCharacter)
         {
            if($x > x)
            {
               this.character.scaleX = -1;
               this.character.x = playerWitdh - 3;
            }
            else
            {
               this.character.scaleX = 1;
               this.character.x = -3;
            }
         }
         else
         {
            this.character.scaleX = 1;
            this.character.x = -3;
         }
      }
      
      public function roleWalk(array:Array) : void
      {
         this.index = 0;
         this._isWalk = true;
         this._walkArray = array;
         dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
         this.characterMirror(this._walkArray[this.index].x);
         TweenMax.to(this,0.3,{
            "x":array[this.index].x,
            "y":array[this.index].y,
            "onComplete":this.comp,
            "ease":Linear.easeNone
         });
      }
      
      private function comp() : void
      {
         ++this.index;
         if(this.index < this._walkArray.length)
         {
            this.characterMirror(this._walkArray[this.index].x);
            this.refreshCharacterState();
            TweenMax.to(this,0.3,{
               "x":this._walkArray[this.index].x,
               "y":this._walkArray[this.index].y,
               "onComplete":this.comp,
               "ease":Linear.easeNone
            });
         }
         else
         {
            this._isWalk = false;
            dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.WALK_OVER));
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
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
      
      override public function dispose() : void
      {
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         super.dispose();
      }
   }
}

