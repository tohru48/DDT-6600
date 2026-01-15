package oldplayergetticket
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class GetTicketView extends Frame
   {
      
      private static var _getSuccess:Boolean = false;
      
      private var _bg:ScaleBitmapImage;
      
      private var _textBg:Bitmap;
      
      private var _getNumBitmap:Bitmap;
      
      private var _bottomBtnBg:ScaleBitmapImage;
      
      private var _captionTxt1:FilterFrameText;
      
      private var _captionTxt2:FilterFrameText;
      
      private var _captionTxt3:FilterFrameText;
      
      private var _captionTxt4:FilterFrameText;
      
      private var _captionTxt5:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _levelTicketNum:FilterFrameText;
      
      private var _rechargeTicketNum:FilterFrameText;
      
      private var _tiepointNum:FilterFrameText;
      
      private var _recvBtn:BaseButton;
      
      public function GetTicketView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.regress.getticketView.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("oldplayer.getTicketBg");
         addToContent(this._bg);
         this._textBg = ComponentFactory.Instance.creatBitmap("asset.getTicket.textBg");
         addToContent(this._textBg);
         this._getNumBitmap = ComponentFactory.Instance.creatBitmap("asset.getTicket.getNum");
         addToContent(this._getNumBitmap);
         this._bottomBtnBg = ComponentFactory.Instance.creatComponentByStylename("oldplayer.bottomBgImg");
         addToContent(this._bottomBtnBg);
         this._captionTxt1 = ComponentFactory.Instance.creatComponentByStylename("oldplayer.caption1");
         this._captionTxt1.text = LanguageMgr.GetTranslation("ddt.regress.getticketView.caption1");
         addToContent(this._captionTxt1);
         this._captionTxt2 = ComponentFactory.Instance.creatComponentByStylename("oldplayer.caption2");
         this._captionTxt2.text = LanguageMgr.GetTranslation("ddt.regress.getticketView.caption2");
         addToContent(this._captionTxt2);
         this._captionTxt3 = ComponentFactory.Instance.creatComponentByStylename("oldplayer.caption3");
         this._captionTxt3.text = LanguageMgr.GetTranslation("ddt.regress.getticketView.caption3");
         addToContent(this._captionTxt3);
         this._captionTxt4 = ComponentFactory.Instance.creatComponentByStylename("oldplayer.caption4");
         this._captionTxt4.text = LanguageMgr.GetTranslation("ddt.regress.getticketView.caption4");
         addToContent(this._captionTxt4);
         this._captionTxt5 = ComponentFactory.Instance.creatComponentByStylename("oldplayer.caption5");
         this._captionTxt5.text = LanguageMgr.GetTranslation("ddt.regress.getticketView.caption5");
         addToContent(this._captionTxt5);
         this._captionTxt5.visible = false;
         this._level = ComponentFactory.Instance.creatComponentByStylename("oldplayer.level");
         addToContent(this._level);
         this._levelTicketNum = ComponentFactory.Instance.creatComponentByStylename("oldplayer.levelTicketNum");
         addToContent(this._levelTicketNum);
         this._rechargeTicketNum = ComponentFactory.Instance.creatComponentByStylename("oldplayer.rechargeTicketNum");
         addToContent(this._rechargeTicketNum);
         this._tiepointNum = ComponentFactory.Instance.creatComponentByStylename("oldplayer.tiepointNum");
         addToContent(this._tiepointNum);
         this._recvBtn = ComponentFactory.Instance.creatComponentByStylename("oldplayer.recvBtn");
         addToContent(this._recvBtn);
         this._recvBtn.enable = !_getSuccess;
      }
      
      public function setViewData(money:int, level:int, levelMoney:int) : void
      {
         if(level == 0)
         {
            PositionUtils.setPos(this._captionTxt3,this._captionTxt2);
            this._rechargeTicketNum.y = this._captionTxt3.y;
            this._level.visible = this._levelTicketNum.visible = this._captionTxt2.visible = this._captionTxt5.visible = false;
            levelMoney = 0;
         }
         else if(level < 35)
         {
            this._captionTxt5.visible = true;
            this._level.visible = this._levelTicketNum.visible = this._captionTxt2.visible = false;
            levelMoney = 0;
         }
         else
         {
            this.setTextInfo(this._level,"ddt.regress.getticketView.level",level);
            this.setTextInfo(this._levelTicketNum,"ddt.regress.getticketView.tiepointNum",levelMoney);
         }
         this.setTextInfo(this._rechargeTicketNum,"ddt.regress.getticketView.tiepointNum",money);
         this._tiepointNum.text = String(money + levelMoney);
      }
      
      private function setTextInfo(info:FilterFrameText, className:String, data:int) : void
      {
         info.text = LanguageMgr.GetTranslation(className,data);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._recvBtn.addEventListener(MouseEvent.CLICK,this.__onRecvBtnClick);
      }
      
      protected function __onRecvBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_GET_TICKETINFO,this.__onGetTicket);
         SocketManager.Instance.out.sendRegressTicket();
      }
      
      protected function __onGetTicket(event:CrazyTankSocketEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var pkg:PackageIn = event.pkg;
         var flag:int = pkg.readInt();
         if(flag == 0)
         {
            this._recvBtn.enable = false;
            _getSuccess = true;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.regress.getticketView.getTicket"));
         }
         else if(flag == 1)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.regress.getticketView.caption4"),LanguageMgr.GetTranslation("ok"));
            alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
         else if(flag == 2)
         {
         }
      }
      
      protected function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.playButtonSound();
               alert.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._recvBtn.removeEventListener(MouseEvent.CLICK,this.__onRecvBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_GET_TICKETINFO,this.__onGetTicket);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               GetTicketManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._textBg))
         {
            this._textBg.bitmapData.dispose();
            this._textBg.bitmapData = null;
            this._textBg = null;
         }
         if(Boolean(this._getNumBitmap))
         {
            this._getNumBitmap.bitmapData.dispose();
            this._getNumBitmap.bitmapData = null;
            this._getNumBitmap = null;
         }
         if(Boolean(this._bottomBtnBg))
         {
            this._bottomBtnBg.dispose();
            this._bottomBtnBg = null;
         }
         if(Boolean(this._captionTxt1))
         {
            this._captionTxt1.dispose();
            this._captionTxt1 = null;
         }
         if(Boolean(this._captionTxt2))
         {
            this._captionTxt2.dispose();
            this._captionTxt2 = null;
         }
         if(Boolean(this._captionTxt3))
         {
            this._captionTxt3.dispose();
            this._captionTxt3 = null;
         }
         if(Boolean(this._captionTxt4))
         {
            this._captionTxt4.dispose();
            this._captionTxt4 = null;
         }
         if(Boolean(this._captionTxt5))
         {
            this._captionTxt5.dispose();
            this._captionTxt5 = null;
         }
         if(Boolean(this._level))
         {
            this._level.dispose();
            this._level = null;
         }
         if(Boolean(this._levelTicketNum))
         {
            this._levelTicketNum.dispose();
            this._levelTicketNum = null;
         }
         if(Boolean(this._rechargeTicketNum))
         {
            this._rechargeTicketNum.dispose();
            this._rechargeTicketNum = null;
         }
         if(Boolean(this._tiepointNum))
         {
            this._tiepointNum.dispose();
            this._tiepointNum = null;
         }
         if(Boolean(this._recvBtn))
         {
            this._recvBtn.dispose();
            this._recvBtn = null;
         }
      }
   }
}

