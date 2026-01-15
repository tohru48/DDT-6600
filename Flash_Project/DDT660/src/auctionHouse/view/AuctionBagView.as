package auctionHouse.view
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import playerDress.PlayerDressManager;
   
   public class AuctionBagView extends BagView
   {
      
      public function AuctionBagView()
      {
         super();
         PlayerDressManager.instance.showBind = false;
      }
      
      override protected function initBackGround() : void
      {
         super.initBackGround();
         ObjectUtils.disposeObject(_equipSelectedBtn);
         _equipSelectedBtn = null;
         _equipSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.equipTabBtn2");
         _equipSelectedBtn.mouseEnabled = false;
         _equipSelectedBtn.mouseChildren = false;
         _equipSelectedBtn.selected = true;
         addChild(_equipSelectedBtn);
         ObjectUtils.disposeObject(_propSelectedBtn);
         _propSelectedBtn = null;
         _propSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.propTabBtn2");
         _propSelectedBtn.mouseEnabled = false;
         _propSelectedBtn.mouseChildren = false;
         addChild(_propSelectedBtn);
         ObjectUtils.disposeObject(_beadSelectedBtn);
         _beadSelectedBtn = null;
         _beadSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.beadTabBtn2");
         _beadSelectedBtn.mouseEnabled = false;
         _beadSelectedBtn.mouseChildren = false;
         addChild(_beadSelectedBtn);
         ObjectUtils.disposeObject(_dressSelectedBtn);
         _dressSelectedBtn = null;
         _dressSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.dressTabBtn2");
         _dressSelectedBtn.mouseEnabled = false;
         _dressSelectedBtn.mouseChildren = false;
         addChild(_dressSelectedBtn);
         _bagLockBtn.visible = false;
      }
      
      override protected function initTabButtons() : void
      {
         super.initTabButtons();
         removeChild(_tabBtn1);
         _tabBtn1 = new Sprite();
         _tabBtn1.graphics.beginFill(255,1);
         _tabBtn1.graphics.drawRoundRect(349,42,50,97,15,15);
         _tabBtn1.graphics.endFill();
         _tabBtn1.alpha = 0;
         _tabBtn1.buttonMode = true;
         addChild(_tabBtn1);
         removeChild(_tabBtn2);
         _tabBtn2 = new Sprite();
         _tabBtn2.graphics.beginFill(255,1);
         _tabBtn2.graphics.drawRoundRect(350,147,50,97,15,15);
         _tabBtn2.graphics.endFill();
         _tabBtn2.alpha = 0;
         _tabBtn2.buttonMode = true;
         addChild(_tabBtn2);
         removeChild(_tabBtn3);
         _tabBtn3 = new Sprite();
         _tabBtn3.graphics.beginFill(255,1);
         _tabBtn3.graphics.drawRoundRect(351,254,50,97,15,15);
         _tabBtn3.graphics.endFill();
         _tabBtn3.alpha = 0;
         _tabBtn3.buttonMode = true;
         addChild(_tabBtn3);
         removeChild(_tabBtn4);
         _tabBtn4 = new Sprite();
         _tabBtn4.graphics.beginFill(255,1);
         _tabBtn4.graphics.drawRoundRect(351,359,50,97,15,15);
         _tabBtn4.graphics.endFill();
         _tabBtn4.alpha = 0;
         _tabBtn4.buttonMode = true;
         addChild(_tabBtn4);
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0);
         _proplist = new AuctionBagListView(1);
         _beadList = new AuctionBeadListView(21,32,80);
         _beadList2 = new AuctionBeadListView(21,81,129);
         _beadList3 = new AuctionBeadListView(21,130,178);
         _equiplist.x = _proplist.x = _beadList.x = _beadList2.x = _beadList3.x = 14;
         _equiplist.y = _proplist.y = _beadList.y = _beadList2.y = _beadList3.y = 47;
         _equiplist.width = _proplist.width = _beadList.width = _beadList2.width = _beadList3.width = 330;
         _equiplist.height = _proplist.height = _beadList.height = _beadList2.height = _beadList3.height = 320;
         _proplist.visible = false;
         _beadList.visible = _beadList2.visible = _beadList3.visible = false;
         _lists = [_equiplist,_proplist,_beadList,_beadList2,_beadList3];
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_proplist);
         addChild(_beadList);
         addChild(_beadList2);
         addChild(_beadList3);
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
         if(Boolean(_continueBtn))
         {
            _continueBtn.enable = false;
            _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      override protected function showDressBagView() : void
      {
         super.showDressBagView();
         _dressbagView.enableSortBtn(false);
      }
      
      override protected function adjustEvent() : void
      {
      }
      
      override protected function __cellOpen(evt:Event) : void
      {
      }
      
      override protected function __cellClick(evt:CellEvent) : void
      {
         var cell:BaseCell = null;
         var info:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            evt.stopImmediatePropagation();
            cell = evt.data as BaseCell;
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
            }
         }
      }
      
      override protected function __cellDoubleClick(evt:CellEvent) : void
      {
      }
      
      override public function setBagType(type:int) : void
      {
         super.setBagType(type);
         if(type == BagView.BEAD)
         {
            adjustBeadBagPage(true);
         }
      }
      
      override public function dispose() : void
      {
         PlayerDressManager.instance.showBind = true;
         super.dispose();
      }
   }
}

