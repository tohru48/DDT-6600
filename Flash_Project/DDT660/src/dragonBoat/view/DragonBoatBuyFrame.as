package dragonBoat.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DragonBoatBuyFrame extends BaseAlerFrame
   {
      
      private var _sprite:Sprite;
      
      private var _number:NumberSelecter;
      
      private var _totalTipText:FilterFrameText;
      
      private var totalText:FilterFrameText;
      
      private var _cell:BaseCell;
      
      private var _shopItem:ShopItemInfo;
      
      private var _stoneNumber:int = 1;
      
      private var _totalPrice:int;
      
      public function DragonBoatBuyFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var bg:Image = null;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.dragonBoat.shopBuyFrame.titleTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         _alertInfo.autoDispose = false;
         _alertInfo.sound = "008";
         info = _alertInfo;
         this._sprite = new Sprite();
         PositionUtils.setPos(this._sprite,"dragonBoat.shopFrame.buyFrameContentPos");
         addToContent(this._sprite);
         bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         this._sprite.addChild(bg);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         this._sprite.addChild(this._number);
         var cellBG:Sprite = new Sprite();
         cellBG.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         this._sprite.addChild(this._totalTipText);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         this._sprite.addChild(this.totalText);
         this._cell = new BaseCell(cellBG);
         this._cell.x = bg.x + 4;
         this._cell.y = bg.y + 4;
         this._cell.tipDirctions = "7,0";
         this._sprite.addChild(this._cell);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._number.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberEnter(e:Event) : void
      {
         this.doBuy();
         this.dispose();
      }
      
      private function _numberClose(e:Event) : void
      {
         this.dispose();
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
               this.doBuy();
               this.dispose();
         }
      }
      
      private function doBuy() : void
      {
         SocketManager.Instance.out.sendDragonBoatExchange(this._shopItem.GoodsID,this._stoneNumber);
      }
      
      private function selectHandler(e:Event) : void
      {
         this._stoneNumber = this._number.number;
         this.refreshNumText();
      }
      
      public function set shopItem(value:ShopItemInfo) : void
      {
         this._shopItem = value;
         this._cell.info = ItemManager.Instance.getTemplateById(this._shopItem.TemplateID);
         this._number.maximum = DragonBoatManager.instance.useableScore / this._shopItem.AValue1;
         this.refreshNumText();
      }
      
      private function refreshNumText() : void
      {
         var price:int = this._shopItem == null ? 0 : this._shopItem.AValue1;
         this._totalPrice = this._stoneNumber * price;
         this.totalText.text = this._totalPrice + LanguageMgr.GetTranslation("ddt.dragonBoat.shopCellMoneyTxt");
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._number.removeEventListener(Event.CHANGE,this.selectHandler);
         this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._number.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._sprite);
         super.dispose();
         this._sprite = null;
         this._number = null;
         this._totalTipText = null;
         this.totalText = null;
         this._cell = null;
         this._shopItem = null;
      }
   }
}

