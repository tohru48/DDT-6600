package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   
   public class RoomNotEnoughEnergyAlert extends SimpleAlert
   {
      
      private var _scb:SelectedCheckButton;
      
      public function RoomNotEnoughEnergyAlert()
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
         this._scb = ComponentFactory.Instance.creatComponentByStylename("room.notEnoughEnergyAlert.scb");
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         _seleContent.y += 28;
         this._scb.x = _seleContent.x + (_seleContent.width - this._scb.width) / 2;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 31;
         _submitButton.y += 31;
         _cancelButton.y += 31;
      }
   }
}

