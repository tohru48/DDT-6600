package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class ConsortiaTaskModel extends EventDispatcher
   {
      
      public static const RELEASE_TASK:int = 0;
      
      public static const RESET_TASK:int = 1;
      
      public static const SUMBIT_TASK:int = 2;
      
      public static const GET_TASKINFO:int = 3;
      
      public static const UPDATE_TASKINFO:int = 4;
      
      public static const SUCCESS_FAIL:int = 5;
      
      public static const DELAY_TIME:int = 6;
      
      public var taskInfo:ConsortiaTaskInfo;
      
      public var isHaveTask_noRelease:Boolean = false;
      
      private var _taskStatus:Boolean = false;
      
      public function ConsortiaTaskModel(target:IEventDispatcher = null)
      {
         super(target);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,this.__releaseTaskCallBack);
      }
      
      private function __releaseTaskCallBack(e:CrazyTankSocketEvent) : void
      {
         var sf:Boolean = false;
         var id1:int = 0;
         var currentValue1:int = 0;
         var finishValue1:int = 0;
         var count1:int = 0;
         var j:int = 0;
         var id2:int = 0;
         var content1:String = null;
         var events2:ConsortiaTaskEvent = null;
         var count:int = 0;
         var i:int = 0;
         var id:int = 0;
         var taskType:int = 0;
         var content:String = null;
         var currentValue:int = 0;
         var targetValue:int = 0;
         var finishValue:int = 0;
         var pkg:PackageIn = e.pkg as PackageIn;
         var type:int = pkg.readByte();
         if(type == SUMBIT_TASK)
         {
            this._taskStatus = pkg.readBoolean();
            if(!this._taskStatus)
            {
               this.taskInfo = null;
            }
         }
         else if(type == SUCCESS_FAIL)
         {
            sf = pkg.readBoolean();
            this.taskInfo = null;
            this._taskStatus = false;
         }
         else if(type == UPDATE_TASKINFO)
         {
            id1 = pkg.readInt();
            currentValue1 = pkg.readInt();
            finishValue1 = pkg.readInt();
            if(this.taskInfo != null)
            {
               this.taskInfo.updateItemData(id1,currentValue1,finishValue1);
            }
         }
         else if(type == RELEASE_TASK || type == RESET_TASK)
         {
            count1 = pkg.readInt();
            this.taskInfo = new ConsortiaTaskInfo();
            for(j = 0; j < count1; j++)
            {
               id2 = pkg.readInt();
               content1 = pkg.readUTF();
               this.taskInfo.addItemData(id2,content1);
            }
         }
         else
         {
            if(type == DELAY_TIME)
            {
               events2 = new ConsortiaTaskEvent(ConsortiaTaskEvent.DELAY_TASK_TIME);
               events2.value = pkg.readInt();
               dispatchEvent(events2);
               PlayerManager.Instance.Self.consortiaInfo.Riches = pkg.readInt();
               return;
            }
            count = pkg.readInt();
            if(count > 0)
            {
               this.taskInfo = new ConsortiaTaskInfo();
               for(i = 0; i < count; i++)
               {
                  id = pkg.readInt();
                  taskType = pkg.readInt();
                  content = pkg.readUTF();
                  currentValue = pkg.readInt();
                  targetValue = pkg.readInt();
                  finishValue = pkg.readInt();
                  this.taskInfo.addItemData(id,content,taskType,currentValue,targetValue,finishValue);
               }
               this.taskInfo.sortItem();
               this.taskInfo.exp = pkg.readInt();
               this.taskInfo.offer = pkg.readInt();
               this.taskInfo.contribution = pkg.readInt();
               this.taskInfo.riches = pkg.readInt();
               this.taskInfo.buffID = pkg.readInt();
               this.taskInfo.beginTime = pkg.readDate();
               this.taskInfo.time = pkg.readInt();
               this.taskInfo.level = pkg.readInt();
            }
            else if(count == -1)
            {
               this.taskInfo = null;
               this.isHaveTask_noRelease = true;
            }
            else
            {
               this.taskInfo = null;
            }
         }
         var events:ConsortiaTaskEvent = new ConsortiaTaskEvent(ConsortiaTaskEvent.GETCONSORTIATASKINFO);
         events.value = type;
         dispatchEvent(events);
      }
      
      public function showReleaseFrame() : void
      {
         if(this._taskStatus && this.taskInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released2"));
            return;
         }
         if(this._taskStatus && this.taskInfo != null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released"));
            return;
         }
         if(this._taskStatus && this.taskInfo != null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released"));
            return;
         }
         if(this.isHaveTask_noRelease)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.havetaskNoRelease"));
         }
         var taskFrame:ConsortiaReleaseTaskFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaReleaseTaskFrame");
         LayerManager.Instance.addToLayer(taskFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

