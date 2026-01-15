package lanternriddles.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.DoubleSelectedItem;
   import flash.events.Event;
   import lanternriddles.event.LanternEvent;
   
   public class LanternAlertView extends BaseAlerFrame
   {
      
      private var _tipInfo:FilterFrameText;
      
      private var _selecedItem:DoubleSelectedItem;
      
      private var _checkBtn:SelectedCheckButton;
      
      public function LanternAlertView()
      {
         super();
         info = new AlertInfo(LanguageMgr.GetTranslation("tips"));
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._tipInfo = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertText");
         addToContent(this._tipInfo);
         this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("lantern.view.selectBtn");
         this._checkBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
         addToContent(this._checkBtn);
         this._selecedItem = new DoubleSelectedItem();
         PositionUtils.setPos(this._selecedItem,"lantern.alertView.doubleSelect");
      }
      
      private function initEvent() : void
      {
         this._checkBtn.addEventListener(Event.SELECT,this.__noAlertTip);
      }
      
      protected function __noAlertTip(event:Event) : void
      {
         SoundManager.instance.play("008");
         var evt:LanternEvent = new LanternEvent(LanternEvent.LANTERN_SELECT);
         evt.flag = this._checkBtn.selected;
         dispatchEvent(evt);
      }
      
      override public function get isBand() : Boolean
      {
         return false;
      }
      
      public function set text(text:String) : void
      {
         this._tipInfo.text = text;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._checkBtn))
         {
            this._checkBtn.removeEventListener(Event.SELECT,this.__noAlertTip);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._tipInfo))
         {
            this._tipInfo.dispose();
            this._tipInfo = null;
         }
         if(Boolean(this._selecedItem))
         {
            this._selecedItem.dispose();
            this._selecedItem = null;
         }
         if(Boolean(this._checkBtn))
         {
            this._checkBtn.dispose();
            this._checkBtn = null;
         }
         super.dispose();
      }
   }
}

