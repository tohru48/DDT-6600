package exitPrompt
{
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   import email.manager.MailManager;
   
   public class ExitPromptModel
   {
      
      private var _list0Arr:Array;
      
      private var _list1Arr:Array;
      
      private var _list2Num:int;
      
      public function ExitPromptModel()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this._list0Arr = new Array();
         this._list1Arr = new Array();
         if(Boolean(TaskManager.instance.getAvailableQuests(2).list) && Boolean(TaskManager.instance.getAvailableQuests(3).list))
         {
            this._list0Arr = this._returnList0Arr(TaskManager.instance.getAvailableQuests(2).list);
            this._list1Arr = this._returnList1Arr(TaskManager.instance.getAvailableQuests(3).list);
         }
         if(Boolean(MailManager.Instance.Model) && Boolean(MailManager.Instance.Model.noReadMails))
         {
            this._list2Num = MailManager.Instance.Model.noReadMails.length;
         }
      }
      
      private function _returnList0Arr(arr:Array) : Array
      {
         var arr0:Array = new Array();
         for(var i:int = 0; i < arr.length; i++)
         {
            arr0[i] = new Array();
            arr0[i][0] = QuestInfo(arr[i]).Title;
            if(QuestInfo(arr[i]).RepeatMax > 50)
            {
               arr0[i][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
            }
            else if(QuestInfo(arr[i]).RepeatMax == 1)
            {
               arr0[i][1] = "0" + "/" + String(QuestInfo(arr[i]).RepeatMax);
            }
            else
            {
               arr0[i][1] = String(QuestInfo(arr[i]).RepeatMax - QuestInfo(arr[i]).data.repeatLeft) + "/" + String(QuestInfo(arr[i]).RepeatMax);
            }
         }
         return arr0;
      }
      
      private function _returnList1Arr(arr:Array) : Array
      {
         var arr0:Array = new Array();
         for(var i:int = 0; i < arr.length; i++)
         {
            arr0[i] = new Array();
            arr0[i][0] = QuestInfo(arr[i]).Title;
            if(QuestInfo(arr[i]).RepeatMax > 50)
            {
               arr0[i][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
            }
            else if(QuestInfo(arr[i]).RepeatMax == 1)
            {
               arr0[i][1] = "0" + "/" + String(QuestInfo(arr[i]).RepeatMax);
            }
            else
            {
               arr0[i][1] = String(QuestInfo(arr[i]).RepeatMax - QuestInfo(arr[i]).data.repeatLeft) + "/" + String(QuestInfo(arr[i]).RepeatMax);
            }
         }
         return arr0;
      }
      
      public function get list0Arr() : Array
      {
         return this._list0Arr;
      }
      
      public function get list1Arr() : Array
      {
         return this._list1Arr;
      }
      
      public function get list2Num() : int
      {
         return this._list2Num;
      }
   }
}

