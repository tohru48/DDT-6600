package ddt.loader
{
   import GodSyah.SyahManager;
   import SendRecord.SendRecordManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.StartupEvent;
   import ddt.manager.DesktopManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import deng.fzip.FZip;
   import deng.fzip.FZipFile;
   import email.manager.MailManager;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import road7th.comm.PackageIn;
   
   public class StartupResourceLoader extends EventDispatcher
   {
      
      private static var _instance:StartupResourceLoader;
      
      public static const NEWBIE:int = 1;
      
      public static const NORMAL:int = 2;
      
      public static const USER_GUILD_RESOURCE_COMPLETE:String = "userGuildResourceComplete";
      
      public static var firstEnterHall:Boolean = false;
      
      private var _currentMode:int = 0;
      
      private var _languageLoader:BaseLoader;
      
      private var _languagePath:String;
      
      private var _isSecondLoad:Boolean = false;
      
      private var _uimoduleProgress:Number;
      
      private var _progressArr:Array;
      
      private var _trainerComplete:Boolean;
      
      private var _trainerUIComplete:Boolean;
      
      private var _trainerFristComplete:Boolean;
      
      public var _queueIsComplete:Boolean;
      
      private var _loaderQueue:QueueLoader;
      
      private var _requestCompleted:int;
      
      public function StartupResourceLoader()
      {
         super();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RELOAD_XML,this.__reloadXML);
      }
      
      public static function get Instance() : StartupResourceLoader
      {
         if(_instance == null)
         {
            _instance = new StartupResourceLoader();
         }
         return _instance;
      }
      
      private function __reloadXML(event:CrazyTankSocketEvent) : void
      {
         var num:int = 0;
         var loader:BaseLoader = null;
         var pkg:PackageIn = event.pkg;
         num = pkg.readInt();
         switch(num)
         {
            case 1:
               loader = LoaderCreate.Instance.creatItemTempleteReload();
               break;
            case 2:
               loader = LoaderCreate.Instance.creatQuestTempleteReload();
               break;
            default:
               return;
         }
         if(Boolean(loader))
         {
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      public function reloadGodSyah(pkg:PackageIn) : void
      {
         var loader:BaseLoader = null;
         var type:int = pkg.readInt();
         SyahManager.Instance.isOpen = pkg.readBoolean();
         if(SyahManager.Instance.isOpen)
         {
            loader = LoaderCreate.Instance.creatGodSyahLoader(type);
            if(Boolean(loader))
            {
               LoaderManager.Instance.startLoad(loader);
            }
         }
         else
         {
            SyahManager.Instance.stopSyah();
         }
      }
      
      private function __onUIModuleLoadError(event:UIModuleEvent) : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ddt.StartupResourceLoader.Error.LoadModuleError",event.module),LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get progress() : int
      {
         if(this._loaderQueue == null)
         {
            return int(this._uimoduleProgress * 35) + 40;
         }
         if(this._queueIsComplete)
         {
            return 99;
         }
         var percent:int = this._uimoduleProgress * 35 + this._requestCompleted / this._loaderQueue.length * 25 + 40;
         return percent > 99 ? 99 : percent;
      }
      
      public function start(mode:int) : void
      {
         this._currentMode = mode;
         this.loadLanguage();
      }
      
      private function loadLanguage() : void
      {
         this._languagePath = PathManager.getLanguagePath();
         this._languageLoader = LoadResourceManager.Instance.createLoader(this._languagePath,BaseLoader.BYTE_LOADER);
         this._languageLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         LoadResourceManager.Instance.startLoad(this._languageLoader);
      }
      
      private function __onLoadLanZipComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         var temp:ByteArray = event.loader.content;
         this.analyMd5(temp);
      }
      
      private function zipLoad(content:ByteArray) : void
      {
         var zip:FZip = new FZip();
         zip.addEventListener(Event.COMPLETE,this.__onZipParaComplete);
         zip.loadBytes(content);
      }
      
      private function analyMd5(content:ByteArray) : void
      {
         var temp:ByteArray = null;
         if(ComponentSetting.USEMD5 && (ComponentSetting.md5Dic["language.png"] || this.hasHead(content)))
         {
            if(this.compareMD5(content))
            {
               temp = new ByteArray();
               content.position = 37;
               content.readBytes(temp);
               this.zipLoad(temp);
            }
            else
            {
               if(this._isSecondLoad)
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("alert",this._languagePath + ":is old");
                  }
               }
               else
               {
                  this._languagePath = this._languagePath.replace(ComponentSetting.FLASHSITE,ComponentSetting.BACKUP_FLASHSITE);
                  this._languageLoader.url = this._languagePath + "?rnd=" + Math.random();
                  this._languageLoader.isLoading = false;
                  this._languageLoader.loadFromWeb();
               }
               this._isSecondLoad = true;
            }
         }
         else
         {
            this.zipLoad(content);
         }
      }
      
      private function hasHead(temp:ByteArray) : Boolean
      {
         var source:int = 0;
         var target:int = 0;
         var road7Byte:ByteArray = new ByteArray();
         road7Byte.writeUTFBytes(ComponentSetting.swf_head);
         road7Byte.position = 0;
         temp.position = 0;
         while(road7Byte.bytesAvailable > 0)
         {
            source = road7Byte.readByte();
            target = temp.readByte();
            if(source != target)
            {
               return false;
            }
         }
         return true;
      }
      
      private function compareMD5(temp:ByteArray) : Boolean
      {
         var source:int = 0;
         var target:int = 0;
         var md5Bytes:ByteArray = new ByteArray();
         md5Bytes.writeUTFBytes(ComponentSetting.md5Dic["language.png"]);
         md5Bytes.position = 0;
         temp.position = 5;
         while(md5Bytes.bytesAvailable > 0)
         {
            source = md5Bytes.readByte();
            target = temp.readByte();
            if(source != target)
            {
               return false;
            }
         }
         return true;
      }
      
      private function __onZipParaComplete(event:Event) : void
      {
         var zip:FZip = event.currentTarget as FZip;
         zip.removeEventListener(Event.COMPLETE,this.__onZipParaComplete);
         var file:FZipFile = zip.getFileAt(0);
         var content:String = file.content.toString();
         LanguageMgr.setup(content);
         var loaderQueue:QueueLoader = new QueueLoader();
         loaderQueue.addLoader(LoaderCreate.Instance.creatZhanLoader());
         loaderQueue.addEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         loaderQueue.start();
      }
      
      private function __onLoadLanguageComplete(event:Event) : void
      {
         var loaderQueue:QueueLoader = event.currentTarget as QueueLoader;
         loaderQueue.removeEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         if(this._currentMode == NEWBIE)
         {
            this.newBieXML();
         }
         else
         {
            this.loadUIModule();
         }
         this._setStageRightMouse();
      }
      
      private function __onUIModuleProgress(event:UIModuleEvent) : void
      {
         var i:uint = 0;
         var uiType:String = null;
         var loader:BaseLoader = event.loader;
         if(event.module == UIModuleTypes.ROAD_COMPONENT)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.CORE_ICON_AND_TIP)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.DDTCORESCALEBITMAP)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.CHAT)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.CHATII)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.PLAYER_TIP)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.LEVEL_ICON)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.ENTHRALL)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.TRAINER)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.TRAINER_UI)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.DDT_HALL)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
		 if(event.module == UIModuleTypes.DDT_HALL_MAIN)
		 {
			 this.setLoaderProgressArr(event.module,loader.progress);
		 }
         if(event.module == UIModuleTypes.DDT_HALLICON)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.TOOLBAR)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.DDT_TIMEBOX)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(event.module == UIModuleTypes.ACADEMY_COMMON)
         {
            this.setLoaderProgressArr(event.module,loader.progress);
         }
         if(!this._progressArr)
         {
            return;
         }
         var num:Number = 0;
         var total:uint = this._progressArr.length;
         for(i = 0; i < total; i++)
         {
            uiType = this._progressArr[i];
            num += this._progressArr[uiType];
         }
         this._uimoduleProgress = num / total;
      }
      
      private function setLoaderProgressArr($name:String, num:Number = 0) : void
      {
         if(!this._progressArr)
         {
            this._progressArr = [];
         }
         if(this._progressArr.indexOf($name) < 0)
         {
            this._progressArr.push($name);
            this._progressArr[$name] = num;
         }
         else
         {
            this._progressArr[$name] = num;
         }
      }
      
      public function addUserGuildResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINERFIRSTGAME);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER_UI);
      }
      
      public function finishLoadingProgress() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function startLoadRelatedInfo() : void
      {
         var loaderQueue:QueueLoader = new QueueLoader();
         loaderQueue.addLoader(LoaderCreate.Instance.creatVoteSubmit());
         this.SendVersion();
         loaderQueue.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.creatFriendListLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.creatMyacademyPlayerListLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.getMyConsortiaData());
         loaderQueue.addLoader(LoaderCreate.Instance.createCalendarRequest());
         loaderQueue.addLoader(MailManager.Instance.getAllEmailLoader());
         loaderQueue.addLoader(MailManager.Instance.getSendedEmailLoader());
         loaderQueue.addLoader(ConsortionModelControl.Instance.getLevelUpInfo());
         loaderQueue.addLoader(LoaderCreate.Instance.creatFeedbackInfoLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.createConsortiaLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.creatItemTempleteReload());
         loaderQueue.addLoader(LoaderCreate.Instance.createGodsRoadsLoader());
         loaderQueue.addLoader(LoaderCreate.Instance.createAddPublicTipLoader());
         loaderQueue.start();
      }
      
      private function __onSetupSourceLoadComplete(event:Event) : void
      {
         var queue:QueueLoader = event.currentTarget as QueueLoader;
         queue.removeEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         queue.removeEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         queue.dispose();
         queue = null;
         this._queueIsComplete = true;
         dispatchEvent(new StartupEvent(StartupEvent.CORE_SETUP_COMPLETE));
      }
      
      private function __onUIMoudleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TRAINER || event.module == UIModuleTypes.TRAINER_UI || event.module == UIModuleTypes.TRAINERFIRSTGAME)
         {
            if(event.module == UIModuleTypes.TRAINER)
            {
               this._trainerComplete = true;
            }
            if(event.module == UIModuleTypes.TRAINER_UI)
            {
               this._trainerUIComplete = true;
            }
            if(event.module == UIModuleTypes.TRAINERFIRSTGAME)
            {
               this._trainerFristComplete = true;
            }
            if(this._trainerComplete && this._trainerUIComplete && this._trainerFristComplete)
            {
               dispatchEvent(new Event(USER_GUILD_RESOURCE_COMPLETE));
            }
         }
         if(event.module == UIModuleTypes.DDT_TIMEBOX)
         {
            LoaderSavingManager.saveFilesToLocal();
            dispatchEvent(new StartupEvent(StartupEvent.CORE_LOAD_COMPLETE));
            this._loaderQueue = new QueueLoader();
            this._queueIsComplete = false;
            this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
            this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
            this.addLoader(LoaderCreate.Instance.creatActiveInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatActionExchangeInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatItemTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatGoodCategoryLoader());
            this.addLoader(LoaderCreate.Instance.creatShopTempleteLoader());
            this.addLoader(LoaderCreate.Instance.createCardSetsSortRule());
            this.addLoader(LoaderCreate.Instance.createCardSetsProperties());
            this.addLoader(ConsortionModelControl.Instance.loadSkillInfoList());
            this.addLoader(LoaderCreate.Instance.creatServerListLoader());
            this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
            this.addLoader(LoaderCreate.Instance.creatQuestTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatEffortTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatAllQuestionInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatUserBoxInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatBoxTempInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
            this.addLoader(LoaderCreate.Instance.creatShopSortLoader());
            this.addLoader(LoaderCreate.Instance.creatMapInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDungeonInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatOpenMapInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatExpericenceAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatPetExpericenceAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatWeaponBallAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatTexpExpLoader());
            this.addLoader(LoaderCreate.Instance.creatBadgeInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyLeagueAwardLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyLeagueLevelLoader());
            this.addLoader(LoaderCreate.Instance.createWishInfoLader());
            this.addLoader(LoaderCreate.Instance.creatServerConfigLoader());
            this.addLoader(LoaderCreate.Instance.creatPetInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatPetSkillLoader());
            this.addLoader(LoaderCreate.Instance.creatPetSkillTemplateInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatFoodComposeLoader());
            this.addLoader(LoaderCreate.Instance.creatFarmPoultryInfo());
            this.addLoader(LoaderCreate.Instance.creatPetConfigLoader());
            this.addLoader(LoaderCreate.Instance.createStoreEquipConfigLoader());
            this.addLoader(LoaderCreate.Instance.creatCardGrooveLoader());
            this.addLoader(LoaderCreate.Instance.creatCardTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatItemStrengthenGoodsInfoLoader());
            this.addLoader(LoaderCreate.Instance.createBeadTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatShopDisCountRealTimesLoader());
            this.addLoader(LoaderCreate.Instance.creatHallIcon());
            this.addLoader(LoaderCreate.Instance.createTotemTemplateLoader());
            this.addLoader(LoaderCreate.Instance.createHonorUpTemplateLoader());
            this.addLoader(LoaderCreate.Instance.createConsortiaBossTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatActiveLoader());
            this.addLoader(LoaderCreate.Instance.creatActivePointLoader());
            this.addLoader(LoaderCreate.Instance.creatRewardLoader());
            this.addLoader(LoaderCreate.Instance.loaderSearchGoodsPayMoney());
            this.addLoader(LoaderCreate.Instance.loaderSearchGoodsTemp());
            this.addLoader(LoaderCreate.Instance.creatWondActiveLoader());
            this.addLoader(LoaderCreate.Instance.firstRechargeLoader());
            this.addLoader(LoaderCreate.Instance.accumulativeLoginLoader());
            this.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
            this.addLoader(LoaderCreate.Instance.createDragonBoatActiveLoader());
            this.addLoader(LoaderCreate.Instance.createCaddyAwardsLoader());
            this.addLoader(LoaderCreate.Instance.createNewFusionDataLoader());
            this.addLoader(LoaderCreate.Instance.createEnergyDataLoader());
            this.addLoader(LoaderCreate.Instance.createActivitySystemItemsLoader());
            this.addLoader(LoaderCreate.Instance.loadWonderfulActivityXml());
            this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
            this.addLoader(LoaderCreate.Instance.createAvatarCollectionUnitDataLoader());
            this.addLoader(LoaderCreate.Instance.createAvatarCollectionItemDataLoader());
            this.addLoader(LoaderCreate.Instance.createPetsRisingStarDataLoader());
            this.addLoader(LoaderCreate.Instance.createPetsEvolutionDataLoader());
            this.addLoader(LoaderCreate.Instance.getPetsFormDataLoader());
            this.addLoader(LoaderCreate.Instance.loadMagicStoneTemplate());
            this.addLoader(LoaderCreate.Instance.createHorseTemplateDataLoader());
            this.addLoader(LoaderCreate.Instance.createHorseSkillGetDataLoader());
            this.addLoader(LoaderCreate.Instance.createHorseSkillDataLoader());
            this.addLoader(LoaderCreate.Instance.createHorseSkillElementDataLoader());
            this.addLoader(LoaderCreate.Instance.createCollectionRebortDataLoader());
            this.addLoader(LoaderCreate.Instance.createHorsePicCherishDataLoader());
            this.addLoader(LoaderCreate.Instance.createNewTitleDataLoader());
            this.addLoader(LoaderCreate.Instance.createRescueRewardLoader());
            this.addLoader(LoaderCreate.Instance.createLoadPetMoePropertyLoader());
            if(PathManager.suitEnable)
            {
               this.addLoader(LoaderCreate.Instance.creatSuitTempleteLoader());
               this.addLoader(LoaderCreate.Instance.creatEquipSuitTempleteLoader());
            }
            if(PathManager.GodSyahEnable)
            {
               this.addLoader(LoaderCreate.Instance.creatGodSyahLoader());
            }
            this.addLoader(LoaderCreate.Instance.creatSuperWinnerLoader());
            this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
            this.addLoader(LoaderCreate.Instance.createLightRoadLoader());
            this.addLoader(LoaderCreate.Instance.createGodsRoadsLoader());
            this.addLoader(LoaderCreate.Instance.createHalloweenLoader());
            this.addLoader(LoaderCreate.Instance.createEnchantMagicInfoLoader());
            this._loaderQueue.start();
         }
         if(event.module == UIModuleTypes.NEW_OPEN_GUIDE)
         {
            dispatchEvent(new Event("RegisterUIModuleComplete"));
         }
      }
      
      private function newBieXML() : void
      {
         this._loaderQueue = new QueueLoader();
         this._queueIsComplete = false;
         this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         this.addLoader(LoaderCreate.Instance.creatActiveInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatActionExchangeInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatItemTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatGoodCategoryLoader());
         this.addLoader(LoaderCreate.Instance.creatShopTempleteLoader());
         this.addLoader(LoaderCreate.Instance.createCardSetsSortRule());
         this.addLoader(LoaderCreate.Instance.createCardSetsProperties());
         this.addLoader(ConsortionModelControl.Instance.loadSkillInfoList());
         this.addLoader(LoaderCreate.Instance.creatServerListLoader());
         this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
         this.addLoader(LoaderCreate.Instance.creatQuestTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatEffortTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatAllQuestionInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatUserBoxInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatBoxTempInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatDailyInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
         this.addLoader(LoaderCreate.Instance.creatShopSortLoader());
         this.addLoader(LoaderCreate.Instance.creatMapInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatDungeonInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatOpenMapInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatExpericenceAnalyzeLoader());
         this.addLoader(LoaderCreate.Instance.creatPetExpericenceAnalyzeLoader());
         this.addLoader(LoaderCreate.Instance.creatWeaponBallAnalyzeLoader());
         this.addLoader(LoaderCreate.Instance.creatTexpExpLoader());
         this.addLoader(LoaderCreate.Instance.creatBadgeInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatDailyLeagueAwardLoader());
         this.addLoader(LoaderCreate.Instance.creatDailyLeagueLevelLoader());
         this.addLoader(LoaderCreate.Instance.createWishInfoLader());
         this.addLoader(LoaderCreate.Instance.creatServerConfigLoader());
         this.addLoader(LoaderCreate.Instance.creatPetInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatPetSkillLoader());
         this.addLoader(LoaderCreate.Instance.creatPetSkillTemplateInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatFoodComposeLoader());
         this.addLoader(LoaderCreate.Instance.creatFarmPoultryInfo());
         this.addLoader(LoaderCreate.Instance.creatPetConfigLoader());
         this.addLoader(LoaderCreate.Instance.createStoreEquipConfigLoader());
         this.addLoader(LoaderCreate.Instance.creatCardGrooveLoader());
         this.addLoader(LoaderCreate.Instance.creatCardTemplateLoader());
         this.addLoader(LoaderCreate.Instance.creatItemStrengthenGoodsInfoLoader());
         this.addLoader(LoaderCreate.Instance.createBeadTemplateLoader());
         this.addLoader(LoaderCreate.Instance.creatShopDisCountRealTimesLoader());
         this.addLoader(LoaderCreate.Instance.creatHallIcon());
         this.addLoader(LoaderCreate.Instance.createTotemTemplateLoader());
         this.addLoader(LoaderCreate.Instance.createHonorUpTemplateLoader());
         this.addLoader(LoaderCreate.Instance.createConsortiaBossTemplateLoader());
         this.addLoader(LoaderCreate.Instance.creatActiveLoader());
         this.addLoader(LoaderCreate.Instance.creatActivePointLoader());
         this.addLoader(LoaderCreate.Instance.creatRewardLoader());
         this.addLoader(LoaderCreate.Instance.loaderSearchGoodsPayMoney());
         this.addLoader(LoaderCreate.Instance.loaderSearchGoodsTemp());
         this.addLoader(LoaderCreate.Instance.creatWondActiveLoader());
         this.addLoader(LoaderCreate.Instance.firstRechargeLoader());
         this.addLoader(LoaderCreate.Instance.accumulativeLoginLoader());
         this.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
         this.addLoader(LoaderCreate.Instance.createDragonBoatActiveLoader());
         this.addLoader(LoaderCreate.Instance.createCaddyAwardsLoader());
         this.addLoader(LoaderCreate.Instance.createNewFusionDataLoader());
         this.addLoader(LoaderCreate.Instance.createEnergyDataLoader());
         this.addLoader(LoaderCreate.Instance.createActivitySystemItemsLoader());
         this.addLoader(LoaderCreate.Instance.loadWonderfulActivityXml());
         this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
         this.addLoader(LoaderCreate.Instance.createAvatarCollectionUnitDataLoader());
         this.addLoader(LoaderCreate.Instance.createAvatarCollectionItemDataLoader());
         this.addLoader(LoaderCreate.Instance.createPetsRisingStarDataLoader());
         this.addLoader(LoaderCreate.Instance.createPetsEvolutionDataLoader());
         this.addLoader(LoaderCreate.Instance.getPetsFormDataLoader());
         this.addLoader(LoaderCreate.Instance.loadMagicStoneTemplate());
         this.addLoader(LoaderCreate.Instance.createHorseTemplateDataLoader());
         this.addLoader(LoaderCreate.Instance.createHorseSkillGetDataLoader());
         this.addLoader(LoaderCreate.Instance.createHorseSkillDataLoader());
         this.addLoader(LoaderCreate.Instance.createHorseSkillElementDataLoader());
         this.addLoader(LoaderCreate.Instance.createCollectionRebortDataLoader());
         this.addLoader(LoaderCreate.Instance.createHorsePicCherishDataLoader());
         this.addLoader(LoaderCreate.Instance.createNewTitleDataLoader());
         this.addLoader(LoaderCreate.Instance.createRescueRewardLoader());
         this.addLoader(LoaderCreate.Instance.createLoadPetMoePropertyLoader());
         if(PathManager.suitEnable)
         {
            this.addLoader(LoaderCreate.Instance.creatSuitTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatEquipSuitTempleteLoader());
         }
         if(PathManager.GodSyahEnable)
         {
            this.addLoader(LoaderCreate.Instance.creatGodSyahLoader());
         }
         this.addLoader(LoaderCreate.Instance.creatSuperWinnerLoader());
         this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
         this.addLoader(LoaderCreate.Instance.createLightRoadLoader());
         this.addLoader(LoaderCreate.Instance.createGodsRoadsLoader());
         this.addLoader(LoaderCreate.Instance.createHalloweenLoader());
         this.addLoader(LoaderCreate.Instance.createEnchantMagicInfoLoader());
         this._loaderQueue.start();
      }
      
      private function addLoader(loader:BaseLoader) : void
      {
         this._loaderQueue.addLoader(loader);
      }
      
      private function __onSetupSourceLoadChange(event:Event) : void
      {
         this._requestCompleted = (event.currentTarget as QueueLoader).completeCount;
      }
      
      public function addRegisterUIModule() : void
      {
         firstEnterHall = true;
         this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
         this.addUIModlue(UIModuleTypes.FIRST_CORE);
         this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
         this.addUIModlue(UIModuleTypes.CHAT);
         this.addUIModlue(UIModuleTypes.ENTHRALL);
         this.addUIModlue(UIModuleTypes.TRAINERFIRSTGAME);
         this.addUIModlue(UIModuleTypes.TRAINER_UI);
         this.addUIModlue(UIModuleTypes.TOOLBAR);
         this.addUIModlue(UIModuleTypes.DDT_COREII);
         this.addUIModlue(UIModuleTypes.SYSTEM_OPEN_PROMPT);
         this.addUIModlue(UIModuleTypes.DDT_HALL);
		 this.addUIModlue(UIModuleTypes.DDT_HALL_MAIN);
         this.addUIModlue(UIModuleTypes.DDT_HALLICON);
         this.addUIModlue(UIModuleTypes.DDT_COREI);
         this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
         this.addUIModlue(UIModuleTypes.LEVEL_ICON);
         this.addUIModlue(UIModuleTypes.PLAYER_TIP);
         this.addUIModlue(UIModuleTypes.CHATII);
         this.addUIModlue(UIModuleTypes.TRAINER);
         this.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
         this.addUIModlue(UIModuleTypes.NEW_OPEN_GUIDE);
         this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
         this.setLoaderProgressArr(UIModuleTypes.FIRST_CORE);
         this.setLoaderProgressArr(UIModuleTypes.DDTCORESCALEBITMAP);
         this.setLoaderProgressArr(UIModuleTypes.CHAT);
         this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
         this.setLoaderProgressArr(UIModuleTypes.TRAINERFIRSTGAME);
         this.setLoaderProgressArr(UIModuleTypes.TRAINER_UI);
         this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
         this.setLoaderProgressArr(UIModuleTypes.DDT_COREII);
         this.setLoaderProgressArr(UIModuleTypes.SYSTEM_OPEN_PROMPT);
         this.setLoaderProgressArr(UIModuleTypes.DDT_HALL);
		 this.setLoaderProgressArr(UIModuleTypes.DDT_HALL_MAIN);
         this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
         this.setLoaderProgressArr(UIModuleTypes.DDT_COREI);
         this.setLoaderProgressArr(UIModuleTypes.CORE_ICON_AND_TIP);
         this.setLoaderProgressArr(UIModuleTypes.LEVEL_ICON);
         this.setLoaderProgressArr(UIModuleTypes.PLAYER_TIP);
         this.setLoaderProgressArr(UIModuleTypes.CHATII);
         this.setLoaderProgressArr(UIModuleTypes.TRAINER);
         this.setLoaderProgressArr(UIModuleTypes.ACADEMY_COMMON);
         this.setLoaderProgressArr(UIModuleTypes.NEW_OPEN_GUIDE);
      }
      
      public function addThirdGameUI() : void
      {
         firstEnterHall = false;
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALL);
		 UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALL_MAIN);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALLICON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREI);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.SYSTEM_OPEN_PROMPT);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CHATII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.PLAYER_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.LEVEL_ICON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
      }
      
      private function loadUIModule() : void
      {
         if(this._currentMode == NORMAL)
         {
            this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
            this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.TRAINER);
            this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
            this.addUIModlue(UIModuleTypes.FIRST_CORE);
            this.addUIModlue(UIModuleTypes.DDT_COREI);
            this.addUIModlue(UIModuleTypes.DDT_COREII);
            this.addUIModlue(UIModuleTypes.SYSTEM_OPEN_PROMPT);
            this.addUIModlue(UIModuleTypes.CHAT);
            this.addUIModlue(UIModuleTypes.CHATII);
            this.addUIModlue(UIModuleTypes.GAME);
            this.addUIModlue(UIModuleTypes.PLAYER_TIP);
            this.addUIModlue(UIModuleTypes.LEVEL_ICON);
            this.addUIModlue(UIModuleTypes.ENTHRALL);
            this.addUIModlue(UIModuleTypes.DDT_HALL);
			this.addUIModlue(UIModuleTypes.DDT_HALL_MAIN);
            this.addUIModlue(UIModuleTypes.DDT_HALLICON);
            this.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
            this.addUIModlue(UIModuleTypes.TOOLBAR);
            this.addUIModlue(UIModuleTypes.NEW_OPEN_GUIDE);
            this.addUIModlue(UIModuleTypes.NEW_VERSION_GUIDE);
            this.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
            this.addUIModlue(UIModuleTypes.DDTBEAD);
            this.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
            this.addUIModlue(UIModuleTypes.CONSORTIAII);
            this.addUIModlue(UIModuleTypes.MAGICHOUSE);
            this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
            this.setLoaderProgressArr(UIModuleTypes.CORE_ICON_AND_TIP);
            this.setLoaderProgressArr(UIModuleTypes.DDTCORESCALEBITMAP);
            this.setLoaderProgressArr(UIModuleTypes.FIRST_CORE);
            this.setLoaderProgressArr(UIModuleTypes.DDT_COREI);
            this.setLoaderProgressArr(UIModuleTypes.DDT_COREII);
            this.setLoaderProgressArr(UIModuleTypes.SYSTEM_OPEN_PROMPT);
            this.setLoaderProgressArr(UIModuleTypes.CHAT);
            this.setLoaderProgressArr(UIModuleTypes.CHATII);
            this.setLoaderProgressArr(UIModuleTypes.GAME);
            this.setLoaderProgressArr(UIModuleTypes.PLAYER_TIP);
            this.setLoaderProgressArr(UIModuleTypes.LEVEL_ICON);
            this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
            this.setLoaderProgressArr(UIModuleTypes.DDT_HALL);
			this.setLoaderProgressArr(UIModuleTypes.DDT_HALL_MAIN);
            this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
            this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
            this.setLoaderProgressArr(UIModuleTypes.NEW_OPEN_GUIDE);
            this.setLoaderProgressArr(UIModuleTypes.NEW_VERSION_GUIDE);
            this.setLoaderProgressArr(UIModuleTypes.ACADEMY_COMMON);
            this.setLoaderProgressArr(UIModuleTypes.DDT_TIMEBOX);
            this.setLoaderProgressArr(UIModuleTypes.CONSORTIAII);
            this.setLoaderProgressArr(UIModuleTypes.MAGICHOUSE);
         }
      }
      
      public function addFirstGameNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTROOMLOADING);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEIII);
      }
      
      public function addNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAGANDINFO);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTSTORE);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
      }
      
      private function addUIModlue(ui:String) : void
      {
         UIModuleLoader.Instance.addUIModlue(ui);
      }
      
      private function _setStageRightMouse() : void
      {
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_BOTTOM_LAYER).contextMenu = this.creatRightMenu();
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.addCallback("sendSwfNowUrl",this.receivedFromJavaScript);
         }
      }
      
      private function creatRightMenu() : ContextMenu
      {
         var myContextMenu:ContextMenu = new ContextMenu();
         myContextMenu.hideBuiltInItems();
         var item:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.share"));
         item.separatorBefore = true;
         myContextMenu.customItems.push(item);
         item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onQQMSNClick);
         var item1:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.collection"));
         item1.separatorBefore = true;
         myContextMenu.customItems.push(item1);
         item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.addFavClick);
         var item2:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.supply"));
         item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.goPayClick);
         myContextMenu.customItems.push(item2);
         myContextMenu.builtInItems.zoom = true;
         return myContextMenu;
      }
      
      private function onQQMSNClick(e:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("getLocationUrl","");
         }
      }
      
      public function receivedFromJavaScript(str:String) : void
      {
         this._receivedFromJavaScriptII(str);
      }
      
      private function _receivedFromJavaScriptII(str:String) : void
      {
         System.setClipboard(str);
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazytank.copyOK"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function SendVersion() : void
      {
         var varialbes:URLVariables = new URLVariables();
         var urlLoader:URLLoader = new URLLoader();
         varialbes.version = Capabilities.version.split(" ")[1];
         var request:URLRequest = new URLRequest(PathManager.solveRequestPath("UpdateVersion.ashx"));
         request.method = URLRequestMethod.POST;
         request.data = varialbes;
         urlLoader.load(request);
         if(PathManager.isSendRecordUserVersion)
         {
            this.sendRecordUserVersion();
         }
         if(PathManager.isSendFlashInfo && !SharedManager.Instance.flashInfoExist)
         {
            this.sendUserVersion();
         }
      }
      
      private function sendRecordUserVersion() : void
      {
         var varialbes:URLVariables = new URLVariables();
         var urlLoader:URLLoader = new URLLoader();
         varialbes.Version = Capabilities.version.split(" ")[1];
         varialbes.Sys = Capabilities.os;
         varialbes.UserName = PlayerManager.Instance.Account.Account;
         var request:URLRequest = new URLRequest(PathManager.solveRequestPath("RecordUserVersion.ashx"));
         request.method = URLRequestMethod.POST;
         request.data = varialbes;
         urlLoader.load(request);
      }
      
      private function sendUserVersion() : void
      {
         SendRecordManager.Instance.setUp();
      }
      
      private function addFavClick(e:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("addToFavorite","");
         }
      }
      
      private function goPayClick(e:ContextMenuEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(evt.target);
      }
   }
}

