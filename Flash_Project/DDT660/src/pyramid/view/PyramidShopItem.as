package pyramid.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import pyramid.PyramidManager;
   import shop.view.ShopItemCell;
   
   public class PyramidShopItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      protected var _itemCell:ShopItemCell;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      protected var _itemPriceTitle:FilterFrameText;
      
      protected var _dotLine:Image;
      
      protected var _shopViewItemBtn:BaseButton;
      
      private var _shopItemInfo:ShopItemInfo;
      
      public function PyramidShopItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.shopViewItemBg");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._itemCell = this.creatItemCell();
         this._itemCell.buttonMode = true;
         this._itemCell.width = 55;
         this._itemCell.height = 55;
         PositionUtils.setPos(this._itemCell,"pyramid.shopGoodItemCellPos");
         addChild(this._itemCell);
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.shopItemDotLine");
         addChild(this._dotLine);
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.shopItemNameTxt");
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.shopItemPriceTxt");
         this._itemPriceTitle = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.shopItemPriceTitle");
         this._itemPriceTitle.text = LanguageMgr.GetTranslation("ddt.pyramid.shopItemPriceTitle");
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemPriceTitle);
         this._shopViewItemBtn = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.shopViewItemBtn");
         addChild(this._shopViewItemBtn);
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.__shopItemOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.__shopItemOut);
         this._shopViewItemBtn.addEventListener(MouseEvent.CLICK,this.__shopViewItemBtnClick);
      }
      
      public function set shopItemInfo(value:ShopItemInfo) : void
      {
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         this._shopItemInfo = value;
         if(Boolean(this._shopItemInfo))
         {
            this._itemCell.info = this._shopItemInfo.TemplateInfo;
            this._itemCell.tipInfo = this._shopItemInfo;
            this._itemNameTxt.text = String(this._itemCell.info.Name);
            this.initPrice();
            this._itemPriceTitle.visible = true;
            this._shopViewItemBtn.visible = true;
            this._itemCell.buttonMode = true;
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemCell.info = null;
            this._itemCell.tipInfo = null;
            this._itemNameTxt.text = "";
            this._itemPriceTxt.text = "";
            this._itemPriceTitle.visible = false;
            this._shopViewItemBtn.visible = false;
            this._itemCell.buttonMode = false;
         }
      }
      
      protected function initPrice() : void
      {
         this._itemPriceTxt.text = String(this._shopItemInfo.AValue1);
         this.updateGreyState();
      }
      
      public function updateGreyState() : void
      {
         if(Boolean(this._shopItemInfo) && PyramidManager.instance.model.totalPoint < this._shopItemInfo.AValue1)
         {
            this.isButtonGrey(true);
         }
         else
         {
            this.isButtonGrey(false);
         }
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      private function __updateShopItem(event:Event) : void
      {
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
         this._itemCell.tipInfo = this._shopItemInfo;
         this._itemNameTxt.text = String(this._itemCell.info.Name);
         this.initPrice();
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,60,60);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      private function __shopViewItemBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PyramidManager.instance.model.isPyramidStart)
         {
            PyramidManager.instance.showFrame(4);
         }
         else
         {
            SocketManager.Instance.out.sendButTransnationalGoods(this._shopItemInfo.GoodsID);
         }
      }
      
      private function isButtonGrey(bool:Boolean) : void
      {
         if(bool)
         {
            this._shopViewItemBtn.mouseChildren = false;
            this._shopViewItemBtn.mouseEnabled = false;
            this._shopViewItemBtn.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         else
         {
            this._shopViewItemBtn.mouseChildren = true;
            this._shopViewItemBtn.mouseEnabled = true;
            this._shopViewItemBtn.filters = null;
         }
      }
      
      private function __shopItemOver(event:MouseEvent) : void
      {
         if(Boolean(this._shopItemInfo))
         {
            this._bg.setFrame(2);
         }
      }
      
      private function __shopItemOut(event:MouseEvent) : void
      {
         this._bg.setFrame(1);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.__shopItemOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.__shopItemOut);
         this._shopViewItemBtn.removeEventListener(MouseEvent.CLICK,this.__shopViewItemBtnClick);
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._itemNameTxt);
         this._itemNameTxt = null;
         ObjectUtils.disposeObject(this._itemPriceTxt);
         this._itemPriceTxt = null;
         ObjectUtils.disposeObject(this._itemPriceTitle);
         this._itemPriceTitle = null;
         ObjectUtils.disposeObject(this._dotLine);
         this._dotLine = null;
         ObjectUtils.disposeObject(this._shopViewItemBtn);
         this._shopViewItemBtn = null;
         this._shopItemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

