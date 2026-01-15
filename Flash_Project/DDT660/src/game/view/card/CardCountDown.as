package game.view.card
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CardCountDown extends Sprite implements Disposeable
   {
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      private var _timer:Timer;
      
      private var _totalSeconds:uint;
      
      private var _digit:Bitmap;
      
      private var _tenDigit:Bitmap;
      
      private var _isPlaySound:Boolean;
      
      public function CardCountDown()
      {
         super();
         this.init();
      }
      
      public function tick(seconds:uint, isPlaySound:Boolean = true) : void
      {
         this._totalSeconds = seconds;
         this._isPlaySound = isPlaySound;
         this._timer.repeatCount = this._totalSeconds;
         this.__updateView();
         this._timer.start();
      }
      
      private function init() : void
      {
         this._digit = new Bitmap();
         this._tenDigit = new Bitmap();
         this._bitmapDatas = new Vector.<BitmapData>();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__updateView);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         for(var i:int = 0; i < 10; i++)
         {
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData("asset.takeoutCard.CountDownNum_" + String(i)));
         }
      }
      
      private function __updateView(event:TimerEvent = null) : void
      {
         var num:int = this._timer.repeatCount - this._timer.currentCount;
         if(num <= 4)
         {
            if(this._isPlaySound)
            {
               SoundManager.instance.stop("067");
               SoundManager.instance.play("067");
            }
         }
         else if(this._isPlaySound)
         {
            SoundManager.instance.play("014");
         }
         this._tenDigit.bitmapData = this._bitmapDatas[int(num / 10)];
         this._digit.bitmapData = this._bitmapDatas[num % 10];
         this._digit.x = this._tenDigit.width - 14;
         addChild(this._digit);
         addChild(this._tenDigit);
      }
      
      private function __onTimerComplete(event:TimerEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         var bmd:BitmapData = null;
         this._timer.removeEventListener(TimerEvent.TIMER,this.__updateView);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         this._timer.stop();
         this._timer = null;
         for each(bmd in this._bitmapDatas)
         {
            bmd.dispose();
            bmd = null;
         }
         if(Boolean(this._digit) && Boolean(this._digit.parent))
         {
            this._digit.parent.removeChild(this._digit);
         }
         if(Boolean(this._tenDigit) && Boolean(this._tenDigit.parent))
         {
            this._tenDigit.parent.removeChild(this._tenDigit);
         }
         this._digit = null;
         this._tenDigit = null;
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

