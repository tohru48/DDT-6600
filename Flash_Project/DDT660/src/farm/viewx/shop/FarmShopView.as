package farm.viewx.shop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import trainer.data.ArrowType;
   
   public class FarmShopView extends Frame
   {
      
      public static const SEEDTYPE:int = 0;
      
      public static var CURRENT_PAGE:int = 1;
      
      public static const SHOP_ITEM_NUM:uint = 10;
      
      public static const PETEGGTYPE:int = 1;
      
      private var _petEggBtn:SelectedButton;
      
      private var _goodItems:Vector.<FarmShopItem>;
      
      private var _currentType:int = 88;
      
      private var _seedBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _goodItemContainerAll:SimpleTileList;
      
      private var _titleShop:DisplayObject;
      
      private var _pageInputBg:DisplayObject;
      
      public function FarmShopView()
      {
         super();
         this._goodItems = new Vector.<FarmShopItem>();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._titleShop = ComponentFactory.Instance.creat("assets.farmShop.title");
         addToContent(this._titleShop);
         this._pageInputBg = ComponentFactory.Instance.creat("farm.farmShopView.fontBG");
         addToContent(this._pageInputBg);
         this._seedBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.seed");
         addToContent(this._seedBtn);
         this._firstPage = ComponentFactory.Instance.creat("farmshop.btnFirstPage");
         addToContent(this._firstPage);
         this._prePageBtn = ComponentFactory.Instance.creat("farmshop.btnPrePage");
         addToContent(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creat("farmshop.btnNextPage");
         addToContent(this._nextPageBtn);
         this._endPageBtn = ComponentFactory.Instance.creat("farmshop.btnEndPage");
         addToContent(this._endPageBtn);
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.shopCurrent");
         addToContent(this._currentPageTxt);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._seedBtn);
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._petEggBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.petEgg");
            addToContent(this._petEggBtn);
            this._btnGroup.addSelectItem(this._petEggBtn);
         }
         this._btnGroup.selectIndex = 0;
         this._goodItemContainerAll = ComponentFactory.Instance.creat("farm.simpleTileList.farmShop",[5]);
         addToContent(this._goodItemContainerAll);
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("farmShop.farmShopItem");
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
         }
         if(PetBagController.instance().petModel.IsFinishTask5)
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_FARM_SHOP);
            PetBagController.instance().petModel.IsFinishTask5 = false;
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
      }
      
      private function __itemClick(evt:ItemEvent) : void
      {
         var item:FarmShopItem = evt.currentTarget as FarmShopItem;
      }
      
      private function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case SEEDTYPE:
               this._currentType = ShopType.FARM_SEED_TYPE;
               break;
            case PETEGGTYPE:
               this._currentType = ShopType.FARM_PETEGG_TYPE;
         }
         CURRENT_PAGE = 1;
         this.loadList();
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
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
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType(),10) + 1;
               }
               --CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType(),10))
               {
                  CURRENT_PAGE = 0;
               }
               ++CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType(),10))
               {
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType(),10);
               }
         }
         this.loadList();
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE,10));
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            if(i < list.length && Boolean(list[i]))
            {
               this._goodItems[i].shopItemInfo = list[i];
            }
            else
            {
               this._goodItems[i].shopItemInfo = null;
            }
            this._goodItems[i].shopType = this.getType();
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType(),10);
      }
      
      private function getType() : int
      {
         return this._currentType;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadList();
      }
      
      override public function dispose() : void
      {
         for(var i:uint = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].dispose();
            this._goodItems[i] = null;
         }
         this._goodItems.splice(0,this._goodItems.length);
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         if(Boolean(this._endPageBtn))
         {
            ObjectUtils.disposeObject(this._endPageBtn);
            this._endPageBtn = null;
         }
         if(Boolean(this._currentPageTxt))
         {
            ObjectUtils.disposeObject(this._currentPageTxt);
            this._currentPageTxt = null;
         }
         if(Boolean(this._nextPageBtn))
         {
            ObjectUtils.disposeObject(this._nextPageBtn);
            this._nextPageBtn = null;
         }
         if(Boolean(this._prePageBtn))
         {
            ObjectUtils.disposeObject(this._prePageBtn);
            this._prePageBtn = null;
         }
         if(Boolean(this._petEggBtn))
         {
            ObjectUtils.disposeObject(this._petEggBtn);
            this._petEggBtn = null;
         }
         if(Boolean(this._firstPage))
         {
            ObjectUtils.disposeObject(this._firstPage);
            this._firstPage = null;
         }
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
            this._btnGroup = null;
         }
         if(Boolean(this._seedBtn))
         {
            ObjectUtils.disposeObject(this._seedBtn);
            this._seedBtn = null;
         }
         if(Boolean(this._titleShop))
         {
            ObjectUtils.disposeObject(this._titleShop);
            this._titleShop = null;
         }
         if(Boolean(this._pageInputBg))
         {
            ObjectUtils.disposeObject(this._pageInputBg);
            this._pageInputBg = null;
         }
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

