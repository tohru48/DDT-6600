package hall.tasktrack
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class HallTaskGuideManager extends EventDispatcher
   {
      
      private static var _instance:HallTaskGuideManager;
      
      public function HallTaskGuideManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : HallTaskGuideManager
      {
         if(_instance == null)
         {
            _instance = new HallTaskGuideManager();
         }
         return _instance;
      }
      
      public function showTask1ClickBagArrow() : void
      {
         var tmpInfo:QuestInfo = null;
         if(StateManager.currentStateType == StateType.MAIN)
         {
            tmpInfo = TaskManager.instance.getQuestByID(558);
            if(tmpInfo == null)
            {
               return;
            }
            if(TaskManager.instance.isAvailableQuest(tmpInfo,true) && !tmpInfo.isCompleted)
            {
               NewHandContainer.Instance.showArrow(ArrowType.GUIDE_TASK_1,0,new Point(858,487),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               BagAndInfoManager.Instance.addEventListener(Event.OPEN,this.showTask2ClickEquipArrow);
               NoviceDataManager.instance.saveNoviceData(320,PathManager.userName(),PathManager.solveRequestPath());
            }
         }
      }
      
      private function showTask2ClickEquipArrow(event:Event) : void
      {
         var tmpInfo:QuestInfo = null;
         BagAndInfoManager.Instance.removeEventListener(Event.OPEN,this.showTask2ClickEquipArrow);
         if(StateManager.currentStateType == StateType.MAIN)
         {
            tmpInfo = TaskManager.instance.getQuestByID(558);
            if(TaskManager.instance.isAvailableQuest(tmpInfo,true) && !tmpInfo.isCompleted)
            {
               NewHandContainer.Instance.showArrow(ArrowType.GUIDE_TASK_1,0,new Point(548,84),"asset.trainer.txtWeaponTip","guide.task1.clickEquipTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
      }
      
      public function clearTask1Arrow() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.GUIDE_TASK_1);
      }
      
      public function showTaskFightItemArrow() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.GUIDE_TASK_FIGHT_ITEM,0,new Point(659,442),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      public function clearTaskFightItemArrow() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.GUIDE_TASK_FIGHT_ITEM);
      }
   }
}

