package im
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   
   public class ConsortiaListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      private var _consortiaPlayerArray:Array;
      
      private var _consortiaInfoArray:Array;
      
      private var _currentItem:ConsortiaPlayerInfo;
      
      private var _currentTitle:ConsortiaPlayerInfo;
      
      private var _pos:int;
      
      public function ConsortiaListView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._list = ComponentFactory.Instance.creat("IM.ConsortiaListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this.update();
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD,this.__updateList);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE,this.__updateList);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updateList);
      }
      
      private function __updateList(event:ConsortionEvent) : void
      {
         this._pos = this._list.list.viewPosition.y;
         this.update();
         var intPoint:IntPoint = new IntPoint(0,this._pos);
         this._list.list.viewPosition = intPoint;
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         if((event.cellValue as ConsortiaPlayerInfo).type == 1)
         {
            if(!this._currentItem)
            {
               this._currentItem = event.cellValue as ConsortiaPlayerInfo;
               this._currentItem.isSelected = true;
            }
            else if(this._currentItem != event.cellValue as ConsortiaPlayerInfo)
            {
               this._currentItem.isSelected = false;
               this._currentItem = event.cellValue as ConsortiaPlayerInfo;
               this._currentItem.isSelected = true;
            }
         }
         else
         {
            if(!this._currentTitle)
            {
               this._currentTitle = event.cellValue as ConsortiaPlayerInfo;
               this._currentTitle.isSelected = true;
            }
            if(this._currentTitle != event.cellValue as ConsortiaPlayerInfo)
            {
               this._currentTitle.isSelected = false;
               this._currentTitle = event.cellValue as ConsortiaPlayerInfo;
               this._currentTitle.isSelected = true;
            }
            else
            {
               this._currentTitle.isSelected = !this._currentTitle.isSelected;
            }
            this.updateList();
            SoundManager.instance.play("008");
         }
         this._list.list.updateListView();
      }
      
      private function updateList() : void
      {
         var intPoint:IntPoint = null;
         this._pos = this._list.list.viewPosition.y;
         if(this._currentTitle.type == 0 && this._currentTitle.isSelected)
         {
            this.update();
            intPoint = new IntPoint(0,this._pos);
            this._list.list.viewPosition = intPoint;
         }
         else if(!this._currentTitle.isSelected)
         {
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(this._consortiaInfoArray);
            this._list.list.updateListView();
         }
      }
      
      private function update() : void
      {
         var info:ConsortiaPlayerInfo = null;
         this._consortiaPlayerArray = [];
         this._consortiaPlayerArray = ConsortionModelControl.Instance.model.onlineConsortiaMemberList;
         if(!this._consortiaInfoArray || this._consortiaInfoArray.length == 0)
         {
            this._consortiaInfoArray = ConsortionModelControl.Instance.model.consortiaInfo;
         }
         var tempArr:Array = [];
         var tempArr1:Array = [];
         for(var i:int = 0; i < this._consortiaPlayerArray.length; i++)
         {
            info = this._consortiaPlayerArray[i] as ConsortiaPlayerInfo;
            if(info.IsVIP)
            {
               tempArr.push(info);
            }
            else
            {
               tempArr1.push(info);
            }
         }
         tempArr = tempArr.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         tempArr1 = tempArr1.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._consortiaPlayerArray = tempArr.concat(tempArr1);
         var tempArray:Array = ConsortionModelControl.Instance.model.offlineConsortiaMemberList;
         tempArray = tempArray.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._consortiaPlayerArray = this._consortiaPlayerArray.concat(tempArray);
         this._consortiaPlayerArray = this._consortiaInfoArray.concat(this._consortiaPlayerArray);
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._consortiaPlayerArray);
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD,this.__updateList);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE,this.__updateList);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updateList);
         if(Boolean(this._list) && Boolean(this._list.parent))
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.isSelected = false;
         }
         if(Boolean(this._currentTitle))
         {
            this._currentTitle.isSelected = false;
         }
      }
   }
}

