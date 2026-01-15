package quest
{
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.TaskManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestCateListView extends ScrollPanel
   {
      
      public static var MAX_LIST_LENGTH:int = 4;
      
      private var _content:VBox;
      
      private var _stripArr:Array;
      
      private var _currentStrip:TaskPannelStripView;
      
      public function QuestCateListView()
      {
         super();
         this._stripArr = new Array();
         this.initView();
      }
      
      private function initView() : void
      {
      }
      
      public function set dataProvider(value:Array) : void
      {
         var item:TaskPannelStripView = null;
         if(value.length == 0)
         {
            return;
         }
         this.height = 0;
         this.clear();
         this._content = new VBox();
         var needScrollBar:Boolean = false;
         if(value.length > QuestCateListView.MAX_LIST_LENGTH)
         {
            needScrollBar = true;
         }
         for(var i:int = 0; Boolean(value[i]); i++)
         {
            item = new TaskPannelStripView(value[i]);
            item.addEventListener(MouseEvent.CLICK,this.__onStripClicked);
            this._content.addChild(item);
            this._stripArr.push(item);
         }
         setView(this._content);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function active() : void
      {
         var strip:TaskPannelStripView = null;
         for each(strip in this._stripArr)
         {
            if(strip.info == TaskManager.instance.selectedQuest)
            {
               this.gotoStrip(strip);
               strip.active();
               return;
            }
         }
         if(Boolean(this._stripArr[0]))
         {
            this.gotoStrip(this._stripArr[0]);
            this._stripArr[0].active();
            return;
         }
      }
      
      private function gotoStrip(strip:TaskPannelStripView) : void
      {
         if(this._currentStrip == strip)
         {
            return;
         }
         if(Boolean(this._currentStrip))
         {
            this._currentStrip.deactive();
         }
         this._currentStrip = strip;
         TaskManager.instance.jumpToQuest(this._currentStrip.info);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __onStripClicked(e:MouseEvent) : void
      {
         this.gotoStrip(e.target as TaskPannelStripView);
      }
      
      private function clear() : void
      {
         var strip:TaskPannelStripView = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         for each(strip in this._stripArr)
         {
            strip.removeEventListener(MouseEvent.CLICK,this.__onStripClicked);
            strip.dispose();
            this._stripArr = new Array();
         }
      }
      
      override public function dispose() : void
      {
         this.clear();
         this._currentStrip.dispose();
         this._currentStrip = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

