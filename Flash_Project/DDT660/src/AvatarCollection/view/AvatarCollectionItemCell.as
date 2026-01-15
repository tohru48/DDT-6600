package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionItemVo;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.BuySingleGoodsView2;
   
   public class AvatarCollectionItemCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemCell:BagCell;
      
      private var _btn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _data:AvatarCollectionItemVo;
      
      private var view:BuySingleGoodsView2;
      
      public function AvatarCollectionItemCell()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.itemCell.bg");
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,74,74);
         sp.graphics.endFill();
         this._itemCell = new BagCell(1,null,true,sp,false);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemCell.btn");
         this._btn.alpha = 0.8;
         this._btn.visible = false;
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemCell.buyBtn");
         this._buyBtn.alpha = 0.8;
         this._buyBtn.visible = false;
         addChild(this._bg);
         addChild(this._itemCell);
         addChild(this._btn);
         addChild(this._buyBtn);
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.buyClickHandler,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      private function buyClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _shopItemInfo:ShopItemInfo = ShopManager.Instance.getGoodsByTemplateID(this._data.itemId);
         this.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount,_shopItemInfo.getItemPrice(1).PriceType);
         if(Boolean(this.view))
         {
            this.view._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.onBuyConfirmResponse);
         }
      }
      
      public function buy($goodsID:int, isDiscount:int = 1, type:int = 1, isSale:Boolean = false) : void
      {
         this.view = new BuySingleGoodsView2(type);
         LayerManager.Instance.addToLayer(this.view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         BuySingleGoodsView2(this.view).isDisCount = isDiscount == 1 ? false : true;
         BuySingleGoodsView2(this.view).isSale = isSale;
         BuySingleGoodsView2(this.view).goodsID = $goodsID;
      }
      
      private function onBuyConfirmResponse(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.Money < this._data.buyPrice)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         var items:Array = [this._data.goodsId];
         var goodsTypes:Array = [this._data.isDiscount];
         this.view.dispose();
      }
      
      private function onBuyedGoods(event:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         event.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var success:int = event.pkg.readInt();
         if(success != 0)
         {
            this.sendActive();
         }
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(this._data && !this._data.isActivity && !this._buyBtn.visible)
         {
            this._btn.visible = true;
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         if(Boolean(this._data) && !this._data.isHas)
         {
            this._btn.visible = false;
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._data.isHas)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.doActive.donnotHas"));
            return;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("avatarCollection.activeItem.promptTxt",this._data.needGold),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__activeConfirm,false,0,true);
      }
      
      private function __activeConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__activeConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendActive();
         }
      }
      
      private function sendActive() : void
      {
         if(!this.checkGoldEnough())
         {
            this.refreshView(this._data);
            return;
         }
         SocketManager.Instance.out.sendAvatarCollectionActive(this._data.id,this._data.itemId,this._data.sex);
      }
      
      private function checkGoldEnough() : Boolean
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Gold < this._data.needGold)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return false;
         }
         return true;
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function refreshView(data:AvatarCollectionItemVo) : void
      {
         this._data = data;
         if(!this._data)
         {
            this._itemCell.info = null;
            this._itemCell.tipStyle = null;
            this._itemCell.tipData = null;
            this._btn.visible = false;
            this._buyBtn.visible = false;
            return;
         }
         this._itemCell.info = this._data.itemInfo;
         this._itemCell.tipStyle = "AvatarCollection.view.AvatarCollectionItemTip";
         this._itemCell.tipData = this._data;
         if(this._data.isActivity)
         {
            this._btn.visible = false;
            this._buyBtn.visible = false;
            this._itemCell.lightPic();
         }
         else if(this._data.isHas)
         {
            this._btn.visible = true;
            this._buyBtn.visible = false;
            this._itemCell.lightPic();
         }
         else
         {
            if(this._data.canBuyStatus == 1)
            {
               this._buyBtn.visible = true;
            }
            else
            {
               this._buyBtn.visible = false;
            }
            this._btn.visible = false;
            this._itemCell.grayPic();
         }
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.buyClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemCell = null;
         this._btn = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

