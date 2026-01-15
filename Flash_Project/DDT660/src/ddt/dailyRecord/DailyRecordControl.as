package ddt.dailyRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DailyRecordControl extends EventDispatcher
   {
      
      private static var _instance:DailyRecordControl;
      
      public static const RECORDLIST_IS_READY:String = "recordListIsReady";
      
      public var recordList:Vector.<DailiyRecordInfo>;
      
      public function DailyRecordControl()
      {
         super();
         this.recordList = new Vector.<DailiyRecordInfo>();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILYRECORD,this.daily);
         ServerManager.Instance.addEventListener(ServerManager.CHANGE_SERVER,this.__changeServerHandler);
      }
      
      public static function get Instance() : DailyRecordControl
      {
         if(_instance == null)
         {
            _instance = new DailyRecordControl();
         }
         return _instance;
      }
      
      private function __changeServerHandler(event:Event) : void
      {
         this.recordList = new Vector.<DailiyRecordInfo>();
      }
      
      private function daily(event:CrazyTankSocketEvent) : void
      {
         var info:DailiyRecordInfo = null;
         var j:int = 0;
         var len:int = event.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new DailiyRecordInfo();
            info.type = event.pkg.readInt();
            info.value = event.pkg.readUTF();
            if(this.recordList.length == 0)
            {
               this.recordList.push(info);
            }
            else if(this.isUpdate(info.type))
            {
               for(j = 0; j < this.recordList.length; j++)
               {
                  if(this.recordList[j].type == info.type)
                  {
                     this.recordList[j].value = info.value;
                     break;
                  }
                  if(j == this.recordList.length - 1)
                  {
                     this.sortPos(info);
                     break;
                  }
               }
            }
            else
            {
               this.sortPos(info);
            }
         }
         dispatchEvent(new Event(RECORDLIST_IS_READY));
      }
      
      private function sortPos(info:DailiyRecordInfo) : void
      {
         for(var i:int = 0; i < this.recordList.length; i++)
         {
            if(i == this.recordList.length - 1)
            {
               if(info.type < this.recordList[i].type)
               {
                  this.recordList.unshift(info);
               }
               else
               {
                  this.recordList.push(info);
               }
               break;
            }
            if(info.type >= this.recordList[i].type && info.type < this.recordList[i + 1].type)
            {
               this.recordList.splice(i + 1,0,info);
               break;
            }
         }
      }
      
      private function isUpdate(type:int) : Boolean
      {
         switch(type)
         {
            case 10:
            case 16:
            case 17:
            case 18:
            case 19:
            case 11:
            case 12:
            case 13:
            case 15:
            case 14:
            case 20:
            case 29:
            case 30:
               return true;
            default:
               return false;
         }
      }
      
      public function alertDailyFrame() : void
      {
         SocketManager.Instance.out.sendDailyRecord();
         var dailyFrame:DailyRecordFrame = ComponentFactory.Instance.creatComponentByStylename("dailyRecordFrame");
         LayerManager.Instance.addToLayer(dailyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

