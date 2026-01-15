package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class CardInputFrame extends BaseAlerFrame
   {
      
      public static const RESTRICT:String = "0-9";
      
      public static const DEFAULT:String = "0";
      
      private var _alertInfo:AlertInfo;
      
      private var _needSoulText:FilterFrameText;
      
      private var _SellText:FilterFrameText;
      
      private var _SellText1:FilterFrameText;
      
      private var _SellText2:FilterFrameText;
      
      private var _InputTxt:FilterFrameText;
      
      private var _sellInputBg:Scale9CornerImage;
      
      private var _place:int;
      
      private var _cardtype:int;
      
      public function CardInputFrame()
      {
         super();
         this.setView();
         this.setEvent();
      }
      
      public function set place(vaule:int) : void
      {
         this._place = vaule;
         this._needSoulText.text = String(this.getNeedSoul());
         var total:int = PlayerManager.Instance.Self.CardSoul;
         var need:int = this.getNeedSoul();
         if(need > total)
         {
            this._InputTxt.text = String(total);
         }
         else
         {
            this._InputTxt.text = String(this.getNeedSoul());
         }
      }
      
      public function set cardtype(value:int) : void
      {
         this._cardtype = value;
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._needSoulText = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellNeedSoulText");
         this._SellText = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText2");
         this._SellText.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText1");
         this._SellText1 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText3");
         this._SellText1.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText5");
         this._SellText2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText5");
         this._SellText2.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText4");
         this._sellInputBg = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellInputBg");
         this._InputTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText4");
         this._InputTxt.maxChars = 8;
         this._InputTxt.restrict = RESTRICT;
         this._InputTxt.text = DEFAULT;
         addToContent(this._needSoulText);
         addToContent(this._SellText);
         addToContent(this._SellText1);
         addToContent(this._SellText2);
         addToContent(this._sellInputBg);
         addToContent(this._InputTxt);
      }
      
      private function getNeedSoul(level:String = null) : int
      {
         if(level == null)
         {
            level = String(CardControl.Instance.model.GrooveInfoVector[this._place].Level + 1);
         }
         var _cardGrooveInfo:GrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
         var _grooveInfo:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(level,String(_cardGrooveInfo.Type));
         var GP:int = _cardGrooveInfo.GP;
         var Exp:int = int(_grooveInfo.Exp);
         return Exp - GP;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__Response);
         this._InputTxt.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         this._InputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._InputTxt.addEventListener(Event.CHANGE,this._change);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__Response);
         this._InputTxt.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         this._InputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._InputTxt.removeEventListener(Event.CHANGE,this._change);
      }
      
      private function _change(event:Event) : void
      {
         var current:int = int(this._InputTxt.text);
         var total:int = PlayerManager.Instance.Self.CardSoul;
         var num:String = this._InputTxt.text.toString();
         var needSoul:int = this.getNeedSoul("40");
         if(current > total)
         {
            this._InputTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         }
         else if(num == "00")
         {
            this._InputTxt.text = "0";
         }
         else if(num == "01")
         {
            this._InputTxt.text = "1";
         }
         else if(num == "02")
         {
            this._InputTxt.text = "2";
         }
         else if(num == "03")
         {
            this._InputTxt.text = "3";
         }
         else if(num == "04")
         {
            this._InputTxt.text = "4";
         }
         else if(num == "05")
         {
            this._InputTxt.text = "5";
         }
         else if(num == "06")
         {
            this._InputTxt.text = "6";
         }
         else if(num == "07")
         {
            this._InputTxt.text = "7";
         }
         else if(num == "08")
         {
            this._InputTxt.text = "8";
         }
         else if(num == "09")
         {
            this._InputTxt.text = "9";
         }
      }
      
      private function __Response(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
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
         var total:int = PlayerManager.Instance.Self.CardSoul;
         var current:int = int(this._InputTxt.text);
         var needSoul:int = this.getNeedSoul("40");
         if(current == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText2"));
         }
         else if(current > total)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText3"));
         }
         else if(current > needSoul)
         {
            this._InputTxt.text = needSoul.toString();
            SocketManager.Instance.out.sendUpdateSLOT(this._place,int(this._InputTxt.text));
            CardControl.Instance.model.inputSoul = int(this._InputTxt.text);
            this.dispose();
         }
         else
         {
            SocketManager.Instance.out.sendUpdateSLOT(this._place,int(this._InputTxt.text));
            CardControl.Instance.model.inputSoul = int(this._InputTxt.text);
            this.dispose();
         }
      }
      
      private function checkSoul() : void
      {
         var total:int = PlayerManager.Instance.Self.CardSoul;
         var current:int = int(this._InputTxt.text);
         if(current >= total)
         {
            current = total;
         }
         this._InputTxt.text = String(current);
      }
      
      private function __keyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            event.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.confirmSubmit();
         }
      }
      
      private function __focusOut(event:FocusEvent) : void
      {
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._needSoulText))
         {
            ObjectUtils.disposeObject(this._needSoulText);
            this._needSoulText = null;
         }
         super.dispose();
         this.removeEvent();
      }
   }
}

