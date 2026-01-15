package farm
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.analyzer.FarmFriendListAnalyzer;
   import farm.analyzer.FarmTreePoultryListAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.analyzer.SuperPetFoodPriceAnalyzer;
   import farm.control.*;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import farm.view.*;
   import farm.viewx.FarmBuyFieldView;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class FarmModelController extends EventDispatcher
   {
      
      private static var _instance:FarmModelController;
      
      private var _model:FarmModel;
      
      private var _timer:Timer;
      
      private var _canGoFarm:Boolean = true;
      
      private var _landInfoVector:Vector.<FieldVO>;
      
      public var gropPrice:int;
      
      public var midAutumnFlag:Boolean;
      
      public var FightPoultryFlag:Boolean;
      
      public var isHelperOK:Boolean;
      
      public function FarmModelController()
      {
         super();
      }
      
      public static function get instance() : FarmModelController
      {
         return _instance = _instance || new FarmModelController();
      }
      
      public function setup() : void
      {
         this._model = new FarmModel();
         this._landInfoVector = new Vector.<FieldVO>();
         this.initEvent();
         FarmComposeHouseController.instance().setup();
      }
      
      public function get model() : FarmModel
      {
         return this._model;
      }
      
      public function stopTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
         this._canGoFarm = true;
      }
      
      public function startTimer() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__timerhandler);
         }
         this._timer.reset();
         this._timer.start();
      }
      
      public function sendEnterFarmPkg(useid:int) : void
      {
         SocketManager.Instance.out.enterFarm(useid);
         if(useid == PlayerManager.Instance.Self.ID)
         {
            this.startTimer();
         }
      }
      
      public function arrange() : void
      {
         SocketManager.Instance.out.arrange(this._model.currentFarmerId);
      }
      
      public function goFarm(id:int, name:String) : void
      {
         if(PlayerManager.Instance.Self.ID == id && PlayerManager.Instance.Self.Grade < 25)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarm.need20"));
            return;
         }
         if(this._canGoFarm)
         {
            this._model.currentFarmerName = name;
            this.sendEnterFarmPkg(id);
            this._canGoFarm = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.internal"));
         }
      }
      
      public function sowSeed(fieldId:int, seedsId:int) : void
      {
         SocketManager.Instance.out.seeding(fieldId,seedsId);
      }
      
      public function accelerateField(type:int, fieldId:int, manureId:int) : void
      {
         SocketManager.Instance.out.doMature(type,fieldId,manureId);
      }
      
      public function getHarvest(fieldId:int) : void
      {
         SocketManager.Instance.out.toGather(this.model.currentFarmerId,fieldId);
      }
      
      public function payField(arr:Array, time:int, bool:Boolean) : void
      {
         SocketManager.Instance.out.toSpread(arr,time,bool);
      }
      
      public function updateFriendListStolen() : void
      {
         this.updateSetupFriendListStolen(this.model.currentFarmerId);
      }
      
      public function setupFoodComposeList(anlyer:FoodComposeListAnalyzer) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.FOOD_COMPOSE_LISE_READY));
      }
      
      public function killCrop(fieldId:int) : void
      {
         SocketManager.Instance.out.toKillCrop(fieldId);
      }
      
      public function farmHelperSetSwitch(temp:Array, isAuto:Boolean) : void
      {
         SocketManager.Instance.out.toFarmHelper(temp,isAuto);
      }
      
      public function helperRenewMoney(hour:int, bool:Boolean) : void
      {
         SocketManager.Instance.out.toHelperRenewMoney(hour,bool);
      }
      
      public function exitFarm(playerID:int) : void
      {
         SocketManager.Instance.out.exitFarm(playerID);
      }
      
      public function openPayFieldFrame(fieldId:int) : void
      {
         var buyfield:FarmBuyFieldView = new FarmBuyFieldView(fieldId);
         LayerManager.Instance.addToLayer(buyfield,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getTreePoultryListData(analyzer:FarmTreePoultryListAnalyzer) : void
      {
         this._model.farmPoultryInfo = analyzer.list;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_LAND_INFO,this.__onFarmLandInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_FARM,this.__onEnterFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD,this.__gainFieldHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING,this.__onSeeding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PAY_FIELD,this.__payField);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DO_MATURE,this.__onDoMature);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_SWITCH,this.__onHelperSwitch);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KILL_CROP,this.__onKillCrop);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_PAY,this.__onHelperPay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_FARM,this.__onExitFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,this.__updateBuyExpExpNum);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,this.__arrangeFriendFarmHandler);
      }
      
      private function __arrangeFriendFarmHandler(event:CrazyTankSocketEvent) : void
      {
         var state:int = event.pkg.readInt();
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.arrange" + state));
         if(state == 0)
         {
            this._model.isArrange = true;
         }
         else
         {
            this._model.isArrange = false;
         }
         dispatchEvent(new FarmEvent(FarmEvent.ARRANGE_FRIEND_FARM));
      }
      
      protected function __onFarmLandInfo(event:CrazyTankSocketEvent) : void
      {
         var landinfo:FieldVO = null;
         if(this._landInfoVector.length > 0)
         {
            this._landInfoVector = new Vector.<FieldVO>();
         }
         var pkg:PackageIn = event.pkg;
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            landinfo = new FieldVO();
            landinfo.fieldID = pkg.readInt();
            landinfo.seedID = pkg.readInt();
            landinfo.plantTime = pkg.readDate();
            pkg.readInt();
            landinfo.AccelerateTime = pkg.readInt();
            this._landInfoVector.push(landinfo);
         }
         this.midAutumnFlag = pkg.readBoolean();
         this.isHelperOK = pkg.readBoolean();
         this.model.selfFieldsInfo = this._landInfoVector;
      }
      
      protected function __updateBuyExpExpNum(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._model.buyExpRemainNum = pkg.readInt();
         dispatchEvent(new FarmEvent(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM));
      }
      
      private function __timerhandler(event:TimerEvent) : void
      {
         this._timer.currentCount % 120 == 0;
         if(this._timer.currentCount % 120 == 0)
         {
         }
         if(this._timer.currentCount % 60 == 0)
         {
            dispatchEvent(new FarmEvent(FarmEvent.FRUSH_FIELD));
         }
         if(this._timer.currentCount % 2 == 0)
         {
            this._canGoFarm = true;
         }
      }
      
      private function __onEnterFarm(e:CrazyTankSocketEvent) : void
      {
         var fieldID:int = 0;
         var seedID:int = 0;
         var payTime:Date = null;
         var plantTime:Date = null;
         var gainCount:int = 0;
         var fieldValidDate:int = 0;
         var AccelerateTime:int = 0;
         var vo:FieldVO = null;
         var existVo:FieldVO = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new Vector.<FieldVO>();
         var p:PackageIn = e.pkg;
         this._model.currentFarmerId = p.readInt();
         var isAutomatic:Boolean = p.readBoolean();
         var autoSeedID:int = p.readInt();
         var autoStartTime:Date = p.readDate();
         var autoTime:int = p.readInt();
         var seedNeedCount:int = p.readInt();
         var gainPlatCount:int = p.readInt();
         var fieldDicCount:int = p.readInt();
         this.model.helperArray = new Array();
         this.model.helperArray.push(isAutomatic);
         this.model.helperArray.push(autoSeedID);
         this.model.helperArray.push(autoStartTime);
         this.model.helperArray.push(autoTime);
         this.model.helperArray.push(seedNeedCount);
         this.model.helperArray.push(gainPlatCount);
         for(var i:int = 0; i < fieldDicCount; i++)
         {
            fieldID = p.readInt();
            seedID = p.readInt();
            payTime = p.readDate();
            plantTime = p.readDate();
            gainCount = p.readInt();
            fieldValidDate = p.readInt();
            AccelerateTime = p.readInt();
            if(this.model.getfieldInfoById(fieldID) == null)
            {
               vo = new FieldVO();
               vo.fieldID = fieldID;
               vo.seedID = seedID;
               vo.payTime = payTime;
               vo.plantTime = plantTime;
               vo.fieldValidDate = fieldValidDate;
               vo.AccelerateTime = AccelerateTime;
               vo.gainCount = gainCount;
               vo.autoSeedID = autoSeedID;
               vo.isAutomatic = isAutomatic;
               this.model.fieldsInfo.push(vo);
            }
            else
            {
               existVo = this.model.getfieldInfoById(fieldID);
               existVo.seedID = seedID;
               existVo.payTime = payTime;
               existVo.plantTime = plantTime;
               existVo.fieldValidDate = fieldValidDate;
               existVo.AccelerateTime = AccelerateTime;
               existVo.gainCount = gainCount;
               existVo.autoSeedID = autoSeedID;
               existVo.isAutomatic = isAutomatic;
            }
         }
         if(this._model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.gropPrice = p.readInt();
            this._model.payFieldMoney = p.readUTF();
            this._model.payAutoMoney = p.readUTF();
            this._model.autoPayTime = p.readDate();
            this._model.autoValidDate = p.readInt();
            this._model.vipLimitLevel = p.readInt();
            this._model.selfFieldsInfo = this._model.fieldsInfo.concat();
            this._model.isAutoId = autoSeedID;
            this._model.buyExpRemainNum = p.readInt();
            PlayerManager.Instance.Self.isFarmHelper = isAutomatic;
         }
         else
         {
            this._model.isArrange = p.readBoolean();
         }
         StateManager.setState(StateType.FARM);
         dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
         SocketManager.Instance.out.getFarmPoultryLevel(FarmModelController.instance.model.currentFarmerId);
      }
      
      private function __gainFieldHandler(event:CrazyTankSocketEvent) : void
      {
         var field:FieldVO = null;
         var bol:Boolean = event.pkg.readBoolean();
         if(bol)
         {
            this.model.gainFieldId = event.pkg.readInt();
            field = this.model.getfieldInfoById(this.model.gainFieldId);
            field.seedID = event.pkg.readInt();
            field.plantTime = event.pkg.readDate();
            field.gainCount = event.pkg.readInt();
            field.AccelerateTime = event.pkg.readInt();
            dispatchEvent(new FarmEvent(FarmEvent.GAIN_FIELD));
         }
      }
      
      private function __payField(event:CrazyTankSocketEvent) : void
      {
         var fieldID:int = 0;
         var seedID:int = 0;
         var payTime:Date = null;
         var plantTime:Date = null;
         var gainCount:int = 0;
         var fieldValidDate:int = 0;
         var AccelerateTime:int = 0;
         var vo:FieldVO = null;
         var existVo:FieldVO = null;
         var pkg:PackageIn = event.pkg;
         this._model.currentFarmerId = pkg.readInt();
         var len:int = event.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            fieldID = pkg.readInt();
            seedID = pkg.readInt();
            payTime = pkg.readDate();
            plantTime = pkg.readDate();
            gainCount = pkg.readInt();
            fieldValidDate = pkg.readInt();
            AccelerateTime = pkg.readInt();
            if(this.model.getfieldInfoById(fieldID) == null)
            {
               vo = new FieldVO();
               vo.fieldID = fieldID;
               vo.seedID = seedID;
               vo.payTime = payTime;
               vo.plantTime = plantTime;
               vo.fieldValidDate = fieldValidDate;
               vo.AccelerateTime = AccelerateTime;
               vo.gainCount = gainCount;
               this.model.fieldsInfo.push(vo);
            }
            else
            {
               existVo = this.model.getfieldInfoById(fieldID);
               existVo.seedID = seedID;
               existVo.payTime = payTime;
               existVo.plantTime = plantTime;
               existVo.fieldValidDate = fieldValidDate;
               existVo.AccelerateTime = AccelerateTime;
               existVo.gainCount = gainCount;
            }
            dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.payField.success"));
         }
      }
      
      private function __onSeeding(e:CrazyTankSocketEvent) : void
      {
         var p:PackageIn = e.pkg;
         var fieldID:int = p.readInt();
         var seedID:int = p.readInt();
         var plantTime:Date = p.readDate();
         var payTime:Date = p.readDate();
         var gainNum:int = p.readInt();
         var accelerateDate:int = p.readInt();
         var fieldInfo:FieldVO = this.model.getfieldInfoById(fieldID);
         fieldInfo.seedID = seedID;
         fieldInfo.plantTime = plantTime;
         fieldInfo.gainCount = gainNum;
         this.model.seedingFieldInfo = fieldInfo;
         dispatchEvent(new FarmEvent(FarmEvent.HAS_SEEDING));
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.seeding.success"));
      }
      
      private function __onDoMature(event:CrazyTankSocketEvent) : void
      {
         var bol:Boolean = false;
         var field:FieldVO = null;
         var count:int = event.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            bol = event.pkg.readBoolean();
            if(bol)
            {
               this.model.matureId = event.pkg.readInt();
               field = this.model.getfieldInfoById(this.model.matureId);
               field.gainCount = event.pkg.readInt();
               field.AccelerateTime = event.pkg.readInt();
               dispatchEvent(new FarmEvent(FarmEvent.ACCELERATE_FIELD));
            }
         }
      }
      
      private function __onKillCrop(event:CrazyTankSocketEvent) : void
      {
         var seedId:int = 0;
         var accelerateDate:int = 0;
         var field:FieldVO = null;
         var bol:Boolean = event.pkg.readBoolean();
         if(bol)
         {
            this.model.killCropId = event.pkg.readInt();
            seedId = event.pkg.readInt();
            accelerateDate = event.pkg.readInt();
            field = this.model.getfieldInfoById(this.model.killCropId);
            field.seedID = seedId;
            field.AccelerateTime = accelerateDate;
            dispatchEvent(new FarmEvent(FarmEvent.KILLCROP_FIELD));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.fail"));
         }
      }
      
      private function __onHelperSwitch(event:CrazyTankSocketEvent) : void
      {
         this.model.helperArray = new Array();
         var isAutomatic:Boolean = event.pkg.readBoolean();
         var autoSeedID:int = event.pkg.readInt();
         var autoStartTime:Date = event.pkg.readDate();
         var autoTime:int = event.pkg.readInt();
         var needSeedCount1:int = event.pkg.readInt();
         var gainCount:int = event.pkg.readInt();
         this.model.helperArray.push(isAutomatic);
         this.model.helperArray.push(autoSeedID);
         this.model.helperArray.push(autoStartTime);
         this.model.helperArray.push(autoTime);
         this.model.helperArray.push(needSeedCount1);
         this.model.helperArray.push(gainCount);
         PlayerManager.Instance.Self.isFarmHelper = isAutomatic;
         if(isAutomatic)
         {
            dispatchEvent(new FarmEvent(FarmEvent.BEGIN_HELPER));
         }
         else
         {
            dispatchEvent(new FarmEvent(FarmEvent.STOP_HELPER));
         }
      }
      
      private function __onHelperPay(event:CrazyTankSocketEvent) : void
      {
         var autoPayTime:Date = event.pkg.readDate();
         var autoValidDate:int = event.pkg.readInt();
         this.model.autoPayTime = autoPayTime;
         this.model.autoValidDate = autoValidDate;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirmPnlSuccess"));
         this.model.dispatchEvent(new FarmEvent(FarmEvent.PAY_HELPER));
      }
      
      private function __onExitFarm(event:CrazyTankSocketEvent) : void
      {
      }
      
      public function updateSetupFriendListLoader() : void
      {
         var args:URLVariables = new URLVariables();
         args["selfid"] = PlayerManager.Instance.Self.ID;
         args["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FarmGetUserFieldInfos.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         loader.analyzer = new FarmFriendListAnalyzer(this.setupFriendList);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function updateSetupFriendListStolen(itemID:int) : void
      {
         var args:URLVariables = new URLVariables();
         args["selfid"] = PlayerManager.Instance.Self.ID;
         args["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         args["friendID"] = itemID;
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FarmGetUserFieldInfosSingle.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         loader.analyzer = new FarmFriendListAnalyzer(this.setupFriendStolen);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function creatSuperPetFoodPriceList() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(SuperPetFoodPriceAnalyzer.Path),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSpuerPetFoodPricetListComposeListFail");
         loader.analyzer = new SuperPetFoodPriceAnalyzer(this.setupSuperPetFoodPriceList);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onloadSpuerPetFoodPricetListComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      protected function __onloadSpuerPetFoodPricetListComplete(event:LoaderEvent) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupSuperPetFoodPriceList(analyzer:SuperPetFoodPriceAnalyzer) : void
      {
         this.model.priceList = analyzer.list;
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupFriendList(analyzer:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateList = analyzer.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIEND_INFO_READY));
      }
      
      public function setupFriendStolen(analyzer:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateListStolenInfo = analyzer.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIENDLIST_UPDATESTOLEN));
      }
      
      public function getCurrentMoney() : int
      {
         var buyExpRemainNum:int = 21 - this.model.buyExpRemainNum;
         for(var i:int = 0; i < this.model.priceList.length; i++)
         {
            if(this.model.priceList[i].Count == buyExpRemainNum)
            {
               return this.model.priceList[i].Money;
            }
         }
         return 0;
      }
      
      public function getCurrentSuperPetFoodPriceInfo() : SuperPetFoodPriceInfo
      {
         var buyExpRemainNum:int = 21 - this.model.buyExpRemainNum;
         for(var i:int = 0; i < this.model.priceList.length; i++)
         {
            if(this.model.priceList[i].Count == buyExpRemainNum)
            {
               return this.model.priceList[i];
            }
         }
         return null;
      }
   }
}

