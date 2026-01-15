package worldboss.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import shop.view.ShopGoodItem;
   import shop.view.ShopItemCell;
   import worldboss.WorldBossManager;
   
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
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _text:FilterFrameText;
      
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
         this._exchangeBtn.enable = WorldBossManager.Instance.bossInfo.roomClose;
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
         if(PlayerManager.Instance.Self.damageScores < _shopItemInfo.getItemPrice(1).scoreValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack"));
            return;
         }
         this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),"","",LanguageMgr.GetTranslation("cancel"),true,true,false,2,null,"SimpleAlert2");
         this._tipsframe.height = 200;
         this._text = ComponentFactory.Instance.creatComponentByStylename("worldboss.autoCountSelectFrame.Text");
         this._text.text = LanguageMgr.GetTranslation("ddt.worldboss.autoOpenCount.text");
         PositionUtils.setPos(this._text,"ddt.worldboss.autoOpenCount.textPos");
         this._inputBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.openBatchView.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("openBatchView.inputTxt");
         this._inputText.text = "1";
         PositionUtils.setPos(this._inputBg,"ddt.worldboss.autoOpenCount.textPos1");
         PositionUtils.setPos(this._inputText,"ddt.worldboss.autoOpenCount.textPos2");
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("openBatchView.maxBtn");
         PositionUtils.setPos(this._maxBtn,"ddt.worldboss.autoOpenCount.textPos3");
         this._tipsframe.addToContent(this._text);
         this._tipsframe.addToContent(this._inputBg);
         this._tipsframe.addToContent(this._inputText);
         this._tipsframe.addToContent(this._maxBtn);
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var scoreHave:int = PlayerManager.Instance.Self.damageScores;
         var itemScoreValue:int = _shopItemInfo.getItemPrice(1).scoreValue;
         var maxNum:int = Math.floor(scoreHave / itemScoreValue);
         if(maxNum > 99)
         {
            maxNum = 99;
         }
         this._inputText.text = maxNum + "";
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var scoreHave:int = PlayerManager.Instance.Self.damageScores;
         var itemScoreValue:int = _shopItemInfo.getItemPrice(1).scoreValue;
         var maxNum:int = Math.floor(scoreHave / itemScoreValue);
         var num:int = int(this._inputText.text);
         if(num > maxNum)
         {
            this._inputText.text = maxNum.toString();
         }
         if(num < 1)
         {
            this._inputText.text = "1";
         }
         if(num > 99)
         {
            this._inputText.text = "99";
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         var arr:Array = null;
         var arr1:Array = null;
         var arr2:Array = null;
         var arr3:Array = null;
         var arr4:Array = null;
         var i:int = 0;
         SoundManager.instance.play("008");
         var currentValue:int = int(this._inputText.text);
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            arr = [];
            arr1 = [];
            arr2 = [];
            arr3 = [];
            arr4 = [];
            for(i = 0; i < currentValue; i++)
            {
               arr.push(_shopItemInfo.GoodsID);
               arr1.push(1);
               arr2.push("");
               arr3.push("");
               arr4.push("");
            }
            SocketManager.Instance.out.sendBuyGoods(arr,arr1,arr2,arr3,arr4);
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      public function updata() : void
      {
         this._exchangeBtn.enable = WorldBossManager.Instance.bossInfo.roomClose;
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

