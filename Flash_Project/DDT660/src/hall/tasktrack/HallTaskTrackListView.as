package hall.tasktrack
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCategory;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HallTaskTrackListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      private var _questData:DictionaryData;
      
      public function HallTaskTrackListView()
      {
         super();
         this.initData();
         this.initView();
         this.refreshView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         var tmp:QuestInfo = null;
         this._questData = new DictionaryData();
         var index:int = -1;
         for(var i:int = 0; i < 7; i++)
         {
            if(i != 4)
            {
               tmp = new QuestInfo();
               if(i == 0)
               {
                  tmp.Type = 2;
               }
               else
               {
                  tmp.Type = 1;
               }
               tmp.QuestID = index;
               this._questData.add(i,tmp);
               index--;
            }
         }
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.list");
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         TaskManager.instance.addEventListener(TaskManager.REFRESH_TASK_TRACK_VIEW,this.refreshView);
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         var tmp:QuestInfo = null;
         var questInfo:QuestInfo = event.cellValue as QuestInfo;
         if(questInfo.QuestID > 0)
         {
            return;
         }
         SoundManager.instance.play("008");
         for each(tmp in this._questData)
         {
            if(questInfo.QuestID == tmp.QuestID)
            {
               tmp.Type = tmp.Type == 1 ? 2 : 1;
               break;
            }
         }
         this.refreshView(new Event(TaskManager.REFRESH_TASK_TRACK_VIEW));
      }
      
      private function refreshView(event:Event = null) : void
      {
         var cate:QuestCategory = null;
         var tmpList:Array = null;
         var typeQuest:QuestInfo = null;
         var questInfo:QuestInfo = null;
         var questInfo2:QuestInfo = null;
         var questInfo5:QuestInfo = null;
         var questInfo3:QuestInfo = null;
         var questInfo4:QuestInfo = null;
         var tmpPosY:int = this._list.list.viewPosition.y;
         var tmp:Array = [];
         var isNeedDefault:Boolean = false;
         if(!event)
         {
            isNeedDefault = true;
         }
         for(var i:int = 0; i < 7; i++)
         {
            if(i != 4)
            {
               cate = TaskManager.instance.getAvailableQuests(i);
               tmpList = cate.list;
               if(tmpList.length > 0)
               {
                  typeQuest = this._questData[i] as QuestInfo;
                  tmp.push(typeQuest);
                  if(isNeedDefault)
                  {
                     typeQuest.Type = 2;
                     isNeedDefault = false;
                  }
                  if(typeQuest.Type == 2)
                  {
                     tmp = tmp.concat(tmpList);
                  }
               }
            }
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(tmp);
         this._list.list.updateListView();
         var intPoint:IntPoint = new IntPoint(0,tmpPosY);
         this._list.list.viewPosition = intPoint;
         dispatchEvent(new Event(Event.CHANGE));
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_1))
         {
            for each(questInfo in tmp)
            {
               if(questInfo.QuestID == 568)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(49,-51),"","",this);
                  break;
               }
            }
         }
         if((PlayerManager.Instance.Self.Grade == 12 || PlayerManager.Instance.Self.Grade == 13) && !PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
         {
            for each(questInfo2 in tmp)
            {
               if(questInfo2.QuestID == 7)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.TEXP_GUIDE,0,new Point(49,-51),"","",this);
                  break;
               }
            }
         }
         if(PlayerManager.Instance.Self.Grade >= 10 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
         {
            for each(questInfo5 in tmp)
            {
               if(questInfo5.QuestID == 327)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.SHOUSHI_GUIDE,-90,new Point(-47,76),"","",this);
                  break;
               }
            }
         }
         if((PlayerManager.Instance.Self.Grade == 13 || PlayerManager.Instance.Self.Grade == 14) && !PlayerManager.Instance.Self.isNewOnceFinish(Step.SHOUSHI_GUIDE))
         {
            for each(questInfo3 in tmp)
            {
               if(questInfo3.QuestID == 25)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,0,new Point(49,-51),"","",this);
                  break;
               }
            }
         }
         if((PlayerManager.Instance.Self.Grade == 15 || PlayerManager.Instance.Self.Grade == 16) && !PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
         {
            for each(questInfo4 in tmp)
            {
               if(questInfo4.QuestID == 29)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.BEAD_GUIDE,0,new Point(49,-51),"","",this);
                  break;
               }
            }
         }
         this.checkNewPlayerMainTask();
      }
      
      private function checkNewPlayerMainTask() : void
      {
         var j:int = 0;
         var taskInfo:QuestInfo = null;
         var tmpCondition:Array = null;
         var isHasOpitional:Boolean = false;
         var qc:QuestCondition = null;
         var i:int = 0;
         var cond:QuestCondition = null;
         var showArrowNum:int = 0;
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.GUIDE_TASK_NEWPLAYER);
            return;
         }
         var mainTaskList:Array = TaskManager.instance.getAvailableQuests(0).list;
         if(Boolean(mainTaskList) && mainTaskList.length > 0)
         {
            for(j = 0; j < mainTaskList.length; j++)
            {
               taskInfo = mainTaskList[j];
               tmpCondition = taskInfo._conditions;
               isHasOpitional = false;
               for each(qc in tmpCondition)
               {
                  if(qc.isOpitional)
                  {
                     isHasOpitional = true;
                     break;
                  }
               }
               if(!taskInfo.isCompleted)
               {
                  if(!isHasOpitional)
                  {
                     for(i = 0; Boolean(taskInfo._conditions[i]); i++)
                     {
                        cond = taskInfo._conditions[i];
                        if(taskInfo.progress[i] > 0)
                        {
                           if(HallTaskTrackManager.instance.isCanTrack(taskInfo.MapID,taskInfo._conditions[i].type))
                           {
                              showArrowNum++;
                           }
                        }
                     }
                  }
               }
            }
         }
         if(showArrowNum > 0)
         {
            NewHandContainer.Instance.showArrow(ArrowType.GUIDE_TASK_NEWPLAYER,-90,new Point(-47,76),"","",this);
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.GUIDE_TASK_NEWPLAYER);
         }
      }
      
      public function isEmpty() : Boolean
      {
         return this._list.vectorListModel.isEmpty();
      }
      
      private function removeEvent() : void
      {
         this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         TaskManager.instance.removeEventListener(TaskManager.REFRESH_TASK_TRACK_VIEW,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._list = null;
         this._questData = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

