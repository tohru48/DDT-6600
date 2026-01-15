package ddt.view.common.church
{
   import baglocked.BagLockedGetFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.events.Event;
   
   public class ChurchBuyRingFrame extends BaseAlerFrame
   {
      
      private var _text1:FilterFrameText;
      
      private var _text2:FilterFrameText;
      
      private var _text3:FilterFrameText;
      
      private var _ringInfo:ShopItemInfo;
      
      private var _alertInfo:AlertInfo;
      
      private var _spouseID:int;
      
      private var _proposeStr:String;
      
      private var _useBugle:Boolean;
      
      public function ChurchBuyRingFrame()
      {
         super();
         this.initialize();
      }
      
      public function get useBugle() : Boolean
      {
         return this._useBugle;
      }
      
      public function set useBugle(value:Boolean) : void
      {
         this._useBugle = value;
      }
      
      public function get proposeStr() : String
      {
         return this._proposeStr;
      }
      
      public function set proposeStr(value:String) : void
      {
         this._proposeStr = value;
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(value:int) : void
      {
         this._spouseID = value;
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this.escEnable = true;
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._text1 = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame.text1");
         this._text1.text = LanguageMgr.GetTranslation("common.church.ChurchBuyRingFrame.text1.text");
         addToContent(this._text1);
         this._text2 = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame.text2");
         this._text2.text = LanguageMgr.GetTranslation("common.church.ChurchBuyRingFrame.text2.text");
         addToContent(this._text2);
         this._text3 = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame.text3");
         this._text3.text = LanguageMgr.GetTranslation("common.church.ChurchBuyRingFrame.text3.text");
         addToContent(this._text3);
         this._ringInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(11103);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function confirmSubmit() : void
      {
         if(PathManager.solveChurchEnable())
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               new BagLockedGetFrame().show();
               return;
            }
            if(BuriedManager.Instance.checkMoney(false,this._ringInfo.getItemPrice(1).moneyValue))
            {
               return;
            }
         }
         SocketManager.Instance.out.sendPropose(this._spouseID,this._proposeStr,this._useBugle,_isBand);
         this.dispose();
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._ringInfo = null;
         this._alertInfo = null;
         if(Boolean(this._text1))
         {
            if(Boolean(this._text1.parent))
            {
               this._text1.parent.removeChild(this._text1);
            }
         }
         this._text1 = null;
         if(Boolean(this._text2))
         {
            if(Boolean(this._text2.parent))
            {
               this._text2.parent.removeChild(this._text2);
            }
         }
         this._text2 = null;
         if(Boolean(this._text3))
         {
            if(Boolean(this._text3.parent))
            {
               this._text3.parent.removeChild(this._text3);
            }
         }
         this._text3 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

