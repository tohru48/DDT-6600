package ddt.loader
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.MapInfo;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MapLoader extends EventDispatcher
   {
      
      private var _info:MapInfo;
      
      private var _back:Bitmap;
      
      private var _fore:Bitmap;
      
      private var _dead:Bitmap;
      
      private var _middle:DisplayObject;
      
      private var _loaderBack:DisplayLoader;
      
      private var _loaderFore:DisplayLoader;
      
      private var _loaderDead:DisplayLoader;
      
      private var _loaderMiddle:DisplayLoader;
      
      private var _count:int;
      
      private var _total:int;
      
      private var _loadCompleted:Boolean;
      
      public function MapLoader(info:MapInfo)
      {
         super();
         this._info = info;
      }
      
      public function get info() : MapInfo
      {
         return this._info;
      }
      
      public function get backBmp() : Bitmap
      {
         return this._back;
      }
      
      public function get foreBmp() : Bitmap
      {
         return this._fore;
      }
      
      public function get deadBmp() : Bitmap
      {
         return this._dead;
      }
      
      public function get middle() : DisplayObject
      {
         return this._middle;
      }
      
      public function get completed() : Boolean
      {
         return this._loadCompleted;
      }
      
      public function load() : void
      {
         this._count = 0;
         this._total = 0;
         this._loadCompleted = false;
         if(this._info.DeadPic != "")
         {
            ++this._total;
            this._loaderDead = LoadResourceManager.Instance.createLoader(PathManager.solveMapPath(this._info.ID,this._info.DeadPic,"png"),BaseLoader.BITMAP_LOADER);
            this._loaderDead.addEventListener(LoaderEvent.COMPLETE,this.__deadComplete);
            LoadResourceManager.Instance.startLoad(this._loaderDead);
         }
         if(this._info.ForePic != "")
         {
            ++this._total;
            this._loaderFore = LoadResourceManager.Instance.createLoader(PathManager.solveMapPath(this._info.ID,this._info.ForePic,"png"),BaseLoader.BITMAP_LOADER);
            this._loaderFore.addEventListener(LoaderEvent.COMPLETE,this.__foreComplete);
            LoadResourceManager.Instance.startLoad(this._loaderFore);
         }
         ++this._total;
         this._loaderBack = LoadResourceManager.Instance.createLoader(PathManager.solveMapPath(this._info.ID,this._info.BackPic,"jpg"),BaseLoader.BITMAP_LOADER);
         this._loaderBack.addEventListener(LoaderEvent.COMPLETE,this.__backComplete);
         LoadResourceManager.Instance.startLoad(this._loaderBack);
      }
      
      private function __backComplete(evt:LoaderEvent) : void
      {
         var loader:DisplayLoader = evt.target as DisplayLoader;
         if(loader.isSuccess)
         {
            this._back = loader.content as Bitmap;
            if(this._back != null)
            {
               this.count();
            }
         }
      }
      
      private function __middleComplete(evt:LoaderEvent) : void
      {
         var loader:DisplayLoader = evt.target as DisplayLoader;
         if(loader.isSuccess)
         {
            this._middle = loader.content;
         }
         this.count();
      }
      
      private function __foreComplete(evt:LoaderEvent) : void
      {
         evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__foreComplete);
         if(evt.loader.isSuccess)
         {
            this._fore = evt.loader.content as Bitmap;
            if(this._fore != null)
            {
               this.count();
            }
         }
      }
      
      private function __deadComplete(evt:LoaderEvent) : void
      {
         evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__deadComplete);
         if(evt.loader.isSuccess)
         {
            this._dead = evt.loader.content as Bitmap;
            if(this._dead != null)
            {
               this.count();
            }
         }
      }
      
      private function count() : void
      {
         ++this._count;
         if(this._count == this._total)
         {
            this._loadCompleted = true;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function dispose() : void
      {
         this._info = null;
         ObjectUtils.disposeObject(this._back);
         if(Boolean(this._back))
         {
            this._back = null;
         }
         ObjectUtils.disposeObject(this._dead);
         if(Boolean(this._dead))
         {
            this._dead = null;
         }
         ObjectUtils.disposeObject(this._fore);
         if(Boolean(this._fore))
         {
            this._fore = null;
         }
         if(Boolean(this._loaderBack))
         {
            this._loaderBack.removeEventListener(LoaderEvent.COMPLETE,this.__backComplete);
         }
         if(Boolean(this._loaderDead))
         {
            this._loaderDead.removeEventListener(LoaderEvent.COMPLETE,this.__deadComplete);
         }
         if(Boolean(this._loaderFore))
         {
            this._loaderFore.removeEventListener(LoaderEvent.COMPLETE,this.__foreComplete);
         }
         if(Boolean(this._loaderMiddle))
         {
            this._loaderMiddle.removeEventListener(LoaderEvent.COMPLETE,this.__middleComplete);
         }
         this._loaderBack = null;
         this._loaderDead = null;
         this._loaderFore = null;
         this._loaderMiddle = null;
      }
   }
}

