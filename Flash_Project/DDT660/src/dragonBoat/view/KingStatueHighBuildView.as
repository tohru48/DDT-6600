package dragonBoat.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.DoubleSelectedItem;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class KingStatueHighBuildView extends BaseAlerFrame
   {
      
      private static const BUILD_COST:int = 100;
      
      private var _desc:FilterFrameText;
      
      private var _ownMoney:FilterFrameText;
      
      private var _ownBindMoney:FilterFrameText;
      
      private var _txt:FilterFrameText;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _bottomPromptTxt:FilterFrameText;
      
      private var _selecedItem:DoubleSelectedItem;
      
      private var _type:int;
      
      public function KingStatueHighBuildView()
      {
         super();
      }
      
      public function init2(type:int) : void
      {
         this._type = type;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var title:String = this._type == 0 ? LanguageMgr.GetTranslation("ddt.dragonBoat.highBuildTxt") : LanguageMgr.GetTranslation("ddt.dragonBoat.highDecorateTxt");
         var _alertInfo:AlertInfo = new AlertInfo(title,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         _alertInfo.autoDispose = false;
         _alertInfo.sound = "008";
         info = _alertInfo;
         escEnable = true;
         this._desc = ComponentFactory.Instance.creat("consortion.taskFrame.textWordI");
         PositionUtils.setPos(this._desc,"kingStatue.consumeFrame2.descPos");
         this._desc.text = LanguageMgr.GetTranslation("kingStatue.ownedMoney");
         this._ownMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalTicketTxt");
         PositionUtils.setPos(this._ownMoney,"kingStatue.consumeFrame2.ownMoneyPos");
         this._ownMoney.text = String(PlayerManager.Instance.Self.Money);
         this._ownBindMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalTicketTxt");
         PositionUtils.setPos(this._ownBindMoney,"kingStatue.consumeFrame2.ownBindMoneyPos");
         this._ownBindMoney.text = String(PlayerManager.Instance.Self.BandMoney);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalPromptTxt");
         PositionUtils.setPos(this._txt,"kingStatue.consumeFrame2.txtPos");
         this._inputBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.normal.inputBg");
         PositionUtils.setPos(this._inputBg,"kingStatue.consumeFrame.inputBg2Pos");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalInputTxt");
         PositionUtils.setPos(this._inputText,"kingStatue.consumeFrame.inputTxt2Pos");
         this._inputText.text = "1";
         this._bottomPromptTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.consumePromptTxt2");
         PositionUtils.setPos(this._bottomPromptTxt,"kingStatue.consumeFrame2.tipsPos");
         this._selecedItem = new DoubleSelectedItem();
         PositionUtils.setPos(this._selecedItem,"kingStatue.consumeFrame2.selectItemPos");
         switch(this._type)
         {
            case 0:
               this._txt.text = LanguageMgr.GetTranslation("kingStatue.highBuild");
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("kingStatue.highBuildTips");
               break;
            case 1:
               this._txt.text = LanguageMgr.GetTranslation("kingStatue.highDecorate");
               this._bottomPromptTxt.text = LanguageMgr.GetTranslation("kingStatue.highDecorateTips");
         }
         addToContent(this._desc);
         addToContent(this._ownMoney);
         addToContent(this._ownBindMoney);
         addToContent(this._txt);
         addToContent(this._inputBg);
         addToContent(this._inputText);
         addToContent(this._bottomPromptTxt);
         addToContent(this._selecedItem);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.inputKeyDownHandler,false,0,true);
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var num:int = int(this._inputText.text);
         if(num < 1)
         {
            this._inputText.text = "1";
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
         var confirmFrame2:BaseAlerFrame = null;
         var tmpNeedMoney:int = BUILD_COST;
         if(this._selecedItem.isBind && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
         {
            confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame2.moveEnable = false;
            confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
            return;
         }
         if(!this._selecedItem.isBind && PlayerManager.Instance.Self.Money < tmpNeedMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SocketManager.Instance.out.sendDragonBoatBuildOrDecorate(2,int(this._inputText.text));
         this.dispose();
      }
      
      private function reConfirmHandler(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = BUILD_COST;
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendDragonBoatBuildOrDecorate(2,int(this._inputText.text));
         }
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
         this._inputText.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
         this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.inputKeyDownHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._desc);
         this._desc = null;
         ObjectUtils.disposeObject(this._ownMoney);
         this._ownMoney = null;
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._inputText);
         this._inputText = null;
         ObjectUtils.disposeObject(this._selecedItem);
         this._selecedItem = null;
         super.dispose();
      }
   }
}

