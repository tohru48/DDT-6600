package overSeasCommunity.vietnam.openapi
{
   public class ZMFriendAPI extends BaseZMOpenAPI
   {
      
      public function ZMFriendAPI(onResponseCall:Function = null)
      {
         super(onResponseCall);
      }
      
      public function getAppUsers() : void
      {
         callMethodASync("GetAppUsers",creatSeessionKey());
      }
      
      public function getLists() : void
      {
         callMethodASync("GetFriendsList",creatSeessionKey());
      }
   }
}

