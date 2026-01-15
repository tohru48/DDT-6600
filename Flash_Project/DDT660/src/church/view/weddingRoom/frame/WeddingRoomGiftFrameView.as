package church.view.weddingRoom.frame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class WeddingRoomGiftFrameView extends BaseAlerFrame
   {
      
      private static const LEAST_GIFT_MONEY:int = 200;
      
      private var _bg:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtMoney:FilterFrameText;
      
      private var _contentText:FilterFrameText;
      
      private var _noticeText:FilterFrameText;
      
      public function WeddingRoomGiftFrameView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("church.room.giftFrameBgAssetForGuest.titleText");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.room.giftFrameBgAssetForGuest");
         PositionUtils.setPos(this._bg,"asset.church.room.giftFrameBgAsset.bg.pos");
         addToContent(this._bg);
         this._contentText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameView.contentText");
         this._contentText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameView.contentText");
         addToContent(this._contentText);
         this._noticeText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameView.noticeText");
         this._noticeText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameView.noticeText",LEAST_GIFT_MONEY);
         addToContent(this._noticeText);
         this._txtMoney = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameMoneyTextAsset");
         this._txtMoney.selectable = false;
         addToContent(this._txtMoney);
      }
      
      public function set txtMoney(m:String) : void
      {
         this._txtMoney.text = m;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function checkMoney() : void
      {
         var total:uint = Math.floor(PlayerManager.Instance.Self.Money / LEAST_GIFT_MONEY);
         var current:uint = Math.ceil(Number(this._txtMoney.text) / LEAST_GIFT_MONEY) == 0 ? 1 : uint(Math.ceil(Number(this._txtMoney.text) / LEAST_GIFT_MONEY));
         if(current >= total)
         {
            current = total;
         }
         this._txtMoney.text = String(current * LEAST_GIFT_MONEY);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
               ChurchManager.instance.dispatchEvent(new Event(ChurchManager.SUBMIT_REFUND));
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.bitmapData.dispose();
            this._bg.bitmapData = null;
         }
         this._bg = null;
         if(Boolean(this._contentText))
         {
            if(Boolean(this._contentText.parent))
            {
               this._contentText.parent.removeChild(this._contentText);
            }
            this._contentText.dispose();
         }
         this._contentText = null;
         if(Boolean(this._noticeText))
         {
            if(Boolean(this._noticeText.parent))
            {
               this._txtMoney.parent.removeChild(this._noticeText);
            }
            this._noticeText.dispose();
         }
         this._noticeText = null;
         if(Boolean(this._txtMoney))
         {
            if(Boolean(this._txtMoney.parent))
            {
               this._txtMoney.parent.removeChild(this._txtMoney);
            }
            this._txtMoney.dispose();
         }
         this._txtMoney = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

