package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddtBuried.BuriedManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import im.IMController;
   import shop.view.BuySingleGoodsView;
   import shop.view.ShopPresentClearingFrame;
   
   public class AuctionBrowseView extends Sprite implements Disposeable
   {
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _list:BrowseLeftMenuView;
      
      private var _bidMoney:BidMoneyView;
      
      private var _bid_btn:BaseButton;
      
      private var _mouthful_btn:BaseButton;
      
      private var _bid_btnR:TextButton;
      
      private var _mouthfulAndbid:ScaleBitmapImage;
      
      private var _mouthful_btnR:TextButton;
      
      private var _btClickLock:Boolean;
      
      private var _isSearch:Boolean;
      
      private var _right:AuctionRightView;
      
      private var _isUpdating:Boolean;
      
      private var _askBtn:TextButton;
      
      private var _sendBtn:TextButton;
      
      private var giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _friendInfo:Object;
      
      private var view:BuySingleGoodsView;
      
      private var _isAsk:Boolean;
      
      public function AuctionBrowseView(controller:AuctionHouseController, model:AuctionHouseModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         addChild(this._bid_btn);
         this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         addChild(this._mouthful_btn);
         this._bid_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Bid_btnR");
         this._bid_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.bid");
         this._mouthful_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Mouthful_btnR");
         this._mouthful_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this._askBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.ask_btnR");
         this._askBtn.text = LanguageMgr.GetTranslation("shop.ShopIIPresentView.ask");
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Send_btnR");
         this._sendBtn.text = LanguageMgr.GetTranslation("shop.ShopIIPresentView.send");
         this._list = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BrowseLeftMenuView");
         addChild(this._list);
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
         this._right.setup(AuctionState.BROWSE);
         addChild(this._right);
         this.initialiseBtn();
         this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
         this._mouthfulAndbid.addChild(this._bid_btnR);
         this._mouthfulAndbid.addChild(this._mouthful_btnR);
         this._mouthfulAndbid.addChild(this._askBtn);
         this._mouthfulAndbid.addChild(this._sendBtn);
         addChild(this._mouthfulAndbid);
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
         this._mouthfulAndbid.visible = false;
      }
      
      private function initialiseBtn() : void
      {
         this._mouthful_btn.enable = false;
         this._bid_btn.enable = false;
         this._bidMoney.cannotBid();
      }
      
      private function addEvent() : void
      {
         this._right.prePage_btn.addEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.addEventListener(MouseEvent.CLICK,this.__next);
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._list.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectLeftStrip);
         this._askBtn.addEventListener(MouseEvent.CLICK,this.askHander);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.sendHander);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bid_btnR.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,this.__updateAuction);
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
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
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
      
      private function responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this;
         }
      }
      
      private function removeEvent() : void
      {
         this._askBtn.removeEventListener(MouseEvent.CLICK,this.askHander);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.sendHander);
         this._right.prePage_btn.removeEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK,this.__next);
         this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._list.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectLeftStrip);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bid_btnR.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,this.__updateAuction);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(evt.target);
      }
      
      internal function addAuction(info:AuctionGoodsInfo) : void
      {
         if(AuctionHouseModel._dimBooble != true)
         {
            this._right.addAuction(info);
         }
      }
      
      internal function updateAuction(info:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(info);
         this.__selectRightStrip(null);
      }
      
      internal function removeAuction() : void
      {
         this.__searchCondition(null);
      }
      
      internal function hideReady() : void
      {
         this._right.hideReady();
      }
      
      internal function clearList() : void
      {
         if(AuctionHouseModel._dimBooble == true)
         {
            this._list.setFocusName();
            return;
         }
         this._right.clearList();
         this.__selectRightStrip(null);
      }
      
      internal function setCategory(value:Vector.<CateCoryInfo>) : void
      {
         this._list.setCategory(value);
      }
      
      internal function setPage(start:int, totalCount:int) : void
      {
         this._right.setPage(start,totalCount);
      }
      
      internal function setSelectType(type:CateCoryInfo) : void
      {
         this.initialiseBtn();
         this._list.setSelectType(type);
      }
      
      internal function getLeftInfo() : CateCoryInfo
      {
         return this._list.getInfo();
      }
      
      internal function setTextEmpty() : void
      {
         this._list.searchText = "";
      }
      
      internal function getPayType() : int
      {
         return -1;
      }
      
      internal function searchByCurCondition(currentPage:int, playerID:int = -1) : void
      {
         if(playerID != -1)
         {
            this._controller.searchAuctionList(currentPage,"",this._list.getType(),-1,playerID,-1,this._right.sortCondition,this._right.sortBy.toString());
            return;
         }
         if(this._isSearch)
         {
            this._controller.searchAuctionList(currentPage,this._list.searchText,this._list.getType(),this.getPayType(),playerID,-1,this._right.sortCondition,this._right.sortBy.toString());
         }
         else
         {
            this._controller.searchAuctionList(currentPage,this._list.searchText,this._list.getType(),-1,playerID,-1,this._right.sortCondition,this._right.sortBy.toString());
         }
         this._bidMoney.cannotBid();
      }
      
      private function getBidPrice() : int
      {
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(Boolean(info))
         {
            return info.BuyerName == "" ? info.Price : info.Price + info.Rise;
         }
         return 0;
      }
      
      private function getPrice() : int
      {
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         return Boolean(info) ? info.Price : 0;
      }
      
      private function getMouthful() : int
      {
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         return Boolean(info) ? info.Mouthful : 0;
      }
      
      private function __searchCondition(event:MouseEvent) : void
      {
         this._isSearch = true;
         if(this._list.getInfo() == null)
         {
            this._controller.browseTypeChangeNull();
         }
         else
         {
            this._controller.browseTypeChange(this._list.getInfo());
         }
      }
      
      private function keyEnterHandler(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            this.__searchCondition(null);
         }
      }
      
      private function __next(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
      }
      
      private function __pre(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
      }
      
      private function __selectLeftStrip(event:AuctionHouseEvent) : void
      {
         this._isSearch = false;
         this._controller.browseTypeChange(this._list.getInfo());
      }
      
      private function __selectRightStrip(event:AuctionHouseEvent) : void
      {
         this._mouthfulAndbid.x = this.globalToLocal(new Point(mouseX,mouseY)).x - 10;
         this._mouthfulAndbid.y = this.globalToLocal(new Point(mouseX,mouseY)).y - 10;
         if(this._mouthfulAndbid.x > stage.stageWidth - this._mouthfulAndbid.width)
         {
            this._mouthfulAndbid.x = this._mouthfulAndbid.x - this._mouthfulAndbid.width + 20;
         }
         this._bid_btnR.enable = false;
         this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mouthful_btnR.enable = false;
         this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this.setChildIndex(this._mouthfulAndbid,this.numChildren - 1);
         if(this._isUpdating)
         {
            return;
         }
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(info == null || info.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(info.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._mouthfulAndbid.visible = true;
            this._sendBtn.enable = this._askBtn.enable = this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
            this._askBtn.filters = this._sendBtn.filters = this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            return;
         }
         if(Boolean(event) && event.currentTarget == this._right)
         {
            this._mouthfulAndbid.visible = true;
         }
         this._sendBtn.enable = this._askBtn.enable = this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
         this._askBtn.filters = this._sendBtn.filters = this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
         if(info.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
         if(Boolean(event))
         {
            this._bid_btnR.enable = this._bid_btn.enable = true;
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      private function init_FUL_BID_btnStatue() : void
      {
         this._bid_btnR.enable = false;
         this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mouthful_btnR.enable = false;
         this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(this._isUpdating)
         {
            return;
         }
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(info == null || info.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(info.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
            this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            return;
         }
         this._sendBtn.enable = this._askBtn.enable = this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
         this._askBtn.filters = this._sendBtn.filters = this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
         this._bid_btn.enable = true;
         if(info.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
      }
      
      private function __bid(event:MouseEvent) : void
      {
         var alert1:AuctionInputFrame = null;
         var _bidKeyUp:Function = null;
         var _responseII:Function = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this._right.getSelectInfo().PayType == 0)
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
            this._bid_btn.enable = false;
            this._mouthfulAndbid.visible = false;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthful_btnR.enable = false;
               this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._bid_btn.enable = true;
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
      
      private function _cancelFun() : void
      {
      }
      
      private function __mouthFull(event:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         this._mouthfulAndbid.visible = false;
         if(this.getMouthful() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthful_btnR.enable = false;
               this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               BaglockedManager.Instance.show();
               return;
            }
            this._mouthful_btn.enable = false;
            this._bid_btn.enable = false;
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _mouthfulAndbidOver(e:MouseEvent) : void
      {
         this._mouthfulAndbid.visible = false;
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
      }
      
      private function _responseIV(evt:FrameEvent) : void
      {
         this._checkResponse(evt.responseCode,this.__mouthFullOk,this.__cancel);
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         ObjectUtils.disposeObject(evt.target);
         this._isUpdating = false;
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
               this._bid_btn.enable = true;
               return;
            }
            if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
               this._bid_btn.enable = true;
               LeavePageManager.showFillFrame();
               return;
            }
            if(this.getMouthful() != 0 && this._bidMoney.getData() >= this.getMouthful())
            {
               this._btClickLock = true;
               this._mouthful_btn.enable = false;
               this._bid_btn.enable = false;
               this.__mouthFullOk();
               return;
            }
            var info:AuctionGoodsInfo = this._right.getSelectInfo();
            if(Boolean(info))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,this._bidMoney.getData());
               IMController.Instance.saveRecentContactsID(info.AuctioneerID);
               info = null;
            }
            return;
         }
      }
      
      private function __cancel() : void
      {
         this.init_FUL_BID_btnStatue();
      }
      
      private function checkPlayerMoney() : void
      {
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
         if(info == null)
         {
            return;
         }
         if(info.Mouthful != 0 && this.getMouthful() <= PlayerManager.Instance.Self.Money)
         {
            this._mouthful_btn.enable = true;
         }
      }
      
      private function __mouthFullOk() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
               this._bid_btn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Your") + String(this.getMouthful()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               return;
            }
            var info:AuctionGoodsInfo = this._right.getSelectInfo();
            if(info && info.AuctionID && Boolean(info.Mouthful))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,info.Mouthful);
               IMController.Instance.saveRecentContactsID(info.AuctioneerID);
               this._right.clearSelectStrip();
               this._right.setSelectEmpty();
               this._bidMoney.cannotBid();
               this.searchByCurCondition(this._model.browseCurrent);
            }
            return;
         }
      }
      
      private function __updateAuction(evt:CrazyTankSocketEvent) : void
      {
         var auctionID:int = 0;
         var succes:Boolean = evt.pkg.readBoolean();
         if(succes)
         {
            auctionID = evt.pkg.readInt();
            if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
            {
               SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
            }
            SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].push(auctionID);
            SharedManager.Instance.save();
         }
         this._isUpdating = false;
      }
      
      private function __addToStage(event:Event) : void
      {
         this.initialiseBtn();
         this._bidMoney.cannotBid();
         this._right.addStageInit();
      }
      
      private function sortChange(e:AuctionHouseEvent) : void
      {
         this.__searchCondition(null);
      }
      
      public function get Right() : AuctionRightView
      {
         return this._right;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         ObjectUtils.disposeObject(this._askBtn);
         this._askBtn = null;
         ObjectUtils.disposeObject(this._sendBtn);
         this._sendBtn = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bidMoney))
         {
            ObjectUtils.disposeObject(this._bidMoney);
         }
         this._bidMoney = null;
         if(Boolean(this._bid_btn))
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(Boolean(this._mouthful_btn))
         {
            ObjectUtils.disposeObject(this._mouthful_btn);
         }
         this._mouthful_btn = null;
         if(Boolean(this._bid_btnR))
         {
            ObjectUtils.disposeObject(this._bid_btnR);
         }
         this._bid_btnR = null;
         if(Boolean(this._mouthful_btnR))
         {
            ObjectUtils.disposeObject(this._mouthful_btnR);
         }
         this._mouthful_btnR = null;
         if(Boolean(this._mouthfulAndbid))
         {
            ObjectUtils.disposeObject(this._mouthfulAndbid);
         }
         this._mouthfulAndbid = null;
         if(Boolean(this._right))
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

