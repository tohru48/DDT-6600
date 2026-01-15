package game.view
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightAchievModel;
   import ddt.display.BitmapShape;
   import ddt.manager.BitmapManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   [Event(name="complete",type="flash.events.Event")]
   public class AchieveAnimation extends Sprite implements Disposeable
   {
      
      public static const Show:int = 1;
      
      public static const Hold:int = 2;
      
      public static const Hide:int = -1;
      
      private var _startY:int;
      
      private var _startX:int;
      
      private var _flashTime:Number;
      
      private var _holdTime:Number;
      
      private var _fadeOutTime:Number;
      
      private var _elapsed:int;
      
      private var _lastTime:int;
      
      private var _state:int = -1;
      
      private var _currentAchiev:int;
      
      private var _num:int = 0;
      
      private var _achievImage:ScaleFrameImage;
      
      private var _numShape:AchievNumShape;
      
      private var _center:Point = new Point();
      
      private var _holdTimeField:TextField;
      
      private var _shine:AchievShineShape;
      
      private var _shineTime:Number;
      
      private var _interval:int = -1;
      
      private var _show:Boolean = false;
      
      private var _start:int = 0;
      
      private var _achiev:int;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _achievShape:BitmapShape;
      
      public function AchieveAnimation(achiev:int, num:int, interval:int, start:int)
      {
         super();
         this._interval = interval;
         this._start = start;
         this._achiev = achiev;
         this._num = num;
         this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
         this._shine = ComponentFactory.Instance.creatCustomObject("AchievShineShape");
         addChild(this._shine);
         this._achievShape = this._bitmapMgr.creatBitmapShape("asset.game.achiev" + this._achiev);
         addChild(this._achievShape);
         this._startX = StageReferance.stageWidth;
         mouseEnabled = false;
         mouseChildren = false;
         this._numShape = new AchievNumShape();
         addChild(this._numShape);
      }
      
      public function dispose() : void
      {
         this.kill();
         if(Boolean(this._bitmapMgr))
         {
            ObjectUtils.disposeObject(this._bitmapMgr);
            this._bitmapMgr = null;
         }
         if(Boolean(this._numShape))
         {
            ObjectUtils.disposeObject(this._numShape);
            this._numShape = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._achievShape))
         {
            ObjectUtils.disposeObject(this._achievShape);
            this._achievShape = null;
         }
      }
      
      private function drawNum() : void
      {
         this._numShape.drawNum(this._num);
         this._numShape.filters = [new GlowFilter(FightAchievModel.getInstance().getAchievColor(this._achiev),1,10,10,3)];
         this._numShape.x = this._center.x - (this._numShape.width >> 1);
         this._numShape.y = this._center.y - (this._numShape.height >> 1);
      }
      
      public function flash() : void
      {
         alpha = 0;
         this._state = Show;
         this._show = true;
      }
      
      private function flashComplete() : void
      {
         this._lastTime = getTimer();
         this._elapsed = 0;
         this._state = Hold;
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__holdFrame);
         if(!FightAchievModel.getInstance().isNumAchiev(this._achiev))
         {
            this._shine.setColor(FightAchievModel.getInstance().getAchievColor(this._achiev));
            TweenLite.to(this._shine,this._shineTime,{
               "alpha":1,
               "yoyo":true,
               "repeat":1,
               "onComplete":this.shineComplete
            });
         }
      }
      
      private function shineComplete() : void
      {
         this._shine.alpha = 0;
      }
      
      private function __holdFrame(event:Event) : void
      {
         var now:int = getTimer();
         this._elapsed += now - this._lastTime;
         if(this._elapsed >= this._holdTime * 1000)
         {
            this.holdComplete();
            return;
         }
         this._lastTime = now;
      }
      
      private function holdComplete() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__holdFrame);
         this.fadeOut();
      }
      
      public function fadeOut() : void
      {
         this._state = Hide;
         TweenLite.to(this,this._fadeOutTime,{
            "alpha":0,
            "onComplete":this.fadeOutComplete
         });
      }
      
      private function fadeOutComplete() : void
      {
         this._numShape.visible = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function kill() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__holdFrame);
         TweenLite.killTweensOf(this);
         TweenLite.killTweensOf(this._shine);
         this._numShape.visible = false;
         this._shine.alpha = 0;
         this._show = false;
      }
      
      public function play() : void
      {
         x = width;
         alpha = 0;
         this._state = Show;
         this._show = true;
         if(FightAchievModel.getInstance().isNumAchiev(this._achiev))
         {
            this.drawNum();
         }
         TweenLite.to(this,this._flashTime,{
            "x":0,
            "alpha":1,
            "onComplete":this.flashComplete,
            "ease":Bounce.easeOut
         });
         this._show = true;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set startY(val:int) : void
      {
         this._startY = val;
         this.y = this._startY;
      }
      
      public function set numCenter(val:String) : void
      {
         var arr:Array = val.split(",");
         this._center.x = arr[0];
         this._center.y = arr[1];
      }
      
      public function set time(val:String) : void
      {
         var arr:Array = val.split(",");
         if(arr.length == 4)
         {
            this._flashTime = arr[0] > 0 ? Number(arr[0]) : 0.6;
            this._holdTime = arr[1] > 0 ? Number(arr[1]) : 2;
            this._fadeOutTime = arr[2] > 0 ? Number(arr[2]) : 0.6;
            this._shineTime = arr[3] > 0 ? Number(arr[3]) : 0.6;
            return;
         }
         throw new Error("在初始化小成就动画时传入了错误的时间值。");
      }
      
      public function get interval() : int
      {
         return this._interval;
      }
      
      public function get show() : Boolean
      {
         return this._show;
      }
      
      public function get delay() : int
      {
         return this._start + this._interval;
      }
      
      public function get id() : int
      {
         return this._achiev;
      }
      
      public function setNum(num:int) : void
      {
         this._num = num > 0 ? num : 0;
         this.drawNum();
         if(this._state == Hold)
         {
            this._elapsed = 0;
         }
      }
      
      override public function get height() : Number
      {
         return this._achievShape.height;
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
      }
   }
}

