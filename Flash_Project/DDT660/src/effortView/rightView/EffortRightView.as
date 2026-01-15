package effortView.rightView
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import flash.display.Sprite;
   
   public class EffortRightView extends Sprite implements Disposeable
   {
      
      private var _bg:MutipleImage;
      
      private var _listPanel:ListPanel;
      
      private var _currentSelectItem:EffortInfo;
      
      private var _currentListArray:Array;
      
      private var _controller:EffortController;
      
      public function EffortRightView(controller:EffortController)
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortFullView.EffortFullViewBGIII");
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("effortView.effortlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         this.getNearCompleteEfforts(EffortManager.Instance.currentEffortList);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
         addChild(this._bg);
         addChild(this._listPanel);
      }
      
      private function initEvent() : void
      {
         EffortManager.Instance.addEventListener(EffortEvent.LIST_CHANGED,this.__listChanged);
      }
      
      private function __listChanged(evt:EffortEvent) : void
      {
         this.getNearCompleteEfforts(EffortManager.Instance.currentEffortList);
      }
      
      private function getNearCompleteEfforts(list:Array) : void
      {
         if(EffortManager.Instance.isSelf)
         {
            this.getSelfNearCompleteEfforts(list);
         }
         else
         {
            this.getOtherNearCompleteEfforts(list);
         }
      }
      
      private function getSelfNearCompleteEfforts(list:Array) : void
      {
         var tempArray:Array = null;
         var nearCompleteArray:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(Boolean((list[i] as EffortInfo).CompleteStateInfo))
            {
               tempArray = [];
               tempArray = EffortManager.Instance.getCompleteNextEffort(list[i].ID);
               if(tempArray[0])
               {
                  nearCompleteArray.push(tempArray[tempArray.length - 1]);
               }
            }
            else
            {
               nearCompleteArray.push(list[i]);
            }
         }
         this.setCurrentList(nearCompleteArray);
      }
      
      private function getOtherNearCompleteEfforts(list:Array) : void
      {
         var tempArray:Array = null;
         var nearCompleteArray:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(EffortManager.Instance.tempEffortIsComplete((list[i] as EffortInfo).ID))
            {
               tempArray = [];
               tempArray = EffortManager.Instance.getTempCompleteNextEffort(list[i].ID);
               if(tempArray[0])
               {
                  nearCompleteArray.push(tempArray[tempArray.length - 1]);
               }
            }
            else
            {
               nearCompleteArray.push(list[i]);
            }
         }
         this.setCurrentList(nearCompleteArray);
      }
      
      public function setCurrentList(list:Array) : void
      {
         var i:int = 0;
         var j:int = 0;
         this._currentListArray = [];
         var temList:Array = list;
         var temInCompleteList:Array = [];
         temList.sortOn("ID",Array.DESCENDING);
         if(EffortManager.Instance.isSelf)
         {
            for(i = 0; i < temList.length; i++)
            {
               if(Boolean((temList[i] as EffortInfo).CompleteStateInfo))
               {
                  this._currentListArray.unshift(temList[i]);
               }
               else
               {
                  temInCompleteList.unshift(temList[i]);
               }
            }
            this._currentListArray = this._currentListArray.concat(temInCompleteList);
         }
         else
         {
            for(j = 0; j < temList.length; j++)
            {
               if(EffortManager.Instance.tempEffortIsComplete(temList[j].ID))
               {
                  this._currentListArray.unshift(temList[j]);
               }
               else
               {
                  temInCompleteList.unshift(temList[j]);
               }
            }
            this._currentListArray = this._currentListArray.concat(temInCompleteList);
         }
         this.updateCurrentList();
      }
      
      private function updateCurrentList() : void
      {
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._currentListArray);
         this._listPanel.list.updateListView();
      }
      
      private function __onListItemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentSelectItem)
         {
            this._currentSelectItem = event.cellValue as EffortInfo;
         }
         if(this._currentSelectItem != event.cellValue as EffortInfo)
         {
            this._currentSelectItem.isSelect = false;
         }
         this._currentSelectItem = event.cellValue as EffortInfo;
         this._currentSelectItem.isSelect = true;
         this._listPanel.list.updateListView();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._currentSelectItem))
         {
            this._currentSelectItem.isSelect = false;
         }
         EffortManager.Instance.removeEventListener(EffortEvent.LIST_CHANGED,this.__listChanged);
         if(Boolean(this._listPanel) && Boolean(this._listPanel.parent))
         {
            this._listPanel.vectorListModel.clear();
            this._listPanel.parent.removeChild(this._listPanel);
            this._listPanel.dispose();
            this._listPanel = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
      }
   }
}

