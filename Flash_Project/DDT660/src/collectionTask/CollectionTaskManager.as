package collectionTask
{
   import collectionTask.model.CollectionTaskAnalyzer;
   import collectionTask.vo.CollectionRobertVo;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class CollectionTaskManager extends EventDispatcher
   {
      
      private static var _instance:CollectionTaskManager;
      
      public var isClickCollection:Boolean;
      
      public var collectionTaskInfoList:Vector.<CollectionRobertVo>;
      
      public var isCollecting:Boolean;
      
      public var collectedId:int;
      
      public var isTaskComplete:Boolean;
      
      public var questInfo:QuestInfo;
      
      private const CONDITION_ID:int = 64;
      
      private var _mapLoader:BaseLoader;
      
      public function CollectionTaskManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : CollectionTaskManager
      {
         if(_instance == null)
         {
            _instance = new CollectionTaskManager();
         }
         return _instance;
      }
      
      public function setUp() : void
      {
         var info:QuestInfo = null;
         var infoArr:Array = TaskManager.instance.allCurrentQuest;
         for each(info in infoArr)
         {
            if(info.Condition == this.CONDITION_ID)
            {
               this.questInfo = info;
               break;
            }
         }
         this.loadMap();
      }
      
      public function robertDataSetup(analyzer:CollectionTaskAnalyzer) : void
      {
         this.collectionTaskInfoList = analyzer.collectionTaskInfoList;
      }
      
      private function loadMap() : void
      {
         this._mapLoader = LoadResourceManager.Instance.createLoader(PathManager.solveCollectionTaskSceneSourcePath("collectionScene"),BaseLoader.MODULE_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoadResourceManager.Instance.startLoad(this._mapLoader);
      }
      
      private function onMapSrcLoadedComplete(event:LoaderEvent = null) : void
      {
         if(this._mapLoader.isSuccess)
         {
            StateManager.setState(StateType.COLLECTION_TASK_SCENE);
         }
      }
   }
}

