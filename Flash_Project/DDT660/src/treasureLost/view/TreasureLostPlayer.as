package treasureLost.view
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
   import treasureLost.controller.TreasureLostManager;
   import treasureLost.events.TreasureLostEvents;
   import worldboss.player.WorldRoomPlayerBase;
   
   public class TreasureLostPlayer extends WorldRoomPlayerBase
   {
      
      private var _sceneCharacterDirection:Object;
      
      private var _timer:Timer;
      
      private var _walkArray:Array;
      
      private var _oldIndex:int;
      
      private var index:int;
      
      private var _isWalk:Boolean;
      
      private var _isMir:Boolean;
      
      private var _light:MovieClip;
      
      public function TreasureLostPlayer(playerInfo:PlayerInfo, callBack:Function = null)
      {
         super(playerInfo,callBack);
         this._light = ComponentFactory.Instance.creat("treasureLost.footLigth");
         this._light.x = -282;
         this._light.y = 38;
         addChild(this._light);
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         this.scaleX = 0.7;
         this.scaleY = 0.7;
      }
      
      public function setPos(path:int) : void
      {
         var pathArr:Array = null;
         var posStr:String = TreasureLostManager.Instance.mapPlayerPath;
         var posArr:Array = posStr.split("|");
         var pathStr:String = posArr[path];
         pathArr = pathStr.split(",");
         this.x = int(pathArr[0]);
         this.y = int(pathArr[1]);
      }
      
      private function enterFrameHander(e:Event) : void
      {
         update();
      }
      
      public function setSceneCharacterDirectionDefault() : void
      {
         character.scaleX = -1;
         character.x = playerWitdh;
      }
      
      private function characterMirror($x:int) : void
      {
         if(!isDefaultCharacter)
         {
            if($x > x)
            {
               character.scaleX = -1;
               character.x = playerWitdh;
            }
            else
            {
               character.scaleX = 1;
               character.x = 0;
            }
         }
         else
         {
            character.scaleX = 1;
            character.x = 0;
         }
      }
      
      public function roleWalk(array:Array) : void
      {
         if(array.length == 0)
         {
            return;
         }
         TreasureLostManager.Instance.isMove = true;
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
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
            dispatchEvent(new TreasureLostEvents(TreasureLostEvents.ROLEWALKEND));
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

