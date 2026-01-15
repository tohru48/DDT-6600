package giftSystem.view
{
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   import giftSystem.element.TurnPage;
   
   public class GiftShopView extends Sprite implements Disposeable
   {
      
      public static const HOT_GOODS:int = 0;
      
      public static const FLOWER:int = 1;
      
      public static const DESSERT:int = 2;
      
      public static const TOY:int = 3;
      
      public static const RARE:int = 4;
      
      public static const FESTIVAL:int = 5;
      
      public static const WEDDING:int = 6;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      private var _title:Bitmap;
      
      private var _BG1:MovieImage;
      
      private var _BG2:MutipleImage;
      
      private var _hbox:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _hotGoodsBtn:SelectedTextButton;
      
      private var _flowerBtn:SelectedTextButton;
      
      private var _dessertBtn:SelectedTextButton;
      
      private var _toyBtn:SelectedTextButton;
      
      private var _rareBtn:SelectedTextButton;
      
      private var _festivalBtn:SelectedTextButton;
      
      private var _weddingBtn:SelectedTextButton;
      
      private var _prompt:FilterFrameText;
      
      private var _turnPage:TurnPage;
      
      private var _goodsList:GiftGoodsListView;
      
      private var _thisShine:IEffect;
      
      private var container:Sprite;
      
      private var _shopMoneySelectedCkBtn:SelectedCheckButton;
      
      private var _shopDDTMoneySelectedCkBtn:SelectedCheckButton;
      
      private var _shopMoneyGroup:SelectedButtonGroup;
      
      private var _moneyBg:Bitmap;
      
      private var time:Timer;
      
      public function GiftShopView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.container = new Sprite();
         this._BG1 = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.BG1");
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.BG2");
         this._title = ComponentFactory.Instance.creatBitmap("asset.giftShop.title");
         this._hotGoodsBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.hotGoods");
         this._hotGoodsBtn.text = LanguageMgr.GetTranslation("shop.ShopRightView.TopBtn.recommend");
         this._flowerBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.flower");
         this._flowerBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.xianhua");
         this._dessertBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.dessert");
         this._dessertBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.dianxin");
         this._toyBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.toy");
         this._toyBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.wanju");
         this._rareBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.rare");
         this._rareBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.xiyou");
         this._festivalBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.festival");
         this._festivalBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.jieri");
         this._weddingBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.wedding");
         this._weddingBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.shop.hunqing");
         this._prompt = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.prompt");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("turnPage");
         this._goodsList = ComponentFactory.Instance.creatCustomObject("giftGoodListView");
         this._btnGroup = new SelectedButtonGroup();
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.Preview.ruleview.hbox");
         this._btnGroup.addSelectItem(this._hotGoodsBtn);
         this._btnGroup.addSelectItem(this._flowerBtn);
         this._btnGroup.addSelectItem(this._dessertBtn);
         this._btnGroup.addSelectItem(this._toyBtn);
         this._btnGroup.addSelectItem(this._rareBtn);
         this._btnGroup.addSelectItem(this._festivalBtn);
         this._btnGroup.addSelectItem(this._weddingBtn);
         if(GiftController.Instance.inChurch)
         {
            this._btnGroup.selectIndex = 6;
         }
         else
         {
            this._btnGroup.selectIndex = 0;
         }
         addChild(this.container);
         this.container.addChild(this._BG1);
         addChild(this._BG2);
         this.container.addChild(this._title);
         addChild(this._hbox);
         this._hbox.addChild(this._hotGoodsBtn);
         this._hbox.addChild(this._flowerBtn);
         this._hbox.addChild(this._dessertBtn);
         this._hbox.addChild(this._toyBtn);
         this._hbox.addChild(this._rareBtn);
         this._hbox.addChild(this._festivalBtn);
         this._hbox.addChild(this._weddingBtn);
         addChild(this._prompt);
         addChild(this._turnPage);
         addChild(this._goodsList);
         var data:Object = new Object();
         data[AlphaShinerAnimation.BLUR_WIDTH] = 12;
         data[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._thisShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.container,data);
         this._thisShine.stop();
         this._prompt.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftShopView.chooseGiftForFriend");
         this.__changeHandler(null);
         this._moneyBg = ComponentFactory.Instance.creatBitmap("asset.giftShop.moneybg");
         this._shopMoneySelectedCkBtn = ComponentFactory.Instance.creatComponentByStylename("giftShop.moneySelectedCkBtn");
         this._shopDDTMoneySelectedCkBtn = ComponentFactory.Instance.creatComponentByStylename("giftShop.ddtMoneySelectedCkBtn");
         this._shopMoneyGroup = new SelectedButtonGroup();
         this._shopMoneyGroup.addSelectItem(this._shopMoneySelectedCkBtn);
         this._shopMoneyGroup.addSelectItem(this._shopDDTMoneySelectedCkBtn);
         this._shopMoneyGroup.selectIndex = CURRENT_MONEY_TYPE - 1;
      }
      
      private function initEvent() : void
      {
         this._hotGoodsBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._flowerBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._dessertBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._toyBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rareBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._festivalBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._weddingBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._turnPage.addEventListener(TurnPage.CURRENTPAGE_CHANGE,this.__upView);
         GiftController.Instance.addEventListener(GiftEvent.REBACK_GIFT,this.__showLight);
         this._shopMoneyGroup.addEventListener(Event.CHANGE,this.__moneySelectBtnChangeHandler);
      }
      
      private function __moneySelectBtnChangeHandler(e:Event) : void
      {
         var idx:int = this._shopMoneyGroup.selectIndex + 1;
         if(CURRENT_MONEY_TYPE == idx)
         {
            return;
         }
         CURRENT_MONEY_TYPE = idx;
         this.__upView(null);
         SoundManager.instance.play("008");
      }
      
      private function __showLight(event:GiftEvent) : void
      {
         this._thisShine.play();
         this.time = new Timer(4500,1);
         this.time.start();
         this.time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
      }
      
      private function __timeOver(event:TimerEvent) : void
      {
         this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
         this._thisShine.stop();
      }
      
      private function __changeHandler(event:Event) : void
      {
         this._turnPage.current = 1;
         this._turnPage.total = ShopManager.Instance.getResultPages(this.getType(),6);
         this.__upView(null);
         this._hbox.arrange();
      }
      
      private function __upView(evt:Event) : void
      {
         this._goodsList.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this._turnPage.current,6));
      }
      
      private function removeEvent() : void
      {
         this._hotGoodsBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._flowerBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._dessertBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._toyBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rareBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._festivalBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._weddingBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._turnPage.removeEventListener(TurnPage.CURRENTPAGE_CHANGE,this.__upView);
         GiftController.Instance.removeEventListener(GiftEvent.REBACK_GIFT,this.__showLight);
         if(Boolean(this.time))
         {
            this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
         }
         this._shopMoneyGroup.removeEventListener(Event.CHANGE,this.__moneySelectBtnChangeHandler);
      }
      
      private function getType() : int
      {
         var shopType:Array = CURRENT_MONEY_TYPE == 2 ? ShopType.GIFT_DDTMONEY_TYPE : ShopType.GIFT_MONEY_TYPE;
         return this._btnGroup.selectIndex > -1 ? int(shopType[this._btnGroup.selectIndex]) : -1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.time = null;
         if(Boolean(this._shopDDTMoneySelectedCkBtn))
         {
            ObjectUtils.disposeObject(this._shopDDTMoneySelectedCkBtn);
            this._shopDDTMoneySelectedCkBtn = null;
         }
         if(Boolean(this._shopMoneySelectedCkBtn))
         {
            ObjectUtils.disposeObject(this._shopMoneySelectedCkBtn);
            this._shopMoneySelectedCkBtn = null;
         }
         if(Boolean(this._moneyBg))
         {
            ObjectUtils.disposeObject(this._moneyBg);
            this._moneyBg = null;
         }
         this._shopMoneyGroup = null;
         if(Boolean(this.container))
         {
            ObjectUtils.disposeObject(this.container);
         }
         this.container = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._BG1))
         {
            ObjectUtils.disposeObject(this._BG1);
         }
         this._BG1 = null;
         if(Boolean(this._BG2))
         {
            ObjectUtils.disposeObject(this._BG2);
         }
         this._BG2 = null;
         if(Boolean(this._hotGoodsBtn))
         {
            ObjectUtils.disposeObject(this._hotGoodsBtn);
         }
         this._hotGoodsBtn = null;
         if(Boolean(this._flowerBtn))
         {
            ObjectUtils.disposeObject(this._flowerBtn);
         }
         this._flowerBtn = null;
         if(Boolean(this._dessertBtn))
         {
            ObjectUtils.disposeObject(this._dessertBtn);
         }
         this._dessertBtn = null;
         if(Boolean(this._toyBtn))
         {
            ObjectUtils.disposeObject(this._toyBtn);
         }
         this._toyBtn = null;
         if(Boolean(this._rareBtn))
         {
            ObjectUtils.disposeObject(this._rareBtn);
         }
         this._rareBtn = null;
         if(Boolean(this._festivalBtn))
         {
            ObjectUtils.disposeObject(this._festivalBtn);
         }
         this._festivalBtn = null;
         if(Boolean(this._weddingBtn))
         {
            ObjectUtils.disposeObject(this._weddingBtn);
         }
         this._weddingBtn = null;
         if(Boolean(this._prompt))
         {
            ObjectUtils.disposeObject(this._prompt);
         }
         this._prompt = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._thisShine))
         {
            EffectManager.Instance.removeEffect(this._thisShine);
         }
         this._thisShine = null;
         if(Boolean(this._goodsList))
         {
            ObjectUtils.disposeObject(this._goodsList);
         }
         this._goodsList = null;
         if(Boolean(this._turnPage))
         {
            ObjectUtils.disposeObject(this._turnPage);
         }
         this._turnPage = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
   }
}

