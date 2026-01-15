package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.analyze.LoadEdictumAnalyze;
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import times.TimesManager;
   
   public class EdictumManager extends EventDispatcher
   {
      
      private static var _instance:EdictumManager;
      
      private var unShowArr:Array = new Array();
      
      private var edictumDataList:Array;
      
      public function EdictumManager(target:IEventDispatcher = null)
      {
         super();
      }
      
      public static function get Instance() : EdictumManager
      {
         if(_instance == null)
         {
            _instance = new EdictumManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EDICTUM_GET_VERSION,this.__getEdictumVersion);
      }
      
      private function __getEdictumVersion(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var count:int = pkg.readInt();
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            arr.push(pkg.readInt());
         }
         this.__checkVersion(arr);
      }
      
      private function __checkVersion(arr:Array) : void
      {
         this.unShowArr = arr;
         if(this.unShowArr.length > 0)
         {
            this.__loadEdictumData();
         }
      }
      
      private function __loadEdictumData() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(this.__getURL(),BaseLoader.REQUEST_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         loader.analyzer = new LoadEdictumAnalyze(this.__returnWebSiteInfoHandler);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __returnWebSiteInfoHandler(action:LoadEdictumAnalyze) : void
      {
         this.edictumDataList = action.edictumDataList;
         TimesManager.Instance.checkLoadUpdateRes(this.edictumDataList,this.unShowArr);
      }
      
      private function __getURL() : String
      {
         return PathManager.solveRequestPath("GMTipAllByIDs.ashx?ids=" + this.unShowArr.join(","));
      }
   }
}

