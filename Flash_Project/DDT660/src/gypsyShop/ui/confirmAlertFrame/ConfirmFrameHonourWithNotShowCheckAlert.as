package gypsyShop.ui.confirmAlertFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConfirmFrameHonourWithNotShowCheckAlert extends Frame
   {
      
      public static const OK:String = "ok";
      
      public static const CANCEL:String = "cancel";
      
      private var _itemInfo:InventoryItemInfo;
      
      private var _confirm:TextButton;
      
      private var _cancel:TextButton;
      
      private var _detailText:FilterFrameText;
      
      private var _scb:SelectedCheckButton;
      
      private var _titleTxt:String;
      
      private var _detail:String;
      
      private var _needHonour:int;
      
      private var _onNotShowAgain:Function;
      
      private var _onComfirm:Function;
      
      public function ConfirmFrameHonourWithNotShowCheckAlert()
      {
         super();
      }
      
      protected function __confirmhandler(event:MouseEvent) : void
      {
         this._confirm && this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmhandler);
         dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
         this.ok();
      }
      
      protected function __cancelHandler(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.ok();
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               this.cancel();
         }
      }
      
      private function ok() : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function cancel() : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(CANCEL));
         this.dispose();
      }
      
      public function initView() : void
      {
         titleText = this._titleTxt;
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.ok");
         this._confirm.x = 31;
         this._confirm.y = 120;
         this._confirm.text = LanguageMgr.GetTranslation("ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.cancel");
         this._cancel.x = 196;
         this._cancel.y = 120;
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._detailText = ComponentFactory.Instance.creat("simpleAlertContentText");
         this._detailText.x = 57;
         this._detailText.y = 58;
         this._detailText.text = this._detail;
         if(this._scb == null)
         {
            this._scb = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
         }
         this._scb.x = 84;
         this._scb.y = 96;
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         addToContent(this._detailText);
         addToContent(this._confirm);
         addToContent(this._cancel);
         addToContent(this._scb);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmhandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
      }
      
      public function get isNoPrompt() : Boolean
      {
         return this._scb.selected;
      }
      
      public function set selectedCheckButton(value:SelectedCheckButton) : void
      {
         this._scb = value;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._confirm))
         {
            this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmhandler);
         }
         if(Boolean(this._cancel))
         {
            this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         }
         super.dispose();
         this._itemInfo = null;
         if(Boolean(this._confirm))
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(Boolean(this._cancel))
         {
            ObjectUtils.disposeObject(this._cancel);
         }
         this._cancel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set needHonour(value:int) : void
      {
         this._needHonour = value;
      }
      
      public function set detail(value:String) : void
      {
         this._detail = value;
      }
      
      public function set onNotShowAgain(value:Function) : void
      {
         this._onNotShowAgain = value;
      }
      
      public function set onComfirm(value:Function) : void
      {
         this._onComfirm = value;
      }
      
      public function set titleTxt(value:String) : void
      {
         this._titleTxt = value;
      }
   }
}

