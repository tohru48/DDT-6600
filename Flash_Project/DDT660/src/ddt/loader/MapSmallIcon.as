package ddt.loader
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapSmallIcon extends Sprite implements Disposeable
   {
      
      protected var _loader:DisplayLoader;
      
      protected var _icon:Bitmap;
      
      protected var _mapID:int = 0;
      
      public function MapSmallIcon(mapID:int = 9999999)
      {
         this._mapID = mapID;
         super();
      }
      
      public function startLoad() : void
      {
         this.loadIcon();
      }
      
      protected function loadIcon() : void
      {
         if(this.id == 9999999)
         {
            return;
         }
         this._loader = LoadResourceManager.Instance.createLoader(PathManager.solveMapIconPath(this._mapID,0),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function __complete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         if(event.loader.isSuccess)
         {
            this._icon = event.loader.content;
            if(Boolean(this._icon))
            {
               addChild(this._icon);
            }
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function set id(i:int) : void
      {
         this._mapID = i;
         this.loadIcon();
      }
      
      public function get id() : int
      {
         return this._mapID;
      }
      
      public function get icon() : Bitmap
      {
         return this._icon;
      }
      
      public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         this._loader = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

