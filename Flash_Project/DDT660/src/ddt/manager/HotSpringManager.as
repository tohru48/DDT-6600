package ddt.manager
{
   import ddt.data.Experience;
   import ddt.data.HotSpringRoomInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class HotSpringManager extends EventDispatcher
   {
      
      private static var _instance:HotSpringManager;
      
      private var _roomCurrently:HotSpringRoomInfo;
      
      private var _playerEffectiveTime:int;
      
      private var _playerEnterRoomTime:Date;
      
      public var messageTip:String;
      
      private var _isRemoveLoading:Boolean = true;
      
      public function HotSpringManager()
      {
         super();
      }
      
      public static function get instance() : HotSpringManager
      {
         if(!_instance)
         {
            _instance = new HotSpringManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,this.roomEnterSucceed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,this.roomPlayerRemove);
      }
      
      public function roomPlayerRemove(event:CrazyTankSocketEvent = null) : void
      {
         var pkg:PackageIn = event.pkg;
         var msg:String = pkg.readUTF();
         this.roomCurrently = null;
         if(PlayerManager.Instance.Self.Grade < Experience.MAX_LEVEL)
         {
            if(msg && msg != "" && msg.length > 0)
            {
               ChatManager.Instance.sysChatYellow(msg);
               MessageTipManager.getInstance().show(msg);
            }
         }
         if(this.messageTip && this.messageTip != "" && this.messageTip.length > 0)
         {
            ChatManager.Instance.sysChatYellow(this.messageTip);
            MessageTipManager.getInstance().show(this.messageTip);
         }
      }
      
      public function get roomCurrently() : HotSpringRoomInfo
      {
         return this._roomCurrently;
      }
      
      public function set roomCurrently(value:HotSpringRoomInfo) : void
      {
         if(Boolean(value) && (!this._roomCurrently || this._roomCurrently.roomID != value.roomID))
         {
            this._roomCurrently = value;
            this.roomEnter();
            return;
         }
         this._roomCurrently = value;
      }
      
      private function roomEnterSucceed(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var hotSpringRoomInfo:HotSpringRoomInfo = new HotSpringRoomInfo();
         hotSpringRoomInfo.roomID = pkg.readInt();
         hotSpringRoomInfo.roomNumber = pkg.readInt();
         hotSpringRoomInfo.roomName = pkg.readUTF();
         hotSpringRoomInfo.roomPassword = pkg.readUTF();
         hotSpringRoomInfo.effectiveTime = pkg.readInt();
         hotSpringRoomInfo.curCount = pkg.readInt();
         hotSpringRoomInfo.playerID = pkg.readInt();
         hotSpringRoomInfo.playerName = pkg.readUTF();
         hotSpringRoomInfo.startTime = pkg.readDate();
         hotSpringRoomInfo.roomIntroduction = pkg.readUTF();
         hotSpringRoomInfo.roomType = pkg.readInt();
         hotSpringRoomInfo.maxCount = pkg.readInt();
         this._playerEnterRoomTime = pkg.readDate();
         this._playerEffectiveTime = pkg.readInt();
         this.roomCurrently = hotSpringRoomInfo;
      }
      
      private function roomEnter() : void
      {
         if(StateManager.getState(StateType.HOT_SPRING_ROOM) == null)
         {
            this._isRemoveLoading = false;
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsClose);
         }
         StateManager.setState(StateType.HOT_SPRING_ROOM);
      }
      
      private function __loadingIsClose(event:Event) : void
      {
         this._isRemoveLoading = true;
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         SocketManager.Instance.out.sendHotSpringRoomPlayerRemove();
      }
      
      public function removeLoadingEvent() : void
      {
         if(!this._isRemoveLoading)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         }
      }
      
      public function get playerEffectiveTime() : int
      {
         return this._playerEffectiveTime;
      }
      
      public function set playerEffectiveTime(value:int) : void
      {
         this._playerEffectiveTime = value;
      }
      
      public function get playerEnterRoomTime() : Date
      {
         return this._playerEnterRoomTime;
      }
      
      public function set playerEnterRoomTime(value:Date) : void
      {
         this._playerEnterRoomTime = value;
      }
   }
}

