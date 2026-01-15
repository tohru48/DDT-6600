package flashP2P.stream
{
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public class SendStream extends NetStream
   {
      
      public const DDT_P2P_PUBLISH_NAME:String = "DDT-P2P-PUBLISH-NAME";
      
      private var _playerID:int;
      
      public function SendStream(connection:NetConnection, peerID:String = "connectToFMS")
      {
         super(connection,peerID);
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
   }
}

