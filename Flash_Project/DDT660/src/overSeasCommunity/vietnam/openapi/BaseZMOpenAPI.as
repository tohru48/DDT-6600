package overSeasCommunity.vietnam.openapi
{
   import com.pickgliss.loader.LoaderManager;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import overSeasCommunity.OverSeasCommunController;
   
   [Event(name="response",type="community.openapi.ZMRequestEvent")]
   public class BaseZMOpenAPI extends EventDispatcher
   {
      
      public static var session_id:String;
      
      public static const USER:int = 1;
      
      public static const SESSION:int = 2;
      
      public static const FEED:int = 3;
      
      public static const FRIEND:int = 4;
      
      protected var _onResponseCall:Function;
      
      private var _requestUrl:String;
      
      public function BaseZMOpenAPI(onResponseCall:Function)
      {
         super();
         this._onResponseCall = onResponseCall;
      }
      
      protected function callMethodASync(method:String, param:Dictionary) : void
      {
         this._requestUrl = OverSeasCommunController.instance().vietnamCommunityInterfacePath(method);
         this.sendRequest(param);
      }
      
      protected function creatSeessionKey() : Dictionary
      {
         var param:Dictionary = new Dictionary();
         param["session_key"] = BaseZMOpenAPI.session_id;
         return param;
      }
      
      private function sendRequest(param:Dictionary) : void
      {
         var req:ZMRequestLoader = new ZMRequestLoader(this._requestUrl,this.prepareData(param));
         req.analyzer = new ZMResponseAnalyzer(this.onRequestComplete);
         LoaderManager.Instance.startLoad(req);
      }
      
      private function prepareData(param:Dictionary) : URLVariables
      {
         var key:String = null;
         var request:URLVariables = new URLVariables();
         for(key in param)
         {
            request[key] = param[key];
         }
         return request;
      }
      
      private function onRequestComplete(analyzer:ZMResponseAnalyzer) : void
      {
         if(this._onResponseCall != null)
         {
            this._onResponseCall(analyzer.UserId > 0 ? analyzer.UserId : analyzer.result);
         }
         dispatchEvent(new ZMRequestEvent(ZMRequestEvent.RESPONSE,analyzer.result));
      }
      
      protected function uploadPhoto(image:BitmapData, param:Dictionary) : void
      {
         var url:String = OverSeasCommunController.instance().vietnamCommunityInterfacePath("UploadPhoto");
         var uploader:ZMFileUploader = new ZMFileUploader(url,image,this.prepareData(param));
         uploader.analyzer = new ZMResponseAnalyzer(this.onRequestComplete);
         LoaderManager.Instance.startLoad(uploader);
      }
   }
}

