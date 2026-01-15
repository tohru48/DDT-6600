package ddt.view.common.church
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.BagInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChurchProposeFrame extends BaseAlerFrame
   {
      
      private var _bg:MutipleImage;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtInfo:TextArea;
      
      private var _chkSysMsg:SelectedIconButton;
      
      private var _maxChar:FilterFrameText;
      
      private var _buyRingFrame:ChurchBuyRingFrame;
      
      private var _spouseID:int;
      
      private var useBugle:Boolean;
      
      private var _bgTitleText:FilterFrameText;
      
      private var _surplusCharText:FilterFrameText;
      
      private var _noticeText:FilterFrameText;
      
      private var _blessingText:FilterFrameText;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _moneyTxt:FilterFrameText;
      
      public function ChurchProposeFrame()
      {
         super();
         this.initialize();
         this.addEvent();
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
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("church.ChurchProposeFrame.bg");
         addToContent(this._bg);
         this._bgTitleText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.bgTitleText");
         this._bgTitleText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.bgTitleText.text");
         addToContent(this._bgTitleText);
         this._surplusCharText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.surplusCharText");
         this._surplusCharText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.surplusCharText.text");
         addToContent(this._surplusCharText);
         this._noticeText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.noticeText");
         this._noticeText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.noticeText.text");
         addToContent(this._noticeText);
         this._blessingText = ComponentFactory.Instance.creat("church.ChurchProposeFrame.blessingText");
         this._blessingText.text = LanguageMgr.GetTranslation("church.ChurchProposeFrame.blessingText.text");
         addToContent(this._blessingText);
         this._txtInfo = ComponentFactory.Instance.creat("common.church.txtChurchProposeFrameAsset");
         this._txtInfo.maxChars = 300;
         addToContent(this._txtInfo);
         this._chkSysMsg = ComponentFactory.Instance.creat("common.church.chkChurchProposeFrameAsset");
         this._chkSysMsg.selected = true;
         addToContent(this._chkSysMsg);
         this._maxChar = ComponentFactory.Instance.creat("common.church.churchProposeMaxCharAsset");
         this._maxChar.text = "300";
         addToContent(this._maxChar);
         this.useBugle = this._chkSysMsg.selected;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkSysMsg.addEventListener(Event.SELECT,this.__checkClick);
         this._chkSysMsg.addEventListener(MouseEvent.CLICK,this.getFocus);
         this._txtInfo.addEventListener(Event.CHANGE,this.__input);
         this._txtInfo.addEventListener(Event.ADDED_TO_STAGE,this.__addToStages);
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
               if(PathManager.solveChurchEnable())
               {
                  this.confirmSubmit();
               }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkSysMsg.removeEventListener(Event.CHANGE,this.__checkClick);
         this._chkSysMsg.removeEventListener(MouseEvent.CLICK,this.getFocus);
         this._txtInfo.removeEventListener(Event.CHANGE,this.__input);
         this._txtInfo.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStages);
      }
      
      private function __checkClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.useBugle = this._chkSysMsg.selected;
      }
      
      private function getFocus(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(stage))
         {
            stage.focus = this;
         }
      }
      
      private function __addToStages(e:Event) : void
      {
         this._txtInfo.stage.focus = this._txtInfo;
         this._txtInfo.text = "";
      }
      
      private function __input(e:Event) : void
      {
         var inputCharacter:int = this._txtInfo.text.length;
         this._maxChar.text = String(300 - inputCharacter);
      }
      
      private function confirmSubmit() : void
      {
         var str:String = null;
         if(!PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).findFistItemByTemplateId(11103))
         {
            str = FilterWordManager.filterWrod(this._txtInfo.text);
            this._buyRingFrame = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame");
            this._buyRingFrame.addEventListener(Event.CLOSE,this.buyRingFrameClose);
            this._buyRingFrame.spouseID = this.spouseID;
            this._buyRingFrame.proposeStr = str;
            this._buyRingFrame.useBugle = this._chkSysMsg.selected;
            this._buyRingFrame.titleText = "Uyarı";
            this._buyRingFrame.show();
            this.dispose();
            return;
         }
         this.sendPropose();
      }
      
      private function sendPropose() : void
      {
         var str:String = FilterWordManager.filterWrod(this._txtInfo.text);
         SocketManager.Instance.out.sendPropose(this._spouseID,str,this.useBugle,false);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      private function buyRingFrameClose(evt:Event) : void
      {
         if(Boolean(this._buyRingFrame))
         {
            this._buyRingFrame.removeEventListener(Event.CLOSE,this.buyRingFrameClose);
            if(Boolean(this._buyRingFrame.parent))
            {
               this._buyRingFrame.parent.removeChild(this._buyRingFrame);
            }
            this._buyRingFrame.dispose();
         }
         this._buyRingFrame = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
         }
         this._bg = null;
         this._bgTitleText = null;
         this._surplusCharText = null;
         this._noticeText = null;
         this._blessingText = null;
         this._txtInfo = null;
         if(Boolean(this._chkSysMsg))
         {
            if(Boolean(this._chkSysMsg.parent))
            {
               this._chkSysMsg.parent.removeChild(this._chkSysMsg);
            }
            this._chkSysMsg.dispose();
         }
         this._chkSysMsg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

