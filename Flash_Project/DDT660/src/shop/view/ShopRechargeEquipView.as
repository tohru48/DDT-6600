package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShopRechargeEquipView extends Sprite implements Disposeable
   {
      
      private var price:ItemPrice;
      
      private var _bg:Image;
      
      private var _frame:BaseAlerFrame;
      
      private var _chargeBtn:TextButton;
      
      private var _itemContainer:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _equipList:Array;
      
      private var _costMoneyTxt:FilterFrameText;
      
      private var _costGiftTxt:FilterFrameText;
      
      private var _playerMoneyTxt:FilterFrameText;
      
      private var _playerGiftTxt:FilterFrameText;
      
      private var _currentCountTxt:FilterFrameText;
      
      private var _affirmContinuBt:BaseButton;
      
      private var _needToPayPanelBg:Image;
      
      private var _haveOwnPanelBg:Image;
      
      private var _needToPayText:FilterFrameText;
      
      private var _haveOwnText:FilterFrameText;
      
      private var _leftTicketText:FilterFrameText;
      
      private var _rightTicketText:FilterFrameText;
      
      private var _leftGiftText:FilterFrameText;
      
      private var _rightGiftText:FilterFrameText;
      
      private var _amountOfItemTipText:FilterFrameText;
      
      private var _isBandList:Vector.<ShopRechargeEquipViewItem>;
      
      private var _leftOrderText:FilterFrameText;
      
      private var _rightOrderText:FilterFrameText;
      
      private var _playerOrderTxt:FilterFrameText;
      
      private var _costOrderTxt:FilterFrameText;
      
      public function ShopRechargeEquipView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrame");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrameBg");
         this._needToPayPanelBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.NeedToPayPanelBg");
         this._haveOwnPanelBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.HaveOwnPanelBg");
         this._amountOfItemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.AmountOfItemTipText");
         this._amountOfItemTipText.text = LanguageMgr.GetTranslation("shop.RechargeView.AmountOfItemTipText");
         this._needToPayText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.NeedToPayText");
         this._needToPayText.text = LanguageMgr.GetTranslation("shop.RechargeView.NeedToPayText");
         this._haveOwnText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.HaveOwnText");
         this._haveOwnText.text = LanguageMgr.GetTranslation("shop.RechargeView.HaveOwnText");
         this._leftTicketText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftTicketText");
         this._leftTicketText.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
         this._leftGiftText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftGiftText");
         this._leftGiftText.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
         this._leftOrderText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftOrderText");
         this._leftOrderText.text = LanguageMgr.GetTranslation("newDdtMoney");
         this._leftOrderText.visible = false;
         this._rightTicketText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightTicketText");
         this._rightTicketText.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
         this._rightGiftText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightGiftText");
         this._rightGiftText.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
         this._rightOrderText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightOrderText");
         this._rightOrderText.text = LanguageMgr.GetTranslation("newDdtMoney");
         this._rightOrderText.visible = false;
         this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeBtn");
         this._chargeBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.RechargeBtnText");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewItemList");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemContainer");
         this._costMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftTicketNumberText");
         this._costGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftGiftNumberText");
         this._costOrderTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftOrderNumberText");
         this._playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightTicketNumberText");
         this._playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightGiftNumberText");
         this._playerOrderTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightOrderNumberText");
         this._currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewCurrentCount");
         this._affirmContinuBt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeConfirmationBtn");
         var ai:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.continuation.contiuationTitle"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu"),LanguageMgr.GetTranslation("cancel"),false,false);
         this._frame.info = ai;
         this._equipList = PlayerManager.Instance.Self.OvertimeListByBody;
         this._scrollPanel.vScrollProxy = ScrollPanel.ON;
         this._scrollPanel.setView(this._itemContainer);
         this._itemContainer.spacing = 5;
         this._itemContainer.strictSize = 100;
         this._scrollPanel.invalidateViewport();
         this._frame.moveEnable = false;
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._needToPayPanelBg);
         this._frame.addToContent(this._haveOwnPanelBg);
         this._frame.addToContent(this._amountOfItemTipText);
         this._frame.addToContent(this._needToPayText);
         this._frame.addToContent(this._haveOwnText);
         this._frame.addToContent(this._leftTicketText);
         this._frame.addToContent(this._leftGiftText);
         this._frame.addToContent(this._leftOrderText);
         this._frame.addToContent(this._rightTicketText);
         this._frame.addToContent(this._rightGiftText);
         this._frame.addToContent(this._rightOrderText);
         this._frame.addToContent(this._chargeBtn);
         this._frame.addToContent(this._scrollPanel);
         this._frame.addToContent(this._costMoneyTxt);
         this._frame.addToContent(this._costGiftTxt);
         this._frame.addToContent(this._costOrderTxt);
         this._frame.addToContent(this._playerMoneyTxt);
         this._frame.addToContent(this._playerGiftTxt);
         this._frame.addToContent(this._playerOrderTxt);
         this._frame.addToContent(this._currentCountTxt);
         this._frame.addToContent(this._affirmContinuBt);
         this.setList();
         this.__onPlayerPropertyChange();
         this._chargeBtn.addEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._affirmContinuBt.addEventListener(MouseEvent.CLICK,this._clickContinuBt);
         addChild(this._frame);
      }
      
      private function __frameEventHandler(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
               }
               else
               {
                  this.payAll();
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               InventoryItemInfo.startTimer();
               this.dispose();
         }
      }
      
      private function _clickContinuBt(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var money:int = int(this._costMoneyTxt.text);
         var bandMoney:int = int(this._costGiftTxt.text);
         var orderMoney:int = int(this._costOrderTxt.text);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         if(money > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(bandMoney > PlayerManager.Instance.Self.BandMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
            return;
         }
         this.payAll();
      }
      
      private function __onChargeClick(e:Event) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function payAll() : void
      {
         var payArr:Array = null;
         var infoArr:Array = null;
         var removeArr:Array = null;
         var j:ShopCarItemInfo = null;
         var k:ShopRechargeEquipViewItem = null;
         var i:int = 0;
         var index:uint = 0;
         var item:ShopRechargeEquipViewItem = null;
         var isDress:Boolean = false;
         var shopInfoListArr:Array = this.shopInfoList;
         var buyArr:Array = ShopManager.Instance.buyIt(this.shopInfoListWithOutDelete);
         if(this.shopInfoListWithOutDelete.length > 0)
         {
            payArr = new Array();
            infoArr = new Array();
            removeArr = new Array();
            for each(j in this.shopInfoListWithOutDelete)
            {
               index = uint(shopInfoListArr.indexOf(j));
               item = this._itemContainer.getChildAt(index) as ShopRechargeEquipViewItem;
               infoArr.push(item.info);
               removeArr.push(item);
            }
            for each(k in removeArr)
            {
               this._itemContainer.removeChild(k);
            }
            this._scrollPanel.invalidateViewport();
            for(i = 0; i < infoArr.length; i++)
            {
               isDress = infoArr[i].Place <= 30;
               payArr.push([infoArr[i].BagType,infoArr[i].Place,buyArr[i].GoodsID,buyArr[i].currentBuyType,isDress,this._isBandList[i].moneType]);
            }
            this.updateTxt();
            SocketManager.Instance.out.sendGoodsContinue(payArr);
            if(this._itemContainer.numChildren <= 0)
            {
               this.dispose();
            }
            else if(this.shopInfoListWithOutDelete.length > 0)
            {
               this.showAlert();
            }
         }
         else if(this.shopInfoListWithOutDelete.length != 0)
         {
            this.showAlert();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.continuation.contiuationFailed"));
         }
      }
      
      private function setList() : void
      {
         var t_i:int;
         var i:InventoryItemInfo = null;
         var item:ShopRechargeEquipViewItem = null;
         this._equipList.sort(function(a:InventoryItemInfo, b:InventoryItemInfo):Number
         {
            var sort_arr:Array = [7,5,1,17,8,9,14,6,13,15,3,4,2];
            var a_index:uint = uint(sort_arr.indexOf(a.CategoryID));
            var b_index:uint = uint(sort_arr.indexOf(b.CategoryID));
            if(a_index < b_index)
            {
               return -1;
            }
            if(a_index == b_index)
            {
               return 0;
            }
            return 1;
         });
         this._isBandList = new Vector.<ShopRechargeEquipViewItem>();
         t_i = 0;
         for each(i in this._equipList)
         {
            if(ShopManager.Instance.canAddPrice(i.TemplateID))
            {
               item = new ShopRechargeEquipViewItem();
               item.itemInfo = i;
               item.clieckHander = this.setIsBandList;
               item.id = t_i;
               this._isBandList.push(item);
               item.setColor(i.Color);
               item.addEventListener(ShopCartItem.DELETE_ITEM,this.__onItemDelete);
               item.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__onItemChange);
               this._itemContainer.addChild(item);
               t_i++;
            }
         }
         this._scrollPanel.invalidateViewport();
         this.updateTxt();
      }
      
      private function setIsBandList(id:int, _type:int) : void
      {
         var len:int = int(this._isBandList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this._isBandList[i].id == id)
            {
               this._isBandList[i].moneType = _type;
               return;
            }
         }
      }
      
      private function __onItemDelete(e:Event) : void
      {
      }
      
      private function __onItemChange(e:Event) : void
      {
         this.updateTxt();
      }
      
      private function get shopInfoListWithOutDelete() : Array
      {
         var item:ShopRechargeEquipViewItem = null;
         var arr:Array = new Array();
         this._isBandList = new Vector.<ShopRechargeEquipViewItem>();
         var len:int = this._itemContainer.numChildren - 1;
         for(var i:uint = 0; i < this._itemContainer.numChildren; i++)
         {
            item = this._itemContainer.getChildAt(len - i) as ShopRechargeEquipViewItem;
            if(Boolean(item) && !item.isDelete)
            {
               arr.push(item.shopItemInfo);
               this._isBandList.push(item);
            }
         }
         return arr;
      }
      
      private function get shopInfoList() : Array
      {
         var item:ShopRechargeEquipViewItem = null;
         var arr:Array = new Array();
         for(var i:uint = 0; i < this._itemContainer.numChildren; i++)
         {
            item = this._itemContainer.getChildAt(i) as ShopRechargeEquipViewItem;
            arr.push(item.shopItemInfo);
         }
         return arr;
      }
      
      private function updateTxt() : void
      {
         var i:ShopCarItemInfo = null;
         var arr:Array = this.shopInfoListWithOutDelete;
         var count:uint = arr.length;
         this._currentCountTxt.text = String(count);
         if(count == 0)
         {
            this._affirmContinuBt.enable = false;
         }
         else
         {
            this._affirmContinuBt.enable = true;
         }
         this._frame.submitButtonEnable = count <= 0 ? false : true;
         this.price = new ItemPrice(null,null,null);
         var t_i:int = 0;
         for each(i in arr)
         {
            this.price.addItemPrice(i.getCurrentPrice(),false,this._isBandList[t_i].moneType);
            t_i++;
         }
         this._costMoneyTxt.text = String(this.price.moneyValue);
         this._costGiftTxt.text = String(this.price.bandDdtMoneyValue);
         this.updataTextColor();
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange,false,0,true);
      }
      
      private function __onPlayerPropertyChange(e:Event = null) : void
      {
         this._playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this._playerGiftTxt.text = String(PlayerManager.Instance.Self.BandMoney);
         this.updataTextColor();
      }
      
      private function updataTextColor() : void
      {
         if(Boolean(this.price))
         {
            if(this.price.moneyValue > PlayerManager.Instance.Self.Money)
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
            }
            else
            {
               this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
            }
            if(this.price.bandDdtMoneyValue > PlayerManager.Instance.Self.BandMoney)
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
            }
            else
            {
               this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
            }
            this._costOrderTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
         }
      }
      
      private function showAlert() : void
      {
         var frame:BaseAlerFrame = null;
         if(this.price.moneyValue > PlayerManager.Instance.Self.Money)
         {
            frame = LeavePageManager.showFillFrame();
         }
      }
      
      public function dispose() : void
      {
         InventoryItemInfo.startTimer();
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._chargeBtn.removeEventListener(MouseEvent.CLICK,this.__onChargeClick);
         this._affirmContinuBt.removeEventListener(MouseEvent.CLICK,this._clickContinuBt);
         this._frame.dispose();
         this._frame = null;
         this.price = null;
         this._bg = null;
         ObjectUtils.disposeObject(this._amountOfItemTipText);
         this._amountOfItemTipText = null;
         ObjectUtils.disposeObject(this._needToPayPanelBg);
         this._needToPayPanelBg = null;
         ObjectUtils.disposeObject(this._haveOwnPanelBg);
         this._haveOwnPanelBg = null;
         ObjectUtils.disposeObject(this._needToPayText);
         this._needToPayText = null;
         ObjectUtils.disposeObject(this._haveOwnText);
         this._haveOwnText = null;
         ObjectUtils.disposeObject(this._leftTicketText);
         this._leftTicketText = null;
         ObjectUtils.disposeObject(this._leftGiftText);
         this._leftGiftText = null;
         ObjectUtils.disposeObject(this._rightTicketText);
         this._rightTicketText = null;
         ObjectUtils.disposeObject(this._rightGiftText);
         this._rightGiftText = null;
         this._chargeBtn = null;
         this._itemContainer = null;
         this._scrollPanel = null;
         this._equipList = null;
         this._costMoneyTxt = null;
         this._costGiftTxt = null;
         this._playerMoneyTxt = null;
         this._playerGiftTxt = null;
         this._currentCountTxt = null;
         this._affirmContinuBt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

