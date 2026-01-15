package luckStar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LuckStarCoinsView extends Sprite implements Disposeable
   {
      
      private static const MAX_NUM_WIDTH:int = 8;
      
      private static const BUFFER_TIME:int = 50;
      
      private static const WIDTH:int = 25;
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var len:int = 4;
      
      private var coinsNum:int;
      
      private var notFirst:Boolean = false;
      
      private var time:Timer;
      
      private var oldCoins:int;
      
      public function LuckStarCoinsView()
      {
         super();
         this._num = new Vector.<ScaleFrameImage>();
         this.time = new Timer(BUFFER_TIME);
         this.time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onComplete);
         this.time.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this.time.stop();
         this.setupCount();
      }
      
      public function set count(value:int) : void
      {
         if(this.coinsNum == value)
         {
            return;
         }
         if(this.coinsNum != this.oldCoins && this.notFirst)
         {
            this.initCoinsStyle();
         }
         this.coinsNum = value;
         this.updateCount();
      }
      
      private function setupCount() : void
      {
         var numX:int = 0;
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(10));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var cha:int = MAX_NUM_WIDTH - this.len;
         numX = cha / 2 * WIDTH;
         for(var i:int = 0; i < this.len; i++)
         {
            this._num[i].x = numX;
            numX += WIDTH;
         }
      }
      
      private function updateCount() : void
      {
         var length:int = int(this.coinsNum.toString().length);
         if(length != this.len)
         {
            this.len = length;
            this.setupCount();
         }
         if(this.coinsNum - this.oldCoins <= 0)
         {
            this.initCoinsStyle();
         }
         else if(!this.notFirst)
         {
            this.notFirst = true;
            this.initCoinsStyle();
         }
         else
         {
            this.play();
         }
      }
      
      private function __onTimer(e:TimerEvent) : void
      {
         ++this.oldCoins;
         if(this.oldCoins > this.coinsNum)
         {
            this.oldCoins = this.coinsNum;
         }
         var arr:Array = this.oldCoins.toString().split("");
         if(this.len > arr.length)
         {
            arr.unshift("0");
         }
         this.updateCoinsView(arr);
      }
      
      private function __onComplete(e:TimerEvent) : void
      {
         this.time.stop();
         this.oldCoins = this.coinsNum;
      }
      
      private function initCoinsStyle() : void
      {
         var arr:Array = this.coinsNum.toString().split("");
         this.updateCoinsView(arr);
         this.oldCoins = this.coinsNum;
      }
      
      private function updateCoinsView(arr:Array) : void
      {
         for(var i:int = 0; i < this.len; i++)
         {
            if(arr[i] == 0)
            {
               arr[i] = 10;
            }
            this._num[i].setFrame(arr[i]);
         }
      }
      
      private function play() : void
      {
         this.time.stop();
         this.time.reset();
         this.time.repeatCount = this.coinsNum - this.oldCoins;
         this.time.start();
      }
      
      private function createCoinsNum(frame:int = 0) : ScaleFrameImage
      {
         var num:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.CoinsNum");
         num.setFrame(frame);
         addChild(num);
         return num;
      }
      
      public function dispose() : void
      {
         this.time.stop();
         this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onComplete);
         this.time.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         this.time = null;
         while(Boolean(this._num.length))
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         this._num = null;
      }
   }
}

