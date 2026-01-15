package consortion.view.selfConsortia
{
   import bagAndInfo.cell.BaseCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionShopItem extends Sprite implements Disposeable
   {
      
      private var _info:ShopItemInfo;
      
      private var _enable:Boolean;
      
      private var _time:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _cellBG:DisplayObject;
      
      private var _cell:BaseCell;
      
      private var _limitCount:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _selfRichBg:MutipleImage;
      
      private var _selfRichText:FilterFrameText;
      
      private var _selfRichTxt:FilterFrameText;
      
      private var _btnArr:Vector.<ConsortionShopItemBtn>;
      
      private var _line:MutipleImage;
      
      public function ConsortionShopItem($enable:Boolean)
      {
         super();
         this._enable = $enable;
         this.initView();
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("shopFrame.ItemBG1");
         this._cellBG = ComponentFactory.Instance.creatCustomObject("shopFrame.ItemCellBG");
         this._nameTxt = ComponentFactory.Instance.creat("consortion.shopItem.name");
         this._selfRichBg = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.selfRichOfferInputBG");
         this._selfRichText = ComponentFactory.Instance.creat("consortion.shop.selfRichOfferTxt");
         this._selfRichText.text = LanguageMgr.GetTranslation("consortion.shop.selfRichOfferTxt.text");
         this._selfRichTxt = ComponentFactory.Instance.creat("consortion.shop.selfRichOffer");
         this._line = ComponentFactory.Instance.creatComponentByStylename("consortion.shopFrame.VerticalLine");
         var sprite:Sprite = new Sprite();
         sprite.graphics.beginFill(16777215,0);
         sprite.graphics.drawRect(0,0,48,48);
         sprite.graphics.endFill();
         this._cell = new BaseCell(sprite);
         PositionUtils.setPos(this._cell,"consortion.shopItem.CellPos");
         this._limitCount = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItem.limitCount");
         addChild(this._bg);
         addChild(this._cellBG);
         addChild(this._cell);
         addChild(this._limitCount);
         addChild(this._nameTxt);
         addChild(this._selfRichBg);
         addChild(this._selfRichText);
         this._selfRichBg.visible = false;
         this._selfRichText.visible = false;
         addChild(this._selfRichTxt);
         addChild(this._line);
         this._selfRichTxt.visible = false;
         this._btnArr = new Vector.<ConsortionShopItemBtn>(3);
         this.setFilters = this._enable;
         this._limitCount.visible = false;
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i < 3; i++)
         {
            if(Boolean(this._btnArr[i]))
            {
               this._btnArr[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            }
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(Event.CHANGE,this.__limitChange);
         }
      }
      
      private function __limitChange(event:Event) : void
      {
         this._limitCount.text = String(this._info.LimitCount);
      }
      
      public function set setFilters(b:Boolean) : void
      {
         if(b)
         {
            this._bg.filters = null;
         }
         else
         {
            this._bg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set info($info:ShopItemInfo) : void
      {
         if(this._info == $info || !$info)
         {
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(Event.CHANGE,this.__limitChange);
         }
         this._info = $info;
         this._info.addEventListener(Event.CHANGE,this.__limitChange);
         this.upView();
      }
      
      public function set neededRich(num:int) : void
      {
         this._selfRichTxt.text = String(num);
      }
      
      private function upView() : void
      {
         this._cell.info = this._info.TemplateInfo;
         this._nameTxt.text = this._info.TemplateInfo.Name;
         this._limitCount.text = String(this._info.LimitCount);
         this._limitCount.visible = this._info.TemplateInfo.CategoryID == EquipType.NECKLACE ? (this._info.TemplateID == 14011 ? false : true) : false;
         this._limitCount.visible = this._info.LimitCount > -1;
         this._selfRichBg.visible = true;
         this._selfRichText.visible = true;
         this._selfRichTxt.visible = true;
         for(var i:int = 0; i < 3; i++)
         {
            if(this._info.getItemPrice(i + 1).IsValid)
            {
               this._btnArr[i] = new ConsortionShopItemBtn();
               addChild(this._btnArr[i]);
               PositionUtils.setPos(this._btnArr[i],"consortion.shopItem.btnPos" + i);
               this._btnArr[i].setValue(this._info.getItemPrice(i + 1).toString(),this._info.getTimeToString(i + 1));
               this._btnArr[i].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            }
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         var type:int = 0;
         var _quickFrame:QuickBuyFrame = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var target:ConsortionShopItemBtn = event.currentTarget as ConsortionShopItemBtn;
         this._time = this._btnArr.indexOf(target) + 1;
         if(this.checkMoney())
         {
            if(this._info.getItemPrice(this._time).goldValue > 0)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return;
            }
            if(this._info.getItemPrice(this._time).moneyValue > 0)
            {
               type = 3;
            }
            else if(this._info.getItemPrice(this._time).bandDdtMoneyValue > 0)
            {
               type = 4;
            }
            else
            {
               type = 2;
            }
            _quickFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quickFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quickFrame.setItemID(this._info.TemplateID,type,this._time);
            _quickFrame.buyFrom = 0;
            _quickFrame.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            _quickFrame.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            LayerManager.Instance.addToLayer(_quickFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
      }
      
      private function __onResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(Boolean(alert.parent))
         {
            alert.parent.removeChild(alert);
         }
         ObjectUtils.disposeObject(alert);
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(Boolean(this._info))
            {
               this.sendConsortiaShop();
            }
         }
      }
      
      private function sendConsortiaShop() : void
      {
         var items:Array = [this._info.GoodsID];
         var types:Array = [this._time];
         var colors:Array = [""];
         var dresses:Array = [false];
         var skins:Array = [""];
         var places:Array = [-1];
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
      }
      
      private function checkMoney() : Boolean
      {
         var goldAlert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         if(this._info.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return false;
         }
         if(!this._enable)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.checkMoney"));
            return false;
         }
         if(PlayerManager.Instance.Self.Gold < this._info.getItemPrice(this._time).goldValue)
         {
            goldAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            goldAlert.moveEnable = false;
            goldAlert.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return false;
         }
         if(PlayerManager.Instance.Self.Offer < this._info.getItemPrice(this._time).gesteValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongXunbuzu"));
            return false;
         }
         return true;
      }
      
      private function __quickBuyResponse(evt:FrameEvent) : void
      {
         var quickBuy:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         frame.dispose();
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            quickBuy = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            quickBuy.itemID = EquipType.GOLD_BOX;
            quickBuy.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(quickBuy,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         for(var i:int = 0; i < 3; i++)
         {
            if(Boolean(this._btnArr[i]))
            {
               ObjectUtils.disposeObject(this._btnArr[i]);
            }
            this._btnArr[i] = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._cellBG = null;
         this._limitCount = null;
         this._cell = null;
         this._nameTxt = null;
         this._selfRichBg = null;
         this._selfRichText = null;
         this._selfRichTxt = null;
         this._line = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

