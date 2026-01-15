package latentEnergy
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class LatentEnergyManager extends EventDispatcher
   {
      
      private static var _instance:LatentEnergyManager;
      
      public static const EQUIP_MOVE:String = "latentEnergy_equip_move";
      
      public static const EQUIP_MOVE2:String = "latentEnergy_equip_move2";
      
      public static const ITEM_MOVE:String = "latentEnergy_item_move";
      
      public static const ITEM_MOVE2:String = "latentEnergy_item_move2";
      
      public static const EQUIP_CHANGE:String = "latentEnergy_equip_change";
      
      private var _cacheDataList:Array;
      
      private var _timer:Timer;
      
      public function LatentEnergyManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : LatentEnergyManager
      {
         if(_instance == null)
         {
            _instance = new LatentEnergyManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LATENT_ENERGY,this.equipChangeHandler);
         this._cacheDataList = [];
         this._timer = new Timer(200,25);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleteHandler,false,0,true);
      }
      
      private function equipChangeHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var data:Object = {};
         data.place = pkg.readInt();
         data.curStr = pkg.readUTF();
         data.newStr = pkg.readUTF();
         data.endTime = pkg.readDate();
         var equipInfo:InventoryItemInfo = PlayerManager.Instance.Self.Bag.items[data.place] as InventoryItemInfo;
         if(Boolean(equipInfo))
         {
            this.doChange(equipInfo,data);
         }
         else
         {
            this._cacheDataList.push(data);
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function doChange(equipInfo:InventoryItemInfo, data:Object) : void
      {
         equipInfo.latentEnergyCurStr = data.curStr;
         equipInfo.latentEnergyNewStr = data.newStr;
         equipInfo.latentEnergyEndTime = data.endTime;
         equipInfo.IsBinds = true;
         dispatchEvent(new Event(EQUIP_CHANGE));
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var i:int = 0;
         var equipInfo:InventoryItemInfo = null;
         var len:int = int(this._cacheDataList.length);
         if(len > 0)
         {
            for(i = len - 1; i >= 0; i--)
            {
               equipInfo = PlayerManager.Instance.Self.Bag.items[this._cacheDataList[i].place] as InventoryItemInfo;
               if(Boolean(equipInfo))
               {
                  this.doChange(equipInfo,this._cacheDataList[i]);
                  this._cacheDataList.splice(i,1);
               }
            }
         }
         else
         {
            this._timer.stop();
         }
      }
      
      private function timerCompleteHandler(event:TimerEvent) : void
      {
         this._cacheDataList = [];
      }
      
      public function getCanLatentEnergyData() : BagInfo
      {
         var item:InventoryItemInfo = null;
         var equipBaglist:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         var latentEnergyBagList:BagInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         for each(item in equipBaglist)
         {
            if(item.isCanLatentEnergy)
            {
               if(item.getRemainDate() > 0)
               {
                  latentEnergyBagList.addItem(item);
               }
            }
         }
         return latentEnergyBagList;
      }
      
      public function getLatentEnergyItemData() : BagInfo
      {
         var item:InventoryItemInfo = null;
         var proBaglist:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         var latentEnergyBagList:BagInfo = new BagInfo(BagInfo.PROPBAG,21);
         for each(item in proBaglist)
         {
            if(item.CategoryID == 11 && int(item.Property1) == 101)
            {
               latentEnergyBagList.addItem(item);
            }
         }
         return latentEnergyBagList;
      }
   }
}

