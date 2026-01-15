package dragonBoat.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DragonBoatConsumeView extends BaseAlerFrame
   {
      
      private var _item:InventoryItemInfo;
      
      private var _itemMax:int;
      
      private var _txt:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _bottomPromptTxt:FilterFrameText;
      
      private var _textWord1:FilterFrameText;
      
      private var _ownMoney:FilterFrameText;
      
      private var _ownMoney2:FilterFrameText;
      
      private var _tag:int;
      
      public function DragonBoatConsumeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _alertInfo:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         _alertInfo.autoDispose = false;
         _alertInfo.sound = "008";
         info = _alertInfo;
         this._textWord1 = ComponentFactory.Instance.creat("consortion.taskFrame.textWordI");
         PositionUtils.setPos(this._textWord1,"dragonBoat.mainFrame.consumeView.textWord1Pos");
         this._textWord1.text = LanguageMgr.GetTranslation("ddt.dragonBoat.highPromptTxt1");
         this._ownMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalTicketTxt");
         PositionUtils.setPos(this._ownMoney,"dragonBoat.mainFrame.consumeView.ownMoneyPos");
         this._ownMoney.text = String(PlayerManager.Instance.Self.Money);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalPromptTxt");
         this._inputBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.normal.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalInputTxt");
         this._inputText.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normal.maxBtn");
         this._bottomPromptTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.consumePromptTxt2");
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalPromptTxt");
         this._ownMoney2 = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalTicketTxt");
         PositionUtils.setPos(this._ownMoney2,"dragonBoat.mainFrame.consumeView.ownMoneyPos2");
         addToContent(this._textWord1);
         addToContent(this._ownMoney);
         addToContent(this._txt);
         addToContent(this._inputBg);
         addToContent(this._inputText);
         addToContent(this._txt2);
         addToContent(this._ownMoney2);
         addToContent(this._maxBtn);
         addToContent(this._bottomPromptTxt);
      }
      
      public function setView(tag:int) : void
      {
         var useChipId:int = 0;
         var _item2:int = 0;
         this._tag = tag;
         if(this._tag == 1 || this._tag == 2)
         {
            useChipId = DragonBoatManager.KINGSTATUE_CHIP;
            this._item = PlayerManager.Instance.Self.PropBag.getItemByTemplateId(useChipId);
            this._itemMax = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(useChipId,false);
            _item2 = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(DragonBoatManager.LINSHI_CHIP,true);
            if(_item2 > 0)
            {
               this._itemMax += _item2;
            }
            this._textWord1.visible = false;
            this._ownMoney.visible = false;
            this._maxBtn.visible = true;
            if(DragonBoatManager.instance.activeInfo.ActiveID == 1)
            {
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.normalPromptTxt2");
            }
            else
            {
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.normalPromptTxt2_II");
            }
            if(this._tag == 1)
            {
               titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.normalBuildTxt");
               this._txt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.normalPromptTxt");
               this._txt.x = 28;
               this._bottomPromptTxt.x = 95;
            }
            else
            {
               titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.normalDecorateTxt");
               this._txt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.normalPromptTxt");
            }
         }
         else
         {
            this.highViewSet();
            if(this._tag == 3)
            {
               titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.highBuildTxt");
               this._txt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.highPromptTxt2");
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.highPromptTxt3");
               this._txt2.text = LanguageMgr.GetTranslation("ddt.dragonBoat.priceFrameMsg");
               this._ownMoney2.text = int(this._inputText.text) * 100 + "";
               this._txt.x = 18;
               this._txt2.x = 289;
               this._txt2.y = 88;
               this._inputBg.x = 122;
               this._inputText.x = 120;
               this._bottomPromptTxt.x = 40;
            }
            else
            {
               titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.highDecorateTxt");
               this._txt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.highPromptTxt22");
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.highPromptTxt32");
            }
         }
      }
      
      private function highViewSet() : void
      {
         this._textWord1.visible = true;
         this._ownMoney.visible = true;
         this._maxBtn.visible = false;
         this._bottomPromptTxt.x = 40;
         this._bottomPromptTxt.y = 121;
         this._txt.x = 42;
         this._txt.y = 88;
         this._inputBg.x = 203;
         this._inputBg.y = 84;
         this._inputText.x = 203;
         this._inputText.y = 89;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.inputKeyDownHandler,false,0,true);
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputText.text = this._itemMax.toString();
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var num:int = int(this._inputText.text);
         if(num < 1)
         {
            this._inputText.text = "1";
         }
         if(Boolean(this._item))
         {
            if(num > this._itemMax)
            {
               this._inputText.text = this._itemMax.toString();
            }
         }
         if(this._tag == 3)
         {
            this._ownMoney2.text = int(this._inputText.text) * 100 + "";
         }
      }
      
      private function responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.enterKeyHandler();
         }
      }
      
      private function enterKeyHandler() : void
      {
         var tmpType:int = 0;
         if(this._tag == 1 || this._tag == 2)
         {
            tmpType = 1;
         }
         else
         {
            tmpType = 2;
         }
         SocketManager.Instance.out.sendDragonBoatBuildOrDecorate(tmpType,int(this._inputText.text));
         this.dispose();
      }
      
      private function inputKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            this.enterKeyHandler();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         this._inputText.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
         this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.inputKeyDownHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._item = null;
         this._txt = null;
         this._inputBg = null;
         this._inputText = null;
         this._maxBtn = null;
         this._bottomPromptTxt = null;
         this._textWord1 = null;
         this._ownMoney = null;
      }
   }
}

