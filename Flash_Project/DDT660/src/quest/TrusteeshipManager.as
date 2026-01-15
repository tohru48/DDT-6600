package quest
{
   import ddt.data.quest.QuestInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class TrusteeshipManager extends EventDispatcher
   {
      
      private static var _instance:TrusteeshipManager;
      
      public static const UPDATE_ALL_DATA:String = "update_all_data";
      
      public static const UPDATE_SPIRIT_VALUE:String = "update_spirit_value";
      
      private var _spiritValue:int;
      
      private var _list:Vector.<TrusteeshipDataVo> = new Vector.<TrusteeshipDataVo>();
      
      private var _maxCanStartCount:int = -1;
      
      private var _maxSpiritValue:int = -1;
      
      private var _buyOnceSpiritValue:int = -1;
      
      private var _buyOnceNeedMoney:int = -1;
      
      private var _speedUpOneMinNeedMoney:int = -1;
      
      public function TrusteeshipManager()
      {
         super(null);
      }
      
      public static function get instance() : TrusteeshipManager
      {
         if(_instance == null)
         {
            _instance = new TrusteeshipManager();
         }
         return _instance;
      }
      
      public function get list() : Vector.<TrusteeshipDataVo>
      {
         return this._list;
      }
      
      public function get spiritValue() : int
      {
         return this._spiritValue;
      }
      
      public function get speedUpOneMinNeedMoney() : int
      {
         if(this._speedUpOneMinNeedMoney == -1)
         {
            this._speedUpOneMinNeedMoney = int(ServerConfigManager.instance.serverConfigInfo["QuestCollocationAdvanceMinuteCost"].Value);
         }
         return this._speedUpOneMinNeedMoney;
      }
      
      public function get buyOnceNeedMoney() : int
      {
         if(this._buyOnceNeedMoney == -1)
         {
            this._buyOnceNeedMoney = int(ServerConfigManager.instance.serverConfigInfo["QuestCollocationEnergyBuyCost"].Value);
         }
         return this._buyOnceNeedMoney;
      }
      
      public function get buyOnceSpiritValue() : int
      {
         if(this._buyOnceSpiritValue == -1)
         {
            this._buyOnceSpiritValue = int(ServerConfigManager.instance.serverConfigInfo["QuestCollocationEnergyBuyCount"].Value);
         }
         return this._buyOnceSpiritValue;
      }
      
      public function get maxSpiritValue() : int
      {
         if(this._maxSpiritValue == -1)
         {
            this._maxSpiritValue = int(ServerConfigManager.instance.serverConfigInfo["QuestCollocationEnergyMaxCount"].Value);
         }
         return this._maxSpiritValue;
      }
      
      public function isCanStart() : Boolean
      {
         if(this._maxCanStartCount == -1)
         {
            this._maxCanStartCount = int(ServerConfigManager.instance.serverConfigInfo["QuestCollocationCount"].Value);
         }
         if(this._list.length < this._maxCanStartCount)
         {
            return true;
         }
         return false;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(TrusteeshipPackageType.START_EVENT,this.updateData);
         SocketManager.Instance.addEventListener(TrusteeshipPackageType.BUY_SPIRIT_EVENT,this.updateSpiritValue);
      }
      
      private function updateSpiritValue(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._spiritValue = pkg.readInt();
         dispatchEvent(new Event(UPDATE_SPIRIT_VALUE));
      }
      
      private function updateData(event:CrazyTankSocketEvent) : void
      {
         var tmpvo:TrusteeshipDataVo = null;
         var pkg:PackageIn = event.pkg;
         this._spiritValue = pkg.readInt();
         this._list = new Vector.<TrusteeshipDataVo>();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            tmpvo = new TrusteeshipDataVo();
            tmpvo.id = pkg.readInt();
            tmpvo.endTime = pkg.readDate();
            this._list.push(tmpvo);
         }
         dispatchEvent(new Event(UPDATE_ALL_DATA));
         this.isHasTrusteeshipQuestUnaviable();
      }
      
      public function isHasTrusteeshipQuestUnaviable() : Boolean
      {
         var tmpData:TrusteeshipDataVo = null;
         var tmpInfo:QuestInfo = null;
         var tmpTag:Boolean = false;
         for each(tmpData in this._list)
         {
            tmpInfo = TaskManager.instance.getQuestByID(tmpData.id);
            if(!tmpInfo || !TaskManager.instance.isAvailableQuest(tmpInfo,true))
            {
               SocketManager.Instance.out.sendTrusteeshipCancel(tmpData.id);
               tmpTag = true;
            }
         }
         return tmpTag;
      }
      
      public function isTrusteeshipQuestEnd(questId:int) : Boolean
      {
         var vo:TrusteeshipDataVo = this.getTrusteeshipInfo(questId);
         if(!vo)
         {
            return false;
         }
         var endTimestamp:Number = Number(vo.endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         if(int((endTimestamp - nowTimestamp) / 1000) > 0)
         {
            return false;
         }
         return true;
      }
      
      public function getTrusteeshipInfo(questId:int) : TrusteeshipDataVo
      {
         var info:TrusteeshipDataVo = null;
         var tmp:TrusteeshipDataVo = null;
         for each(tmp in this._list)
         {
            if(tmp.id == questId)
            {
               info = tmp;
               break;
            }
         }
         return info;
      }
   }
}

