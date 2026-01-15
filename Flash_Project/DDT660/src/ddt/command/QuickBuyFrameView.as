package ddt.command
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyFrameView extends Sprite implements Disposeable
   {
      
      private var _number:NumberSelecter;
      
      private var _itemTemplateInfo:ItemTemplateInfo;
      
      private var _shopItem:ShopItemInfo;
      
      private var _cell:BaseCell;
      
      private var _totalTipText:FilterFrameText;
      
      protected var totalText:FilterFrameText;
      
      public var _itemID:int;
      
      protected var _stoneNumber:int = 1;
      
      private var _price:int;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _bandMoney:FilterFrameText;
      
      protected var _isBand:Boolean;
      
      private var _movieBack:MovieClip;
      
      private var _type:int = 0;
      
      private var _time:int = 1;
      
      public function QuickBuyFrameView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(value:int) : void
      {
         this._time = value;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
      }
      
      public function get isBand() : Boolean
      {
         return this._isBand;
      }
      
      public function set isBand(b:Boolean) : void
      {
         this._isBand = b;
      }
      
      private function initView() : void
      {
         var bg:Image = null;
         var cellBG:Sprite = null;
         bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         addChild(bg);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         addChild(this._number);
         cellBG = new Sprite();
         cellBG.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
         this._movieBack = ComponentFactory.Instance.creat("asset.core.stranDown");
         this._movieBack.x = 176;
         this._movieBack.y = 116;
         this._movieBack.visible = false;
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.selected = true;
         this._selectedBtn.x = 83;
         this._selectedBtn.y = 101;
         this._selectedBtn.enable = false;
         this._selectedBtn.visible = false;
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.seletedHander);
         this._isBand = false;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.enable = true;
         this._selectedBandBtn.selected = false;
         this._selectedBandBtn.x = 183;
         this._selectedBandBtn.y = 101;
         this._selectedBandBtn.visible = false;
         this._selectedBandBtn.addEventListener(MouseEvent.CLICK,this.selectedBandHander);
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         addChild(this._totalTipText);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         addChild(this.totalText);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.x = 55;
         this._moneyTxt.y = 107;
         this._moneyTxt.text = LanguageMgr.GetTranslation("ddt.money");
         this._moneyTxt.visible = false;
         this._bandMoney = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoney.x = 173;
         this._bandMoney.y = 107;
         this._bandMoney.text = LanguageMgr.GetTranslation("ddt.bandMoney");
         this._bandMoney.visible = false;
         this._cell = new BaseCell(cellBG);
         this._cell.x = bg.x + 4;
         this._cell.y = bg.y + 4;
         addChild(this._cell);
         this._cell.tipDirctions = "7,0";
         this.refreshNumText();
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
      
      private function initEvents() : void
      {
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function selectHandler(e:Event) : void
      {
         this._stoneNumber = this._number.number;
         this.refreshNumText();
      }
      
      private function _numberClose(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      public function hideSelectedBand() : void
      {
         this._selectedBandBtn.visible = false;
         this._bandMoney.visible = false;
         this._moneyTxt.x += 50;
         this._selectedBtn.x += 50;
         this._selectedBtn.selected = true;
         this._selectedBandBtn.selected = false;
         this._selectedBandBtn.enable = false;
         this._selectedBtn.enable = false;
         this._isBand = false;
         this.refreshNumText();
      }
      
      public function hideSelected() : void
      {
         this._selectedBtn.visible = false;
         this._moneyTxt.visible = false;
         this._bandMoney.x -= 50;
         this._selectedBandBtn.x -= 50;
         this._selectedBandBtn.selected = true;
         this._selectedBtn.selected = false;
         this._selectedBandBtn.enable = false;
         this._selectedBtn.enable = false;
         this._isBand = true;
         this.refreshNumText();
      }
      
      public function set ItemID(ID:int) : void
      {
         this._moneyTxt.visible = this._bandMoney.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = true;
         this._itemID = ID;
         if(this._itemID == EquipType.STRENGTH_STONE4)
         {
            this._stoneNumber = 3;
         }
         else
         {
            this._stoneNumber = 1;
         }
         this._number.number = this._stoneNumber;
         this._shopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         this.initInfo();
         this.refreshNumText();
      }
      
      public function setItemID(ID:int, type:int, time:int, $info:ShopItemInfo = null) : void
      {
         this._itemID = ID;
         this._type = type;
         this._time = time;
         this._shopItem = ShopManager.Instance.getShopItemByTemplateID(this._itemID,this._type);
         if(this._itemID == EquipType.STRENGTH_STONE4)
         {
            this._stoneNumber = 3;
         }
         else
         {
            this._stoneNumber = 1;
         }
         this._number.number = this._stoneNumber;
         if(type == 1 || type == 2 || type == 4 || type == 5 || type == 6)
         {
            this._moneyTxt.visible = this._bandMoney.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = false;
         }
         else if(type == 3)
         {
            this._selectedBandBtn.selected = true;
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
            this._number.ennable = false;
            this._moneyTxt.visible = this._bandMoney.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = true;
         }
         else if(type == 4)
         {
            this._shopItem = $info;
            this._selectedBandBtn.selected = true;
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
            this._number.ennable = false;
            this._moneyTxt.visible = this._bandMoney.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = true;
         }
         this.initInfo();
         this.refreshNumText();
         this.hideSelectedBand();
         this.hideSelectedBand();
      }
      
      public function set stoneNumber(value:int) : void
      {
         this._stoneNumber = value;
         this._number.number = this._stoneNumber;
         this.refreshNumText();
      }
      
      public function get stoneNumber() : int
      {
         return this._stoneNumber;
      }
      
      public function get ItemID() : int
      {
         return this._itemID;
      }
      
      public function set maxLimit(value:int) : void
      {
         this._number.maximum = value;
      }
      
      private function initInfo() : void
      {
         this._itemTemplateInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._cell.info = this._itemTemplateInfo;
      }
      
      protected function refreshNumText() : void
      {
         switch(this._type)
         {
            case 0:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).moneyValue;
               if(this._isBand)
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
               }
               else
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
               }
               break;
            case 1:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).hardCurrencyValue;
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
               break;
            case 2:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).gesteValue;
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("gongxun");
               break;
            case 3:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(this._time).moneyValue;
               if(this._isBand)
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
               }
               else
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
               }
               break;
            case 4:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(this._time).bandDdtMoneyValue;
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
               break;
            case 5:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).scoreValue;
               this.totalText.text = String(this._stoneNumber * this._price) + Price.SCORETOSTRING;
               break;
            case 6:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).leagueValue;
               this.totalText.text = String(this._stoneNumber * this._price) + Price.LEAGUESTRING;
               break;
            case -1700:
               this._price = this._shopItem == null ? 0 : this._shopItem.AValue1;
               this.totalText.text = String(this._stoneNumber * this._price) + Price.TREASURELOST_STONE;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._number))
         {
            this._number.removeEventListener(Event.CANCEL,this.selectHandler);
            this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            ObjectUtils.disposeObject(this._number);
         }
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.seletedHander);
         }
         if(Boolean(this._selectedBandBtn))
         {
            this._selectedBandBtn.removeEventListener(MouseEvent.CLICK,this.selectedBandHander);
         }
         ObjectUtils.disposeObject(this._selectedBandBtn);
         ObjectUtils.disposeObject(this._selectedBtn);
         ObjectUtils.disposeObject(this._moneyTxt);
         ObjectUtils.disposeObject(this._bandMoney);
         if(Boolean(this._totalTipText))
         {
            ObjectUtils.disposeObject(this._totalTipText);
         }
         this._totalTipText = null;
         if(Boolean(this.totalText))
         {
            ObjectUtils.disposeObject(this.totalText);
         }
         this.totalText = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         this._number = null;
         this._itemTemplateInfo = null;
         this._shopItem = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

