package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomViewerItem;
   
   public class RoomLoadingViewerItem extends Sprite implements Disposeable
   {
      
      private static const MAX_VIEWER:int = 2;
      
      private var _bg:Image;
      
      private var _viewerTxt:Bitmap;
      
      private var _viewerItems:Vector.<RoomViewerItem>;
      
      public function RoomLoadingViewerItem()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var viewers:Vector.<RoomPlayer> = null;
         var i:int = 0;
         var j:int = 0;
         var item:RoomViewerItem = null;
         var _noViewer:Bitmap = null;
         this._viewerItems = new Vector.<RoomViewerItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("roomloading.ViewerFrameBg");
         this._viewerTxt = ComponentFactory.Instance.creatBitmap("asset.roomloading.ViewerTxt");
         PositionUtils.setPos(this._viewerTxt,"asset.ddtroom.viewerTxt");
         if(RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM)
         {
            viewers = this.findViewers();
            for(i = 0; i < viewers.length; i++)
            {
               item = new RoomViewerItem(viewers[i].place);
               item.changeBg();
               this._viewerItems.push(item);
               this._viewerItems[i].loadingMode = true;
               this._viewerItems[i].info = viewers[i];
               this._viewerItems[i].mouseChildren = false;
               this._viewerItems[i].mouseEnabled = false;
               PositionUtils.setPos(this._viewerItems[i],"asset.roomLoading.ViewerItemPos_" + String(i));
               addChild(this._viewerItems[i]);
            }
            for(j = MAX_VIEWER; j > viewers.length; j--)
            {
               _noViewer = ComponentFactory.Instance.creatBitmap("asset.roomloading.noViewer");
               PositionUtils.setPos(_noViewer,"asset.roomLoading.ViewerItemPos_" + (j - 1).toString());
               addChild(_noViewer);
            }
         }
         addChildAt(this._bg,0);
         addChild(this._viewerTxt);
      }
      
      private function findViewers() : Vector.<RoomPlayer>
      {
         var roomPlayer:RoomPlayer = null;
         var players:Array = GameManager.Instance.Current.roomPlayers;
         var result:Vector.<RoomPlayer> = new Vector.<RoomPlayer>();
         for each(roomPlayer in players)
         {
            if(roomPlayer.isViewer)
            {
               result.push(roomPlayer);
            }
         }
         return result;
      }
      
      public function dispose() : void
      {
         var item:RoomViewerItem = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._viewerTxt);
         this._viewerTxt = null;
         for each(item in this._viewerItems)
         {
            item.dispose();
            item = null;
         }
         this._viewerItems = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

