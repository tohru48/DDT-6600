package ddt.view.roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RouletteGlintView extends Sprite implements Disposeable
   {
      
      public static const BIGGLINTCOMPLETE:String = "bigGlintComplete";
      
      private var _timer:Timer;
      
      private var _glintType:int = 0;
      
      private var _pointArray:Array;
      
      private var _bigGlintSprite:MovieClip;
      
      private var _glintArray:Vector.<MovieClip>;
      
      public function RouletteGlintView(pointArray:Array)
      {
         super();
         this.init();
         this.initEvent();
         this._pointArray = pointArray;
      }
      
      private function init() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._glintArray = new Vector.<MovieClip>();
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function _timerComplete(e:TimerEvent) : void
      {
         this._timer.stop();
         this._clearGlint();
      }
      
      private function _restartTimer(time:int) : void
      {
         this._timer.delay = time;
         this._timer.reset();
         this._timer.start();
      }
      
      public function showOneCell(value:int, time:int) : void
      {
         var glintSp:MovieClip = null;
         this.glintType = 1;
         if(value >= 0 && value <= 17)
         {
            glintSp = ComponentFactory.Instance.creat("asset.awardSystem.roulette.GlintAsset");
            glintSp.x = this._pointArray[value].x;
            glintSp.y = this._pointArray[value].y;
            addChild(glintSp);
            this._glintArray.push(glintSp);
            this._restartTimer(time);
         }
      }
      
      public function showTwoStep(time:int) : void
      {
         this.glintType = 2;
         this.showAllCell();
         this.showBigGlint();
         this._restartTimer(time);
      }
      
      public function showAllCell() : void
      {
         var i:int = 0;
         var glintSp:MovieClip = null;
         for(i = 0; i <= 17; i++)
         {
            glintSp = ComponentFactory.Instance.creat("asset.awardSystem.roulette.GlintAsset");
            glintSp.x = this._pointArray[i].x;
            glintSp.y = this._pointArray[i].y;
            addChild(glintSp);
            this._glintArray.push(glintSp);
         }
      }
      
      public function showBigGlint() : void
      {
         this._bigGlintSprite = ComponentFactory.Instance.creat("asset.awardSystem.roulette.BigGlintAsset");
         addChild(this._bigGlintSprite);
      }
      
      private function _clearGlint() : void
      {
         var glintSp:MovieClip = null;
         for(var i:int = 0; i < this._glintArray.length; i++)
         {
            glintSp = this._glintArray[i] as MovieClip;
            removeChild(glintSp);
         }
         if(Boolean(this._bigGlintSprite))
         {
            removeChild(this._bigGlintSprite);
            this._bigGlintSprite = null;
         }
         this._glintArray.splice(0,this._glintArray.length);
         if(this.glintType == 2)
         {
            dispatchEvent(new Event(BIGGLINTCOMPLETE));
         }
      }
      
      public function set glintType(value:int) : void
      {
         this._glintType = value;
      }
      
      public function get glintType() : int
      {
         return this._glintType;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer = null;
         }
         if(Boolean(this._bigGlintSprite))
         {
            ObjectUtils.disposeObject(this._bigGlintSprite);
         }
         this._bigGlintSprite = null;
         for(var i:int = 0; i < this._glintArray.length; i++)
         {
            ObjectUtils.disposeObject(this._glintArray[i]);
         }
         this._glintArray.splice(0,this._glintArray.length);
      }
   }
}

