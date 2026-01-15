package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopSaleManager;
   
   public class ShopSaleItemCell extends Sprite implements Disposeable, ISelectable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _info:ShopItemInfo;
      
      private var _sheng:Bitmap;
      
      private var _oneMoneyLabel:ScaleFrameImage;
      
      private var _twoMoneyLabel:ScaleFrameImage;
      
      private var _buyBtn:BaseButton;
      
      private var _cellPrice:FilterFrameText;
      
      private var _cellName:FilterFrameText;
      
      private var _cellOldPrice:FilterFrameText;
      
      private var _savePrice:int = 3000;
      
      private var _itemCell:ShopItemCell;
      
      private var _itemCellBg:Image;
      
      private var _selected:Boolean;
      
      private var _deleteLine:Shape;
      
      private var _line:TiledImage;
      
      private var _priceImageCon:Sprite;
      
      private var _priceImage:Vector.<ScaleFrameImage>;
      
      private var _countText:FilterFrameText;
      
      private var _limitNum:int = -1;
      
      private var _icon:ScaleFrameImage;
      
      public function ShopSaleItemCell()
      {
         super();
         this.init();
      }
      
      public function get itemCell() : ShopItemCell
      {
         return this._itemCell;
      }
      
      private function init() : void
      {
         this.visible = false;
         this._bg = UICreatShortcut.creatAndAdd("ddtshop.view.seleteSaleCellBg",this);
         this._bg.setFrame(1);
         this._sheng = UICreatShortcut.creatAndAdd("asset.ddtshop.SaleSave",this);
         this._cellPrice = UICreatShortcut.creatAndAdd("ddtshop.view.saleCellPrice",this);
         this._cellName = UICreatShortcut.creatAndAdd("ddtshop.view.saleCellName",this);
         this._cellOldPrice = UICreatShortcut.creatAndAdd("ddtshop.view.saleCellOldPrice",this);
         this._deleteLine = new Shape();
         addChild(this._deleteLine);
         this._oneMoneyLabel = UICreatShortcut.creatAndAdd("ddtshop.GoodPayTypeLabel",this);
         PositionUtils.setPos(this._oneMoneyLabel,"ddtshop.oneMoneyLabel");
         this._twoMoneyLabel = UICreatShortcut.creatAndAdd("ddtshop.GoodPayTypeLabel",this);
         PositionUtils.setPos(this._twoMoneyLabel,"ddtshop.twoMoneyLabel");
         this._oneMoneyLabel.setFrame(2);
         this._twoMoneyLabel.setFrame(2);
         this._line = UICreatShortcut.creatAndAdd("ddtshop.saleCellLine",this);
         this._itemCellBg = UICreatShortcut.creatAndAdd("ddtshop.GoodItemCellBg",this);
         this._itemCellBg.setFrame(1);
         PositionUtils.setPos(this._itemCellBg,"ddtshop.saleItmeCellBgPos");
         this._itemCell = this.createItemCell();
         addChild(this._itemCell);
         this._countText = UICreatShortcut.creatAndAdd("ddtshop.saleCellCount",this);
         PositionUtils.setPos(this._itemCell,"ddtshop.saleItmeCellPos");
         this._icon = UICreatShortcut.creatAndAdd("ddtshop.view.goodsCellIcon",this);
         this._buyBtn = UICreatShortcut.creatAndAdd("ddtshop.view.saleCellBuyBtn",this);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onClickBuy);
         this._priceImage = new Vector.<ScaleFrameImage>();
         this._priceImageCon = new Sprite();
         PositionUtils.setPos(this._priceImageCon,"ddtshop.priceImageConPos");
         addChild(this._priceImageCon);
      }
      
      public function set info(data:ShopItemInfo) : void
      {
         this._info = data;
         if(Boolean(this._info))
         {
            this._itemCell.info = this._info.TemplateInfo;
            this._itemCell.tipInfo = this._info;
            this.updateinfo();
            this.visible = true;
         }
         else
         {
            this._itemCell.info = null;
            this.visible = false;
         }
      }
      
      public function get info() : ShopItemInfo
      {
         return this._info;
      }
      
      public function set limitNum(value:int) : void
      {
         if(this._limitNum == value)
         {
            return;
         }
         this._limitNum = value;
         this._countText.text = this._limitNum.toString();
         if(this._countText.text == "-1")
         {
            this._countText.visible = false;
         }
         else
         {
            this._countText.visible = true;
         }
         this._buyBtn.enable = this.enableBuy;
      }
      
      private function updateinfo() : void
      {
         this.limitNum = this.isLimitGoods ? this._info.LimitPersonalCount : this._info.LimitAreaCount;
         this._icon.setFrame(this.isLimitGoods ? 2 : 1);
         this._cellName.text = this._info.TemplateInfo.Name;
         var newPrice:int = this._info.getItemPrice(1).moneyValue;
         var oldPrice:int = ShopSaleManager.Instance.getGoodsOldPriceByID(this._info.TemplateID);
         if(oldPrice <= 0)
         {
            oldPrice = newPrice;
         }
         this._savePrice = oldPrice - newPrice;
         this._cellPrice.text = LanguageMgr.GetTranslation("asset.ddtshop.newPrice",newPrice);
         this._cellOldPrice.text = LanguageMgr.GetTranslation("asset.ddtshop.oldPrice",oldPrice);
         this._deleteLine.x = this._cellOldPrice.x + 2;
         this._deleteLine.y = this._cellOldPrice.y + this._cellOldPrice.textHeight / 2 + 2;
         this.clearAndCreateDeleteLine(this._cellOldPrice.textWidth);
         this.resetPrice();
      }
      
      private function __onClickBuy(e:MouseEvent) : void
      {
         if(this.enableBuy)
         {
            if(this._limitNum <= 0 && this._info.GoodsID != 201453110)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.ddtshop.notBuySaleGoods"));
               return;
            }
            ShopSaleManager.Instance.goodsBuyMaxNum = this._limitNum;
            ShopBuyManager.Instance.buy(this._info.GoodsID,this._info.isDiscount,this._info.getItemPrice(1).PriceType,true);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.ddtshop.sellFinish"));
         }
      }
      
      public function set autoSelect(value:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this._itemCellBg.setFrame(this._selected ? 3 : 1);
         this._cellName.setFrame(this.selectType);
         this._cellPrice.setFrame(this.selectType);
         this._bg.setFrame(this.selectType);
      }
      
      private function get selectType() : int
      {
         return this._selected ? 2 : 1;
      }
      
      public function get enableBuy() : Boolean
      {
         return this._limitNum != 0;
      }
      
      public function get isLimitGoods() : Boolean
      {
         return this._info.LimitPersonalCount != -1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function resetPrice() : void
      {
         var num:ScaleFrameImage = null;
         var index:int = 0;
         var len:Array = this._savePrice.toString().split("");
         while(Boolean(this._priceImage.length))
         {
            ObjectUtils.disposeObject(this._priceImage.pop());
         }
         while(this._priceImage.length < len.length)
         {
            num = UICreatShortcut.creatAndAdd("ddtshop.view.SaleCoins",this._priceImageCon);
            index = int(len[this._priceImage.length]);
            num.setFrame(index == 0 ? 10 : index);
            num.x = (num.width - 5) * this._priceImage.length;
            this._priceImage.push(num);
         }
      }
      
      private function clearAndCreateDeleteLine(lenght:int) : void
      {
         this._deleteLine.graphics.clear();
         this._deleteLine.graphics.lineStyle(1,11053223);
         this._deleteLine.graphics.moveTo(0,0);
         this._deleteLine.graphics.lineTo(lenght,0);
         this._deleteLine.graphics.endFill();
      }
      
      private function createItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,49,49);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onClickBuy);
         }
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._countText);
         this._countText = null;
         ObjectUtils.disposeObject(this._itemCellBg);
         this._itemCellBg = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._sheng);
         this._sheng = null;
         ObjectUtils.disposeObject(this._oneMoneyLabel);
         this._oneMoneyLabel = null;
         ObjectUtils.disposeObject(this._twoMoneyLabel);
         this._twoMoneyLabel = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         this._deleteLine.graphics.clear();
         ObjectUtils.disposeObject(this._deleteLine);
         this._deleteLine = null;
         this._cellPrice = null;
         this._cellName = null;
         this._cellOldPrice = null;
      }
   }
}

