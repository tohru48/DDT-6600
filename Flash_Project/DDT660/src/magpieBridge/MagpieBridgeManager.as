package magpieBridge
{
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddtBuried.data.MapItemData;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import magpieBridge.data.MagpieModel;
   import magpieBridge.event.MagpieBridgeEvent;
   import road7th.comm.PackageIn;
   
   public class MagpieBridgeManager extends EventDispatcher
   {
      
      private static var _instance:MagpieBridgeManager;
      
      private var _magpieModel:MagpieModel;
      
      public var _isOpen:Boolean;
      
      private var _hallView:HallStateView;
      
      private var _magpieBtn:MovieClip;
      
      public function MagpieBridgeManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : MagpieBridgeManager
      {
         if(!_instance)
         {
            _instance = new MagpieBridgeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._magpieModel = new MagpieModel();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.OPEN,this.__onOpen);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.ENTER_MAGPIEBRIDGE,this.__onEnterView);
      }
      
      protected function __onOpen(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._isOpen = pkg.readBoolean();
         this.initIcon(this._isOpen);
      }
      
      public function initIcon(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.MAGPIEBRIDGE,flag);
      }
      
      protected function __onEnterView(event:MagpieBridgeEvent) : void
      {
         var data:MapItemData = null;
         this._magpieModel.MapDataVec = new Vector.<MapItemData>();
         var pkg:PackageIn = event.pkg;
         this._magpieModel.MapId = pkg.readInt() - 1;
         this._magpieModel.NowPosition = pkg.readInt();
         this._magpieModel.LastNum = pkg.readInt();
         this._magpieModel.MagpieNum = pkg.readInt();
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            data = new MapItemData();
            data.type = pkg.readInt();
            data.tempID = pkg.readInt();
            this._magpieModel.MapDataVec.push(data);
         }
         StateManager.setState(StateType.MAGPIEBRIDGE);
      }
      
      public function get magpieModel() : MagpieModel
      {
         return this._magpieModel;
      }
   }
}

