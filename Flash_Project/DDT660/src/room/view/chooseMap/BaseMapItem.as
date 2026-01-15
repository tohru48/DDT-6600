package room.view.chooseMap
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseMapItem extends Sprite implements Disposeable
   {
      
      protected var _mapId:int = -1;
      
      protected var _selected:Boolean;
      
      protected var _bg:Bitmap;
      
      protected var _mapIconContaioner:Sprite;
      
      protected var _limitLevel:Sprite;
      
      protected var _limitBg:Bitmap;
      
      protected var _limitLevelText:FilterFrameText;
      
      protected var _selectedBg:Bitmap;
      
      protected var _loader:DisplayLoader;
      
      public function BaseMapItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function get height() : Number
      {
         return Math.max(this._bg.height,this._selectedBg.height);
      }
      
      override public function get width() : Number
      {
         return Math.max(this._bg.width,this._selectedBg.width);
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.mapItemBgAsset");
         addChild(this._bg);
         this._mapIconContaioner = new Sprite();
         addChild(this._mapIconContaioner);
         this.createLitmitSprite();
         this._selectedBg = ComponentFactory.Instance.creatBitmap("asset.room.mapItemSelectedAsset");
         addChild(this._selectedBg);
         this._selectedBg.visible = false;
      }
      
      private function createLitmitSprite() : void
      {
         this._limitLevel = new Sprite();
         PositionUtils.setPos(this._limitLevel,"asset.room.mapItem.limitLevelPos");
         addChild(this._limitLevel);
         this._limitLevel.visible = false;
         this._limitBg = ComponentFactory.Instance.creatBitmap("asset.room.mapItem.limitLevelBg");
         this._limitLevel.addChild(this._limitBg);
         this._limitLevelText = ComponentFactory.Instance.creatComponentByStylename("room.mapItem.limitLevel.text");
         this._limitLevel.addChild(this._limitLevelText);
         this._limitLevelText.visible = false;
      }
      
      public function setLimitLevel(min:int, max:int) : void
      {
         this._limitLevelText.text = LanguageMgr.GetTranslation("room.mapItem.limitLevel.Text",min,max);
      }
      
      protected function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function updateMapIcon() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = LoadResourceManager.Instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      protected function solvePath() : String
      {
         return PathManager.SITE_MAIN + "image/map/" + this._mapId.toString() + "/samll_map_s.jpg";
      }
      
      protected function __onComplete(evt:LoaderEvent) : void
      {
         var bm:Bitmap = null;
         ObjectUtils.disposeAllChildren(this._mapIconContaioner);
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         this._loader = null;
         if(BaseLoader(evt.loader).isSuccess)
         {
            bm = Bitmap(evt.loader.content);
            bm.width = this._bg.width;
            bm.height = this._bg.height;
            this._mapIconContaioner.addChild(bm);
            this._limitLevel.visible = true;
         }
      }
      
      protected function updateSelectState() : void
      {
         this._selectedBg.visible = this._selected;
      }
      
      private function __onClick(evt:MouseEvent) : void
      {
         var dungeon:DungeonInfo = null;
         if(this._mapId > -1)
         {
            SoundManager.instance.play("045");
            dungeon = MapManager.getDungeonInfo(this._mapId) as DungeonInfo;
            if(Boolean(dungeon) && dungeon.LevelLimits > PlayerManager.Instance.Self.Grade)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.clew",dungeon.LevelLimits));
               return;
            }
            this.selected = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._mapIconContaioner);
         removeChild(this._mapIconContaioner);
         this._mapIconContaioner = null;
         if(Boolean(this._selectedBg))
         {
            if(this._selectedBg.parent != null)
            {
               this._selectedBg.parent.removeChild(this._selectedBg);
            }
            this._selectedBg.bitmapData.dispose();
         }
         this._selectedBg = null;
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this.updateSelectState();
         if(this._selected)
         {
            dispatchEvent(new Event(Event.SELECT));
         }
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(value:int) : void
      {
         this._mapId = value;
         this.updateMapIcon();
         buttonMode = this.mapId != 10000;
      }
   }
}

