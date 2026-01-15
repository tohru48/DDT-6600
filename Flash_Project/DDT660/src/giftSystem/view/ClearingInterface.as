package giftSystem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.NameInputDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   import giftSystem.element.ChooseNum;
   import giftSystem.element.GiftCartItem;
   
   public class ClearingInterface extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bg3:MutipleImage;
      
      private var _bg4:MutipleImage;
      
      private var _chooseFriendBtn:TextButton;
      
      private var _nameInput:NameInputDropListTarget;
      
      private var _dropList:DropList;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _buyMoneyBtn:BaseButton;
      
      private var _presentBtn:BaseButton;
      
      private var _totalMoney:FilterFrameText;
      
      private var _poorMoney:FilterFrameText;
      
      private var _giftNum:FilterFrameText;
      
      private var _giftCartItem:GiftCartItem;
      
      private var _moneyIsEnough:ScaleFrameImage;
      
      private var _NeedPay:FilterFrameText;
      
      private var _HavePay:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _moneyTxt1:FilterFrameText;
      
      private var _comboBoxLabel:FilterFrameText;
      
      private var _buyTxt:FilterFrameText;
      
      private var _info:ShopItemInfo;
      
      public function ClearingInterface()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this.titleText = LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.background1");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.TotalMoneyPanel");
         this._bg4 = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.TotalMoneyPanel1");
         this._chooseFriendBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtgiftSystem.PresentFrame.ChooseFriendBtn");
         this._chooseFriendBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.ChooseFriendButtonText");
         this._comboBoxLabel = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ComboBoxLabel");
         this._comboBoxLabel.text = LanguageMgr.GetTranslation("shop.PresentFrame.ComboBoxLabel");
         PositionUtils.setPos(this._comboBoxLabel,"giftSystem.comboBoxLabelPos");
         this._nameInput = ComponentFactory.Instance.creatCustomObject("ClearingInterface.nameInput");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         this._moneyIsEnough = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.isEnoughImage");
         this._buyMoneyBtn = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.buyMoney");
         this._presentBtn = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.present");
         this._totalMoney = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.totalMoney");
         this._poorMoney = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.poorMoney");
         this._giftNum = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.giftNum");
         this._giftCartItem = ComponentFactory.Instance.creatCustomObject("giftCartItem");
         this._NeedPay = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._NeedPay.text = LanguageMgr.GetTranslation("shop.RechargeView.NeedToPayText");
         PositionUtils.setPos(this._NeedPay,"giftSystem.NeedPayTextPos");
         this._HavePay = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._HavePay.text = LanguageMgr.GetTranslation("shop.RechargeView.HaveOwnText");
         PositionUtils.setPos(this._HavePay,"giftSystem.HavePayTextPos");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._moneyTxt.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
         PositionUtils.setPos(this._moneyTxt,"giftSystem.moneyPayTextPos");
         this._moneyTxt1 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._moneyTxt1.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
         PositionUtils.setPos(this._moneyTxt1,"giftSystem.moneyPayTextPosOne");
         this._buyTxt = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.buyText");
         this._buyTxt.text = LanguageMgr.GetTranslation("shop.RechargeView.BuyText");
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         addToContent(this._bg);
         addToContent(this._bg3);
         addToContent(this._bg4);
         addToContent(this._chooseFriendBtn);
         addToContent(this._nameInput);
         addToContent(this._buyMoneyBtn);
         addToContent(this._presentBtn);
         addToContent(this._totalMoney);
         addToContent(this._poorMoney);
         addToContent(this._NeedPay);
         addToContent(this._HavePay);
         addToContent(this._moneyTxt);
         addToContent(this._moneyTxt1);
         addToContent(this._giftNum);
         addToContent(this._giftCartItem);
         addToContent(this._comboBoxLabel);
         addToContent(this._buyTxt);
         this._moneyIsEnough.setFrame(1);
      }
      
      private function selectName(nick:String, id:int = 0) : void
      {
         this.setName(nick);
         this._friendList.setVisible = false;
      }
      
      public function setName(value:String) : void
      {
         this._nameInput.text = value;
      }
      
      public function set info(value:ShopItemInfo) : void
      {
         if(this._info == value)
         {
            return;
         }
         this._info = value;
         this.updateMoneyType();
         this._giftCartItem.info = this._info;
         this.__numberChange(null);
      }
      
      private function updateMoneyType() : void
      {
         switch(this._info.getItemPrice(1).PriceType)
         {
            case Price.MONEY:
               this._poorMoney.text = String(PlayerManager.Instance.Self.Money);
               this._moneyTxt.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
               this._moneyTxt1.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
               break;
            case Price.DDT_MONEY:
               this._poorMoney.text = String(PlayerManager.Instance.Self.BandMoney);
               this._moneyTxt.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
               this._moneyTxt1.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._chooseFriendBtn.addEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._buyMoneyBtn.addEventListener(MouseEvent.CLICK,this.__buyMoney);
         this._presentBtn.addEventListener(MouseEvent.CLICK,this.__present);
         this._giftCartItem.addEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__moneyChange);
         GiftController.Instance.addEventListener(GiftEvent.SEND_GIFT_RETURN,this.__sendRetrunHandler);
      }
      
      protected function __sendRetrunHandler(event:GiftEvent) : void
      {
         if(event.str == "true")
         {
            this.dispose();
         }
         else
         {
            this._presentBtn.enable = true;
         }
      }
      
      private function __numberChange(event:Event) : void
      {
         var total:int = 0;
         var poor:int = 0;
         switch(this._info.getItemPrice(1).PriceType)
         {
            case Price.DDT_MONEY:
               total = this._info.getItemPrice(1).bandDdtMoneyValue * this._giftCartItem.number;
               poor = PlayerManager.Instance.Self.BandMoney - total;
               break;
            case Price.MONEY:
               total = this._info.getItemPrice(1).moneyValue * this._giftCartItem.number;
               poor = PlayerManager.Instance.Self.Money - total;
         }
         this._totalMoney.text = total.toString();
         if(poor < 0)
         {
            this._moneyIsEnough.setFrame(2);
         }
         else
         {
            this._moneyIsEnough.setFrame(1);
         }
         this._giftNum.text = this._giftCartItem.number.toString();
      }
      
      private function __present(event:MouseEvent) : void
      {
         var confirm:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(parseInt(this._poorMoney.text) < 0)
         {
            confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            confirm.moveEnable = false;
            confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            return;
         }
         if(this._nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.inputName"));
            return;
         }
         if(this._giftCartItem.number <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.noEnoughMoney"));
            return;
         }
         if(this._nameInput.text == PlayerManager.Instance.Self.NickName)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.canNotYourSelf"));
            return;
         }
         if(this._info.Label == 6 && this._giftCartItem.number != 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.limit"));
            return;
         }
         SocketManager.Instance.out.sendBuyGift(this._nameInput.text,this._info.GoodsID,this._giftCartItem.number,1);
      }
      
      private function __buyMoney(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      private function __showFramePanel(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pos:Point = this._chooseFriendBtn.localToGlobal(new Point(0,0));
         this._friendList.x = pos.x - 95;
         this._friendList.y = pos.y + this._chooseFriendBtn.height;
         this._friendList.setVisible = true;
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._chooseFriendBtn.removeEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._buyMoneyBtn.removeEventListener(MouseEvent.CLICK,this.__buyMoney);
         this._presentBtn.removeEventListener(MouseEvent.CLICK,this.__present);
         this._giftCartItem.removeEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__moneyChange);
         GiftController.Instance.removeEventListener(GiftEvent.SEND_GIFT_RETURN,this.__sendRetrunHandler);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._dropList))
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(Boolean(this._friendList))
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         super.dispose();
         this.removeEvent();
         GiftController.Instance.rebackName = "";
         this._chooseFriendBtn = null;
         this._nameInput = null;
         this._dropList = null;
         this._buyMoneyBtn = null;
         this._presentBtn = null;
         this._totalMoney = null;
         this._poorMoney = null;
         this._giftNum = null;
         this._giftCartItem = null;
         this._moneyIsEnough = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __hideDropList(event:Event) : void
      {
         if(event.target is FilterFrameText)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      protected function __onReceiverChange(event:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var list:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(list),this._nameInput.text);
      }
      
      private function filterRepeatInArray(filterArr:Array) : Array
      {
         var j:int = 0;
         var arr:Array = new Array();
         for(var i:int = 0; i < filterArr.length; i++)
         {
            if(i == 0)
            {
               arr.push(filterArr[i]);
            }
            for(j = 0; j < arr.length; j++)
            {
               if(arr[j].NickName == filterArr[i].NickName)
               {
                  break;
               }
               if(j == arr.length - 1)
               {
                  arr.push(filterArr[i]);
               }
            }
         }
         return arr;
      }
      
      private function filterSearch(list:Array, targetStr:String) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].NickName.indexOf(targetStr) != -1)
            {
               result.push(list[i]);
            }
         }
         return result;
      }
      
      protected function __moneyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Money"]))
         {
            this.__numberChange(null);
         }
      }
      
      protected function __confirmResponse(event:FrameEvent) : void
      {
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(frame);
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
   }
}

