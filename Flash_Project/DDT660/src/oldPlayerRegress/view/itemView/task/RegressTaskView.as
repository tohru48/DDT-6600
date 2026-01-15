package oldPlayerRegress.view.itemView.task
{
   import bagAndInfo.BagAndInfoManager;
   import battleGroud.BattleGroudManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddtActivityIcon.ActivitStateEvent;
   import ddtActivityIcon.DdtActivityIconManager;
   import fightLib.LessonType;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import labyrinth.LabyrinthManager;
   import oldPlayerRegress.view.RegressView;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class RegressTaskView extends Frame
   {
      
      private var _taskInfo:QuestInfo;
      
      private var _taskIdArray:Array;
      
      private var _funcArray:Array;
      
      private var _gotoFunc:Function;
      
      private var _isBattleOpen:Boolean;
      
      private var _bottomBtnBg:ScaleBitmapImage;
      
      private var _getAwardBtn:BaseButton;
      
      private var _gotoBtn:BaseButton;
      
      private var _questBtnShine:IEffect;
      
      private var _lastCreatTime:int;
      
      private var _bossState:int = 0;
      
      public function RegressTaskView()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._isBattleOpen = false;
         this._funcArray = new Array(this.notGo,this.gotoHall,this.gotoDungeon,this.gotoBagAndInfo,this.gotoPetView,this.gotoLabyrinth,this.gotoBattle,this.gotoBuried,this.gotoConsortiria,this.gotoTrain);
         this._taskIdArray = new Array([1519,1520,1528],[1524,1525],[1526,1527],[1521],[1523],[1517,1518],[1515],[1522],[1516],[1529,1530]);
         SocketManager.Instance.out.sendConsortiaBossInfo(1);
      }
      
      private function initView() : void
      {
         this._bottomBtnBg = ComponentFactory.Instance.creatComponentByStylename("regress.bottomBgImg");
         this.getAwardBtn = ComponentFactory.Instance.creat("regress.getAward");
         this.gotoBtn = ComponentFactory.Instance.creat("regress.goto");
         this.gotoBtn.visible = false;
         var shineData:Object = new Object();
         shineData[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._questBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.getAwardBtn,shineData);
         this._questBtnShine.stop();
         addChild(this._bottomBtnBg);
         addChild(this.getAwardBtn);
         addChild(this.gotoBtn);
      }
      
      private function initEvent() : void
      {
         this.getAwardBtn.addEventListener(MouseEvent.CLICK,this.__onGetAwardBtnClick);
         this.gotoBtn.addEventListener(MouseEvent.CLICK,this.__onGotoBtnClick);
         DdtActivityIconManager.Instance.addEventListener(DdtActivityIconManager.START,this.battleOpenHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_OVER,this.battleOverHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.consortiaBossHandler);
      }
      
      protected function __onGetAwardBtnClick(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(!this.taskInfo)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         var questInfo:QuestInfo = this.taskInfo;
         var money:int = PlayerManager.Instance.Self.BandMoney;
         var limit:int = ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel);
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
      
      protected function __onGotoBtnClick(event:MouseEvent) : void
      {
         if(this._gotoFunc != null)
         {
            this._gotoFunc();
         }
      }
      
      private function finishQuest(pQuestInfo:QuestInfo) : void
      {
         if(Boolean(pQuestInfo) && !pQuestInfo.isCompleted)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
            return;
         }
         if(Boolean(pQuestInfo))
         {
            TaskManager.instance.sendQuestFinish(pQuestInfo.QuestID);
         }
      }
      
      private function __onResponse(pEvent:FrameEvent) : void
      {
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(pEvent.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.finishQuest(this.taskInfo);
         }
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      private function removeEvent() : void
      {
         this.getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__onGetAwardBtnClick);
         this.gotoBtn.removeEventListener(MouseEvent.CLICK,this.__onGotoBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.consortiaBossHandler);
         DdtActivityIconManager.Instance.removeEventListener(DdtActivityIconManager.START,this.battleOpenHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BATTLE_OVER,this.battleOverHandler);
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function setModuleInfo() : void
      {
         this._gotoFunc = this._funcArray[this.getFuncID(this.taskInfo._conditions[0].questID)];
         if(this.taskInfo.isCompleted)
         {
            this.getAwardBtn.visible = true;
            this.getAwardBtn.enable = true;
            this.gotoBtn.visible = false;
            this.questBtnShine.play();
         }
         else if(this._gotoFunc == this.notGo)
         {
            this.getAwardBtn.visible = true;
            this.getAwardBtn.enable = false;
            this.gotoBtn.visible = false;
            this.questBtnShine.stop();
         }
         else if(this._gotoFunc == this.gotoBattle)
         {
            this.getAwardBtn.visible = false;
            this.gotoBtn.visible = true;
            this.gotoBtn.enable = this._isBattleOpen;
            this.questBtnShine.stop();
         }
         else if(this._gotoFunc == this.gotoConsortiria)
         {
            this.getAwardBtn.visible = false;
            this.gotoBtn.visible = true;
            this.gotoBtn.enable = this._bossState == 1 ? true : false;
            this.questBtnShine.stop();
         }
         else
         {
            this.getAwardBtn.visible = false;
            this.gotoBtn.visible = true;
            this.gotoBtn.enable = true;
            this.questBtnShine.stop();
         }
      }
      
      private function getFuncID(taskId:int) : int
      {
         var id:int = 0;
         for(var i:int = 0; i < this._taskIdArray.length; i++)
         {
            if(this._taskIdArray[i].indexOf(taskId) != -1)
            {
               id = i;
               break;
            }
         }
         return id;
      }
      
      private function notGo() : void
      {
      }
      
      private function gotoHall() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,2))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",2));
            return;
         }
         StateManager.setState(StateType.ROOM_LIST);
         ComponentSetting.SEND_USELOG_ID(3);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
         }
      }
      
      private function gotoDungeon() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,8))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
            return;
         }
         if(!PlayerManager.Instance.checkEnterDungeon)
         {
            return;
         }
         StateManager.setState(StateType.DUNGEON_LIST);
         ComponentSetting.SEND_USELOG_ID(4);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
         }
      }
      
      private function gotoBagAndInfo() : void
      {
         BagAndInfoManager.Instance.showBagAndInfo();
         (parent.parent.parent as RegressView).dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      private function gotoPetView() : void
      {
         BagAndInfoManager.Instance.showBagAndInfo(3);
         (parent.parent.parent as RegressView).dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      private function gotoLabyrinth() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,30))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
            return;
         }
         LabyrinthManager.Instance.show();
         (parent.parent.parent as RegressView).dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      private function battleOpenHandler(event:ActivitStateEvent) : void
      {
         var arr:Array = event.data as Array;
         var id:int = int(arr[0]);
         if(id == 5)
         {
            this._isBattleOpen = true;
            if(this._gotoFunc == this.gotoBattle)
            {
               this.gotoBtn.enable = true;
            }
         }
      }
      
      private function battleOverHandler(event:CrazyTankSocketEvent) : void
      {
         this._isBattleOpen = false;
         if(this._gotoFunc == this.gotoBattle)
         {
            this.gotoBtn.enable = false;
         }
      }
      
      private function gotoBattle() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
            return;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            BattleGroudManager.Instance.addBattleSingleRoom();
         }
         (parent.parent.parent as RegressView).dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      private function gotoBuried() : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.enterBuried();
      }
      
      private function consortiaBossHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._bossState = pkg.readByte();
         if(this._gotoFunc == this.gotoConsortiria)
         {
            this.gotoBtn.enable = this._bossState == 1 ? true : false;
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.consortiaBossHandler);
      }
      
      private function gotoConsortiria() : void
      {
         if(this._bossState == 1)
         {
            if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,7))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",7));
               return;
            }
            StateManager.setState(StateType.CONSORTIA);
            ComponentSetting.SEND_USELOG_ID(5);
            if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
            {
               SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
            }
         }
      }
      
      private function gotoTrain() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.WeaponID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         TaskManager.instance.guideId = this.taskInfo.MapID;
         SocketManager.Instance.out.createUserGuide(5);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
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
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._gotoFunc = null;
         if(Boolean(this._bottomBtnBg))
         {
            this._bottomBtnBg.dispose();
            this._bottomBtnBg = null;
         }
         if(Boolean(this.getAwardBtn))
         {
            this.getAwardBtn.dispose();
            this.getAwardBtn = null;
         }
         if(Boolean(this.gotoBtn))
         {
            this.gotoBtn.dispose();
            this.gotoBtn = null;
         }
         if(Boolean(this.questBtnShine))
         {
            this.questBtnShine.dispose();
            this.questBtnShine = null;
         }
         if(Boolean(this.taskInfo))
         {
            this.taskInfo = null;
         }
         for(var i:int = 0; i < this._taskIdArray.length; i++)
         {
            this._taskIdArray[i] = null;
         }
         this._taskIdArray.length = 0;
         for(var j:int = 0; j < this._funcArray.length; j++)
         {
            this._funcArray[j] = null;
         }
         this._funcArray.length = 0;
      }
      
      public function get taskInfo() : QuestInfo
      {
         return this._taskInfo;
      }
      
      public function set taskInfo(value:QuestInfo) : void
      {
         this._taskInfo = value;
         if(Boolean(this.taskInfo))
         {
            this.setModuleInfo();
         }
      }
      
      public function get getAwardBtn() : BaseButton
      {
         return this._getAwardBtn;
      }
      
      public function set getAwardBtn(value:BaseButton) : void
      {
         this._getAwardBtn = value;
      }
      
      public function get questBtnShine() : IEffect
      {
         return this._questBtnShine;
      }
      
      public function set questBtnShine(value:IEffect) : void
      {
         this._questBtnShine = value;
      }
      
      public function get gotoBtn() : BaseButton
      {
         return this._gotoBtn;
      }
      
      public function set gotoBtn(value:BaseButton) : void
      {
         this._gotoBtn = value;
      }
   }
}

