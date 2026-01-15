package overSeasCommunity.vietnam.openapi
{
   import com.adobe.images.JPGEncoder;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   [Event(name="complete",type="flash.events.Event")]
   public class ZMFileUploader extends BaseLoader
   {
      
      private static const TRY_UPLOAD_TIMES:int = 1;
      
      private var _uploadData:*;
      
      private var _currentTryTime:int = 0;
      
      public function ZMFileUploader(url:String, data:*, args:URLVariables = null)
      {
         var id:int = LoaderManager.Instance.getNextLoaderID();
         url = ZMOpenAPIHelper.solveRequestPath(url,args);
         super(id,url,args,"POST");
         this._uploadData = data;
      }
      
      override protected function startLoad(path:String) : void
      {
         if(_isLoading)
         {
            return;
         }
         _currentLoadPath = path;
         _loader.dataFormat = getLoadDataFormat();
         _request = new URLRequest(path);
         _request.method = _requestMethod;
         _request.contentType = "application/octet-stream";
         _request.data = this.encode2Bytes(this._uploadData);
         _isLoading = true;
         _loader.load(_request);
         _starTime = getTimer();
      }
      
      override protected function onLoadError() : void
      {
         if(this._currentTryTime < TRY_UPLOAD_TIMES)
         {
            ++this._currentTryTime;
            _isLoading = false;
            this.startLoad(_currentLoadPath);
         }
         else
         {
            removeEvent();
            _loader.close();
            _isComplete = true;
            _isLoading = false;
            _isSuccess = false;
            dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,this));
            dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,this));
         }
      }
      
      override protected function __onDataLoadComplete(event:Event) : void
      {
         removeEvent();
         _loader.close();
         if(Boolean(analyzer))
         {
            analyzer.analyzeCompleteCall = fireCompleteEvent;
            analyzer.analyzeErrorCall = fireErrorEvent;
            analyzer.analyze(_loader.data);
         }
         else
         {
            fireCompleteEvent();
         }
      }
      
      private function encode2Bytes(data:*) : ByteArray
      {
         var bytes:ByteArray = null;
         if(data is BitmapData)
         {
            bytes = new JPGEncoder(80).encode(data);
         }
         return bytes;
      }
   }
}

