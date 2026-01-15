package ddt.manager
{
   import ddt.interfaces.IProcessObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ProcessManager
   {
      
      private static var _ins:ProcessManager;
      
      private var _objects:Vector.<IProcessObject> = new Vector.<IProcessObject>();
      
      private var _startup:Boolean = false;
      
      private var _shape:Shape = new Shape();
      
      private var _elapsed:int;
      
      private var _virtualTime:int;
      
      public function ProcessManager()
      {
         super();
      }
      
      public static function get Instance() : ProcessManager
      {
         return _ins = _ins || new ProcessManager();
      }
      
      public function addObject(object:IProcessObject) : IProcessObject
      {
         if(!object.onProcess)
         {
            object.onProcess = true;
            this._objects.push(object);
            this.startup();
         }
         return object;
      }
      
      public function removeObject(object:IProcessObject) : IProcessObject
      {
         var idx:int = 0;
         if(object.onProcess)
         {
            object.onProcess = false;
            idx = int(this._objects.indexOf(object));
            if(idx >= 0)
            {
               this._objects.splice(idx,1);
            }
         }
         return object;
      }
      
      public function startup() : void
      {
         if(!this._startup)
         {
            this._elapsed = getTimer();
            this._shape.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._startup = true;
         }
      }
      
      private function __enterFrame(event:Event) : void
      {
         var object:IProcessObject = null;
         var now:int = getTimer();
         var rate:Number = now - this._elapsed;
         for each(object in this._objects)
         {
            object.process(rate);
         }
         this._elapsed = now;
      }
      
      public function shutdown() : void
      {
         this._shape.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._startup = false;
      }
      
      public function get running() : Boolean
      {
         return this._startup;
      }
   }
}

