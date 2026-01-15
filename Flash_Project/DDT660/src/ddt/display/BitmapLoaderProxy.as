package ddt.display
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class BitmapLoaderProxy extends Sprite implements Disposeable
   {
      
      public static const LOADING_FINISH:String = "loadingFinish";
      
      private var _loader:BitmapLoader;
      
      private var _bitmap:Bitmap;
      
      private var _size:Rectangle;
      
      private var _isSmoothing:Boolean;
      
      public function BitmapLoaderProxy(url:String, size:Rectangle = null, isSmoothing:Boolean = false)
      {
         super();
         this._size = size;
         this._isSmoothing = isSmoothing;
         this._loader = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.onComplete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function onComplete(event:LoaderEvent) : void
      {
         if(this._loader.isSuccess)
         {
            this._bitmap = this._loader.content;
            if(Boolean(this._size))
            {
               this._bitmap.x = this._size.x;
               this._bitmap.y = this._size.y;
               this._bitmap.width = this._size.width;
               this._bitmap.height = this._size.height;
            }
            addChild(this._bitmap);
            this._bitmap.smoothing = this._isSmoothing;
            dispatchEvent(new Event(LOADING_FINISH));
         }
      }
      
      public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader = null;
         if(Boolean(this._bitmap))
         {
            removeChild(this._bitmap);
            this._bitmap.bitmapData.dispose();
            this._bitmap = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

