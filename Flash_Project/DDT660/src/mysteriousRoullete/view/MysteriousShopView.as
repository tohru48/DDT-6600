package mysteriousRoullete.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import mysteriousRoullete.MysteriousManager;
   
   public class MysteriousShopView extends Sprite implements Disposeable
   {
      
      private static const NUMBER:int = 2;
      
      private static const LENGTH:int = 8;
      
      private var _shopTitle:Bitmap;
      
      private var _freeBG:Bitmap;
      
      private var _discountBG:Bitmap;
      
      private var _freeCount:FilterFrameText;
      
      private var _discountCount:FilterFrameText;
      
      private var _freePanel:ScrollPanel;
      
      private var _discontPanel:ScrollPanel;
      
      private var _freeItemList:SimpleTileList;
      
      private var _freeItemArr:Array;
      
      private var _discountItemList:SimpleTileList;
      
      private var _discountItemArr:Array;
      
      public function MysteriousShopView()
      {
         super();
         this._freeItemArr = [];
         this._discountItemArr = [];
         this.initView();
         this.initData();
      }
      
      public function initView() : void
      {
         this._shopTitle = ComponentFactory.Instance.creat("mysteriousRoulette.shopTitle");
         addChild(this._shopTitle);
         this._freeBG = ComponentFactory.Instance.creat("mysteriousRoulette.freeBG");
         addChild(this._freeBG);
         this._discountBG = ComponentFactory.Instance.creat("mysteriousRoulette.discountBG");
         addChild(this._discountBG);
         this._freeCount = ComponentFactory.Instance.creat("mysteriousRoulette.freeCount");
         this._freeCount.text = "0";
         addChild(this._freeCount);
         this._discountCount = ComponentFactory.Instance.creat("mysteriousRoulette.discountCount");
         this._discountCount.text = "0";
         addChild(this._discountCount);
         this._freePanel = ComponentFactory.Instance.creat("mysteriousRoulette.freePanel");
         addChild(this._freePanel);
         this._freeItemList = ComponentFactory.Instance.creatCustomObject("mysteriousRoulette.freeItemList",[NUMBER]);
         this._freePanel.setView(this._freeItemList);
         this._discontPanel = ComponentFactory.Instance.creat("mysteriousRoulette.discountPanel");
         addChild(this._discontPanel);
         this._discountItemList = ComponentFactory.Instance.creatCustomObject("mysteriousRoulette.discountItemList",[NUMBER]);
         this._discontPanel.setView(this._discountItemList);
      }
      
      private function initData() : void
      {
         var item:MysteriousShopItem = null;
         var item2:MysteriousShopItem = null;
         var freeItemArr:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(96);
         for(var i:int = 0; i <= freeItemArr.length - 1; i++)
         {
            item = new MysteriousShopItem(MysteriousShopItem.TYPE_FREE);
            item.shopItemInfo = freeItemArr[i];
            this._freeItemList.addChild(item);
            this._freeItemArr.push(item);
         }
         var discountItemArr:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(97);
         for(var j:int = 0; j <= discountItemArr.length - 1; j++)
         {
            item2 = new MysteriousShopItem(MysteriousShopItem.TYPE_DISCOUNT);
            item2.shopItemInfo = discountItemArr[j];
            this._discountItemList.addChild(item2);
            this._discountItemArr.push(item2);
         }
         this.setTimes();
      }
      
      public function setTimes() : void
      {
         var freeTimes:int = MysteriousManager.instance.freeGetTimes;
         var discountTimes:int = MysteriousManager.instance.discountBuyTimes;
         this._freeCount.text = freeTimes.toString();
         this._discountCount.text = discountTimes.toString();
         var grayFlag1:Boolean = freeTimes == 0 ? true : false;
         var grayFlag2:Boolean = discountTimes == 0 ? true : false;
         for(var i:int = 0; i <= this._freeItemArr.length - 1; i++)
         {
            (this._freeItemArr[i] as MysteriousShopItem).turnGray(grayFlag1);
         }
         for(var j:int = 0; j <= this._discountItemArr.length - 1; j++)
         {
            (this._discountItemArr[j] as MysteriousShopItem).turnGray(grayFlag2);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._shopTitle))
         {
            ObjectUtils.disposeObject(this._shopTitle);
         }
         this._shopTitle = null;
         if(Boolean(this._freeBG))
         {
            ObjectUtils.disposeObject(this._freeBG);
         }
         this._freeBG = null;
         if(Boolean(this._discountBG))
         {
            ObjectUtils.disposeObject(this._discountBG);
         }
         this._discountBG = null;
         if(Boolean(this._freeCount))
         {
            ObjectUtils.disposeObject(this._freeCount);
         }
         this._freeCount = null;
         if(Boolean(this._discountCount))
         {
            ObjectUtils.disposeObject(this._discountCount);
         }
         this._discountCount = null;
         if(Boolean(this._freePanel))
         {
            ObjectUtils.disposeObject(this._freePanel);
         }
         this._freePanel = null;
         if(Boolean(this._discontPanel))
         {
            ObjectUtils.disposeObject(this._discontPanel);
         }
         this._discontPanel = null;
         if(Boolean(this._freeItemList))
         {
            ObjectUtils.disposeObject(this._freeItemList);
         }
         this._freeItemList = null;
         if(Boolean(this._discountItemList))
         {
            ObjectUtils.disposeObject(this._discountItemList);
         }
         this._discountItemList = null;
      }
   }
}

