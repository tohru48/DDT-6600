package store.newFusion.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.newFusion.FusionNewManager;
   import store.newFusion.data.FusionNewVo;
   
   public class FusionNewUnitView extends Sprite implements Disposeable
   {
      
      public static const SELECTED_CHANGE:String = "fusionNewUnitView_selected_change";
      
      private var _index:int;
      
      private var _rightView:FusionNewRightView;
      
      private var _selectedBtn:SelectedButton;
      
      private var _bg:Bitmap;
      
      private var _list:ListPanel;
      
      private var _isFilter:Boolean = false;
      
      private var _dataList:Array;
      
      private var _selectedValue:FusionNewVo;
      
      public function FusionNewUnitView(index:int, rightView:FusionNewRightView)
      {
         super();
         this._index = index;
         this._rightView = rightView;
         this.initView();
         this.initEvent();
         this.initData();
         this.initStatus();
      }
      
      private function initStatus() : void
      {
         if(this._index == 1)
         {
            this.extendSelecteTheFirst();
         }
      }
      
      private function extendSelecteTheFirst() : void
      {
         this.extendHandler();
         this.autoSelect();
      }
      
      private function autoSelect() : void
      {
         var tmpSelectedIndex:int = 0;
         var intPoint:IntPoint = null;
         var _model:IListModel = this._list.list.model;
         var len:int = int(_model.getSize());
         if(len > 0)
         {
            if(!this._selectedValue)
            {
               this._selectedValue = _model.getElementAt(0) as FusionNewVo;
            }
            tmpSelectedIndex = int(_model.indexOf(this._selectedValue));
            intPoint = new IntPoint(0,_model.getCellPosFromIndex(tmpSelectedIndex));
            this._list.list.viewPosition = intPoint;
            this._list.list.currentSelectedIndex = tmpSelectedIndex;
         }
         else
         {
            this._selectedValue = null;
         }
         this._rightView.refreshView(this._selectedValue);
      }
      
      public function set isFilter(value:Boolean) : void
      {
         this._isFilter = value;
         this.refreshList();
      }
      
      private function initData() : void
      {
         this._dataList = this.getDataList();
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._dataList);
         this._list.list.updateListView();
      }
      
      private function refreshList() : void
      {
         var len:int = 0;
         var i:int = 0;
         var tmpArray:Array = [];
         if(this._isFilter)
         {
            len = int(this._dataList.length);
            for(i = 0; i < len; i++)
            {
               if((this._dataList[i] as FusionNewVo).canFusionCount > 0)
               {
                  tmpArray.push(this._dataList[i]);
               }
            }
         }
         else
         {
            tmpArray = this._dataList;
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(tmpArray);
         this._list.list.updateListView();
         if(Boolean(this._selectedValue) && tmpArray.indexOf(this._selectedValue) == -1)
         {
            this._selectedValue = null;
         }
         if(this._list.visible)
         {
            this.autoSelect();
         }
      }
      
      private function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.newFusion.selectedUnitBg");
         this._bg.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.unitCellList");
         this._list.visible = false;
         addChild(this._selectedBtn);
         addChild(this._bg);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.updateBag);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.updateBag);
      }
      
      private function updateBag(evt:BagEvent) : void
      {
         this.refreshList();
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedValue = event.cellValue as FusionNewVo;
         if(Boolean(this._rightView))
         {
            this._rightView.refreshView(this._selectedValue);
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.extendSelecteTheFirst();
         dispatchEvent(new Event(SELECTED_CHANGE));
      }
      
      private function extendHandler() : void
      {
         this._bg.visible = true;
         this._list.visible = true;
         this._selectedBtn.enable = false;
      }
      
      public function unextendHandler() : void
      {
         this._selectedBtn.selected = false;
         this._selectedBtn.enable = true;
         this._bg.visible = false;
         this._list.visible = false;
         this._selectedValue = null;
      }
      
      private function getDataList() : Array
      {
         var tmp:Array = null;
         switch(this._index)
         {
            case 1:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.WEAPON_TYPE);
               break;
            case 2:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.JEWELLRY_TYPE);
               break;
            case 3:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.AVATAR_TYPE);
               break;
            case 4:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.DRILL_TYPE);
               break;
            case 5:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.COMBINE_TYPE);
               break;
            case 6:
               tmp = FusionNewManager.instance.getDataListByType(FusionNewVo.OTHER_TYPE);
               break;
            default:
               tmp = [];
         }
         return Boolean(tmp) ? tmp : [];
      }
      
      private function getSelectedBtn() : SelectedButton
      {
         var tmp:SelectedButton = null;
         switch(this._index)
         {
            case 1:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.weaponBtn");
               break;
            case 2:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.jewellryBtn");
               break;
            case 3:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.avatarBtn");
               break;
            case 4:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.drillBtn");
               break;
            case 5:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.combineBtn");
               break;
            case 6:
               tmp = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.otherBtn");
         }
         return tmp;
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._selectedBtn) && Boolean(this._bg))
         {
            if(this._bg.visible)
            {
               return this._bg.y + this._bg.height;
            }
            return this._selectedBtn.height;
         }
         return super.height;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         if(Boolean(this._list))
         {
            this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.updateBag);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._selectedBtn = null;
         this._bg = null;
         this._list = null;
         this._rightView = null;
         this._selectedValue = null;
         this._dataList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

