package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionShopFrame extends Frame
   {
      
      private var _bg:MutipleImage;
      
      private var _scrollbg:ScaleBitmapImage;
      
      private var _bg2:MutipleImage;
      
      private var _bg3:MutipleImage;
      
      private var _gold:FilterFrameText;
      
      private var _money:FilterFrameText;
      
      private var _exploitText:FilterFrameText;
      
      private var _contributionText:FilterFrameText;
      
      private var _offer:FilterFrameText;
      
      private var _ttoffer:FilterFrameText;
      
      private var _level1:SelectedTextButton;
      
      private var _level2:SelectedTextButton;
      
      private var _level3:SelectedTextButton;
      
      private var _level4:SelectedTextButton;
      
      private var _level5:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ConsortionShopList;
      
      private var _word:FilterFrameText;
      
      public function ConsortionShopFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.bg");
         this._scrollbg = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItem.scallBG");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.bg2");
         this._gold = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.gold");
         this._money = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.money");
         this._exploitText = ComponentFactory.Instance.creatComponentByStylename("consortion.shopFrame.exploitText");
         this._exploitText.text = LanguageMgr.GetTranslation("offer");
         this._contributionText = ComponentFactory.Instance.creatComponentByStylename("consortion.shopFrame.contributionText");
         this._contributionText.text = LanguageMgr.GetTranslation("ddt.consortion.skillCell.btnPersonal.rich");
         this._offer = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.offer");
         this._ttoffer = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.ttoffer");
         this._level1 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level1");
         this._level1.text = LanguageMgr.GetTranslation("consortion.shop.level1.text");
         this._level2 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level2");
         this._level2.text = LanguageMgr.GetTranslation("consortion.shop.level2.text");
         this._level3 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level3");
         this._level3.text = LanguageMgr.GetTranslation("consortion.shop.level3.text");
         this._level4 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level4");
         this._level4.text = LanguageMgr.GetTranslation("consortion.shop.level4.text");
         this._level5 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level5");
         this._level5.text = LanguageMgr.GetTranslation("consortion.shop.level5.text");
         this._btnGroup = new SelectedButtonGroup();
         this._list = ComponentFactory.Instance.creatCustomObject("consortionShopList");
         this._word = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.word");
         this._word.text = LanguageMgr.GetTranslation("consortion.shop.word.text");
         addToContent(this._bg);
         addToContent(this._scrollbg);
         addToContent(this._bg2);
         addToContent(this._gold);
         addToContent(this._money);
         addToContent(this._exploitText);
         addToContent(this._contributionText);
         addToContent(this._offer);
         addToContent(this._ttoffer);
         addToContent(this._level1);
         addToContent(this._level2);
         addToContent(this._level3);
         addToContent(this._level4);
         addToContent(this._level5);
         addToContent(this._list);
         addToContent(this._word);
         this._btnGroup.addSelectItem(this._level1);
         this._btnGroup.addSelectItem(this._level2);
         this._btnGroup.addSelectItem(this._level3);
         this._btnGroup.addSelectItem(this._level4);
         this._btnGroup.addSelectItem(this._level5);
         this._btnGroup.selectIndex = 0;
         this._gold.text = String(PlayerManager.Instance.Self.Gold);
         this._money.text = String(PlayerManager.Instance.Self.Money);
         this._offer.text = String(PlayerManager.Instance.Self.Offer);
         this._ttoffer.text = String(PlayerManager.Instance.Self.UseOffer);
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
      }
      
      protected function __useChangeHandler(event:Event) : void
      {
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
      }
      
      private function __propChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Offer"]))
         {
            this._offer.text = String(PlayerManager.Instance.Self.Offer);
         }
         if(Boolean(event.changedProperties["Money"]))
         {
            this._money.text = String(PlayerManager.Instance.Self.Money);
         }
         if(Boolean(event.changedProperties["Gold"]))
         {
            this._gold.text = String(PlayerManager.Instance.Self.Gold);
         }
         if(Boolean(event.changedProperties["BandMoney"]))
         {
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __groupChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function showLevel(index:int) : void
      {
         var rich:int = 0;
         var b:Boolean = PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= index ? true : false;
         var uselist:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         if(uselist == null || uselist.length == 0)
         {
            rich = 100;
         }
         else
         {
            rich = ConsortionModelControl.Instance.model.useConditionList[index - 1].Riches;
         }
         this._list.list(ShopManager.Instance.consortiaShopLevelTemplates(index),index,rich,b);
      }
      
      private function __managerClickHandler(event:MouseEvent) : void
      {
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._scrollbg = null;
         this._bg2 = null;
         this._gold = null;
         this._money = null;
         this._exploitText = null;
         this._contributionText = null;
         this._offer = null;
         this._ttoffer = null;
         this._level1 = null;
         this._level2 = null;
         this._level3 = null;
         this._level4 = null;
         this._level5 = null;
         this._btnGroup = null;
         this._list = null;
         this._word = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

