package ddt
{
   import AvatarCollection.AvatarCollectionManager;
   import DDPlay.DDPlayManaer;
   import Dice.DiceManager;
   import accumulativeLogin.AccumulativeManager;
   import bagAndInfo.BagAndInfoManager;
   import battleGroud.BattleGroudManager;
   import beadSystem.beadSystemManager;
   import boguAdventure.BoguAdventureManager;
   import calendar.CalendarManager;
   import campbattle.CampBattleManager;
   import catchInsect.CatchInsectMananger;
   import catchbeast.CatchBeastManager;
   import chickActivation.ChickActivationManager;
   import christmas.manager.ChristmasManager;
   import cityWide.CityWideManager;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.StringUtils;
   import consortionBattle.ConsortiaBattleManager;
   import cryptBoss.CryptBossManager;
   import dayActivity.DayActivityManager;
   import ddt.data.AccountInfo;
   import ddt.data.ColorEnum;
   import ddt.data.ConfigParaser;
   import ddt.data.PathInfo;
   import ddt.events.StartupEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.EdictumManager;
   import ddt.manager.EnthrallManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GradeExaltClewManager;
   import ddt.manager.HotSpringManager;
   import ddt.manager.LandersAwardManager;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerStateManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.QueueManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SevenDoubleEscortManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StageFocusManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateCreater;
   import ddt.states.StateType;
   import ddt.utils.CrytoUtils;
   import ddt.view.chat.ChatBugleView;
   import ddtBuried.BuriedManager;
   import ddtDeed.DeedManager;
   import debug.StatsManager;
   import dragonBoat.DragonBoatManager;
   import drgnBoat.DrgnBoatManager;
   import eliteGame.EliteGameController;
   import entertainmentMode.EntertainmentModeManager;
   import escort.EscortManager;
   import exitPrompt.ExitPromptManager;
   import farm.FarmModelController;
   import fightFootballTime.manager.FightFootballTimeManager;
   import firstRecharge.FirstRechargeManger;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flashP2P.FlashP2PManager;
   import foodActivity.FoodActivityManager;
   import game.GameManager;
   import game.view.WindPowerManager;
   import gemstone.GemstoneManager;
   import godsRoads.manager.GodsRoadsManager;
   import groupPurchase.GroupPurchaseManager;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import gypsyShop.ctrl.GypsyShopManager;
   import hallIcon.HallIconManager;
   import halloween.HalloweenManager;
   import horse.HorseManager;
   import horseRace.controller.HorseRaceManager;
   import im.IMController;
   import itemActivityGift.ItemActivityGiftManager;
   import kingBless.KingBlessManager;
   import kingDivision.KingDivisionManager;
   import lanternriddles.LanternRiddlesManager;
   import latentEnergy.LatentEnergyManager;
   import league.manager.LeagueManager;
   import lightRoad.manager.LightRoadManager;
   import littleGame.LittleGameManager;
   import littleGame.character.LittleGameCharacter;
   import luckStar.manager.LuckStarManager;
   import magicHouse.MagicHouseManager;
   import magicStone.MagicStoneManager;
   import magpieBridge.MagpieBridgeManager;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import mysteriousRoullete.MysteriousManager;
   import newChickenBox.controller.NewChickenBoxManager;
   import newYearRice.NewYearRiceManager;
   import org.aswing.KeyboardManager;
   import overSeasCommunity.OverSeasCommunController;
   import petsBag.controller.PetBagController;
   import playerDress.PlayerDressManager;
   import powerUp.PowerUpMovieManager;
   import pyramid.PyramidManager;
   import quest.TrusteeshipManager;
   import rescue.RescueManager;
   import room.RoomManager;
   import room.transnational.TransnationalFightManager;
   import roulette.LeftGunRouletteManager;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import sevenDouble.SevenDoubleManager;
   import superWinner.manager.SuperWinnerManager;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.WeakGuildManager;
   import treasureHunting.TreasureManager;
   import treasureLost.controller.TreasureLostManager;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActivityManager;
   import worldboss.WorldBossManager;
   import zodiac.ZodiacManager;
   
   public class DDT
   {
      
      public static var _fbapp:Boolean;
      
      public static var SERVER_ID:int = -1;
      
      public static const THE_HIGHEST_LV:int = 60;
      
      private var _alerLayer:Sprite;
      
      private var _allowMulti:Boolean;
      
      private var _gameLayer:Sprite;
      
      private var _musicList:Array;
      
      private var _pass:String;
      
      private var _user:String;
      
      private var _rid:String;
      
      private var numCh:Number;
      
      private var _loaded:Boolean = false;
      
      public function DDT()
      {
         super();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         var ch:DisplayObject = null;
         this.numCh = 0;
         for(var i:int = 0; i < StageReferance.stage.numChildren; i++)
         {
            ch = StageReferance.stage.getChildAt(i);
            ch.visible = true;
            ++this.numCh;
            if(ch is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(ch));
            }
         }
      }
      
      private function show(dis:DisplayObjectContainer) : void
      {
         var ch:DisplayObject = null;
         for(var i:int = 0; i < dis.numChildren; i++)
         {
            ch = dis.getChildAt(i);
            ch.visible = true;
            ++this.numCh;
            if(ch is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(ch));
            }
         }
      }
      
      public function lunch(config:XML, username:String, password:String, mode:int, rid:String = "", $baiduEnterCode:String = "", $_fbapp:String = "") : void
      {
         DesktopManager.Instance.checkIsDesktop();
         PlayerManager.Instance.Self.baiduEnterCode = $baiduEnterCode;
         _fbapp = StringUtils.converBoolean($_fbapp);
         if(!this._loaded)
         {
            this._user = username;
            this._pass = password;
            this._rid = rid;
            PlayerManager.Instance.Self.rid = this._rid;
            ConfigParaser.paras(config,StageReferance.stage.loaderInfo,this._user);
            this.setup();
            StartupResourceLoader.Instance.addEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
            StartupResourceLoader.Instance.start(mode);
         }
         else if(StartupResourceLoader.Instance._queueIsComplete)
         {
            this.__onCoreSetupLoadComplete(null);
         }
         else
         {
            StartupResourceLoader.Instance.addEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
         }
      }
      
      public function startLoad(config:XML, username:String, password:String, mode:int, rid:String = "") : void
      {
         this._loaded = true;
         this._user = username;
         this._pass = password;
         this._rid = rid;
         PlayerManager.Instance.Self.rid = this._rid;
         ConfigParaser.paras(config,StageReferance.stage.loaderInfo,this._user);
         this.setup();
         StartupResourceLoader.Instance.start(mode);
      }
      
      private function __onCoreSetupLoadComplete(event:StartupEvent) : void
      {
         StartupResourceLoader.Instance.removeEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
         ChatManager.Instance.setup();
         ChatBugleView.instance.setup();
         StageFocusManager.getInstance().setup(StageReferance.stage);
         StateManager.setState(StateType.LOGIN);
         FightLibManager.Instance.setup();
         PlayerStateManager.Instance.setup();
         WeakGuildManager.Instance.setup();
         GemstoneManager.Instance.initEvent();
         GemstoneManager.Instance.loaderData();
         FirstRechargeManger.Instance.setup();
         AccumulativeManager.instance.setup();
         KingBlessManager.instance.setup();
         TrusteeshipManager.instance.setup();
         DayActivityManager.Instance.setup();
         BattleGroudManager.Instance.setup();
         WonderfulActivityManager.Instance.setup();
         BuriedManager.Instance.setup();
         PlayerDressManager.instance.setup();
         FoodActivityManager.Instance.setUp();
         if(PathManager.flashP2PEbable)
         {
            FlashP2PManager.Instance.connect();
         }
         TransnationalFightManager.Instance.Setup();
         FightFootballTimeManager.instance.Setup();
         DeedManager.instance.setup();
         GypsyShopManager.getInstance().init();
      }
      
      private function setup() : void
      {
         var m1:String = null;
         var m2:String = null;
         var acc:AccountInfo = null;
         if(StringUtils.isEmpty(this._user))
         {
            LeavePageManager.leaveToLoginPath();
         }
         else
         {
            this.setupComponent();
            m1 = "zRSdzFcnZjOCxDMkWUbuRgiOZIQlk7frZMhElQ0a7VqZI9VgU3+lwo0ghZLU3Gg63kOY2UyJ5vFpQdwJUQydsF337ZAUJz4rwGRt/MNL70wm71nGfmdPv4ING+DyJ3ZxFawwE1zSMjMOqQtY4IV8his/HlgXuUfIHVDK87nMNLc=";
            m2 = "AQAB";
            acc = new AccountInfo();
            acc.Account = this._user;
            acc.Password = this._pass;
            acc.Key = CrytoUtils.generateRsaKey(m1,m2);
            WonderfulActivityManager.Instance.addWAIcon = this.initWonderfulIcon;
            WonderfulActivityManager.Instance.deleWAIcon = this.deleWAIcon;
            PlayerManager.Instance.setup(acc);
            ShowTipManager.Instance.setup();
            QueueManager.setup(StageReferance.stage);
            TimeManager.Instance.setup();
            SoundManager.instance.setup(PathInfo.MUSIC_LIST,PathManager.SITE_MAIN);
            IMController.Instance.setup();
            SharedManager.Instance.setup();
            LittleGameManager.Instance.initialize();
            CalendarManager.getInstance().initialize();
            RoomManager.Instance.setup();
            BagAndInfoManager.Instance.setup();
            EliteGameController.Instance.setup();
            GameManager.Instance.setup();
            KeyboardManager.getInstance().init(StageReferance.stage);
            ChurchManager.instance.setup();
            GradeExaltClewManager.getInstance().setup();
            PowerUpMovieManager.Instance.setup();
            HotSpringManager.instance.setup();
            RouletteManager.instance.setup();
            AcademyManager.Instance.setup();
            ColorEnum.initColor();
            StateManager.setup(LayerManager.Instance.getLayerByType(LayerManager.GAME_BASE_LAYER),new StateCreater());
            EnthrallManager.getInstance().setup();
            ExitPromptManager.Instance.init();
            CityWideManager.Instance.init();
            WindPowerManager.Instance.init();
            LevelRewardManager.Instance.setup();
            QQtipsManager.instance.setup();
            LittleGameCharacter.setup();
            EdictumManager.Instance.setup();
            LeftGunRouletteManager.instance.init();
            LeagueManager.instance.initLeagueStartNoticeEvent();
            FarmModelController.instance.setup();
            PetBagController.instance().setup();
            beadSystemManager.Instance.setup();
            WorldBossManager.Instance.setup();
            if(Boolean(PathManager.OVERSEAS_COMMUNITY_TYPE))
            {
               OverSeasCommunController.instance().setup();
            }
            NewChickenBoxManager.instance.setup();
            DiceManager.Instance.setup();
            LatentEnergyManager.instance.setup();
            ConsortiaBattleManager.instance.setup();
            DragonBoatManager.instance.setup();
            CampBattleManager.instance.setup();
            GroupPurchaseManager.instance.setup();
            SevenDoubleManager.instance.setup();
            EscortManager.instance.setup();
            SevenDoubleEscortManager.instance.setup();
            DrgnBoatManager.instance.setup();
            TreasureManager.instance.setup();
            MysteriousManager.instance.setup();
            ChristmasManager.instance.setup();
            CatchBeastManager.instance.setup();
            AvatarCollectionManager.instance.setup();
            LanternRiddlesManager.instance.setup();
            LandersAwardManager.instance.setup();
            MagicStoneManager.instance.setup();
            HorseManager.instance.setup();
            DiceManager.Instance.setup();
            PyramidManager.instance.setup();
            SuperWinnerManager.instance.setup();
            GodsRoadsManager.instance.setup();
            GuildMemberWeekManager.instance.setup();
            LuckStarManager.Instance.setup();
            GrowthPackageManager.instance.setup();
            LightRoadManager.instance.setup();
            NewSevenDayAndNewPlayerManager.Instance.setup();
            HallIconManager.instance.setup();
            KingDivisionManager.Instance.setup();
            EntertainmentModeManager.instance.setup();
            ChickActivationManager.instance.setup();
            StatsManager.instance.setup();
            DDPlayManaer.Instance.setup();
            BoguAdventureManager.instance.setup();
            TreasurePuzzleManager.Instance.setup();
            WitchBlessingManager.Instance.setup();
            HalloweenManager.instance.setup();
            ItemActivityGiftManager.instance.setup();
            MagpieBridgeManager.instance.setup();
            CryptBossManager.instance.setUp();
            WorshipTheMoonManager.getInstance().init();
            CatchInsectMananger.instance.setup();
            RescueManager.instance.setup();
            CloudBuyLotteryManager.Instance.setup();
            MagicHouseManager.instance.setup();
            TreasureLostManager.Instance.setup();
            NewYearRiceManager.instance.setup();
            ZodiacManager.instance.setup();
            HorseRaceManager.Instance.setup();
         }
      }
      
      private function initWonderfulIcon() : void
      {
         WonderfulActivityManager.Instance.hasActivity = true;
      }
      
      private function deleWAIcon() : void
      {
         WonderfulActivityManager.Instance.hasActivity = false;
      }
      
      private function setupComponent() : void
      {
         ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER);
         ComponentSetting.PLAY_SOUND_FUNC = SoundManager.instance.play;
         ComponentSetting.SEND_USELOG_ID = SocketManager.Instance.out.sendUseLog;
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.mutiline = true;
         alertInfo.buttonGape = 15;
         alertInfo.autoDispose = true;
         alertInfo.sound = "008";
         AlertManager.Instance.setup(LayerManager.STAGE_DYANMIC_LAYER,alertInfo);
         this.soundPlay();
      }
      
      private function soundPlay() : void
      {
         SoundManager.instance.play("008");
      }
   }
}

