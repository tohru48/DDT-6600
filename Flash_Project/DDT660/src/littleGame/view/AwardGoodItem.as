package littleGame.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ScoreExchangeFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import shop.view.ShopGoodItem;
   import shop.view.ShopItemCell;
   
   [Event(name="giving",type="ddt.events.ShopItemEvent")]
   [Event(name="collect",type="ddt.events.ShopItemEvent")]
   [Event(name="purchase",type="ddt.events.ShopItemEvent")]
   public class AwardGoodItem extends ShopGoodItem
   {
      
      private static const AwardItemCell_Size:int = 61;
      
      private var _scoreTitleField:FilterFrameText;
      
      private var _scoreField:FilterFrameText;
      
      private var _exchangeBtn:SimpleBitmapButton;
      
      private var _exchangeTxt:FilterFrameText;
      
      private var _awardItem:MovieImage;
      
      public function AwardGoodItem()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._scoreTitleField);
         this._scoreTitleField = null;
         ObjectUtils.disposeObject(this._scoreField);
         this._scoreField = null;
         ObjectUtils.disposeObject(this._exchangeBtn);
         this._exchangeBtn = null;
      }
      
      override protected function initContent() : void
      {
         var rect:Rectangle = null;
         this._awardItem = ComponentFactory.Instance.creatComponentByStylename("asset.littleGame.background");
         addChild(this._awardItem);
         super.initContent();
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("core.shop.exchangeButton");
         addChild(this._exchangeBtn);
         this._exchangeTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.exchangeText");
         this._exchangeTxt.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
         this._exchangeBtn.addChild(this._exchangeTxt);
         rect = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemBG.size");
         _itemBg.width = rect.width;
         _itemBg.height = rect.height;
         rect = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemName.size");
         ObjectUtils.disposeObject(_itemNameTxt);
         _itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemNameII");
         _itemNameTxt.isAutoFitLength = true;
         _itemNameTxt.x = rect.x;
         _itemNameTxt.width = rect.width;
         addChild(_itemNameTxt);
         rect = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemDotLine.size");
         _dotLine.width = rect.width;
         PositionUtils.setPos(_payType,"littleGame.GoodPayTypeLabel.pos");
         PositionUtils.setPos(_payPaneBuyBtn,"littleGame.PayPaneBuyBtn.pos");
         PositionUtils.setPos(_itemNameTxt,"littleGame.GoodItemName.pos");
         PositionUtils.setPos(_dotLine,"littleGame.GoodItemDotLine.pos");
         PositionUtils.setPos(_itemCellBg,"littleGame.GoodItemCellBg.pos");
         _payPaneGivingBtn.visible = false;
         _payPaneBuyBtn.visible = false;
         this._exchangeBtn.visible = false;
         _itemBg.visible = false;
         _itemPriceTxt.visible = false;
         _shopItemCellTypeBg.visible = false;
         _payType.visible = false;
         this._scoreTitleField = ComponentFactory.Instance.creatComponentByStylename("littleGame.AwardScoreTitleField");
         this._scoreTitleField.text = LanguageMgr.GetTranslation("littlegame.AwardScore");
         addChild(this._scoreTitleField);
         this._scoreField = ComponentFactory.Instance.creatComponentByStylename("littleGame.AwardScoreField");
         addChild(this._scoreField);
         PositionUtils.setPos(itemCell,"littleGame.GoodItemCell.pos");
         itemCell.cellSize = AwardItemCell_Size;
      }
      
      override protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,AwardItemCell_Size,AwardItemCell_Size);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         _itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      override protected function __itemMouseOver(event:MouseEvent) : void
      {
         if(!_itemCell.info)
         {
            return;
         }
         if(Boolean(_lightMc))
         {
            addChild(_lightMc);
         }
         parent.addChild(this);
         _isMouseOver = true;
         __timelineComplete();
      }
      
      override protected function __itemMouseOut(event:MouseEvent) : void
      {
         ObjectUtils.disposeObject(_lightMc);
         if(!_shopItemInfo)
         {
            return;
         }
         _isMouseOver = false;
         __timelineComplete();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._exchangeBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
      }
      
      override protected function __payPanelClick(event:MouseEvent) : void
      {
         if(_shopItemInfo == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Score < _shopItemInfo.getItemPrice(1).scoreValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack"));
            return;
         }
         var _quickFrame:ScoreExchangeFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.exchangeFrame");
         _quickFrame.type = 0;
         _quickFrame.shopItem = _shopItemInfo;
         LayerManager.Instance.addToLayer(_quickFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function set shopItemInfo(value:ShopItemInfo) : void
      {
         super.shopItemInfo = value;
         _payPaneGivingBtn.visible = false;
         _payPaneBuyBtn.visible = false;
         _payType.visible = false;
         this._exchangeBtn.visible = value != null;
         _itemPriceTxt.visible = false;
         _shopItemCellTypeBg.visible = false;
         if(Boolean(value))
         {
            this._scoreField.visible = true;
            this._scoreTitleField.visible = true;
            this._scoreField.text = String(value.AValue1);
         }
         else
         {
            this._scoreField.visible = false;
            this._scoreTitleField.visible = false;
         }
      }
   }
}

