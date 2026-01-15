package church.view.churchFire
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChurchFireEffectPlayer extends Sprite
   {
      
      public static const FIER_TIMER:int = 3500;
      
      private var _fireTemplateID:int;
      
      private var _fireMovie:MovieClip;
      
      private var _playerFramesCount:int = 0;
      
      private var _playerTimer:Timer;
      
      public var owerID:int;
      
      public function ChurchFireEffectPlayer(fireTemplateID:int)
      {
         this._fireTemplateID = fireTemplateID;
         this.addFire();
         super();
      }
      
      private function addFire() : void
      {
         var fireClassPath:String = "";
         switch(this._fireTemplateID)
         {
            case 21002:
               fireClassPath = "tank.church.fireAcect.FireItemAccect02";
               break;
            case 21006:
               fireClassPath = "tank.church.fireAcect.FireItemAccect06";
         }
         if(!fireClassPath || fireClassPath == "" || fireClassPath.length <= 0)
         {
            return;
         }
         var fireClass:Class = ClassUtils.uiSourceDomain.getDefinition(fireClassPath) as Class;
         if(Boolean(fireClass))
         {
            this._fireMovie = new fireClass() as MovieClip;
            if(Boolean(this._fireMovie))
            {
               addChild(this._fireMovie);
            }
         }
      }
      
      public function firePlayer(playSound:Boolean = true) : void
      {
         if(playSound)
         {
            SoundManager.instance.play("117");
         }
         if(Boolean(this._fireMovie))
         {
            this._fireMovie.gotoAndPlay(1);
            this._fireMovie.addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
            this._playerFramesCount = 0;
            this._playerTimer = new Timer(FIER_TIMER,0);
            this._playerTimer.start();
            this._playerTimer.addEventListener(TimerEvent.TIMER,this.timerHander);
         }
         else
         {
            this.removeFire();
         }
      }
      
      public function removeFire() : void
      {
         if(Boolean(this._fireMovie))
         {
            if(Boolean(this._fireMovie.parent))
            {
               this._fireMovie.parent.removeChild(this._fireMovie);
            }
            this._fireMovie.removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
            this._fireMovie = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function timerHander(evt:TimerEvent) : void
      {
         if(Boolean(this._playerTimer))
         {
            this._playerTimer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._playerTimer.stop();
            this._playerTimer = null;
         }
         this.removeFire();
      }
      
      private function enterFrameHander(e:Event) : void
      {
         ++this._playerFramesCount;
         if(this._playerFramesCount >= this._fireMovie.totalFrames)
         {
            this.removeFire();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._fireMovie))
         {
            this._fireMovie.removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         }
         this._fireMovie = null;
         if(Boolean(this._playerTimer))
         {
            this._playerTimer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._playerTimer.stop();
         }
         this._playerTimer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

