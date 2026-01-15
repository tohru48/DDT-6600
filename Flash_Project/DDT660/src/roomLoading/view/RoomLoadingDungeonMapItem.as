package roomLoading.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import escort.EscortManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   import rescue.RescueManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingDungeonMapItem extends Sprite implements Disposeable
   {
      
      private var _displayMc:MovieClip;
      
      private var _itemFrame:DisplayObject;
      
      private var _item:Sprite;
      
      private var _mapLoader:DisplayLoader;
      
      public function RoomLoadingDungeonMapItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._item = new Sprite();
         this._itemFrame = ComponentFactory.Instance.creat("asset.roomLoading.DungeonMapFrame");
         this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
         this._mapLoader = LoadResourceManager.Instance.createLoader(this.solveMapPath(),BaseLoader.BITMAP_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoadResourceManager.Instance.startLoad(this._mapLoader);
      }
      
      private function __onLoadComplete(event:Event) : void
      {
         var content:Bitmap = null;
         if(this._mapLoader.isSuccess)
         {
            this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            content = this._mapLoader.content as Bitmap;
            content.height = 365;
            this._item.addChild(content);
            this._item.addChild(this._itemFrame);
            PositionUtils.setPos(this._displayMc,"asset.roomLoading.DungeonMapLoaderPos");
            this._item.scaleX = -1;
            this._displayMc.scaleX = -1;
            this._displayMc["character"].addChild(this._item);
            this._displayMc.gotoAndPlay("appear1");
            addChild(this._displayMc);
         }
      }
      
      private function solveMapPath() : String
      {
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(GameManager.Instance.Current.gameMode == 8)
         {
            return result + "1133/show.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            return result + "214/show1.png";
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BOSS)
         {
            return result + "215/show1.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.CAMPBATTLE_BATTLE)
         {
            return result + "216/show1.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.SEVEN_DOUBLE)
         {
            if(EscortManager.instance.isStart)
            {
               result += "1350/show1.png";
            }
            else if(DrgnBoatManager.instance.isStart)
            {
               result += "71002/show1.jpg";
            }
            else
            {
               result += "217/show1.png";
            }
            return result;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CATCH_BEAST)
         {
            return result + "1347/show1.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.CRYPTBOSS_ROOM)
         {
            return result + "1511/show1.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.RESCUE)
         {
            switch(RescueManager.instance.curIndex)
            {
               case 0:
                  result += "70004/show1.jpg";
                  break;
               case 1:
                  result += "70005/show1.jpg";
                  break;
               case 2:
                  result += "70006/show1.jpg";
                  break;
               case 3:
                  result += "70010/show1.jpg";
                  break;
               case 4:
                  result += "70011/show1.jpg";
                  break;
               case 5:
                  result += "70012/show1.jpg";
            }
            return result;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
         {
            return result + "70003/show1.jpg";
         }
         var pic:String = GameManager.Instance.Current.missionInfo.pic;
         var pic1:String = RoomManager.Instance.current.pic;
         if(RoomManager.Instance.current.isOpenBoss)
         {
            if(pic1 == null || pic1 == "")
            {
               result += RoomManager.Instance.current.mapId + "/show1.jpg";
            }
            else
            {
               result += RoomManager.Instance.current.mapId + "/" + pic1;
            }
         }
         else if(pic == null || RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || pic == "")
         {
            result += RoomManager.Instance.current.mapId + "/show1.jpg";
         }
         else
         {
            result += RoomManager.Instance.current.mapId + "/" + pic;
         }
         return result;
      }
      
      public function disappear() : void
      {
         this._displayMc.gotoAndPlay("disappear1");
      }
      
      public function dispose() : void
      {
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         ObjectUtils.disposeAllChildren(this);
         this._mapLoader = null;
         this._displayMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

