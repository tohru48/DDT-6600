package shop.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import shop.ShopController;
   import shop.ShopEvent;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class ShopRightView extends Sprite implements Disposeable
   {
      
      public static const TOP_RECOMMEND:uint = 0;
      
      public static const SHOP_ITEM_NUM:uint = 8;
      
      public static var CURRENT_GENDER:int = -1;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      public static var CURRENT_PAGE:int = 1;
      
      public static var TOP_TYPE:int = 0;
      
      public static var SUB_TYPE:int = 2;
      
      public static const SHOW_LIGHT:String = "SHOW_LIGHT";
      
      private static var isDiscountType:Boolean = false;
      
      private var _bg:Image;
      
      private var _bg1:Bitmap;
      
      private var _controller:ShopController;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _femaleBtn:SelectedButton;
      
      private var _genderContainer:VBox;
      
      private var _genderGroup:SelectedButtonGroup;
      
      private var _rightViewTitleBg:Bitmap;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _goodItemContainerBg:Image;
      
      private var _goodItemContainerTwoLine:Image;
      
      private var _goodItemGroup:SelectedButtonGroup;
      
      private var _goodItems:Vector.<ShopGoodItem>;
      
      private var _maleBtn:SelectedButton;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _subBtns:Vector.<SelectedTextButton>;
      
      private var _subBtnsContainers:Vector.<HBox>;
      
      private var _subBtnsGroups:Vector.<SelectedButtonGroup>;
      
      private var _currentSubBtnContainerIndex:int;
      
      private var _topBtns:Vector.<SelectedTextButton>;
      
      private var _topBtnsContainer:HBox;
      
      private var _topBtnsGroup:SelectedButtonGroup;
      
      private var _shopSearchBox:Sprite;
      
      private var _shopSearchEndBtnBg:Bitmap;
      
      private var _shopSearchColseBtn:BaseButton;
      
      private var _rightItemLightMc:MovieClip;
      
      private var _shopMoneySelectedCkBtn:SelectedCheckButton;
      
      private var _shopDDTMoneySelectedCkBtn:SelectedCheckButton;
      
      public var _shopMoneyGroup:SelectedButtonGroup;
      
      private var _moneyBg:Bitmap;
      
      private var _moneySeperateLine:Image;
      
      private var _tempTopType:int = -1;
      
      private var _tempCurrentPage:int = -1;
      
      private var _tempSubBtnHBox:HBox;
      
      private var _isSearch:Boolean;
      
      private var _searchShopItemList:Vector.<ShopItemInfo>;
      
      private var _searchItemTotalPage:int;
      
      public function ShopRightView()
      {
         super();
      }
      
      public function get genderGroup() : SelectedButtonGroup
      {
         return this._genderGroup;
      }
      
      public function setup(controller:ShopController) : void
      {
         this._controller = controller;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("ddtshop.RightViewBg");
         addChild(this._bg);
         this._rightViewTitleBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RightViewTitleBg");
         addChild(this._rightViewTitleBg);
         this.initBtns();
         this.initEvent();
         if(CURRENT_GENDER < 0)
         {
            this.setCurrentSex(PlayerManager.Instance.Self.Sex ? 1 : 2);
         }
      }
      
      private function initBtns() : void
      {
         var topBtnStyleName:Array;
         var subBtnStyleName:Array;
         var controlArr:Array;
         var i:uint = 0;
         var topBtnTextTranslation:Array = null;
         var subBtnTextTranslation:Array = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var k:uint = 0;
         i = 0;
         this._topBtns = new Vector.<SelectedTextButton>();
         this._topBtnsGroup = new SelectedButtonGroup();
         this._subBtns = new Vector.<SelectedTextButton>();
         this._subBtnsContainers = new Vector.<HBox>();
         this._subBtnsGroups = new Vector.<SelectedButtonGroup>();
         this._genderGroup = new SelectedButtonGroup();
         this._goodItems = new Vector.<ShopGoodItem>();
         this._goodItemGroup = new SelectedButtonGroup();
         this._firstPage = ComponentFactory.Instance.creat("ddtshop.BtnFirstPage");
         this._prePageBtn = ComponentFactory.Instance.creat("ddtshop.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnNextPage");
         this._endPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnEndPage");
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPage");
         this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPageInput");
         this._topBtnsContainer = ComponentFactory.Instance.creat("ddtshop.TopBtnContainer");
         topBtnStyleName = ["ddtshop.TopBtnRecommend","ddtshop.TopBtnEquipment","ddtshop.TopBtnBeautyup","ddtshop.TopBtnProp","ddtshop.TopBtnDisCount"];
         topBtnTextTranslation = ["shop.ShopRightView.TopBtn.recommend","shop.ShopRightView.TopBtn.equipment","shop.ShopRightView.TopBtn.beautyup","shop.ShopRightView.TopBtn.prop","shop.ShopRightView.TopBtn.discount"];
         topBtnStyleName.forEach(function(pItem:*, pIndex:int, pArray:Array):void
         {
            var btn:SelectedTextButton = ComponentFactory.Instance.creat(pItem as String);
            btn.text = LanguageMgr.GetTranslation(topBtnTextTranslation[pIndex]);
            _topBtns.push(btn);
         });
         this._genderContainer = ComponentFactory.Instance.creat("ddtshop.GenderBtnContainer");
         this._maleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnMale");
         this._femaleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnFemale");
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("ddtshop.RightItemLightMc");
         this._goodItemContainerBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemContainerBg");
         this._goodItemContainerTwoLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TwoLine");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItemContainerAll");
         for(i = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItem");
            dx = this._goodItems[i].width;
            dy = this._goodItems[i].height;
            dx *= int(i % 2);
            dy *= int(i / 2);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].setItemLight(this._rightItemLightMc);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
         }
         this._femaleBtn.displacement = false;
         this._maleBtn.displacement = false;
         this._genderContainer.addChild(this._femaleBtn);
         this._genderContainer.addChild(this._maleBtn);
         this._genderGroup.addSelectItem(this._maleBtn);
         this._genderGroup.addSelectItem(this._femaleBtn);
         for(i = 0; i < this._topBtns.length; i++)
         {
            this._topBtns[i].addEventListener(MouseEvent.CLICK,this.__topBtnClick);
            this._topBtnsContainer.addChild(this._topBtns[i]);
            this._topBtnsGroup.addSelectItem(this._topBtns[i]);
            if(i == 0)
            {
               this._topBtnsGroup.selectIndex = i;
            }
            this._subBtnsGroups[i] = new SelectedButtonGroup();
         }
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerRecommend"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerEquipment"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerBeautyup"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerProp"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerExchange"));
         subBtnStyleName = ["ddtshop.SubBtnHotSaleIcon","ddtshop.SubBtnRecommend","ddtshop.SubBtnDiscount","ddtshop.SubBtnGiftMedalWeapon","ddtshop.SubBtnCloth","ddtshop.SubBtnHat","ddtshop.SubBtnGlasses","ddtshop.SubBtnRing","ddtshop.SubBtnHair","ddtshop.SubBtnEye","ddtshop.SubBtnFace","ddtshop.SubBtnSuit","ddtshop.SubBtnWing","ddtshop.SubBtnFunc","ddtshop.SubBtnSpecial","ddtshop.SubBtnGiftMedalAll"];
         subBtnTextTranslation = ["shop.ShopRightView.SubBtn.hotSale","shop.ShopRightView.SubBtn.recommend","shop.ShopRightView.SubBtn.discount","shop.ShopRightView.SubBtn.weapon","shop.ShopRightView.SubBtn.cloth","shop.ShopRightView.SubBtn.hat","shop.ShopRightView.SubBtn.glasses","shop.ShopRightView.SubBtn.ring","shop.ShopRightView.SubBtn.hair","shop.ShopRightView.SubBtn.eye","shop.ShopRightView.SubBtn.face","shop.ShopRightView.SubBtn.suit","shop.ShopRightView.SubBtn.wing","shop.ShopRightView.SubBtn.func","shop.ShopRightView.SubBtn.special","shop.ShopRightView.SubBtn.giftMedalAll"];
         subBtnStyleName.forEach(function(pItem:*, pIndex:int, pArray:Array):void
         {
            var btn:SelectedTextButton = ComponentFactory.Instance.creat(pItem as String);
            btn.text = LanguageMgr.GetTranslation(subBtnTextTranslation[pIndex]);
            _subBtns.push(btn);
         });
         controlArr = [3,8,13,15];
         k = 0;
         for(i = 0; i < this._subBtns.length; i++)
         {
            if(i == controlArr[k])
            {
               k++;
            }
            if(this._subBtnsContainers[k] == null)
            {
               k++;
            }
            this._subBtns[i].addEventListener(MouseEvent.CLICK,this.__subBtnClick);
            this._subBtnsContainers[k].addChild(this._subBtns[i]);
            this._subBtnsGroups[k].addSelectItem(this._subBtns[i]);
            if(i == 0)
            {
               this._subBtnsGroups[k].selectIndex = i;
            }
            this._subBtnsGroups[k].addEventListener(Event.CHANGE,this.subButtonSelectedChangeHandler);
         }
         addChild(this._firstPage);
         addChild(this._prePageBtn);
         addChild(this._nextPageBtn);
         addChild(this._endPageBtn);
         addChild(this._currentPageInput);
         addChild(this._currentPageTxt);
         addChild(this._genderContainer);
         addChild(this._goodItemContainerBg);
         addChild(this._goodItemContainerTwoLine);
         addChild(this._goodItemContainerAll);
         addChild(this._topBtnsContainer);
         for(i = 0; i < this._subBtnsContainers.length; i++)
         {
            if(Boolean(this._subBtnsContainers[i]))
            {
               addChild(this._subBtnsContainers[i]);
               this._subBtnsContainers[i].visible = false;
               if(i == 0)
               {
                  this._subBtnsContainers[i].visible = true;
               }
            }
         }
         this._shopSearchBox = ComponentFactory.Instance.creatCustomObject("ddtshop.SearchBox");
         this._shopSearchEndBtnBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.SearchResultImage");
         this._shopSearchBox.addChild(this._shopSearchEndBtnBg);
         this._shopSearchColseBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchColseBtn");
         this._shopSearchBox.addChild(this._shopSearchColseBtn);
         addChild(this._shopSearchBox);
         this._shopSearchBox.visible = false;
         this._moneyBg = ComponentFactory.Instance.creatBitmap("asset.shop.moneybg");
         addChild(this._moneyBg);
         this._moneySeperateLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.moneySeperateLine");
         addChild(this._moneySeperateLine);
         this._shopMoneySelectedCkBtn = ComponentFactory.Instance.creatComponentByStylename("ddtShop.moneySelectedCkBtn");
         this._shopDDTMoneySelectedCkBtn = ComponentFactory.Instance.creatComponentByStylename("ddtShop.ddtMoneySelectedCkBtn");
         this._shopMoneyGroup = new SelectedButtonGroup();
         this._shopMoneyGroup.addSelectItem(this._shopMoneySelectedCkBtn);
         this._shopMoneyGroup.addSelectItem(this._shopDDTMoneySelectedCkBtn);
         addChild(this._shopMoneySelectedCkBtn);
         addChild(this._shopDDTMoneySelectedCkBtn);
         this._shopMoneyGroup.selectIndex = CURRENT_MONEY_TYPE - 1;
         if(CURRENT_MONEY_TYPE == 2 && TOP_TYPE == 0)
         {
            SUB_TYPE = 0;
         }
         this._currentSubBtnContainerIndex = SUB_TYPE;
         this.updateBtn();
         this._topBtnsContainer.arrange();
      }
      
      private function updateBtn() : void
      {
         if(Boolean(this._topBtns))
         {
            this._topBtns[4].visible = ShopManager.Instance.isHasDisCountGoods(CURRENT_MONEY_TYPE);
         }
         if(!this._topBtns[4].visible)
         {
            if(TOP_TYPE == 4)
            {
               TOP_TYPE = 0;
               SUB_TYPE = CURRENT_MONEY_TYPE == 1 ? 2 : 0;
               isDiscountType = false;
               this._topBtnsGroup.selectIndex = TOP_TYPE;
               this.showSubBtns(TOP_TYPE);
            }
         }
      }
      
      private function subButtonSelectedChangeHandler(evt:Event) : void
      {
         this._subBtnsContainers[this._currentSubBtnContainerIndex].arrange();
      }
      
      private function initEvent() : void
      {
         this._topBtnsGroup.addEventListener(Event.CHANGE,this.__topBtnChangeHandler);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._shopSearchColseBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
         this._shopMoneyGroup.addEventListener(Event.CHANGE,this.__moneySelectBtnChangeHandler);
         ShopManager.Instance.addEventListener(ShopEvent.DISCOUNT_IS_CHANGE,this.__discountChange);
      }
      
      protected function __discountChange(event:ShopEvent) : void
      {
         this.updateBtn();
         this.loadList();
      }
      
      protected function __moneySelectBtnChangeHandler(e:Event) : void
      {
         var idx:int = this._shopMoneyGroup.selectIndex + 1;
         if(CURRENT_MONEY_TYPE == idx)
         {
            return;
         }
         if(!this._isSearch)
         {
            CURRENT_PAGE = 1;
         }
         CURRENT_MONEY_TYPE = idx;
         if(!ShopManager.Instance.isHasDisCountGoods(CURRENT_MONEY_TYPE) && TOP_TYPE == 4)
         {
            this._topBtnsGroup.selectIndex = TOP_TYPE = 0;
            this.showSubBtns(TOP_TYPE);
            this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE = 0;
            isDiscountType = false;
         }
         if(idx == 2 && TOP_TYPE == 0)
         {
            this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE = 0;
         }
         this.updateBtn();
         this.loadList();
         SoundManager.instance.play("008");
      }
      
      protected function __topBtnChangeHandler(event:Event) : void
      {
         this._topBtnsContainer.arrange();
      }
      
      private function __userGuide(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_SHOP) && PlayerManager.Instance.Self.Grade >= 9)
         {
            NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT,180,"trainer.shopGiftArrowPos","asset.trainer.txtShopGift","trainer.shopGiftTipPos",null,5);
         }
      }
      
      private function reoveArrow() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
      }
      
      protected function __shopSearchColseBtnClick(event:MouseEvent) : void
      {
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         TOP_TYPE = this._tempTopType;
         this._tempTopType = -1;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         if(!this._tempSubBtnHBox)
         {
            this._tempSubBtnHBox = this._subBtnsContainers[0];
         }
         this._tempSubBtnHBox.visible = true;
         CURRENT_PAGE = this._tempCurrentPage;
         this._tempCurrentPage = -1;
         if(TOP_TYPE == 0 && CURRENT_MONEY_TYPE == 2)
         {
            SUB_TYPE = 0;
            this._subBtnsGroups[TOP_TYPE].selectIndex = 0;
         }
         this.loadList();
         SoundManager.instance.play("008");
      }
      
      public function loadList() : void
      {
         if(this._isSearch)
         {
            return;
         }
         if(!isDiscountType)
         {
            this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE));
         }
         else
         {
            this.setList(ShopManager.Instance.getDisCountGoods(CURRENT_MONEY_TYPE,CURRENT_PAGE));
         }
      }
      
      private function getType() : int
      {
         var shopType:Array = [];
         if(CURRENT_MONEY_TYPE == 1)
         {
            shopType = CURRENT_GENDER == 1 ? ShopType.MALE_MONEY_TYPE : ShopType.FEMALE_MONEY_TYPE;
            this._subBtns[1].visible = true;
            this._subBtns[2].visible = true;
         }
         else if(CURRENT_MONEY_TYPE == 2)
         {
            shopType = CURRENT_GENDER == 1 ? ShopType.MALE_DDTMONEY_TYPE : ShopType.FEMALE_DDTMONEY_TYPE;
            this._subBtns[1].visible = false;
            this._subBtns[2].visible = false;
         }
         var result:* = shopType[TOP_TYPE];
         if(result is Array && SUB_TYPE > -1)
         {
            result = result[SUB_TYPE];
         }
         return int(result);
      }
      
      public function setCurrentSex(sex:int) : void
      {
         CURRENT_GENDER = sex;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].selected = false;
            if(!list)
            {
               break;
            }
            if(i < list.length && Boolean(list[i]))
            {
               this._goodItems[i].shopItemInfo = list[i];
            }
         }
         if(!isDiscountType)
         {
            this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
         }
         else
         {
            this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE);
         }
      }
      
      public function searchList($list:Vector.<ShopItemInfo>) : void
      {
         var hBox:HBox = null;
         if(this._searchShopItemList == $list && this._isSearch)
         {
            return;
         }
         this._searchShopItemList = $list;
         if(!this._isSearch)
         {
            this._tempTopType = TOP_TYPE;
            this._tempCurrentPage = CURRENT_PAGE;
         }
         this._isSearch = true;
         TOP_TYPE = -1;
         this._topBtnsGroup.selectIndex = -1;
         this._topBtnsContainer.arrange();
         CURRENT_PAGE = 1;
         for(var i:int = 0; i < this._subBtnsContainers.length; i++)
         {
            hBox = this._subBtnsContainers[i] as HBox;
            if(Boolean(hBox))
            {
               hBox.visible = false;
            }
         }
         this._shopSearchBox.visible = true;
         this.runSearch();
      }
      
      private function runSearch() : void
      {
         var startIndex:int = 0;
         var len:int = 0;
         var i:int = 0;
         this.clearitems();
         this._searchItemTotalPage = Math.ceil(this._searchShopItemList.length / 8);
         if(CURRENT_PAGE > 0 && CURRENT_PAGE <= this._searchItemTotalPage)
         {
            startIndex = 8 * (CURRENT_PAGE - 1);
            len = Math.min(this._searchShopItemList.length - startIndex,8);
            for(i = 0; i < len; i++)
            {
               this._goodItems[i].selected = false;
               if(Boolean(this._searchShopItemList[i + startIndex]))
               {
                  this._goodItems[i].shopItemInfo = this._searchShopItemList[i + startIndex];
               }
            }
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
      }
      
      private function __genderClick(evt:MouseEvent) : void
      {
         var idx:int = evt.currentTarget as SelectedButton == this._maleBtn ? 1 : 2;
         if(CURRENT_GENDER == idx)
         {
            return;
         }
         this.setCurrentSex(idx);
         if(!this._isSearch)
         {
            CURRENT_PAGE = 1;
         }
         this._controller.setFittingModel(CURRENT_GENDER == 1);
         SoundManager.instance.play("008");
      }
      
      private function __itemSelect(evt:ItemEvent) : void
      {
         var j:ISelectable = null;
         evt.stopImmediatePropagation();
         var item:ShopGoodItem = evt.currentTarget as ShopGoodItem;
         for each(j in this._goodItems)
         {
            j.selected = false;
         }
         item.selected = true;
      }
      
      private function __itemClick(evt:ItemEvent) : void
      {
         var i:ISelectable = null;
         var j:ISelectable = null;
         var isAdd:Boolean = false;
         var isColorEditorVisble:Boolean = false;
         var sexId:int = 0;
         var shopItem:ShopCarItemInfo = null;
         var item:ShopGoodItem = evt.currentTarget as ShopGoodItem;
         if(this._controller.model.isOverCount(item.shopItemInfo))
         {
            for each(i in this._goodItems)
            {
               i.selected = i == item;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         if(Boolean(item.shopItemInfo) && Boolean(item.shopItemInfo.TemplateInfo))
         {
            for each(j in this._goodItems)
            {
               j.selected = j == item;
            }
            if(EquipType.dressAble(item.shopItemInfo.TemplateInfo))
            {
               sexId = item.shopItemInfo.TemplateInfo.NeedSex != 2 ? 0 : 1;
               if(item.shopItemInfo.TemplateInfo.NeedSex != 0 && this._genderGroup.selectIndex != sexId)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.sexAlert"));
                  return;
               }
               this._controller.addTempEquip(item.shopItemInfo);
            }
            else
            {
               shopItem = new ShopCarItemInfo(item.shopItemInfo.GoodsID,item.shopItemInfo.TemplateID);
               ObjectUtils.copyProperties(shopItem,item.shopItemInfo);
               isAdd = this._controller.addToCar(shopItem);
            }
            this.itemClick(item);
            isColorEditorVisble = this._controller.leftView.getColorEditorVisble();
            if(isAdd && !isColorEditorVisble)
            {
               this.addCartEffects(item.itemCell);
            }
         }
         dispatchEvent(new Event(SHOW_LIGHT));
      }
      
      private function addCartEffects($item:DisplayObject) : void
      {
         var tp:TweenProxy = null;
         var timeline:TimelineLite = null;
         var tw:TweenLite = null;
         var tw1:TweenLite = null;
         if(!$item)
         {
            return;
         }
         var tempBitmapD:BitmapData = new BitmapData($item.width,$item.height,true,0);
         tempBitmapD.draw($item);
         var bitmap:Bitmap = new Bitmap(tempBitmapD,"auto",true);
         parent.addChild(bitmap);
         tp = TweenProxy.create(bitmap);
         tp.registrationX = tp.width / 2;
         tp.registrationY = tp.height / 2;
         var pos:Point = DisplayUtils.localizePoint(parent,$item);
         tp.x = pos.x + tp.width / 2;
         tp.y = pos.y + tp.height / 2;
         timeline = new TimelineLite();
         timeline.vars.onComplete = this.twComplete;
         timeline.vars.onCompleteParams = [timeline,tp,bitmap];
         tw = new TweenLite(tp,0.3,{
            "x":220,
            "y":430
         });
         tw1 = new TweenLite(tp,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         timeline.append(tw);
         timeline.append(tw1,-0.2);
      }
      
      private function twComplete(timeline:TimelineLite, tp:TweenProxy, bitmap:Bitmap) : void
      {
         if(Boolean(timeline))
         {
            timeline.kill();
         }
         if(Boolean(tp))
         {
            tp.destroy();
         }
         if(Boolean(bitmap.parent))
         {
            bitmap.parent.removeChild(bitmap);
            bitmap.bitmapData.dispose();
         }
         tp = null;
         bitmap = null;
         timeline = null;
      }
      
      private function itemClick(item:ShopGoodItem) : void
      {
         if(item.shopItemInfo.TemplateInfo != null)
         {
            if(CURRENT_GENDER != item.shopItemInfo.TemplateInfo.NeedSex && item.shopItemInfo.TemplateInfo.NeedSex != 0)
            {
               this.setCurrentSex(item.shopItemInfo.TemplateInfo.NeedSex);
               this._controller.setFittingModel(CURRENT_GENDER == 1);
            }
         }
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSearch)
         {
            if(!isDiscountType)
            {
               if(ShopManager.Instance.getResultPages(this.getType()) == 0)
               {
                  return;
               }
            }
            else if(ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE) == 0)
            {
               return;
            }
            switch(evt.currentTarget)
            {
               case this._firstPage:
                  if(CURRENT_PAGE != 1)
                  {
                     CURRENT_PAGE = 1;
                  }
                  break;
               case this._prePageBtn:
                  if(CURRENT_PAGE == 1)
                  {
                     if(!isDiscountType)
                     {
                        CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
                     }
                     else
                     {
                        CURRENT_PAGE = ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE) + 1;
                     }
                  }
                  --CURRENT_PAGE;
                  break;
               case this._nextPageBtn:
                  if(!isDiscountType)
                  {
                     if(CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
                     {
                        CURRENT_PAGE = 0;
                     }
                  }
                  else if(CURRENT_PAGE == ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE))
                  {
                     CURRENT_PAGE = 0;
                  }
                  ++CURRENT_PAGE;
                  break;
               case this._endPageBtn:
                  if(!isDiscountType)
                  {
                     if(CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
                     {
                        CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
                     }
                  }
                  else if(CURRENT_PAGE != ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE))
                  {
                     CURRENT_PAGE = ShopManager.Instance.getDisCountResultPages(CURRENT_MONEY_TYPE);
                  }
            }
            this.loadList();
         }
         else
         {
            switch(evt.currentTarget)
            {
               case this._firstPage:
                  if(CURRENT_PAGE != 1)
                  {
                     CURRENT_PAGE = 1;
                  }
                  break;
               case this._prePageBtn:
                  if(CURRENT_PAGE == 1)
                  {
                     CURRENT_PAGE = this._searchItemTotalPage + 1;
                  }
                  --CURRENT_PAGE;
                  break;
               case this._nextPageBtn:
                  if(CURRENT_PAGE == this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = 0;
                  }
                  ++CURRENT_PAGE;
                  break;
               case this._endPageBtn:
                  if(CURRENT_PAGE != this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = this._searchItemTotalPage;
                  }
            }
            this.runSearch();
         }
      }
      
      private function __subBtnClick(event:MouseEvent) : void
      {
         this.reoveArrow();
         var idx:int = this._subBtnsContainers[TOP_TYPE].getChildIndex(event.currentTarget as SelectedButton);
         if(idx != SUB_TYPE)
         {
            SUB_TYPE = idx;
            CURRENT_PAGE = 1;
            this.loadList();
            SoundManager.instance.play("008");
         }
      }
      
      private function __topBtnClick(event:MouseEvent) : void
      {
         this._topBtnsContainer.arrange();
         var idx:int = int(this._topBtns.indexOf(event.currentTarget as SelectedTextButton));
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         this._tempTopType = -1;
         this._tempCurrentPage = -1;
         if(idx != TOP_TYPE)
         {
            TOP_TYPE = idx;
            SUB_TYPE = 0;
            CURRENT_PAGE = 1;
            this.showSubBtns(idx);
            this._currentSubBtnContainerIndex = idx;
            if(TOP_TYPE == 4)
            {
               isDiscountType = true;
               if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_SHOP) && PlayerManager.Instance.Self.Grade >= 9)
               {
                  NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                  SocketManager.Instance.out.syncWeakStep(Step.GUIDE_SHOP);
               }
            }
            else
            {
               isDiscountType = false;
               this.disposeUserGuide();
            }
            this.loadList();
            SoundManager.instance.play("008");
         }
      }
      
      private function disposeUserGuide() : void
      {
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._topBtnsGroup.removeEventListener(Event.CHANGE,this.__topBtnChangeHandler);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         for(var i:uint = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
         }
         for(i = 0; i < this._topBtns.length; i++)
         {
            this._topBtns[i].removeEventListener(MouseEvent.CLICK,this.__topBtnClick);
         }
         for(i = 0; i < this._subBtns.length; i++)
         {
            this._subBtns[i].removeEventListener(MouseEvent.CLICK,this.__subBtnClick);
         }
         removeEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
         this._shopSearchColseBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
         this._shopMoneyGroup.removeEventListener(Event.CHANGE,this.__moneySelectBtnChangeHandler);
         ShopManager.Instance.removeEventListener(ShopEvent.DISCOUNT_IS_CHANGE,this.__discountChange);
      }
      
      private function showSubBtns(topIdx:int) : void
      {
         var hBox:HBox = null;
         for(var i:int = 0; i < this._subBtnsContainers.length; i++)
         {
            hBox = this._subBtnsContainers[i] as HBox;
            if(Boolean(hBox))
            {
               hBox.visible = false;
            }
         }
         if(Boolean(this._subBtnsContainers[topIdx]))
         {
            this._subBtnsContainers[topIdx].visible = true;
            this._tempSubBtnHBox = this._subBtnsContainers[topIdx];
            this._subBtnsGroups[topIdx].selectIndex = SUB_TYPE;
            this._subBtnsContainers[topIdx].arrange();
         }
      }
      
      public function gotoPage(topType:int = -1, subType:int = -1, currentPage:int = 1, currentGender:int = 1) : void
      {
         var hBox:HBox = null;
         if(topType == 4 && !ShopManager.Instance.isHasDisCountGoods(CURRENT_MONEY_TYPE))
         {
            topType = 0;
            subType = 2;
         }
         if(topType != -1)
         {
            TOP_TYPE = topType;
         }
         if(subType != -1)
         {
            SUB_TYPE = subType;
         }
         CURRENT_PAGE = currentPage;
         CURRENT_GENDER = currentGender;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
         this.setCurrentSex(CURRENT_GENDER);
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
         for(var i:int = 0; i < this._subBtnsContainers.length; i++)
         {
            hBox = this._subBtnsContainers[i] as HBox;
            if(Boolean(hBox))
            {
               hBox.visible = false;
            }
         }
         if(Boolean(this._subBtnsContainers[TOP_TYPE]))
         {
            this._subBtnsContainers[TOP_TYPE].visible = true;
            this._subBtnsContainers[TOP_TYPE].arrange();
            this._tempSubBtnHBox = this._subBtnsContainers[TOP_TYPE];
         }
         this.loadList();
      }
      
      public function dispose() : void
      {
         NewSevenDayAndNewPlayerManager.Instance.enterShop = false;
         if(this._tempCurrentPage > -1)
         {
            CURRENT_PAGE = this._tempCurrentPage;
         }
         if(this._tempTopType > -1)
         {
            TOP_TYPE = this._tempTopType;
         }
         this.removeEvent();
         this.disposeUserGuide();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._currentPageTxt))
         {
            this._currentPageTxt.dispose();
         }
         this._currentPageTxt = null;
         for(var i:int = 0; i < this._goodItems.length; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         this._goodItems = null;
         for(i = 0; i < this._topBtns.length; i++)
         {
            ObjectUtils.disposeObject(this._topBtns[i]);
            this._topBtns[i] = null;
         }
         this._topBtns = null;
         for(i = 0; i < this._subBtns.length; i++)
         {
            ObjectUtils.disposeObject(this._subBtns[i]);
            this._subBtns[i] = null;
         }
         this._subBtns = null;
         for(i = 0; i < this._subBtnsGroups.length; i++)
         {
            ObjectUtils.disposeObject(this._subBtnsGroups[i]);
            this._subBtnsGroups[i] = null;
            ObjectUtils.disposeObject(this._subBtnsContainers[i]);
            this._subBtnsContainers[i] = null;
         }
         this._subBtnsContainers = null;
         this._subBtnsGroups = null;
         this._controller = null;
         this._goodItemGroup = null;
         this._nextPageBtn = null;
         this._prePageBtn = null;
         this._topBtnsGroup = null;
         this._tempSubBtnHBox = null;
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
         ObjectUtils.disposeObject(this._moneySeperateLine);
         this._moneySeperateLine = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bg1);
         this._bg1 = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._femaleBtn);
         this._femaleBtn = null;
         ObjectUtils.disposeObject(this._genderContainer);
         this._genderContainer = null;
         ObjectUtils.disposeObject(this._genderGroup);
         this._genderGroup = null;
         ObjectUtils.disposeObject(this._rightViewTitleBg);
         this._rightViewTitleBg = null;
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._maleBtn);
         this._maleBtn = null;
         ObjectUtils.disposeObject(this._firstPage);
         this._firstPage = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeObject(this._topBtnsContainer);
         this._topBtnsContainer = null;
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._shopSearchEndBtnBg);
         this._shopSearchEndBtnBg = null;
         ObjectUtils.disposeObject(this._shopSearchColseBtn);
         this._shopSearchColseBtn = null;
         ObjectUtils.disposeObject(this._shopSearchBox);
         this._shopSearchBox = null;
         ObjectUtils.disposeObject(this._goodItemContainerBg);
         this._goodItemContainerBg = null;
         ObjectUtils.disposeObject(this._goodItemContainerTwoLine);
         this._goodItemContainerTwoLine = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

