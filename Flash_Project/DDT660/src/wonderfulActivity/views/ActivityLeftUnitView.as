package wonderfulActivity.views
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class ActivityLeftUnitView extends Sprite implements Disposeable
   {
      
      public static const TYPE_WONDER:int = 2;
      
      public static const TYPE_LIMINT:int = 1;
      
      public static const TYPE_NEWSERVER:int = 3;
      
      private var _selectedBtn:SelectedButton;
      
      private var _bg:ScaleBitmapImage;
      
      private var _list:ListPanel;
      
      private var _type:int;
      
      private var dataList:Array;
      
      private var _selectedValue:ActivityCellVo;
      
      private var _updateFun:Function;
      
      private var _currentID:String = "-1";
      
      private var hasClickSound:Boolean = true;
      
      public function ActivityLeftUnitView(type:int)
      {
         super();
         this._type = type;
         this.initView();
         this.initEvent();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function setData(value:Array, rightFun:Function) : void
      {
         this.dataList = value;
         this._updateFun = rightFun;
         this.initData();
      }
      
      private function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         addChild(this._selectedBtn);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.listBG");
         this._bg.visible = false;
         addChild(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.unitCellList");
         this._list.visible = false;
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      public function initData() : void
      {
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this.dataList);
         this._list.list.updateListView();
      }
      
      private function getSelectedBtn() : SelectedButton
      {
         var tmp:SelectedButton = null;
         switch(this._type)
         {
            case TYPE_WONDER:
               tmp = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.wonderfulSelectedBtn");
               break;
            case TYPE_LIMINT:
               tmp = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.limitSelectedBtn");
               break;
            case TYPE_NEWSERVER:
               tmp = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.newServerSelectedBtn");
         }
         return tmp;
      }
      
      private function __selectedBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bg.visible = this._selectedBtn.selected;
         this._list.visible = this._selectedBtn.selected;
         this.extendSelecteTheFirst();
         dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.SELECTED_CHANGE));
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         this._selectedValue = event.cellValue as ActivityCellVo;
         if(this._selectedValue.id == this._currentID)
         {
            return;
         }
         this._currentID = this._selectedValue.id;
         if(this.hasClickSound)
         {
            SoundManager.instance.play("008");
         }
         this.hasClickSound = true;
         this._updateFun(this._selectedValue.id);
      }
      
      public function extendSelecteTheFirst() : void
      {
         this.hasClickSound = false;
         this._currentID = "-1";
         this.extendHandler();
         this.autoSelect();
      }
      
      private function autoSelect() : void
      {
         var tmpSelectedIndex:int = 0;
         var intPoint:IntPoint = null;
         var i:int = 0;
         var model:IListModel = this._list.list.model;
         var len:int = int(model.getSize());
         if(len > 0)
         {
            if(WonderfulActivityManager.Instance.isSkipFromHall)
            {
               for(i = 0; i < len; i++)
               {
                  if(WonderfulActivityManager.Instance.skipType == (model.getElementAt(i) as ActivityCellVo).id)
                  {
                     this._selectedValue = model.getElementAt(i) as ActivityCellVo;
                     WonderfulActivityManager.Instance.isSkipFromHall = false;
                     break;
                  }
               }
               if(!this._selectedValue)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.close"));
                  WonderfulActivityManager.Instance.isSkipFromHall = false;
                  this._selectedValue = model.getElementAt(0) as ActivityCellVo;
               }
            }
            else if(!this._selectedValue)
            {
               this._selectedValue = model.getElementAt(0) as ActivityCellVo;
            }
            tmpSelectedIndex = this.getIndexInModel(this._selectedValue.id);
            if(tmpSelectedIndex < 0)
            {
               tmpSelectedIndex = 0;
            }
            intPoint = new IntPoint(0,model.getCellPosFromIndex(tmpSelectedIndex));
            this._list.list.viewPosition = intPoint;
            this._list.list.currentSelectedIndex = tmpSelectedIndex;
         }
         else
         {
            this._selectedValue = null;
         }
      }
      
      private function getIndexInModel(id:String) : int
      {
         var model:IListModel = this._list.list.model;
         for(var i:int = 0; i <= model.getSize() - 1; i++)
         {
            if(model.getElementAt(i).id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function extendHandler() : void
      {
         this._selectedBtn.selected = true;
         this._selectedBtn.enable = false;
         this._list.visible = true;
         this._bg.visible = true;
      }
      
      public function unextendHandler() : void
      {
         this._selectedBtn.selected = false;
         this._selectedBtn.enable = true;
         this._bg.visible = false;
         this._list.visible = false;
      }
      
      public function getModelSize() : int
      {
         return this._list.list.model.getSize();
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
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
         }
         if(Boolean(this._list) && Boolean(this._list.list))
         {
            this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._selectedBtn))
         {
            ObjectUtils.disposeObject(this._selectedBtn);
         }
         this._selectedBtn = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
      }
      
      public function get bg() : ScaleBitmapImage
      {
         return this._bg;
      }
      
      public function set bg(value:ScaleBitmapImage) : void
      {
         this._bg = value;
      }
      
      public function get list() : ListPanel
      {
         return this._list;
      }
      
      public function set list(value:ListPanel) : void
      {
         this._list = value;
      }
   }
}

