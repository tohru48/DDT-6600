package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="prePage",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="nextPage",type="auctionHouse.event.AuctionHouseEvent")]
   public class AuctionSellView extends Sprite implements Disposeable
   {
      
      private var _right:AuctionRightView;
      
      private var _left:AuctionSellLeftView;
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _cancelBid_btn:BaseButton;
      
      private var _sendBugle:BaseButton;
      
      private var _selectCheckBtn:SelectedCheckButton;
      
      private var _btClickLock:Boolean;
      
      public function AuctionSellView(controller:AuctionHouseController, model:AuctionHouseModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
         this._right.setup(AuctionState.SELL);
         addChild(this._right);
         this._left = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionSellLeftView");
         addChildAt(this._left,0);
         this._cancelBid_btn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.CancelBid_btn");
         addChild(this._cancelBid_btn);
         this._sendBugle = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SendBugle");
         addChild(this._sendBugle);
      }
      
      private function addEvent() : void
      {
         this._cancelBid_btn.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._sendBugle.addEventListener(MouseEvent.CLICK,this.__sendBugle);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeStage);
         this._right.prePage_btn.addEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.addEventListener(MouseEvent.CLICK,this.__next);
         this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function removeEvent() : void
      {
         this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._cancelBid_btn.removeEventListener(MouseEvent.CLICK,this.__cancel);
         this._sendBugle.removeEventListener(MouseEvent.CLICK,this.__sendBugle);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeStage);
         this._right.prePage_btn.removeEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK,this.__next);
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(evt:Event) : void
      {
         this._cancelBid_btn.enable = false;
         this._sendBugle.enable = false;
         this._left.addStage();
      }
      
      internal function clearLeft() : void
      {
         this._left.clear();
      }
      
      internal function clearList() : void
      {
         this._right.clearList();
      }
      
      internal function hideReady() : void
      {
         this._left.hideReady();
         this._right.hideReady();
      }
      
      internal function addAuction(info:AuctionGoodsInfo) : void
      {
         this._right.addAuction(info);
      }
      
      internal function setPage(start:int, totalCount:int) : void
      {
         this._right.setPage(start,totalCount);
      }
      
      internal function updateList(info:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(info);
      }
      
      private function __sendBugle(e:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         if(SharedManager.Instance.isAuctionHouseTodayUseBugle)
         {
            if(this._selectCheckBtn == null)
            {
               this._selectCheckBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.noMoraAlert");
               this._selectCheckBtn.text = LanguageMgr.GetTranslation("dice.alert.nextPrompt");
            }
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.UseBugle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.addChild(this._selectCheckBtn);
            alert1.addEventListener(FrameEvent.RESPONSE,function(e:FrameEvent):void
            {
               if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  if(_selectCheckBtn.selected)
                  {
                     SharedManager.Instance.isAuctionHouseTodayUseBugle = !_selectCheckBtn.selected;
                  }
                  ChatManager.Instance.sendFastAuctionBugle(_right.getSelectInfo().AuctionID);
               }
               alert1.dispose();
               _selectCheckBtn.dispose();
               _selectCheckBtn = null;
            });
         }
         else
         {
            ChatManager.Instance.sendFastAuctionBugle(this._right.getSelectInfo().AuctionID);
         }
      }
      
      private function __cancel(event:MouseEvent) : void
      {
         SoundManager.instance.play("043");
         this._btClickLock = true;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._cancelBid_btn.enable = false;
         this._sendBugle.enable = false;
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.cancel"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(evt.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._response);
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.__cancelOk();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.__cannelNo();
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function __cancelOk() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(Boolean(this._right.getSelectInfo()))
            {
               if(this._right.getSelectInfo().BuyerName != "")
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Price"));
                  return;
               }
               SocketManager.Instance.out.auctionCancelSell(this._right.getSelectInfo().AuctionID);
               this._controller.model.sellTotal -= 1;
               this._right.clearSelectStrip();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
            }
            SoundManager.instance.play("008");
            this._cancelBid_btn.enable = false;
            this._sendBugle.enable = false;
            return;
         }
      }
      
      private function __cannelNo() : void
      {
         SoundManager.instance.play("008");
         this._cancelBid_btn.enable = true;
         this._sendBugle.enable = true;
      }
      
      private function __removeStage(event:Event) : void
      {
         this._left.clear();
      }
      
      private function __next(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._cancelBid_btn.enable = false;
         this._sendBugle.enable = false;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
      }
      
      private function __pre(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._cancelBid_btn.enable = false;
         this._sendBugle.enable = false;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
      }
      
      private function sortChange(e:AuctionHouseEvent) : void
      {
         this._cancelBid_btn.enable = false;
         this._sendBugle.enable = false;
         this._model.sellCurrent = 1;
         this._controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1,this._right.sortCondition,this._right.sortBy.toString());
      }
      
      internal function searchByCurCondition(currentPage:int, playerID:int = -1) : void
      {
         this._controller.searchAuctionList(currentPage,"",-1,-1,playerID,-1,this._right.sortCondition,this._right.sortBy.toString());
      }
      
      private function __selectStrip(event:AuctionHouseEvent) : void
      {
         if(Boolean(this._right.getSelectInfo()))
         {
            if(this._right.getSelectInfo().BuyerName != "")
            {
               this._cancelBid_btn.enable = false;
               this._sendBugle.enable = false;
            }
            else
            {
               this._cancelBid_btn.enable = true;
               this._sendBugle.enable = true;
            }
         }
      }
      
      public function get this_left() : AuctionSellLeftView
      {
         return this._left;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._right))
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(Boolean(this._left))
         {
            ObjectUtils.disposeObject(this._left);
         }
         this._left = null;
         if(Boolean(this._cancelBid_btn))
         {
            ObjectUtils.disposeObject(this._cancelBid_btn);
         }
         this._cancelBid_btn = null;
         if(Boolean(this._sendBugle))
         {
            ObjectUtils.disposeObject(this._sendBugle);
         }
         this._sendBugle = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

