package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import ddt.data.analyze.FightLibAwardAnalyzer;
   import ddt.data.fightLib.FightLibAwardInfo;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.utils.RequestVairableCreater;
   import fightLib.script.BaseScript;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import road7th.comm.PackageIn;
   
   public class FightLibManager extends EventDispatcher
   {
      
      private static var _ins:FightLibManager;
      
      private static const PATH:String = "FightLabDropItemList.xml";
      
      public static const GAINAWARD:String = "gainAward";
      
      private var _currentInfo:FightLibInfo;
      
      public var lastInfo:FightLibInfo;
      
      public var lastFightLibMission:String;
      
      private var _lastWin:Boolean = false;
      
      private var _awardList:Array;
      
      private var _script:BaseScript;
      
      private var _reAnswerNum:int;
      
      public var award:Boolean = false;
      
      private var _isWork:Boolean;
      
      public function FightLibManager(singletonFocer:SingletonFocer)
      {
         super();
         this.addEvent();
      }
      
      public static function get Instance() : FightLibManager
      {
         if(_ins == null)
         {
            _ins = new FightLibManager(new SingletonFocer());
         }
         return _ins;
      }
      
      public function set isWork(value:Boolean) : void
      {
         this._isWork = value;
      }
      
      public function get isWork() : Boolean
      {
         return this._isWork;
      }
      
      public function get lastWin() : Boolean
      {
         return this._lastWin;
      }
      
      public function set lastWin(val:Boolean) : void
      {
         this._lastWin = val;
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,this.__infoChange);
      }
      
      private function __infoChange(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var id:int = pkg.readInt();
         var difficulty:int = pkg.readInt();
         this.currentInfoID = id;
         this.currentInfo.beginChange();
         this.currentInfo.difficulty = difficulty;
         var info:DungeonInfo = this.findDungInfoByID(id);
         this.currentInfo.commitChange();
      }
      
      private function findDungInfoByID(id:int) : DungeonInfo
      {
         var info:DungeonInfo = null;
         for each(info in MapManager.getFightLibList())
         {
            if(info.ID == id)
            {
               return info;
            }
         }
         return null;
      }
      
      public function getFightLibInfoByID(id:int) : FightLibInfo
      {
         var fightInfo:FightLibInfo = null;
         var info:DungeonInfo = this.findDungInfoByID(id);
         if(Boolean(info))
         {
            fightInfo = new FightLibInfo();
            fightInfo.beginChange();
            fightInfo.id = info.ID;
            fightInfo.description = info.Description;
            fightInfo.name = info.Name;
            fightInfo.difficulty = -1;
            fightInfo.requiedLevel = info.LevelLimits;
            fightInfo.mapID = int(info.Pic);
            fightInfo.commitChange();
            return fightInfo;
         }
         return null;
      }
      
      public function reset() : void
      {
         this.currentInfo = null;
         this.reAnswerNum = 1;
         if(Boolean(this._script))
         {
            this._script.dispose();
         }
         this._script = null;
      }
      
      public function get currentInfo() : FightLibInfo
      {
         return this._currentInfo;
      }
      
      public function set currentInfo(value:FightLibInfo) : void
      {
         this._currentInfo = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set currentInfoID(value:int) : void
      {
         var fightInfo:FightLibInfo = null;
         if(Boolean(this.currentInfo) && this.currentInfo.id == value)
         {
            return;
         }
         var info:DungeonInfo = this.findDungInfoByID(value);
         if(Boolean(info))
         {
            fightInfo = new FightLibInfo();
            fightInfo.beginChange();
            fightInfo.id = info.ID;
            fightInfo.description = info.Description;
            fightInfo.name = info.Name;
            fightInfo.difficulty = -1;
            fightInfo.requiedLevel = info.LevelLimits;
            fightInfo.mapID = int(info.Pic);
            fightInfo.commitChange();
            this.currentInfo = fightInfo;
         }
      }
      
      public function get script() : BaseScript
      {
         return this._script;
      }
      
      public function set script(value:BaseScript) : void
      {
         this._script = value;
      }
      
      public function get reAnswerNum() : int
      {
         return this._reAnswerNum;
      }
      
      public function set reAnswerNum(value:int) : void
      {
         this._reAnswerNum = value;
      }
      
      public function getFightLibAwardInfoByID(id:int) : FightLibAwardInfo
      {
         var awardItem:FightLibAwardInfo = null;
         for each(awardItem in this._awardList)
         {
            if(awardItem.id == id)
            {
               return awardItem;
            }
         }
         return null;
      }
      
      public function setup() : void
      {
         this.createInitAwardLoader(this.initAwardInfo);
      }
      
      private function createInitAwardLoader(callBack:Function) : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(PATH),BaseLoader.COMPRESS_TEXT_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("tank.fightLib.LoaderAwardInfoError");
         loader.analyzer = new FightLibAwardAnalyzer(callBack);
         LoadResourceManager.Instance.startLoad(loader);
         return loader;
      }
      
      private function __onLoadError(evt:LoaderEvent) : void
      {
      }
      
      private function initAwardInfo(analyzer:FightLibAwardAnalyzer) : void
      {
         this._awardList = analyzer.list;
      }
      
      public function gainAward(info:FightLibInfo) : void
      {
         dispatchEvent(new Event(GAINAWARD));
      }
   }
}

class SingletonFocer
{
   
   public function SingletonFocer()
   {
      super();
   }
}
