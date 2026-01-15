package catchInsect.componets
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class CatchInsectShopItem extends Sprite implements Disposeable
   {
      
      protected var _itemBg:ScaleFrameImage;
      
      protected var _itemCellBg:Image;
      
      protected var _dotLine:Image;
      
      protected var _payType:ScaleFrameImage;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      protected var _itemCell:ShopItemCell;
      
      private var _needScore:FilterFrameText;
      
      private var _canNotBuyTips:FilterFrameText;
      
      private var _covertBtn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCellBtn:Sprite;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      protected var _selected:Boolean;
      
      protected var _isMouseOver:Boolean;
      
      protected var _lightMc:MovieClip;
      
      public function CatchInsectShopItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      protected function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemDotLine");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemName");
         this._itemNameTxt.width = 130;
         this._itemNameTxt.x = 79;
         this._itemNameTxt.y = 3;
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,60,60);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         PositionUtils.setPos(this._itemCell,"catchInsect.shopFrame.itemCell.pos");
         this._needScore = ComponentFactory.Instance.creatComponentByStylename("catchInsect.shopFrame.needScoreTxt");
         this._needScore.text = LanguageMgr.GetTranslation("magicStone.score");
         this._canNotBuyTips = ComponentFactory.Instance.creatComponentByStylename("catchInsect.shopFrame.scoreNotEnoughTxt");
         this._canNotBuyTips.visible = false;
         this._covertBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ConvertBtn");
         this._covertBtn.visible = false;
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.BuyBtn");
         this._buyBtn.visible = false;
         this._itemBg.setFrame(1);
         this._itemCellBg.setFrame(1);
         this._payType.setFrame(1);
         this._itemCellBtn = new Sprite();
         this._itemCellBtn.addChild(this._itemCell);
         addChild(this._itemBg);
         addChild(this._itemCellBg);
         addChild(this._dotLine);
         addChild(this._payType);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemCellBtn);
         addChild(this._needScore);
         addChild(this._canNotBuyTips);
         addChild(this._covertBtn);
         addChild(this._buyBtn);
         this._payType.visible = false;
         this._itemPriceTxt.visible = false;
      }
      
      public function set shopItemInfo(value:ShopItemInfo) : void
      {
         if(Boolean(value))
         {
            this._shopItemInfo = value;
            this._itemCell.info = value.TemplateInfo;
            this._itemCell.visible = true;
            this._itemNameTxt.visible = true;
            this._itemNameTxt.text = this._itemCell.info.Name;
            this._needScore.visible = true;
            this._needScore.text = LanguageMgr.GetTranslation("magicStone.score",String(value.AValue1));
            this._covertBtn.visible = true;
            this._buyBtn.visible = false;
            this._canNotBuyTips.visible = false;
         }
         else
         {
            this._shopItemInfo = null;
            this._itemCell.info = null;
            this._itemBg.setFrame(1);
            this._itemCellBg.setFrame(1);
            this._payType.visible = false;
            this._itemPriceTxt.visible = false;
            this._itemNameTxt.visible = false;
            this._needScore.visible = false;
            this._covertBtn.visible = false;
            this._buyBtn.visible = false;
            this._canNotBuyTips.visible = false;
         }
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      protected function addEvent() : void
      {
         this._covertBtn.addEventListener(MouseEvent.CLICK,this.__covertBtnClick);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyBtnClick);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function removeEvent() : void
      {
         this._covertBtn.removeEventListener(MouseEvent.CLICK,this.__covertBtnClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyBtnClick);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function __itemClick(evt:MouseEvent) : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         SoundManager.instance.play("008");
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,this._shopItemInfo,1));
      }
      
      protected function __covertBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var quickBuyFrame:InsectQuickBuyAlert = ComponentFactory.Instance.creatComponentByStylename("catchInsect.quickBuyAlert");
         quickBuyFrame.setData(this._shopItemInfo.TemplateID,this._shopItemInfo.GoodsID,this._shopItemInfo.AValue1);
         LayerManager.Instance.addToLayer(quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __buyBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
      }
      
      protected function __itemMouseOver(event:MouseEvent) : void
      {
         if(!this._itemCell.info)
         {
            return;
         }
         if(Boolean(this._lightMc))
         {
            addChild(this._lightMc);
         }
         parent.addChild(this);
         this._isMouseOver = true;
      }
      
      protected function __itemMouseOut(event:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._lightMc);
         if(!this._shopItemInfo)
         {
            return;
         }
         this._isMouseOver = false;
      }
      
      public function setItemLight($lightMc:MovieClip) : void
      {
         if(this._lightMc == $lightMc)
         {
            return;
         }
         this._lightMc = $lightMc;
         this._lightMc.mouseChildren = false;
         this._lightMc.mouseEnabled = false;
         this._lightMc.gotoAndPlay(1);
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
         this._itemNameTxt.setFrame(value ? 2 : 1);
         this._itemPriceTxt.setFrame(value ? 2 : 1);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._itemCellBg);
         this._itemCellBg = null;
         ObjectUtils.disposeObject(this._dotLine);
         this._dotLine = null;
         ObjectUtils.disposeObject(this._payType);
         this._payType = null;
         ObjectUtils.disposeObject(this._itemNameTxt);
         this._itemNameTxt = null;
         ObjectUtils.disposeObject(this._itemPriceTxt);
         this._itemPriceTxt = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._itemCellBtn);
         this._itemCellBtn = null;
         ObjectUtils.disposeObject(this._needScore);
         this._needScore = null;
         ObjectUtils.disposeObject(this._canNotBuyTips);
         this._canNotBuyTips = null;
         ObjectUtils.disposeObject(this._covertBtn);
         this._covertBtn = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
      }
   }
}

