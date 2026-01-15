package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ChatBallBase extends Sprite implements Disposeable
   {
      
      protected var POP_REPEAT:int = 1;
      
      protected var POP_DELAY:int = 2300;
      
      protected var paopaoMC:MovieClip;
      
      protected var _popupTimer:Timer;
      
      protected var _chatballBackground:ChatBallBackground;
      
      protected var _field:ChatBallTextAreaBase;
      
      public function ChatBallBase()
      {
         super();
         this._popupTimer = new Timer(this.POP_DELAY,this.POP_REPEAT);
         this.hide();
      }
      
      public function setText(content:String, chatball:int = 0) : void
      {
      }
      
      protected function get field() : ChatBallTextAreaBase
      {
         return this._field;
      }
      
      public function set direction(value:Point) : void
      {
         this.paopao.direction = value;
         this.fitSize(this.field);
      }
      
      public function set directionX(value:Number) : void
      {
         this.direction = new Point(value,this.paopao.direction.y);
      }
      
      public function set directionY(value:Number) : void
      {
         this.direction = new Point(this.paopao.direction.x,value);
      }
      
      protected function get paopao() : ChatBallBackground
      {
         return this._chatballBackground;
      }
      
      protected function fitSize(field:MovieClip) : void
      {
         this.paopao.fitSize(new Point(field.width,field.height));
         field.x = this.paopao.textArea.x;
         field.y = this.paopao.textArea.y;
         if(this.paopao.textArea.width / field.width > this.paopao.textArea.height / field.height)
         {
            field.x = this.paopao.textArea.x + (this.paopao.textArea.width - field.width) / 2;
         }
         else
         {
            field.y = this.paopao.textArea.y + (this.paopao.textArea.height - field.height) / 2;
         }
         addChild(field);
      }
      
      protected function beginPopDelay() : void
      {
         this._popupTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer,false,0,true);
         this._popupTimer.reset();
         this._popupTimer.start();
      }
      
      protected function __onPopupTimer(e:TimerEvent) : void
      {
         this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
         this._popupTimer.stop();
         this.hide();
      }
      
      public function hide() : void
      {
         visible = false;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function show() : void
      {
         visible = true;
      }
      
      public function clear() : void
      {
         this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
         this._popupTimer.stop();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._popupTimer))
         {
            this._popupTimer.stop();
            this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
            this._popupTimer = null;
         }
         if(Boolean(this.paopao) && Boolean(this.paopao.parent))
         {
            this.removeChild(this.paopao);
         }
         if(Boolean(this._field))
         {
            this._field.dispose();
         }
         this._field = null;
         if(Boolean(this._chatballBackground))
         {
            this._chatballBackground.dispose();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

