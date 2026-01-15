package store.view.transfer
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class HoleConfirmAlert extends BaseAlerFrame
   {
      
      private var _state1:Boolean;
      
      private var _state2:Boolean;
      
      private var _beforeCheck:SelectedCheckButton;
      
      private var _afterCheck:SelectedCheckButton;
      
      private var _textField:FilterFrameText;
      
      private var _noteField:FilterFrameText;
      
      public function HoleConfirmAlert(state1:int, state2:int)
      {
         super();
         var info:AlertInfo = new AlertInfo();
         info.submitLabel = LanguageMgr.GetTranslation("ok");
         info.cancelLabel = LanguageMgr.GetTranslation("cancel");
         info.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this.info = info;
         this.addEvent();
         if(state1 == -1)
         {
            this._beforeCheck.enable = false;
         }
         else
         {
            this._beforeCheck.selected = state1 == 1 ? true : false;
         }
         if(state2 == -1)
         {
            this._afterCheck.enable = false;
         }
         else
         {
            this._afterCheck.selected = state2 == 1 ? true : false;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._beforeCheck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.StrengthenHoleCheckBtn");
         addToContent(this._beforeCheck);
         this._afterCheck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.CloseHoleCheckBtn");
         addToContent(this._afterCheck);
         this._textField = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.TipsText");
         this._textField.text = LanguageMgr.GetTranslation("store.view.transfer.HoleTipsText");
         addToContent(this._textField);
         this._noteField = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.NoteText");
         this._noteField.text = LanguageMgr.GetTranslation("store.view.transfer.HoleNoteText");
         addToContent(this._noteField);
      }
      
      private function addEvent() : void
      {
         this._beforeCheck.addEventListener(Event.SELECT,this.__selectChanged);
         this._afterCheck.addEventListener(Event.SELECT,this.__selectChanged);
      }
      
      private function __selectChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         var check:SelectedCheckButton = event.currentTarget as SelectedCheckButton;
         if(check == this._beforeCheck)
         {
            this._state1 = this._beforeCheck.selected;
         }
         else if(check == this._afterCheck)
         {
            this._state2 = this._beforeCheck.selected;
         }
      }
      
      private function removeEvent() : void
      {
         this._beforeCheck.removeEventListener(Event.SELECT,this.__selectChanged);
         this._afterCheck.removeEventListener(Event.SELECT,this.__selectChanged);
      }
      
      public function get state1() : Boolean
      {
         return this._beforeCheck.enable && this._beforeCheck.selected;
      }
      
      public function get state2() : Boolean
      {
         return this._afterCheck.enable && this._afterCheck.selected;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._beforeCheck))
         {
            ObjectUtils.disposeObject(this._beforeCheck);
            this._beforeCheck = null;
         }
         if(Boolean(this._afterCheck))
         {
            ObjectUtils.disposeObject(this._afterCheck);
            this._afterCheck = null;
         }
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
         }
         if(Boolean(this._noteField))
         {
            ObjectUtils.disposeObject(this._noteField);
         }
         this._noteField = null;
         super.dispose();
      }
   }
}

