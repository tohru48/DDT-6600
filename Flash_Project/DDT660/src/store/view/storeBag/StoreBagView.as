package store.view.storeBag
{
   import bagAndInfo.bag.BreakGoodsView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.view.goods.AddPricePanel;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import store.StoreBagBgWHPoint;
   import store.StoreMainView;
   import store.data.StoreModel;
   
   public class StoreBagView extends Sprite implements Disposeable
   {
      
      private var _controller:StoreBagController;
      
      private var _model:StoreModel;
      
      private var _equipmentView:StoreBagListView;
      
      private var _propView:StoreBagListView;
      
      private var _transerViewUp:StoreSingleBagListView;
      
      private var _transerViewDown:StoreSingleBagListView;
      
      private var _bitmapBg:StoreBagbgbmp;
      
      private var bagBg:ScaleFrameImage;
      
      private var _equipmentsColumnBg:Image;
      
      private var _itemsColumnBg:Image;
      
      public var msg_txt:ScaleFrameImage;
      
      private var goldTxt:FilterFrameText;
      
      private var moneyTxt:FilterFrameText;
      
      private var giftTxt:FilterFrameText;
      
      private var _goldButton:RichesButton;
      
      private var _giftButton:RichesButton;
      
      private var _moneyButton:RichesButton;
      
      private var _bgPoint:StoreBagBgWHPoint;
      
      private var _bgShape:Shape;
      
      private var _equipmentTitleText:FilterFrameText;
      
      private var _itemTitleText:FilterFrameText;
      
      private var _equipmentTipText:FilterFrameText;
      
      private var _itemTipText:FilterFrameText;
      
      public function StoreBagView()
      {
         super();
      }
      
      public function setup(controller:StoreBagController) : void
      {
         this._controller = controller;
         this._model = this._controller.model;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bitmapBg = new StoreBagbgbmp();
         addChildAt(this._bitmapBg,0);
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagViewBg2");
         addChild(this.bagBg);
         this._equipmentTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTitleText");
         this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         this._itemTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTitleText");
         this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
         this._equipmentTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTipText");
         this._itemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTipText");
         addChild(this._equipmentTitleText);
         addChild(this._itemTitleText);
         addChild(this._equipmentTipText);
         addChild(this._itemTipText);
         this.showStoreBagViewText("store.StoreBagView.EquipmentTip.StrengthText","store.StoreBagView.ItemTip.Text1");
         var showMoneyBG:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.MoneyPanelBg");
         addChild(showMoneyBG);
         this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.TicketText");
         addChild(this.moneyTxt);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         addChild(this._goldButton);
         this.giftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GiftText");
         addChild(this.giftTxt);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         this._giftButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GiftButton");
         var levelNum:int = int(ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel));
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",levelNum.toString());
         addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._moneyButton);
         this.goldTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GoldText");
         addChild(this.goldTxt);
         this._equipmentView = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagListViewEquip");
         this._propView = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagListViewProp");
         this._transerViewUp = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreSingleBagListView");
         this._transerViewDown = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreSingleBagListView");
         this._transerViewDown.y = this._propView.y;
         this._equipmentView.setup(0,this._controller,StoreBagListView.SMALLGRID);
         this._propView.setup(1,this._controller,StoreBagListView.SMALLGRID);
         this._transerViewUp.setup(0,this._controller,StoreBagListView.SMALLGRID);
         this._transerViewDown.setup(0,this._controller,StoreBagListView.SMALLGRID);
         addChild(this._equipmentView);
         addChild(this._propView);
         addChild(this._transerViewUp);
         addChild(this._transerViewDown);
         this.updateMoney();
      }
      
      private function showStoreBagViewText(equipmentTip:String, itemTip:String, isShowItemTip:Boolean = true) : void
      {
         this._equipmentTipText.text = LanguageMgr.GetTranslation(equipmentTip);
         if(isShowItemTip)
         {
            this._itemTipText.text = LanguageMgr.GetTranslation(itemTip);
         }
         this._itemTipText.visible = isShowItemTip;
         this._itemTitleText.visible = isShowItemTip;
      }
      
      private function initEvents() : void
      {
         this._equipmentView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._transerViewUp.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._transerViewDown.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         this._model.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function removeEvents() : void
      {
         this._equipmentView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._transerViewUp.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._transerViewDown.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         this._model.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      public function setData(storeModel:StoreModel) : void
      {
         this.visible = true;
         if(this._controller.currentPanel == StoreMainView.STRENGTH)
         {
            this._equipmentView.setData(this._model.canStrthEqpmtList);
            this._propView.setData(this._model.strthList);
            this.bagBg.setFrame(1);
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.StrengthText","store.StoreBagView.ItemTip.Text1");
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.COMPOSE)
         {
            this._equipmentView.setData(this._model.canCpsEquipmentList);
            this._propView.setData(this._model.cpsAndANchList);
            this.bagBg.setFrame(1);
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.ComposeText","store.StoreBagView.ItemTip.Text1");
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.FUSION)
         {
            this.visible = false;
            this._equipmentView.setData(this._model.canRongLiangEquipmengtList);
            this._propView.setData(this._model.canRongLiangPropList);
            this.bagBg.setFrame(1);
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.FusionText","store.StoreBagView.ItemTip.Text3");
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.LIANGHUA)
         {
            this._equipmentView.setData(this._model.canLianhuaEquipList);
            this._propView.setData(this._model.canLianhuaPropList);
            this.bagBg.setFrame(1);
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.EXALT)
         {
            this._equipmentView.setData(this._model.canExaltEqpmtList);
            this._propView.setData(this._model.exaltRock);
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.ExaltText","store.StoreBagView.ItemTip.Text2");
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
            this.bagBg.setFrame(1);
            this.changeToDoubleBagView();
         }
         else
         {
            this._transerViewUp.setData(this._model.canTransEquipmengtList);
            this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
            this._transerViewDown.setData(this._model.canNotTransEquipmengtList);
            this.bagBg.setFrame(1);
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.TransferText","store.StoreBagView.ItemTip.Text4");
            this.changeToSingleBagView();
         }
      }
      
      private function changeToSingleBagView() : void
      {
         this._equipmentView.visible = false;
         this._propView.visible = false;
         this._transerViewDown.visible = true;
         this._transerViewUp.visible = true;
      }
      
      private function changeToDoubleBagView() : void
      {
         this._equipmentView.visible = true;
         this._propView.visible = true;
         this._transerViewDown.visible = false;
         this._transerViewUp.visible = false;
      }
      
      private function __cellClick(evt:CellEvent) : void
      {
         var info:InventoryItemInfo = null;
         evt.stopImmediatePropagation();
         var cell:BagCell = evt.data as BagCell;
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
            if(!EquipType.isPackage(info))
            {
               cell.dragStart();
            }
         }
      }
      
      private function createBreakWin(cell:BagCell) : void
      {
         SoundManager.instance.play("008");
         var win:BreakGoodsView = new BreakGoodsView();
         win.cell = cell;
         win.show();
      }
      
      private function __cellAddPrice(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         if(Boolean(cell))
         {
            AddPricePanel.Instance.setInfo(cell.itemInfo,false);
            LayerManager.Instance.addToLayer(AddPricePanel.Instance,LayerManager.STAGE_DYANMIC_LAYER,true);
         }
      }
      
      private function __cellMove(evt:Event) : void
      {
         SoundManager.instance.play("008");
         var cell:BagCell = CellMenu.instance.cell;
         if(Boolean(cell))
         {
            cell.dragStart();
         }
      }
      
      public function getPropCell(pos:int) : BagCell
      {
         return this._propView.getCellByPos(pos);
      }
      
      public function getEquipCell(pos:int) : BagCell
      {
         return this._equipmentView.getCellByPos(pos);
      }
      
      public function get EquipList() : StoreBagListView
      {
         return this._equipmentView;
      }
      
      public function get PropList() : StoreBagListView
      {
         return this._propView;
      }
      
      public function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["Money"]) || Boolean(evt.changedProperties["Gold"]) || Boolean(evt.changedProperties[PlayerInfo.DDT_MONEY]) || Boolean(evt.changedProperties[PlayerInfo.BandMONEY]))
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         this.goldTxt.text = String(PlayerManager.Instance.Self.Gold);
         this.moneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.giftTxt.text = String(PlayerManager.Instance.Self.BandMoney);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bitmapBg))
         {
            ObjectUtils.disposeObject(this._bitmapBg);
         }
         this._bitmapBg = null;
         if(Boolean(this.bagBg))
         {
            ObjectUtils.disposeObject(this.bagBg);
         }
         this.bagBg = null;
         if(Boolean(this._equipmentsColumnBg))
         {
            ObjectUtils.disposeObject(this._equipmentsColumnBg);
         }
         this._equipmentsColumnBg = null;
         if(Boolean(this._itemsColumnBg))
         {
            ObjectUtils.disposeAllChildren(this._itemsColumnBg);
         }
         this._itemsColumnBg = null;
         if(Boolean(this._equipmentTitleText))
         {
            ObjectUtils.disposeObject(this._equipmentTitleText);
         }
         this._equipmentTitleText = null;
         if(Boolean(this._equipmentTipText))
         {
            ObjectUtils.disposeObject(this._equipmentTipText);
         }
         this._equipmentTipText = null;
         if(Boolean(this._itemTitleText))
         {
            ObjectUtils.disposeObject(this._itemTitleText);
         }
         this._itemTitleText = null;
         if(Boolean(this._itemTipText))
         {
            ObjectUtils.disposeObject(this._itemTipText);
         }
         this._itemTipText = null;
         if(Boolean(this.msg_txt))
         {
            ObjectUtils.disposeObject(this.msg_txt);
         }
         this.msg_txt = null;
         if(Boolean(this._equipmentView))
         {
            ObjectUtils.disposeObject(this._equipmentView);
         }
         this._equipmentView = null;
         if(Boolean(this._propView))
         {
            ObjectUtils.disposeObject(this._propView);
         }
         this._propView = null;
         if(Boolean(this._transerViewUp))
         {
            ObjectUtils.disposeObject(this._transerViewUp);
         }
         this._transerViewUp = null;
         if(Boolean(this._transerViewDown))
         {
            ObjectUtils.disposeObject(this._transerViewDown);
         }
         this._transerViewDown = null;
         if(Boolean(this.goldTxt))
         {
            ObjectUtils.disposeObject(this.goldTxt);
         }
         this.goldTxt = null;
         if(Boolean(this.moneyTxt))
         {
            ObjectUtils.disposeObject(this.moneyTxt);
         }
         this.moneyTxt = null;
         if(Boolean(this.giftTxt))
         {
            ObjectUtils.disposeObject(this.giftTxt);
         }
         this.giftTxt = null;
         if(Boolean(this._goldButton))
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(Boolean(this._giftButton))
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(Boolean(this._moneyButton))
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(Boolean(this._bgShape))
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

