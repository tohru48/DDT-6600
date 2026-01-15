package battleGroud
{
   import battleGroud.data.BatlleData;
   import battleGroud.data.BattlPrestigeData;
   import battleGroud.data.BattleUpdateData;
   import battleGroud.data.PlayerBattleData;
   import battleGroud.view.BattleGroudView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import room.RoomManager;
   
   public class BattleGroudManager
   {
      
      private static var _instance:BattleGroudManager;
      
      public var initBattleIcon:Function;
      
      public var dispBattleIcon:Function;
      
      public var isShow:Boolean;
      
      private var _battlGroudView:BattleGroudView;
      
      private var _moduleComplete:Boolean;
      
      private var _battleDataList:Array;
      
      public var orderdata:BattleUpdateData;
      
      private var _isBattleUILoaded:Boolean;
      
      private var _battlePresDataList:Vector.<BattlPrestigeData>;
      
      public var playerBattleData:PlayerBattleData;
      
      public function BattleGroudManager()
      {
         super();
         this.orderdata = new BattleUpdateData();
      }
      
      public static function get Instance() : BattleGroudManager
      {
         if(!_instance)
         {
            _instance = new BattleGroudManager();
         }
         return _instance;
      }
      
      public function open(e:CrazyTankSocketEvent) : void
      {
         this.isShow = true;
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            if(this.initBattleIcon != null)
            {
               this.initBattleIcon();
            }
         }
      }
      
      public function over(e:CrazyTankSocketEvent) : void
      {
         this.isShow = false;
         if(this.dispBattleIcon != null)
         {
            this.dispBattleIcon();
         }
         DdtActivityIconManager.Instance.currObj = null;
      }
      
      private function realTimeUpdataValue(e:CrazyTankSocketEvent) : void
      {
         this.orderdata.addDayPrestge = e.pkg.readInt();
         this.orderdata.totalPrestige = e.pkg.readInt();
      }
      
      private function updataValue(e:CrazyTankSocketEvent) : void
      {
         var bool:Boolean = e.pkg.readBoolean();
         if(!bool)
         {
            return;
         }
         var type:int = e.pkg.readByte();
         if(type == 1)
         {
            this.orderdata.addDayPrestge = e.pkg.readInt();
            this.orderdata.totalPrestige = e.pkg.readInt();
            this.orderdata.fairBattleDayPrestige = e.pkg.readInt();
         }
         else if(type == 2)
         {
            this.orderdata.rankings = e.pkg.readInt();
            if(Boolean(this._battlGroudView))
            {
               this._battlGroudView.setRanks(String(this.orderdata.rankings));
            }
         }
      }
      
      public function getBattleDataByPrestige(prestige:int) : BatlleData
      {
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            return new BatlleData();
         }
         var len:int = int(this._battleDataList.length);
         for(var i:int = len - 1; i >= 0; i--)
         {
            if(prestige >= this._battleDataList[i].Prestige)
            {
               return this._battleDataList[i] as BatlleData;
            }
         }
         return new BatlleData();
      }
      
      public function getBattleDataByLevel(level:int) : BatlleData
      {
         var len:int = int(this._battleDataList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(level == this._battleDataList[i].Level)
            {
               return this._battleDataList[i] as BatlleData;
            }
         }
         return new BatlleData();
      }
      
      public function setup() : void
      {
         this.orderData();
         this.celeTotalPrestigeData();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_OPEN,this.open);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_OVER,this.over);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLEDATA_UPDATA,this.updataValue);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLEDATA_UPDATA_REALTIME,this.realTimeUpdataValue);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DATA_UPDATA,this.playerDataUpDate);
      }
      
      protected function playerDataUpDate(event:CrazyTankSocketEvent) : void
      {
         this.playerBattleData = new PlayerBattleData();
         this.playerBattleData.Attack = event.pkg.readInt();
         this.playerBattleData.Defend = event.pkg.readInt();
         this.playerBattleData.Agility = event.pkg.readInt();
         this.playerBattleData.Lucky = event.pkg.readInt();
         this.playerBattleData.Damage = event.pkg.readInt();
         this.playerBattleData.Guard = event.pkg.readInt();
         this.playerBattleData.Blood = event.pkg.readInt();
         this.playerBattleData.Energy = event.pkg.readInt();
         this.playerBattleData.ID = PlayerManager.Instance.Self.ID;
      }
      
      private function orderData() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("FairBattleRewardTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new BattleGroundAnalyer(this.completeHander);
      }
      
      private function celeTotalPrestigeData() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("CelebByTotalPrestige.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new CeleTotalPrestigeAnalyer(this.completeHander2);
      }
      
      public function completeHander(analyzer:BattleGroundAnalyer) : void
      {
         this._battleDataList = analyzer.battleDataList;
      }
      
      public function completeHander2(analyzer:CeleTotalPrestigeAnalyer) : void
      {
         this._battlePresDataList = analyzer.battleDataList;
      }
      
      public function getCurrBattlePresData(id:int) : BattlPrestigeData
      {
         var len:int = int(this._battlePresDataList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(id == this._battlePresDataList[i].ID)
            {
               return this._battlePresDataList[i];
            }
         }
         return new BattlPrestigeData();
      }
      
      public function initBattleView() : void
      {
         if(Boolean(this._battlGroudView) && Boolean(this._battlGroudView.parent))
         {
            this.hide();
         }
         else if(this._moduleComplete)
         {
            this.show();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BATTLEGROUD);
         }
      }
      
      public function addBattleSingleRoom() : void
      {
         if(this._isBattleUILoaded)
         {
            GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOM);
      }
      
      private function __onProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.BATTLEGROUD)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function show() : void
      {
         if(Boolean(this._battlGroudView))
         {
            ObjectUtils.disposeObject(this._battlGroudView);
            this._battlGroudView = null;
         }
         this._battlGroudView = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView");
         LayerManager.Instance.addToLayer(this._battlGroudView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         if(Boolean(this._battlGroudView))
         {
            this._battlGroudView.dispose();
         }
         this._battlGroudView = null;
      }
      
      private function __onUIModuleComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.BATTLEGROUD)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._moduleComplete = true;
            UIModuleSmallLoading.Instance.hide();
            this.show();
         }
         else if(evt.module == UIModuleTypes.DDTROOM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._isBattleUILoaded = true;
            UIModuleSmallLoading.Instance.hide();
            GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         this._moduleComplete = false;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
   }
}

