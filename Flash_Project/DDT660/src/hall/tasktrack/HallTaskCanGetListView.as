package hall.tasktrack
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class HallTaskCanGetListView extends Sprite implements Disposeable
   {
      
      private var _titleTxt:FilterFrameText;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _sprite:Sprite;
      
      private var _dataList:DictionaryData;
      
      private var _npcBtn:BaseButton;
      
      private var _pointDownArrow:MovieClip;
      
      public function HallTaskCanGetListView(npcBtn:BaseButton)
      {
         super();
         this.mouseEnabled = false;
         this._npcBtn = npcBtn;
         this._dataList = TaskManager.instance.manuGetList;
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function initView() : void
      {
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellConditionTxt");
         this._titleTxt.width = 300;
         this._titleTxt.htmlText = LanguageMgr.GetTranslation("hall.taskCanGetListView.titleTxt");
         this._titleTxt.mouseEnabled = true;
         this._titleTxt.x = 7;
         this._titleTxt.y = 10;
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("hall.taskCanGetListView.scrollPanel");
         this._sprite = new Sprite();
         addChild(this._titleTxt);
         addChild(this._scrollPanel);
      }
      
      private function initEvent() : void
      {
         this._titleTxt.addEventListener(TextEvent.LINK,this.textClickHandler);
         this._dataList.addEventListener(DictionaryEvent.ADD,this.addHandler);
         this._dataList.addEventListener(DictionaryEvent.REMOVE,this.removeHandler);
      }
      
      private function addHandler(event:DictionaryEvent) : void
      {
         this.refreshView();
      }
      
      private function removeHandler(event:DictionaryEvent) : void
      {
         this.refreshView();
      }
      
      private function refreshView() : void
      {
         var dataArray:Array = null;
         var i:int = 0;
         var taskTitleTxt:FilterFrameText = null;
         ObjectUtils.disposeAllChildren(this._sprite);
         dataArray = this._dataList.list;
         var tmpLen:int = int(dataArray.length);
         if(tmpLen > 0)
         {
            for(i = 0; i < tmpLen; i++)
            {
               taskTitleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellTitleTxt");
               taskTitleTxt.text = ">>" + dataArray[i].Title;
               taskTitleTxt.y = 20 * i;
               this._sprite.addChild(taskTitleTxt);
               if(dataArray[i].QuestID == 558 && !this._pointDownArrow)
               {
                  this._pointDownArrow = ComponentFactory.Instance.creat("asset.newHandGuide.newArrowPointDown");
                  this._pointDownArrow.mouseChildren = false;
                  this._pointDownArrow.mouseEnabled = false;
                  this._pointDownArrow.x = 43;
                  this._pointDownArrow.y = -59;
                  addChild(this._pointDownArrow);
               }
            }
            this._scrollPanel.setView(this._sprite);
            this._titleTxt.visible = true;
            this._scrollPanel.visible = true;
         }
         else
         {
            this._titleTxt.visible = false;
            this._scrollPanel.visible = false;
            if(Boolean(this._pointDownArrow))
            {
               this._pointDownArrow.gotoAndStop(1);
               removeChild(this._pointDownArrow);
               this._pointDownArrow = null;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function textClickHandler(event:TextEvent) : void
      {
         this._npcBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function isEmpty() : Boolean
      {
         return this._dataList.length <= 0;
      }
      
      private function removeEvent() : void
      {
         this._titleTxt.removeEventListener(TextEvent.LINK,this.textClickHandler);
         this._dataList.removeEventListener(DictionaryEvent.ADD,this.addHandler);
         this._dataList.removeEventListener(DictionaryEvent.REMOVE,this.removeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._pointDownArrow))
         {
            this._pointDownArrow.gotoAndStop(1);
            removeChild(this._pointDownArrow);
            this._pointDownArrow = null;
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeAllChildren(this._sprite);
         this._titleTxt = null;
         this._scrollPanel = null;
         this._sprite = null;
         this._dataList = null;
         this._npcBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

