package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCategory;
   import ddt.events.TaskEvent;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestCateView extends Sprite implements Disposeable
   {
      
      public static var TITLECLICKED:String = "titleClicked";
      
      public static var EXPANDED:String = "expanded";
      
      public static var COLLAPSED:String = "collapsed";
      
      public static const ENABLE_CHANGE:String = "enableChange";
      
      private const ITEM_HEIGHT:int = 38;
      
      private const LIST_SPACE:int = 0;
      
      private const LIST_PADDING:int = 10;
      
      private var _data:QuestCategory;
      
      private var _titleView:QuestCateTitleView;
      
      private var _listView:ScrollPanel;
      
      private var _itemList:VBox;
      
      private var _itemArr:Array;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _isExpanded:Boolean;
      
      public var questType:int;
      
      public function QuestCateView(cateID:int = -1, scrollPanel:ScrollPanel = null)
      {
         super();
         this._itemArr = new Array();
         this.questType = cateID;
         this._scrollPanel = scrollPanel;
         this.initView();
         this.initEvent();
         this.collapse();
      }
      
      override public function get height() : Number
      {
         if(this._isExpanded)
         {
            return 210;
         }
         return 57;
      }
      
      public function get contentHeight() : int
      {
         var titleHeight:int = this._titleView.height;
         if(!this._isExpanded)
         {
            return titleHeight;
         }
         if(this._data.list.length <= QuestCateListView.MAX_LIST_LENGTH)
         {
            return titleHeight + QuestCateListView.MAX_LIST_LENGTH * this.ITEM_HEIGHT;
         }
         return titleHeight + this._listView.height;
      }
      
      public function get length() : int
      {
         if(Boolean(this.data) && Boolean(this.data.list))
         {
            return this.data.list.length;
         }
         return 0;
      }
      
      public function get data() : QuestCategory
      {
         return this._data;
      }
      
      private function initView() : void
      {
         this._titleView = new QuestCateTitleView(this.questType);
         this._titleView.x = 0;
         this._titleView.y = 0;
         addChild(this._titleView);
         this._itemList = new VBox();
         this._itemList.spacing = this.LIST_SPACE;
         this._listView = ComponentFactory.Instance.creat("core.quest.QuestItemList");
         this._listView.setView(this._itemList);
         this._listView.vScrollProxy = ScrollPanel.AUTO;
         this._listView.hScrollProxy = ScrollPanel.OFF;
         addChild(this._listView);
         this.updateData();
      }
      
      public function set taskStyle(style:int) : void
      {
         this._titleView.taskStyle = style;
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            (this._itemArr[i] as TaskPannelStripView).taskStyle = style;
         }
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
      }
      
      private function initEvent() : void
      {
         this._titleView.addEventListener(MouseEvent.CLICK,this.__onTitleClicked);
         this._listView.addEventListener(Event.CHANGE,this.__onListChange);
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.__onQuestData);
      }
      
      private function removeEvent() : void
      {
         this._titleView.removeEventListener(MouseEvent.CLICK,this.__onTitleClicked);
         this._listView.removeEventListener(Event.CHANGE,this.__onListChange);
         TaskManager.instance.removeEventListener(TaskEvent.CHANGED,this.__onQuestData);
      }
      
      public function initData() : void
      {
         this.updateData();
      }
      
      public function active() : Boolean
      {
         if(this._data.list.length == 0)
         {
            return false;
         }
         TaskManager.instance.currentCategory = this.questType;
         this.updateView();
         this.expand();
         dispatchEvent(new Event(TITLECLICKED));
         return true;
      }
      
      private function __onQuestData(e:TaskEvent) : void
      {
         if(!TaskManager.instance.MainFrame)
         {
            return;
         }
         this.updateData();
         if(this.isExpanded)
         {
            dispatchEvent(new Event(TITLECLICKED));
         }
      }
      
      private function __onTitleClicked(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TaskManager.instance.MainFrame.currentNewCateView = null;
         if(!this._isExpanded)
         {
            this.active();
         }
      }
      
      private function __onListChange(e:Event) : void
      {
         this.updateView();
      }
      
      public function set dataProvider(value:Array) : void
      {
      }
      
      private function updateView() : void
      {
         this.updateTitleView();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get isExpanded() : Boolean
      {
         return this._isExpanded;
      }
      
      public function collapse() : void
      {
         if(this._isExpanded == false)
         {
            return;
         }
         this._isExpanded = false;
         this._titleView.isExpanded = this._isExpanded;
         this._listView.visible = false;
         if(this._listView.parent == this)
         {
            removeChild(this._listView);
         }
         this.updateTitleView();
         dispatchEvent(new Event(COLLAPSED));
      }
      
      public function expand() : void
      {
         var item:TaskPannelStripView = null;
         this._isExpanded = true;
         this.updateData();
         this._titleView.isExpanded = this._isExpanded;
         this._listView.visible = true;
         addChild(this._listView);
         for each(item in this._itemArr)
         {
            item.onShow();
         }
         this.updateTitleView();
         dispatchEvent(new Event(EXPANDED));
      }
      
      private function set enable(value:Boolean) : void
      {
         if(value)
         {
            this._titleView.enable = true;
         }
         else
         {
            this._titleView.haveNoTag();
            this._titleView.enable = false;
            this.collapse();
         }
         if(visible != value)
         {
            visible = value;
            dispatchEvent(new Event(ENABLE_CHANGE));
         }
      }
      
      private function updateData() : void
      {
         var item:TaskPannelStripView = null;
         var actived:Boolean = false;
         var i:uint = 0;
         var needScrollBar:Boolean = false;
         var questItem:TaskPannelStripView = null;
         this._data = TaskManager.instance.getAvailableQuests(this.questType);
         if(this._data.list.length == 0 || this.questType == 4)
         {
            this.enable = false;
            return;
         }
         this.enable = true;
         this.updateTitleView();
         if(!this.isExpanded)
         {
            return;
         }
         if(this._data.list.length > QuestCateListView.MAX_LIST_LENGTH)
         {
            needScrollBar = true;
         }
         for each(item in this._itemArr)
         {
            item.dispose();
         }
         this._itemList.disposeAllChildren();
         this._itemArr = new Array();
         actived = false;
         for(i = 0; i < this._data.list.length; i++)
         {
            questItem = new TaskPannelStripView(this._data.list[i]);
            questItem.addEventListener(TaskEvent.CHANGED,this.__onItemActived);
            if(needScrollBar)
            {
               questItem.x = 3;
            }
            else
            {
               questItem.x = this.LIST_PADDING;
            }
            if(Boolean(TaskManager.instance.selectedQuest))
            {
               if(questItem.info.id == 363 || questItem.info.id == TaskManager.instance.selectedQuest.id)
               {
                  questItem.active();
                  actived = true;
               }
            }
            if(!(questItem.info.id >= 4001 && questItem.info.id <= 4024))
            {
               this._itemArr.push(questItem);
               this._itemList.addChild(questItem);
            }
         }
         if(!actived)
         {
            (this._itemArr[0] as TaskPannelStripView).active();
         }
         this._listView.invalidateViewport();
      }
      
      private function __onItemActived(e:TaskEvent) : void
      {
         for(var i:int = 0; i < this._itemList.numChildren; i++)
         {
            if((this._itemList.getChildAt(i) as TaskPannelStripView).info != e.info)
            {
               (this._itemList.getChildAt(i) as TaskPannelStripView).status = "normal";
            }
            (this._itemList.getChildAt(i) as TaskPannelStripView).update();
         }
      }
      
      private function updateTitleView() : void
      {
         if(this._isExpanded)
         {
            this._titleView.haveNoTag();
            return;
         }
         if(this._data.haveCompleted)
         {
            this._titleView.haveCompleted();
         }
         else if(this._data.haveRecommend)
         {
            this._titleView.haveRecommond();
         }
         else if(this._data.haveNew)
         {
            this._titleView.haveNew();
         }
         else
         {
            this._titleView.haveNoTag();
         }
         if(this._isExpanded)
         {
         }
      }
      
      public function dispose() : void
      {
         var item:TaskPannelStripView = null;
         this.removeEvent();
         this._data = null;
         if(Boolean(this._titleView))
         {
            ObjectUtils.disposeObject(this._titleView);
         }
         this._titleView = null;
         if(Boolean(this._itemList))
         {
            this._itemList.disposeAllChildren();
            ObjectUtils.disposeObject(this._itemList);
            this._itemList = null;
         }
         if(Boolean(this._listView))
         {
            ObjectUtils.disposeObject(this._listView);
         }
         this._listView = null;
         while(Boolean(item = this._itemArr.pop()))
         {
            if(Boolean(item))
            {
               item.removeEventListener(TaskEvent.CHANGED,this.__onItemActived);
               item.dispose();
            }
            item = null;
         }
         this._itemArr = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get itemArr() : Array
      {
         return this._itemArr;
      }
   }
}

