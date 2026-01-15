package Dice
{
   import Dice.Controller.DiceController;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class DiceManager extends EventDispatcher
   {
      
      private static var _instance:DiceManager;
      
      private var _callBack:Function;
      
      private var _isopen:Boolean = false;
      
      public function DiceManager(target:IEventDispatcher = null)
      {
         super(target);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DICE_ACTIVE_OPEN,this.__showEnterIcon);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DICE_ACTIVE_CLOSE,this.__hideEnterIcon);
      }
      
      public static function get Instance() : DiceManager
      {
         if(_instance == null)
         {
            _instance = new DiceManager();
         }
         return _instance;
      }
      
      public function setup(callBack:Function = null) : void
      {
         if(callBack != null)
         {
            this._callBack = callBack;
            if(DiceController.Instance.canUseModel)
            {
               this._callBack(true);
            }
         }
      }
      
      public function get isopen() : Boolean
      {
         return this._isopen;
      }
      
      public function __showEnterIcon(event:CrazyTankSocketEvent) : void
      {
         this._isopen = true;
         DiceController.Instance.install(event.pkg);
         if(this._callBack != null)
         {
            this._callBack(true);
         }
      }
      
      public function EnterDice() : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendRequestEnterDiceSystem();
      }
      
      private function __hideEnterIcon(event:CrazyTankSocketEvent) : void
      {
         this._isopen = false;
         if(this._callBack != null)
         {
            this._callBack(false);
            DiceController.Instance.unInstall();
         }
      }
   }
}

