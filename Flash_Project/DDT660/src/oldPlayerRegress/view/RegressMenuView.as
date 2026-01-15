package oldPlayerRegress.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.UIModuleTypes;
   import ddt.data.quest.QuestCategory;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import oldPlayerRegress.event.RegressEvent;
   import oldPlayerRegress.view.itemView.AreaView;
   import oldPlayerRegress.view.itemView.TaskItemView;
   import oldPlayerRegress.view.itemView.WelcomeView;
   import oldPlayerRegress.view.itemView.call.CallView;
   import oldPlayerRegress.view.itemView.packs.PacksView;
   import oldPlayerRegress.view.itemView.task.RegressTaskView;
   import quest.QuestInfoPanelView;
   
   public class RegressMenuView extends Frame
   {
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private const LIST_SPACE:int = -5;
      
      private const TASK_TYPE:int = 4;
      
      private var _bgArray:Array;
      
      private var _menuItemBgSelect:ScaleFrameImage;
      
      private var _textArray:Array;
      
      private var _textNameArray:Array;
      
      private var _btnArray:Array;
      
      private var _viewArray:Array;
      
      private var _taskInfoView:QuestInfoPanelView;
      
      private var _itemList:VBox;
      
      private var _listView:ScrollPanel;
      
      private var _taskData:QuestCategory;
      
      private var _expandBg:DisplayObject;
      
      private var _taskMenuItem:Vector.<TaskItemView>;
      
      public function RegressMenuView()
      {
         super();
         this.loadTaskUI();
      }
      
      private function loadTaskUI() : void
      {
         if(loadComplete)
         {
            this._init();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
         }
      }
      
      private function __onTaskLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleSmallLoading.Instance.hide();
      }
      
      private function __onTaskLoadComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this._init();
         }
      }
      
      private function _init() : void
      {
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._bgArray = new Array(new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage());
         this._textArray = new Array(new FilterFrameText(),new FilterFrameText(),new FilterFrameText(),new FilterFrameText(),new FilterFrameText());
         this._textNameArray = new Array("ddt.regress.menuView.Welcome","ddt.regress.menuView.Packs","ddt.regress.menuView.Area","ddt.regress.menuView.Call","ddt.regress.menuView.Task");
         this._btnArray = new Array(new BaseButton(),new BaseButton(),new BaseButton(),new BaseButton(),new BaseButton());
         this._viewArray = new Array(new WelcomeView(),new PacksView(),new AreaView(),new CallView(),new RegressTaskView());
         this._taskData = TaskManager.instance.getAvailableQuests(this.TASK_TYPE);
         this._taskMenuItem = new Vector.<TaskItemView>();
      }
      
      private function initView() : void
      {
         this.setItemView(this._bgArray,"regress.ActivityCellBgUnSelected");
         this._menuItemBgSelect = ComponentFactory.Instance.creatComponentByStylename("regress.ActivityCellBgSelected");
         addChild(this._menuItemBgSelect);
         for(var j:int = 0; j < this._textArray.length; j++)
         {
            this._textArray[j] = ComponentFactory.Instance.creatComponentByStylename("regress.view.menuItemName.Text");
            this._textArray[j].text = LanguageMgr.GetTranslation(this._textNameArray[j]);
            if(j > 0)
            {
               this._textArray[j].y = this._textArray[j - 1].y + this._textArray[j].height + 7;
            }
            addChild(this._textArray[j]);
         }
         this.setItemView(this._btnArray,"regress.button");
         if(this._taskData.list.length > 0)
         {
            this.addTaskListView();
         }
         else
         {
            this._bgArray[4].visible = false;
            this._btnArray[4].visible = false;
            this._textArray[4].visible = false;
         }
         this._taskInfoView = new QuestInfoPanelView();
         PositionUtils.setPos(this._taskInfoView,"regress.task.view.pos");
         addChild(this._taskInfoView);
         for(var k:int = 0; k < this._viewArray.length; k++)
         {
            addChild(this._viewArray[k]);
            if(k > 0)
            {
               this._viewArray[k].visible = false;
            }
         }
      }
      
      private function addTaskListView() : void
      {
         this._expandBg = ComponentFactory.Instance.creatCustomObject("regress.taskExpandBg");
         addChild(this._expandBg);
         this._itemList = new VBox();
         this._itemList.spacing = this.LIST_SPACE;
         this._listView = ComponentFactory.Instance.creat("regress.taskItemList");
         this._listView.setView(this._itemList);
         this._listView.vScrollProxy = ScrollPanel.AUTO;
         this._listView.hScrollProxy = ScrollPanel.OFF;
         addChild(this._listView);
         this.addListItem();
      }
      
      private function addListItem() : void
      {
         var taskItem:TaskItemView = null;
         for(var i:int = 0; i < this._taskData.list.length; i++)
         {
            taskItem = new TaskItemView(this.taskMenuItemClick);
            taskItem.titleField.text = this._taskData.list[i].Title;
            taskItem.clickID = i;
            if(Boolean(this._taskData.list[i].isCompleted))
            {
               taskItem.bmpOK.visible = true;
            }
            taskItem.width = taskItem.displayWidth;
            taskItem.height = taskItem.displayHeight;
            this._itemList.addChild(taskItem);
            this._taskMenuItem.push(taskItem);
         }
         this._itemList.arrange();
         this._listView.invalidateViewport();
      }
      
      protected function __onUpdateTaskMenuItem(event:Event) : void
      {
         this._taskData = TaskManager.instance.getAvailableQuests(this.TASK_TYPE);
         for(var i:int = 0; i < this._taskMenuItem.length; i++)
         {
            this._itemList.removeChild(this._taskMenuItem[i]);
         }
         this._taskMenuItem.length = 0;
         if(this._taskData.list.length > 0)
         {
            this.addListItem();
            this.taskMenuItemClick(0);
         }
         else
         {
            this._expandBg.visible = false;
            this._listView.visible = false;
            this._bgArray[4].visible = false;
            this._btnArray[4].visible = false;
            this._textArray[4].visible = false;
            this.menuItemClick(0);
         }
      }
      
      private function taskMenuItemClick(clickID:int) : void
      {
         SoundManager.instance.playButtonSound();
         this._menuItemBgSelect.y = this._btnArray[4].y - 2;
         this.setViewVisible();
         this.setTaskMenuBgFrame();
         if(this._taskMenuItem.length == 0)
         {
            return;
         }
         this._taskMenuItem[clickID].itemBg.setFrame(2);
         this._taskInfoView.visible = true;
         this._taskInfoView.regressFlag = true;
         this._taskInfoView.info = this._taskData.list[clickID];
         this._viewArray[4].visible = true;
         this._viewArray[4].taskInfo = this._taskData.list[clickID];
         this._viewArray[4].show();
      }
      
      private function setTaskMenuBgFrame() : void
      {
         for(var i:int = 0; i < this._taskMenuItem.length; i++)
         {
            this._taskMenuItem[i].itemBg.setFrame(1);
         }
      }
      
      private function setItemView(array:Array, styleName:String) : void
      {
         for(var i:int = 0; i < array.length; i++)
         {
            array[i] = ComponentFactory.Instance.creatComponentByStylename(styleName);
            if(i > 0)
            {
               array[i].y = array[i - 1].y + array[i].height + 4;
            }
            addChild(array[i]);
         }
      }
      
      private function initEvent() : void
      {
         for(var i:int = 0; i < this._btnArray.length; i++)
         {
            this._btnArray[i].addEventListener(MouseEvent.CLICK,this.__onMenuItemClick);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,TaskManager.instance.__updateAcceptedTask);
         TaskManager.instance.addEventListener(RegressEvent.REGRESS_UPDATE_TASKMENUITEM,this.__onUpdateTaskMenuItem);
      }
      
      private function __onMenuItemClick(event:MouseEvent) : void
      {
         for(var i:int = 0; i < this._btnArray.length; i++)
         {
            if(this._btnArray[i] == event.currentTarget)
            {
               SoundManager.instance.playButtonSound();
               this.menuItemClick(i);
               break;
            }
         }
      }
      
      private function menuItemClick(id:int) : void
      {
         this._menuItemBgSelect.y = this._btnArray[id].y - 2;
         this.setViewVisible();
         this._taskInfoView.visible = false;
         if(id == 4)
         {
            this.taskMenuItemClick(0);
         }
         else
         {
            this._viewArray[id].show();
         }
         if(id == this._btnArray.length - 1)
         {
            this.taskMenuItemClick(0);
         }
         else
         {
            this._viewArray[id].show();
         }
         if(id == 2)
         {
            SocketManager.Instance.out.sendRegressApplyEnable();
         }
      }
      
      private function setViewVisible() : void
      {
         for(var i:int = 0; i < this._viewArray.length; i++)
         {
            this._viewArray[i].visible = false;
         }
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i < this._btnArray.length; i++)
         {
            this._btnArray[i].removeEventListener(MouseEvent.CLICK,this.__onMenuItemClick);
         }
         TaskManager.instance.removeEventListener(RegressEvent.REGRESS_UPDATE_TASKMENUITEM,this.__onUpdateTaskMenuItem);
      }
      
      private function removeArray(array:Array) : void
      {
         for(var i:int = 0; i < array.length; i++)
         {
            if(Boolean(array[i]))
            {
               array[i].dispose();
               array[i] = null;
            }
         }
         array.length = 0;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeArray(this._bgArray);
         this.removeArray(this._textArray);
         this.removeArray(this._btnArray);
         this.removeArray(this._viewArray);
         for(var i:int = 0; i < this._taskMenuItem.length; i++)
         {
            if(Boolean(this._taskMenuItem[i]))
            {
               this._taskMenuItem[i].dispose();
               this._taskMenuItem[i] = null;
            }
         }
         this._taskMenuItem.length = 0;
         if(Boolean(this._menuItemBgSelect))
         {
            this._menuItemBgSelect.dispose();
            this._menuItemBgSelect = null;
         }
         if(Boolean(this._taskInfoView))
         {
            this._taskInfoView.dispose();
            this._taskInfoView = null;
         }
         for(var j:int = 0; j < this._textNameArray.length; j++)
         {
            this._textNameArray[j] = null;
         }
         this._textNameArray.length = 0;
         if(Boolean(this._itemList))
         {
            this._itemList.dispose();
            this._itemList = null;
         }
         if(Boolean(this._listView))
         {
            this._listView.dispose();
            this._listView = null;
         }
         if(Boolean(this._taskData))
         {
            this._taskData = null;
         }
         if(Boolean(this._expandBg))
         {
            this._expandBg = null;
         }
      }
   }
}

