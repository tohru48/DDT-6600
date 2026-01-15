package catchInsect.componets
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InsectQuickBuyFrame extends Frame
   {
      
      private var _bg:Image;
      
      private var _number:NumberSelecter;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _totalTipText:FilterFrameText;
      
      protected var totalText:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _bandMoney:FilterFrameText;
      
      private var _submitButton:TextButton;
      
      private var _movieBack:MovieClip;
      
      private var _sprite:Sprite;
      
      private var _cell:BagCell;
      
      private var _type:int;
      
      private var _perPrice:int;
      
      protected var _isBand:Boolean;
      
      private var _goodsId:int;
      
      public function InsectQuickBuyFrame()
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
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText2");
         addToContent(this.totalText);
         this._sprite = new Sprite();
         addToContent(this._sprite);
         this._movieBack = ComponentFactory.Instance.creat("asset.core.stranDown");
         this._movieBack.x = 176;
         this._movieBack.y = 116;
         this._sprite.addChild(this._movieBack);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.enable = true;
         this._selectedBtn.selected = false;
         this._selectedBtn.x = 83;
         this._selectedBtn.y = 101;
         this._sprite.addChild(this._selectedBtn);
         this._isBand = true;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.enable = false;
         this._selectedBandBtn.selected = true;
         this._selectedBandBtn.x = 183;
         this._selectedBandBtn.y = 101;
         this._sprite.addChild(this._selectedBandBtn);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.x = 55;
         this._moneyTxt.y = 107;
         this._moneyTxt.text = LanguageMgr.GetTranslation("ddt.money");
         this._sprite.addChild(this._moneyTxt);
         this._bandMoney = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoney.x = 173;
         this._bandMoney.y = 107;
         this._bandMoney.text = LanguageMgr.GetTranslation("ddt.bandMoney");
         this._sprite.addChild(this._bandMoney);
         this._cell = new BagCell(0);
         this._cell.x = 33;
         this._cell.y = 35;
         addToContent(this._cell);
         this.refreshNumText();
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         addToContent(this._submitButton);
         this._submitButton.y = 146;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.seletedHander);
         this._selectedBandBtn.addEventListener(MouseEvent.CLICK,this.selectedBandHander);
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__buy);
      }
      
      protected function __buy(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         var bands:Array = [];
         for(var i:int = 0; i <= this._number.number - 1; i++)
         {
            items.push(this._goodsId);
            types.push(1);
            colors.push("");
            dresses.push(false);
            skins.push("");
            places.push(-1);
            bands.push(false);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,0,null,bands);
         SocketManager.Instance.out.updateInsectInfo();
         this.dispose();
      }
      
      protected function selectedBandHander(event:MouseEvent) : void
      {
         if(this._selectedBandBtn.selected)
         {
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
         }
         else
         {
            this._isBand = false;
         }
         this.refreshNumText();
      }
      
      protected function seletedHander(event:MouseEvent) : void
      {
         if(this._selectedBtn.selected)
         {
            this._isBand = false;
            this._selectedBandBtn.selected = false;
            this._selectedBandBtn.enable = true;
            this._selectedBtn.enable = false;
         }
         else
         {
            this._isBand = true;
         }
         this.refreshNumText();
      }
      
      private function selectHandler(e:Event) : void
      {
         this.refreshNumText();
      }
      
      protected function refreshNumText() : void
      {
         var tmp:String = null;
         var priceStr:String = String(this._number.number * this._perPrice);
         switch(this._type)
         {
            case 0:
               tmp = this._isBand ? LanguageMgr.GetTranslation("ddtMoney") : LanguageMgr.GetTranslation("money");
               break;
            case 1:
               tmp = LanguageMgr.GetTranslation("tank.gameover.takecard.score");
         }
         this.totalText.text = priceStr + " " + tmp;
         this.totalText.x = 245;
      }
      
      public function setData(type:int, perPrice:int, templateId:int, goodsId:int) : void
      {
         this._type = type;
         this._perPrice = perPrice;
         this._goodsId = goodsId;
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = templateId;
         ItemManager.fill(info);
         info.BindType = 4;
         this._cell.info = info;
         this._cell.setCountNotVisible();
         this.refreshNumText();
         if(this._type == 1)
         {
            this._sprite.visible = false;
         }
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
         this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.seletedHander);
         this._selectedBandBtn.removeEventListener(MouseEvent.CLICK,this.selectedBandHander);
         this._number.removeEventListener(Event.CHANGE,this.selectHandler);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this.__buy);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvnets();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._selectedBtn);
         this._selectedBtn = null;
         ObjectUtils.disposeObject(this._selectedBandBtn);
         this._selectedBandBtn = null;
         ObjectUtils.disposeObject(this._totalTipText);
         this._totalTipText = null;
         ObjectUtils.disposeObject(this.totalText);
         this.totalText = null;
         ObjectUtils.disposeObject(this._moneyTxt);
         this._moneyTxt = null;
         ObjectUtils.disposeObject(this._bandMoney);
         this._bandMoney = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         ObjectUtils.disposeObject(this._movieBack);
         this._movieBack = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
      }
   }
}

