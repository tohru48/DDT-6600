package roomLoading.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import escort.EscortManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingBattleFieldItem extends Sprite implements Disposeable
   {
      
      private var _mapId:int;
      
      private var _bg:Image;
      
      private var _mapLoader:DisplayLoader;
      
      private var _fieldBg:Bitmap;
      
      private var _fieldNameLoader:DisplayLoader;
      
      private var _map:Bitmap;
      
      private var _fieldName:Bitmap;
      
      public function RoomLoadingBattleFieldItem(mapId:int = -1)
      {
         super();
         if(RoomManager.Instance.current.mapId > 0)
         {
            mapId = RoomManager.Instance.current.mapId;
         }
         this._mapId = mapId;
         try
         {
            this.init();
         }
         catch(error:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onScaleBitmapLoaded);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTCORESCALEBITMAP);
         }
      }
      
      private function __onScaleBitmapLoaded(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDTCORESCALEBITMAP)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onScaleBitmapLoaded);
            this.init();
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("roomloading.MapFrameBg");
         this._fieldBg = ComponentFactory.Instance.creatBitmap("asset.roomloading.battleItemTxt");
         addChild(this._bg);
         this._mapLoader = LoadResourceManager.Instance.createLoader(this.solveMapPath(1),BaseLoader.BITMAP_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoadResourceManager.Instance.startLoad(this._mapLoader);
         this._fieldNameLoader = LoadResourceManager.Instance.createLoader(this.solveMapPath(2),BaseLoader.BITMAP_LOADER);
         this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoadResourceManager.Instance.startLoad(this._fieldNameLoader);
      }
      
      private function __onLoadComplete(evt:LoaderEvent) : void
      {
         if(Boolean(evt.currentTarget.isSuccess))
         {
            if(evt.currentTarget == this._mapLoader)
            {
               this._map = PositionUtils.setPos(Bitmap(this._mapLoader.content),"roomLoading.BattleFieldItemMapPos");
               this._map = Bitmap(this._mapLoader.content);
            }
            else if(evt.currentTarget == this._fieldNameLoader)
            {
               this._fieldName = PositionUtils.setPos(Bitmap(this._fieldNameLoader.content),"roomLoading.BattleFieldItemNamePos");
               this._fieldName = Bitmap(this._fieldNameLoader.content);
            }
         }
         if(Boolean(this._map))
         {
            addChild(this._map);
         }
         addChild(this._fieldBg);
         if(Boolean(this._fieldName))
         {
            addChild(this._fieldName);
         }
      }
      
      private function solveMapPath(type:int) : String
      {
         var imgName:String = "samll_map";
         if(type == 2)
         {
            imgName = "icon";
         }
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.gameMode == 8)
         {
            return result + ("1133/" + imgName + ".png");
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM && type != 2)
         {
            return result + "214/samll_map.png";
         }
         if(RoomManager.Instance.current.type == RoomInfo.CAMPBATTLE_BATTLE && type != 2 && GameManager.Instance.Current.gameMode == GameManager.CAMP_BATTLE_MODEL_PVE)
         {
            return result + "216/samll_map.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.SEVEN_DOUBLE && type != 2)
         {
            if(EscortManager.instance.isStart)
            {
               result += "1350/samll_map.png";
            }
            else if(DrgnBoatManager.instance.isStart)
            {
               result += "71002/samll_map.png";
            }
            else
            {
               result += "217/samll_map.png";
            }
            return result;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
         {
            return result + ("70003/" + imgName + ".png");
         }
         return result + (this._mapId.toString() + "/" + imgName + ".png");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

