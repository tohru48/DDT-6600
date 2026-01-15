package effortView.rightView
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortIconView extends Sprite implements Disposeable
   {
      
      public static const ICON_SIZE:int = 50;
      
      private var _loadingasset:MovieClip;
      
      private var _iconUrl:String;
      
      private var _icon:Bitmap;
      
      private var _loader:DisplayLoader;
      
      private var _bg:Bitmap;
      
      private var _iconPos:Point;
      
      private var _loadingPos:Point;
      
      public function EffortIconView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.Effort.iconBg");
         this._bg.smoothing = true;
         addChild(this._bg);
         this._loadingasset = ComponentFactory.Instance.creat("bagAndInfo.cell.BaseCellLoadingAsset");
         this._loadingPos = ComponentFactory.Instance.creatCustomObject("effortView.EffortIconView.EffortIconLoadingassetPos");
         this._loadingasset.x = this._loadingPos.x;
         this._loadingasset.y = this._loadingPos.y;
         this._iconPos = ComponentFactory.Instance.creatCustomObject("effortView.EffortIconView.iconPos");
         addChild(this._loadingasset);
      }
      
      public function set iconUrl(iconUrl:String) : void
      {
         if(this._iconUrl == iconUrl)
         {
            return;
         }
         ObjectUtils.disposeObject(this._icon);
         DisplayUtils.clearChildren(this);
         addChild(this._bg);
         addChild(this._loadingasset);
         this._iconUrl = iconUrl;
         this.loadIcon();
      }
      
      protected function loadIcon() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         }
         this._loader = LoadResourceManager.Instance.createLoader(PathManager.solveEffortIconPath(this._iconUrl),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function __complete(event:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         ObjectUtils.disposeObject(this._icon);
         if(event.loader.isSuccess)
         {
            this._icon = event.loader.content as Bitmap;
            this._icon.x = this._iconPos.x;
            this._icon.y = this._iconPos.y;
            this._icon.smoothing = true;
            addChild(this._icon);
         }
         if(!this._icon)
         {
            return;
         }
         if(Boolean(this._loadingasset.parent))
         {
            removeChild(this._loadingasset);
         }
         this._icon.scaleX = ICON_SIZE / this._icon.width;
         this._icon.scaleY = ICON_SIZE / this._icon.height;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._loadingasset);
         if(Boolean(this._loadingasset))
         {
            ObjectUtils.disposeObject(this._loadingasset);
         }
         this._loadingasset = null;
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         }
         this._loader = null;
         if(Boolean(this._icon) && Boolean(this._icon.bitmapData))
         {
            this._icon.bitmapData.dispose();
         }
         this._icon = null;
         if(Boolean(this._bg) && Boolean(this._bg.bitmapData))
         {
            this._bg.bitmapData.dispose();
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         DisplayUtils.clearChildren(this);
         this._loadingPos = null;
         this._iconPos = null;
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

