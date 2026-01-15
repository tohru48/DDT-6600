package rescue.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RescueQuickBuyFrame extends Frame
   {
      
      private var _bg:Image;
      
      private var _itemBmp:Bitmap;
      
      private var _number:NumberSelecter;
      
      private var _totalTipText:FilterFrameText;
      
      protected var totalText:FilterFrameText;
      
      private var _submitButton:TextButton;
      
      private var _type:int;
      
      private var _perPrice:int;
      
      protected var _isBand:Boolean;
      
      public function RescueQuickBuyFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         addToContent(this._bg);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         addToContent(this._number);
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         addToContent(this._totalTipText);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         addToContent(this.totalText);
         this.refreshNumText();
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         addToContent(this._submitButton);
         this._submitButton.y = 126;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__buyBuff);
      }
      
      protected function __buyBuff(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmpNeedMoney:int = this.getNeedMoney();
         if(PlayerManager.Instance.Self.Money < tmpNeedMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SocketManager.Instance.out.sendRescueBuyBuff(this._type,this._number.number,false);
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
            needMoney = this.getNeedMoney();
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendRescueBuyBuff(this._type,this._number.number,false);
            this.dispose();
         }
      }
      
      private function getNeedMoney() : int
      {
         return this._perPrice * this._number.number;
      }
      
      private function selectHandler(e:Event) : void
      {
         this.refreshNumText();
      }
      
      protected function refreshNumText() : void
      {
         var priceStr:String = String(this._number.number * this._perPrice);
         var tmp:String = LanguageMgr.GetTranslation("money");
         this.totalText.text = priceStr + " " + tmp;
      }
      
      public function setData(type:int, perPrice:int) : void
      {
         this._type = type;
         this._perPrice = perPrice;
         switch(this._type)
         {
            case 0:
               this._itemBmp = ComponentFactory.Instance.creat("rescue.arrow");
               break;
            case 1:
               this._itemBmp = ComponentFactory.Instance.creat("rescue.bloodBag");
               break;
            case 2:
               this._itemBmp = ComponentFactory.Instance.creat("rescue.kingBless");
         }
         if(Boolean(this._itemBmp))
         {
            addToContent(this._itemBmp);
            this._itemBmp.scaleX = 0.6;
            this._itemBmp.scaleY = 0.6;
            this._itemBmp.x = 30;
            this._itemBmp.y = 34;
            this._itemBmp.smoothing = true;
         }
         this.refreshNumText();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvnets() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._number.removeEventListener(Event.CHANGE,this.selectHandler);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this.__buyBuff);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvnets();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._itemBmp);
         this._itemBmp = null;
         ObjectUtils.disposeObject(this._totalTipText);
         this._totalTipText = null;
         ObjectUtils.disposeObject(this.totalText);
         this.totalText = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
      }
   }
}

