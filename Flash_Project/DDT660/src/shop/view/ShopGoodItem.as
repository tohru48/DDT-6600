package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class ShopGoodItem extends Sprite implements ISelectable, Disposeable
   {
      
      public static const PAYTYPE_DDT_MONEY:uint = 1;
      
      public static const PAYTYPE_MONEY:uint = 2;
      
      public static const YELLOW_BOY:uint = 3;
      
      public static const BURIED_STONE:uint = 4;
      
      private static const LIMIT_LABEL:uint = 6;
      
      protected var _payPaneGivingBtn:BaseButton;
      
      protected var _payPaneBuyBtn:BaseButton;
      
      protected var _itemBg:ScaleFrameImage;
      
      protected var _itemCellBg:Image;
      
      private var _shopItemCellBg:Bitmap;
      
      protected var _itemCell:ShopItemCell;
      
      protected var _itemCellBtn:Sprite;
      
      protected var _itemCountTxt:FilterFrameText;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      protected var _labelIcon:ScaleFrameImage;
      
      protected var _payType:ScaleFrameImage;
      
      protected var _selected:Boolean;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      protected var _shopItemCellTypeBg:ScaleFrameImage;
      
      private var _payPaneBuyBtnHotArea:Sprite;
      
      protected var _dotLine:Image;
      
      protected var _timeline:TimelineMax;
      
      protected var _isMouseOver:Boolean;
      
      protected var _lightMc:MovieClip;
      
      protected var _payPaneaskBtn:BaseButton;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      public function ShopGoodItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      public function get payPaneGivingBtn() : BaseButton
      {
         return this._payPaneGivingBtn;
      }
      
      public function get payPaneBuyBtn() : BaseButton
      {
         return this._payPaneBuyBtn;
      }
      
      public function get payPaneaskBtn() : BaseButton
      {
         return this._payPaneaskBtn;
      }
      
      public function get itemBg() : ScaleFrameImage
      {
         return this._itemBg;
      }
      
      public function get itemCell() : ShopItemCell
      {
         return this._itemCell;
      }
      
      public function get itemCellBtn() : Sprite
      {
         return this._itemCellBtn;
      }
      
      public function get dotLine() : Image
      {
         return this._dotLine;
      }
      
      protected function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemDotLine");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         this._payPaneGivingBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneGivingBtn");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneBuyBtn");
         this._payPaneaskBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneAskBtn");
         this._payPaneBuyBtnHotArea = new Sprite();
         this._payPaneBuyBtnHotArea.graphics.beginFill(0,0);
         this._payPaneBuyBtnHotArea.graphics.drawRect(0,0,this._payPaneBuyBtn.width,this._payPaneBuyBtn.height);
         PositionUtils.setPos(this._payPaneBuyBtnHotArea,this._payPaneBuyBtn);
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemName");
         this._itemNameTxt.y = 3;
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCount");
         this._itemCell = this.creatItemCell();
         PositionUtils.setPos(this._itemCell,"ddtshop.ShopGoodItemCellPos");
         this._labelIcon = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodLabelIcon");
         this._labelIcon.mouseChildren = false;
         this._labelIcon.mouseEnabled = false;
         this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopItemCellTypeBg");
         this._itemCellBtn = new Sprite();
         this._itemCellBtn.buttonMode = true;
         this._itemCellBtn.addChild(this._itemCell);
         this._itemCellBtn.addChild(this._shopItemCellTypeBg);
         this._itemBg.setFrame(1);
         this._itemCellBg.setFrame(1);
         this._labelIcon.setFrame(1);
         this._payType.setFrame(1);
         addChild(this._itemBg);
         addChild(this._itemCellBg);
         addChild(this._dotLine);
         addChild(this._payPaneGivingBtn);
         addChild(this._payPaneBuyBtn);
         addChild(this._payPaneaskBtn);
         addChild(this._payPaneBuyBtnHotArea);
         addChild(this._payType);
         addChild(this._itemCellBtn);
         addChild(this._labelIcon);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemCountTxt);
         /*
		 this._timeline = new TimelineMax();
         this._timeline.addEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         var tw1:TweenLite = TweenLite.to(this._labelIcon,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(tw1);
         var tw2:TweenLite = TweenLite.to(this._itemCountTxt,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(tw2,-0.25);
         var tw5:TweenMax = TweenMax.from(this._shopItemCellTypeBg,0.1,{
            "autoAlpha":0,
            "y":"5"
         });
         this._timeline.append(tw5,-0.2);
         this._timeline.stop();
		 */
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,75,75);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(value:ShopItemInfo) : void
      {
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         if(value == null)
         {
            this._shopItemInfo = null;
            this._itemCell.info = null;
         }
         else
         {
            this._shopItemInfo = value;
            this._itemCell.info = value.TemplateInfo;
            this._itemCell.tipInfo = value;
         }
         if(this._itemCell.info != null)
         {
            this._itemCell.visible = true;
            this._itemCellBtn.visible = true;
            this._itemCellBtn.buttonMode = true;
            this._payType.visible = true;
            this._itemPriceTxt.visible = true;
            this._itemNameTxt.visible = true;
            this._itemCountTxt.visible = true;
            this._payPaneGivingBtn.visible = true;
            this._payPaneBuyBtn.visible = true;
            this._payPaneaskBtn.visible = true;
            this._itemNameTxt.text = String(this._itemCell.info.Name);
            this._itemCell.tipInfo = value;
            this.initPrice();
            if(this._shopItemInfo.ShopID == 1)
            {
               this._itemBg.setFrame(1);
               this._itemCellBg.setFrame(1);
            }
            else
            {
               this._itemBg.setFrame(2);
               this._itemCellBg.setFrame(2);
            }
            if(EquipType.dressAble(this._shopItemInfo.TemplateInfo))
            {
               this._shopItemCellTypeBg.setFrame(1);
            }
            else
            {
               this._shopItemCellTypeBg.setFrame(2);
            }
            this._labelIcon.visible = this._shopItemInfo.Label == 0 ? false : true;
            this._labelIcon.setFrame(this._shopItemInfo.Label);
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemBg.setFrame(1);
            this._itemCellBg.setFrame(1);
            this._itemCellBtn.visible = false;
            this._labelIcon.visible = false;
            this._payType.visible = false;
            this._itemPriceTxt.visible = false;
            this._itemNameTxt.visible = false;
            this._itemCountTxt.visible = false;
            this._payPaneGivingBtn.visible = false;
            this._payPaneBuyBtn.visible = false;
            this._payPaneaskBtn.visible = false;
         }
         this.updateCount();
         this.updateBtn();
      }
      
      private function updateBtn() : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
         {
            this._payPaneBuyBtn.enable = false;
            this._payPaneBuyBtnHotArea.mouseEnabled = true;
         }
         else
         {
            this._payPaneBuyBtn.enable = true;
            this._payPaneBuyBtnHotArea.mouseEnabled = false;
         }
      }
      
      private function __updateShopItem(evt:Event) : void
      {
         this.updateCount();
      }
      
      private function checkType() : int
      {
         if(Boolean(this._shopItemInfo))
         {
            return this._shopItemInfo.ShopID == 1 ? 1 : 2;
         }
         return 1;
      }
      
      protected function initPrice() : void
      {
         switch(this._shopItemInfo.getItemPrice(1).PriceType)
         {
            case Price.MONEY:
               this._payType.setFrame(PAYTYPE_MONEY);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
               break;
            case Price.DDT_MONEY:
               this._payType.setFrame(PAYTYPE_DDT_MONEY);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).bandDdtMoneyValue);
               this._payPaneGivingBtn.visible = false;
               this._payPaneaskBtn.visible = false;
               break;
            case Price.SCORE:
               this._payType.setFrame(PAYTYPE_DDT_MONEY);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).bandDdtMoneyValue);
               this._payPaneGivingBtn.visible = false;
               this._payPaneaskBtn.visible = false;
         }
      }
      
      private function updateCount() : void
      {
         if(Boolean(this._shopItemInfo))
         {
            if(Boolean(this._shopItemInfo.Label) && this._shopItemInfo.Label == LIMIT_LABEL)
            {
               if(Boolean(this._itemBg) && Boolean(this._labelIcon) && Boolean(this._itemCountTxt))
               {
                  this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
               }
            }
            else if(Boolean(this._itemBg) && Boolean(this._labelIcon) && Boolean(this._itemCountTxt))
            {
               this._itemCountTxt.visible = false;
               this._itemCountTxt.text = "0";
            }
         }
      }
      
      protected function addEvent() : void
      {
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OVER,this.__payPaneBuyBtnOver);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OUT,this.__payPaneBuyBtnOut);
         this._payPaneGivingBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneaskBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function removeEvent() : void
      {
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OVER,this.__payPaneBuyBtnOver);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OUT,this.__payPaneBuyBtnOut);
         this._payPaneGivingBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneaskBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      private function payPanAskHander(e:MouseEvent) : void
      {
         this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._shopPresentClearingFrame.show();
         this._shopPresentClearingFrame.setType(ShopPresentClearingFrame.FPAYTYPE_SHOP);
         this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick);
         this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
      }
      
      protected function shopPresentClearingFrameResponseHandler(event:FrameEvent) : void
      {
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
         if(Boolean(this._shopPresentClearingFrame.presentBtn))
         {
            this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.presentBtnClick);
         }
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
      }
      
      protected function presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var name:String = this._shopPresentClearingFrame.nameInput.text;
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askPay"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askSpace"));
            return;
         }
         this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.presentBtnClick);
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
      }
      
      protected function __payPaneBuyBtnOver(event:MouseEvent) : void
      {
         if(Boolean(this._shopItemInfo) && this._shopItemInfo.LimitGrade > PlayerManager.Instance.Self.Grade)
         {
            this._payPaneBuyBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this._payPaneBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy",this._shopItemInfo.LimitGrade);
            this._payPaneBuyBtn.tipDirctions = "3,7,6";
            ShowTipManager.Instance.showTip(this._payPaneBuyBtn);
         }
      }
      
      protected function __payPaneBuyBtnOut(event:MouseEvent) : void
      {
         ShowTipManager.Instance.removeTip(this._payPaneBuyBtn);
      }
      
      protected function __payPanelClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         if(Boolean(this._shopItemInfo) && this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(this._shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            if(this._shopItemInfo.isDiscount == 2 && ShopManager.Instance.getDisCountShopItemByGoodsID(this._shopItemInfo.GoodsID) == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.shop.discount.exit"));
               return;
            }
            if(event.currentTarget == this._payPaneGivingBtn)
            {
               ShopGiftsManager.Instance.buy(this._shopItemInfo.GoodsID,this._shopItemInfo.isDiscount == 2,2);
            }
            else if(event.currentTarget == this._payPaneBuyBtn)
            {
               ShopBuyManager.Instance.buy(this._shopItemInfo.GoodsID,this._shopItemInfo.isDiscount,this._shopItemInfo.getItemPrice(1).PriceType);
            }
            else
            {
               ShopBuyManager.Instance.buy(this._shopItemInfo.GoodsID,this._shopItemInfo.isDiscount,3);
            }
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      protected function __payPaneGetBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var frame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.title"),LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.msg"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         var items:Array = null;
         var types:Array = null;
         var colors:Array = null;
         var dresses:Array = null;
         var places:Array = null;
         var i:int = 0;
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            items = new Array();
            types = new Array();
            colors = new Array();
            dresses = new Array();
            places = new Array();
            for(i = 0; i < 1; i++)
            {
               items.push(this._shopItemInfo.GoodsID);
               types.push(1);
               colors.push("");
               dresses.push("");
               places.push("");
            }
            SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses);
         }
      }
      
      protected function __itemClick(evt:MouseEvent) : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,this._shopItemInfo,1));
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
         //this._timeline.play();
      }
      
      protected function __itemMouseOut(event:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._lightMc);
         if(!this._shopItemInfo)
         {
            return;
         }
         this._isMouseOver = false;
         //this.__timelineComplete();
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
      
      protected function __timelineComplete(event:TweenEvent = null) : void
      {
         if(this._timeline.currentTime < this._timeline.totalDuration)
         {
            return;
         }
         if(this._isMouseOver)
         {
            return;
         }
         this._timeline.reverse();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
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
         this._itemBg.setFrame(this._selected ? 3 : this.checkType());
         this._itemCellBg.setFrame(this._selected ? 3 : this.checkType());
         this._itemNameTxt.setFrame(value ? 2 : 1);
         this._itemPriceTxt.setFrame(value ? 2 : 1);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         ObjectUtils.disposeAllChildren(this);
        /*
		 if(Boolean(this._timeline))
         {
            this._timeline.removeEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
            this._timeline = null;
         }
		 */
         if(Boolean(this._lightMc))
         {
            ObjectUtils.disposeObject(this._lightMc);
            this._lightMc = null;
         }
         if(Boolean(this._itemBg))
         {
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
         }
         if(Boolean(this._itemCellBg))
         {
            ObjectUtils.disposeObject(this._itemCellBg);
            this._itemCellBg = null;
         }
         if(Boolean(this._shopItemCellBg))
         {
            ObjectUtils.disposeObject(this._shopItemCellBg);
            this._shopItemCellBg = null;
         }
         if(Boolean(this._payPaneaskBtn))
         {
            ObjectUtils.disposeObject(this._payPaneaskBtn);
         }
         this._payPaneaskBtn = null;
         if(Boolean(this._payPaneGivingBtn))
         {
            ObjectUtils.disposeObject(this._payPaneGivingBtn);
         }
         this._payPaneGivingBtn = null;
         if(Boolean(this._payPaneBuyBtn))
         {
            ObjectUtils.disposeObject(this._payPaneBuyBtn);
         }
         this._payPaneBuyBtn = null;
         if(Boolean(this._dotLine))
         {
            ObjectUtils.disposeObject(this._dotLine);
            this._dotLine = null;
         }
         if(Boolean(this._itemCell))
         {
            ObjectUtils.disposeObject(this._itemCell);
            this._itemCell = null;
         }
         if(Boolean(this._shopItemCellTypeBg))
         {
            ObjectUtils.disposeObject(this._shopItemCellTypeBg);
            this._shopItemCellTypeBg = null;
         }
         if(Boolean(this._payPaneBuyBtnHotArea))
         {
            ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
            this._payPaneBuyBtnHotArea = null;
         }
         if(Boolean(this._itemCountTxt))
         {
            this._itemCountTxt = null;
         }
         if(Boolean(this._itemNameTxt))
         {
            this._itemNameTxt = null;
         }
         if(Boolean(this._itemPriceTxt))
         {
            this._itemPriceTxt = null;
         }
         if(Boolean(this._labelIcon))
         {
            this._labelIcon = null;
         }
         if(Boolean(this._payType))
         {
            this._payType = null;
         }
         if(Boolean(this._itemCellBtn))
         {
            this._itemCellBtn = null;
         }
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo = null;
         }
         if(Boolean(this._payPaneGivingBtn))
         {
            this._payPaneGivingBtn = null;
         }
         if(Boolean(this._payPaneBuyBtn))
         {
            this._payPaneBuyBtn = null;
         }
      }
   }
}

