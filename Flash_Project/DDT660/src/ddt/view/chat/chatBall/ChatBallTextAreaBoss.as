package ddt.view.chat.chatBall
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.utils.Timer;
   
   public class ChatBallTextAreaBoss extends ChatBallTextAreaNPC
   {
      
      private const TYPEDLENGTH:int = 1;
      
      private const TYPEINTERVAL:int = 30;
      
      private var _maskMC:Sprite;
      
      private var _bmdata:BitmapData;
      
      private var _bmp:Bitmap;
      
      private var _typeTimer:Timer;
      
      private var _count:int;
      
      public var animation:Boolean = true;
      
      public function ChatBallTextAreaBoss()
      {
         super();
         this._typeTimer = new Timer(this.TYPEINTERVAL);
         this._typeTimer.addEventListener(TimerEvent.TIMER,this.__onTypeTimerTick);
      }
      
      override protected function setFormat() : void
      {
         var style:StyleSheet = new StyleSheet();
         style.parseCSS("p{font-size:12px;text-align:left;font-weight:bold;leading:3px;}" + ".red{color:#FF0000;}" + ".blue{color:#0000FF;}" + ".green{color:#00FF00;}");
         tf.styleSheet = style;
      }
      
      override public function set text(value:String) : void
      {
         super.text = value;
         ObjectUtils.disposeObject(this._maskMC);
         this._maskMC = new Sprite();
         addChild(this._maskMC);
         this._maskMC.x = tf.x + 2;
         this._maskMC.y = tf.y + 2;
         ObjectUtils.disposeObject(this._bmp);
         this._bmdata = new BitmapData(tf.width,tf.height + 4);
         this._bmdata.draw(tf);
         this._bmp = new Bitmap(this._bmdata);
         this._bmp.x = tf.x;
         this._bmp.y = tf.y;
         addChild(this._bmp);
         this._bmp.mask = this._maskMC;
         this._count = 0;
         tf.visible = false;
         this._typeTimer.addEventListener(TimerEvent.TIMER,this.__onTypeTimerTick);
         this._typeTimer.reset();
         this._typeTimer.start();
         if(!this.animation)
         {
            SoundManager.instance.play("008");
            this._typeTimer.stop();
            this.drawFullMask();
         }
      }
      
      private function __onTypeTimerTick(e:TimerEvent) : void
      {
         if(this._count < 15)
         {
            SoundManager.instance.play("120");
         }
         while(!_text.charAt(this._count))
         {
            --this._count;
            this._typeTimer.stop();
            this.textDisplayCompleted();
         }
         this.redrawMask(this._count);
         this._count += this.TYPEDLENGTH;
      }
      
      private function drawFullMask() : void
      {
         this._typeTimer.removeEventListener(TimerEvent.TIMER,this.__onTypeTimerTick);
         this._bmp.mask = null;
         this.textDisplayCompleted();
      }
      
      private function redrawMask(location:int) : void
      {
         if(!_text.charAt(this._count))
         {
            return;
         }
         var t:String = _text.charAt(location);
         var rec:Rectangle = tf.getCharBoundaries(location);
         if(rec == null)
         {
            return;
         }
         this._maskMC.graphics.clear();
         this._maskMC.graphics.lineStyle(0);
         this._maskMC.graphics.beginFill(13421772);
         this._maskMC.graphics.moveTo(0,-4);
         this._maskMC.graphics.lineTo(0,rec.y + rec.height + 3);
         this._maskMC.graphics.lineTo(rec.x + rec.width,rec.y + rec.height + 3);
         this._maskMC.graphics.lineTo(rec.x + rec.width,rec.y - 4);
         this._maskMC.graphics.lineTo(tf.width,rec.y - 4);
         this._maskMC.graphics.lineTo(tf.width,-4);
         this._maskMC.graphics.lineTo(0,-4);
         this._maskMC.graphics.endFill();
         addChild(this._maskMC);
      }
      
      override protected function clear() : void
      {
         super.clear();
         if(Boolean(this._bmp) && Boolean(this._bmp.parent))
         {
            this._bmp.parent.removeChild(this._bmp);
         }
      }
      
      private function textDisplayCompleted() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._typeTimer))
         {
            this._typeTimer.removeEventListener(TimerEvent.TIMER,this.__onTypeTimerTick);
         }
         this.clear();
         ObjectUtils.disposeObject(this._bmdata);
         this._bmdata = null;
         this._bmp = null;
         ObjectUtils.disposeObject(this._maskMC);
         this._maskMC = null;
         super.dispose();
      }
   }
}

