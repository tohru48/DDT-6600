package room.view.bigMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomTicketView;
   
   public class MissionRoomBigMapInfoPanel extends Sprite implements Disposeable
   {
      
      protected var _bg:MutipleImage;
      
      protected var _mapShowContainer:Sprite;
      
      protected var _dropList:DropList;
      
      protected var _pos1:Point;
      
      protected var _pos2:Point;
      
      protected var _info:RoomInfo;
      
      private var _loader:DisplayLoader;
      
      protected var _ticketView:RoomTicketView;
      
      public function MissionRoomBigMapInfoPanel()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initEvents() : void
      {
         this._dropList.addEventListener(DropList.LARGE,this.__dropListLarge);
         this._dropList.addEventListener(DropList.SMALL,this.__dropListSmall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__lastMission);
      }
      
      protected function removeEvents() : void
      {
         this._dropList.removeEventListener(DropList.LARGE,this.__dropListLarge);
         this._dropList.removeEventListener(DropList.SMALL,this.__dropListSmall);
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         this._info.removeEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
         this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__lastMission);
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.bigMapinfo.bg");
         addChild(this._bg);
         this._mapShowContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.bigMapIconContainer");
         addChild(this._mapShowContainer);
         this._pos1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos1");
         this._pos2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos2");
         this._dropList = new DropList();
         this._dropList.x = this._pos1.x;
         this._dropList.y = this._pos1.y;
         addChild(this._dropList);
         this._dropList.visible = false;
         this._info = RoomManager.Instance.current;
         if(Boolean(this._info))
         {
            this._info.addEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
            this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
            this.updateMap();
         }
         if(this._ticketView == null)
         {
            this._ticketView = ComponentFactory.Instance.creatCustomObject("asset.warriorsArena.ticketView");
            this._ticketView.visible = RoomManager.Instance.IsLastMisstion;
            addChild(this._ticketView);
         }
         if(Boolean(this._info))
         {
            this.updateDropList();
         }
      }
      
      private function __lastMission(event:CrazyTankSocketEvent) : void
      {
         this._ticketView.visible = RoomManager.Instance.IsLastMisstion;
      }
      
      protected function __onMapChanged(evt:RoomEvent) : void
      {
         this.updateMap();
         this.updateDropList();
      }
      
      protected function __updateHard(evt:RoomEvent) : void
      {
         this.updateDropList();
      }
      
      protected function updateMap() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         }
         this._loader = LoadResourceManager.Instance.createLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__showMap);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function __showMap(evt:LoaderEvent) : void
      {
         if(evt.loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._mapShowContainer);
            evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
            this._mapShowContainer.addChild(evt.loader.content as Bitmap);
            this._mapShowContainer.width = 315;
            this._mapShowContainer.height = 357;
         }
      }
      
      protected function updateDropList() : void
      {
         var dungeon:DungeonInfo = MapManager.getDungeonInfo(this._info.mapId);
         if(this._info.mapId != 0 && this._info.mapId != 10000)
         {
            if(Boolean(this._ticketView))
            {
               this._ticketView.giftBtnEnable();
            }
            switch(this._info.hardLevel)
            {
               case RoomInfo.EASY:
                  this._dropList.info = dungeon.SimpleTemplateIds.split(",");
                  break;
               case RoomInfo.NORMAL:
                  this._dropList.info = dungeon.NormalTemplateIds.split(",");
                  break;
               case RoomInfo.HARD:
                  this._dropList.info = dungeon.HardTemplateIds.split(",");
                  break;
               case RoomInfo.HERO:
                  this._dropList.info = dungeon.TerrorTemplateIds.split(",");
                  break;
               case RoomInfo.EPIC:
                  this._dropList.info = dungeon.EpicTemplateIds.split(",");
            }
            this._dropList.visible = true;
         }
         else
         {
            this._dropList.visible = false;
         }
      }
      
      private function __dropListLarge(evt:Event) : void
      {
         this._dropList.x = this._pos2.x;
         this._dropList.y = this._pos2.y;
         this._ticketView.y = this._dropList.y - 22;
      }
      
      private function __dropListSmall(evt:Event) : void
      {
         this._dropList.x = this._pos1.x;
         this._dropList.y = this._pos1.y;
         this._ticketView.y = this._dropList.y - 22;
      }
      
      protected function solvePath() : String
      {
         var result:String = "";
         if(RoomManager.Instance.current.isOpenBoss)
         {
            result = PathManager.SITE_MAIN + "image/map/" + this._info.mapId + "/" + RoomManager.Instance.current.pic;
         }
         else
         {
            result = PathManager.SITE_MAIN + "image/map/" + this._info.mapId + "/" + GameManager.Instance.Current.missionInfo.pic;
         }
         return result;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg.parent != null)
         {
            this._bg.parent.removeChild(this._bg);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._mapShowContainer);
         if(this._mapShowContainer.parent != null)
         {
            this._mapShowContainer.parent.removeChild(this._mapShowContainer);
         }
         this._mapShowContainer = null;
         if(this._dropList != null)
         {
            this._dropList.dispose();
         }
         this._dropList = null;
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
         }
         this._loader = null;
         this._info = null;
         if(Boolean(this._ticketView))
         {
            this._ticketView.dispose();
         }
         this._ticketView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

