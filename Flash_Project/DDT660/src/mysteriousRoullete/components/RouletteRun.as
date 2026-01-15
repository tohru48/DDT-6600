package mysteriousRoullete.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RouletteRun extends Sprite implements Disposeable
   {
      
      public static const repeatCount:int = 20;
      
      private var _yellowGlint:MovieClip;
      
      private var _orangeGlint:MovieClip;
      
      private var _pinkGlint:MovieClip;
      
      private var _blueGlint:MovieClip;
      
      private var _greenGlint:MovieClip;
      
      private var glintArr:Array;
      
      private var glintTimer:Timer;
      
      private var lastGlintTimer:Timer;
      
      private var selectedIndex:int;
      
      private var currentIndex:int;
      
      private var _sound:RouletteSound;
      
      public function RouletteRun()
      {
         super();
         this.currentIndex = 0;
         this.glintArr = [];
         this.glintTimer = new Timer(200);
         this.lastGlintTimer = new Timer(500);
         this._sound = new RouletteSound();
         this.initView();
      }
      
      private function initView() : void
      {
         this._yellowGlint = ComponentFactory.Instance.creat("mysteriousRoulette.mc.yellowGlint");
         PositionUtils.setPos(this._yellowGlint,"mysteriousRoulette.mc.yellowGlintPos");
         addChild(this._yellowGlint);
         this._yellowGlint.visible = false;
         this._orangeGlint = ComponentFactory.Instance.creat("mysteriousRoulette.mc.orangeGlint");
         PositionUtils.setPos(this._orangeGlint,"mysteriousRoulette.mc.orangeGlintPos");
         addChild(this._orangeGlint);
         this._orangeGlint.visible = false;
         this._pinkGlint = ComponentFactory.Instance.creat("mysteriousRoulette.mc.pinkGlint");
         PositionUtils.setPos(this._pinkGlint,"mysteriousRoulette.mc.pinkGlintPos");
         addChild(this._pinkGlint);
         this._pinkGlint.visible = false;
         this._blueGlint = ComponentFactory.Instance.creat("mysteriousRoulette.mc.blueGlint");
         PositionUtils.setPos(this._blueGlint,"mysteriousRoulette.mc.blueGlintPos");
         addChild(this._blueGlint);
         this._blueGlint.visible = false;
         this._greenGlint = ComponentFactory.Instance.creat("mysteriousRoulette.mc.greenGlint");
         PositionUtils.setPos(this._greenGlint,"mysteriousRoulette.mc.greenGlintPos");
         addChild(this._greenGlint);
         this._greenGlint.visible = false;
         this.glintArr.push(this._yellowGlint);
         this.glintArr.push(this._orangeGlint);
         this.glintArr.push(this._pinkGlint);
         this.glintArr.push(this._blueGlint);
         this.glintArr.push(this._greenGlint);
      }
      
      public function select(index:int) : void
      {
         this.glintArr[index].visible = true;
         this.glintArr[index].gotoAndStop(9);
      }
      
      public function run(result:int) : void
      {
         this.selectedIndex = result;
         this.glintTimer.addEventListener(TimerEvent.TIMER,this.onGlintTimer);
         this.glintTimer.start();
      }
      
      protected function onGlintTimer(event:TimerEvent) : void
      {
         var i:int = this.currentIndex;
         this.glintArr[i].visible = true;
         this.glintArr[i].gotoAndStop(1);
         this.glintArr[i].addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.glintArr[i].play();
         this._sound.playOneStep();
         if(this.glintTimer.currentCount > repeatCount && i == this.selectedIndex)
         {
            this.lastGlintTimer.addEventListener(TimerEvent.TIMER,this.onLastGlintTimer);
            this.lastGlintTimer.start();
            this.glintTimer.stop();
         }
         else if(i >= 4)
         {
            this.currentIndex = 0;
         }
         else
         {
            ++this.currentIndex;
         }
      }
      
      protected function onLastGlintTimer(event:TimerEvent) : void
      {
         this.glintArr[this.selectedIndex].visible = true;
         this.glintArr[this.selectedIndex].play();
         if(this.lastGlintTimer.currentCount == 5)
         {
            (this.glintArr[this.selectedIndex] as MovieClip).gotoAndStop(1);
            this.lastGlintTimer.stop();
            this.lastGlintTimer.removeEventListener(TimerEvent.TIMER,this.onLastGlintTimer);
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function onEnterFrame(event:Event) : void
      {
         if((event.target as MovieClip).currentFrame == (event.target as MovieClip).totalFrames)
         {
            (event.target as MovieClip).stop();
            (event.target as MovieClip).visible = false;
            (event.target as MovieClip).gotoAndStop(1);
            (event.target as MovieClip).removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function removeEvent() : void
      {
         this.glintTimer.removeEventListener(TimerEvent.TIMER,this.onGlintTimer);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._blueGlint))
         {
            ObjectUtils.disposeObject(this._blueGlint);
         }
         this._blueGlint = null;
         if(Boolean(this._greenGlint))
         {
            ObjectUtils.disposeObject(this._greenGlint);
         }
         this._greenGlint = null;
         if(Boolean(this._orangeGlint))
         {
            ObjectUtils.disposeObject(this._orangeGlint);
         }
         this._orangeGlint = null;
         if(Boolean(this._pinkGlint))
         {
            ObjectUtils.disposeObject(this._pinkGlint);
         }
         this._pinkGlint = null;
         if(Boolean(this._yellowGlint))
         {
            ObjectUtils.disposeObject(this._yellowGlint);
         }
         this._yellowGlint = null;
      }
   }
}

