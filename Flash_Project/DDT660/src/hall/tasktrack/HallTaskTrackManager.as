package hall.tasktrack
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class HallTaskTrackManager extends EventDispatcher
   {
      
      private static var _instance:HallTaskTrackManager;
      
      public var btnList:Array;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _completeTaskList:DictionaryData = new DictionaryData();
      
      private var _hasOpenCommitViewList:DictionaryData = new DictionaryData();
      
      public function HallTaskTrackManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : HallTaskTrackManager
      {
         if(_instance == null)
         {
            _instance = new HallTaskTrackManager();
         }
         return _instance;
      }
      
      public function moduleLoad(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
      }
      
      private function __onTaskLoadComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function __onTaskLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      public function addCompleteTask(questId:int) : void
      {
         if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.FRESHMAN_ROOM2 || StateManager.currentStateType == StateType.FRESHMAN_ROOM1 || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.WORLDBOSS_FIGHT_ROOM)
         {
            this.openCommitView(questId);
         }
         else if(!this._completeTaskList.hasKey(questId))
         {
            this._completeTaskList.add(questId,questId);
         }
         if(questId == 558)
         {
            HallTaskGuideManager.instance.clearTask1Arrow();
         }
      }
      
      public function checkOpenCommitView() : void
      {
         var questId:int = 0;
         for each(questId in this._completeTaskList)
         {
            this.openCommitView(questId);
         }
      }
      
      private function openCommitView(questId:int) : void
      {
         var tmp:HallTaskCompleteCommitView = null;
         if(this._hasOpenCommitViewList.hasKey(questId))
         {
            return;
         }
         tmp = new HallTaskCompleteCommitView(questId);
         tmp.x = 363;
         tmp.y = 431;
         LayerManager.Instance.addToLayer(tmp,LayerManager.STAGE_DYANMIC_LAYER);
         this._hasOpenCommitViewList.add(questId,questId);
      }
      
      public function isCanTrack(mapId:int, typeId:int) : Boolean
      {
         if(mapId > 0)
         {
            return true;
         }
         switch(typeId)
         {
            case 4:
            case 5:
            case 6:
            case 22:
            case 23:
            case 24:
            case 26:
            case 31:
            case 34:
            case 36:
            case 37:
            case 9:
            case 10:
            case 11:
            case 13:
            case 19:
            case 21:
            case 39:
            case 50:
            case 60:
            case 51:
            case 56:
            case 57:
            case 58:
            case 59:
            case 61:
            case 64:
            case 65:
               return true;
            default:
               return false;
         }
      }
   }
}

