package hall
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import Dice.DiceManager;
   import GodSyah.SyahManager;
   import LimitAward.LimitAwardButton;
   import accumulativeLogin.AccumulativeManager;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import beadSystem.controls.BeadLeadManager;
   import bombKing.BombKingManager;
   import calendar.CalendarManager;
   import campbattle.CampBattleManager;
   import catchInsect.CatchInsectMananger;
   import chickActivation.ChickActivationManager;
   import church.view.weddingRoomList.DivorcePromptFrame;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.MD5;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import cryptBoss.CryptBossManager;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayActiveData;
   import dayActivity.view.DdtImportantFrame;
   import ddt.bagStore.BagStore;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.loader.LoaderCreate;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.CSMBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.DuowanInterfaceManage;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.manager.VoteManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.BackgoundView;
   import ddt.view.DailyButtunBar;
   import ddt.view.MainToolBar;
   import ddt.view.NovicePlatinumCard;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.ChatView;
   import ddt.view.tips.HallBuildTip;
   import ddtActivityIcon.ActivitStateEvent;
   import ddtActivityIcon.DdtActivityIconManager;
   import dragonBoat.DragonBoatManager;
   import escort.EscortManager;
   import farm.FarmModelController;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import flowerGiving.FlowerGivingManager;
   import foodActivity.FoodActivityManager;
   import game.GameManager;
   import game.view.stage.StageCurtain;
   import gradeAwardsBoxBtn.GradeAwardsBoxButtonManager;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyNPCModel;
   import gypsyShop.npcBehavior.GypsyNPCBhvr;
   import hall.event.NewHallEvent;
   import hall.hallInfo.HallPlayerInfoView;
   import hall.player.HallPlayerOperateView;
   import hall.player.HallPlayerView;
   import hall.tasktrack.HallTaskGuideManager;
   import hall.tasktrack.HallTaskTrackMainView;
   import hall.tasktrack.HallTaskTrackManager;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.view.HallRightIconView;
   import im.IMController;
   import kingBless.KingBlessManager;
   import kingDivision.KingDivisionManager;
   import labyrinth.LabyrinthManager;
   import league.manager.LeagueManager;
   import littleGame.LittleGameManager;
   import littleGame.events.LittleGameEvent;
   import magicHouse.MagicHouseManager;
   import magpieBridge.MagpieBridgeManager;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import newOpenGuide.NewOpenGuideDialogView;
   import newOpenGuide.NewOpenGuideManager;
   import newVersionGuide.NewVersionGuideManager;
   import newYearRice.NewYearRiceManager;
   import oldPlayerRegress.RegressManager;
   import oldPlayerRegress.data.RegressData;
   import oldplayergetticket.GetTicketManager;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import quest.TaskMainFrame;
   import rescue.RescueManager;
   import ringStation.RingStationManager;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.transnational.TransnationalFightManager;
   import roomList.LookupEnumerate;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   import roulette.LeftGunRouletteManager;
   import roulette.RouletteFrameEvent;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDouble.SevenDoubleManager;
   import shop.manager.ShopSaleManager;
   import shop.view.ShopRechargeEquipAlert;
   import shop.view.ShopRechargeEquipServer;
   import socialContact.friendBirthday.FriendBirthdayManager;
   import store.StrengthDataManager;
   import superWinner.manager.SuperWinnerManager;
   import times.TimesManager;
   import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.SystemOpenPromptManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import trainer.view.WelcomeView;
   import treasureLost.controller.TreasureLostManager;
   import vip.VipController;
   import wantstrong.WantStrongManager;
   import wantstrong.event.WantStrongEvent;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.event.WonderfulActivityEvent;
   import worldBossHelper.WorldBossHelperManager;
   import worldboss.WorldBossManager;
   
   public class HallStateView extends BaseStateView
   {
      
      public static const MOUSE_ON_GLOW_FILTER:Array = [new GlowFilter(16776960,1,8,8,2,2)];
      
      public static const VIP_LEFT_DAY_TO_COMFIRM:int = 3;
      
      public static const VIP_LEFT_DAY_FIRST_PROMPT:int = 7;
      
      public static const BUILDNUM:int = 6;
      
      public static var btnID:int = -1;
      
      public static var SoundIILoaded:Boolean = false;
      
      public static var SoundILoaded:Boolean = false;
      
      private static var _firstLoadTimes:Boolean = true;
      
      private static var _isFirstCheck:uint = 1;
      
      private var _black:Shape;
      
      private var _playerInfoView:HallPlayerInfoView;
      
      private var _playerOperateView:HallPlayerOperateView;
      
      private var _bgSprite:Sprite;
      
      private var _OpenAuction:MovieClip;
      
      private var _chatView:ChatView;
      
      private var _btnList:Array;
      
      private var _btnTipList:Array;
      
      private var _eventActives:Array;
      
      private var _isIMController:Boolean;
      
      private var isShow:Boolean = false;
      
      private var _renewal:BaseAlerFrame;
      
      private var _isAddFrameComplete:Boolean = false;
      
      private var _txtArray:Array;
      
      private var _selfPosArray:Array;
      
      private var _btnArray:Array;
      
      private var _shine:Vector.<MovieClipWrapper>;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _signBtnContainer:Sprite;
      
      private var _angelblessIcon:MovieClip;
      
      private var isInLuckStone:Boolean;
      
      private var _timer:Timer;
      
      private var _expValue:int;
      
      private var _isShowWonderfulActTip1:Boolean;
      
      private var _isShowWonderfulActTip2:Boolean;
      
      private var _hallRightIconView:HallRightIconView;
      
      private var _getTicketBtn:BaseButton;
      
      private var _ringStationClickDate:Number = 0;
      
      private var _playerView:HallPlayerView;
      
      private var _taskTrackMainView:HallTaskTrackMainView;
      
      private var _isFromNewVersionGuide:Boolean;
      
      private var _isShowActTipDic:Dictionary;
      
      private var _needShowOpenTipActArr:Array;
      
      private var _needShowAwardTipActArr:Array;
      
      private var startDate:Date;
      
      private var endDate:Date;
      
      private var isActiv:Boolean;
      
      private var _boxButton:SmallBoxButton;
      
      private var _count:uint;
      
      private var _timesCount:uint;
      
      private var _checkisDesk:Timer;
      
      private var _isDesk:Boolean = true;
      
      private var _trainerWelcomeView:WelcomeView;
      
      private var _dialog:NewOpenGuideDialogView;
      
      private var _battleFrame:Frame;
      
      private var _battlePanel:ScrollPanel;
      
      private var _battleImg:Bitmap;
      
      private var _battleBtn:TextButton;
      
      private var _isFirst:Boolean;
      
      private var _lastCreatTime:int;
      
      public function HallStateView()
      {
         this._txtArray = ["txt_dungeon_mc","txt_roomList_mc","txt_Labyrinth_mc","txt_farm_mc","txt_ringstation_mc","txt_church_mc"];
         this._selfPosArray = [new Point(1145,347),new Point(1561,399),new Point(2505,318),new Point(2696,313),new Point(3074,330),new Point(2650,520),new Point(2284,376),new Point(755,363),new Point(1003,391),new Point(1307,415),new Point(1807,462),new Point(2017,340),new Point(107,538),new Point(231,532),new Point(333,540)];
         this._btnArray = ["dungeon","roomList","labyrinth","farm","ringStation","cryptBoss","church","gypsy","guide","constrion","store","auction","redPlatform","bluePlatform","goldPlatform"];
         this._needShowOpenTipActArr = [ActivityType.PAY_RETURN,ActivityType.CONSUME_RETURN,ActivityType.MOUNT_MASTER_SKILL,ActivityType.MOUNT_MASTER_LEVEL];
         this._needShowAwardTipActArr = [ActivityType.PAY_RETURN,ActivityType.CONSUME_RETURN,ActivityType.MOUNT_MASTER_SKILL,ActivityType.MOUNT_MASTER_LEVEL,ActivityType.CARNIVAL_BEAD,ActivityType.CARNIVAL_CARD,ActivityType.CARNIVAL_FUSION,ActivityType.CARNIVAL_GRADE,ActivityType.CARNIVAL_MOUNT_MASTER,ActivityType.CARNIVAL_PET,ActivityType.CARNIVAL_PRACTICE,ActivityType.CARNIVAL_ROOKIE,ActivityType.CARNIVAL_STRENGTH,ActivityType.CARNIVAL_TOTEM,ActivityType.CARNIVAL_ZHANHUN,ActivityType.WHOLEPEOPLE_PET,ActivityType.WHOLEPEOPLE_VIP,ActivityType.DAILY_GIFT];
         super();
         try
         {
            WeakGuildManager.Instance.timeStatistics(0,getDefinitionByName("DDT_Loading").time);
            if(PathManager.isStatistics)
            {
               WeakGuildManager.Instance.statistics(3,getDefinitionByName("DDT_Loading").time);
            }
         }
         catch(e:Error)
         {
         }
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this._checkActivityPer);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.LABYRINTH_CHAT,this.__labyrinthChat);
      }
      
      protected function __labyrinthChat(event:Event) : void
      {
         LayerManager.Instance.addToLayer(ChatManager.Instance.view,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      override public function getType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         var i:int;
         this._btnList = [];
         this._btnTipList = [];
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.enter(prev,data);
         if(data is Function)
         {
            data();
         }
         KeyboardShortcutsManager.Instance.setup();
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.MAIN);
         BackgoundView.Instance.show();
         WantStrongManager.Instance.isTimeUpdated = false;
         SocketManager.Instance.out.sendUpdateSysDate();
         SocketManager.Instance.out.battleGroundUpdata(1);
         SocketManager.Instance.out.battleGroundUpdata(2);
         SocketManager.Instance.out.battleGroundPlayerUpdata();
         SocketManager.Instance.out.sendWonderfulActivity(0,-1);
         SocketManager.Instance.out.updateConsumeRank();
         PlayerManager.Instance.discountInit();
         SocketManager.Instance.out.getVipAndMerryInfo(1);
         SocketManager.Instance.out.getVipAndMerryInfo(2);
         if(!this._isShowActTipDic)
         {
            this._isShowActTipDic = new Dictionary();
         }
         for(i = 0; i < this._needShowOpenTipActArr.length; i++)
         {
            if(!this._isShowActTipDic[this._needShowOpenTipActArr[i]])
            {
               this._isShowActTipDic[this._needShowOpenTipActArr[i]] = false;
            }
         }
         WonderfulActivityManager.Instance.addEventListener(WonderfulActivityEvent.CHECK_ACTIVITY_STATE,this.__checkShowWonderfulActivityTip);
         if(StartupResourceLoader.firstEnterHall)
         {
            StartupResourceLoader.Instance.addThirdGameUI();
            StartupResourceLoader.Instance.startLoadRelatedInfo();
         }
         try
         {
            this.initHall();
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onHallLoadComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_COREI);
         }
      }
      
      private function __onHallLoadComplete(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDT_COREI)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onHallLoadComplete);
            this.initHall();
         }
      }
      
      private function initHall() : void
      {
         var loaderQueue:QueueLoader = null;
         var novicePlatinumCard:NovicePlatinumCard = null;
         SoundManager.instance.playMusic("062",true,false);
         if(!this._bgSprite)
         {
            this._bgSprite = new Sprite();
            addChild(this._bgSprite);
         }
         if(!this._playerInfoView)
         {
            this._playerInfoView = new HallPlayerInfoView();
            addChild(this._playerInfoView);
         }
         if(!this._playerOperateView)
         {
            this._playerOperateView = new HallPlayerOperateView();
            PositionUtils.setPos(this._playerOperateView,"hall.playerView.playerOperatePos");
            addChild(this._playerOperateView);
         }
         if(!this._playerView)
         {
            this._playerView = new HallPlayerView(this._bgSprite,PlayerManager.Instance.Self.Grade > 10 ? 0 : 1);
            this._playerView.addEventListener(NewHallEvent.BTNCLICK,this.__onBtnClick);
         }
         var behavior:GypsyNPCBhvr = new GypsyNPCBhvr(null);
         behavior.container = this._playerView.hallView;
         behavior.hall = this;
         GypsyShopManager.getInstance().npcBehavior = behavior;
         GypsyShopManager.getInstance().init();
         DailyButtunBar.Insance.show();
         this.createBuildBtn();
         this.createNpcBtn();
         this.initBuild();
         SocketManager.Instance.out.requestWonderfulActInit(2);
         SocketManager.Instance.out.updateConsumeRank();
         MainToolBar.Instance.show();
         MainToolBar.Instance.btnOpen();
         MainToolBar.Instance.enabled = true;
         MainToolBar.Instance.updateReturnBtn(MainToolBar.ENTER_HALL);
         MainToolBar.Instance.ExitBtnVisible = true;
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         this._chatView = ChatManager.Instance.view;
         this._chatView.visible = true;
         ChatManager.Instance.lock = ChatManager.HALL_CHAT_LOCK;
         ChatManager.Instance.chatDisabled = false;
         addChild(this._chatView);
         StartupResourceLoader.Instance.finishLoadingProgress();
         StartupResourceLoader.Instance.addNotStartupNeededResource();
         if(!SoundILoaded)
         {
            loaderQueue = new QueueLoader();
            loaderQueue.addLoader(LoaderCreate.Instance.createAudioILoader());
            loaderQueue.addLoader(LoaderCreate.Instance.createAudioIILoader());
            loaderQueue.addEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
            loaderQueue.start();
         }
         this.loadUserGuide();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
         this._isFromNewVersionGuide = NewVersionGuideManager.instance.isGuiding;
         if(NewVersionGuideManager.instance.isGuiding)
         {
            NewVersionGuideManager.instance.completeGuideFunc = this.showFrame;
         }
         else
         {
            this.showFrame();
         }
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_FIGHT);
         this.checkShowBossBox();
         this.checkShowStoreFromShop();
         StrengthDataManager.instance.setup();
         GuildMemberWeekManager.instance.setup();
         if(!this._isIMController && PathManager.CommunityExist())
         {
            this._isIMController = true;
            IMController.Instance.createConsortiaLoader();
         }
         if(PlayerManager.Instance.Self.baiduEnterCode == "true")
         {
            novicePlatinumCard = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard");
            novicePlatinumCard.setup();
         }
         TaskManager.instance.addEventListener(TaskMainFrame.TASK_FRAME_HIDE,this.__taskFrameHide);
         this.loadWeakGuild();
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_HALL);
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_HALL);
         this._isFromNewVersionGuide = NewVersionGuideManager.instance.isGuiding;
         if(NewVersionGuideManager.instance.isGuiding)
         {
            NewVersionGuideManager.instance.completeGuideFunc = this.showFrame;
         }
         else
         {
            this.showFrame();
         }
         FriendBirthdayManager.Instance.findFriendBirthday();
         PetBagController.instance().addEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         this.petFarmGuilde();
         DragonBoatManager.instance.createEntryBtn(this._playerView);
         GradeAwardsBoxButtonManager.getInstance().init();
         GradeAwardsBoxButtonManager.getInstance().setHall(this);
         MagicHouseManager.instance.createEntryBtn(this._playerView);
         CSMBoxManager.instance.showBox(this);
         this.updateWantStrong();
         HallIconManager.instance.checkDefaultIconShow();
         FoodActivityManager.Instance.checkOpen();
         this._hallRightIconView = new HallRightIconView();
         PositionUtils.setPos(this._hallRightIconView,"hallIcon.hallRightIconViewPos");
         LayerManager.Instance.addToLayer(this._hallRightIconView,LayerManager.GAME_UI_LAYER);
         HallIconManager.instance.checkIconCall();
         HallIconManager.instance.checkCacheRightIconShow();
         HallIconManager.instance.checkCacheRightIconTask();
         this.defaultRightWonderfulPlayIconShow();
         this.defaultRightActivityIconShow();
         if(KingDivisionManager.Instance.openFrame)
         {
            KingDivisionManager.Instance.onClickIcon();
         }
         var bool:Boolean = TreasureLostManager.Instance.isOpenFrame;
         if(TreasureLostManager.Instance.isOpenFrame)
         {
            SocketManager.Instance.out.enterTreasureLost();
         }
         this._timer.reset();
         this._timer.start();
         if(SyahManager.Instance.isOpen)
         {
            if(SyahManager.Instance.login == false)
            {
               SyahManager.Instance.login = true;
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.GodSyah.isCome"));
            }
         }
         this.initDdtActiviyIconState();
         if(DdtActivityIconManager.Instance.isOneOpen && Boolean(DdtActivityIconManager.Instance.currObj))
         {
            this.changeIconState(DdtActivityIconManager.Instance.currObj,true);
         }
         DdtActivityIconManager.Instance.setup();
         BeadLeadManager.Instance.beadLeadOne();
         SocketManager.Instance.out.sendDragonBoatRefreshBoatStatus();
         NewOpenGuideManager.instance.checkShow(this._playerView);
         if(GameManager.exploreOver)
         {
            BagAndInfoManager.Instance.showBagAndInfo();
         }
         this._taskTrackMainView = new HallTaskTrackMainView(this._btnList[7]);
         LayerManager.Instance.addToLayer(this._taskTrackMainView,LayerManager.GAME_UI_LAYER);
         HallTaskTrackManager.instance.btnList = this._btnList;
         BombKingManager.instance.setup(this._playerView);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         SuperWinnerManager.instance.addEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
         SevenDayTargetManager.Instance.isHallAct = true;
         SevenDayTargetManager.Instance.onClickSevenDayTargetIcon();
      }
      
      private function showFrame() : void
      {
         var self:SelfInfo = null;
         SystemOpenPromptManager.instance.showFrame();
         this.checkShowVote();
         this.checkShowVipAlert_New();
         KingBlessManager.instance.checkShowDueAlert();
         if(!this._isAddFrameComplete)
         {
            this.addFrame();
         }
         TimesManager.Instance.checkOpenUpdateFrame();
         if(NewVersionGuideManager.instance.isShowOldPlayerFrame)
         {
            self = PlayerManager.Instance.Self;
            if(self.isOld && !RegressData.isOver && !self.isSameDay && RegressData.isFirstLogin && RegressData.isAutoPop)
            {
               RegressData.isAutoPop = false;
               RegressManager.instance.autoPopUp = true;
               RegressManager.instance.show();
            }
         }
         if(this._isFromNewVersionGuide)
         {
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_HALL);
            CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_HALL);
         }
         DragonBoatManager.instance.enterMainOpenFrame();
         WonderfulActivityManager.Instance.checkShowSendGiftFrame();
         if(SharedManager.Instance.divorceBoolean)
         {
            DivorcePromptFrame.Instance.show();
         }
         if(!this._isAddFrameComplete)
         {
            TaskManager.instance.checkHighLight();
         }
         HallTaskTrackManager.instance.checkOpenCommitView();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP);
      }
      
      private function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]))
         {
            this.initBuild();
            this.addButtonList();
         }
      }
      
      private function checkDdtImportantFrame() : void
      {
         var frame:DdtImportantFrame = null;
         if(SharedManager.Instance.isShowDdtImportantView)
         {
            frame = ComponentFactory.Instance.creatComponentByStylename("DdtImportantFrame");
            LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            SharedManager.Instance.isShowDdtImportantView = false;
            SharedManager.Instance.save();
         }
      }
      
      private function createBuildBtn() : void
      {
         var buildBtn:BaseButton = null;
         var buildTip:HallBuildTip = null;
         var buildObj:Object = null;
         for(var i:int = 0; i < BUILDNUM; i++)
         {
            buildBtn = ComponentFactory.Instance.creatComponentByStylename("HallMain." + this._btnArray[i] + "Btn");
            buildTip = new HallBuildTip();
            buildObj = new Object();
            buildObj["title"] = LanguageMgr.GetTranslation("ddt.hall.build." + this._btnArray[i] + "title");
            buildObj["content"] = LanguageMgr.GetTranslation("ddt.HallStateView." + this._btnArray[i]);
            buildTip.tipData = buildObj;
            PositionUtils.setPos(buildTip,"hall.build." + this._btnArray[i] + "TipPos");
            this._btnTipList.push(buildTip);
            this._btnList.push(buildBtn);
            this._playerView.touchArea.addChild(buildTip);
            this._playerView.touchArea.addChild(buildBtn);
         }
      }
      
      private function createNpcBtn() : void
      {
         var npcBtn:BaseButton = null;
         for(var i:int = BUILDNUM; i < this._btnArray.length; i++)
         {
            npcBtn = ComponentFactory.Instance.creatComponentByStylename("HallMain." + this._btnArray[i] + "Btn");
            this._btnList.push(npcBtn);
            if(i != 8)
            {
               this._playerView.touchArea.addChild(npcBtn);
            }
         }
      }
      
      private function initBuild() : void
      {
         var lv:int = PlayerManager.Instance.Self.Grade;
         this.setBuildState(0,lv >= 10 ? true : false);
         this.setBuildState(1,lv >= 3 ? true : false);
         this.setBuildState(2,lv >= 30 ? true : false);
         this.setBuildState(3,lv >= 25 ? true : false);
         this.setBuildState(4,lv >= 19 ? true : false);
         this.setBuildState(5,lv >= 31 ? true : false);
         this.setBuildState(6,true);
         this.setBuildState(7,GypsyNPCModel.getInstance().isStart());
         this.setBuildState(9,true);
         this.setBuildState(10,true);
         this.setBuildState(11,true);
         this.setBuildState(12,true);
         this.setBuildState(13,true);
         this.setBuildState(14,true);
      }
      
      private function setBuildState(idx:int, enable:Boolean) : void
      {
         var txt:MovieClip = this._playerView.hallView[this._txtArray[idx]];
         var baseBtn:Component = this._btnList[idx];
         baseBtn.buttonMode = baseBtn.mouseChildren = baseBtn.mouseEnabled = enable;
         if(Boolean(txt))
         {
            txt.buttonMode = txt.mouseChildren = txt.mouseEnabled = false;
            txt.visible = enable;
         }
         if(enable)
         {
            baseBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
            baseBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__btnOver);
            baseBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
         }
         if(idx == 7)
         {
            GypsyShopManager.getInstance().npcBehavior.hotArea = baseBtn;
         }
      }
      
      private function __btnOver(evt:MouseEvent) : void
      {
         var btnId:int = int(this._btnList.indexOf(evt.currentTarget as BaseButton));
         if(btnId < 6)
         {
            this._playerView.hallView[this._btnArray[btnId]].gotoAndStop(2);
            this._btnTipList[btnId].visible = true;
         }
         else
         {
            this.setCharacterFilter(btnId,true);
         }
      }
      
      protected function setCharacterFilter(btnId:int, value:Boolean) : void
      {
         if(Boolean(this._playerView.hallView[this._btnArray[btnId]]))
         {
            this._playerView.hallView[this._btnArray[btnId]].filters = value ? MOUSE_ON_GLOW_FILTER : null;
         }
      }
      
      private function __btnOut(evt:MouseEvent) : void
      {
         var btnId:int = int(this._btnList.indexOf(evt.currentTarget as BaseButton));
         if(btnId < 6)
         {
            this._playerView.hallView[this._btnArray[btnId]].gotoAndStop(1);
            this._btnTipList[btnId].visible = false;
         }
         else
         {
            this.setCharacterFilter(btnId,false);
         }
      }
      
      private function defaultRightWonderfulPlayIconShow() : void
      {
         LeagueManager.instance.addLeaIcon = this.addLeagueIcon;
         LeagueManager.instance.deleteLeaIcon = this.deleLeagueBtn;
         if(LeagueManager.instance.isOpen)
         {
            this.addLeagueIcon();
         }
         if(ConsortiaBattleManager.instance.isOpen)
         {
            ConsortiaBattleManager.instance.addEntryBtn(true);
         }
         if(CampBattleManager.instance.model.isOpen)
         {
            CampBattleManager.instance.addCampBtn();
         }
         BattleGroudManager.Instance.initBattleIcon = this.addBattleIcon;
         BattleGroudManager.Instance.dispBattleIcon = this.delBattleIcon;
         if(BattleGroudManager.Instance.isShow)
         {
            this.addBattleIcon();
         }
         LittleGameManager.Instance.addEventListener(LittleGameEvent.ActivedChanged,this.__littlegameActived);
         this.__littlegameActived();
         if(TransnationalFightManager.Instance.hasActived())
         {
            this.ShowTransnationalIcon(true);
         }
         TransnationalFightManager.Instance.ShowIcon = this.ShowTransnationalIcon;
         if(TransnationalFightManager.Instance.isfromTransnational)
         {
            TransnationalFightManager.Instance.isfromTransnational = false;
         }
         if(SevenDoubleManager.instance.isStart && SevenDoubleManager.instance.isLoadIconComplete)
         {
            this.sevenDoubleIconResLoadComplete(null);
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.END,this.sevendoubleEndHandler);
         }
         else
         {
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.ICON_RES_LOAD_COMPLETE,this.sevenDoubleIconResLoadComplete);
         }
         if(EscortManager.instance.isStart && EscortManager.instance.isLoadIconComplete)
         {
            this.escortIconResLoadComplete(null);
            EscortManager.instance.addEventListener(EscortManager.END,this.escortEndHandler);
         }
         else
         {
            EscortManager.instance.addEventListener(EscortManager.ICON_RES_LOAD_COMPLETE,this.escortIconResLoadComplete);
         }
         this.checkShowWorldBossEntrance();
         this.checkShowWorldBossHelper();
         if(FightFootballTimeManager.instance.isopen)
         {
            this.showFightFootballTimeIcon(true);
         }
         FightFootballTimeManager.instance.ShowIcon = this.showFightFootballTimeIcon;
      }
      
      public function setNPCBtnEnable($baseBtn:Component, enable:Boolean) : void
      {
         if(enable)
         {
            $baseBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__btnOver);
            $baseBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
            $baseBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         else
         {
            $baseBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.__btnOver);
            $baseBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
            $baseBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
            this.onOutEffect(this._btnList.indexOf($baseBtn));
         }
      }
      
      private function onOutEffect(btnId:int) : void
      {
         if(btnId < 6)
         {
            this._playerView.hallView[this._btnArray[btnId]].gotoAndStop(1);
            this._btnTipList[btnId].visible = false;
         }
         else
         {
            this.setCharacterFilter(btnId,false);
         }
      }
      
      private function __ringstationOnFightFlag(event:RingStationEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         var date:Date = pkg.readDate();
         if(StateManager.currentStateType == StateType.MAIN)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.RINGSTATION,true);
         }
      }
      
      public function ShowTransnationalIcon(value:Boolean) : void
      {
         if(value)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.TRANSNATIONAL,true);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.TRANSNATIONAL,false);
         }
      }
      
      private function showFightFootballTimeIcon(isshow:Boolean) : void
      {
         if(isshow)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.FIGHTFOOTBALLTIME,true);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.FIGHTFOOTBALLTIME,false);
         }
      }
      
      private function addLeagueIcon(isUse:Boolean = false, timeStr:String = null) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEAGUE,true,timeStr);
      }
      
      private function deleLeagueBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEAGUE,false);
      }
      
      private function addBattleIcon(isUse:Boolean = false, timeStr:String = "") : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.BATTLE,true,timeStr);
      }
      
      private function delBattleIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.BATTLE,false);
      }
      
      private function sevendoubleEndHandler(event:Event) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDOUBLE,false);
      }
      
      private function sevenDoubleIconResLoadComplete(event:Event) : void
      {
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ICON_RES_LOAD_COMPLETE,this.sevenDoubleIconResLoadComplete);
         if(SevenDoubleManager.instance.isStart && SevenDoubleManager.instance.isLoadIconComplete)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDOUBLE,true);
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.END,this.sevendoubleEndHandler);
         }
         else
         {
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.ICON_RES_LOAD_COMPLETE,this.sevenDoubleIconResLoadComplete);
         }
      }
      
      private function escortEndHandler(event:Event) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ESCORT,false);
      }
      
      private function escortIconResLoadComplete(event:Event) : void
      {
         EscortManager.instance.removeEventListener(EscortManager.ICON_RES_LOAD_COMPLETE,this.escortIconResLoadComplete);
         if(EscortManager.instance.isStart && EscortManager.instance.isLoadIconComplete)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.ESCORT,true);
            EscortManager.instance.addEventListener(EscortManager.END,this.escortEndHandler);
         }
         else
         {
            EscortManager.instance.addEventListener(EscortManager.ICON_RES_LOAD_COMPLETE,this.escortIconResLoadComplete);
         }
      }
      
      private function __littlegameActived(evt:Event = null, isUse:Boolean = false, timeStr:String = null) : void
      {
         if(LittleGameManager.Instance.hasActive())
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.LITTLEGAMENOTE,true,timeStr);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.LITTLEGAMENOTE,false,timeStr);
         }
      }
      
      private function defaultRightWonderfulPlayIconRemove() : void
      {
         SocketManager.Instance.removeEventListener(RingStationEvent.RINGSTATION_FIGHTFLAG,this.__ringstationOnFightFlag);
         LittleGameManager.Instance.removeEventListener(LittleGameEvent.ActivedChanged,this.__littlegameActived);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.END,this.sevendoubleEndHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ICON_RES_LOAD_COMPLETE,this.sevenDoubleIconResLoadComplete);
         EscortManager.instance.removeEventListener(EscortManager.END,this.escortEndHandler);
         EscortManager.instance.removeEventListener(EscortManager.ICON_RES_LOAD_COMPLETE,this.escortIconResLoadComplete);
         BattleGroudManager.Instance.initBattleIcon = null;
         BattleGroudManager.Instance.dispBattleIcon = null;
      }
      
      private function defaultRightActivityIconShow() : void
      {
         GrowthPackageManager.instance.showEnterIcon();
         DiceManager.Instance.setup(this.showDiceBtn);
         if(DiceManager.Instance.isopen)
         {
            this.showDiceBtn(true);
         }
         this.addAccumulativeLoginAct();
         LeftGunRouletteManager.instance.addEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         if(LeftGunRouletteManager.instance.IsOpen)
         {
            LeftGunRouletteManager.instance.showGunButton();
         }
         WonderfulActivityManager.Instance.setLimitActivities(CalendarManager.getInstance().eventActives);
         WonderfulActivityManager.Instance.addWAIcon = this.initLimitActivityIcon;
         WonderfulActivityManager.Instance.deleWAIcon = this.deleteLimitActivityIcon;
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            if(WonderfulActivityManager.Instance.actList.length > 0)
            {
               this.initLimitActivityIcon();
            }
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKLYSTONE_ACTIVITY,this.__getLuckStoneEnable);
         SocketManager.Instance.out.requestForLuckStone();
         if(AvatarCollectionManager.instance.isDataComplete)
         {
            if(!AvatarCollectionManager.instance.isCheckedAvatarTime)
            {
               this.__checkAvatarCollectionTime(null);
            }
         }
         else
         {
            AvatarCollectionManager.instance.addEventListener(AvatarCollectionManager.DATA_COMPLETE,this.__checkAvatarCollectionTime);
         }
         SocketManager.Instance.out.sendRegressTicketInfo();
         FlowerGivingManager.instance.checkOpen();
         if(KingDivisionManager.Instance.isOpen)
         {
            KingDivisionManager.Instance.updateConsotionMessage();
            KingDivisionManager.Instance.kingDivisionIcon(KingDivisionManager.Instance.isOpen);
         }
         if(WorshipTheMoonManager.getInstance()._isOpen)
         {
            WorshipTheMoonManager.getInstance().worshipTheMoonIcon(WorshipTheMoonManager.getInstance()._isOpen);
         }
         if(FoodActivityManager.Instance._isStart)
         {
            FoodActivityManager.Instance.initBtn(FoodActivityManager.Instance._isStart);
         }
         if(RescueManager.instance._isBegin)
         {
            RescueManager.instance.createRescueBtn(RescueManager.instance._isBegin);
         }
         if(CatchInsectMananger.instance.model.isOpen)
         {
            CatchInsectMananger.instance.showEnterIcon(CatchInsectMananger.instance.model.isOpen);
         }
         if(MagpieBridgeManager.instance._isOpen)
         {
            MagpieBridgeManager.instance.initIcon(MagpieBridgeManager.instance._isOpen);
         }
         if(CloudBuyLotteryManager.Instance.model.isOpen)
         {
            CloudBuyLotteryManager.Instance.initIcon(CloudBuyLotteryManager.Instance.model.isOpen);
         }
         if(NewYearRiceManager.instance.model.isOpen)
         {
            NewYearRiceManager.instance.showEnterIcon(NewYearRiceManager.instance.model.isOpen);
         }
         ShopSaleManager.Instance.checkOpenShopSale();
         ChickActivationManager.instance.checkShowIcon();
         GypsyShopManager.getInstance().refreshNPC();
      }
      
      private function __checkAvatarCollectionTime(event:Event) : void
      {
         var endTimestamp:Number = NaN;
         var nowTimestamp:Number = NaN;
         var dataIndex:AvatarCollectionUnitVo = null;
         var data:AvatarCollectionUnitVo = null;
         var chatData:ChatData = null;
         if(Boolean(event))
         {
            AvatarCollectionManager.instance.removeEventListener(AvatarCollectionManager.DATA_COMPLETE,this.__checkAvatarCollectionTime);
         }
         if(!AvatarCollectionManager.instance.maleUnitList)
         {
            return;
         }
         var dataArr:Array = AvatarCollectionManager.instance.maleUnitList.concat(AvatarCollectionManager.instance.femaleUnitList);
         AvatarCollectionManager.instance.skipIdArray = [];
         for(var k:int = 0; k < dataArr.length; k++)
         {
            dataIndex = dataArr[k];
            if(!(!dataIndex.endTime || dataIndex.totalActivityItemCount < dataIndex.totalItemList.length / 2))
            {
               endTimestamp = Number(dataIndex.endTime.getTime());
               nowTimestamp = Number(TimeManager.Instance.Now().getTime());
               if(endTimestamp - nowTimestamp <= 0)
               {
                  AvatarCollectionManager.instance.skipIdArray.push(dataIndex);
                  AvatarCollectionManager.instance.skipFlag = true;
               }
            }
         }
         for(var i:int = 0; i < dataArr.length; i++)
         {
            data = dataArr[i];
            if(!(!data.endTime || data.totalActivityItemCount < data.totalItemList.length / 2))
            {
               endTimestamp = Number(data.endTime.getTime());
               nowTimestamp = Number(TimeManager.Instance.Now().getTime());
               if(endTimestamp - nowTimestamp <= 0)
               {
                  chatData = new ChatData();
                  chatData.channel = ChatInputView.COMPLEX_NOTICE;
                  chatData.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
                  chatData.type = ChatFormats.AVATAR_COLLECTION_TIP;
                  chatData.msg = LanguageMgr.GetTranslation("avatarCollection.noTime.tipTxt");
                  AvatarCollectionManager.instance.isCheckedAvatarTime = true;
                  ChatManager.Instance.chat(chatData);
                  AvatarCollectionManager.instance.skipId = data.id;
                  break;
               }
            }
         }
      }
      
      private function showDiceBtn(value:Boolean = false) : void
      {
         if(value)
         {
            if(PlayerManager.Instance.Self.Grade >= 10)
            {
               HallIconManager.instance.updateSwitchHandler(HallIconType.DICE,true);
            }
            else
            {
               HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.DICE,true,10);
            }
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.DICE,false);
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.DICE,false);
         }
      }
      
      private function addAccumulativeLoginAct() : void
      {
         if(PlayerManager.Instance.Self.accumulativeLoginDays >= 7 && PlayerManager.Instance.Self.accumulativeAwardDays >= 7)
         {
            AccumulativeManager.instance.removeAct();
         }
         else
         {
            AccumulativeManager.instance.addAct();
         }
      }
      
      private function __getLuckStoneEnable(e:CrazyTankSocketEvent) : void
      {
         var open:Boolean = false;
         var p:PackageIn = e.pkg;
         this.startDate = p.readDate();
         this.endDate = p.readDate();
         this.isActiv = p.readBoolean();
         var nowDate:Date = TimeManager.Instance.Now();
         if(nowDate.getTime() >= this.startDate.getTime() && nowDate.getTime() <= this.endDate.getTime())
         {
            open = true;
         }
         WonderfulActivityManager.Instance.rouleEndTime = this.endDate;
         if(this.isActiv && open)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTONE,true);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTONE,false);
         }
      }
      
      protected function __onGetTicketClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         GetTicketManager.instance.show();
      }
      
      private function deleteGetTicketBtn() : void
      {
         if(Boolean(this._getTicketBtn))
         {
            this._getTicketBtn.dispose();
            this._getTicketBtn = null;
         }
      }
      
      private function addRegressBtn() : void
      {
      }
      
      private function _checkActivityPer(event:TimerEvent) : void
      {
         this._checkLimit();
         if(!this.isInLuckStone && this.checkLuckStone())
         {
            this.addButtonList();
         }
         else if(this.isInLuckStone && !this.checkLuckStone())
         {
            this.addButtonList();
         }
         ShopSaleManager.Instance.checkOpenShopSale();
      }
      
      private function __leftGunShow(event:RouletteFrameEvent) : void
      {
         if(LeftGunRouletteManager.instance.IsOpen)
         {
            LeftGunRouletteManager.instance.showGunButton();
         }
         else
         {
            LeftGunRouletteManager.instance.hideGunButton();
         }
      }
      
      private function _checkLimit() : void
      {
         if(!this._limitAwardButton)
         {
            return;
         }
         if(!CalendarManager.getInstance().checkEventInfo())
         {
            this.addButtonList();
            return;
         }
      }
      
      private function initLimitActivityIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIMITACTIVITY,true);
      }
      
      private function deleteLimitActivityIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIMITACTIVITY,false);
      }
      
      private function defaultRightActivityIconRemove() : void
      {
         LeftGunRouletteManager.instance.removeEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKLYSTONE_ACTIVITY,this.__getLuckStoneEnable);
         this.deleteGetTicketBtn();
         WonderfulActivityManager.Instance.addWAIcon = null;
         WonderfulActivityManager.Instance.deleWAIcon = null;
      }
      
      private function updateWantStrong() : void
      {
         var acitiveDataList:Vector.<DayActiveData> = null;
         var bossDataDic:Dictionary = null;
         var findBackDic:Dictionary = null;
         var speedActArr:Array = null;
         var nowDate:Date = null;
         var hours:int = 0;
         var minutes:int = 0;
         var activeTime:String = null;
         var findBackExist:Boolean = false;
         var i:int = 0;
         if(PlayerManager.Instance.Self.Grade >= 8 && PlayerManager.Instance.Self.Grade <= 80)
         {
            acitiveDataList = DayActivityManager.Instance.acitiveDataList;
            bossDataDic = DayActivityManager.Instance.bossDataDic;
            findBackDic = WantStrongManager.Instance.findBackDic;
            speedActArr = DayActivityManager.Instance.speedActArr;
            nowDate = TimeManager.Instance.serverDate;
            findBackExist = false;
            for(i = 0; i < acitiveDataList.length; i++)
            {
               hours = int(acitiveDataList[i].ActiveTime.substr(acitiveDataList[i].ActiveTime.length - 5,2));
               minutes = int(acitiveDataList[i].ActiveTime.substr(acitiveDataList[i].ActiveTime.length - 2,2)) + 10;
               switch(acitiveDataList[i].ID)
               {
                  case 1:
                     if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,6) && !this.isFindBack(findBackDic,6))
                     {
                        WantStrongManager.Instance.findBackExist = true;
                        findBackExist = true;
                        WantStrongManager.Instance.setFindBackData(0);
                     }
                     break;
                  case 19:
                     activeTime = acitiveDataList[i].ActiveTime.split("（")[0];
                     hours = int(activeTime.substr(activeTime.length - 5,2));
                     minutes = int(activeTime.substr(activeTime.length - 2,2)) + 10;
                     if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,19) && !this.isFindBack(findBackDic,19))
                     {
                        WantStrongManager.Instance.findBackExist = true;
                        findBackExist = true;
                        WantStrongManager.Instance.setFindBackData(2);
                     }
                     break;
                  case 2:
                     activeTime = acitiveDataList[i].ActiveTime.split("（")[0];
                     hours = int(activeTime.substr(activeTime.length - 5,2));
                     minutes = int(activeTime.substr(activeTime.length - 2,2)) + 10;
                     if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,19) && !this.isFindBack(findBackDic,19))
                     {
                        WantStrongManager.Instance.findBackExist = true;
                        findBackExist = true;
                        WantStrongManager.Instance.setFindBackData(0);
                     }
                     break;
                  case 4:
                     activeTime = acitiveDataList[i].ActiveTime.split("|")[0];
                     hours = int(activeTime.substr(activeTime.length - 5,2));
                     minutes = int(activeTime.substr(activeTime.length - 2,2)) + 10;
                     if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,4) && !this.isFindBack(findBackDic,4))
                     {
                        WantStrongManager.Instance.findBackExist = true;
                        findBackExist = true;
                        WantStrongManager.Instance.setFindBackData(4);
                     }
                     break;
                  case 5:
                     if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,5) && !this.isFindBack(findBackDic,5))
                     {
                        WantStrongManager.Instance.findBackExist = true;
                        findBackExist = true;
                        WantStrongManager.Instance.setFindBackData(3);
                     }
                     break;
               }
            }
            if(!findBackExist)
            {
               WantStrongManager.Instance.findBackExist = false;
            }
         }
      }
      
      protected function __alreadyUpdateTimeHandler(event:Event) : void
      {
         WantStrongManager.Instance.removeEventListener(WantStrongEvent.ALREADYUPDATETIME,this.__alreadyUpdateTimeHandler);
         this.checkWantStrongFindBack();
      }
      
      private function checkWantStrongFindBack() : void
      {
         var acitiveDataList:Vector.<DayActiveData> = null;
         var hours:int = 0;
         var minutes:int = 0;
         var i:int = 0;
         var activeTime:String = null;
         acitiveDataList = DayActivityManager.Instance.acitiveDataList;
         var bossDataDic:Dictionary = DayActivityManager.Instance.bossDataDic;
         var findBackDic:Dictionary = WantStrongManager.Instance.findBackDic;
         var speedActArr:Array = DayActivityManager.Instance.speedActArr;
         var nowDate:Date = TimeManager.Instance.serverDate;
         var findBackExist:Boolean = false;
         for(i = 0; i < acitiveDataList.length; i++)
         {
            hours = int(acitiveDataList[i].ActiveTime.substr(acitiveDataList[i].ActiveTime.length - 5,2));
            minutes = int(acitiveDataList[i].ActiveTime.substr(acitiveDataList[i].ActiveTime.length - 2,2)) + 10;
            switch(acitiveDataList[i].ID)
            {
               case 1:
                  if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,18) && !this.isFindBack(findBackDic,18))
                  {
                     WantStrongManager.Instance.findBackExist = true;
                     findBackExist = true;
                     WantStrongManager.Instance.setFindBackData(1);
                  }
                  break;
               case 2:
                  if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,6) && !this.isFindBack(findBackDic,6))
                  {
                     WantStrongManager.Instance.findBackExist = true;
                     findBackExist = true;
                     WantStrongManager.Instance.setFindBackData(0);
                  }
                  break;
               case 19:
                  activeTime = acitiveDataList[i].ActiveTime.split("（")[0];
                  hours = int(activeTime.substr(activeTime.length - 5,2));
                  minutes = int(activeTime.substr(activeTime.length - 2,2)) + 10;
                  if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,19) && !this.isFindBack(findBackDic,19))
                  {
                     WantStrongManager.Instance.findBackExist = true;
                     findBackExist = true;
                     WantStrongManager.Instance.setFindBackData(2);
                  }
                  break;
               case 4:
                  if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,4) && !this.isFindBack(findBackDic,4))
                  {
                     WantStrongManager.Instance.findBackExist = true;
                     findBackExist = true;
                     WantStrongManager.Instance.setFindBackData(4);
                  }
                  break;
               case 5:
                  if(this.compareDay(nowDate.day,acitiveDataList[i].DayOfWeek) && PlayerManager.Instance.Self.Grade >= int(acitiveDataList[i].LevelLimit) && this.compareDate(nowDate,hours,minutes) && !this.isPassBoss(bossDataDic,speedActArr,5) && !this.isFindBack(findBackDic,5))
                  {
                     WantStrongManager.Instance.findBackExist = true;
                     findBackExist = true;
                     WantStrongManager.Instance.setFindBackData(3);
                  }
                  break;
            }
         }
         if(!findBackExist)
         {
            WantStrongManager.Instance.findBackExist = false;
         }
         if(WantStrongManager.Instance.findBackExist)
         {
            if(this.isOnceFindBack(findBackDic))
            {
               WantStrongManager.Instance.isPlayMovie = false;
            }
         }
      }
      
      private function __alreadyFindBackHandler(event:Event) : void
      {
         WantStrongManager.Instance.removeEventListener(WantStrongEvent.ALREADYFINDBACK,this.__alreadyFindBackHandler);
      }
      
      private function checkShowBossBox() : void
      {
         if(BossBoxManager.instance.isShowBoxButton())
         {
            if(!this._boxButton)
            {
               this._boxButton = new SmallBoxButton(SmallBoxButton.HALL_POINT);
               BossBoxManager.instance.startDelayTime();
            }
         }
      }
      
      private function isOnceFindBack(findBackDic:Dictionary) : Boolean
      {
         var itemArr:Array = null;
         for each(itemArr in findBackDic)
         {
            if(Boolean(itemArr[0]) || Boolean(itemArr[1]))
            {
               return true;
            }
         }
         return false;
      }
      
      private function isFindBack(findBackDic:Dictionary, type:int) : Boolean
      {
         if(Boolean(findBackDic[type]))
         {
            if(Boolean(findBackDic[type][0]) && Boolean(findBackDic[type][1]))
            {
               return true;
            }
         }
         return false;
      }
      
      private function ringStationShow() : void
      {
         if(new Date().time - this._ringStationClickDate > 1000)
         {
            this._ringStationClickDate = new Date().time;
            SoundManager.instance.playButtonSound();
            RingStationManager.instance.show();
         }
      }
      
      private function __checkShowWonderfulActivityTip(evnet:WonderfulActivityEvent) : void
      {
         this.checkShowActTip();
         this.createActAwardChat();
      }
      
      private function checkShowActTip() : void
      {
         var key:String = null;
         var i:int = 0;
         for(key in WonderfulActivityManager.Instance.stateDic)
         {
            for(i = 0; i < this._needShowOpenTipActArr.length; i++)
            {
               if(key == String(this._needShowOpenTipActArr[i]) && !this._isShowActTipDic[this._needShowOpenTipActArr[i]])
               {
                  ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("wonderfulActivity.startTip" + this._needShowOpenTipActArr[i]));
                  this._isShowActTipDic[this._needShowOpenTipActArr[i]] = true;
               }
            }
         }
      }
      
      private function __superWinnerIsOpen(e:Event) : void
      {
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this.superWinnerShowFrame));
         }
         else
         {
            this.superWinnerShowFrame();
         }
      }
      
      private function superWinnerShowFrame() : void
      {
         var alertFrame:BaseAlerFrame = null;
         if(SuperWinnerManager.instance.isOpen && PlayerManager.Instance.Self.Grade >= 20)
         {
            alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.superWinner.openSuperWinner"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
            alertFrame.addEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
         }
      }
      
      private function _responseEnterSuperWinner(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
         SoundManager.instance.playButtonSound();
         alert.dispose();
      }
      
      private function createHuiKuiChat(type:int) : void
      {
         if(type == 0)
         {
            return;
         }
         if(type == 1 || type == 2)
         {
            ChatManager.Instance.chat(this.createChatData(type));
         }
         else if(type == 3)
         {
            ChatManager.Instance.chat(this.createChatData(1));
            ChatManager.Instance.chat(this.createChatData(2));
         }
      }
      
      private function createChatData(type:int) : ChatData
      {
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.COMPLEX_NOTICE;
         chatData.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
         if(type == 1)
         {
            chatData.type = ChatFormats.CLICK_ENTERHUIKUI_ACTIVITY;
            chatData.actId = WonderfulActivityManager.Instance.getActIdWithViewId(ActivityType.PAY_RETURN);
            chatData.msg = LanguageMgr.GetTranslation("wonderfulActivity.startTip3");
         }
         else if(type == 2)
         {
            chatData.type = ChatFormats.CLICK_ENTERHUIKUI_ACTIVITY;
            chatData.actId = WonderfulActivityManager.Instance.getActIdWithViewId(ActivityType.CONSUME_RETURN);
            chatData.msg = LanguageMgr.GetTranslation("wonderfulActivity.startTip4");
         }
         return chatData;
      }
      
      private function checkHuiKui() : int
      {
         var temp_chongzhi:int = 0;
         var temp_xiaofei:int = 0;
         var temp:int = 0;
         var key:String = null;
         for(key in WonderfulActivityManager.Instance.stateDic)
         {
            if(key == String(ActivityType.PAY_RETURN) && Boolean(WonderfulActivityManager.Instance.stateDic[key]))
            {
               temp_chongzhi = 1;
            }
            else if(key == String(ActivityType.CONSUME_RETURN) && Boolean(WonderfulActivityManager.Instance.stateDic[key]))
            {
               temp_xiaofei = 1;
            }
         }
         if(temp_chongzhi == 1 && temp_xiaofei == 1)
         {
            temp = 3;
         }
         else if(temp_chongzhi == 1)
         {
            temp = 1;
         }
         else if(temp_xiaofei == 1)
         {
            temp = 2;
         }
         else
         {
            temp = 0;
         }
         return temp;
      }
      
      public function __CheckIsDesk(evt:TimerEvent) : void
      {
         ++this._timesCount;
         if(ExternalInterface.available)
         {
            if(Boolean(ExternalInterface.objectID))
            {
               ++this._count;
            }
            if(this._count == 5)
            {
               this._isDesk = false;
            }
         }
         this.clearCheck();
      }
      
      private function clearCheck() : void
      {
         var checkIsDeskAlert:BaseAlerFrame = null;
         if(this._timesCount == 5)
         {
            this._checkisDesk.stop();
            this._checkisDesk.removeEventListener(TimerEvent.TIMER,this.__CheckIsDesk);
            if(this._isDesk)
            {
               SocketManager.Instance.out.sendDeskTopLogin(1);
               if(PathManager.checkDeskKillSwitch)
               {
                  SocketManager.Instance.socket.close();
                  checkIsDeskAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ddt.checkIsDeskAlert.msg"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
                  checkIsDeskAlert.addEventListener(FrameEvent.RESPONSE,this.__onCheckIsDeskAlertResponse);
               }
            }
         }
      }
      
      private function __onCheckIsDeskAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onCheckIsDeskAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function createActAwardChat() : void
      {
         var key:String = null;
         var i:int = 0;
         var chatData:ChatData = null;
         for(key in WonderfulActivityManager.Instance.stateDic)
         {
            for(i = 0; i < this._needShowAwardTipActArr.length; i++)
            {
               if(key == String(this._needShowAwardTipActArr[i]) && Boolean(WonderfulActivityManager.Instance.stateDic[key]))
               {
                  chatData = new ChatData();
                  chatData.channel = ChatInputView.COMPLEX_NOTICE;
                  chatData.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
                  chatData.type = ChatFormats.CLICK_ACT_TIP + this._needShowAwardTipActArr[i];
                  chatData.actId = WonderfulActivityManager.Instance.getActIdWithViewId(this._needShowAwardTipActArr[i]);
                  chatData.msg = LanguageMgr.GetTranslation("wonderfulActivity.awardTip" + this._needShowAwardTipActArr[i]);
                  ChatManager.Instance.chat(chatData);
               }
            }
         }
      }
      
      private function initDdtActiviyIconState() : void
      {
         DdtActivityIconManager.Instance.addEventListener(DdtActivityIconManager.READY_START,this.readyHander);
         DdtActivityIconManager.Instance.addEventListener(DdtActivityIconManager.START,this.startHander);
      }
      
      private function removeDdtActiviyIconState() : void
      {
         DdtActivityIconManager.Instance.removeEventListener(DdtActivityIconManager.READY_START,this.readyHander);
         DdtActivityIconManager.Instance.removeEventListener(DdtActivityIconManager.START,this.startHander);
      }
      
      private function readyHander(e:ActivitStateEvent) : void
      {
         this.changeIconState(e.data,false);
      }
      
      private function startHander(e:ActivitStateEvent) : void
      {
         this.changeIconState(e.data,true);
      }
      
      private function changeIconState(arr:Array, isOpen:Boolean = false) : void
      {
         var id:int = int(arr[0]);
         var worldBossId:int = int(arr[1]);
         var tString:String = arr[2];
         if(isOpen)
         {
            tString = "";
         }
         switch(id)
         {
            case 1:
            case 2:
            case 19:
               if(isOpen && !WorldBossManager.Instance.isOpen)
               {
                  DdtActivityIconManager.Instance.isOneOpen = false;
                  return;
               }
               WorldBossManager.Instance.creatEnterIcon(isOpen,worldBossId,tString);
               this.checkShowWorldBossHelper();
               break;
            case 4:
               this.addLeagueIcon(isOpen,tString);
               break;
            case 5:
               this.addBattleIcon(isOpen,tString);
               break;
            case 10:
               this.__littlegameActived(null,isOpen,tString);
               break;
            case 18:
               CampBattleManager.instance.addCampBtn(isOpen,tString);
               break;
            case 20:
               ConsortiaBattleManager.instance.addEntryBtn(isOpen,tString);
         }
      }
      
      private function stopAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         while(Boolean($mc.numChildren - index))
         {
            if($mc.getChildAt(index) is MovieClip)
            {
               cMc = $mc.getChildAt(index) as MovieClip;
               cMc.stop();
               this.stopAllMc(cMc);
            }
            index++;
         }
      }
      
      private function playAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         while(Boolean($mc.numChildren - index))
         {
            if($mc.getChildAt(index) is MovieClip)
            {
               cMc = $mc.getChildAt(index) as MovieClip;
               cMc.play();
               this.playAllMc(cMc);
            }
            index++;
         }
      }
      
      private function isPassBoss(bossDataDic:Dictionary, speedActArr:Array, type:int) : Boolean
      {
         if(speedActArr.indexOf("" + type) != -1)
         {
            return false;
         }
         if(!bossDataDic[type] || bossDataDic[type] == 0)
         {
            return false;
         }
         return true;
      }
      
      private function compareDay(day:int, activeDays:String) : Boolean
      {
         var dayArr:Array = activeDays.split(",");
         if(dayArr.indexOf("" + day) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function compareDate(date1:Date, hours:int, minutes:int) : Boolean
      {
         if(date1.hours < hours)
         {
            return false;
         }
         if(date1.hours == hours)
         {
            if(date1.minutes < minutes)
            {
               return false;
            }
         }
         return true;
      }
      
      private function addButtonList() : void
      {
         if(PlayerManager.Instance.Self.Grade == 8)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.WANTSTRONG,true);
         }
         GradeAwardsBoxButtonManager.getInstance().init();
         GradeAwardsBoxButtonManager.getInstance().setHall(this);
      }
      
      private function checkLuckStone() : Boolean
      {
         var nowDate:Date = TimeManager.Instance.Now();
         if(!this.startDate)
         {
            return false;
         }
         if(nowDate.getTime() > this.startDate.getTime() && nowDate.getTime() < this.endDate.getTime() && this.isActiv)
         {
            this.isInLuckStone = true;
            return true;
         }
         this.isInLuckStone = false;
         return false;
      }
      
      private function __updatePetFarmGuilde(e:UpdatePetFarmGuildeEvent) : void
      {
         PetBagController.instance().finishTask();
         var currentGuildeInfo:QuestInfo = e.data as QuestInfo;
         if(currentGuildeInfo.QuestID == PetFarmGuildeTaskType.PET_TASK5)
         {
         }
         if(currentGuildeInfo.QuestID == PetFarmGuildeTaskType.PET_TASK4)
         {
         }
      }
      
      private function __OpenVipView(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function __OpenBlessView(event:Event) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         RouletteManager.instance.useBless();
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_PET_BAG,-50,"farmTrainer.openBagArrowPos","asset.farmTrainer.clickHere","farmTrainer.openBagTipPos",this);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_SEED_BAG,-150,"farmTrainer.openFarmArrowPos","asset.farmTrainer.seed","farmTrainer.grainopenFarmTipPosout",this);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.GRAIN_IN_FRAME,-150,"farmTrainer.openFarmArrowPos","asset.farmTrainer.grain1","farmTrainer.grainopenFarmTipPos",this);
         }
      }
      
      private function __onAudioIILoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onAudioIILoadComplete);
         SoundManager.instance.setupAudioResource(true);
         SoundIILoaded = true;
      }
      
      private function __onAudioLoadComplete(event:Event) : void
      {
         event.currentTarget.removeEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
         SoundManager.instance.setupAudioResource(false);
         SoundILoaded = true;
      }
      
      private function __OpenlittleGame(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(LittleGameManager.Instance.hasActive())
         {
            StateManager.setState(StateType.LITTLEHALL);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
         }
      }
      
      private function addFrame() : void
      {
         if(this._isAddFrameComplete)
         {
            return;
         }
         if(TimeManager.Instance.TotalDaysToNow(PlayerManager.Instance.Self.LastDate as Date) >= 30 && PlayerManager.Instance.Self.isOldPlayerHasValidEquitAtLogin && !PlayerManager.Instance.Self.isOld)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipServer().show));
         }
         else if(PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipAlert().show));
         }
         else
         {
            InventoryItemInfo.startTimer();
         }
         if(AcademyManager.Instance.isRecommend())
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(AcademyManager.Instance.recommend));
         }
         this._isAddFrameComplete = true;
      }
      
      private function loadWeakGuild() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         WeakGuildManager.Instance.checkFunction();
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_SHOW_OPEN))
            {
               this.showBuildOpen(Step.GAME_ROOM_SHOW_OPEN,"asset.trainer.openGameRoom");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
            {
               this.buildShine(Step.GAME_ROOM_CLICKED,"asset.trainer.RoomShineAsset","trainer.posBuildGameRoom");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_SHOW))
            {
               if(!DragonBoatManager.instance.isStart)
               {
                  this.showBuildOpen(Step.CONSORTIA_SHOW,"asset.trainer.openConsortia");
               }
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
            {
               if(!DragonBoatManager.instance.isStart)
               {
                  this.buildShine(Step.CONSORTIA_CLICKED,"asset.trainer.shineConsortia","trainer.posBuildConsortia");
               }
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_SHOW))
            {
               this.showBuildOpen(Step.DUNGEON_SHOW,"asset.trainer.openDungeon");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
            {
               this.buildShine(Step.DUNGEON_CLICKED,"asset.trainer.shineDungeon","trainer.posBuildDungeon");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_SHOW))
            {
               this.showBuildOpen(Step.CHURCH_SHOW,"asset.trainer.openChurch");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_CLICKED))
            {
               this.buildShine(Step.CHURCH_CLICKED,"asset.trainer.shineChurch","trainer.posBuildChurch");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_SHOW))
            {
               this.showBuildOpen(Step.TOFF_LIST_SHOW,"asset.trainer.openToffList");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_CLICKED))
            {
               this.buildShine(Step.TOFF_LIST_CLICKED,"asset.trainer.shineToffList","trainer.posBuildToffList");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_SHOW))
            {
               this.showBuildOpen(Step.AUCTION_SHOW,"asset.trainer.openAuction");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_CLICKED))
            {
               this.buildShine(Step.AUCTION_CLICKED,"asset.trainer.shineAuction","trainer.posBuildAuction");
            }
         }
      }
      
      private function __taskFrameHide(evt:Event) : void
      {
         this.loadWeakGuild();
      }
      
      private function checkShowVote() : void
      {
         if(VoteManager.Instance.showVote)
         {
            VoteManager.Instance.addEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
            if(VoteManager.Instance.loadOver)
            {
               VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
               VoteManager.Instance.openVote();
            }
         }
      }
      
      private function checkShowVipAlert() : void
      {
         var msg:String = null;
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(!selfInfo.isSameDay && !VipController.instance.isRechargePoped)
         {
            VipController.instance.isRechargePoped = true;
            if(selfInfo.IsVIP)
            {
               if(selfInfo.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && selfInfo.VIPLeftDays >= 0 || selfInfo.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  msg = "";
                  if(selfInfo.VIPLeftDays == 0)
                  {
                     if(selfInfo.VipLeftHours > 0)
                     {
                        msg = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredToday",selfInfo.VipLeftHours);
                     }
                     else if(selfInfo.VipLeftHours == 0)
                     {
                        msg = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredHour");
                     }
                     else
                     {
                        msg = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
                     }
                  }
                  else
                  {
                     msg = LanguageMgr.GetTranslation("ddt.vip.vipView.expired",selfInfo.VIPLeftDays);
                  }
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
            else if(selfInfo.VIPExp > 0)
            {
               if(selfInfo.LastDate.valueOf() < selfInfo.VIPExpireDay.valueOf() && selfInfo.VIPExpireDay.valueOf() <= selfInfo.systemDate.valueOf())
               {
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue"),LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
         }
      }
      
      private function checkShowVipAlert_New() : void
      {
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(!selfInfo.isSameDay && !VipController.instance.isRechargePoped)
         {
            VipController.instance.isRechargePoped = true;
            if(selfInfo.IsVIP)
            {
               if(selfInfo.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && selfInfo.VIPLeftDays >= 0 || selfInfo.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  VipController.instance.showRechargeAlert();
               }
            }
            else if(selfInfo.VIPExp > 0)
            {
               VipController.instance.showRechargeAlert();
            }
         }
      }
      
      private function __goRenewal(evt:FrameEvent) : void
      {
         this._renewal.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               VipController.instance.show();
         }
         this._renewal.dispose();
         if(Boolean(this._renewal.parent))
         {
            this._renewal.parent.removeChild(this._renewal);
         }
         this._renewal = null;
      }
      
      private function __vote(e:Event) : void
      {
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         VoteManager.Instance.openVote();
      }
      
      private function checkShowStoreFromShop() : void
      {
         if(BagStore.instance.isFromShop)
         {
            BagStore.instance.isFromShop = false;
            BagStore.instance.show();
         }
      }
      
      private function toFightLib() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.CAMPAIGN_LAB_OPEN,15))
         {
            WeakGuildManager.Instance.showBuildPreview("campaignLab_mc",LanguageMgr.GetTranslation("tank.hall.ChooseHallView.campaignLabAlert"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",15));
            return;
         }
         if(PathManager.getFightLibEanble())
         {
            StateManager.setState(StateType.FIGHT_LIB);
            ComponentSetting.SEND_USELOG_ID(12);
            if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_CLICKED))
            {
               SocketManager.Instance.out.syncWeakStep(Step.CAMPAIGN_LAB_CLICKED);
            }
         }
         else
         {
            this.createBattle();
         }
      }
      
      private function toDungeon() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,10))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
            return;
         }
         if(!PlayerManager.Instance.checkEnterDungeon)
         {
            return;
         }
         StateManager.currentStateType = StateType.DUNGEON_LIST;
         DungeonListController.instance.enter();
         ComponentSetting.SEND_USELOG_ID(4);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
         }
      }
      
      private function toFarmSelf() : void
      {
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      private function __btnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         evt.stopPropagation();
         btnID = this._btnList.indexOf(evt.currentTarget);
         this._playerView.MapClickFlag = false;
         this._playerView.setSelfPlayerPos(this._selfPosArray[btnID]);
      }
      
      private function __onBtnClick(event:NewHallEvent) : void
      {
         switch(btnID)
         {
            case 0:
               this.toDungeon();
               break;
            case 1:
               if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,2))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",2));
                  return;
               }
               StateManager.currentStateType = StateType.ROOM_LIST;
               RoomListController.instance.enter();
               ComponentSetting.SEND_USELOG_ID(3);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
               {
                  TrainStep.send(TrainStep.Step.ENTER_GAMEHALL);
                  SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
               }
               break;
            case 2:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,30))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               LabyrinthManager.Instance.show();
               break;
            case 3:
               this.toFarmSelf();
               break;
            case 4:
               this.ringStationShow();
               break;
            case 5:
               this.showCryptBossFrame();
               break;
            case 6:
               if(!WeakGuildManager.Instance.checkOpen(Step.CHURCH_OPEN,15))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",15));
                  return;
               }
               StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(6);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CHURCH_CLICKED);
               }
               break;
            case 7:
               GypsyShopManager.getInstance().showMainFrame();
               break;
            case 9:
               if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,17))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               ComponentSetting.SEND_USELOG_ID(5);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
               }
               break;
            case 10:
               if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
               {
                  if(PlayerManager.Instance.Self.Grade < 5)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                     return;
                  }
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               ComponentSetting.SEND_USELOG_ID(2);
               break;
            case 11:
               if(!WeakGuildManager.Instance.checkOpen(Step.AUCTION_OPEN,18))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",18));
                  return;
               }
               StateManager.setState(StateType.AUCTION);
               ComponentSetting.SEND_USELOG_ID(7);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.AUCTION_CLICKED);
               }
               break;
            case 12:
            case 13:
            case 14:
               BombKingManager.instance.onShow();
         }
         if(btnID != DragonBoatManager.BTNID_DRAGONBOAT && btnID != MagicHouseManager.BTNID_MAGICHOUSE)
         {
            btnID = -1;
         }
      }
      
      private function showCryptBossFrame() : void
      {
         CryptBossManager.instance.show();
      }
      
      private function loadUserGuide() : void
      {
         if(NewHandGuideManager.Instance.progress < Step.POP_EXPLAIN_ONE && WeakGuildManager.Instance.switchUserGuide)
         {
            if(PathManager.TRAINER_STANDALONE && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE))
            {
               SocketManager.Instance.out.syncStep(Step.POP_EXPLAIN_ONE,true);
               this.prePopWelcome();
               this.sendToLoginInterface();
               DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.ADD_ROLE));
            }
         }
         MainToolBar.Instance.tipTask();
      }
      
      private function sendToLoginInterface() : void
      {
         var loader:RequestLoader = null;
         var args:URLVariables = new URLVariables();
         var username:String = PlayerManager.Instance.Self.ID.toString();
         username = encodeURI(username);
         args["username"] = username;
         args["sign"] = MD5.hash(username + "sdkxccjlqaoehtdwjkdycdrw");
         var requestURL:String = PathManager.callLoginInterface();
         if(Boolean(requestURL))
         {
            loader = LoadResourceManager.Instance.createLoader(requestURL,BaseLoader.REQUEST_LOADER,args);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function prePopWelcome() : void
      {
         TrainStep.send(TrainStep.Step.ENTER_MAIN_GAME);
         this._trainerWelcomeView = ComponentFactory.Instance.creat("trainer.welcome.mainFrame");
         this._trainerWelcomeView.addEventListener(FrameEvent.RESPONSE,this.__trainerResponse);
         this._trainerWelcomeView.show();
      }
      
      private function __trainerResponse(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__trainerResponse);
            SoundManager.instance.play("008");
            TrainStep.send(TrainStep.Step.CLICK_TIP_CONFIRM);
            if(!PathManager.TRAINER_STANDALONE && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE))
            {
               NewHandGuideManager.Instance.mapID = 111;
               SocketManager.Instance.out.createUserGuide();
            }
            this.finPopWelcome();
         }
      }
      
      private function exePopWelcome() : Boolean
      {
         return RoomManager.Instance.current != null;
      }
      
      private function finPopWelcome() : void
      {
         var img:Bitmap = null;
         if(Boolean(this._trainerWelcomeView))
         {
            this._trainerWelcomeView.dispose();
            this._trainerWelcomeView = null;
         }
         if(PlayerManager.Instance.Self.Sex)
         {
            img = ComponentFactory.Instance.creatBitmap("asset.hall.maleImg");
         }
         else
         {
            img = ComponentFactory.Instance.creatBitmap("asset.hall.femaleImg");
         }
         this._dialog = new NewOpenGuideDialogView();
         this._dialog.showMouseMsgTxt(true);
         this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.firstEnterPrompt1"),PlayerManager.Instance.Self.NickName,img,new Point(163,339));
         this._dialog.addEventListener(MouseEvent.CLICK,this.dialogNextHandler);
         LayerManager.Instance.addToLayer(this._dialog,LayerManager.STAGE_TOP_LAYER);
      }
      
      private function dialogNextHandler(event:MouseEvent) : void
      {
         this._dialog.removeEventListener(MouseEvent.CLICK,this.dialogNextHandler);
         this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.firstEnterPrompt2",PlayerManager.Instance.Self.NickName));
         this._dialog.addEventListener(MouseEvent.CLICK,this.dialogNextHandler2);
      }
      
      private function dialogNextHandler2(event:MouseEvent) : void
      {
         this._dialog.removeEventListener(MouseEvent.CLICK,this.dialogNextHandler2);
         ObjectUtils.disposeObject(this._dialog);
         this._dialog = null;
         var tmp:MovieClip = ComponentFactory.Instance.creat("asset.newHandGuide.hideShowPlayerPrompt");
         tmp.x = 692;
         tmp.y = 48;
         LayerManager.Instance.addToLayer(tmp,LayerManager.GAME_TOP_LAYER);
         setTimeout(this.disposeHideShowPrompt,5000,tmp);
         HallTaskGuideManager.instance.showTask1ClickBagArrow();
      }
      
      private function disposeHideShowPrompt(tmp:MovieClip) : void
      {
         tmp.gotoAndStop(1);
         tmp.parent.removeChild(tmp);
      }
      
      private function createBattle() : void
      {
         this._battleFrame = ComponentFactory.Instance.creatComponentByStylename("hall.battleFrame");
         this._battleFrame.titleText = LanguageMgr.GetTranslation("tank.hall.ChooseHallView.campaignLabAlert");
         this._battleFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._battlePanel = ComponentFactory.Instance.creatComponentByStylename("hall.battleSrollPanel");
         this._battleFrame.addToContent(this._battlePanel);
         this._battleImg = ComponentFactory.Instance.creatBitmap("asset.hall.battleLABS");
         this._battlePanel.setView(this._battleImg);
         this._battleBtn = ComponentFactory.Instance.creatComponentByStylename("hall.battleBtn");
         this._battleBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         this._battleFrame.addToContent(this._battleBtn);
         this._battleBtn.addEventListener(MouseEvent.CLICK,this.__battleBtnClick);
         LayerManager.Instance.addToLayer(this._battleFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function showSPAAlert() : void
      {
         var alert:Frame = ComponentFactory.Instance.creatComponentByStylename("hall.hotSpringAlertFrame");
         alert.addEventListener(FrameEvent.RESPONSE,this.__onRespose);
         LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onRespose(event:FrameEvent) : void
      {
         var alert:Frame = event.currentTarget as Frame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         alert.dispose();
      }
      
      private function __battleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.battleFrameClose();
      }
      
      private function battleFrameClose() : void
      {
         this._battleFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._battleBtn.removeEventListener(MouseEvent.CLICK,this.__battleBtnClick);
         this._battlePanel = null;
         this._battleImg = null;
         this._battleFrame.dispose();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.battleFrameClose();
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         var i:int = 0;
         var j:int = 0;
         SuperWinnerManager.instance.removeEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
         if(Boolean(this._playerInfoView))
         {
            this._playerInfoView.dispose();
            this._playerInfoView = null;
         }
         if(Boolean(this._playerOperateView))
         {
            this._playerOperateView.dispose();
            this._playerOperateView = null;
         }
         GypsyShopManager.getInstance().hideNPC();
         GypsyShopManager.getInstance().dispose();
         if(Boolean(this._playerView))
         {
            this._playerView.removeEventListener(NewHallEvent.BTNCLICK,this.__onBtnClick);
            this._playerView.dispose();
            this._playerView = null;
         }
         this.removeDdtActiviyIconState();
         WonderfulActivityManager.Instance.removeEventListener(WonderfulActivityEvent.CHECK_ACTIVITY_STATE,this.__checkShowWonderfulActivityTip);
         LeftGunRouletteManager.instance.removeEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         LeftGunRouletteManager.instance.hideGunButton();
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         TaskManager.instance.removeEventListener(TaskMainFrame.TASK_FRAME_HIDE,this.__taskFrameHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKLYSTONE_ACTIVITY,this.__getLuckStoneEnable);
         MainToolBar.Instance.hide();
         MainToolBar.Instance.updateReturnBtn(MainToolBar.LEAVE_HALL);
         DailyButtunBar.Insance.hide();
         KingBlessManager.instance.clearConfirmFrame();
         DragonBoatManager.instance.disposeEntryBtn();
         NewHandContainer.Instance.clearArrowByID(ArrowType.HALL_BUILD);
         SystemOpenPromptManager.instance.dispose();
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ICON_RES_LOAD_COMPLETE,this.sevenDoubleIconResLoadComplete);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.END,this.sevendoubleEndHandler);
         WantStrongManager.Instance.removeEventListener(WantStrongEvent.ALREADYFINDBACK,this.__alreadyFindBackHandler);
         WantStrongManager.Instance.removeEventListener(WantStrongEvent.ALREADYUPDATETIME,this.__alreadyUpdateTimeHandler);
         if(Boolean(this._timer) && this._timer.running)
         {
            this._timer.stop();
         }
         if(Boolean(this._shine))
         {
            while(this._shine.length > 0)
            {
               this._shine.shift().dispose();
            }
            this._shine = null;
         }
         if(Boolean(this._black))
         {
            ObjectUtils.disposeObject(this._black);
            this._black = null;
         }
         if(Boolean(this._btnList))
         {
            for(i = 0; i < this._btnList.length; i++)
            {
               this._btnList[i].removeEventListener(MouseEvent.CLICK,this.__btnClick);
               this._btnList[i].dispose();
               this._btnList[i] = null;
            }
            this._btnList.length = 0;
         }
         this._btnList = null;
         if(Boolean(this._btnTipList))
         {
            for(j = 0; j < this._btnTipList.length; j++)
            {
               this._btnTipList[j].dispose();
               this._btnTipList[j] = null;
            }
            this._btnTipList.length = 0;
         }
         this._btnTipList = null;
         WorldBossManager.Instance.disposeEnterBtn();
         if(Boolean(this._angelblessIcon))
         {
            ObjectUtils.disposeObject(this._angelblessIcon);
         }
         this._angelblessIcon = null;
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         if(PathManager.solveWeeklyEnable())
         {
            TimesManager.Instance.hideButton();
         }
         if(next.getType() != StateType.DUNGEON_LIST && next.getType() != StateType.ROOM_LIST)
         {
            GameInSocketOut.sendExitScene();
         }
         ObjectUtils.disposeObject(this._taskTrackMainView);
         this._taskTrackMainView = null;
         HallTaskTrackManager.instance.btnList = null;
         if(Boolean(this._bgSprite))
         {
            ObjectUtils.disposeAllChildren(this._bgSprite);
            this._bgSprite = null;
         }
         GradeAwardsBoxButtonManager.getInstance().dispose();
         NewOpenGuideManager.instance.closeShow();
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(Boolean(this._hallRightIconView))
         {
            ObjectUtils.disposeObject(this._hallRightIconView);
            this._hallRightIconView = null;
         }
         this.defaultRightWonderfulPlayIconRemove();
         this.defaultRightActivityIconRemove();
         ObjectUtils.disposeAllChildren(this);
         GCPlus.clear();
         super.leaving(next);
      }
      
      override public function prepare() : void
      {
         super.prepare();
         this._isFirst = true;
      }
      
      override public function fadingComplete() : void
      {
         var frame:SaveFileWidow = null;
         super.fadingComplete();
         if(this._isFirst)
         {
            this._isFirst = false;
            if(LoaderSavingManager.cacheAble == false && PlayerManager.Instance.Self.IsFirst > 1 && PlayerManager.Instance.Self.LastServerId == -1)
            {
               frame = ComponentFactory.Instance.creatComponentByStylename("hall.SaveFileWidow");
               frame.show();
            }
            LeavePageManager.setFavorite(PlayerManager.Instance.Self.IsFirst <= 1);
         }
      }
      
      private function showBuildOpen(step:int, style:String) : void
      {
         if(StateManager.currentStateType != StateType.MAIN)
         {
            return;
         }
         SocketManager.Instance.out.syncWeakStep(step);
      }
      
      private function __completeGameRoom(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeGameRoom);
         this.buildShine(Step.GAME_ROOM_CLICKED,"asset.trainer.RoomShineAsset","trainer.posBuildGameRoom");
      }
      
      private function __completeConsortia(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeConsortia);
         this.buildShine(Step.CONSORTIA_CLICKED,"asset.trainer.shineConsortia","trainer.posBuildConsortia");
      }
      
      private function __completeDungeon(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeDungeon);
         this.buildShine(Step.DUNGEON_CLICKED,"asset.trainer.shineDungeon","trainer.posBuildDungeon");
      }
      
      private function __completeChurch(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeChurch);
         this.buildShine(Step.CHURCH_CLICKED,"asset.trainer.shineChurch","trainer.posBuildChurch");
      }
      
      private function __completeToffList(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeToffList);
         this.buildShine(Step.TOFF_LIST_CLICKED,"asset.trainer.shineToffList","trainer.posBuildToffList");
      }
      
      private function __completeAuction(evt:Event) : void
      {
         MovieClipWrapper(evt.currentTarget).removeEventListener(Event.COMPLETE,this.__completeAuction);
         this.buildShine(Step.AUCTION_CLICKED,"asset.trainer.shineAuction","trainer.posBuildAuction");
      }
      
      private function __onClickServerName(e:MouseEvent) : void
      {
      }
      
      private function buildShine(step:int, style:String, pos:String) : void
      {
      }
      
      override public function refresh() : void
      {
         var curtain:StageCurtain = new StageCurtain();
         curtain.play(25);
         LayerManager.Instance.clearnGameDynamic();
         ShowTipManager.Instance.removeAllTip();
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         ChatManager.Instance.view.visible = true;
         ChatManager.Instance.lock = ChatManager.HALL_CHAT_LOCK;
         ChatManager.Instance.chatDisabled = false;
         addChild(ChatManager.Instance.view);
         super.refresh();
      }
      
      private function checkShowWorldBossEntrance() : void
      {
      }
      
      private function checkShowWorldBossHelper() : void
      {
         if(WorldBossManager.Instance.bossInfo && !WorldBossManager.Instance.bossInfo.fightOver && WorldBossHelperManager.Instance.helperOpen && !WorldBossHelperManager.Instance.isInWorldBossHelperFrame && !WorldBossHelperManager.Instance.isHelperInited)
         {
            if(WorldBossHelperManager.Instance.isHelperOnlyOnce)
            {
               if(WorldBossManager.Instance.worldBossNum > 1)
               {
                  return;
               }
               WorldBossHelperManager.Instance.setup();
            }
            else
            {
               WorldBossHelperManager.Instance.setup();
            }
         }
      }
      
      public function get ringStationClickDate() : Number
      {
         return this._ringStationClickDate;
      }
   }
}

