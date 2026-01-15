package overSeasCommunity.vietnam.openapi
{
   public class ZMSessionAPI extends BaseZMOpenAPI
   {
      
      public function ZMSessionAPI(onResponseCall:Function = null)
      {
         super(onResponseCall);
      }
      
      public function getLoggedInUser(session_key:String) : void
      {
         callMethodASync("GetUserLoggedInUser",creatSeessionKey());
      }
   }
}

