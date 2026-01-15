package auctionHouse.view
{
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.model.AuctionHouseModel;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import shop.view.ShopPresentClearingFrame;
   
   public class FastAuctionView extends Frame
   {
      
      private var _view:Sprite = new Sprite();
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _data:AuctionGoodsInfo;
      
      private var _bidMoney:BidMoneyView;
      
      private var _mouthfulBtn:BaseButton;
      
      private var _bidBtn:BaseButton;
      
      private var _askBtn:BaseButton;
      
      private var _givingBtn:BaseButton;
      
      private var giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _friendInfo:Object;
      
      private var _btClickLock:Boolean;
      
      private var _isUpdating:Boolean;
      
      private var _isAsk:Boolean;
      
      public function FastAuctionView(data:AuctionGoodsInfo, controller:AuctionHouseController, model:AuctionHouseModel)
      {
         this._data = data;
         this._controller = controller;
         this._model = model;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var itemInfo:ItemTemplateInfo = null;
         var cell:BagCell = null;
         addToContent(this._view);
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.fastAuctionBg");
         this._view.addChild(bg);
         itemInfo = this._data.BagItemInfo as ItemTemplateInfo;
         cell = new BagCell(0,itemInfo,false,null,false);
         cell.setContentSize(72,72);
         cell.setBgVisible(false);
         cell._tbxCount.x = 54;
         cell._tbxCount.y = 52;
         this._view.addChild(cell);
         PositionUtils.setPos(cell,"asset.ddtauction.fastAuctionItemPos");
         var itemNameTxt:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.itemName");
         itemNameTxt.text = itemInfo.Name;
         this._view.addChild(itemNameTxt);
         var endTime:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.endTimeTxt");
         endTime.text = this._data.getSithTimeDescription();
         this._view.addChild(endTime);
         this._givingBtn = ComponentFactory.Instance.creat("ddtauction.FastAuction.givingBtn");
         this._view.addChild(this._givingBtn);
         this._askBtn = ComponentFactory.Instance.creat("ddtauction.FastAuction.askBtn");
         this._view.addChild(this._askBtn);
         this._bidBtn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         PositionUtils.setPos(this._bidBtn,"asset.ddtauction.fastAuctionbidBtn");
         this._view.addChild(this._bidBtn);
         this._mouthfulBtn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         PositionUtils.setPos(this._mouthfulBtn,"asset.ddtauction.fastAuctionMouthfulBtn");
         this._view.addChild(this._mouthfulBtn);
         var money:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.money");
         money.text = String(PlayerManager.Instance.Self.Money);
         this._view.addChild(money);
         titleText = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.fastAuctionTitle");
         var numberTxt:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         numberTxt.text = this._data.BagItemInfo.Count + "";
         PositionUtils.setPos(numberTxt,"asset.ddtauction.fastAuctionNumber");
         this._view.addChild(numberTxt);
         var priceTxt:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         priceTxt.text = this._data.Price + "";
         PositionUtils.setPos(priceTxt,"asset.ddtauction.fastAuctionPrice");
         this._view.addChild(priceTxt);
         var mouthfulTxt:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         mouthfulTxt.text = this._data.Mouthful + "";
         PositionUtils.setPos(mouthfulTxt,"asset.ddtauction.fastAuctionMouthful");
         this._view.addChild(mouthfulTxt);
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this.initialiseBtn();
         this.init_FUL_BID_btnStatue();
         this._mouthfulBtn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bidBtn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._askBtn.addEventListener(MouseEvent.CLICK,this.askHander);
         this._givingBtn.addEventListener(MouseEvent.CLICK,this.sendHander);
      }
      
      private function initialiseBtn() : void
      {
         this._mouthfulBtn.enable = false;
         this._bidBtn.enable = false;
         this._bidMoney.cannotBid();
      }
      
      private function getMouthful() : int
      {
         return Boolean(this._data.Mouthful) ? this._data.Mouthful : 0;
      }
      
      private function __mouthFull(event:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this.getMouthful() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthfulBtn.enable = false;
               this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               BaglockedManager.Instance.show();
               return;
            }
            this._mouthfulBtn.enable = false;
            this._bidBtn.enable = false;
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _responseIV(evt:FrameEvent) : void
      {
         this._checkResponse(evt.responseCode,this.__mouthFullOk,this.__cancel);
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         ObjectUtils.disposeObject(evt.target);
         this._isUpdating = false;
      }
      
      private function __mouthFullOk() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
               this._bidBtn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Your") + String(this.getMouthful()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               return;
            }
            var info:AuctionGoodsInfo = this._data;
            if(info && info.AuctionID && Boolean(info.Mouthful))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,info.Mouthful);
               IMController.Instance.saveRecentContactsID(info.AuctioneerID);
               this._bidMoney.cannotBid();
               this.dispose();
            }
            return;
         }
      }
      
      private function __cancel() : void
      {
         this.init_FUL_BID_btnStatue();
      }
      
      private function init_FUL_BID_btnStatue() : void
      {
         this._bidBtn.enable = false;
         this._bidBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mouthfulBtn.enable = false;
         this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(this._isUpdating)
         {
            return;
         }
         var info:AuctionGoodsInfo = this._data;
         if(info == null || info.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(info.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._givingBtn.enable = this._askBtn.enable = this._mouthfulBtn.enable = this._mouthfulBtn.enable = info.Mouthful == 0 ? false : true;
            this._askBtn.filters = this._givingBtn.filters = this._mouthfulBtn.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            return;
         }
         this._givingBtn.enable = this._askBtn.enable = this._mouthfulBtn.enable = this._mouthfulBtn.enable = info.Mouthful == 0 ? false : true;
         this._askBtn.filters = this._givingBtn.filters = this._mouthfulBtn.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
         this._bidBtn.enable = true;
         if(info.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
      }
      
      private function getBidPrice() : int
      {
         var info:AuctionGoodsInfo = this._data;
         if(Boolean(info))
         {
            return info.BuyerName == "" ? info.Price : info.Price + info.Rise;
         }
         return 0;
      }
      
      private function _checkResponse(keyCode:int, submitFun:Function = null, cancelFun:Function = null, closeFun:Function = null) : void
      {
         SoundManager.instance.play("008");
         switch(keyCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               submitFun();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               cancelFun();
         }
      }
      
      private function checkPlayerMoney() : void
      {
         var info:AuctionGoodsInfo = this._data;
         this._bidBtn.enable = false;
         this._mouthfulBtn.enable = false;
         if(info == null)
         {
            return;
         }
         if(info.Mouthful != 0 && this.getMouthful() <= PlayerManager.Instance.Self.Money)
         {
            this._mouthfulBtn.enable = true;
         }
      }
      
      private function __bid(event:MouseEvent) : void
      {
         var alert1:AuctionInputFrame = null;
         var _bidKeyUp:Function = null;
         var _responseII:Function = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this._data.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
         if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            _bidKeyUp = function(e:Event):void
            {
               SoundManager.instance.play("008");
               __bidOk();
               alert1.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(alert1);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            _responseII = function(evt:FrameEvent):void
            {
               SoundManager.instance.play("008");
               _checkResponse(evt.responseCode,__bidOk,__cancel);
               var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
               alert.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(evt.target);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            this.checkPlayerMoney();
            this._bidBtn.enable = false;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthfulBtn.enable = false;
               this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._bidBtn.enable = true;
               BaglockedManager.Instance.show();
               return;
            }
            alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
            LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            alert1.addToContent(this._bidMoney);
            this._bidMoney.money.setFocus();
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE,_responseII);
            this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP,_bidKeyUp);
         }
      }
      
      private function __bidOk() : void
      {
         this._isUpdating = true;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getBidPrice() > this._bidMoney.getData())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.Auction") + String(this.getBidPrice()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               this._bidBtn.enable = true;
               return;
            }
            if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
               this._bidBtn.enable = true;
               LeavePageManager.showFillFrame();
               return;
            }
            if(this.getMouthful() != 0 && this._bidMoney.getData() >= this.getMouthful())
            {
               this._btClickLock = true;
               this._mouthfulBtn.enable = false;
               this._bidBtn.enable = false;
               this.__mouthFullOk();
               return;
            }
            var info:AuctionGoodsInfo = this._data;
            if(Boolean(info))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,this._bidMoney.getData());
               IMController.Instance.saveRecentContactsID(info.AuctioneerID);
               info = null;
               this.dispose();
            }
            return;
         }
      }
      
      protected function sendHander(event:MouseEvent) : void
      {
         if(Boolean(this.giveFriendOpenFrame))
         {
            this.giveFriendOpenFrame.dispose();
            this.giveFriendOpenFrame = null;
         }
         this._isAsk = false;
         this.giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this.giveFriendOpenFrame.nameInput.enable = true;
         this.giveFriendOpenFrame.titleTxt.visible = false;
         this.giveFriendOpenFrame.setType();
         this.giveFriendOpenFrame.show();
         this.giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick,false,0,true);
         this.giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
      }
      
      private function responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this;
         }
      }
      
      protected function askHander(event:MouseEvent) : void
      {
         if(Boolean(this.giveFriendOpenFrame))
         {
            this.giveFriendOpenFrame.dispose();
            this.giveFriendOpenFrame = null;
         }
         this._isAsk = true;
         this.giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this.giveFriendOpenFrame.nameInput.enable = true;
         this.giveFriendOpenFrame.titleTxt.visible = false;
         this.giveFriendOpenFrame.setType(ShopPresentClearingFrame.FPAYTYPE_PAIMAI);
         this.giveFriendOpenFrame.show();
         this.giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick,false,0,true);
         this.giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
      }
      
      private function presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var name:String = this.giveFriendOpenFrame.nameInput.text;
         var info:AuctionGoodsInfo = this._data;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         if(this._isAsk)
         {
            SocketManager.Instance.out.requestAuctionPay(info.AuctionID,this.giveFriendOpenFrame.Name,this.giveFriendOpenFrame.textArea.text);
         }
         else if(!BuriedManager.Instance.checkMoney(false,info.Mouthful))
         {
            SocketManager.Instance.out.sendForAuction(info.AuctionID,this.giveFriendOpenFrame.Name);
         }
         this._friendInfo = {};
         this._friendInfo["id"] = this.giveFriendOpenFrame.selectPlayerId;
         this._friendInfo["name"] = name;
         this._friendInfo["msg"] = FilterWordManager.filterWrod(this.giveFriendOpenFrame.textArea.text);
         this.giveFriendOpenFrame.dispose();
         this.giveFriendOpenFrame = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._controller))
         {
            this._controller.disposeMe();
            this._controller = null;
         }
         this._model = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeAllChildren(this._view);
         }
         this._view = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

