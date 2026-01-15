package magpieBridge.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.Price;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MagpieBuyCountsView extends BaseAlerFrame
   {
      
      private var _text:FilterFrameText;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _totalTipText:FilterFrameText;
      
      private var _totalText:FilterFrameText;
      
      private var _price:int;
      
      public function MagpieBuyCountsView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("magpieBridgeView.buyCount.titleTxt");
         this._text = ComponentFactory.Instance.creatComponentByStylename("magpieBridge.buyCountsView.text");
         this._text.text = LanguageMgr.GetTranslation("magpieBridgeView.buyCount.alertInfo");
         addToContent(this._text);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         PositionUtils.setPos(this._numberSelecter,"magpieBridgeView.numSelecterPos");
         addToContent(this._numberSelecter);
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         PositionUtils.setPos(this._totalTipText,"magpieBridgeView.totalTipPos");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         addToContent(this._totalTipText);
         this._totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         PositionUtils.setPos(this._totalText,"magpieBridgeView.totalTxtPos");
         this._totalText.text = "100";
         addToContent(this._totalText);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         PositionUtils.setPos(this._okBtn,"magpieBridgeView.okBtnPos");
         addToContent(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         PositionUtils.setPos(this._cancelBtn,"magpieBridgeView.cancelBtnPos");
         addToContent(this._cancelBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      protected function __selectedItemChange(event:Event) : void
      {
         this.updateTotalCost();
      }
      
      public function updateTotalCost() : void
      {
         var tmpNeedMoney:int = this._price * int(this._numberSelecter.currentValue);
         this._totalText.text = tmpNeedMoney + " " + Price.MONEYTOSTRING;
      }
      
      protected function __okBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmpNeedMoney:int = this._price * int(this._numberSelecter.currentValue);
         if(PlayerManager.Instance.Self.Money < tmpNeedMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SocketManager.Instance.out.buyMagpieCount(int(this._numberSelecter.currentValue),false);
         this.dispose();
      }
      
      private function reConfirmHandler(event:FrameEvent) : void
      {
         var tmpNeedMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               tmpNeedMoney = this._price * int(this._numberSelecter.currentValue);
               if(PlayerManager.Instance.Self.Money < tmpNeedMoney)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.buyMagpieCount(int(this._numberSelecter.currentValue),false);
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         ObjectUtils.disposeObject(event.currentTarget);
         this.dispose();
      }
      
      protected function __cancelBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateTotalCost();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__seleterChange);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvents();
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._totalTipText);
         this._totalTipText = null;
         ObjectUtils.disposeObject(this._totalText);
         this._totalText = null;
         ObjectUtils.disposeObject(this._okBtn);
         this._okBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
      }
      
      public function set price(value:int) : void
      {
         this._price = value;
         this.updateTotalCost();
      }
   }
}

