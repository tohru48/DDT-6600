package overSeasCommunity.vietnam.openapi
{
   import flash.utils.Dictionary;
   
   public class ZMUserAPI extends BaseZMOpenAPI
   {
      
      public function ZMUserAPI(onResponseCall:Function = null)
      {
         super(onResponseCall);
      }
      
      public function getUserIdByUsername(username:String) : void
      {
         var param:Dictionary = new Dictionary();
         param["users"] = username;
         callMethodASync("GetUserIdByUsername",param);
      }
      
      public function getInfo(ids:String, fields:String) : void
      {
         var param:Dictionary = new Dictionary();
         param["ids"] = ids;
         param["fields"] = fields;
         callMethodASync("GetInfo",param);
      }
      
      public function getInfoByUsername(username:String, fields:String) : void
      {
         var param:Dictionary = new Dictionary();
         param["users"] = username;
         callMethodASync("GetInfoForJson",param);
      }
   }
}

