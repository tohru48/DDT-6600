package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class SevenDoubleEscortManager extends EventDispatcher
   {
      
      private static var _instance:SevenDoubleEscortManager;
      
      private var _tag:int;
      
      public function SevenDoubleEscortManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : SevenDoubleEscortManager
      {
         if(_instance == null)
         {
            _instance = new SevenDoubleEscortManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVEN_DOUBLE_ESCORT,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var tmpTag:int = 0;
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         if(cmd == 1)
         {
            tmpTag = pkg.readInt();
            if(pkg.readBoolean())
            {
               this._tag = tmpTag;
            }
            pkg.position -= 5;
         }
         pkg.position -= 1;
         if(this._tag == 1)
         {
            SocketManager.Instance.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVEN_DOUBLE,pkg));
         }
         else if(this._tag == 2)
         {
            SocketManager.Instance.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ESCORT,pkg));
         }
         else if(this._tag == 3)
         {
            SocketManager.Instance.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DRGN_BAOT,pkg));
         }
      }
   }
}

