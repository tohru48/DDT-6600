package overSeasCommunity.vietnam.openapi
{
   import flash.net.URLVariables;
   
   public class ZMOpenAPIHelper
   {
      
      public function ZMOpenAPIHelper()
      {
         super();
      }
      
      public static function getKeys(d:*) : Array
      {
         var key:Object = null;
         var a:Array = new Array();
         for(key in d)
         {
            a.push(key);
         }
         return a;
      }
      
      public static function solveRequestPath(path:String, args:URLVariables) : String
      {
         var key:String = null;
         var params:String = "?";
         for(key in args)
         {
            params += key + "=" + args[key] + "&";
         }
         return path + params;
      }
   }
}

