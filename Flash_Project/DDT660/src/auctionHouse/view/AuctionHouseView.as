package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.IAuctionHouse;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class AuctionHouseView extends Sprite implements IAuctionHouse, Disposeable
   {
      
      private var _model:AuctionHouseModel;
      
      private var _controller:AuctionHouseController;
      
      private var _isInit:Boolean;
      
      private var _browse:AuctionBrowseView;
      
      private var _buy:AuctionBuyView;
      
      private var _sell:AuctionSellView;
      
      private var _notesButton:BaseButton;
      
      private var _titleMc:ScaleFrameImage;
      
      private var _browse_btn:BaseButton;
      
      private var _buy_btn:BaseButton;
      
      private var _sell_btn:BaseButton;
      
      private var _money:FilterFrameText;
      
      private var _ddtauction:MovieImage;
      
      private var _ddtauctionView:MovieImage;
      
      private var moneyBG:Bitmap;
      
      private var moneyInfoBG:ScaleBitmapImage;
      
      private var _titleBroweBtn:SelectedButton;
      
      private var _titleSellBtn:SelectedButton;
      
      private var _titleBuyBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _moneyBitmap:Bitmap;
      
      private var _titleBG:Bitmap;
      
      private var _titleName:Bitmap;
      
      private var _explainTxt:FilterFrameText;
      
      public function AuctionHouseView(controller:AuctionHouseController, model:AuctionHouseModel)
      {
         super();
         this._isInit = true;
         this._model = model;
         this._controller = controller;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this.y = 5;
         this._ddtauction = ComponentFactory.Instance.creatComponentByStylename("ddtauctionView.BG1");
         addChild(this._ddtauction);
         this._titleBG = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleBg");
         addChild(this._titleBG);
         this._titleBG.x = 206;
         this._titleBG.y = -3;
         this._titleBG.height = 45;
         this._titleName = ComponentFactory.Instance.creatBitmap("asset.ddtauction.titlename");
         addChild(this._titleName);
         this._ddtauctionView = ComponentFactory.Instance.creatComponentByStylename("ddtauctionView.BG2");
         addChild(this._ddtauctionView);
         this._titleBroweBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleAsset");
         addChild(this._titleBroweBtn);
         this._titleSellBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleSellAsset");
         addChild(this._titleSellBtn);
         this._titleBuyBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.TitleBuyAsset");
         addChild(this._titleBuyBtn);
         this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.explainTxt.text");
         this._explainTxt.text = LanguageMgr.GetTranslation("auctionHouse.explainTxt.text",ServerConfigManager.instance.AuctionRate);
         addChild(this._explainTxt);
         this._browse_btn = ComponentFactory.Instance.creat("auctionHouse.Browse_btn");
         addChild(this._browse_btn);
         this._notesButton = ComponentFactory.Instance.creat("auctionHouse.NotesButton");
         addChild(this._notesButton);
         this._buy_btn = ComponentFactory.Instance.creat("auctionHouse.Buy_btn");
         addChild(this._buy_btn);
         this._sell_btn = ComponentFactory.Instance.creat("auctionHouse.Sell_btn");
         addChild(this._sell_btn);
         this.moneyBG = ComponentFactory.Instance.creatBitmap("asset.ddtauction.moneyBG");
         addChild(this.moneyBG);
         this.moneyInfoBG = ComponentFactory.Instance.creatComponentByStylename("ddtauction.moneyInfoBG");
         addChild(this.moneyInfoBG);
         this._money = ComponentFactory.Instance.creat("auctionHouse.money");
         addChild(this._money);
         this._moneyBitmap = ComponentFactory.Instance.creatBitmap("asset.core.ticketIcon");
         PositionUtils.setPos(this._moneyBitmap,"asset.core.ticketIcon.pos");
         addChild(this._moneyBitmap);
         this._browse = new AuctionBrowseView(this._controller,this._model);
         this._buy = new AuctionBuyView();
         this._sell = new AuctionSellView(this._controller,this._model);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._titleBroweBtn);
         this._btnGroup.addSelectItem(this._titleSellBtn);
         this._btnGroup.addSelectItem(this._titleBuyBtn);
         this._btnGroup.selectIndex = 0;
         this.update();
         this.updateAccount();
      }
      
      private function addEvent() : void
      {
         this._browse_btn.addEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.addEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.addEventListener(MouseEvent.CLICK,this.__sell);
         this._notesButton.addEventListener(MouseEvent.CLICK,this.__showDescription);
         this._model.addEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._btnGroup.addEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._model.addEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,this.__getCategory);
         this._model.myAuctionData.addEventListener(DictionaryEvent.ADD,this.__addMyAuction);
         this._model.myAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearMyAuction);
         this._model.myAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateMyAuction);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.ADD,this.__addBrowse);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearBrowse);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.REMOVE,this.__removeBrowse);
         this._model.browseAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateBrowse);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.ADD,this.__addBuyAuction);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.CLEAR,this.__clearBuyAuction);
         this._model.buyAuctionData.addEventListener(DictionaryEvent.UPDATE,this.__updateBuyAuction);
         this._model.addEventListener(AuctionHouseEvent.UPDATE_PAGE,this.__updatePage);
         this._model.addEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,this.__browserTypeChange);
         this._sell.addEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._sell.addEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         this._sell.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.__sellSortChange);
         this._browse.addEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._browse.addEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      private function removeEvent() : void
      {
         this._browse_btn.removeEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.removeEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.removeEventListener(MouseEvent.CLICK,this.__sell);
         this._notesButton.removeEventListener(MouseEvent.CLICK,this.__showDescription);
         this._model.removeEventListener(AuctionHouseEvent.CHANGE_STATE,this.__changeState);
         this._model.removeEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,this.__getCategory);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addMyAuction);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearMyAuction);
         this._model.myAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateMyAuction);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addBrowse);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearBrowse);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.REMOVE,this.__removeBrowse);
         this._model.browseAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateBrowse);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.ADD,this.__addBuyAuction);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.CLEAR,this.__clearBuyAuction);
         this._model.buyAuctionData.removeEventListener(DictionaryEvent.UPDATE,this.__updateBuyAuction);
         this._sell.removeEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._sell.removeEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         this._sell.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.__sellSortChange);
         this._model.removeEventListener(AuctionHouseEvent.UPDATE_PAGE,this.__updatePage);
         this._model.removeEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,this.__browserTypeChange);
         this._browse.removeEventListener(AuctionHouseEvent.PRE_PAGE,this.__prePage);
         this._browse.removeEventListener(AuctionHouseEvent.NEXT_PAGE,this.__nextPage);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      public function forbidChangeState() : void
      {
         this._browse_btn.removeEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.removeEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.removeEventListener(MouseEvent.CLICK,this.__sell);
      }
      
      public function allowChangeState() : void
      {
         this._browse_btn.addEventListener(MouseEvent.CLICK,this.__browse);
         this._buy_btn.addEventListener(MouseEvent.CLICK,this.__buy);
         this._sell_btn.addEventListener(MouseEvent.CLICK,this.__sell);
      }
      
      private function __browse(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.BROWSE);
      }
      
      private function __buy(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.BUY);
      }
      
      private function __sell(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._controller.setState(AuctionState.SELL);
      }
      
      private function __changeState(event:AuctionHouseEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var AuctionIDs:Array = null;
         var sAuctionIDs:String = null;
         var lth:int = 0;
         var i:int = 0;
         if(this._model.state == AuctionState.BROWSE)
         {
            this._btnGroup.selectIndex = 0;
            this._browse_btn.mouseEnabled = false;
            this._buy_btn.mouseEnabled = true;
            this._sell_btn.mouseEnabled = true;
            addChild(this._browse);
            if(Boolean(this._buy.parent))
            {
               removeChild(this._buy);
            }
            if(Boolean(this._sell.parent))
            {
               this._sell.hideReady();
            }
            if(Boolean(this._sell.parent))
            {
               removeChild(this._sell);
            }
            if(this._isInit)
            {
               this._isInit = false;
            }
         }
         else if(this._model.state == AuctionState.BUY)
         {
            this._btnGroup.selectIndex = 2;
            this._browse_btn.mouseEnabled = true;
            this._buy_btn.mouseEnabled = false;
            this._sell_btn.mouseEnabled = true;
            addChild(this._buy);
            if(Boolean(this._browse.parent))
            {
               this._browse.hideReady();
            }
            if(Boolean(this._browse.parent))
            {
               removeChild(this._browse);
            }
            if(Boolean(this._sell.parent))
            {
               this._sell.hideReady();
            }
            if(Boolean(this._sell.parent))
            {
               removeChild(this._sell);
            }
            AuctionIDs = SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID];
            sAuctionIDs = "";
            if(Boolean(AuctionIDs) && AuctionIDs.length > 0)
            {
               lth = int(AuctionIDs.length);
               sAuctionIDs = AuctionIDs[0].toString();
               if(lth > 1)
               {
                  for(i = 1; i < lth; i++)
                  {
                     sAuctionIDs += "," + AuctionIDs[i].toString();
                  }
               }
            }
            if(this._model.buyAuctionData.length < 50)
            {
               this._controller.searchAuctionList(1,"",-1,-1,-1,PlayerManager.Instance.Self.ID,0,"false",sAuctionIDs);
            }
         }
         else if(this._model.state == AuctionState.SELL)
         {
            this._btnGroup.selectIndex = 1;
            this._browse_btn.mouseEnabled = true;
            this._buy_btn.mouseEnabled = true;
            this._sell_btn.mouseEnabled = false;
            this._sell.this_left.openBagFrame();
            addChild(this._sell);
            if(Boolean(this._browse.parent))
            {
               this._browse.hideReady();
            }
            if(Boolean(this._browse.parent))
            {
               removeChild(this._browse);
            }
            if(Boolean(this._buy.parent))
            {
               removeChild(this._buy);
            }
            if(this._model.myAuctionData.length < 50)
            {
               this._model.sellCurrent = 1;
               this._controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1,0,"true");
            }
         }
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
      }
      
      public function hide() : void
      {
         this.dispose();
         if(Boolean(parent))
         {
            this._controller.removeChild(this);
         }
      }
      
      private function __updatePage(event:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            this._sell.setPage(this._model.sellCurrent,this._model.sellTotal);
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            this._browse.setPage(this._model.browseCurrent,this._model.browseTotal);
         }
      }
      
      private function __prePage(event:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            if(this._model.sellCurrent > 1)
            {
               this._model.sellCurrent -= 1;
               this._sell.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
            }
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            if(this._model.browseCurrent > 1)
            {
               this._model.browseCurrent -= 1;
               this._browse.searchByCurCondition(this._model.browseCurrent);
            }
         }
      }
      
      private function __nextPage(event:AuctionHouseEvent) : void
      {
         if(this._model.state == AuctionState.SELL)
         {
            if(this._model.sellCurrent < this._model.sellTotalPage)
            {
               this._model.sellCurrent += 1;
               this._sell.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
            }
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            if(this._model.browseCurrent < this._model.browseTotalPage)
            {
               this._model.browseCurrent += 1;
               this._browse.searchByCurCondition(this._model.browseCurrent);
            }
         }
      }
      
      private function __addMyAuction(event:DictionaryEvent) : void
      {
         this._sell.addAuction(event.data as AuctionGoodsInfo);
         this._sell.clearLeft();
      }
      
      private function __clearMyAuction(event:DictionaryEvent) : void
      {
         this._sell.clearList();
      }
      
      private function __removeMyAuction(event:DictionaryEvent) : void
      {
         this._controller.searchAuctionList(this._model.sellCurrent,"",-1,-1,PlayerManager.Instance.Self.ID,-1);
      }
      
      private function __updateMyAuction(event:DictionaryEvent) : void
      {
         this._sell.updateList(event.data as AuctionGoodsInfo);
      }
      
      private function __addBrowse(event:DictionaryEvent) : void
      {
         this._browse.addAuction(event.data as AuctionGoodsInfo);
      }
      
      private function __removeBrowse(event:DictionaryEvent) : void
      {
         this._browse.searchByCurCondition(this._model.browseCurrent);
      }
      
      private function __updateBrowse(event:DictionaryEvent) : void
      {
         this._browse.updateAuction(event.data as AuctionGoodsInfo);
      }
      
      private function __clearBrowse(event:DictionaryEvent) : void
      {
         this._browse.clearList();
      }
      
      private function __browserTypeChange(event:AuctionHouseEvent) : void
      {
         this._browse.setSelectType(this._model.currentBrowseGoodInfo);
         this._model.browseCurrent = 1;
         this._browse.searchByCurCondition(1);
      }
      
      private function __addBuyAuction(event:DictionaryEvent) : void
      {
         this._buy.addAuction(event.data as AuctionGoodsInfo);
      }
      
      private function __removeBuyAuction(event:DictionaryEvent) : void
      {
         this._buy.removeAuction();
         this._controller.searchAuctionList(this._model.browseCurrent,"",-1,-1,-1,PlayerManager.Instance.Self.ID);
      }
      
      private function __clearBuyAuction(event:DictionaryEvent) : void
      {
         this._buy.clearList();
      }
      
      private function __updateBuyAuction(event:DictionaryEvent) : void
      {
         this._buy.updateAuction(event.data as AuctionGoodsInfo);
      }
      
      private function __changeMoney(event:PlayerPropertyEvent) : void
      {
         this.updateAccount();
      }
      
      private function __sellSortChange(e:AuctionHouseEvent) : void
      {
         this._browse.searchByCurCondition(this._model.sellCurrent,PlayerManager.Instance.Self.ID);
      }
      
      private function updateAccount() : void
      {
         this._money.text = String(PlayerManager.Instance.Self.Money);
      }
      
      private function __showDescription(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var desctrptionFrame:AuctionDescriptionFrame = ComponentFactory.Instance.creat("auctionHouse.NotesFrame");
         LayerManager.Instance.addToLayer(desctrptionFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __getCategory(event:AuctionHouseEvent) : void
      {
         this._model.browseCurrent = 1;
         this._browse.setCategory(this._model.category);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._model = null;
         this._controller = null;
         if(Boolean(this._browse))
         {
            ObjectUtils.disposeObject(this._browse);
         }
         this._browse = null;
         if(Boolean(this._buy))
         {
            ObjectUtils.disposeObject(this._buy);
         }
         this._buy = null;
         if(Boolean(this._sell))
         {
            ObjectUtils.disposeObject(this._sell);
         }
         this._sell = null;
         if(Boolean(this._notesButton))
         {
            ObjectUtils.disposeObject(this._notesButton);
         }
         this._notesButton = null;
         if(Boolean(this._browse_btn))
         {
            ObjectUtils.disposeObject(this._browse_btn);
         }
         this._browse_btn = null;
         if(Boolean(this._buy_btn))
         {
            ObjectUtils.disposeObject(this._buy_btn);
         }
         this._buy_btn = null;
         if(Boolean(this._sell_btn))
         {
            ObjectUtils.disposeObject(this._sell_btn);
         }
         this._sell_btn = null;
         if(Boolean(this._money))
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this.moneyBG))
         {
            ObjectUtils.disposeObject(this.moneyBG);
         }
         this.moneyBG = null;
         if(Boolean(this.moneyInfoBG))
         {
            ObjectUtils.disposeObject(this.moneyInfoBG);
         }
         this.moneyInfoBG = null;
         if(Boolean(this._titleBroweBtn))
         {
            ObjectUtils.disposeObject(this._titleBroweBtn);
         }
         this._titleBroweBtn = null;
         if(Boolean(this._titleBuyBtn))
         {
            ObjectUtils.disposeObject(this._titleBuyBtn);
         }
         this._titleBuyBtn = null;
         if(Boolean(this._explainTxt))
         {
            ObjectUtils.disposeObject(this._explainTxt);
         }
         this._explainTxt = null;
         if(Boolean(this._titleSellBtn))
         {
            ObjectUtils.disposeObject(this._titleSellBtn);
         }
         this._titleSellBtn = null;
         if(Boolean(this._moneyBitmap))
         {
            ObjectUtils.disposeObject(this._moneyBitmap);
         }
         this._moneyBitmap = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._titleBG))
         {
            ObjectUtils.disposeObject(this._titleBG);
         }
         this._titleBG = null;
         if(Boolean(this._titleName))
         {
            ObjectUtils.disposeObject(this._titleName);
         }
         this._titleName = null;
      }
   }
}

