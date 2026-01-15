package ddt.manager
{
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.map.DungeonInfo;
   import ddt.data.map.MapInfo;
   import ddt.data.map.OpenMapInfo;
   import flash.events.EventDispatcher;
   
   public class MapManager extends EventDispatcher
   {
      
      private static var _list:Vector.<MapInfo>;
      
      private static var _openList:Vector.<OpenMapInfo>;
      
      private static var _radomMapInfo:MapInfo;
      
      private static var _defaultDungeon:DungeonInfo;
      
      private static var _pveList:Vector.<DungeonInfo>;
      
      private static var _pvpList:Vector.<MapInfo>;
      
      private static var _pveLinkList:Array;
      
      private static var _pveAdvancedList:Array;
      
      private static var _pveBossList:Vector.<DungeonInfo>;
      
      private static var _pveExplrolList:Vector.<DungeonInfo>;
      
      private static var _pvpComplectiList:Vector.<MapInfo>;
      
      private static var _fightLibList:Vector.<DungeonInfo>;
      
      private static var _pveAcademyList:Vector.<DungeonInfo>;
      
      private static var _pveActivityList:Vector.<DungeonInfo>;
      
      public static const PVP_TRAIN_MAP:int = 1;
      
      public static const PVP_COMPECTI_MAP:int = 0;
      
      public static const PVE_EXPROL_MAP:int = 2;
      
      public static const PVE_BOSS_MAP:int = 3;
      
      public static const PVE_LINK_MAP:int = 4;
      
      public static const FIGHT_LIB:int = 5;
      
      public static const PVE_ACADEMY_MAP:int = 6;
      
      public static const PVE_ACTIVITY_MAP:int = 21;
      
      public static const PVE_ADVANCED_MAP:Array = [13];
      
      public static const PVE_SPECIAL_MAP:int = 23;
      
      public static const PVE_MAP:int = 5;
      
      public static const PVP_MAP:int = 6;
      
      public function MapManager()
      {
         super();
      }
      
      public static function getListByType(type:int = 0) : *
      {
         if(type == PVP_TRAIN_MAP)
         {
            return _list;
         }
         if(type == PVE_MAP)
         {
            return _pveList;
         }
         if(type == PVE_LINK_MAP)
         {
            return _pveLinkList;
         }
         if(type == PVE_BOSS_MAP)
         {
            return _pveBossList;
         }
         if(type == PVE_EXPROL_MAP)
         {
            return _pveExplrolList;
         }
         if(type == PVP_COMPECTI_MAP)
         {
            return _pvpComplectiList;
         }
         if(type == PVP_MAP)
         {
            return _pvpList;
         }
         if(type == FIGHT_LIB)
         {
            return _fightLibList;
         }
         if(type == PVE_ACADEMY_MAP)
         {
            return _pveAcademyList;
         }
         if(type == PVE_ACTIVITY_MAP || type == PVE_SPECIAL_MAP)
         {
            return _pveActivityList;
         }
         return null;
      }
      
      public static function getAdvancedList() : Array
      {
         return _pveAdvancedList;
      }
      
      public static function getPveActivityList() : Vector.<DungeonInfo>
      {
         return _pveActivityList;
      }
      
      public static function setup() : void
      {
      }
      
      public static function setupMapInfo(analyzer:MapAnalyzer) : void
      {
         _radomMapInfo = new MapInfo();
         _radomMapInfo.ID = 0;
         _radomMapInfo.isOpen = true;
         _radomMapInfo.canSelect = true;
         _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _list = analyzer.list;
         _pvpList = _list.slice();
         _radomMapInfo = new MapInfo();
         _radomMapInfo.ID = 0;
         _radomMapInfo.isOpen = true;
         _radomMapInfo.canSelect = true;
         _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _list.unshift(_radomMapInfo);
         _pvpComplectiList = new Vector.<MapInfo>();
         _pvpComplectiList.push(_radomMapInfo);
      }
      
      public static function setupDungeonInfo(analyzer:DungeonAnalyzer) : void
      {
         var info:DungeonInfo = null;
         _defaultDungeon = new DungeonInfo();
         _defaultDungeon.ID = 10000;
         _defaultDungeon.Description = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         _defaultDungeon.isOpen = true;
         _defaultDungeon.Name = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         _defaultDungeon.Type = 4;
         _defaultDungeon.Ordering = -1;
         _pveList = analyzer.list;
         _pveLinkList = [];
         _pveAdvancedList = [];
         _pveBossList = new Vector.<DungeonInfo>();
         _pveExplrolList = new Vector.<DungeonInfo>();
         _fightLibList = new Vector.<DungeonInfo>();
         _pveAcademyList = new Vector.<DungeonInfo>();
         _pveActivityList = new Vector.<DungeonInfo>();
         for(var i:int = 0; i < _pveList.length; i++)
         {
            info = _pveList[i];
            if(MapManager.PVE_ADVANCED_MAP.indexOf(info.ID) != -1 || PathManager.footballEnable && info.ID == 14)
            {
               _pveAdvancedList.push(info);
            }
            else if(info.Type == PVE_LINK_MAP)
            {
               _pveLinkList.push(info);
            }
            else if(info.Type == PVE_BOSS_MAP)
            {
               _pveBossList.push(info);
            }
            else if(info.Type == PVE_EXPROL_MAP)
            {
               _pveExplrolList.push(info);
            }
            else if(info.Type == FIGHT_LIB)
            {
               _fightLibList.push(info);
            }
            else if(info.Type == PVE_ACADEMY_MAP)
            {
               _pveAcademyList.push(info);
            }
            else if(info.Type == PVE_ACTIVITY_MAP || info.Type == PVE_SPECIAL_MAP)
            {
               _pveActivityList.push(info);
            }
         }
         _pveLinkList.unshift(_defaultDungeon);
         _pveAdvancedList.unshift(_defaultDungeon);
         _pveBossList.unshift(_defaultDungeon);
      }
      
      public static function setupOpenMapInfo(analyzer:WeekOpenMapAnalyze) : void
      {
         _openList = analyzer.list;
         buildMap();
      }
      
      public static function buildMap() : void
      {
         var currentMaps:String = null;
         var info:MapInfo = null;
         if(_openList == null || _list == null || ServerManager.Instance.current == null)
         {
            return;
         }
         for(var i:uint = 0; i < _openList.length; i++)
         {
            if(_openList[i].serverID == ServerManager.Instance.current.ID)
            {
               currentMaps = _openList[i].maps;
            }
         }
         if(Boolean(_openList) && Boolean(_list))
         {
            for each(info in _list)
            {
               if(Boolean(currentMaps))
               {
                  info.isOpen = currentMaps.indexOf(String(info.ID)) > -1;
               }
            }
            _list.splice(_list.indexOf(_radomMapInfo),1);
            _list.unshift(_radomMapInfo);
         }
      }
      
      public static function isMapOpen(id:int) : Boolean
      {
         return getMapInfo(id).isOpen;
      }
      
      public static function getMapInfo(id:Number) : MapInfo
      {
         var info:MapInfo = null;
         for each(info in _list)
         {
            if(info.ID == id)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getDungeonInfo(id:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in _pveList)
         {
            if(info.ID == id)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getByOrderingDungeonInfo(ordering:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in _pveLinkList)
         {
            if(info.Ordering == ordering)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getByOrderingAdvancedDungeonInfo(ordering:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in _pveAdvancedList)
         {
            if(info.Ordering == ordering)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getByOrderingAcademyDungeonInfo(ordering:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in _pveAcademyList)
         {
            if(info.Ordering == ordering)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getByOrderingActivityDungeonInfo(ordering:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in _pveActivityList)
         {
            if(info.Ordering == ordering)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getFightLibList() : Vector.<DungeonInfo>
      {
         return _fightLibList;
      }
      
      public static function getMapName(id:int) : String
      {
         var info:DungeonInfo = getDungeonInfo(id);
         if(Boolean(info))
         {
            return info.Name;
         }
         var m_info:MapInfo = getMapInfo(id);
         if(Boolean(m_info))
         {
            return m_info.Name;
         }
         return "";
      }
   }
}

