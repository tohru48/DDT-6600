package game.view.stage
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class StageCurtain extends Sprite
   {
      
      private var _playTime:uint;
      
      private var _duration:uint;
      
      private var _life:uint;
      
      public function StageCurtain()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         visible = false;
         graphics.clear();
         graphics.beginFill(0);
         graphics.drawRect(0,0,2000,2000);
      }
      
      public function fadeIn(duration:uint = 25) : void
      {
         StageReferance.stage.addChild(this);
         visible = true;
         alpha = 0;
         this._duration = duration;
         this._life = 0;
         addEventListener(Event.ENTER_FRAME,this.__updateFadeIn);
      }
      
      public function fadeOut(duration:uint = 25) : void
      {
         StageReferance.stage.addChild(this);
         visible = true;
         alpha = 1;
         this._duration = duration;
         this._life = 0;
         addEventListener(Event.ENTER_FRAME,this.__updateFadeOut);
      }
      
      private function __updateFadeIn(evt:Event) : void
      {
         if(this._life == this._duration)
         {
            dispatchEvent(new Event("fadein"));
            removeEventListener(Event.ENTER_FRAME,this.__updateFadeIn);
            alpha = 1;
            this.end();
         }
         var progress:Number = this._life / this._duration;
         alpha = progress;
         ++this._life;
      }
      
      private function __updateFadeOut(evt:Event) : void
      {
         if(this._life == this._duration)
         {
            dispatchEvent(new Event("fadeout"));
            removeEventListener(Event.ENTER_FRAME,this.__updateFadeOut);
            alpha = 0;
            this.end();
         }
         var progress:Number = this._life / this._duration;
         alpha = 1 - progress;
         ++this._life;
      }
      
      private function end() : void
      {
         this.parent.removeChild(this);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function play(duration:uint = 25) : void
      {
         StageReferance.stage.addChild(this);
         visible = true;
         alpha = 0;
         this._duration = duration;
         this._life = 0;
         addEventListener(Event.ENTER_FRAME,this.__updatePlay);
      }
      
      private function __updatePlay(e:Event) : void
      {
         if(this._life == this._duration)
         {
            removeEventListener(Event.ENTER_FRAME,this.__updatePlay);
            alpha = 0;
            this.end();
         }
         var progress:Number = this._life / this._duration;
         if(progress < 0.2)
         {
            alpha = progress / 0.2;
         }
         else
         {
            alpha = 1 - progress / 0.8;
         }
         ++this._life;
      }
   }
}

