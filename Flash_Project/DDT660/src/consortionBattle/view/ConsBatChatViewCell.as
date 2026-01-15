package consortionBattle.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConsBatChatViewCell extends Sprite implements Disposeable
   {
      
      public static const GUARD_COMPLETE:String = "ConsBatChatViewCell_Guard_Complete";
      
      public static const DISAPPEAR_COMPLETE:String = "ConsBatChatViewCell_Disappear_Complete";
      
      private var _txt:FilterFrameText;
      
      private var _isGuard:Boolean;
      
      private var _isActive:Boolean;
      
      private var _timer:Timer;
      
      private var _existCount:int;
      
      private var _index:int;
      
      public function ConsBatChatViewCell()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.chatView.cellTxt");
         addChild(this._txt);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      public function get isGuard() : Boolean
      {
         return this._isGuard;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         this._index = value;
         y = this._index * 30;
      }
      
      public function set existCount(value:int) : void
      {
         this._existCount = value;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         ++this._existCount;
         if(this._existCount >= 2)
         {
            this._isGuard = false;
            dispatchEvent(new Event(GUARD_COMPLETE));
         }
         if(this._existCount >= 5)
         {
            this._timer.stop();
            TweenLite.to(this._txt,0.5,{
               "alpha":0,
               "onComplete":this.disappearCompleteHandler
            });
         }
      }
      
      private function disappearCompleteHandler() : void
      {
         this._isActive = false;
         this.setText("");
         dispatchEvent(new Event(DISAPPEAR_COMPLETE));
      }
      
      public function setText(value:String, existCount:int = 0) : void
      {
         if(!value || value == "")
         {
            this._timer.stop();
            this._isGuard = false;
            this._isActive = false;
            this._txt.text = "";
         }
         else
         {
            TweenLite.killTweensOf(this._txt);
            this._txt.text = value;
            this._txt.alpha = 1;
            this._isGuard = true;
            this._isActive = true;
            this._existCount = existCount;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
            this._timer = null;
         }
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

