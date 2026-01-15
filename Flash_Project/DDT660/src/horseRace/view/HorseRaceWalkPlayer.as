package horseRace.view
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import hall.player.HallPlayer;
   import hall.player.vo.PlayerVO;
   
   public class HorseRaceWalkPlayer extends HallPlayer implements Disposeable
   {
      
      public var index:int;
      
      public var speed:int = 10;
      
      public var raceLen:Number = 0;
      
      public var isGoToEnd:Boolean = false;
      
      public var isStartRace:Boolean = false;
      
      public var initPosX:int;
      
      public var endPosX:int;
      
      private var _raceTimer:Timer;
      
      public var id:int;
      
      public var rank:int;
      
      public var isSelf:Boolean;
      
      public var gameId:int;
      
      public var buffList:Array = [];
      
      public var isGetEnd:Boolean = false;
      
      public var currentTime:int;
      
      public var isRankByCilent:Boolean = true;
      
      private var mytime:int = 0;
      
      public function HorseRaceWalkPlayer(playerVO:PlayerVO, callBack:Function = null)
      {
         super(playerVO,callBack);
         this.addRaceTimer();
      }
      
      private function addRaceTimer() : void
      {
         this._raceTimer = new Timer(20);
         this._raceTimer.addEventListener(TimerEvent.TIMER,this._playerChangePos);
      }
      
      private function removeRaceTimer() : void
      {
         if(Boolean(this._raceTimer))
         {
            this._raceTimer.removeEventListener(TimerEvent.TIMER,this._playerChangePos);
            this._raceTimer.stop();
         }
         this._raceTimer = null;
      }
      
      public function startRace() : void
      {
         this.isStartRace = true;
         this._raceTimer.start();
         this.currentTime = getTimer();
         this.walk();
      }
      
      public function stopRace() : void
      {
         this.isStartRace = false;
         this.stand();
      }
      
      public function turnTo(direction:String = "left") : void
      {
         if(direction == "right")
         {
            isDefaultCharacter = false;
         }
         else
         {
            isDefaultCharacter = true;
         }
         this.characterMirror();
      }
      
      public function stand() : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         sceneCharacterActionType = "naturalStandFront";
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function walk() : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         sceneCharacterActionType = "naturalWalkFront";
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function _playerChangePos(e:TimerEvent) : void
      {
         var nowTimer:int = getTimer();
         var timeCount:int = nowTimer - this.currentTime;
         if(this.isStartRace)
         {
            this.raceLen += this.speed * timeCount / 1000;
         }
         this.currentTime = nowTimer;
      }
      
      public function stop() : void
      {
         sceneCharacterActionType = "naturalStandFront";
         if(hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         this.refreshCharacterState();
         this.characterMirror();
         update();
      }
      
      override public function refreshCharacterState() : void
      {
      }
      
      private function characterMirror() : void
      {
         if(this.character == null)
         {
            return;
         }
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
      
      override public function dispose() : void
      {
         this.removeRaceTimer();
         super.dispose();
      }
   }
}

