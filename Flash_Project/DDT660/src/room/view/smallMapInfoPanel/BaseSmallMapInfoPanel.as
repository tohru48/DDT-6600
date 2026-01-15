package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import room.model.RoomInfo;
   
   public class BaseSmallMapInfoPanel extends Sprite implements Disposeable
   {
      
      protected static const DEFAULT_MAP_ID:String = "10000";
      
      protected var _info:RoomInfo;
      
      private var _bg:MutipleImage;
      
      private var _word:Bitmap;
      
      private var _smallMapIcon:Bitmap;
      
      private var _smallMapContainer:Sprite;
      
      private var _loader:DisplayLoader;
      
      private var _rect:Rectangle;
      
      private var _maskShape:Shape;
      
      public function BaseSmallMapInfoPanel()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMapInfo.bg");
         addChild(this._bg);
         this._word = ComponentFactory.Instance.creatBitmap("asset.ddtroom.smallMapInfo.word");
         addChild(this._word);
         this._smallMapContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallMapInfoPanel.smallMapContainer");
         addChild(this._smallMapContainer);
         this._loader = LoadResourceManager.Instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoadResourceManager.Instance.startLoad(this._loader);
         this._rect = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallInfoPanel.imageRect");
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(0,0);
         this._maskShape.graphics.drawRect(this._rect.x,this._rect.y,this._rect.width,this._rect.height);
         this._maskShape.graphics.endFill();
         addChild(this._maskShape);
      }
      
      protected function solvePath() : String
      {
         if(Boolean(this._info) && this._info.mapId > 0)
         {
            return PathManager.SITE_MAIN + "image/map/" + this._info.mapId.toString() + "/samll_map.png";
         }
         return PathManager.SITE_MAIN + "image/map/" + DEFAULT_MAP_ID + "/samll_map.png";
      }
      
      protected function __completeHandler(evt:LoaderEvent) : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         if(this._loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._smallMapContainer);
            this._smallMapIcon = this._loader.content as Bitmap;
            this._smallMapIcon.mask = this._maskShape;
            this._smallMapContainer.addChild(this._smallMapIcon);
         }
      }
      
      public function set info(value:RoomInfo) : void
      {
         this._info = value;
         this._info.addEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         this.updateView();
      }
      
      private function __update(evt:Event) : void
      {
         this.updateView();
      }
      
      protected function updateView() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
            this._loader = null;
         }
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         this._loader = LoadResourceManager.Instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._word);
         this._word = null;
         this._smallMapIcon = null;
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         removeChild(this._smallMapContainer);
         this._smallMapContainer = null;
         this._info = null;
         this._loader = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

