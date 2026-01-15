package ddtBuried.views
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.bagStore.BagStore;
   import ddt.data.quest.QuestCategory;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import farm.FarmModelController;
   import flash.events.MouseEvent;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class TaskTrackView extends Frame
   {
      
      private const LIST_SPACE:int = 5;
      
      private const DAY_TASK_TYPE:int = 5;
      
      private var _taskBg:ScaleFrameImage;
      
      private var _taskBackBtn:SimpleBitmapButton;
      
      private var _taskBackPopBtn:SimpleBitmapButton;
      
      private var _buriedFlag:Boolean = true;
      
      private var _listView:ScrollPanel;
      
      private var _itemList:VBox;
      
      private var _idArray:Array;
      
      private var _funcArray:Array;
      
      private var _data:QuestCategory;
      
      public function TaskTrackView()
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
         this._data = TaskManager.instance.getAvailableQuests(this.DAY_TASK_TYPE);
         this._funcArray = new Array(this.gotoMainView,this.gotoShop,this.gotoHall,this.gotoDungeon,this.gotoStore,this.gotoFarm);
         this._idArray = new Array([30],[10,54],[22,23,24,26,28,34,36,37],[1,2,3,7,8,13,14,15,21,41],[9,11,19],[51]);
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var taskInfo:TaskTrackInfoView = null;
         this._taskBg = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskTrackbg");
         addChild(this._taskBg);
         this._taskBackBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskBuried");
         addChild(this._taskBackBtn);
         this._taskBackPopBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskBuriedPopBtn");
         addChild(this._taskBackPopBtn);
         this._itemList = new VBox();
         this._itemList.spacing = this.LIST_SPACE;
         this._listView = ComponentFactory.Instance.creat("ddtburied.TaskItemList");
         this._listView.setView(this._itemList);
         this._listView.vScrollProxy = ScrollPanel.AUTO;
         this._listView.hScrollProxy = ScrollPanel.OFF;
         PositionUtils.setPos(this._listView,"ddtburied.taskInfo.pos");
         addChild(this._listView);
         if(this._data.list.length > 0)
         {
            this._taskBackPopBtn.visible = false;
            for(i = 0; i < this._data.list.length; i++)
            {
               taskInfo = new TaskTrackInfoView();
               taskInfo.taskTitle.text = ">>" + this._data.list[i].Title;
               taskInfo.taskInfo.htmlText = "<u>" + this._data.list[i].conditionDescription[0] + "</u>";
               taskInfo.func = this._funcArray[this.getFuncID(this._data.list[i].Condition)];
               taskInfo.taskBtnRect();
               this._itemList.addChild(taskInfo);
            }
         }
         else
         {
            this._taskBackBtn.visible = false;
            this.__onBackClick(null);
         }
         this._listView.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         this._taskBackBtn.addEventListener(MouseEvent.CLICK,this.__onBackClick);
         this._taskBackPopBtn.addEventListener(MouseEvent.CLICK,this.__onBackClick);
      }
      
      public function refreshTask() : void
      {
         var taskInfo:TaskTrackInfoView = null;
         this._data = TaskManager.instance.getAvailableQuests(this.DAY_TASK_TYPE);
         for(var i:int = 0; i < this._data.list.length; i++)
         {
            taskInfo = new TaskTrackInfoView();
            taskInfo.taskTitle.text = ">>" + this._data.list[i].Title;
            taskInfo.taskInfo.htmlText = "<u>" + this._data.list[i].conditionDescription[0] + "</u>";
            taskInfo.func = this._funcArray[this.getFuncID(this._data.list[i].Condition)];
            taskInfo.taskBtnRect();
            this._itemList.addChild(taskInfo);
         }
      }
      
      protected function __onBackClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._buriedFlag)
         {
            TweenLite.to(this,0.5,{"x":1000});
         }
         else
         {
            TweenLite.to(this,0.5,{"x":803});
         }
         this._taskBackPopBtn.visible = this._buriedFlag;
         this._taskBackBtn.visible = !this._buriedFlag;
         this._buriedFlag = !this._buriedFlag;
      }
      
      public function __onBackRollout(event:MouseEvent) : void
      {
         event.stopPropagation();
      }
      
      private function getFuncID(conditionId:int) : int
      {
         var id:int = 0;
         for(var i:int = 0; i < this._idArray.length; i++)
         {
            if(this._idArray[i].indexOf(conditionId) != -1)
            {
               id = i;
               break;
            }
         }
         return id;
      }
      
      private function gotoShop() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.SHOP_OPEN,3))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
            return;
         }
         StateManager.setState(StateType.SHOP);
         ComponentSetting.SEND_USELOG_ID(1);
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
      
      private function gotoStore() : void
      {
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            if(PlayerManager.Instance.Self.Grade < 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
         }
         BagStore.instance.show(BagStore.BAG_STORE);
         ComponentSetting.SEND_USELOG_ID(2);
      }
      
      private function gotoFarm() : void
      {
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      private function gotoMainView() : void
      {
         BuriedManager.Instance.dispose();
         SocketManager.Instance.out.outCard();
      }
      
      private function removeEvent() : void
      {
         this._taskBackBtn.removeEventListener(MouseEvent.CLICK,this.__onBackClick);
         this._taskBackPopBtn.removeEventListener(MouseEvent.CLICK,this.__onBackClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._taskBg))
         {
            this._taskBg.dispose();
            this._taskBg = null;
         }
         if(Boolean(this._taskBackBtn))
         {
            this._taskBackBtn.dispose();
            this._taskBackBtn = null;
         }
      }
   }
}

