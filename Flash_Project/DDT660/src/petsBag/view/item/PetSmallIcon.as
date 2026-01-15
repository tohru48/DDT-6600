package petsBag.view.item
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
   
   public class PetSmallIcon extends Sprite implements Disposeable
   {
      
      protected var _loader:DisplayLoader;
      
      protected var _icon:Bitmap;
      
      protected var _petPic:String;
      
      public function PetSmallIcon(petPic:String = "")
      {
         super();
         this._petPic = !petPic || petPic.length == 0 ? "1" : petPic;
      }
      
      public function startLoad() : void
      {
         this.loadIcon();
      }
      
      protected function loadIcon() : void
      {
         if(this._petPic.length == 0)
         {
            return;
         }
         this._loader = LoadResourceManager.Instance.createLoader(PathManager.solvePetIconUrl(this._petPic),BaseLoader.BITMAP_LOADER);
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
               this._icon.smoothing = true;
            }
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get icon() : Bitmap
      {
         return this._icon;
      }
      
      public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         ObjectUtils.disposeObject(this._loader);
         this._loader = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

