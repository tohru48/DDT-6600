package overSeasCommunity.vietnam.openapi
{
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.RequestLoader;
   import flash.net.URLVariables;
   
   public class ZMRequestLoader extends RequestLoader
   {
      
      public function ZMRequestLoader(url:String, args:URLVariables = null)
      {
         var id:int = LoaderManager.Instance.getNextLoaderID();
         super(id,url,args,"POST");
      }
   }
}

