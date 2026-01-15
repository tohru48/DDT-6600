package fightLib.command
{
   import fightLib.FightLibCommandEvent;
   import fightLib.IFightLibCommand;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BaseFightLibCommand implements IFightLibCommand
   {
      
      protected var _dispather:EventDispatcher;
      
      private var _excuteFunArr:Array;
      
      protected var _completeFunArr:Array;
      
      protected var _prepareFun:Function;
      
      protected var _undoFunArr:Array;
      
      public function BaseFightLibCommand()
      {
         super();
         this._dispather = new EventDispatcher();
         this._excuteFunArr = new Array();
         this._completeFunArr = new Array();
         this._undoFunArr = new Array();
      }
      
      public function set completeFunArr(value:Array) : void
      {
         this._completeFunArr = value;
      }
      
      public function get completeFunArr() : Array
      {
         return this._completeFunArr;
      }
      
      public function get prepareFun() : Function
      {
         return this._prepareFun;
      }
      
      public function set prepareFun(value:Function) : void
      {
         this._prepareFun = value;
      }
      
      public function excute() : void
      {
         var fun:Function = null;
         for each(fun in this._excuteFunArr)
         {
            fun();
         }
      }
      
      public function finish() : void
      {
         var fun:Function = null;
         if(this._completeFunArr == null)
         {
            return;
         }
         for each(fun in this._completeFunArr)
         {
            fun();
         }
         this.dispatchEvent(new FightLibCommandEvent(FightLibCommandEvent.FINISH));
      }
      
      public function undo() : void
      {
         var fun:Function = null;
         for each(fun in this._undoFunArr)
         {
            fun();
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this._dispather.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this._dispather.removeEventListener(type,listener,useCapture);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this._dispather.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this._dispather.hasEventListener(type);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this._dispather.willTrigger(type);
      }
      
      public function get undoFunArr() : Array
      {
         return this._undoFunArr;
      }
      
      public function set undoFunArr(value:Array) : void
      {
         this._undoFunArr = value;
      }
      
      public function dispose() : void
      {
         this._dispather = null;
         this._excuteFunArr = null;
         this._completeFunArr = null;
         this._prepareFun = null;
         this._undoFunArr = null;
      }
      
      public function get excuteFunArr() : Array
      {
         return this._excuteFunArr;
      }
      
      public function set excuteFunArr(value:Array) : void
      {
         this._excuteFunArr = value;
      }
   }
}

