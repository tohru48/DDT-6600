package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   
   public class AuctionBuyView extends Sprite implements Disposeable
   {
      
      private var _bidMoney:BidMoneyView;
      
      private var _right:AuctionBuyRightView;
      
      private var _bid_btn:BaseButton;
      
      private var _mouthful_btn:BaseButton;
      
      private var _bid_btnR:TextButton;
      
      private var _mouthfulAndbid:ScaleBitmapImage;
      
      private var _mouthful_btnR:TextButton;
      
      private var _btClickLock:Boolean;
      
      public function AuctionBuyView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         addChild(this._bid_btn);
         this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         addChild(this._mouthful_btn);
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this._bidMoney.cannotBid();
         this._bid_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Bid_btnR");
         this._bid_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.bid");
         this._mouthful_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Mouthful_btnR");
         this._mouthful_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionBuyRightView");
         addChild(this._right);
         this.initialiseBtn();
         this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
         this._mouthfulAndbid.addChild(this._bid_btnR);
         this._mouthfulAndbid.addChild(this._mouthful_btnR);
         addChild(this._mouthfulAndbid);
         this._mouthfulAndbid.visible = false;
         this._bid_btn.enable = false;
         this._bid_btnR.enable = false;
      }
      
      private function addEvent() : void
      {
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this._bid_btnR.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
      }
      
      private function __nextPage(evt:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
      }
      
      private function __prePage(evt:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
      }
      
      private function removeEvent() : void
      {
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this._bid_btnR.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
      }
      
      private function getBidPrice() : int
      {
         var min:int = 0;
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(info.BuyerName == "")
         {
            min = info.Price;
         }
         else
         {
            min = info.Price + info.Rise;
         }
         return min;
      }
      
      internal function hide() : void
      {
      }
      
      private function initialiseBtn() : void
      {
         this._mouthful_btn.enable = false;
         this._bid_btn.enable = false;
         this._mouthful_btnR.enable = false;
         this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._bid_btnR.enable = false;
         this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._bidMoney.cannotBid();
      }
      
      internal function addAuction(info:AuctionGoodsInfo) : void
      {
         this._right.addAuction(info);
      }
      
      internal function removeAuction() : void
      {
         this._bidMoney.cannotBid();
      }
      
      internal function updateAuction(info:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(info);
         this.__selectRightStrip(null);
      }
      
      internal function clearList() : void
      {
         this._right.clearList();
      }
      
      private function _mouthfulAndbidOver(e:MouseEvent) : void
      {
         this._mouthfulAndbid.visible = false;
      }
      
      private function __selectRightStrip(event:AuctionHouseEvent) : void
      {
         this._mouthfulAndbid.x = this.globalToLocal(new Point(mouseX,mouseY)).x - 10;
         this._mouthfulAndbid.y = this.globalToLocal(new Point(mouseX,mouseY)).y - 10;
         if(this._mouthfulAndbid.x > stage.stageWidth - this._mouthfulAndbid.width)
         {
            this._mouthfulAndbid.x = this._mouthfulAndbid.x - this._mouthfulAndbid.width + 20;
         }
         this.setChildIndex(this._mouthfulAndbid,this.numChildren - 1);
         if(Boolean(event))
         {
            this._mouthfulAndbid.visible = true;
         }
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(Boolean(info))
         {
            if(info.AuctioneerID == PlayerManager.Instance.Self.ID)
            {
               this.initialiseBtn();
               return;
            }
            this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
            this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            this._bid_btnR.enable = this._bid_btn.enable = info.BuyerID == PlayerManager.Instance.Self.ID ? false : true;
            this._bid_btnR.filters = info.BuyerID == PlayerManager.Instance.Self.ID ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            if(info.BuyerID != PlayerManager.Instance.Self.ID)
            {
               this._bidMoney.canMoneyBid(info.Price + info.Rise);
            }
            else
            {
               this._bidMoney.cannotBid();
            }
         }
      }
      
      private function __bid(event:MouseEvent) : void
      {
         var alert1:AuctionInputFrame = null;
         var _bidKeyUp:Function = null;
         var _responseII:Function = null;
         var alert:BaseAlerFrame = null;
         _bidKeyUp = function(e:Event):void
         {
            SoundManager.instance.play("008");
            __bidII();
            alert1.removeEventListener(FrameEvent.RESPONSE,_responseII);
            _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
            ObjectUtils.disposeObject(alert1);
            _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         };
         _responseII = function(evt:FrameEvent):void
         {
            SoundManager.instance.play("008");
            _checkResponse(evt.responseCode,__bidII,__cannel);
            var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
            alert.removeEventListener(FrameEvent.RESPONSE,_responseII);
            _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
            ObjectUtils.disposeObject(evt.target);
            _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         };
         SoundManager.instance.play("047");
         this._btClickLock = true;
         this._mouthfulAndbid.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this.__selectRightStrip(null);
            return;
         }
         if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         this._bid_btn.enable = false;
         this._bid_btnR.enable = false;
         alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
         LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         alert1.addToContent(this._bidMoney);
         this._bidMoney.money.setFocus();
         alert1.moveEnable = false;
         alert1.addEventListener(FrameEvent.RESPONSE,_responseII);
         this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP,_bidKeyUp);
      }
      
      private function __bidII() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getBidPrice() > this._bidMoney.getData())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.price") + String(this._bidMoney.getData()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.less") + String(this.getBidPrice()));
               return;
            }
            var info:AuctionGoodsInfo = this._right.getSelectInfo();
            if(Boolean(info))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,this._bidMoney.getData());
            }
            return;
         }
      }
      
      private function __mouthFull(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._mouthfulAndbid.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._mouthful_btn.enable = this._mouthful_btnR.enable = false;
         this._bid_btn.enable = this._bid_btnR.enable = false;
         this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._btClickLock = true;
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(info.Mouthful > PlayerManager.Instance.Self.Money)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         var alert1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert1.moveEnable = false;
         alert1.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseI(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkResponse(evt.responseCode,LeavePageManager.leaveToFillPath,this._cancelFun);
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseI);
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function _responseII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkResponse(evt.responseCode,this.__callMouthFull,this.__cannel);
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function __callMouthFull() : void
      {
         var i:int = 0;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            var info:AuctionGoodsInfo = this._right.getSelectInfo();
            if(Boolean(info))
            {
               SocketManager.Instance.out.auctionBid(info.AuctionID,info.Mouthful);
               IMController.Instance.saveRecentContactsID(info.AuctioneerID);
               if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
               {
                  SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
               }
               for(i = 0; i < SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].length; i++)
               {
                  if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID][i] == info.AuctionID)
                  {
                     SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].splice(i,1);
                  }
               }
               SharedManager.Instance.save();
               this._bidMoney.cannotBid();
               this._right.clearSelectStrip();
            }
            return;
         }
      }
      
      private function __cannel() : void
      {
         var info:AuctionGoodsInfo = this._right.getSelectInfo();
         if(Boolean(info))
         {
            this._mouthful_btnR.enable = this._mouthful_btn.enable = info.Mouthful == 0 ? false : true;
            this._mouthful_btnR.filters = info.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            this._bid_btnR.enable = this._bid_btn.enable = info.BuyerID == PlayerManager.Instance.Self.ID ? false : true;
            this._bid_btnR.filters = info.BuyerID == PlayerManager.Instance.Self.ID ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
         }
         else
         {
            this._mouthful_btnR.enable = this._mouthful_btn.enable = false;
            this._bid_btnR.enable = this._bid_btn.enable = false;
            this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function _cancelFun() : void
      {
      }
      
      private function __addToStage(event:Event) : void
      {
         this.initialiseBtn();
         this._bidMoney.cannotBid();
      }
      
      private function _checkResponse(keyCode:int, submitFun:Function = null, cancelFun:Function = null, closeFun:Function = null) : void
      {
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
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._right))
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(Boolean(this._mouthful_btn))
         {
            ObjectUtils.disposeObject(this._mouthful_btn);
         }
         this._mouthful_btn = null;
         if(Boolean(this._bid_btn))
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(Boolean(this._bidMoney))
         {
            ObjectUtils.disposeObject(this._bidMoney);
         }
         this._bidMoney = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
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
      }
   }
}

