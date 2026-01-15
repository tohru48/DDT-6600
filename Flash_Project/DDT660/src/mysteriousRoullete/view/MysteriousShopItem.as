package mysteriousRoullete.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import shop.view.ShopGoodItem;
   
   public class MysteriousShopItem extends ShopGoodItem
   {
      
      public static const TYPE_FREE:int = 0;
      
      public static const TYPE_DISCOUNT:int = 1;
      
      private var _itemCount:FilterFrameText;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var type:int = 1;
      
      private var _alertFrame:BaseAlerFrame;
      
      private var price:int;
      
      public function MysteriousShopItem(type:int)
      {
         this.type = type;
         super();
      }
      
      override protected function initContent() : void
      {
         super.initContent();
         removeChild(_payPaneaskBtn);
         removeChild(_payPaneBuyBtn);
         removeChild(_payPaneGivingBtn);
         _shopItemCellTypeBg.parent.removeChild(_shopItemCellTypeBg);
         this._itemCount = ComponentFactory.Instance.creatComponentByStylename("mysteriousRoulette.itemCount");
         this._itemCount.text = "100";
         addChild(this._itemCount);
         switch(this.type)
         {
            case TYPE_FREE:
               this._getBtn = ComponentFactory.Instance.creatComponentByStylename("mysteriousRoulette.getBtn");
               this._getBtn.addEventListener(MouseEvent.CLICK,this.__getBtnClick);
               addChild(this._getBtn);
               removeChild(_payType);
               break;
            case TYPE_DISCOUNT:
               this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("mysteriousRoulette.buyBtn");
               this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyBtnClick);
               addChild(this._buyBtn);
         }
      }
      
      override public function set shopItemInfo(value:ShopItemInfo) : void
      {
         super.shopItemInfo = value;
         if(_shopItemInfo.BuyType == 1)
         {
            this._itemCount.text = _shopItemInfo.AUnit.toString();
         }
         else
         {
            this._itemCount.text = "";
         }
      }
      
      private function __getBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("mysteriousRoulette.ensureGet"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,true,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
      }
      
      private function __buyBtnClick(event:MouseEvent) : void
      {
         this.price = shopItemInfo.getItemPrice(1).moneyValue;
         SoundManager.instance.play("008");
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("mysteriousRoulette.ensureBuy",this.price),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyGoods);
      }
      
      protected function __alertBuyGoods(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyGoods);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  frame.dispose();
                  return;
               }
               if(frame.isBand)
               {
                  if(PlayerManager.Instance.Self.BandMoney < this.price)
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(PlayerManager.Instance.Self.Money < this.price)
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               this.buy(frame.isBand);
               break;
         }
         frame.dispose();
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this.price)
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            this.buy(false);
         }
         e.currentTarget.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function __alertResponseHandler(event:FrameEvent) : void
      {
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
         this._alertFrame.dispose();
         this._alertFrame = null;
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this.buy();
               break;
         }
      }
      
      private function buy(isbind:Boolean = false) : void
      {
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var goodsTypes:Array = [];
         var binds:Array = [];
         items.push(shopItemInfo.GoodsID);
         types.push(1);
         colors.push("");
         dresses.push("");
         places.push("");
         goodsTypes.push(1);
         binds.push(isbind);
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,null,0,goodsTypes,binds);
      }
      
      public function turnGray(flag:Boolean = false) : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.enable = !flag;
         }
         if(Boolean(this._getBtn))
         {
            this._getBtn.enable = !flag;
         }
      }
      
      override protected function removeEvent() : void
      {
         if(Boolean(this._getBtn))
         {
            this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getBtnClick);
         }
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyBtnClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemCount);
         this._itemCount = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         super.dispose();
      }
   }
}

