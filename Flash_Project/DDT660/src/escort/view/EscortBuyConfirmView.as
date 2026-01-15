package escort.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   
   public class EscortBuyConfirmView extends SimpleAlert
   {
      
      private var _scb:SelectedCheckButton;
      
      public function EscortBuyConfirmView()
      {
         super();
      }
      
      public function get isNoPrompt() : Boolean
      {
         return this._scb.selected;
      }
      
      override public function set info(value:AlertInfo) : void
      {
         super.info = value;
         this._scb = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         _seleContent.y += 35;
         this._scb.x = _seleContent.x + (_seleContent.width - this._scb.width) / 2;
         this._scb.y = _seleContent.y - 5 - this._scb.height + 46;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 40;
         _submitButton.y += 40;
         _cancelButton.y += 40;
      }
   }
}

