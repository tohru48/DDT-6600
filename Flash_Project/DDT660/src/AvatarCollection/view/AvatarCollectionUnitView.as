package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionUnitView extends Sprite implements Disposeable
   {
      
      public static const SELECTED_CHANGE:String = "avatarCollectionUnitView_selected_change";
      
      private var _index:int;
      
      private var _rightView:AvatarCollectionRightView;
      
      private var _selectedBtn:SelectedButton;
      
      private var _bg:Bitmap;
      
      private var _list:ListPanel;
      
      private var _dataList:Array;
      
      private var _selectedValue:AvatarCollectionUnitVo;
      
      private var _isFilter:Boolean = false;
      
      private var _isBuyFilter:Boolean = false;
      
      public function AvatarCollectionUnitView(index:int, rightView:AvatarCollectionRightView)
      {
         super();
         this._index = index;
         this._rightView = rightView;
         this.initView();
         this.initEvent();
         this.initData();
         this.initStatus();
      }
      
      public function set isBuyFilter(value:Boolean) : void
      {
         this._isBuyFilter = value;
         if(this._isBuyFilter)
         {
            this._isFilter = false;
         }
         this.refreshList();
      }
      
      public function set isFilter(value:Boolean) : void
      {
         this._isFilter = value;
         if(this._isFilter)
         {
            this._isBuyFilter = false;
         }
         this.refreshList();
      }
      
      private function initStatus() : void
      {
         var i:int = 0;
         if(AvatarCollectionManager.instance.isSkipFromHall)
         {
            for(i = 0; i < this._dataList.length; i++)
            {
               if((this._dataList[i] as AvatarCollectionUnitVo).id == AvatarCollectionManager.instance.skipId)
               {
                  this.extendSelecteTheFirst();
                  break;
               }
            }
         }
         else if(this._index == 1)
         {
            this.extendSelecteTheFirst();
         }
      }
      
      private function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.selectUnitBg");
         this._bg.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitCellList");
         this._list.visible = false;
         addChild(this._selectedBtn);
         addChild(this._bg);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         AvatarCollectionManager.instance.addEventListener(AvatarCollectionManager.REFRESH_VIEW,this.toDoRefresh);
      }
      
      private function initData() : void
      {
         this._dataList = this.getDataList();
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._dataList);
         this._list.list.updateListView();
      }
      
      private function toDoRefresh(event:Event) : void
      {
         this.refreshList();
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedValue = event.cellValue as AvatarCollectionUnitVo;
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
      
      private function extendSelecteTheFirst() : void
      {
         this.extendHandler();
         this.autoSelect();
      }
      
      private function extendHandler() : void
      {
         this._bg.visible = true;
         this._list.visible = true;
         this._selectedBtn.enable = false;
      }
      
      private function autoSelect() : void
      {
         var tmpSelectedIndex:int = 0;
         var intPoint:IntPoint = null;
         var i:int = 0;
         var _model:IListModel = this._list.list.model;
         var len:int = int(_model.getSize());
         if(len > 0)
         {
            if(!this._selectedValue)
            {
               if(AvatarCollectionManager.instance.isSkipFromHall)
               {
                  for(i = 0; i < len; i++)
                  {
                     if((_model.getElementAt(i) as AvatarCollectionUnitVo).id == AvatarCollectionManager.instance.skipId)
                     {
                        this._selectedValue = _model.getElementAt(i);
                        AvatarCollectionManager.instance.isSkipFromHall = false;
                        break;
                     }
                  }
               }
               else
               {
                  this._selectedValue = _model.getElementAt(0) as AvatarCollectionUnitVo;
               }
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
      
      public function unextendHandler() : void
      {
         this._selectedBtn.selected = false;
         this._selectedBtn.enable = true;
         this._bg.visible = false;
         this._list.visible = false;
      }
      
      private function refreshList() : void
      {
         var len:int = 0;
         var i:int = 0;
         var len2:int = 0;
         var k:int = 0;
         var tmpArray:Array = [];
         if(this._isFilter)
         {
            len = int(this._dataList.length);
            for(i = 0; i < len; i++)
            {
               if((this._dataList[i] as AvatarCollectionUnitVo).canActivityCount > 0)
               {
                  tmpArray.push(this._dataList[i]);
               }
            }
         }
         else if(this._isBuyFilter)
         {
            len2 = int(this._dataList.length);
            for(k = 0; k < len2; k++)
            {
               if((this._dataList[k] as AvatarCollectionUnitVo).canBuyCount > 0)
               {
                  tmpArray.push(this._dataList[k]);
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
      
      private function getDataList() : Array
      {
         var tmp:Array = null;
         switch(this._index)
         {
            case 1:
               tmp = AvatarCollectionManager.instance.maleUnitList;
               break;
            case 2:
               tmp = AvatarCollectionManager.instance.femaleUnitList;
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
               tmp = ComponentFactory.Instance.creatComponentByStylename("avatarColl.maleBtn");
               break;
            case 2:
               tmp = ComponentFactory.Instance.creatComponentByStylename("avatarColl.femaleBtn");
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
         this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         AvatarCollectionManager.instance.removeEventListener(AvatarCollectionManager.REFRESH_VIEW,this.toDoRefresh);
      }
      
      public function dispose() : void
      {
         AvatarCollectionManager.instance.isSkipFromHall = false;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._rightView = null;
         this._selectedBtn = null;
         this._bg = null;
         this._list = null;
         this._dataList = null;
         this._selectedValue = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

