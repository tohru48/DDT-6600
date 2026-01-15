package im
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.analyze.LoadPlayerWebsiteInfoAnalyze;
   import ddt.manager.DesktopManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   public class IMFriendPhotoCell extends Sprite
   {
      
      private var _load:Loader;
      
      private var _url:URLRequest;
      
      private var _websiteInfo:Dictionary;
      
      private var _photoFrame:Bitmap;
      
      private var _mask:Shape;
      
      private var _name:FilterFrameText;
      
      private var _userId:String;
      
      private var _loaderContext:LoaderContext;
      
      public function IMFriendPhotoCell()
      {
         super();
         buttonMode = false;
         this._load = new Loader();
         this._load.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__loadCompleteHandler);
         this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__loadIoErrorHandler);
         this._loaderContext = new LoaderContext(true);
         this._photoFrame = ComponentFactory.Instance.creatBitmap("asset.playerTip.PhotoFrame");
         this._name = ComponentFactory.Instance.creatComponentByStylename("playerTip.PhotoNameTxt");
         addChild(this._name);
         this._mask = new Shape();
         this._mask.graphics.beginFill(0,0);
         this._mask.graphics.drawRect(0,0,54,55);
         this._mask.graphics.endFill();
         if(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog())
         {
            buttonMode = true;
            this.addEvents();
         }
      }
      
      private function addEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__photoClick);
      }
      
      private function __photoClick(e:MouseEvent) : void
      {
         var redirictURL:String = null;
         SoundManager.instance.play("008");
         var url:String = PathManager.solveLoginPHP(this._userId);
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            redirictURL = "function redict () {window.open(\"" + url + "\", \"_blank\")}";
            ExternalInterface.call(redirictURL);
         }
         else
         {
            navigateToURL(new URLRequest(encodeURI(url)),"_blank");
         }
      }
      
      public function set userID(uid:String) : void
      {
         this._userId = uid;
         var loader:BaseLoader = LoaderManager.Instance.creatLoaderOriginal(PathManager.solveWebPlayerInfoPath(uid),BaseLoader.REQUEST_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         loader.analyzer = new LoadPlayerWebsiteInfoAnalyze(this.__returnWebSiteInfoHandler);
         LoadResourceManager.Instance.startLoad(loader);
         if(Boolean(this._name))
         {
            this._name.text = "";
         }
      }
      
      private function __returnWebSiteInfoHandler(action:LoadPlayerWebsiteInfoAnalyze) : void
      {
         this._websiteInfo = action.info;
         if(this._websiteInfo["tinyHeadUrl"] != null && this._websiteInfo["tinyHeadUrl"] != "")
         {
            this.loadImage(this._websiteInfo["tinyHeadUrl"]);
         }
         if(this._websiteInfo["userName"] != null && Boolean(this._websiteInfo["userName"]))
         {
            if(Boolean(this._name))
            {
               this._name.text = this._websiteInfo["userName"];
            }
         }
      }
      
      private function loadImage($url:String) : void
      {
         this._url = new URLRequest($url);
         this._load.load(this._url,this._loaderContext);
      }
      
      private function __loadCompleteHandler(evt:Event) : void
      {
         addChild(this._load.content);
         this._load.content.x = 4;
         this._load.content.y = 5;
         this._load.content.mask = this._mask;
         addChild(this._photoFrame);
         addChild(this._mask);
      }
      
      public function clearSprite() : void
      {
         while(Boolean(this.numChildren))
         {
            this.removeChildAt(0);
         }
         this.graphics.clear();
      }
      
      private function __loadIoErrorHandler(evt:IOErrorEvent) : void
      {
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__photoClick);
         if(Boolean(this._load) && Boolean(this._load.contentLoaderInfo))
         {
            this._load.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__loadCompleteHandler);
            this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__loadIoErrorHandler);
         }
         if(Boolean(this._mask) && Boolean(this._mask.parent))
         {
            this._mask.graphics.clear();
            this._mask.parent.removeChild(this._mask);
         }
         this._mask = null;
         this.clearSprite();
         if(Boolean(this._name))
         {
            this._name.dispose();
            this._name = null;
         }
         if(Boolean(this._photoFrame) && Boolean(this._photoFrame.parent))
         {
            this._photoFrame.parent.removeChild(this._photoFrame);
         }
         this._photoFrame = null;
         this._url = null;
         this._load = null;
         this._loaderContext = null;
         this._websiteInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

