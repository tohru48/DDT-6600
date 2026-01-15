package flashP2P
{
   import com.pickgliss.utils.GeneralUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.ByteArray;
   import flashP2P.event.StreamEvent;
   import flashP2P.stream.ReadStream;
   import flashP2P.stream.SendStream;
   import road7th.data.DictionaryData;
   
   public class FlashP2PManager extends EventDispatcher
   {
      
      private static var _instance:FlashP2PManager;
      
      public const DDT_P2P_PUBLISH_NAME:String = "DDT-P2P-PUBLISH-NAME";
      
      public const AdobeKey:String = "rtmfp://p2p.rtmfp.net";
      
      private const CirrusAddress:String = "rtmfp://p2p.rtmfp.net";
      
      private var _netConnection:NetConnection;
      
      private var _sendStream:SendStream;
      
      private var _selfNearID:String;
      
      private var _readStreams:DictionaryData;
      
      public function FlashP2PManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : FlashP2PManager
      {
         if(_instance == null)
         {
            _instance = new FlashP2PManager();
         }
         return _instance;
      }
      
      public function connect() : void
      {
         this._netConnection = new NetConnection();
         this._netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.__netConnectionHandler);
         this._netConnection.connect(PathManager.flashP2PCirrusUrl,PathManager.flashP2PKey);
      }
      
      public function close() : void
      {
         this._netConnection.close();
      }
      
      protected function __netConnectionHandler(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetConnection.Connect.Success":
               this.connectSuccess();
               break;
            case "NetConnection.Connect.Closed":
               this.connectClosed();
               break;
            case "NetConnection.Connect.Failed":
               this.connectFailed();
         }
      }
      
      private function connectSuccess() : void
      {
         this._selfNearID = this._netConnection.nearID;
         SocketManager.Instance.out.sendPeerID(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID,this._selfNearID);
         this.initSendStream();
      }
      
      private function connectClosed() : void
      {
         this._selfNearID = "";
         SocketManager.Instance.out.sendPeerID(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID,this._selfNearID);
      }
      
      private function connectFailed() : void
      {
         this._selfNearID = "";
         SocketManager.Instance.out.sendPeerID(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID,this._selfNearID);
      }
      
      private function initSendStream() : void
      {
         this._sendStream = new SendStream(this._netConnection,NetStream.DIRECT_CONNECTIONS);
      }
      
      public function getPeerIDByPlayerID(playerID:int) : String
      {
         return null;
      }
      
      public function addReadStream(peerID:String, playerID:int) : void
      {
         var readStream:ReadStream = new ReadStream(this._netConnection,playerID,peerID);
         readStream.addEventListener(StreamEvent.DEFAULT_EVENT,this.onReadStreamHandler);
         readStream.addEventListener(NetStatusEvent.NET_STATUS,this.__onNetStatus);
         readStream.play(this.DDT_P2P_PUBLISH_NAME);
      }
      
      protected function __onNetStatus(event:NetStatusEvent) : void
      {
         ChatManager.Instance.sysChatRed(event.info.code);
      }
      
      public function sendPlivateMsg(peerID:String, toNick:String, msg:String, toId:Number = 0, isAutoReply:Boolean = false) : void
      {
         var pkg:ByteArray = new ByteArray();
         pkg.writeInt(toId);
         pkg.writeUTF(toNick);
         pkg.writeUTF(PlayerManager.Instance.Self.NickName);
         pkg.writeInt(PlayerManager.Instance.Self.ID);
         pkg.writeUTF(msg);
         pkg.writeBoolean(isAutoReply);
         if(this.getPeerIndex(peerID) != -1)
         {
            this._sendStream.peerStreams[this.getPeerIndex(peerID)].send("readByteArray",StreamEvent.PRIVATE_MSG,pkg);
         }
      }
      
      public function sendLookPlayerInfo(peerID:String) : void
      {
         var pkg:ByteArray = new ByteArray();
         pkg.writeUTF(peerID);
         if(this.getPeerIndex(peerID) != -1)
         {
            this._sendStream.peerStreams[this.getPeerIndex(peerID)].send("readByteArray",StreamEvent.LOOK_PLAYER_INFO,pkg);
         }
      }
      
      public function sendShowPlayerInfo(peerID:String, self:SelfInfo) : void
      {
         var selfObj:Object = GeneralUtils.serializeObject(self);
         var pkg:ByteArray = new ByteArray();
         pkg.writeUTF(peerID);
         pkg.writeObject(selfObj);
         if(this.getPeerIndex(peerID) != -1)
         {
            this._sendStream.peerStreams[this.getPeerIndex(peerID)].send("readByteArray",StreamEvent.SHOW_PLAYER_INFO,pkg);
         }
      }
      
      public function getPeerIndex(peerID:String) : int
      {
         for(var i:int = 0; i < this._sendStream.peerStreams.length; i++)
         {
            if(this._sendStream.peerStreams[i].nearID == peerID)
            {
               return i;
            }
         }
         return -1;
      }
      
      protected function onReadStreamHandler(event:StreamEvent) : void
      {
         switch(event.eventType)
         {
            case StreamEvent.PRIVATE_MSG:
               dispatchEvent(new StreamEvent(StreamEvent.PRIVATE_MSG,"",event.readByteArray));
               break;
            case StreamEvent.LOOK_PLAYER_INFO:
               dispatchEvent(new StreamEvent(StreamEvent.LOOK_PLAYER_INFO,"",event.readByteArray));
               break;
            case StreamEvent.SHOW_PLAYER_INFO:
               dispatchEvent(new StreamEvent(StreamEvent.SHOW_PLAYER_INFO,"",event.readByteArray));
         }
      }
   }
}

