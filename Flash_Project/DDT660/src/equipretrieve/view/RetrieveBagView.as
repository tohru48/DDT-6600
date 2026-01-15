package equipretrieve.view
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import flash.display.Shape;
   import flash.events.Event;
   
   public class RetrieveBagView extends BagView
   {
      
      protected var _equipPanel:ScrollPanel;
      
      protected var _propPanel:ScrollPanel;
      
      public function RetrieveBagView()
      {
         super();
         isNeedCard(false);
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(Boolean(_breakBtn))
         {
            _breakBtn.enable = false;
            _breakBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(_sellBtn))
         {
            _sellBtn.enable = false;
            _sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(_keySortBtn))
         {
            _keySortBtn.enable = false;
            _keySortBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(_cardEnbleFlase))
         {
            _cardEnbleFlase.visible = false;
            _cardEnbleFlase.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(_continueBtn))
         {
            _continueBtn.enable = false;
            _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(_tabBtn3))
         {
            _tabBtn3.mouseEnabled = false;
         }
         _goodsNumInfoText.visible = false;
         _goodsNumTotalText.visible = false;
      }
      
      override protected function initBackGround() : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset4");
         _itemtabBtn = ComponentFactory.Instance.creat("bagView.itemTabButton");
         _itemtabBtn.setFrame(1);
         _bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bgIII");
         _moneyBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBG");
         _moneyBg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGI");
         _moneyBg2 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGII");
         _moneyBg3 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGIII");
         _bgShape = new Shape();
         _bgShape.graphics.beginFill(15262671,1);
         _bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         _bgShape.graphics.endFill();
         _bgShape.x = 11;
         _bgShape.y = 50;
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new RetrieveBagEquipListView(0);
         _proplist = new RetrieveBagListView(1);
         _currentList = _equiplist;
         this._equipPanel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagEquipScrollPanel");
         this._equipPanel.x = 16;
         this._equipPanel.y = 92;
         addChild(this._equipPanel);
         this._equipPanel.hScrollProxy = ScrollPanel.OFF;
         this._equipPanel.vScrollProxy = ScrollPanel.ON;
         this._equipPanel.setView(_equiplist);
         this._equipPanel.invalidateViewport();
         this._propPanel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagEquipScrollPanel");
         this._propPanel.x = 16;
         this._propPanel.y = 266;
         addChild(this._propPanel);
         this._propPanel.hScrollProxy = ScrollPanel.OFF;
         this._propPanel.vScrollProxy = ScrollPanel.ON;
         this._propPanel.setView(_proplist);
         this._propPanel.invalidateViewport();
      }
      
      override protected function initTabButtons() : void
      {
         super.initTabButtons();
         _tabBtn1.visible = false;
         _tabBtn2.visible = false;
         _tabBtn3.visible = false;
         _buttonContainer.visible = false;
      }
      
      override protected function initEvent() : void
      {
         _equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         _equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,__listChange);
         _equiplist.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
         _proplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _proplist.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,__useColorShell);
      }
      
      override public function setBagType(type:int) : void
      {
         super.setBagType(type);
         _buttonContainer.visible = false;
         _itemtabBtn.setFrame(type + 1);
         _sellBtn.enable = _breakBtn.enable = _continueBtn.enable = false;
         _sellBtn.filters = _breakBtn.filters = _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         _equiplist.visible = true;
         _proplist.visible = true;
      }
      
      override protected function __cellDoubleClick(evt:CellEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         evt.stopImmediatePropagation();
         var cell:RetrieveBagcell = evt.data as RetrieveBagcell;
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         var templeteInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.TemplateID);
         var playerSex:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(!cell.locked)
         {
            RetrieveController.Instance.cellDoubleClick(cell);
         }
      }
      
      override protected function __cellClick(evt:CellEvent) : void
      {
         var cell:BagCell = null;
         var info:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            evt.stopImmediatePropagation();
            cell = evt.data as BagCell;
            if(Boolean(cell))
            {
               info = cell.info as InventoryItemInfo;
            }
            if(info == null)
            {
               return;
            }
            if(!cell.locked)
            {
               SoundManager.instance.play("008");
               cell.dragStart();
               RetrieveController.Instance.shine = true;
            }
         }
      }
      
      private function _stopDrag(e:CellEvent) : void
      {
         RetrieveController.Instance.shine = false;
      }
      
      public function resultPoint(i:int, _dx:Number, _dy:Number) : void
      {
         this.setBagType(i);
         if(i == EQUIP)
         {
            RetrieveModel.Instance.setresultCell(RetrieveBagEquipListView(_equiplist).returnNullPoint(_dx,_dy));
         }
         else if(i == PROP)
         {
            RetrieveModel.Instance.setresultCell(RetrieveBagListView(_proplist).returnNullPoint(_dx,_dy));
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._equipPanel);
         this._equipPanel = null;
         ObjectUtils.disposeObject(this._propPanel);
         this._propPanel = null;
         super.dispose();
      }
   }
}

