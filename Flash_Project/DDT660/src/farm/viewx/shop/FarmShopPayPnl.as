package farm.viewx.shop
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class FarmShopPayPnl extends BaseAlerFrame
   {
      
      public static const GOLD:int = 0;
      
      public static const GIFT:int = 1;
      
      public static const MONEY:int = 2;
      
      private static const MaxNum:int = 50;
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _alertTips:FilterFrameText;
      
      private var _payNumtxt:TextInput;
      
      private var _payNumBg:DisplayObject;
      
      private var _shopPayItem:ShopItemCell;
      
      private var _cellBg:DisplayObject;
      
      private var _goodsID:int;
      
      private var _payNum:int = 1;
      
      private var _alertTips2:FilterFrameText;
      
      private var _totalBg:Bitmap;
      
      private var _group:SelectedButtonGroup;
      
      private var _gold:SelectedCheckButton;
      
      private var _gift:SelectedCheckButton;
      
      private var _money:SelectedCheckButton;
      
      private var _spendValue:int;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _shopType:int;
      
      private var _myCreditTxt:FilterFrameText;
      
      private var _myCreditNum:FilterFrameText;
      
      public function FarmShopPayPnl()
      {
         super();
         moveEnable = false;
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.showCancel = false;
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.farms.shopPayButton");
         alertInfo.title = LanguageMgr.GetTranslation("ddt.farms.shopPayTitle");
         alertInfo.bottomGap = 33;
         this.info = alertInfo;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._payNumBg = ComponentFactory.Instance.creat("farm.shop.payPanelInputBg");
         addToContent(this._payNumBg);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("farm.shop.shopUpButton");
         addToContent(this._addBtn);
         this._removeBtn = ComponentFactory.Instance.creatComponentByStylename("farm.shop.shopDownButton");
         addToContent(this._removeBtn);
         this._totalBg = ComponentFactory.Instance.creatBitmap("assets.farmShop.payBg");
         addToContent(this._totalBg);
         this._alertTips = ComponentFactory.Instance.creatComponentByStylename("farm.text.shopPayAlertTips");
         addToContent(this._alertTips);
         this._alertTips2 = ComponentFactory.Instance.creatComponentByStylename("farm.text.shopPayAlertTips2");
         addToContent(this._alertTips2);
         this._payNumtxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.shopPayNumInput");
         addToContent(this._payNumtxt);
         this._payNumtxt.textField.restrict = "0-9";
         this._payNumtxt.text = "1";
         this._payNum = 1;
         this._cellBg = ComponentFactory.Instance.creat("asset.farm.baseImage5");
         PositionUtils.setPos(this._cellBg,"farm.shopPayCell.point");
         addToContent(this._cellBg);
         this._gold = ComponentFactory.Instance.creatComponentByStylename("farm.shopPayView.gold");
         this._gift = ComponentFactory.Instance.creatComponentByStylename("farm.shopPayView.gift");
         this._money = ComponentFactory.Instance.creatComponentByStylename("farm.shopPayView.money");
         this._group = new SelectedButtonGroup();
         this._group.addSelectItem(this._gold);
         this._group.addSelectItem(this._gift);
         this._group.addSelectItem(this._money);
         addToContent(this._gold);
         addToContent(this._gift);
         addToContent(this._money);
         this._alertTips.text = LanguageMgr.GetTranslation("ddt.farms.shopPayAlert");
      }
      
      public function set goodsID(value:int) : void
      {
         var i:int = 0;
         if(Boolean(this._shopPayItem))
         {
            this._shopPayItem.dispose();
         }
         this._goodsID = value;
         this._shopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
         if(!this._shopItemInfo)
         {
            this._shopItemInfo = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
         }
         this._shopPayItem = this.creatItemCell();
         PositionUtils.setPos(this._shopPayItem,"farm.shopPayCell.point");
         this._shopPayItem.cellSize = 54;
         this._shopPayItem.info = this._shopItemInfo.TemplateInfo;
         addToContent(this._shopPayItem);
         this._gold.enable = false;
         this._gift.enable = false;
         this._money.enable = false;
         this._gold.text = LanguageMgr.GetTranslation("gold");
         this._gift.text = LanguageMgr.GetTranslation("ddtMoney");
         this._money.text = LanguageMgr.GetTranslation("money");
         if(Boolean(this._shopItemInfo))
         {
            i = 1;
            if(Boolean(this._shopItemInfo.getItemPrice(i).goldValue))
            {
               this._gold.enable = true;
               this._group.selectIndex = GOLD;
            }
            if(Boolean(this._shopItemInfo.getItemPrice(i).bandDdtMoneyValue))
            {
               this._gift.enable = true;
               this._group.selectIndex = GIFT;
            }
            if(Boolean(this._shopItemInfo.getItemPrice(i).moneyValue))
            {
               this._money.enable = true;
               this._group.selectIndex = MONEY;
            }
         }
         this.alertMoney();
      }
      
      private function alertMoney() : void
      {
         var alertTxt:String = "";
         if(this._shopType == ShopType.FARM_PETEGG_TYPE)
         {
            this._spendValue = this._shopItemInfo.getItemPrice(1).ddtPetScoreValue * this._payNum;
            this._alertTips2.text = String(this._spendValue) + "" + LanguageMgr.GetTranslation("ddt.farm.petScore");
            return;
         }
         switch(this._group.selectIndex)
         {
            case MONEY:
               this._spendValue = this._shopItemInfo.getItemPrice(1).moneyValue * this._payNum;
               alertTxt = String(this._spendValue) + LanguageMgr.GetTranslation("money");
               break;
            case GOLD:
               this._spendValue = this._shopItemInfo.getItemPrice(1).goldValue * this._payNum;
               alertTxt = String(this._spendValue) + LanguageMgr.GetTranslation("gold");
               break;
            case GIFT:
               this._spendValue = this._shopItemInfo.getItemPrice(1).bandDdtMoneyValue * this._payNum;
               alertTxt = String(this._spendValue) + LanguageMgr.GetTranslation("ddtMoney");
         }
         this._alertTips2.text = alertTxt;
      }
      
      public function set shopType(value:int) : void
      {
         this._shopType = value;
         if(value == ShopType.FARM_PETEGG_TYPE)
         {
            this.isPetSocrePay();
         }
         this.alertMoney();
      }
      
      private function isPetSocrePay() : void
      {
         this._gold.visible = false;
         this._gift.visible = false;
         this._money.visible = false;
         this._myCreditTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.myCreditTxt");
         this._myCreditNum = ComponentFactory.Instance.creatComponentByStylename("farm.text.myCreditNum");
         this.info.title = LanguageMgr.GetTranslation("ddt.farm.affirmExchange");
         this._myCreditTxt.text = LanguageMgr.GetTranslation("ddt.farm.possessScore");
         this._myCreditNum.text = String(PlayerManager.Instance.Self.petScore) + "" + LanguageMgr.GetTranslation("ddt.farm.petScore");
         addToContent(this._myCreditTxt);
         addToContent(this._myCreditNum);
         this.height = 235;
         this._alertTips2.y = 136;
         this._alertTips.y = 136;
         this._totalBg.y = 130;
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,75,75);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      private function initEvent() : void
      {
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__selectPayNum);
         this._removeBtn.addEventListener(MouseEvent.CLICK,this.__selectPayNum);
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._payNumtxt.addEventListener(Event.CHANGE,this.__txtInputCheck);
         this._group.addEventListener(Event.CHANGE,this.__selectedChange);
      }
      
      private function removeEvent() : void
      {
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__selectPayNum);
         this._removeBtn.removeEventListener(MouseEvent.CLICK,this.__selectPayNum);
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._payNumtxt.removeEventListener(Event.CHANGE,this.__txtInputCheck);
         this._group.addEventListener(Event.CHANGE,this.__selectedChange);
      }
      
      protected function __selectedChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.alertMoney();
      }
      
      private function __txtInputCheck(e:Event) : void
      {
         this._payNum = parseInt(this._payNumtxt.text);
         this.checkInput();
         this.alertMoney();
      }
      
      private function checkInput() : void
      {
         if(this._payNum <= 1)
         {
            this._payNum = 1;
         }
         else if(this._payNum > MaxNum)
         {
            this._payNum = MaxNum;
         }
         this._payNumtxt.text = this._payNum.toString();
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(Boolean(this._shopItemInfo))
               {
                  if(this._shopType == ShopType.FARM_PETEGG_TYPE)
                  {
                     this.sendFarmShopCreditPay();
                  }
                  else
                  {
                     this.sendFarmShop();
                  }
               }
         }
      }
      
      private function sendFarmShopCreditPay() : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.petScore < this._spendValue)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.farm.scoreNotEnough"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlertOne",60,false);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this.__response);
            alert.titleOuterRectPosString = "125,12,5";
            return;
         }
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         for(var i:int = 0; i < this._payNum; i++)
         {
            items.push(this._shopItemInfo.GoodsID);
            types.push(1);
            colors.push("");
            dresses.push(false);
            skins.push("");
            places.push(-1);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
         this.dispose();
      }
      
      private function sendFarmShop() : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         switch(this._group.selectIndex)
         {
            case MONEY:
               if(PlayerManager.Instance.Self.Money < this._spendValue)
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlertOne",60,false);
                  alert.addEventListener(FrameEvent.RESPONSE,this.__response);
                  alert.titleOuterRectPosString = "162,10,5";
                  return;
               }
               break;
            case GOLD:
               if(PlayerManager.Instance.Self.Gold < this._spendValue)
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlert",60,false);
                  alert.moveEnable = false;
                  alert.titleOuterRectPosString = "184,10,5";
                  alert.addEventListener(FrameEvent.RESPONSE,this.__response);
                  return;
               }
               break;
            case GIFT:
         }
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         for(var i:int = 0; i < this._payNum; i++)
         {
            items.push(this._shopItemInfo.GoodsID);
            types.push(1);
            colors.push("");
            dresses.push(false);
            skins.push("");
            places.push(-1);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
         this.dispose();
      }
      
      private function __response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(this._shopType == ShopType.FARM_PETEGG_TYPE)
            {
               alert.dispose();
               this.dispose();
               return;
            }
            switch(this._group.selectIndex)
            {
               case MONEY:
                  LeavePageManager.leaveToFillPath();
                  break;
               case GOLD:
                  this.okFastPurchaseGold();
                  break;
               case GIFT:
            }
         }
         alert.dispose();
         this.dispose();
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __selectPayNum(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(e.currentTarget)
         {
            case this._addBtn:
               ++this._payNum;
               break;
            case this._removeBtn:
               if(this._payNum < 1)
               {
                  this._payNum == 1;
               }
               else
               {
                  --this._payNum;
               }
         }
         this.checkInput();
         this.alertMoney();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._addBtn))
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(Boolean(this._cellBg))
         {
            ObjectUtils.disposeObject(this._cellBg);
            this._cellBg = null;
         }
         if(Boolean(this._shopPayItem))
         {
            ObjectUtils.disposeObject(this._shopPayItem);
            this._shopPayItem = null;
         }
         if(Boolean(this._payNumBg))
         {
            ObjectUtils.disposeObject(this._payNumBg);
            this._payNumBg = null;
         }
         if(Boolean(this._payNumtxt))
         {
            ObjectUtils.disposeObject(this._payNumtxt);
            this._payNumtxt = null;
         }
         if(Boolean(this._myCreditTxt))
         {
            ObjectUtils.disposeObject(this._myCreditTxt);
            this._myCreditTxt = null;
         }
         if(Boolean(this._myCreditNum))
         {
            ObjectUtils.disposeObject(this._myCreditNum);
            this._myCreditNum = null;
         }
         if(Boolean(this._alertTips))
         {
            ObjectUtils.disposeObject(this._alertTips);
            this._alertTips = null;
         }
         if(Boolean(this._removeBtn))
         {
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
         }
         if(Boolean(this._money))
         {
            ObjectUtils.disposeObject(this._money);
            this._money = null;
         }
         if(Boolean(this._gift))
         {
            ObjectUtils.disposeObject(this._gift);
            this._gift = null;
         }
         if(Boolean(this._gold))
         {
            ObjectUtils.disposeObject(this._gold);
            this._gold = null;
         }
         if(Boolean(this._group))
         {
            ObjectUtils.disposeObject(this._group);
            this._group = null;
         }
         if(Boolean(this._totalBg))
         {
            ObjectUtils.disposeObject(this._totalBg);
            this._totalBg = null;
         }
         if(Boolean(this._alertTips2))
         {
            ObjectUtils.disposeObject(this._alertTips2);
            this._alertTips2 = null;
         }
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

