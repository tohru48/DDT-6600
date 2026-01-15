package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class ShineSelectButton extends SelectedButton
   {
      
      private var _shineBg:DisplayObject;
      
      private var _textField:TextField;
      
      private var _timer:Timer;
      
      private var _delay:int = 200;
      
      public function ShineSelectButton()
      {
         this._timer = new Timer(this._delay);
         super();
      }
      
      public function set delay(value:int) : void
      {
         this._delay = value;
      }
      
      public function set shineStyle(value:String) : void
      {
         if(Boolean(this._shineBg))
         {
            ObjectUtils.disposeObject(this._shineBg);
         }
         this._shineBg = ComponentFactory.Instance.creat(value);
         this._shineBg.visible = false;
      }
      
      public function set textStyle(value:String) : void
      {
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = ComponentFactory.Instance.creat(value);
      }
      
      public function set text(value:String) : void
      {
         if(Boolean(this._textField))
         {
            this._textField.text = value;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._shineBg))
         {
            addChild(this._shineBg);
         }
         if(Boolean(this._textField))
         {
            addChild(this._textField);
         }
      }
      
      public function shine() : void
      {
         this._timer.reset();
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this._timer.start();
      }
      
      public function stopShine() : void
      {
         if(Boolean(this._timer) && this._timer.running)
         {
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer.stop();
            this._shineBg.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         if(Boolean(this._shineBg))
         {
            ObjectUtils.disposeObject(this._shineBg);
            this._shineBg = null;
         }
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
         }
         super.dispose();
      }
      
      private function __onTimer(evt:TimerEvent) : void
      {
         this._shineBg.visible = this._timer.currentCount % 2 == 1;
      }
   }
}

