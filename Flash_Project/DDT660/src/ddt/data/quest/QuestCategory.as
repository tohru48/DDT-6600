package ddt.data.quest
{
   import ddt.manager.TaskManager;
   
   public class QuestCategory
   {
      
      private var _completedQuestArray:Array;
      
      private var _newQuestArray:Array;
      
      private var _questArray:Array;
      
      public function QuestCategory()
      {
         super();
         this._completedQuestArray = new Array();
         this._newQuestArray = new Array();
         this._questArray = new Array();
      }
      
      public function addNew(questInfo:QuestInfo) : void
      {
         this._newQuestArray.push(questInfo);
      }
      
      public function addCompleted(questInfo:QuestInfo) : void
      {
         this._completedQuestArray.push(questInfo);
      }
      
      public function addQuest(questInfo:QuestInfo) : void
      {
         this._questArray.push(questInfo);
      }
      
      public function get list() : Array
      {
         return this._completedQuestArray.concat(this._newQuestArray.concat(this._questArray));
      }
      
      public function get haveNew() : Boolean
      {
         var info:QuestInfo = null;
         for each(info in this._newQuestArray)
         {
            if(Boolean(info.data) && info.data.isNew)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get haveRecommend() : Boolean
      {
         for(var i:int = 0; i < this.list.length; i++)
         {
            if(this.list[i].StarLev == 1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get haveClickedNew() : Boolean
      {
         var info:QuestInfo = null;
         for each(info in this._newQuestArray)
         {
            if(info == TaskManager.instance.currentNewQuest)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get haveCompleted() : Boolean
      {
         return this._completedQuestArray.length > 0;
      }
      
      public function get completedQuestArray() : Array
      {
         return this._completedQuestArray.concat();
      }
      
      public function get unCompleteQuestArray() : Array
      {
         return this._newQuestArray.concat(this._questArray);
      }
   }
}

