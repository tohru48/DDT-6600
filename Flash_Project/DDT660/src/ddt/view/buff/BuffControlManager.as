package ddt.view.buff
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class BuffControlManager extends EventDispatcher
   {
      
      private static var _instance:BuffControlManager;
      
      private var _buff:BuffControl;
      
      public function BuffControlManager(target:IEventDispatcher = null)
      {
         super(target);
         this._buff = new BuffControl();
      }
      
      public static function get instance() : BuffControlManager
      {
         if(!_instance)
         {
            _instance = new BuffControlManager();
         }
         return _instance;
      }
      
      public function get buff() : BuffControl
      {
         if(!this._buff)
         {
            this._buff = new BuffControl();
         }
         return this._buff;
      }
      
      public function set buff(value:BuffControl) : void
      {
         this._buff = value;
      }
   }
}

