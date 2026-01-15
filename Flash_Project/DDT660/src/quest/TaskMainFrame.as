package quest
{
   import baglocked.BaglockedManager;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.data.BeadLeadEvent;
   import collectionTask.CollectionTaskManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import fightLib.LessonType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import hall.tasktrack.HallTaskGuideManager;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import quest.cmd.Cmd_ThreeAndPower_PickUpAndEnable;
   import room.RoomManager;
   import roomList.pvpRoomList.RoomListBGView;
   import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import tryonSystem.TryonSystemController;
   
   public class TaskMainFrame extends Frame
   {
      
      public static const NORMAL:int = 1;
      
      public static const GUIDE:int = 2;
      
      public static const REWARD_UDERLINE:int = 417;
      
      public static const TASK_FRAME_HIDE:String = "taskFrameHide";
      
      private static const SPINEL:int = 11555;
      
      private static const TYPE_NUMBER:int = 7;
      
      private const CATEVIEW_X:int = 0;
      
      private const CATEVIEW_Y:int = 0;
      
      private const CATEVIEW_H:int = 50;
      
      private var cateViewArr:Array;
      
      private var infoView:QuestInfoPanelView;
      
      private var _questBtn:BaseButton;
      
      private var _goDungeonBtnShine:IEffect;
      
      private var _downClientShine:IEffect;
      
      private var _questBtnShine:IEffect;
      
      private var _buySpinelBtn:TextButton;
      
      private var _opened:Boolean = false;
      
      private var _currentCateView:QuestCateView;
      
      public var currentNewCateView:QuestCateView;
      
      private var leftPanel:ScrollPanel;
      
      private var leftPanelContent:VBox;
      
      private var _trusteeshipView:TrusteeshipView;
      
      private var _leftBGStyleNormal:MovieClip;
      
      private var _rightBGStyleNormal:MovieClip;
      
      private var _rightBottomBg:ScaleBitmapImage;
      
      private var _goDungeonBtn:BaseButton;
      
      private var _downloadClientBtn:TextButton;
      
      private var _gotoAcademy:BaseButton;
      
      private var _gotoGameBtn:BaseButton;
      
      private var _gotoTrainBtn:BaseButton;
      
      private var _gotoSceneBtn:SimpleBitmapButton;
      
      private var _mcTaskTarget:MovieClip;
      
      private var _timer:Timer;
      
      private var _style:int;
      
      private var _gotoGameTime:Number;
      
      private var _gotoTrainTime:Number;
      
      private var _quick:QuickBuyFrame;
      
      public function TaskMainFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      override public function get width() : Number
      {
         return _container.width;
      }
      
      override public function get height() : Number
      {
         return _container.height;
      }
      
      private function initView() : void
      {
         this.initStyleNormalBG();
         this.initStyleGuideBG();
         this.leftPanel = ComponentFactory.Instance.creatComponentByStylename("core.quest.questCateList");
         this.leftPanelContent = new VBox();
         this.leftPanelContent.spacing = 0;
         this.leftPanel.setView(this.leftPanelContent);
         addToContent(this.leftPanel);
         this.addQuestList();
         this.infoView = new QuestInfoPanelView();
         PositionUtils.setPos(this.infoView,"quest.infoPanelPos");
         addToContent(this.infoView);
         this._questBtn = ComponentFactory.Instance.creat("quest.getAwardBtn");
         addToContent(this._questBtn);
         this._goDungeonBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoDungeonBtn");
         addToContent(this._goDungeonBtn);
         this._goDungeonBtn.visible = false;
         this._gotoGameBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.goGameBtn");
         addToContent(this._gotoGameBtn);
         this._gotoGameBtn.visible = false;
         this._gotoTrainBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.goGameBtn");
         addToContent(this._gotoTrainBtn);
         this._gotoTrainBtn.visible = false;
         this._gotoSceneBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.goSceneBtn");
         addToContent(this._gotoSceneBtn);
         this._gotoSceneBtn.visible = false;
         this._gotoAcademy = ComponentFactory.Instance.creatComponentByStylename("core.quest.gotoAcademyBtn");
         addToContent(this._gotoAcademy);
         this._gotoAcademy.visible = false;
         this._downloadClientBtn = ComponentFactory.Instance.creat("core.quest.DownloadClientBtn");
         this._downloadClientBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.DownloadClient");
         addToContent(this._downloadClientBtn);
         this._downloadClientBtn.visible = false;
         this._buySpinelBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.buySpinelBtn");
         this._buySpinelBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.buySpinel");
         addToContent(this._buySpinelBtn);
         var shineData:Object = new Object();
         shineData[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._goDungeonBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._goDungeonBtn,shineData);
         this._goDungeonBtnShine.stop();
         this._downClientShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._downloadClientBtn,shineData);
         this._downClientShine.play();
         this._questBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._questBtn,shineData);
         this._questBtnShine.stop();
         this._buySpinelBtn.visible = false;
         this._questBtn.enable = false;
         titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.task");
         if(PathManager.solveTrusteeshipEnable())
         {
            this._trusteeshipView = ComponentFactory.Instance.creatCustomObject("quest.trusteeshipView");
            addToContent(this._trusteeshipView);
         }
         this.showStyle(NORMAL);
      }
      
      private function initStyleNormalBG() : void
      {
         this._leftBGStyleNormal = ComponentFactory.Instance.creat("asset.core.quest.leftBGStyle1");
         PositionUtils.setPos(this._leftBGStyleNormal,"quest.leftBgpos");
         this._rightBGStyleNormal = ComponentFactory.Instance.creat("asset.background.mapBg");
         PositionUtils.setPos(this._rightBGStyleNormal,"quest.rightBgpos");
         this._rightBottomBg = ComponentFactory.Instance.creatComponentByStylename("quest.rightBottomBgImg");
         addToContent(this._leftBGStyleNormal);
         addToContent(this._rightBGStyleNormal);
         addToContent(this._rightBottomBg);
      }
      
      private function clearVBox() : void
      {
         while(Boolean(this.leftPanelContent.numChildren))
         {
            this.leftPanelContent.removeChild(this.leftPanelContent.getChildAt(0));
         }
      }
      
      private function initStyleGuideBG() : void
      {
      }
      
      private function switchBG(style:int) : void
      {
      }
      
      private function addQuestList() : void
      {
         var cateView:QuestCateView = null;
         if(Boolean(this.cateViewArr))
         {
            return;
         }
         this.cateViewArr = new Array();
         for(var i:int = 0; i < TYPE_NUMBER; i++)
         {
            cateView = new QuestCateView(i,this.leftPanel);
            cateView.collapse();
            cateView.x = this.CATEVIEW_X;
            cateView.y = this.CATEVIEW_Y + this.CATEVIEW_H * i;
            cateView.addEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            cateView.addEventListener(Event.CHANGE,this.__onCateViewChange);
            cateView.addEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            this.cateViewArr.push(cateView);
            this.leftPanelContent.addChild(cateView);
         }
         this.leftPanel.invalidateViewport();
         this.__onEnbleChange(null);
      }
      
      private function __onEnbleChange(evt:Event) : void
      {
         var cateView:QuestCateView = null;
         var cates:int = 0;
         for(var i:int = 0; i < TYPE_NUMBER - 1; i++)
         {
            cateView = this.cateViewArr[i];
            if(cateView.visible)
            {
               cateView.y = this.CATEVIEW_Y + this.CATEVIEW_H * cates;
               cates++;
               this.leftPanelContent.addChild(cateView);
            }
         }
         this.leftPanel.setView(this.leftPanelContent);
         this.leftPanel.invalidateViewport();
      }
      
      private function addEvent() : void
      {
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         TaskManager.instance.addEventListener(TaskEvent.FINISH,this.__onTaskFinished);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.addEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._goDungeonBtn.addEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._gotoAcademy.addEventListener(MouseEvent.CLICK,this.__gotoAcademy);
         this._downloadClientBtn.addEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.addEventListener(MouseEvent.CLICK,this.__buySpinelClick);
         this._gotoGameBtn.addEventListener(MouseEvent.CLICK,this.__gotoGame);
         this._gotoTrainBtn.addEventListener(MouseEvent.CLICK,this.__gotoTrain);
         this._gotoSceneBtn.addEventListener(MouseEvent.CLICK,this.__gotoScene);
         PetBagController.instance().addEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
      }
      
      protected function __onTaskFinished(event:TaskEvent) : void
      {
         if(event.data.id == 367)
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_PET_BAG,50,"farmTrainer.openBagArrowPos","asset.farmTrainer.clickHere","farmTrainer.openBagTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER),10);
         }
         else if(event.data.id == 369 && StateManager.currentStateType == StateType.MAIN)
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.GRAIN_IN_FRAME,-150,"farmTrainer.openFarmArrowPos","asset.farmTrainer.grain1","farmTrainer.grainopenFarmTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER),10);
         }
         else if(event.data.id == 368 && StateManager.currentStateType == StateType.MAIN)
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.PLANT_IN_FRAME,-150,"farmTrainer.openFarmArrowPos","asset.farmTrainer.seed","farmTrainer.grainopenFarmTipPosout",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER),10);
         }
         else if(event.data.id == TaskManager.BEADLEAD_TASKTYPE1)
         {
            BeadLeadManager.Instance.dispatchEvent(new BeadLeadEvent(BeadLeadEvent.GETTASKISCOMPLETE));
         }
      }
      
      private function removeEvent() : void
      {
         TaskManager.instance.removeEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         TaskManager.instance.removeEventListener(TaskEvent.FINISH,this.__onTaskFinished);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.removeEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._goDungeonBtn.removeEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._gotoAcademy.removeEventListener(MouseEvent.CLICK,this.__gotoAcademy);
         this._downloadClientBtn.removeEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.removeEventListener(MouseEvent.CLICK,this.__buySpinelClick);
         this._gotoGameBtn.removeEventListener(MouseEvent.CLICK,this.__gotoGame);
         this._gotoTrainBtn.removeEventListener(MouseEvent.CLICK,this.__gotoTrain);
         this._gotoSceneBtn.removeEventListener(MouseEvent.CLICK,this.__gotoScene);
         PetBagController.instance().removeEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
      }
      
      private function __updatePetFarmGuilde(e:UpdatePetFarmGuildeEvent) : void
      {
         var j:int = 0;
         var jview:QuestCateView = null;
         var taskInfo:QuestInfo = null;
         PetBagController.instance().finishTask();
         var currentGuildeInfo:QuestInfo = e.data as QuestInfo;
         if(Boolean(currentGuildeInfo) && currentGuildeInfo.QuestID == PetFarmGuildeTaskType.PET_TASK3)
         {
            for(j = 0; j < this.cateViewArr.length; j++)
            {
               jview = this.cateViewArr[j] as QuestCateView;
               jview.initData();
               for each(taskInfo in jview.data.list)
               {
                  if(taskInfo == currentGuildeInfo)
                  {
                     jview.active();
                     this.jumpToQuest(currentGuildeInfo);
                     if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK3))
                     {
                     }
                     return;
                  }
               }
            }
         }
      }
      
      private function __onDataChanged(e:TaskEvent) : void
      {
         var i:uint = 0;
         this.infoView.visible = false;
         this._questBtn.enable = false;
         if(!this._currentCateView || this.currentNewCateView != null)
         {
            return;
         }
         if(this._currentCateView.active())
         {
            return;
         }
         i = 0;
         while(!(this.cateViewArr[i] as QuestCateView).active())
         {
            i++;
            if(i == 4)
            {
               return;
            }
         }
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               TaskManager.instance.switchVisible();
         }
      }
      
      public function jumpToQuest(info:QuestInfo) : void
      {
         var s:int = 0;
         if(info.MapID > 0 || info.Condition == 64)
         {
            this.showOtherBtn(info);
         }
         else
         {
            s = TaskManager.itemAwardSelected;
            this._goDungeonBtn.visible = false;
            this._goDungeonBtnShine.stop();
            this._gotoAcademy.visible = false;
            this._downloadClientBtn.visible = false;
            this._questBtn.visible = true;
            this._gotoGameBtn.visible = false;
            this._gotoTrainBtn.visible = false;
            this._gotoSceneBtn.visible = false;
            this._buySpinelBtn.visible = this.existRewardId(info,SPINEL);
            this.showStyle(NORMAL);
            this.hideGuide();
         }
         this.infoView.info = info;
         this.showQuestOverBtn(info.isCompleted);
         if(PathManager.solveTrusteeshipEnable())
         {
            this.showTrusteeshipView(info);
         }
      }
      
      private function showTrusteeshipView(info:QuestInfo) : void
      {
         if(info.TrusteeshipCost >= 0)
         {
            this._trusteeshipView.visible = true;
            this._trusteeshipView.refreshView(info,this.showQuestOverBtn,this._questBtn);
         }
         else
         {
            this._trusteeshipView.visible = false;
            this._trusteeshipView.clearSome();
         }
      }
      
      private function showQuestOverBtn(value:Boolean) : void
      {
         if(value)
         {
            this._questBtn.enable = true;
            this._questBtn.visible = true;
            this._questBtnShine.play();
            this._goDungeonBtn.visible = false;
            this._gotoAcademy.visible = false;
            this._gotoGameBtn.visible = false;
            this._gotoTrainBtn.visible = false;
            this._gotoSceneBtn.visible = false;
            if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && TaskManager.instance.getQuestByID(318).isCompleted && !TaskManager.instance.getQuestByID(318).isAchieved)
            {
               TrainStep.send(TrainStep.Step.TWO_TASK_PAGE);
               NewHandContainer.Instance.showArrow(ArrowType.GET_REWARD,0,"trainer.getTaskRewardArrowPos","asset.trainer.txtGetReward","trainer.getTaskRewardTipPos",this);
            }
         }
         else
         {
            this._questBtn.enable = false;
            this._questBtnShine.stop();
         }
      }
      
      private function showOtherBtn(info:QuestInfo) : void
      {
         if(info.Condition == 64)
         {
            this._gotoAcademy.visible = false;
            this._downloadClientBtn.visible = false;
            this._goDungeonBtn.visible = false;
            this._gotoGameBtn.visible = false;
            this._gotoTrainBtn.visible = false;
            this._gotoSceneBtn.visible = true;
         }
         else if(info.MapID > 0)
         {
            if(info.MapID == 2)
            {
               this._gotoAcademy.visible = true;
               this._goDungeonBtn.visible = false;
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
               this._gotoTrainBtn.visible = false;
            }
            else if(info.MapID == 3)
            {
               this._downloadClientBtn.visible = true;
               this._questBtn.visible = true;
               this._gotoAcademy.visible = false;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
               this._gotoTrainBtn.visible = false;
            }
            else if(info.MapID == 4)
            {
               this._downloadClientBtn.visible = false;
               this._gotoAcademy.visible = false;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = true;
               this._gotoTrainBtn.visible = false;
            }
            else if(info.MapID > 9 && info.MapID < 30)
            {
               this._downloadClientBtn.visible = false;
               this._gotoAcademy.visible = false;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
               this._gotoTrainBtn.visible = true;
            }
            else
            {
               this.showStyle(GUIDE);
               this._goDungeonBtn.visible = true;
               this._goDungeonBtn.enable = !info.isCompleted;
               if(this._goDungeonBtn.enable)
               {
                  this._goDungeonBtnShine.play();
                  HallTaskGuideManager.instance.showTaskFightItemArrow();
               }
               else
               {
                  this._goDungeonBtnShine.stop();
               }
               this._gotoAcademy.visible = false;
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
               this._gotoTrainBtn.visible = false;
            }
         }
         else
         {
            this._gotoAcademy.visible = false;
            this._downloadClientBtn.visible = false;
            this._goDungeonBtn.visible = false;
            this._gotoGameBtn.visible = false;
            this._gotoTrainBtn.visible = false;
            this._buySpinelBtn.visible = this.existRewardId(info,SPINEL);
         }
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && PlayerManager.Instance.Self.Grade < 2 && this._goDungeonBtn.visible && this._goDungeonBtn.enable)
         {
            this.showGuide();
         }
      }
      
      private function existRewardId(info:QuestInfo, itemID:int) : Boolean
      {
         var temp:QuestItemReward = null;
         for each(temp in info.itemRewards)
         {
            if(temp.itemID == itemID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showGuide() : void
      {
         this.hideGuide();
         if(!this._mcTaskTarget)
         {
            this._mcTaskTarget = ComponentFactory.Instance.creatCustomObject("trainer.mcTaskTarget");
         }
         if(!this._timer)
         {
            this._timer = new Timer(4000,1);
         }
         addChild(this._mcTaskTarget);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.start();
      }
      
      private function __timer(evt:TimerEvent) : void
      {
         this.resetTimer();
         removeChild(this._mcTaskTarget);
         NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT,0,"trainer.clickBeatArrowPos","asset.trainer.txtClickBeat","trainer.clickBeatTipPos",this);
      }
      
      private function resetTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this._timer.stop();
            this._timer.reset();
         }
      }
      
      private function hideGuide() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
         this.resetTimer();
         if(Boolean(this._mcTaskTarget) && Boolean(this._mcTaskTarget.parent))
         {
            removeChild(this._mcTaskTarget);
         }
      }
      
      private function showStyle(style:int) : void
      {
         if(this._style == style)
         {
            return;
         }
         this._style = style;
         for(var i:int = 0; i < this.cateViewArr.length; i++)
         {
            (this.cateViewArr[i] as QuestCateView).taskStyle = style;
         }
         this.switchBG(style);
      }
      
      private function __onCateViewChange(e:Event) : void
      {
         var view:QuestCateView = null;
         this.clearVBox();
         this.infoView.visible = false;
         var visibleItemNumber:int = 0;
         var _currentY:int = 42;
         for(var i:int = 0; i < this.cateViewArr.length; i++)
         {
            view = this.cateViewArr[i] as QuestCateView;
            if(view.visible)
            {
               visibleItemNumber++;
               view.y = _currentY;
               _currentY += view.contentHeight + 7;
               this.leftPanelContent.addChild(view);
            }
         }
         this.leftPanel.setView(this.leftPanelContent);
         this.leftPanel.invalidateViewport();
         if(visibleItemNumber == 0)
         {
            TaskManager.instance.MainFrame.dispose();
         }
      }
      
      private function __onTitleClicked(e:Event) : void
      {
         var view:QuestCateView = null;
         this.clearVBox();
         if(!parent || this.currentNewCateView != null)
         {
            return;
         }
         if(this._currentCateView != e.target as QuestCateView)
         {
         }
         this._currentCateView = e.target as QuestCateView;
         var _currentY:int = this.CATEVIEW_Y;
         for(var i:int = 0; i < this.cateViewArr.length; i++)
         {
            view = this.cateViewArr[i] as QuestCateView;
            if(view != this._currentCateView)
            {
               view.collapse();
            }
            if(view.visible)
            {
               view.y = _currentY;
               _currentY += view.contentHeight + 7;
               this.leftPanelContent.addChild(view);
            }
         }
         this.leftPanel.setView(this.leftPanelContent);
         this.leftPanel.invalidateViewport();
      }
      
      public function switchVisible() : void
      {
         if(Boolean(parent))
         {
            this.dispose();
         }
         else
         {
            this._show();
         }
      }
      
      private function _show() : void
      {
         if(this._opened == true)
         {
            this.dispose();
         }
         this._opened = true;
         MainToolBar.Instance.unReadTask = false;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function open() : void
      {
         if(!this._opened)
         {
            this._show();
            this.leftPanel.invalidateViewport();
         }
      }
      
      private function __onQuestBtnClicked(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(!this.infoView.info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var questInfo:QuestInfo = this.infoView.info;
         if(questInfo.RewardBindMoney != 0 && questInfo.RewardBindMoney + PlayerManager.Instance.Self.BandMoney > ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,false,true,1);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            this.finishQuest(questInfo);
         }
      }
      
      private function finishQuest(pQuestInfo:QuestInfo) : void
      {
         var items:Array = null;
         var temp:QuestItemReward = null;
         var info:InventoryItemInfo = null;
         if(Boolean(pQuestInfo) && !pQuestInfo.isCompleted)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
            this._currentCateView.active();
            return;
         }
         if(TaskManager.itemAwardSelected == -1)
         {
            items = [];
            for each(temp in pQuestInfo.itemRewards)
            {
               info = new InventoryItemInfo();
               info.TemplateID = temp.itemID;
               ItemManager.fill(info);
               info.ValidDate = temp.ValidateTime;
               info.TemplateID = temp.itemID;
               info.IsJudge = true;
               info.IsBinds = temp.isBind;
               info.AttackCompose = temp.AttackCompose;
               info.DefendCompose = temp.DefendCompose;
               info.AgilityCompose = temp.AgilityCompose;
               info.LuckCompose = temp.LuckCompose;
               info.StrengthenLevel = temp.StrengthenLevel;
               info.Count = temp.count[pQuestInfo.QuestLevel - 1];
               if(!(0 != info.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != info.NeedSex))
               {
                  if(temp.isOptional == 1)
                  {
                     items.push(info);
                  }
               }
            }
            TryonSystemController.Instance.show(items,this.chooseReward,this.cancelChoose);
            return;
         }
         if(Boolean(this.infoView.info))
         {
            TaskManager.instance.sendQuestFinish(this.infoView.info.QuestID);
            if(TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(318)) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(319)))
            {
               SocketManager.Instance.out.syncWeakStep(Step.ACHIVED_THREE_QUEST);
            }
            this.checkThreeAndPower();
            if(this.infoView.info.QuestID == 537)
            {
               TrainStep.send(TrainStep.Step.PASS_CLOTHES_TASK);
            }
            else if(this.infoView.info.QuestID == 320)
            {
               TrainStep.send(TrainStep.Step.LEVEL_FOUR);
            }
            else if(this.infoView.info.QuestID == 321)
            {
               TrainStep.send(TrainStep.Step.GET_GIFT);
            }
            else if(this.infoView.info.QuestID == 322)
            {
               TrainStep.send(TrainStep.Step.PLANE_TASK_COMPLETE);
            }
            else if(this.infoView.info.QuestID == 324)
            {
               TrainStep.send(TrainStep.Step.HARMTWO_TASK_COMPLETE);
            }
            else if(this.infoView.info.QuestID == 326)
            {
               TrainStep.send(TrainStep.Step.HARMALL_TASK_COMPLETE);
            }
         }
      }
      
      private function checkThreeAndPower() : void
      {
         if(Boolean(this.infoView) && Boolean(this.infoView.info))
         {
            new Cmd_ThreeAndPower_PickUpAndEnable().excute(this.infoView.info.QuestID);
         }
      }
      
      private function __onResponse(pEvent:FrameEvent) : void
      {
         var questInfo:QuestInfo = null;
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(pEvent.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            questInfo = this.infoView.info;
            this.finishQuest(questInfo);
         }
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         if(Sex)
         {
            return 1;
         }
         return 2;
      }
      
      private function chooseReward(item:ItemTemplateInfo) : void
      {
         SocketManager.Instance.out.sendQuestFinish(this.infoView.info.QuestID,item.TemplateID);
         TaskManager.itemAwardSelected = -1;
         this.checkThreeAndPower();
      }
      
      private function cancelChoose() : void
      {
         TaskManager.itemAwardSelected = -1;
      }
      
      private function __onGoDungeonClicked(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._goDungeonBtn.enable = false;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            this._goDungeonBtn.enable = true;
            return;
         }
         if(this.infoView.info.MapID > 0)
         {
            NewHandGuideManager.Instance.mapID = this.infoView.info.MapID;
            if(NewHandGuideManager.Instance.mapID == 112)
            {
               TrainStep.send(TrainStep.Step.CLICK_GOATTACK);
            }
            else if(NewHandGuideManager.Instance.mapID == 113)
            {
               TrainStep.send(TrainStep.Step.BEAT_BOGU);
            }
            else if(NewHandGuideManager.Instance.mapID == 114)
            {
               TrainStep.send(TrainStep.Step.BEAT_BABY3);
            }
            else if(NewHandGuideManager.Instance.mapID == 115)
            {
               TrainStep.send(TrainStep.Step.BEAT_BABY4);
            }
            else if(NewHandGuideManager.Instance.mapID == 116)
            {
               TrainStep.send(TrainStep.Step.BEAT_BABY5);
            }
            if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            setTimeout(SocketManager.Instance.out.createUserGuide,500);
            if(this.infoView.info.MapID == 111 || this.infoView.info.MapID == 112)
            {
               NoviceDataManager.instance.saveNoviceData(350,PathManager.userName(),PathManager.solveRequestPath());
            }
            else if(this.infoView.info.MapID == 113)
            {
               NoviceDataManager.instance.saveNoviceData(460,PathManager.userName(),PathManager.solveRequestPath());
            }
            else if(this.infoView.info.MapID == 114)
            {
               NoviceDataManager.instance.saveNoviceData(510,PathManager.userName(),PathManager.solveRequestPath());
            }
            else if(this.infoView.info.MapID == 115)
            {
               NoviceDataManager.instance.saveNoviceData(540,PathManager.userName(),PathManager.solveRequestPath());
            }
            else if(this.infoView.info.MapID == 116)
            {
               NoviceDataManager.instance.saveNoviceData(670,PathManager.userName(),PathManager.solveRequestPath());
            }
         }
      }
      
      private function __gotoGame(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var nowTime:Number = getTimer();
         if(nowTime < this._gotoGameTime + 1000)
         {
            return;
         }
         this._gotoGameTime = nowTime;
         this._gotoGameBtn.enable = false;
         StateManager.setState(StateType.ROOM_LIST);
         setTimeout(GameInSocketOut.sendCreateRoom,1000,RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],0,3);
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK3))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.JOIN_GAME);
         }
      }
      
      private function __gotoScene(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._gotoSceneBtn.enable = false;
         switch(this.infoView.info.Condition)
         {
            case 64:
               CollectionTaskManager.Instance.setUp();
         }
      }
      
      private function __gotoTrain(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var nowTime2:Number = getTimer();
         if(nowTime2 < this._gotoTrainTime + 1000)
         {
            return;
         }
         this._gotoTrainTime = nowTime2;
         this._gotoTrainBtn.enable = false;
         if(PlayerManager.Instance.Self.WeaponID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         TaskManager.instance.guideId = this.infoView.info.MapID;
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM)
         {
            StateManager.setState(StateType.ROOM_LIST);
         }
         setTimeout(this.__createUserGude,500);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
      }
      
      private function __createUserGude() : void
      {
         SocketManager.Instance.out.createUserGuide(5);
      }
      
      private function __gameStart(e:CrazyTankSocketEvent) : void
      {
         var _difficulty:int = 0;
         var _infoId:int = 0;
         var _sencondType:int = 0;
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         switch(TaskManager.instance.guideId)
         {
            case 10:
               _difficulty = FightLibInfo.EASY;
               _infoId = LessonType.Measure;
               break;
            case 11:
               _difficulty = FightLibInfo.NORMAL;
               _infoId = LessonType.Measure;
               break;
            case 12:
               _difficulty = FightLibInfo.DIFFICULT;
               _infoId = LessonType.Measure;
               break;
            case 13:
               _difficulty = FightLibInfo.EASY;
               _infoId = LessonType.Twenty;
               break;
            case 14:
               _difficulty = FightLibInfo.NORMAL;
               _infoId = LessonType.Twenty;
               break;
            case 15:
               _difficulty = FightLibInfo.DIFFICULT;
               _infoId = LessonType.Twenty;
               break;
            case 16:
               _difficulty = FightLibInfo.EASY;
               _infoId = LessonType.SixtyFive;
               break;
            case 17:
               _difficulty = FightLibInfo.NORMAL;
               _infoId = LessonType.SixtyFive;
               break;
            case 18:
               _difficulty = FightLibInfo.DIFFICULT;
               _infoId = LessonType.SixtyFive;
               break;
            case 19:
               _difficulty = FightLibInfo.EASY;
               _infoId = LessonType.HighThrow;
               break;
            case 20:
               _difficulty = FightLibInfo.NORMAL;
               _infoId = LessonType.HighThrow;
               break;
            case 21:
               _difficulty = FightLibInfo.DIFFICULT;
               _infoId = LessonType.HighThrow;
               break;
            case 22:
               _difficulty = FightLibInfo.EASY;
               _infoId = LessonType.HighGap;
               break;
            case 23:
               _difficulty = FightLibInfo.NORMAL;
               _infoId = LessonType.HighGap;
               break;
            case 24:
               _difficulty = FightLibInfo.DIFFICULT;
               _infoId = LessonType.HighGap;
         }
         _sencondType = this.getSecondType(_infoId,_difficulty);
         GameInSocketOut.sendGameRoomSetUp(_infoId,5,false,"","",_sencondType,_difficulty,0,false,0);
         FightLibManager.Instance.currentInfoID = _infoId;
         FightLibManager.Instance.currentInfo.difficulty = _difficulty;
         StateManager.setState(StateType.FIGHT_LIB);
      }
      
      private function getSecondType(infoId:int, difficulty:int) : int
      {
         var secondType:int = 0;
         if(infoId == LessonType.Twenty || infoId == LessonType.SixtyFive || infoId == LessonType.HighThrow)
         {
            if(difficulty == FightLibInfo.EASY)
            {
               secondType = 6;
            }
            else if(difficulty == FightLibInfo.NORMAL)
            {
               secondType = 5;
            }
            else
            {
               secondType = 3;
            }
         }
         else if(infoId == LessonType.HighGap)
         {
            if(difficulty == FightLibInfo.EASY)
            {
               secondType = 5;
            }
            else if(difficulty == FightLibInfo.NORMAL)
            {
               secondType = 4;
            }
            else
            {
               secondType = 3;
            }
         }
         return secondType;
      }
      
      private function __gotoAcademy(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyManager.Instance.gotoAcademyState();
      }
      
      private function __downloadClient(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      private function __buySpinelClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var shopItemInfo:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(SPINEL);
         this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quick.itemID = SPINEL;
         this._quick.buyFrom = 7;
         this._quick.maxLimit = 3;
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function gotoQuest(info:QuestInfo) : void
      {
         var jview:QuestCateView = null;
         var taskInfo:QuestInfo = null;
         var item:TaskPannelStripView = null;
         for(var j:int = 0; j < this.cateViewArr.length; j++)
         {
            jview = this.cateViewArr[j] as QuestCateView;
            for each(taskInfo in jview.data.list)
            {
               if(taskInfo.QuestID == info.QuestID)
               {
                  jview.active();
                  for each(item in jview.itemArr)
                  {
                     if(item.info.id == info.QuestID)
                     {
                        item.active();
                     }
                  }
                  return;
               }
            }
         }
      }
      
      override protected function __onAddToStage(e:Event) : void
      {
         var jview:QuestCateView = null;
         var view1:QuestCateView = null;
         super.__onAddToStage(e);
         var cate:int = -1;
         for(var j:int = 0; j < this.cateViewArr.length; j++)
         {
            jview = this.cateViewArr[j] as QuestCateView;
            jview.initData();
         }
         for(var k:int = 0; k < this.cateViewArr.length; k++)
         {
            view1 = this.cateViewArr[k] as QuestCateView;
            if(view1.questType != 4)
            {
               view1.initData();
               if(view1.data.haveCompleted)
               {
                  view1.active();
                  this.leftPanel.invalidateViewport();
                  return;
               }
               if(view1.length > 0 && cate < 0)
               {
                  cate = k;
                  view1.active();
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         var cateView:QuestCateView = null;
         this.hideGuide();
         this.removeEvent();
         this._currentCateView = null;
         this.currentNewCateView = null;
         while(Boolean(cateView = this.cateViewArr.pop()))
         {
            cateView.removeEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            cateView.removeEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            cateView.removeEventListener(Event.CHANGE,this.__onCateViewChange);
            cateView.dispose();
            cateView = null;
         }
         ObjectUtils.disposeObject(this.leftPanelContent);
         this.leftPanelContent = null;
         ObjectUtils.disposeObject(this.leftPanel);
         this.leftPanel = null;
         if(Boolean(this._quick) && this._quick.canDispose)
         {
            this._quick.dispose();
         }
         this._quick = null;
         if(Boolean(this.infoView))
         {
            this.infoView.dispose();
         }
         this.infoView = null;
         if(Boolean(this._questBtn))
         {
            ObjectUtils.disposeObject(this._questBtn);
         }
         this._questBtn = null;
         if(Boolean(this._goDungeonBtnShine))
         {
            ObjectUtils.disposeObject(this._goDungeonBtnShine);
         }
         this._goDungeonBtnShine = null;
         if(Boolean(this._downClientShine))
         {
            ObjectUtils.disposeObject(this._downClientShine);
         }
         this._downClientShine = null;
         if(Boolean(this._questBtnShine))
         {
            ObjectUtils.disposeObject(this._questBtnShine);
         }
         this._questBtnShine = null;
         if(Boolean(this._mcTaskTarget))
         {
            ObjectUtils.disposeObject(this._mcTaskTarget);
         }
         this._mcTaskTarget = null;
         if(Boolean(this._rightBottomBg))
         {
            ObjectUtils.disposeObject(this._rightBottomBg);
         }
         this._rightBottomBg = null;
         if(Boolean(this._leftBGStyleNormal))
         {
            ObjectUtils.disposeObject(this._leftBGStyleNormal);
         }
         this._leftBGStyleNormal = null;
         if(Boolean(this._rightBGStyleNormal))
         {
            ObjectUtils.disposeObject(this._rightBGStyleNormal);
         }
         this._rightBGStyleNormal = null;
         if(Boolean(this._goDungeonBtn))
         {
            ObjectUtils.disposeObject(this._goDungeonBtn);
         }
         this._goDungeonBtn = null;
         if(Boolean(this._downloadClientBtn))
         {
            ObjectUtils.disposeObject(this._downloadClientBtn);
         }
         this._downloadClientBtn = null;
         if(Boolean(this._gotoAcademy))
         {
            ObjectUtils.disposeObject(this._gotoAcademy);
         }
         this._gotoAcademy = null;
         if(Boolean(this._gotoTrainBtn))
         {
            ObjectUtils.disposeObject(this._gotoTrainBtn);
         }
         this._gotoTrainBtn = null;
         if(Boolean(this._gotoSceneBtn))
         {
            ObjectUtils.disposeObject(this._gotoSceneBtn);
         }
         this._gotoSceneBtn = null;
         if(Boolean(this._gotoGameBtn))
         {
            ObjectUtils.disposeObject(this._gotoGameBtn);
            this._gotoGameBtn = null;
         }
         ObjectUtils.disposeObject(this._trusteeshipView);
         this._trusteeshipView = null;
         this._opened = false;
         this._timer = null;
         TaskManager.instance.selectedQuest = null;
         TaskManager.instance.isShow = false;
         TaskManager.instance.clearNewQuest();
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_REWARD);
         HallTaskGuideManager.instance.clearTaskFightItemArrow();
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.JOIN_GAME);
         MainToolBar.Instance.tipTask();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(TaskMainFrame.TASK_FRAME_HIDE));
      }
   }
}

