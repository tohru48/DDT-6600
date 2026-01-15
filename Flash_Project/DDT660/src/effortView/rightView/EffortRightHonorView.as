package effortView.rightView
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.tips.GoodTip;
   import effortView.EffortController;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EffortRightHonorView extends Sprite implements Disposeable
   {
      
      public static const GOODSCLICK:String = "goods_click_awardsItem";
      
      private var _listPanel:ListPanel;
      
      private var _currentSelectItem:EffortInfo;
      
      private var _effortRigthItemArray:Array;
      
      private var _currentListArray:Array;
      
      private var _controller:EffortController;
      
      private var _bg:MutipleImage;
      
      private var _goodTip:GoodTip;
      
      private var _tipStageClickCount:int;
      
      public function EffortRightHonorView(controller:EffortController)
      {
         super();
         this._controller = controller;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortFullView.EffortFullViewBGIII");
         addChild(this._bg);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("effortView.effortHonorlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         this.update();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
         addChild(this._listPanel);
         EffortManager.Instance.addEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         var cells:Vector.<IListCell> = this._listPanel.list.getAllCells();
         for(var i:int = 0; i < cells.length; i++)
         {
            (cells[i] as DisplayObject).addEventListener(EffortRightHonorView.GOODSCLICK,this.__goodsClick);
         }
      }
      
      private function __goodsClick(e:CaddyEvent) : void
      {
         this.showLinkGoodsInfo(e.itemTemplateInfo,e.point);
      }
      
      private function showLinkGoodsInfo(item:ItemTemplateInfo, tipPos:Point, tipStageClickCount:uint = 0) : void
      {
         if(!this._goodTip)
         {
            this._goodTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip");
         }
         this._goodTip.showTip(item);
         this.setTipPos(this._goodTip,tipPos);
         this._tipStageClickCount = tipStageClickCount;
      }
      
      private function setTipPos(tip:BaseTip, tipPos:Point) : void
      {
         tip.x = tipPos.x - tip.width;
         tip.y = tipPos.y - tip.height - 10;
         if(tip.y < 0)
         {
            tip.y = 10;
         }
         StageReferance.stage.addChild(tip);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
      }
      
      private function __stageClickHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         event.stopPropagation();
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(Boolean(StageReferance.stage))
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function __typeChanged(event:EffortEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            switch(this._controller.currentViewType)
            {
               case 0:
                  this.setCurrentList(EffortManager.Instance.getHonorEfforts());
                  break;
               case 1:
                  this.setCurrentList(EffortManager.Instance.getCompleteHonorEfforts());
                  break;
               case 2:
                  this.setCurrentList(EffortManager.Instance.getInCompleteHonorEfforts());
            }
         }
         else
         {
            switch(this._controller.currentViewType)
            {
               case 0:
                  this.setCurrentList(EffortManager.Instance.getTempHonorEfforts());
                  break;
               case 1:
                  this.setCurrentList(EffortManager.Instance.getTempCompleteHonorEfforts());
                  break;
               case 2:
                  this.setCurrentList(EffortManager.Instance.getTempInCompleteHonorEfforts());
            }
         }
      }
      
      public function setCurrentList(list:Array) : void
      {
         var i:int = 0;
         var j:int = 0;
         this._currentListArray = [];
         this._effortRigthItemArray = [];
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
         EffortManager.Instance.removeEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         if(Boolean(this._currentSelectItem))
         {
            this._currentSelectItem.isSelect = false;
         }
         if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
         {
            this._goodTip.parent.removeChild(this._goodTip);
         }
         this._goodTip = null;
         var cells:Vector.<IListCell> = this._listPanel.list.getAllCells();
         for(var i:int = 0; i < cells.length; i++)
         {
            (cells[i] as DisplayObject).removeEventListener(EffortRightHonorView.GOODSCLICK,this.__goodsClick);
         }
         if(Boolean(this._listPanel) && Boolean(this._listPanel.parent))
         {
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
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

