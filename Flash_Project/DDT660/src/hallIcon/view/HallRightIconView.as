package hallIcon.view
{
   import DDPlay.DDPlayManaer;
   import Dice.DiceManager;
   import GodSyah.SyahManager;
   import accumulativeLogin.AccumulativeManager;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import campbattle.CampBattleManager;
   import catchInsect.CatchInsectMananger;
   import catchbeast.CatchBeastManager;
   import chickActivation.ChickActivationManager;
   import christmas.manager.ChristmasManager;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import dayActivity.DayActivityManager;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.view.bossbox.SmallBoxButton;
   import entertainmentMode.EntertainmentModeManager;
   import escort.EscortManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import firstRecharge.FirstRechargeManger;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flowerGiving.FlowerGivingManager;
   import foodActivity.FoodActivityManager;
   import foodActivity.view.FoodActivityEnterIcon;
   import godsRoads.manager.GodsRoadsManager;
   import groupPurchase.GroupPurchaseManager;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import horseRace.controller.HorseRaceManager;
   import kingDivision.KingDivisionManager;
   import lanternriddles.LanternRiddlesManager;
   import lightRoad.manager.LightRoadManager;
   import littleGame.LittleGameManager;
   import luckStar.manager.LuckStarManager;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import mysteriousRoullete.MysteriousManager;
   import newChickenBox.controller.NewChickenBoxManager;
   import newYearRice.NewYearRiceManager;
   import oldPlayerRegress.RegressManager;
   import pyramid.PyramidManager;
   import rescue.RescueManager;
   import ringStation.RingStationManager;
   import room.transnational.TransnationalFightManager;
   import roulette.LeftGunRouletteManager;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDouble.SevenDoubleManager;
   import shop.manager.ShopSaleManager;
   import superWinner.manager.SuperWinnerManager;
   import trainer.TrainStep;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import treasureHunting.TreasureManager;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import wantstrong.WantStrongManager;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActivityManager;
   import zodiac.ZodiacManager;
   
   public class HallRightIconView extends Sprite implements Disposeable
   {
      
      private var _iconBox:HBox;
      
      private var _boxButton:SmallBoxButton;
      
      private var _wonderFulPlay:HallIconPanel;
      
      private var _everyDayActivityIcon:MovieClip;
      
      private var _activity:HallIconPanel;
      
      private var _wantstrongIcon:MovieClip;
      
      private var _firstRechargeIcon:MovieClip;
      
      private var _lastCreatTime:Number;
      
      private var _foodButton:FoodActivityEnterIcon;
      
      private var _showArrowSp:Sprite;
      
      public function HallRightIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._showArrowSp = new Sprite();
         addChild(this._showArrowSp);
         this._iconBox = new HBox();
         this._iconBox.spacing = 5;
         addChild(this._iconBox);
         this.updateActivityIcon();
         this.updateWonderfulPlayIcon();
         this.updateEveryDayActivityIcon();
         this.updateWantstrongIcon();
         this.updateFirstRechargeIcon();
         this.checkShowBossBox();
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.addEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
         FirstRechargeManger.Instance.addEventListener(FirstRechargeManger.REMOVEFIRSTRECHARGEICON,this.__removeIcon);
         FirstRechargeManger.Instance.addEventListener(FirstRechargeManger.ADDFIRSTRECHARGEICON,this.__addIcon);
      }
      
      private function __addIcon(e:Event) : void
      {
         if(this._firstRechargeIcon == null)
         {
            this._firstRechargeIcon = ClassUtils.CreatInstance("assets.hallIcon.firstRechargeIcon");
            this._firstRechargeIcon.addEventListener(MouseEvent.CLICK,this.__firstRechargeIconClickHandler);
            this._firstRechargeIcon.buttonMode = true;
            this._firstRechargeIcon.mouseChildren = false;
            this.addChildBox(this._firstRechargeIcon);
         }
      }
      
      private function __removeIcon(e:Event) : void
      {
         this.removeFirstRechargeIcon();
      }
      
      private function addChildBox($child:DisplayObject) : void
      {
         this._iconBox.addChild($child);
         this._iconBox.arrange();
         this._iconBox.x = -this._iconBox.width;
      }
      
      private function __updateBatchIconViewHandler(evt:HallIconEvent) : void
      {
         var info:HallIconInfo = null;
         var dic:Dictionary = HallIconManager.instance.model.cacheRightIconDic;
         for each(info in dic)
         {
            this.updateIconView(info);
         }
      }
      
      private function __updateIconViewHandler(evt:HallIconEvent) : void
      {
         var iconInfo:HallIconInfo = HallIconInfo(evt.data);
         this.updateIconView(iconInfo);
      }
      
      private function updateIconView($iconInfo:HallIconInfo) : void
      {
         if($iconInfo.halltype == HallIcon.WONDERFULPLAY && Boolean(this._wonderFulPlay))
         {
            this.commonUpdateIconPanelView(this._wonderFulPlay,$iconInfo,false);
            if(!$iconInfo.isopen)
            {
               this.removeWonderFulPlayChildHandler($iconInfo.icontype);
            }
         }
         else if($iconInfo.halltype == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            this.commonUpdateIconPanelView(this._activity,$iconInfo,true);
         }
         else
         {
            switch($iconInfo.icontype)
            {
               case HallIconType.WONDERFULPLAY:
                  this.updateWonderfulPlayIcon();
                  break;
               case HallIconType.EVERYDAYACTIVITY:
                  this.updateEveryDayActivityIcon();
                  break;
               case HallIconType.ACTIVITY:
                  this.updateActivityIcon();
                  break;
               case HallIconType.WANTSTRONG:
                  this.updateWantstrongIcon();
                  break;
               case HallIconType.FIRSTRECHARGE:
                  this.updateFirstRechargeIcon();
                  break;
               case HallIconType.FOODACTIVITY:
                  this.checkFoodBox();
            }
         }
      }
      
      private function checkFoodBox() : void
      {
         if(FoodActivityManager.Instance._isStart)
         {
            if(this._foodButton == null)
            {
               this._foodButton = FoodActivityManager.Instance.foodActivityIcon;
               this.addChildBox(this._foodButton);
            }
         }
         else
         {
            this.removeFoodBox();
         }
      }
      
      private function commonUpdateIconPanelView($hallIconPanel:HallIconPanel, $iconInfo:HallIconInfo, flag:Boolean = false) : void
      {
         var tempIcon:HallIcon = null;
         if($iconInfo.isopen)
         {
            tempIcon = $hallIconPanel.getIconByType($iconInfo.icontype) as HallIcon;
            if(!tempIcon)
            {
               tempIcon = $hallIconPanel.addIcon(this.createHallIconPanelIcon($iconInfo),$iconInfo.icontype,$iconInfo.orderid,flag) as HallIcon;
            }
            tempIcon.updateIcon($iconInfo);
         }
         else
         {
            $hallIconPanel.removeIconByType($iconInfo.icontype);
         }
         $hallIconPanel.arrange();
      }
      
      private function updateEveryDayActivityIcon() : void
      {
         if(HallIconManager.instance.model.everyDayActivityIsOpen)
         {
            if(this._everyDayActivityIcon == null)
            {
               this._everyDayActivityIcon = ClassUtils.CreatInstance("assets.hallIcon.everyDayActivityIcon");
               this._everyDayActivityIcon.addEventListener(MouseEvent.CLICK,this.__everyDayActivityIconClickHandler);
               this._everyDayActivityIcon.buttonMode = true;
               this._everyDayActivityIcon.mouseChildren = false;
               this.addChildBox(this._everyDayActivityIcon);
            }
         }
         else
         {
            this.removeEveryDayActivityIcon();
         }
      }
      
      private function __everyDayActivityIconClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DayActivityManager.Instance.initActivityFrame();
      }
      
      private function updateWantstrongIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 8)
         {
            if(this._wantstrongIcon == null)
            {
               this._wantstrongIcon = ClassUtils.CreatInstance("assets.hallIcon.wantstrongIcon");
               this._wantstrongIcon.addEventListener(MouseEvent.CLICK,this.__wantstrongIconClickHandler);
               this._wantstrongIcon.buttonMode = true;
               this._wantstrongIcon.mouseChildren = false;
               this.addChildBox(this._wantstrongIcon);
            }
         }
         else
         {
            this.removeWantstrongIcon();
         }
      }
      
      private function __wantstrongIconClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         WantStrongManager.Instance.setup();
      }
      
      private function updateFirstRechargeIcon() : void
      {
         if(HallIconManager.instance.model.firstRechargeIsOpen)
         {
            if(this._firstRechargeIcon == null)
            {
               this._firstRechargeIcon = ClassUtils.CreatInstance("assets.hallIcon.firstRechargeIcon");
               this._firstRechargeIcon.addEventListener(MouseEvent.CLICK,this.__firstRechargeIconClickHandler);
               this._firstRechargeIcon.buttonMode = true;
               this._firstRechargeIcon.mouseChildren = false;
               this.addChildBox(this._firstRechargeIcon);
            }
         }
         else
         {
            this.removeFirstRechargeIcon();
         }
      }
      
      private function __firstRechargeIconClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FirstRechargeManger.Instance.showView();
      }
      
      private function updateWonderfulPlayIcon() : void
      {
         if(HallIconManager.instance.model.wonderFulPlayIsOpen)
         {
            if(this._wonderFulPlay == null)
            {
               this._wonderFulPlay = new HallIconPanel("assets.hallIcon.wonderfulPlayIcon",HallIconPanel.BOTTOM,6);
               this._wonderFulPlay.addEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
               this.addChildBox(this._wonderFulPlay);
            }
         }
         else
         {
            this.removeWonderfulPlayIcon();
         }
      }
      
      private function checkShowBossBox() : void
      {
         if(BossBoxManager.instance.isShowBoxButton())
         {
            if(this._boxButton == null)
            {
               this._boxButton = new SmallBoxButton(SmallBoxButton.HALL_POINT);
            }
            this.addChildBox(this._boxButton);
         }
         else
         {
            this.removeBossBox();
         }
      }
      
      private function __wonderFulPlayClickHandler(evt:MouseEvent) : void
      {
         var icon:HallIcon = null;
         if(Boolean(this._wonderFulPlay) && evt.target == this._wonderFulPlay.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._wonderFulPlay.count);
            this.checkRightIconTaskClickHandler(HallIcon.WONDERFULPLAY);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(evt.target is HallIcon)
         {
            icon = evt.target as HallIcon;
            if(icon.iconInfo.halltype == HallIcon.WONDERFULPLAY)
            {
               switch(icon.iconInfo.icontype)
               {
                  case HallIconType.WORLDBOSSENTRANCE1:
                  case HallIconType.WORLDBOSSENTRANCE4:
                     SoundManager.instance.play("003");
                     StateManager.setState(StateType.WORLDBOSS_AWARD);
                     break;
                  case HallIconType.CAMP:
                     CampBattleManager.instance.onCampBtnHander(evt);
                     break;
                  case HallIconType.BATTLE:
                     SoundManager.instance.play("008");
                     if(PlayerManager.Instance.Self.Grade < 21)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",21));
                        return;
                     }
                     if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                        return;
                     }
                     BattleGroudManager.Instance.addBattleSingleRoom();
                     break;
                  case HallIconType.SEVENDOUBLE:
                     SoundManager.instance.play("008");
                     if(SevenDoubleManager.instance.isInGame)
                     {
                        SevenDoubleManager.instance.addEventListener(SevenDoubleManager.CAN_ENTER,this.sevenDoubleCanEnterHandler);
                        SocketManager.Instance.out.sendSevenDoubleCanEnter();
                     }
                     else
                     {
                        SevenDoubleManager.instance.loadSevenDoubleModule();
                     }
                     break;
                  case HallIconType.LEAGUE:
                     SoundManager.instance.playButtonSound();
                     if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,20))
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                        return;
                     }
                     StateManager.setState(StateType.ROOM_LIST);
                     ComponentSetting.SEND_USELOG_ID(3);
                     if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
                     {
                        SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
                     }
                     break;
                  case HallIconType.RINGSTATION:
                     SoundManager.instance.playButtonSound();
                     RingStationManager.instance.show();
                     break;
                  case HallIconType.TRANSNATIONAL:
                     SoundManager.instance.play("008");
                     if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                        return;
                     }
                     TransnationalFightManager.Instance.enterTransnationalFight();
                     break;
                  case HallIconType.FIGHTFOOTBALLTIME:
                     SoundManager.instance.play("008");
                     if(PlayerManager.Instance.Self.Grade < 20)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("fightFootballTime.match.levelMsg"));
                        return;
                     }
                     FightFootballTimeManager.instance.enterFightFootballTime();
                     break;
                  case HallIconType.CONSORTIABATTLE:
                     SoundManager.instance.play("008");
                     if(ConsortiaBattleManager.instance.isCanEnter)
                     {
                        GameInSocketOut.sendSingleRoomBegin(4);
                     }
                     else if(PlayerManager.Instance.Self.ConsortiaID != 0)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
                     }
                     break;
                  case HallIconType.LITTLEGAMENOTE:
                     SoundManager.instance.play("008");
                     if(LittleGameManager.Instance.hasActive())
                     {
                        StateManager.setState(StateType.LITTLEHALL);
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     }
                     break;
                  case HallIconType.FLOWERGIVING:
                     FlowerGivingManager.instance.onIconClick(evt);
                     break;
                  case HallIconType.ESCORT:
                     if(EscortManager.instance.isInGame)
                     {
                        EscortManager.instance.addEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
                        SocketManager.Instance.out.sendEscortCanEnter();
                     }
                     else
                     {
                        EscortManager.instance.loadEscortModule();
                     }
                     break;
                  case HallIconType.BURIED:
                     SoundManager.instance.play("003");
                     SocketManager.Instance.out.enterBuried();
               }
            }
         }
      }
      
      public function removeWonderFulPlayChildHandler($icontype:String) : void
      {
         switch($icontype)
         {
            case HallIconType.SEVENDOUBLE:
               SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.CAN_ENTER,this.sevenDoubleCanEnterHandler);
               break;
            case HallIconType.ESCORT:
               EscortManager.instance.removeEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
         }
      }
      
      private function sevenDoubleCanEnterHandler(event:Event) : void
      {
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.CAN_ENTER,this.sevenDoubleCanEnterHandler);
         StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
      }
      
      private function canEnterHandler(event:Event) : void
      {
         EscortManager.instance.removeEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
         StateManager.setState(StateType.ESCORT);
      }
      
      private function updateActivityIcon() : void
      {
         if(HallIconManager.instance.model.activityIsOpen)
         {
            if(this._activity == null)
            {
               this._activity = new HallIconPanel("assets.hallIcon.activityIcon",HallIconPanel.BOTTOM,6);
               this._activity.addEventListener(MouseEvent.CLICK,this.__activityClickHandler);
               this.addChildBox(this._activity);
            }
         }
         else
         {
            this.removeActivityIcon();
         }
      }
      
      private function __activityClickHandler(evt:MouseEvent) : void
      {
         var icon:HallIcon = null;
         var self:PlayerInfo = null;
         if(WonderfulActivityManager.isFirstClick)
         {
            WonderfulActivityManager.isFirstClick = false;
            TrainStep.send(TrainStep.CLICK_WONDERFULACTIVITY);
         }
         SevenDayTargetManager.Instance.isHallAct = false;
         if(Boolean(this._activity) && evt.target == this._activity.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._activity.count);
            this.checkRightIconTaskClickHandler(HallIcon.ACTIVITY);
            return;
         }
         SevenDayTargetManager.Instance.isHallAct = false;
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(evt.target is HallIcon)
         {
            icon = evt.target as HallIcon;
            if(icon.iconInfo.halltype == HallIcon.ACTIVITY)
            {
               switch(icon.iconInfo.icontype)
               {
                  case HallIconType.CHRISTMAS:
                     ChristmasManager.instance.onClickChristmasIcon(evt);
                     break;
                  case HallIconType.CATCHBEAST:
                     CatchBeastManager.instance.onCatchBeastShow(evt);
                     break;
                  case HallIconType.PYRAMID:
                     PyramidManager.instance.onClickPyramidIcon(evt);
                     break;
                  case HallIconType.SUPERWINNER:
                     SuperWinnerManager.instance.openSuperWinner(evt);
                     break;
                  case HallIconType.LUCKSTAR:
                     LuckStarManager.Instance.onClickLuckyStarIocn(evt);
                     break;
                  case HallIconType.GROWTHPACKAGE:
                     GrowthPackageManager.instance.onClickIcon(evt);
                     break;
                  case HallIconType.DICE:
                     DiceManager.Instance.EnterDice();
                     break;
                  case HallIconType.ACCUMULATIVE_LOGIN:
                     AccumulativeManager.instance.showFrame();
                     break;
                  case HallIconType.GUILDMEMBERWEEK:
                     GuildMemberWeekManager.instance.onClickguildMemberWeekIcon(evt);
                     break;
                  case HallIconType.LANTERNRIDDLES:
                     LanternRiddlesManager.instance.onLanternShow(evt);
                     break;
                  case HallIconType.NEWCHICKENBOX:
                     NewChickenBoxManager.instance.enterNewBoxView(evt);
                     break;
                  case HallIconType.LEFTGUNROULETTE:
                     LeftGunRouletteManager.instance.onGunBtnClick(evt);
                     break;
                  case HallIconType.GROUPPURCHASE:
                     GroupPurchaseManager.instance.showFrame();
                     break;
                  case HallIconType.LUCKSTONE:
                     SoundManager.instance.play("008");
                     if(PlayerManager.Instance.Self.bagLocked)
                     {
                        BaglockedManager.Instance.show();
                        return;
                     }
                     RouletteManager.instance.useBless();
                     break;
                  case HallIconType.MYSTERIOUROULETTE:
                     MysteriousManager.instance.showFrame();
                     break;
                  case HallIconType.SYAH:
                     SyahManager.Instance.showFrame();
                     break;
                  case HallIconType.TREASUREHUNTING:
                     TreasureManager.instance.showFrame();
                     break;
                  case HallIconType.OLDPLAYERREGRESS:
                     RegressManager.instance.show();
                     break;
                  case HallIconType.LIMITACTIVITY:
                     SoundManager.instance.play("008");
                     WonderfulActivityManager.Instance.clickWonderfulActView = true;
                     SocketManager.Instance.out.requestWonderfulActInit(1);
                     break;
                  case HallIconType.LIGHTROAD:
                     LightRoadManager.instance.onClicklightRoadIcon(evt);
                     break;
                  case HallIconType.SEVENDAYTARGET:
                     NewSevenDayAndNewPlayerManager.Instance.onClickSevenDayTargetIcon(evt);
                     break;
                  case HallIconType.GODSROADS:
                     GodsRoadsManager.instance.openGodsRoads(evt);
                     break;
                  case HallIconType.ENTERTAINMENT:
                     SoundManager.instance.play("008");
                     EntertainmentModeManager.instance.show();
                     break;
                  case HallIconType.SALESHOP:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.sendGetShopBuyLimitedCount();
                     ShopSaleManager.Instance.show();
                     break;
                  case HallIconType.KINGDIVISION:
                     SoundManager.instance.play("008");
                     KingDivisionManager.Instance.onClickIcon();
                     break;
                  case HallIconType.CHICKACTIVATION:
                     SoundManager.instance.play("008");
                     ChickActivationManager.instance.showFrame();
                     break;
                  case HallIconType.DDPLAY:
                     SoundManager.instance.play("008");
                     DDPlayManaer.Instance.show();
                     break;
                  case HallIconType.BOGUADVENTURE:
                     SoundManager.instance.playButtonSound();
                     StateManager.setState(StateType.BOGU_ADVENTURE);
                     break;
                  case HallIconType.WITCHBLESSING:
                     SoundManager.instance.playButtonSound();
                     WitchBlessingManager.Instance.onClickIcon();
                     break;
                  case HallIconType.TREASUREPUZZLE:
                     SoundManager.instance.playButtonSound();
                     TreasurePuzzleManager.Instance.onClickTreasurePuzzleIcon();
                     break;
                  case HallIconType.WORSHIPTHEMOON:
                     SoundManager.instance.playButtonSound();
                     WorshipTheMoonManager.getInstance().showFrame();
                     break;
                  case HallIconType.HALLOWEEN:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.halloweenInit();
                     break;
                  case HallIconType.RESCUE:
                     SoundManager.instance.play("008");
                     RescueManager.instance.show();
                     break;
                  case HallIconType.CATCHINSECT:
                     SoundManager.instance.play("008");
                     CatchInsectMananger.instance.loaderCatchInsectFrame();
                     break;
                  case HallIconType.MAGPIEBRIDGE:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.enterMagpieBridge();
                     break;
                  case HallIconType.CLOUDBUYLOTTERY:
                     SoundManager.instance.play("008");
                     CloudBuyLotteryManager.Instance.loaderCloudBuyFrame();
                     break;
                  case HallIconType.TREASURELOST:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.enterTreasureLost();
                     break;
                  case HallIconType.NEWYEARRICE:
                     SoundManager.instance.play("008");
                     NewYearRiceManager.instance.onClickNewYearRiceIcon(evt);
                     break;
                  case HallIconType.ZODIAC:
                     SoundManager.instance.play("008");
                     ZodiacManager.instance.showFrame();
                     break;
                  case HallIconType.HORSERACE:
                     SoundManager.instance.play("008");
                     self = PlayerManager.Instance.Self;
                     if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                        return;
                     }
                     if(self.IsMounts)
                     {
                        HorseRaceManager.Instance.enterView();
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horseRace.noMount"));
                     }
                     break;
               }
            }
         }
      }
      
      public function createHallIconPanelIcon($iconInfo:HallIconInfo) : HallIcon
      {
         var iconString:String = null;
         switch($iconInfo.icontype)
         {
            case HallIconType.WORLDBOSSENTRANCE1:
               iconString = "assets.hallIcon.worldBossEntrance_1";
               break;
            case HallIconType.WORLDBOSSENTRANCE4:
               iconString = "assets.hallIcon.worldBossEntrance_4";
               break;
            case HallIconType.CAMP:
               iconString = "assets.hallIcon.campIcon";
               break;
            case HallIconType.BATTLE:
               iconString = "assets.hallIcon.battleIcon";
               break;
            case HallIconType.SEVENDOUBLE:
               iconString = "assets.hallIcon.sevenDoubleEntryIcon";
               break;
            case HallIconType.LEAGUE:
               iconString = "assets.hallIcon.leagueIcon";
               break;
            case HallIconType.RINGSTATION:
               iconString = "assets.hallIcon.ringStationIcon";
               break;
            case HallIconType.TRANSNATIONAL:
               iconString = "assets.hallIcon.transnationalIcon";
               break;
            case HallIconType.FIGHTFOOTBALLTIME:
               iconString = "assets.hallIcon.fightFootballTimeIcon";
               break;
            case HallIconType.CONSORTIABATTLE:
               iconString = "assets.hallIcon.consortiaBattleEntryIcon";
               break;
            case HallIconType.LITTLEGAMENOTE:
               iconString = "assets.hallIcon.littleGameNoteIcon";
               break;
            case HallIconType.FLOWERGIVING:
               iconString = "assets.hallIcon.flowerGivingIcon";
               break;
            case HallIconType.ESCORT:
               iconString = "assets.hallIcon.escortEntryIcon";
               break;
            case HallIconType.BURIED:
               iconString = "assets.hallIcon.buriedIcon";
               break;
            case HallIconType.CHRISTMAS:
               iconString = "assets.hallIcon.christmasIcon";
               break;
            case HallIconType.CATCHBEAST:
               iconString = "asset.hallIcon.catchBeastIcon";
               break;
            case HallIconType.PYRAMID:
               iconString = "assets.hallIcon.pyramidIcon";
               break;
            case HallIconType.SUPERWINNER:
               iconString = "assets.hallIcon.superWinnerEntryIcon";
               break;
            case HallIconType.LUCKSTAR:
               iconString = "assets.hallIcon.luckyStarIcon";
               break;
            case HallIconType.GROWTHPACKAGE:
               iconString = "assets.hallIcon.growthPachageIcon";
               break;
            case HallIconType.DICE:
               iconString = "assets.hallIcon.diceIcon";
               break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               iconString = "assets.hallIcon.accumulativeLoginIcon";
               break;
            case HallIconType.GUILDMEMBERWEEK:
               iconString = "assets.hallIcon.guildmemberweekIcon";
               break;
            case HallIconType.LANTERNRIDDLES:
               iconString = "assets.hallIcon.lanternriddlesIcon";
               break;
            case HallIconType.NEWCHICKENBOX:
               iconString = "assets.hallIcon.newChickenBoxIcon";
               break;
            case HallIconType.LEFTGUNROULETTE:
               iconString = "assets.hallIcon.rouletteGunIcon";
               break;
            case HallIconType.GROUPPURCHASE:
               iconString = "assets.hallIcon.groupPurchaseIcon";
               break;
            case HallIconType.LUCKSTONE:
               iconString = "assets.hallIcon.luckStoneIcon";
               break;
            case HallIconType.MYSTERIOUROULETTE:
               iconString = "assets.hallIcon.mysteriousRouletteIcon";
               break;
            case HallIconType.SYAH:
               iconString = "assets.hallIcon.syahIcon";
               break;
            case HallIconType.TREASUREHUNTING:
               iconString = "assets.hallIcon.treasureHuntingIcon";
               break;
            case HallIconType.OLDPLAYERREGRESS:
               iconString = "assets.hallIcon.oldPlayerRegressIcon";
               break;
            case HallIconType.LIMITACTIVITY:
               iconString = "assets.hallIcon.limitActivityIcon";
               break;
            case HallIconType.LIGHTROAD:
               iconString = "assets.hallIcon.lightRoadIcon";
               break;
            case HallIconType.SEVENDAYTARGET:
               iconString = "assets.hallIcon.sevenDayTargetIcon";
               break;
            case HallIconType.GODSROADS:
               iconString = "assets.hallIcon.godsRoadsIcon";
               break;
            case HallIconType.ENTERTAINMENT:
               iconString = "assets.hallIcon.entertainmentIcon";
               break;
            case HallIconType.SALESHOP:
               iconString = "assets.hallIcon.saleShopIcon";
               break;
            case HallIconType.KINGDIVISION:
               iconString = "assets.hallIcon.kingDivisionIcon";
               break;
            case HallIconType.CHICKACTIVATION:
               iconString = "assets.hallIcon.chickActivationIcon";
               break;
            case HallIconType.DDPLAY:
               iconString = "assets.hallIcon.DDPlayIcon";
               break;
            case HallIconType.BOGUADVENTURE:
               iconString = "assets.hallIcon.boguAdventureIcon";
               break;
            case HallIconType.WITCHBLESSING:
               iconString = "assets.hallIcon.witchBlessingIcon";
               break;
            case HallIconType.TREASUREPUZZLE:
               iconString = "assets.hallIcon.treasurePuzzleIcon";
               break;
            case HallIconType.HALLOWEEN:
               iconString = "assets.hallIcon.halloweenIcon";
               break;
            case HallIconType.WORSHIPTHEMOON:
               iconString = "assets.hallIcon.worshipTheMoon";
               break;
            case HallIconType.FOODACTIVITY:
               iconString = "asset.hallIcon.FoodActivity";
               break;
            case HallIconType.RESCUE:
               iconString = "assets.hallIcon.rescue";
               break;
            case HallIconType.CATCHINSECT:
               iconString = "assets.hallIcon.catchInsect";
               break;
            case HallIconType.MAGPIEBRIDGE:
               iconString = "assets.hallIcon.magpiebridge";
               break;
            case HallIconType.CLOUDBUYLOTTERY:
               iconString = "assets.hallIcon.cloudbuylotteryIcon";
               break;
            case HallIconType.TREASURELOST:
               iconString = "assets.hallIcon.treasureLostIcon";
               break;
            case HallIconType.NEWYEARRICE:
               iconString = "assets.hallIcon.newYearRiceIcon";
               break;
            case HallIconType.ZODIAC:
               iconString = "assets.hallIcon.zodiacIcon";
               break;
            case HallIconType.HORSERACE:
               iconString = "assets.hallIcon.horseRace";
         }
         return new HallIcon(iconString,$iconInfo);
      }
      
      public function getIconByType($hallType:int, $iconType:String) : DisplayObject
      {
         if($hallType == HallIcon.WONDERFULPLAY && Boolean(this._wonderFulPlay))
         {
            return this._wonderFulPlay.getIconByType($iconType);
         }
         if($hallType == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            return this._activity.getIconByType($iconType);
         }
         return null;
      }
      
      private function topIndex() : void
      {
         if(Boolean(this.parent) && this.parent.numChildren > 1)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      private function checkNoneActivity($count:int) : void
      {
         if($count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.NoneActivity"));
         }
      }
      
      public function __checkHallIconExperienceOpenHandler(evt:HallIconEvent) : void
      {
         this.updateRightIconTaskArrow();
      }
      
      private function updateRightIconTaskArrow() : void
      {
         var step:int = 0;
         var posId:int = 0;
         var cacheRightIconTask:Object = HallIconManager.instance.model.cacheRightIconTask;
         if(cacheRightIconTask && !cacheRightIconTask.isCompleted && SharedManager.Instance.halliconExperienceStep < 2)
         {
            step = SharedManager.Instance.halliconExperienceStep;
            posId = 1;
            if(this._iconBox.numChildren == 3)
            {
               posId = 2;
            }
            else if(this._iconBox.numChildren == 4)
            {
               posId = 3;
            }
            else if(this._iconBox.numChildren == 5)
            {
               posId = 4;
            }
            if(step == 1)
            {
               posId += 1;
            }
            NewHandContainer.Instance.showArrow(ArrowType.HALLICON_EXPERIENCE,-90,"hallIcon.hallIconExperiencePos" + posId,"assets.hallIcon.experienceClickTxt","hallIcon.hallIconExperienceTxt" + posId,this._showArrowSp,0,true);
         }
         else if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
      }
      
      private function checkRightIconTaskClickHandler($halltype:int) : void
      {
         if(!HallIconManager.instance.model.cacheRightIconTask)
         {
            return;
         }
         if($halltype == HallIcon.WONDERFULPLAY && SharedManager.Instance.halliconExperienceStep == 0)
         {
            SharedManager.Instance.halliconExperienceStep = 1;
            this.updateRightIconTaskArrow();
            SharedManager.Instance.save();
         }
         else if($halltype == HallIcon.ACTIVITY && SharedManager.Instance.halliconExperienceStep == 1)
         {
            SharedManager.Instance.halliconExperienceStep = 2;
            this.updateRightIconTaskArrow();
            TaskManager.instance.checkQuest(TaskManager.HALLICON_TASKTYPE,1,0);
            SharedManager.Instance.halliconExperienceStep = 0;
            SharedManager.Instance.save();
         }
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.removeEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
         FirstRechargeManger.Instance.removeEventListener(FirstRechargeManger.REMOVEFIRSTRECHARGEICON,this.__removeIcon);
         FirstRechargeManger.Instance.removeEventListener(FirstRechargeManger.ADDFIRSTRECHARGEICON,this.__addIcon);
      }
      
      private function removeWonderfulPlayIcon() : void
      {
         if(Boolean(this._wonderFulPlay))
         {
            this._wonderFulPlay.removeEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
            ObjectUtils.disposeObject(this._wonderFulPlay);
            this._wonderFulPlay = null;
         }
      }
      
      private function removeEveryDayActivityIcon() : void
      {
         if(Boolean(this._everyDayActivityIcon))
         {
            this._everyDayActivityIcon.stop();
            this._everyDayActivityIcon.removeEventListener(MouseEvent.CLICK,this.__everyDayActivityIconClickHandler);
            ObjectUtils.disposeObject(this._everyDayActivityIcon);
            this._everyDayActivityIcon = null;
         }
      }
      
      private function removeWantstrongIcon() : void
      {
         if(Boolean(this._wantstrongIcon))
         {
            this._wantstrongIcon.stop();
            this._wantstrongIcon.removeEventListener(MouseEvent.CLICK,this.__wantstrongIconClickHandler);
            ObjectUtils.disposeObject(this._wantstrongIcon);
            this._wantstrongIcon = null;
         }
      }
      
      private function removeFirstRechargeIcon() : void
      {
         if(Boolean(this._firstRechargeIcon))
         {
            this._firstRechargeIcon.stop();
            this._firstRechargeIcon.removeEventListener(MouseEvent.CLICK,this.__firstRechargeIconClickHandler);
            ObjectUtils.disposeObject(this._firstRechargeIcon);
            this._firstRechargeIcon = null;
         }
      }
      
      private function removeActivityIcon() : void
      {
         if(Boolean(this._activity))
         {
            this._activity.removeEventListener(MouseEvent.CLICK,this.__activityClickHandler);
            ObjectUtils.disposeObject(this._activity);
            this._activity = null;
         }
      }
      
      private function removeBossBox() : void
      {
         if(Boolean(this._boxButton))
         {
            ObjectUtils.disposeAllChildren(this._boxButton);
            ObjectUtils.disposeObject(this._boxButton);
            this._boxButton = null;
         }
      }
      
      private function removeFoodBox() : void
      {
         if(Boolean(this._foodButton))
         {
            FoodActivityManager.Instance.stopTime();
            ObjectUtils.disposeAllChildren(this._foodButton);
            ObjectUtils.disposeObject(this._foodButton);
            this._foodButton = null;
            FoodActivityManager.Instance.deleteBtn();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeWonderfulPlayIcon();
         this.removeEveryDayActivityIcon();
         this.removeActivityIcon();
         this.removeWantstrongIcon();
         this.removeFirstRechargeIcon();
         this.removeBossBox();
         this.removeFoodBox();
         if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
         if(Boolean(this._showArrowSp))
         {
            ObjectUtils.disposeAllChildren(this._showArrowSp);
            ObjectUtils.disposeObject(this._showArrowSp);
            this._showArrowSp = null;
         }
         if(Boolean(this._iconBox))
         {
            ObjectUtils.disposeAllChildren(this._iconBox);
            ObjectUtils.disposeObject(this._iconBox);
            this._iconBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

