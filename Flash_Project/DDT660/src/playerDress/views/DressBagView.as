package playerDress.views
{
   import bagAndInfo.bag.ContinueGoodsBtn;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import playerDress.PlayerDressManager;
   
   public class DressBagView extends Sprite implements Disposeable
   {
      
      public static const CELLS_NUM:int = 49;
      
      private var _assortBox:ComboBox;
      
      private var _searchInput:TextInput;
      
      private var _searchBtn:SimpleBitmapButton;
      
      private var _baglist:DressBagListView;
      
      private var _bottomBg:Bitmap;
      
      private var _maleBtn:SelectedButton;
      
      private var _femaleBtn:SelectedButton;
      
      private var _sortBtn:SimpleBitmapButton;
      
      private var _renewalBtn:ContinueGoodsBtn;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _pageBG:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _currentSort:int;
      
      private var _sortArr:Array = [];
      
      private var _sortTypeArr:Array = [0,5,1,3,13,2,4,6,15,-1];
      
      private var _info:SelfInfo;
      
      private var _currentPage:int;
      
      public function DressBagView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         PlayerDressManager.instance.dressBag = this;
         this._currentSort = 0;
         this._currentPage = 1;
         this._info = PlayerManager.Instance.Self;
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort0"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort1"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort2"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort3"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort4"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort5"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort6"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort7"));
         this._sortArr.push(LanguageMgr.GetTranslation("playerDress.sort8"));
      }
      
      private function initView() : void
      {
         var isMale:Boolean = false;
         this._assortBox = ComponentFactory.Instance.creatComponentByStylename("playerDress.assortCombo");
         this._assortBox.selctedPropName = "text";
         this._assortBox.textField.text = this._sortArr[this._currentSort];
         addChild(this._assortBox);
         this._searchInput = ComponentFactory.Instance.creatComponentByStylename("playerDress.searchInput");
         this._searchInput.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         addChild(this._searchInput);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.searchBtn");
         addChild(this._searchBtn);
         this._baglist = new DressBagListView(BagInfo.EQUIPBAG,7,CELLS_NUM);
         PositionUtils.setPos(this._baglist,"playerDress.baglistPos");
         addChild(this._baglist);
         this._bottomBg = ComponentFactory.Instance.creat("playerDress.bottomBg");
         addChild(this._bottomBg);
         this._maleBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.maleBtn");
         addChild(this._maleBtn);
         this._femaleBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.femaleBtn");
         addChild(this._femaleBtn);
         this._sortBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.sortBtn");
         addChild(this._sortBtn);
         this._renewalBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton2");
         PositionUtils.setPos(this._renewalBtn,"playerDress.renewalBtnPos");
         this._renewalBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagContinue");
         addChild(this._renewalBtn);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.leftBtn");
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.rightBtn");
         addChild(this._rightBtn);
         this._pageBG = ComponentFactory.Instance.creatComponentByStylename("playerDress.pageBG");
         addChild(this._pageBG);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("playerDress.pageTxt");
         addChild(this._pageTxt);
         this._pageTxt.text = "2/3";
         isMale = PlayerManager.Instance.Self.Sex;
         this._maleBtn.selected = isMale;
         this._maleBtn.mouseEnabled = !isMale;
         this._femaleBtn.selected = !isMale;
         this._femaleBtn.mouseEnabled = isMale;
         this.updateComboBox(this._sortArr[this._currentSort]);
         this._baglist.setData(this._info.Bag);
         this.updateBagList();
      }
      
      private function initEvent() : void
      {
         this._baglist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._baglist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._assortBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__maleBtnClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__femaleBtnClick);
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftBtnClick);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightBtnClick);
         this._sortBtn.addEventListener(MouseEvent.CLICK,this.__sortBtnClick);
         this._renewalBtn.addEventListener(MouseEvent.CLICK,this.__renewalBtnClick);
         this._searchInput.addEventListener(FocusEvent.FOCUS_IN,this.__searchInputFocusIn);
         this._searchInput.addEventListener(FocusEvent.FOCUS_OUT,this.__searchInputFocusOut);
      }
      
      protected function __cellClick(event:CellEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,event.data,false,false,event.ctrlKey));
      }
      
      protected function __renewalBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __sortBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("playerDress.sortTips"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      protected function __onResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._baglist.foldItems();
         }
      }
      
      protected function __cellDoubleClick(event:CellEvent) : void
      {
         var cell:BagCell = null;
         var item:InventoryItemInfo = null;
         var dressView:PlayerDressView = PlayerDressManager.instance.dressView;
         if(Boolean(dressView))
         {
            cell = event.data as BagCell;
            item = cell.info as InventoryItemInfo;
            PlayerDressManager.instance.putOnDress(item);
         }
         else
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,event.data));
         }
      }
      
      protected function __searchBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchInput.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText") || this._searchInput.text.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.PleaseEnterTheKeywords"));
            return;
         }
         this._currentSort = 9;
         this._assortBox.textField.text = LanguageMgr.GetTranslation("playerDress.sort9");
         this.updateComboBox();
         this.updateBagList();
      }
      
      protected function __maleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._maleBtn.mouseEnabled = false;
         this._femaleBtn.mouseEnabled = true;
         this._femaleBtn.selected = false;
         this.updateBagList();
      }
      
      protected function __femaleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._femaleBtn.mouseEnabled = false;
         this._maleBtn.mouseEnabled = true;
         this._maleBtn.selected = false;
         this.updateBagList();
      }
      
      protected function __rightBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._currentPage;
         if(this._currentPage > this.pageSum())
         {
            this._currentPage = this.pageSum();
            return;
         }
         this.updatePage();
         this._baglist.fillPage(this._currentPage);
      }
      
      protected function __leftBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._currentPage;
         if(this._currentPage < 1)
         {
            this._currentPage = 1;
            return;
         }
         this.updatePage();
         this._baglist.fillPage(this._currentPage);
      }
      
      protected function __onListClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentSort = this._sortArr.indexOf(event.cellValue);
         this._searchInput.text = "";
         this.updateComboBox(event.cellValue);
         this.updateBagList();
      }
      
      public function updateBagList() : void
      {
         this._baglist.setSortType(this._sortTypeArr[this._currentSort],this._maleBtn.selected,this._searchInput.text);
      }
      
      public function set currentPage(value:int) : void
      {
         this._currentPage = value;
      }
      
      public function updatePage() : void
      {
         this._pageTxt.text = this._currentPage + "/" + this.pageSum();
      }
      
      private function pageSum() : int
      {
         var len:int = this._baglist.displayItemsLength();
         return len == 0 ? 1 : int(Math.ceil(len / CELLS_NUM));
      }
      
      private function updateComboBox(obj:* = null) : void
      {
         var comboxModel:VectorListModel = this._assortBox.listPanel.vectorListModel;
         comboxModel.clear();
         comboxModel.appendAll(this._sortArr);
         comboxModel.remove(obj);
      }
      
      protected function __searchInputFocusIn(event:FocusEvent) : void
      {
         if(this._searchInput.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText"))
         {
            this._searchInput.text = "";
         }
      }
      
      protected function __searchInputFocusOut(event:FocusEvent) : void
      {
         if(this._searchInput.text.length == 0)
         {
            this._searchInput.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         }
      }
      
      public function enableSortBtn(enable:Boolean) : void
      {
         this._sortBtn.enable = enable;
      }
      
      private function removeEvent() : void
      {
         this._baglist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._assortBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__maleBtnClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__femaleBtnClick);
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftBtnClick);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightBtnClick);
         this._sortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBtnClick);
         this._renewalBtn.removeEventListener(MouseEvent.CLICK,this.__renewalBtnClick);
         this._baglist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._searchInput.removeEventListener(FocusEvent.FOCUS_IN,this.__searchInputFocusIn);
         this._searchInput.removeEventListener(FocusEvent.FOCUS_OUT,this.__searchInputFocusOut);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._assortBox);
         this._assortBox = null;
         ObjectUtils.disposeObject(this._searchInput);
         this._searchInput = null;
         ObjectUtils.disposeObject(this._searchBtn);
         this._searchBtn = null;
         ObjectUtils.disposeObject(this._baglist);
         this._baglist = null;
         ObjectUtils.disposeObject(this._maleBtn);
         this._maleBtn = null;
         ObjectUtils.disposeObject(this._femaleBtn);
         this._femaleBtn = null;
         ObjectUtils.disposeObject(this._bottomBg);
         this._bottomBg = null;
         ObjectUtils.disposeObject(this._sortBtn);
         this._sortBtn = null;
         ObjectUtils.disposeObject(this._renewalBtn);
         this._renewalBtn = null;
         ObjectUtils.disposeObject(this._leftBtn);
         this._leftBtn = null;
         ObjectUtils.disposeObject(this._rightBtn);
         this._rightBtn = null;
         ObjectUtils.disposeObject(this._pageBG);
         this._pageBG = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
      }
      
      public function get baglist() : DressBagListView
      {
         return this._baglist;
      }
   }
}

