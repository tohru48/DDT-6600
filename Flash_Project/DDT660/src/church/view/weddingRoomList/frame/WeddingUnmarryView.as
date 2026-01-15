package church.view.weddingRoomList.frame
{
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomListController;
   import church.view.ChurchPresentFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import shop.view.ShopPresentClearingFrame;
   
   public class WeddingUnmarryView extends BaseAlerFrame
   {
      
      private var _controller:ChurchRoomListController;
      
      private var _alertInfo:AlertInfo;
      
      private var _text1:FilterFrameText;
      
      private var _text2:FilterFrameText;
      
      private var _text3:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _needMoney:int;
      
      private var _textBG:ScaleBitmapImage;
      
      private var _textI:FilterFrameText;
      
      private var _textII:FilterFrameText;
      
      private var _otherPayBtn:TextButton;
      
      private var _friendInfo:Object;
      
      private var giveFriendOpenFrame:ChurchPresentFrame;
      
      public function WeddingUnmarryView()
      {
         super();
         this.initialize();
      }
      
      public function set controller(value:ChurchRoomListController) : void
      {
         this._controller = value;
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
         this._otherPayBtn = ComponentFactory.Instance.creatComponentByStylename("wedding.otherPay.btn");
         this._otherPayBtn.text = LanguageMgr.GetTranslation("ddt.friendPay.txt");
         addToContent(this._otherPayBtn);
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.unwedding.txt");
         this._alertInfo.moveEnable = false;
         this.escEnable = true;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.UnmarryAsset");
         addToContent(this._bg);
         this._textBG = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.textBG");
         addToContent(this._textBG);
         this._textI = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.text1");
         this._textI.text = LanguageMgr.GetTranslation("church.main.WeddingUnmarryView.text1.text");
         addToContent(this._textI);
         this._textII = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.text2");
         this._textII.text = LanguageMgr.GetTranslation("church.main.WeddingUnmarryView.text2.text");
         addToContent(this._textII);
         this._text1 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT1");
         addToContent(this._text1);
         this._text2 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT2");
         addToContent(this._text2);
         this._text3 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT3");
         this._text3.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.note");
         addToContent(this._text3);
      }
      
      public function setText(str1:String = "", str2:String = "") : void
      {
         this._text1.htmlText = str1;
         this._text2.htmlText = str2;
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(Boolean(this._textBG))
         {
            ObjectUtils.disposeObject(this._textBG);
         }
         this._textBG = null;
         if(Boolean(this._textI))
         {
            ObjectUtils.disposeObject(this._textI);
         }
         this._textI = null;
         if(Boolean(this._textII))
         {
            ObjectUtils.disposeObject(this._textII);
         }
         this._textII = null;
         if(Boolean(this._text1))
         {
            this._text1.dispose();
         }
         this._text1 = null;
         if(Boolean(this._text2))
         {
            this._text2.dispose();
         }
         this._text2 = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._otherPayBtn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function mouseClickHander(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.playButtonSound();
         this.giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("church.view.ChurchPresentFrame");
         this.giveFriendOpenFrame.titleTxt.visible = false;
         this.giveFriendOpenFrame.setType(ShopPresentClearingFrame.FPAYTYPE_LIHUN);
         this.giveFriendOpenFrame.show();
         this.giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick,false,0,true);
         this.giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.responseHandler2,false,0,true);
      }
      
      private function responseHandler2(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._otherPayBtn.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var name:String = this.giveFriendOpenFrame.nameInput.text;
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askPay"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askSpace"));
            return;
         }
         this._friendInfo = {};
         this._friendInfo["id"] = this.giveFriendOpenFrame.selectPlayerId;
         this._friendInfo["name"] = name;
         if(Boolean(this.giveFriendOpenFrame.textArea))
         {
            this._friendInfo["msg"] = FilterWordManager.filterWrod(this.giveFriendOpenFrame.textArea.text);
         }
         var myName:String = PlayerManager.Instance.Self.NickName;
         if(this.giveFriendOpenFrame.selectPlayerId == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.unwedding.notfriend"));
            return;
         }
         SocketManager.Instance.out.requestUnWeddingPay(this.giveFriendOpenFrame.selectPlayerId);
         this.giveFriendOpenFrame.dispose();
         this.giveFriendOpenFrame = null;
         this.dispose();
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
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         var money:int = PlayerManager.Instance.Self.Money;
         if(money < this._needMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._controller.unmarry();
         this.dispose();
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      public function show(needMoney:int) : void
      {
         this._needMoney = needMoney;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

