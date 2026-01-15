package fightLib.command
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   
   public class PopupHFrameCommand extends BaseFightLibCommand
   {
      
      private var _infoString:String;
      
      private var _okLabel:String;
      
      private var _cancelLabel:String;
      
      private var _okCallBack:Function;
      
      private var _cancellCallBack:Function;
      
      private var _showOkBtn:Boolean;
      
      private var _showCancelBtn:Boolean;
      
      private var _alert:BaseAlerFrame;
      
      public function PopupHFrameCommand(infoString:String, okLabel:String = "", okCallBack:Function = null, cancelLabel:String = "", cancelCallBack:Function = null, showOkBtn:Boolean = true, showCancelBtn:Boolean = false)
      {
         super();
         this._infoString = infoString;
         this._okLabel = okLabel;
         this._cancelLabel = cancelLabel;
         this._okCallBack = okCallBack;
         this._cancellCallBack = cancelCallBack;
         this._showOkBtn = showOkBtn;
         this._showCancelBtn = showCancelBtn;
      }
      
      protected function __response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._cancellCallBack != null)
               {
                  this._cancellCallBack.apply();
               }
               this.closeAlert();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._okCallBack != null)
               {
                  this._okCallBack.apply();
               }
               this.closeAlert();
         }
      }
      
      override public function excute() : void
      {
         super.excute();
         var alert:BaseAlerFrame = this._alert;
         this._alert = AlertManager.Instance.simpleAlert("",this._infoString,this._okLabel,this._cancelLabel,false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__response);
         if(Boolean(alert) && alert != this._alert)
         {
            alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
            ObjectUtils.disposeObject(alert);
         }
      }
      
      override public function finish() : void
      {
         if(this._okCallBack != null)
         {
            this._okCallBack.apply();
         }
         this.closeAlert();
         super.finish();
      }
      
      override public function undo() : void
      {
         this.closeAlert();
         super.undo();
      }
      
      override public function dispose() : void
      {
         this._okCallBack = null;
         this._cancellCallBack = null;
         this._okLabel = null;
         this._cancelLabel = null;
         this.closeAlert();
      }
      
      private function closeFrame() : void
      {
      }
      
      private function closeAlert() : void
      {
         if(Boolean(this._alert))
         {
            ObjectUtils.disposeObject(this._alert);
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
            this._alert = null;
         }
      }
   }
}

