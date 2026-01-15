package flashP2P.stream
{
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.ByteArray;
   import flashP2P.event.StreamEvent;
   
   public class ReadStream extends NetStream
   {
      
      public const DDT_P2P_PUBLISH_NAME:String = "DDT-P2P-PUBLISH-NAME";
      
      private var _playerID:int;
      
      public function ReadStream(connection:NetConnection, playerID:int, peerID:String = "connectToFMS")
      {
         super(connection,peerID);
         this._playerID = playerID;
         addEventListener(NetStatusEvent.NET_STATUS,this.__onStreamHandler);
         this.init();
      }
      
      protected function init() : void
      {
         publish(this.DDT_P2P_PUBLISH_NAME);
      }
      
      protected function __onStreamHandler(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetStream.Publish.Start":
         }
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function readByteArray(eventType:String, inputByteArray:ByteArray) : void
      {
         dispatchEvent(new StreamEvent(StreamEvent.DEFAULT_EVENT,eventType,inputByteArray));
      }
   }
}

