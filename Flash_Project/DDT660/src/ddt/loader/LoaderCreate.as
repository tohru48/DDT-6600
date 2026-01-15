package ddt.loader
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import GodSyah.SyahAnalyzer;
   import GodSyah.SyahManager;
   import accumulativeLogin.AccumulativeLoginAnalyer;
   import accumulativeLogin.AccumulativeManager;
   import bagAndInfo.callPropData.CallPropDataAnalyer;
   import bagAndInfo.energyData.EnergyDataAnalyzer;
   import baglocked.BaglockedManager;
   import baglocked.phone4399.MsnConfirmAnalyzer;
   import bombKing.BombKingManager;
   import calendar.CalendarManager;
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.GrooveInfoManager;
   import cardSystem.analyze.CardTemplateAnalyzer;
   import cardSystem.analyze.SetsPropertiesAnalyzer;
   import cardSystem.analyze.SetsSortRuleAnalyzer;
   import chickActivation.ChickActivationManager;
   import collectionTask.CollectionTaskManager;
   import collectionTask.model.CollectionTaskAnalyzer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortiaBossDataAnalyzer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import dayActivity.ActivePointAnalzer;
   import dayActivity.ActivityAnalyzer;
   import dayActivity.ActivityRewardAnalyzer;
   import dayActivity.DayActivityManager;
   import ddt.data.Experience;
   import ddt.data.GoodsAdditioner;
   import ddt.data.PetExperience;
   import ddt.data.analyze.ActivitySystemItemsDataAnalyzer;
   import ddt.data.analyze.AddPublicTipDataAnalyzer;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import ddt.data.analyze.BallInfoAnalyzer;
   import ddt.data.analyze.BeadAnalyzer;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.CardGrooveEventAnalyzer;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.EffortItemTemplateInfoAnalyzer;
   import ddt.data.analyze.EquipSuitTempleteAnalyzer;
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.data.analyze.FightReportAnalyze;
   import ddt.data.analyze.FilterWordAnalyzer;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.GoodsAdditionAnalyer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.LoginSelectListAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.PetAllSkillAnalyzer;
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.data.analyze.PetInfoAnalyzer;
   import ddt.data.analyze.PetMoePropertyAnalyzer;
   import ddt.data.analyze.PetSkillAnalyzer;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.analyze.QuestionInfoAnalyze;
   import ddt.data.analyze.RegisterAnalyzer;
   import ddt.data.analyze.ServerConfigAnalyz;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.analyze.SuitTempleteAnalyzer;
   import ddt.data.analyze.TexpExpAnalyze;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitAnalyzer;
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.BallManager;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetAllSkillManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QuestionInfoMannager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ServerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VoteManager;
   import ddt.manager.WeaponBallManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.caddyII.CaddyAwardDataAnalyzer;
   import ddt.view.caddyII.CaddyAwardModel;
   import ddtBuried.BuriedManager;
   import ddtBuried.SearchGoodsPayAnalyer;
   import ddtBuried.UpdateStarAnalyer;
   import dragonBoat.DragonBoatManager;
   import dragonBoat.dataAnalyzer.DragonBoatActiveDataAnalyzer;
   import enchant.EnchantInfoAnalyzer;
   import enchant.EnchantManager;
   import farm.FarmModelController;
   import farm.analyzer.FarmTreePoultryListAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.control.FarmComposeHouseController;
   import feedback.FeedbackManager;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import firstRecharge.FirstRechargeManger;
   import firstRecharge.RechargeAnalyer;
   import flash.net.URLVariables;
   import flash.utils.getDefinitionByName;
   import godsRoads.analyze.GodsRoadsDataAnalyzer;
   import godsRoads.manager.GodsRoadsManager;
   import groupPurchase.GroupPurchaseManager;
   import groupPurchase.data.GroupPurchaseAwardAnalyzer;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import halloween.HalloweenManager;
   import halloween.analyze.HalloweenDataAnalyzer;
   import horse.HorseManager;
   import horse.dataAnalyzer.HorsePicCherishAnalyzer;
   import horse.dataAnalyzer.HorseSkillDataAnalyzer;
   import horse.dataAnalyzer.HorseSkillElementDataAnalyzer;
   import horse.dataAnalyzer.HorseSkillGetDataAnalyzer;
   import horse.dataAnalyzer.HorseTemplateDataAnalyzer;
   import horseRace.controller.HorseRaceManager;
   import kingDivision.KingDivisionManager;
   import lanternriddles.LanternRiddlesManager;
   import lanternriddles.data.LanternDataAnalyzer;
   import lightRoad.dataAnalyzer.LightRoadDataAnalyzer;
   import lightRoad.manager.LightRoadManager;
   import magicStone.MagicStoneManager;
   import magicStone.data.MagicStoneTempAnalyer;
   import mainbutton.data.HallIconDataAnalyz;
   import mainbutton.data.MainButtonManager;
   import newTitle.NewTitleManager;
   import newTitle.data.NewTitleDataAnalyz;
   import newYearRice.NewYearRiceManager;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.petsAdvanced.PetsEvolutionDataAnalyzer;
   import petsBag.petsAdvanced.PetsFormDataAnalyzer;
   import petsBag.petsAdvanced.PetsRisingStarDataAnalyzer;
   import pyramid.PyramidManager;
   import rescue.RescueManager;
   import rescue.data.RescueRewardAnalyzer;
   import roomList.movingNotification.MovingNotificationManager;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDayTarget.dataAnalyzer.SevenDayTargetDataAnalyzer;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import store.data.StoreEquipExperience;
   import store.forge.wishBead.WishBeadManager;
   import store.newFusion.FusionNewManager;
   import store.newFusion.data.FusionNewDataAnalyzer;
   import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import superWinner.analyze.SuperWinnerAnalyze;
   import superWinner.manager.SuperWinnerManager;
   import texpSystem.controller.TexpManager;
   import totem.HonorUpManager;
   import totem.TotemManager;
   import totem.data.HonorUpDataAnalyz;
   import totem.data.TotemDataAnalyz;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActAnalyer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.WonderfulGMActAnalyer;
   
   public class LoaderCreate
   {
      
      private static var _instance:LoaderCreate;
      
      private var _reloadCount:int = 0;
      
      private var _reloadQuestCount:int = 0;
      
      private var _rechargeCount:int = 0;
      
      private var _actReloadeCount:int = 0;
      
      public function LoaderCreate()
      {
         super();
      }
      
      public static function get Instance() : LoaderCreate
      {
         if(_instance == null)
         {
            _instance = new LoaderCreate();
         }
         return _instance;
      }
      
      public function createAudioILoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveSoundSwf(),BaseLoader.MODULE_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIFail");
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createAudioIILoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveSoundSwf2(),BaseLoader.MODULE_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIIFail");
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function loadExppression(fun:Function) : void
      {
         var loader:ModuleLoader = LoadResourceManager.Instance.createLoader(PathManager.getExpressionPath(),BaseLoader.MODULE_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingExpressionResourcesFailure");
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.addEventListener(LoaderEvent.COMPLETE,fun);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function creatBallInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("BallList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBombMetadataFailure");
         loader.analyzer = new BallInfoAnalyzer(BallManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatBoxTempInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadBoxTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsListFailure");
         loader.analyzer = new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatDungeonInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPVEItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingCopyMapsInformationFailure");
         loader.analyzer = new DungeonAnalyzer(MapManager.setupDungeonInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatEffortTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AchievementList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         loader.analyzer = new EffortItemTemplateInfoAnalyzer(EffortManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatFriendListLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["uname"] = PlayerManager.Instance.Account.Account;
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("IMListLoad.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         loader.analyzer = new FriendListAnalyzer(PlayerManager.Instance.setupFriendList);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatMyacademyPlayerListLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["RelationshipID"] = PlayerManager.Instance.Self.masterID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("UserApprenticeshipInfoList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         loader.analyzer = new MyAcademyPlayersAnalyze(PlayerManager.Instance.setupMyacademyPlayers);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatGoodCategoryLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadItemsCategory.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingItemTypeFailure");
         loader.analyzer = new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatItemTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TemplateAllList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         loader.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatItemTempleteReload() : BaseLoader
      {
         this._reloadCount += 1;
         var variables:URLVariables = new URLVariables();
         variables["lv"] = LoaderSavingManager.Version + this._reloadCount;
         variables["rnd"] = TextLoader.TextLoaderKey + this._reloadCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopBox.xml"),BaseLoader.TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingNewGoodsTemplateFailure");
         loader.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.addGoodsTemplates);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatBadgeInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaBadgeConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBadgeInfoFailure");
         loader.analyzer = new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatMovingNotificationLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getMovingNotificationPath(),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAnnouncementFailure");
         loader.analyzer = new MovingNotificationAnalyzer(MovingNotificationManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatDailyInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyAwardList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLoginFailedRewardInformation");
         loader.analyzer = new DaylyGiveAnalyzer(CalendarManager.getInstance().setDailyInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatMapInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadMapsItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadMapInformationFailure");
         loader.analyzer = new MapAnalyzer(MapManager.setupMapInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatOpenMapInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MapServerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingOpenMapListFailure");
         loader.analyzer = new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatQuestTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         loader.analyzer = new QuestListAnalyzer(TaskManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatQuestTempleteReload() : BaseLoader
      {
         this._reloadQuestCount += 1;
         var variables:URLVariables = new URLVariables();
         variables["lv"] = LoaderSavingManager.Version + this._reloadQuestCount;
         variables["rnd"] = TextLoader.TextLoaderKey + this._reloadQuestCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         loader.analyzer = new QuestListAnalyzer(TaskManager.instance.reloadNewQuest);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatRegisterLoader() : BaseLoader
      {
         var RegisterState:* = getDefinitionByName("register.RegisterState");
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["Sex"] = RegisterState.SelectedSex;
         args["NickName"] = RegisterState.Nickname;
         args["Name"] = PlayerManager.Instance.Account.Account;
         args["Pass"] = PlayerManager.Instance.Account.Password;
         args["site"] = "";
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VisualizeRegister.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.FailedToRegister");
         loader.analyzer = new RegisterAnalyzer(null);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatSelectListLoader() : BaseLoader
      {
         var args:URLVariables = new URLVariables();
         args["rnd"] = Math.random();
         args["username"] = PlayerManager.Instance.Account.Account;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoginSelectList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingRoleListFailure");
         loader.analyzer = new LoginSelectListAnalyzer(SelectListManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatServerListLoader() : BaseLoader
      {
         var args:URLVariables = new URLVariables();
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ServerList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingServerListFailure");
         loader.analyzer = new ServerListAnalyzer(ServerManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCardSetsSortRule() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsSortRule");
         loader.analyzer = new SetsSortRuleAnalyzer(CardControl.Instance.initSetsSortRule);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCardSetsProperties() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardBuffList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsProperties");
         loader.analyzer = new SetsPropertiesAnalyzer(CardControl.Instance.initSetsProperties);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatShopTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingStoreItemsFail");
         loader.analyzer = new ShopItemAnalyzer(ShopManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatGoodsAdditionLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ItemStrengthenPlusData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsAdditionFail");
         loader.analyzer = new GoodsAdditionAnalyer(GoodsAdditioner.Instance.addGoodsAddition);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatShopSortLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopGoodsShowList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.TheClassificationOfGoodsLoadingShopFailure");
         loader.analyzer = new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatAllQuestionInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadAllQuestions.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTestFailure");
         loader.analyzer = new QuestionInfoAnalyze(QuestionInfoMannager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatUserBoxInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadUserBox.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsInformationFailure");
         loader.analyzer = new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatZhanLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getZhanPath(),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = "LoadingDirtyCharacterSheetsFailure";
         loader.analyzer = new FilterWordAnalyzer(FilterWordManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createConsortiaLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["page"] = 1;
         args["size"] = 10000;
         args["order"] = -1;
         args["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         args["userID"] = -1;
         args["state"] = -1;
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGuildMembersListFailure");
         loader.analyzer = new ConsortionMemberAnalyer(ConsortionModelControl.Instance.memberListComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCalendarRequest() : BaseLoader
      {
         return CalendarManager.getInstance().request();
      }
      
      public function getMyConsortiaData() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = 1;
         args["size"] = 1;
         args["name"] = "";
         args["level"] = -1;
         args["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         args["order"] = -1;
         args["openApply"] = -1;
         var loadConsortias:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loadConsortias.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaInfoError");
         loadConsortias.analyzer = new ConsortionListAnalyzer(ConsortionModelControl.Instance.selfConsortionComplete);
         loadConsortias.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loadConsortias;
      }
      
      public function creatFeedbackInfoLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["userid"] = PlayerManager.Instance.Self.ID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionRead.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingComplainInformationFailure");
         loader.analyzer = new LoadFeedbackReplyAnalyzer(FeedbackManager.instance.setupFeedbackData);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatExpericenceAnalyzeLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LevelList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         loader.analyzer = new ExpericenceAnalyze(Experience.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatPetExpericenceAnalyzeLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetLevelInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPetExpirenceTemplateFormFailure");
         loader.analyzer = new PetExpericenceAnalyze(PetExperience.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatTexpExpLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ExerciseInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTexpExpFailure");
         loader.analyzer = new TexpExpAnalyze(TexpManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatWeaponBallAnalyzeLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("BombConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWeaponBallListFormFailure");
         loader.analyzer = new WeaponBallInfoAnalyze(WeaponBallManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatDailyLeagueAwardLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyLeagueAward.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueAwardFailure");
         loader.analyzer = new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatDailyLeagueLevelLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyLeagueLevel.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         loader.analyzer = new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createWishInfoLader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GoldEquipTemplateLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         loader.analyzer = new WishInfoAnalyzer(WishBeadManager.instance.getwishInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatServerConfigLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ServerConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         loader.analyzer = new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatPetInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetTemplateInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetInfoFail");
         loader.analyzer = new PetInfoAnalyzer(PetInfoManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatPetSkillLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("Petskillinfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetSkillFail");
         loader.analyzer = new PetSkillAnalyzer(PetSkillManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatFarmPoultryInfo() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TreeTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.getPoultryFail");
         loader.analyzer = new FarmTreePoultryListAnalyzer(FarmModelController.instance.getTreePoultryListData);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatFoodComposeLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FoodComposeList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadFoodComposeListFail");
         loader.analyzer = new FoodComposeListAnalyzer(FarmComposeHouseController.instance().setupFoodComposeList);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatPetConfigLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetConfigInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetConfigFail");
         loader.analyzer = new PetconfigAnalyzer(null);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatPetSkillTemplateInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetSkillTemplateInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetAllSkillFail");
         loader.analyzer = new PetAllSkillAnalyzer(PetAllSkillManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatActiveInfoLoader() : BaseLoader
      {
         return CalendarManager.getInstance().requestActiveEvent();
      }
      
      public function creatActionExchangeInfoLoader() : BaseLoader
      {
         return CalendarManager.getInstance().requestActionExchange();
      }
      
      public function creatShopDisCountRealTimesLoader() : BaseLoader
      {
         var args:URLVariables = new URLVariables();
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         loader.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount);
         return loader;
      }
      
      public function creatVoteSubmit() : BaseLoader
      {
         var args:URLVariables = new URLVariables();
         args["userId"] = PlayerManager.Instance.Self.ID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VoteSubmit.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.vip.loadVip.error");
         loader.analyzer = new VoteSubmitAnalyzer(this.loadVoteXml);
         return loader;
      }
      
      public function createStoreEquipConfigLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadStrengthExp.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadStoreEquipExperienceAllFail");
         loader.analyzer = new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatCardGrooveLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardGrooveUpdateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadCardGrooveFail");
         loader.analyzer = new CardGrooveEventAnalyzer(GrooveInfoManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatCardTemplateLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadCardTemplateInfoFail");
         loader.analyzer = new CardTemplateAnalyzer(CardTemplateInfoManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatItemStrengthenGoodsInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ItemStrengthenGoodsInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadItemStrengthenGoodsInfoListFail");
         loader.analyzer = new ItemStrengthenGoodsInfoAnalyzer(ItemStrengthenGoodsInfoManager.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createBeadTemplateLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("RuneTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadBeadInfoFail");
         loader.analyzer = new BeadAnalyzer(BeadTemplateManager.Instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatHallIcon() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ButtonConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         loader.analyzer = new HallIconDataAnalyz(MainButtonManager.instance.gethallIconInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createTotemTemplateLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TotemInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadTotemInfoFail");
         loader.analyzer = new TotemDataAnalyz(TotemManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHonorUpTemplateLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TotemHonorTemplate.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHonorUpInfoFail");
         loader.analyzer = new HonorUpDataAnalyz(HonorUpManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createConsortiaBossTemplateLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaBossConfigLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadConsortiaBossInfoFail");
         loader.analyzer = new ConsortiaBossDataAnalyzer(ConsortionModelControl.Instance.bossConfigDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatActiveLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActivePointTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEveryDayActFail");
         loader.analyzer = new ActivityAnalyzer(DayActivityManager.Instance.everyDayActive);
         return loader;
      }
      
      public function creatActivePointLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActiveProgressInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.actInfoFail");
         loader.analyzer = new ActivePointAnalzer(DayActivityManager.Instance.everyDayActivePoint);
         return loader;
      }
      
      public function creatRewardLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActiveRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.everyDayRewardFail");
         loader.analyzer = new ActivityRewardAnalyzer(DayActivityManager.Instance.activityRewardComp);
         return loader;
      }
      
      public function loaderSearchGoodsTemp() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SearchGoodsTemp.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.starUpdataInfoFail");
         loader.analyzer = new UpdateStarAnalyer(BuriedManager.Instance.SearchGoodsTempHander);
         return loader;
      }
      
      public function loaderSearchGoodsPayMoney() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SearchGoodsPayMoney.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.starUpDataCountInfoFail");
         loader.analyzer = new SearchGoodsPayAnalyer(BuriedManager.Instance.searchGoodsPayHander);
         return loader;
      }
      
      public function creatWondActiveLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var variables:URLVariables = new URLVariables();
         variables["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadChargeActiveTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wondActInfoFail");
         loader.analyzer = new WonderfulActAnalyer(WonderfulActivityManager.Instance.wonderfulActiveType);
         return loader;
      }
      
      public function firstRechargeLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var variables:URLVariables = new URLVariables();
         variables["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ChargeSpendRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.firstRechargeInfoFail");
         loader.analyzer = new RechargeAnalyer(FirstRechargeManger.Instance.completeHander);
         return loader;
      }
      
      public function accumulativeLoginLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var variables:URLVariables = new URLVariables();
         variables["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoginAwardItemTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.accumulativeLoginInfoFail");
         loader.analyzer = new AccumulativeLoginAnalyer(AccumulativeManager.instance.loadTempleteDataComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createDragonBoatActiveLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CommunalActive.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.dragonBoatActiveInfoFail");
         loader.analyzer = new DragonBoatActiveDataAnalyzer(DragonBoatManager.instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCaddyAwardsLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LotteryShowTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new CaddyAwardDataAnalyzer(CaddyAwardModel.getInstance().setUp);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createActivitySystemItemsLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivitySystemItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.activitySystemItemsInfoFail");
         loader.analyzer = new ActivitySystemItemsDataAnalyzer(this.activitySystemItemsDataHandler);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      private function activitySystemItemsDataHandler(analyzer:DataAnalyzer) : void
      {
         var tempDataAnalyzer:ActivitySystemItemsDataAnalyzer = null;
         if(analyzer is ActivitySystemItemsDataAnalyzer)
         {
            tempDataAnalyzer = analyzer as ActivitySystemItemsDataAnalyzer;
            PyramidManager.instance.templateDataSetup(tempDataAnalyzer.pyramidSystemDataList);
            GuildMemberWeekManager.instance.templateDataSetup(tempDataAnalyzer.guildMemberWeekDataList);
            GrowthPackageManager.instance.templateDataSetup(tempDataAnalyzer.growthPackageDataList);
            KingDivisionManager.Instance.templateDataSetup(tempDataAnalyzer.kingDivisionDataList);
            ChickActivationManager.instance.templateDataSetup(tempDataAnalyzer.chickActivationDataList);
            WitchBlessingManager.Instance.templateDataSetup(tempDataAnalyzer.witchBlessingDataList);
            NewYearRiceManager.instance.templateDataSetup(tempDataAnalyzer.newYearRiceDataList);
            HorseRaceManager.Instance.templateDataSetup(tempDataAnalyzer.horseRaceDataList);
         }
      }
      
      public function createNewFusionDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FusionInfoLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.newFusionDataInfoFail");
         loader.analyzer = new FusionNewDataAnalyzer(FusionNewManager.instance.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createEnergyDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MissionEnergyPrice.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.energyInfoFail");
         loader.analyzer = new EnergyDataAnalyzer(PlayerManager.Instance.setupEnergyData);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCallPropDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("RankTemplateAll.xml?type=" + Math.random()),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.callPropInfoFail");
         loader.analyzer = new CallPropDataAnalyer(PlayerManager.Instance.setupCallPropData);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createGroupPurchaseAwardInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TeamBuyActiveAwardInfo.ashx"),BaseLoader.REQUEST_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.groupPurchaseDataInfoFail");
         loader.analyzer = new GroupPurchaseAwardAnalyzer(GroupPurchaseManager.instance.awardAnalyComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      private function loadVoteXml(anlyzer:VoteSubmitAnalyzer) : void
      {
         var loadVoteInfo:BaseLoader = null;
         if(anlyzer.result == VoteSubmitAnalyzer.FILENAME)
         {
            loadVoteInfo = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(VoteSubmitAnalyzer.FILENAME),BaseLoader.TEXT_LOADER);
            loadVoteInfo.loadErrorMessage = LanguageMgr.GetTranslation("ddt.view.vote.loadXMLError");
            loadVoteInfo.analyzer = new VoteInfoAnalyzer(VoteManager.Instance.loadCompleted);
            LoadResourceManager.Instance.startLoad(loadVoteInfo);
         }
      }
      
      public function loadWonderfulActivityXml() : BaseLoader
      {
         ++this._actReloadeCount;
         var variables:URLVariables = new URLVariables();
         variables["rnd"] = TextLoader.TextLoaderKey + this._actReloadeCount.toString();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GmActivityInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wonderfulActiveInfoFail");
         loader.analyzer = new WonderfulGMActAnalyer(WonderfulActivityManager.Instance.wonderfulGMActiveInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function requestMsnConfirm(type:int, code:String = "") : BaseLoader
      {
         var args:URLVariables = new URLVariables();
         args["uid"] = PlayerManager.Instance.Self.ID;
         args["type"] = type;
         args["code"] = code;
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ResetPassword4399.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.analyzer = new MsnConfirmAnalyzer(BaglockedManager.Instance.msnConfirmAnalyeComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createAvatarCollectionUnitDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothPropertyTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionUnitDataFail");
         loader.analyzer = new AvatarCollectionUnitDataAnalyzer(AvatarCollectionManager.instance.unitListDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createAvatarCollectionItemDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothGroupTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionItemDataFail");
         loader.analyzer = new AvatarCollectionItemDataAnalyzer(AvatarCollectionManager.instance.itemListDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createPetsRisingStarDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetStarExp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         loader.analyzer = new PetsRisingStarDataAnalyzer(PetsAdvancedManager.Instance.risingStarDataComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createPetsEvolutionDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetFightProperty.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         loader.analyzer = new PetsEvolutionDataAnalyzer(PetsAdvancedManager.Instance.evolutionDataComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function loadMagicStoneTemplate() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MagicStoneTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.magicStoneTempFail");
         loader.analyzer = new MagicStoneTempAnalyer(MagicStoneManager.instance.loadMgStoneTempComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function getFightReportLoader(reportID:String) : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["ID"] = reportID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GetFightReport.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingFightReportFailure");
         loader.analyzer = new FightReportAnalyze(BombKingManager.instance.getFightInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHorseTemplateDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MountTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.horseTemplateDataFail");
         loader.analyzer = new HorseTemplateDataAnalyzer(HorseManager.instance.horseTemplateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHorseSkillGetDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MountSkillGetTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.horseSkillGetDataFail");
         loader.analyzer = new HorseSkillGetDataAnalyzer(HorseManager.instance.horseSkillGetDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHorseSkillDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MountSkillTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.horseSkillDataFail");
         loader.analyzer = new HorseSkillDataAnalyzer(HorseManager.instance.horseSkillDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHorseSkillElementDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MountSkillElementTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.horseSkillElementDataFail");
         loader.analyzer = new HorseSkillElementDataAnalyzer(HorseManager.instance.horseSkillElementDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createCollectionRebortDataLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["uname"] = PlayerManager.Instance.Account.Account;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SceneCollecRandomNpc.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.collectionRobertDataFail");
         loader.analyzer = new CollectionTaskAnalyzer(CollectionTaskManager.Instance.robertDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHorsePicCherishDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MountDrawTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.horsePicCherishDataFail");
         loader.analyzer = new HorsePicCherishAnalyzer(HorseManager.instance.horsePicCherishDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createNewTitleDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("NewTitleInfo.xml"),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.newTitleDataFail");
         loader.analyzer = new NewTitleDataAnalyz(NewTitleManager.instance.newTitleDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createRescueRewardLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("HelpGameReward.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.rescueRewardFail");
         loader.analyzer = new RescueRewardAnalyzer(RescueManager.instance.setupRewardList);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createLoadPetMoePropertyLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetMoeProperty.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.rescueRewardFail");
         loader.analyzer = new PetMoePropertyAnalyzer(PetsAdvancedManager.Instance.moePropertyComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            if(event.loader.analyzer.message != null)
            {
               msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
            }
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function creatSuitTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         loader.analyzer = new SuitTempleteAnalyzer(ItemManager.Instance.setupSuitTemplates);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatEquipSuitTempleteLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitPartEquipInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         loader.analyzer = new EquipSuitTempleteAnalyzer(ItemManager.Instance.setupEquipSuitTemplates);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatGodSyahLoader(type:int = 7) : BaseLoader
      {
         if(type != 7)
         {
            return null;
         }
         var variables:URLVariables = new URLVariables();
         variables["rnd"] = TextLoader.TextLoaderKey + Math.random().toString();
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SubActiveList.ashx"),BaseLoader.REQUEST_LOADER,variables);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGodSyahFailure");
         loader.analyzer = new SyahAnalyzer(SyahManager.Instance.godSyahLoaderCompleted);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function creatSuperWinnerLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("DiceGameAwardItem.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.superWinner.loadAwardsError");
         loader.analyzer = new SuperWinnerAnalyze(SuperWinnerManager.instance.awardsLoadCompleted);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function loadLanternRiddlesXml() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LightRiddleQuest.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.lanternRiddlesInfoFail");
         loader.analyzer = new LanternDataAnalyzer(LanternRiddlesManager.instance.questionInfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createLightRoadLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("GoodsCollect.xml?type=LightRoadPath"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LightRoadInfoFail");
         loader.analyzer = new LightRoadDataAnalyzer(LightRoadManager.instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createGodsRoadsLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityQuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.godsRoads.cuowu");
         loader.analyzer = new GodsRoadsDataAnalyzer(GodsRoadsManager.instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createSevenDayTargetLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityQuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.sevenDayTargetInfoFail");
         loader.analyzer = new SevenDayTargetDataAnalyzer(SevenDayTargetManager.Instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createHalloweenLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityHalloweenItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.halloweenPrizeInfoFail");
         loader.analyzer = new HalloweenDataAnalyzer(HalloweenManager.instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function getPetsFormDataLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetFormData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsFormDataFail");
         loader.analyzer = new PetsFormDataAnalyzer(PetsAdvancedManager.Instance.formDataComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createEnchantMagicInfoLoader() : BaseLoader
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MagicItemTemp.xml"),BaseLoader.TEXT_LOADER);
         loader.analyzer = new EnchantInfoAnalyzer(EnchantManager.instance.setupInfoList);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      public function createAddPublicTipLoader() : BaseLoader
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivitySystemItemsRate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.addPublicTipFail");
         loader.analyzer = new AddPublicTipDataAnalyzer(AddPublicTipManager.Instance.templateDataSetup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
   }
}

