package beadSystem.data
{
   import ddt.data.quest.QuestInfo;
   import flash.events.Event;
   
   public class BeadLeadEvent extends Event
   {
      
      public static const GETTASKISCOMPLETE:String = "getTaskIsComplete";
      
      public static const SPALINGUPLEVELCELL:String = "spalinguplevelcell";
      
      private var _taskinfo:QuestInfo;
      
      public function BeadLeadEvent(type:String, taskinfo:QuestInfo = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._taskinfo = taskinfo;
      }
      
      public function get taskinfo() : QuestInfo
      {
         return this._taskinfo;
      }
   }
}

