package magicHouse.magicCollection
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   
   public class MagicHouseChargeBoxCountFrame extends Frame
   {
      
      private var _oneTimeBtn:SelectedCheckButton;
      
      private var _fiveTimeBtn:SelectedCheckButton;
      
      private var _okBtn:TextButton;
      
      private var _cancleBtn:TextButton;
      
      private var _tipTxt:FilterFrameText;
      
      public var openCount:int = 1;
      
      public function MagicHouseChargeBoxCountFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._oneTimeBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.getBox.oneSelectBtn");
         PositionUtils.setPos(this._oneTimeBtn,"magicHouse.collection.get1boxBtnPos");
         addToContent(this._oneTimeBtn);
         this._oneTimeBtn.selected = true;
         this._oneTimeBtn.addEventListener(MouseEvent.CLICK,this.__getBoxChange);
         this._fiveTimeBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.getBox.fiveSelectBtn");
         PositionUtils.setPos(this._fiveTimeBtn,"magicHouse.collection.get5boxBtnPos");
         addToContent(this._fiveTimeBtn);
         this._fiveTimeBtn.selected = false;
         this._fiveTimeBtn.addEventListener(MouseEvent.CLICK,this.__getBoxChange);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.confirmBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._okBtn);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__confirmGetBox);
         this._cancleBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.cancleBtn");
         this._cancleBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         addToContent(this._cancleBtn);
         this._cancleBtn.addEventListener(MouseEvent.CLICK,this.__cancleGetBox);
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.chargeBoxNeedMoneyText");
         this._tipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.chargeGetNeedMoney",MagicHouseManager.instance.boxNeedmoney);
         addToContent(this._tipTxt);
      }
      
      private function __getBoxChange(e:MouseEvent) : void
      {
         if(this._oneTimeBtn == e.currentTarget as SelectedCheckButton)
         {
            this._oneTimeBtn.selected = true;
            this._fiveTimeBtn.selected = false;
            this.openCount = 1;
            this._tipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.chargeGetNeedMoney",MagicHouseManager.instance.boxNeedmoney * this.openCount);
         }
         else
         {
            this._oneTimeBtn.selected = false;
            this._fiveTimeBtn.selected = true;
            this.openCount = 5;
            this._tipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.chargeGetNeedMoney",MagicHouseManager.instance.boxNeedmoney * this.openCount);
         }
      }
      
      private function __confirmGetBox(e:MouseEvent) : void
      {
         SocketManager.Instance.out.magicLibChargeGet(this.openCount);
         this.dispose();
      }
      
      private function __cancleGetBox(e:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         this._oneTimeBtn.removeEventListener(Event.CHANGE,this.__getBoxChange);
         this._fiveTimeBtn.removeEventListener(Event.CHANGE,this.__getBoxChange);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__confirmGetBox);
         this._cancleBtn.removeEventListener(MouseEvent.CLICK,this.__cancleGetBox);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._oneTimeBtn))
         {
            ObjectUtils.disposeObject(this._oneTimeBtn);
         }
         this._oneTimeBtn = null;
         if(Boolean(this._fiveTimeBtn))
         {
            ObjectUtils.disposeObject(this._fiveTimeBtn);
         }
         this._fiveTimeBtn = null;
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(Boolean(this._cancleBtn))
         {
            ObjectUtils.disposeObject(this._cancleBtn);
         }
         this._cancleBtn = null;
         super.dispose();
      }
   }
}

