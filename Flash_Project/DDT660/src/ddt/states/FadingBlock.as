package ddt.states
{
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.StateManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FadingBlock extends Sprite
   {
      
      private var _func:Function;
      
      private var _life:Number;
      
      private var _exected:Boolean;
      
      private var _nextView:BaseStateView;
      
      private var _showLoading:Function;
      
      private var _newStart:Boolean;
      
      private var _showed:Boolean;
      
      private var _canSave:Boolean;
      
      public function FadingBlock(func:Function, showLoading:Function)
      {
         super();
         this._func = func;
         this._showLoading = showLoading;
         this._life = 0;
         this._newStart = true;
         this._canSave = true;
         graphics.beginFill(0);
         graphics.drawRect(0,0,1008,608);
         graphics.endFill();
      }
      
      public function setNextState(next:BaseStateView) : void
      {
         this._nextView = next;
         this._canSave = StateManager.currentStateType != StateType.LOGIN;
      }
      
      public function update() : void
      {
         if(parent == null)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,0,false);
         }
         if(this._newStart)
         {
            if(!StateManager.isShowFadingAnimation)
            {
               this._func();
               if(Boolean(parent))
               {
                  parent.removeChild(this);
               }
               dispatchEvent(new Event(Event.COMPLETE));
               this._nextView.fadingComplete();
               return;
            }
            alpha = 0;
            this._life = 0;
            this._exected = false;
            this._showed = false;
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
         else
         {
            this._life = 1;
            alpha = this._life;
            this._exected = false;
         }
         this._newStart = false;
      }
      
      public function stopImidily() : void
      {
         parent.removeChild(this);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._newStart = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function set executed(value:Boolean) : void
      {
         this._exected = value;
      }
      
      private function __enterFrame(event:Event) : void
      {
         var tick:int = 0;
         var time:Number = NaN;
         if(this._life < 1)
         {
            this._life += 0.16;
            alpha = this._life;
         }
         else if(this._life < 2)
         {
            tick = getTimer();
            if(this._canSave)
            {
               LoaderSavingManager.saveFilesToLocal();
            }
            tick = getTimer() - tick;
            time = tick / 40 * 0.1;
            this._life += time < 0.1 ? 0.1 : time;
            if(this._life > 2)
            {
               this._life = 2.01;
            }
            if(!this._exected)
            {
               this._exected = true;
               alpha = 1;
               this._func();
            }
         }
         else if(this._life >= 2)
         {
            this._life += 0.16;
            alpha = 3 - this._life;
            if(alpha < 0.2)
            {
               if(Boolean(parent))
               {
                  parent.removeChild(this);
               }
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
               this._newStart = true;
               dispatchEvent(new Event(Event.COMPLETE));
               this._nextView.fadingComplete();
            }
         }
      }
   }
}

