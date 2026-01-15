package game.view.control
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import game.model.LocalPlayer;
   
   public class FightControlBar implements Disposeable
   {
      
      public static const LIVE:int = 0;
      
      public static const SOUL:int = 1;
      
      private var _statePool:Object = new Object();
      
      private var _self:LocalPlayer;
      
      private var _state:int;
      
      private var _container:DisplayObjectContainer;
      
      private var _current:ControlState;
      
      private var _next:ControlState;
      
      public function FightControlBar(self:LocalPlayer, container:DisplayObjectContainer)
      {
         this._self = self;
         this._container = container;
         this.configUI();
         this.addEvent();
         super();
      }
      
      private static function getFightControlState(state:int, self:LocalPlayer) : ControlState
      {
         switch(state)
         {
            case LIVE:
               return new LiveState(self);
            case SOUL:
               return new SoulState(self);
            default:
               return null;
         }
      }
      
      private function configUI() : void
      {
      }
      
      private function addEvent() : void
      {
      }
      
      private function __die(event:LivingEvent) : void
      {
         this.setState(SOUL);
      }
      
      private function removeEvent() : void
      {
      }
      
      public function setState(state:int) : ControlState
      {
         var cs:ControlState = null;
         if(!this.hasState(state))
         {
            cs = getFightControlState(state,this._self);
            this._statePool[String(state)] = this._next = cs;
         }
         else
         {
            this._next = this._statePool[String(state)];
         }
         if(this._current == this._next)
         {
            this._next = null;
            return this._current;
         }
         if(this._current != null)
         {
            this._current.leaving(this.leavingComplete);
         }
         else
         {
            this.enterNext(this._next);
         }
         return this._current;
      }
      
      private function hasState(state:int) : Boolean
      {
         return Boolean(this._statePool.hasOwnProperty(String(state))) && Boolean(this._statePool[String(state)]);
      }
      
      private function enterNext(next:ControlState) : void
      {
         if(Boolean(next))
         {
            this._current = next;
         }
         if(Boolean(this._current))
         {
            this._current.enter(this._container);
         }
         this._next = null;
      }
      
      private function __stateClicked(event:MouseEvent) : void
      {
         this.setState(SOUL);
      }
      
      private function leavingComplete() : void
      {
         this.enterNext(this._next);
      }
      
      private function enterComplete() : void
      {
      }
      
      public function dispose() : void
      {
         var key:String = null;
         this.removeEvent();
         for(key in this._statePool)
         {
            ObjectUtils.disposeObject(this._statePool[key]);
            delete this._statePool[key];
         }
      }
   }
}

