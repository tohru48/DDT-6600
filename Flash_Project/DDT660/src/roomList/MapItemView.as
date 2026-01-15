package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.loader.MapSmallIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapItemView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _mapIcon:MapSmallIcon;
      
      private var _bgII:ScaleBitmapImage;
      
      private var _mapID:int;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function MapItemView(mapID:int, cellWidth:int, cellheight:int)
      {
         this._mapID = mapID;
         this._cellWidth = cellWidth;
         this._cellheight = cellheight;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._mapIcon = new MapSmallIcon(this._mapID);
         this._mapIcon.addEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._mapIcon.startLoad();
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.itemredbg");
         this._bgII.mouseChildren = false;
         this._bgII.mouseEnabled = false;
         this._bgII.width = this._cellWidth;
         this._bgII.height = this._cellheight;
         this._bgII.visible = false;
         addChild(this._bgII);
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
      }
      
      protected function __itemOut(event:MouseEvent) : void
      {
         this._bgII.visible = false;
      }
      
      protected function __itemOver(event:MouseEvent) : void
      {
         this._bgII.visible = true;
      }
      
      private function __mapIconLoadComplete(event:Event) : void
      {
         this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._bg = this._mapIcon.icon;
         if(Boolean(this._bg))
         {
            this._bg.x = this._cellWidth / 2 - this._bg.width / 2 + 5;
            addChild(this._bg);
         }
      }
      
      public function get id() : int
      {
         return this._mapID;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._mapIcon))
         {
            this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
            this._mapIcon.dispose();
            this._mapIcon = null;
         }
         if(Boolean(this._bg) && Boolean(this._bg.parent))
         {
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         if(Boolean(this._bgII))
         {
            ObjectUtils.disposeObject(this._bgII);
            this._bgII = null;
         }
      }
   }
}

