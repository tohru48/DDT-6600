package treasureLost.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import treasureLost.data.TreasureLostPackageType;
   import treasureLost.events.TreasureLostEvents;
   import treasureLost.model.TreasureLostMapData;
   import treasureLost.view.TreasureLostFrame;
   
   public class TreasureLostManager extends EventDispatcher
   {
      
      private static var _instance:TreasureLostManager;
      
      public static var loadComplete:Boolean = false;
      
      public static const NORMALBALL:int = 10620;
      
      public static const ALLBALL:int = 10621;
      
      public static const SMALLBOSS:int = 10015;
      
      public static const BIGBOSS:int = 10016;
      
      public static const TREASURELOSTROOMTYPE:int = 55;
      
      private var _isShowIcon:Boolean;
      
      private var _treasureLostFrame:TreasureLostFrame;
      
      public var power:int = 0;
      
      public var powerBuyCountLimite:int = 1;
      
      public var goldDiceRollBuyCountLimite:int = 1;
      
      public var powerBuyPrice:Array;
      
      public var goldDiceBuyPrice:Array;
      
      public var currentMap:int = 1;
      
      public var mapTypeArr:String;
      
      public var mapPosArr:String;
      
      public var mapPlayerPath:String;
      
      public var maxMapItemNum:int;
      
      public var specialMapNum:int;
      
      public var specialLength:int;
      
      public var playerCurrentPath:int = 0;
      
      public var unWalkPoint:int;
      
      public var goldDiceRollBuyCount:int = 10;
      
      public var battalOneCount:int;
      
      public var battalAllCount:int;
      
      public var treasureLostStoneNum:int;
      
      public var isDoubleBuff:Boolean;
      
      public var isHaveItemIdArr:Array;
      
      public var isHaveItemRewardArr:Array;
      
      public var isOpenFrame:Boolean = false;
      
      public var buyFrameEnable:Boolean = true;
      
      public var isMove:Boolean = false;
      
      public var maxPowerCount:int;
      
      public var maxGoldDiceCount:int;
      
      public function TreasureLostManager()
      {
         super();
      }
      
      public static function get Instance() : TreasureLostManager
      {
         if(_instance == null)
         {
            _instance = new TreasureLostManager();
         }
         return _instance;
      }
      
      public function getTreasureLostStoneNum() : String
      {
         var num:int = this.treasureLostStoneNum;
         return num.toString();
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TREASURELOST_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var type:int = 0;
         pkg = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case TreasureLostPackageType.TREASURELOST_OPEN_CLOSE:
               this.openOrclose(pkg);
               break;
            case TreasureLostPackageType.ENTERGAME:
               this.enterView(pkg);
               break;
            case TreasureLostPackageType.TREASURELOST_ROLLDICE:
               type = pkg.readInt();
               if(type == 1)
               {
                  this.getRollDice(pkg);
               }
               else if(type == 3)
               {
                  this.getGoldRollDice(pkg);
               }
               else if(type == 2)
               {
                  this.selectChadao(pkg);
               }
               break;
            case TreasureLostPackageType.TREASURELOST_EVENT_DISPATCH:
               this.eventDispatch(pkg);
               break;
            case TreasureLostPackageType.TREASURELOST_BUYITEM:
               this.buyItem(pkg);
               break;
            case TreasureLostPackageType.TREASURELOST_UPDATA_FIVEITEM:
               this.updataFiveItem(pkg);
         }
      }
      
      private function updataFiveItem(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.UpDate_FIVE_ITEM,pkg));
      }
      
      private function buyItem(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.PLAYER_BUY_ITEM,pkg));
      }
      
      private function eventDispatch(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.PLAYER_EVENT_DISPATCH,pkg));
      }
      
      private function getRollDice(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.PLAYER_ROLL_DICE,pkg));
      }
      
      private function getGoldRollDice(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.PLAYER_ROLL_GOLDDICE,pkg));
      }
      
      private function selectChadao(pkg:PackageIn) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.PLAYER_SELECT_CHADAO,pkg));
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isShowIcon = pkg.readBoolean();
         if(this._isShowIcon)
         {
            this.addEnterIcon();
         }
         else
         {
            this.disposeEnterIcon();
            if(Boolean(this._treasureLostFrame))
            {
               this._treasureLostFrame.dispose();
            }
            LayerManager.Instance.clearnGameDynamic();
         }
      }
      
      public function addEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASURELOST,true);
      }
      
      private function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASURELOST,false);
      }
      
      public function enterView(pkg:PackageIn) : void
      {
         var itemId:int = 0;
         var itemReward:Boolean = false;
         this.isHaveItemIdArr = [];
         this.isHaveItemRewardArr = [];
         this.powerBuyPrice = ServerConfigManager.instance.treasureLostPowerPrice;
         this.goldDiceBuyPrice = ServerConfigManager.instance.treasureLostGolidDicePrice;
         this.currentMap = pkg.readInt();
         this.playerCurrentPath = pkg.readInt();
         this.power = pkg.readInt();
         this.unWalkPoint = pkg.readInt();
         this.goldDiceRollBuyCount = pkg.readInt();
         this.treasureLostStoneNum = pkg.readInt();
         this.powerBuyCountLimite = pkg.readInt();
         this.goldDiceRollBuyCountLimite = pkg.readInt();
         this.isDoubleBuff = pkg.readBoolean();
         for(var i:int = 0; i < 5; i++)
         {
            itemId = pkg.readInt();
            itemReward = pkg.readBoolean();
            this.isHaveItemIdArr.push(itemId);
            this.isHaveItemRewardArr.push(itemReward);
         }
         this.mapTypeArr = pkg.readUTF();
         this.maxPowerCount = pkg.readInt();
         this.maxGoldDiceCount = pkg.readInt();
         if(loadComplete)
         {
            this.showTreasurePuzzleMainView(this.currentMap);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TREASURE_LOST);
         }
      }
      
      private function showTreasurePuzzleMainView(mapId:int) : void
      {
         var mapData:TreasureLostMapData = null;
         if(mapId == 1)
         {
            mapData = ComponentFactory.Instance.creatCustomObject("treasureLost.map1Data");
         }
         else if(mapId == 2)
         {
            mapData = ComponentFactory.Instance.creatCustomObject("treasureLost.map2Data");
         }
         else if(mapId == 3)
         {
            mapData = ComponentFactory.Instance.creatCustomObject("treasureLost.map3Data");
         }
         this.mapPosArr = mapData.mapItemPosArr;
         this.mapPlayerPath = mapData.playerPathArr;
         this.maxMapItemNum = mapData.maxMapItemNum;
         this.specialMapNum = mapData.specialItemNum;
         this.specialLength = mapData.specialLength;
         this._treasureLostFrame = ComponentFactory.Instance.creatComponentByStylename("treasureLost.treasureLostFrame");
         this._treasureLostFrame.addDiceView(1);
         this._treasureLostFrame.show();
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_LOST)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __completeShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_LOST)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showTreasurePuzzleMainView(this.currentMap);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._treasureLostFrame) && Boolean(this._treasureLostFrame.parent))
         {
            this._treasureLostFrame.dispose();
            this._treasureLostFrame = null;
         }
      }
   }
}

