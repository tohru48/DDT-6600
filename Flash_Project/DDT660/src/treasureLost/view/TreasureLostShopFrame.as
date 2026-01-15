package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasureLost.controller.TreasureLostManager;
   import treasureLost.events.TreasureLostEvents;
   
   public class TreasureLostShopFrame extends BaseAlerFrame
   {
      
      public static const SHOP_ITEM_NUM:uint = 4;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      private var CURRENT_PAGE:int = 1;
      
      private var _goodItems:Vector.<TreasureLostShopItem>;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _rightItemLightMc:MovieClip;
      
      protected var _goodItemContainerBg:Image;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _navigationBarContainer:Sprite;
      
      private var _coinNumBG:Scale9CornerImage;
      
      private var _coinText:FilterFrameText;
      
      private var _coinNumText:FilterFrameText;
      
      private var _lable:FilterFrameText;
      
      private var othertitleText:FilterFrameText;
      
      public function TreasureLostShopFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var title:String = null;
         var coinTxt:String = null;
         var coinNum:String = null;
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         super.init();
         title = LanguageMgr.GetTranslation("treasureLost.alertInfo.shopTitle");
         coinTxt = LanguageMgr.GetTranslation("treasureLost.treasureLostShopFrame.text1");
         coinNum = TreasureLostManager.Instance.getTreasureLostStoneNum();
         var alerInfo:AlertInfo = new AlertInfo(title,"",LanguageMgr.GetTranslation("tank.calendar.Activity.BackButtonText"),false);
         info = alerInfo;
         this._goodItems = new Vector.<TreasureLostShopItem>();
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("treasureLost.treasureLostShopFrame.RightItemLightMc");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("treasureLost.treasureLostShopFrame.GoodItemContainerAll");
         this._goodItemContainerBg = ComponentFactory.Instance.creatComponentByStylename("treasureLost.treasureLostShopFrame.GoodItemContainerBg");
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("treasureLost.treasureLostShopFrame.navigationBarContainer");
         this._prePageBtn = UICreatShortcut.creatAndAdd("treasureLost.treasureLostShopFrame.BtnPrePage",this._navigationBarContainer);
         this._nextPageBtn = UICreatShortcut.creatAndAdd("treasureLost.treasureLostShopFrame.BtnNextPage",this._navigationBarContainer);
         this._currentPageInput = UICreatShortcut.creatAndAdd("treasureLost.treasureLostShopFrame.CurrentPageInput",this._navigationBarContainer);
         this._currentPageTxt = UICreatShortcut.creatAndAdd("treasureLost.treasureLostShopFrame.CurrentPage",this._navigationBarContainer);
         this._coinNumBG = ComponentFactory.Instance.creatComponentByStylename("treasureLost.treasureLostShopFrame.coinBG");
         this._coinText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.treasureLostShopFrame.coinText");
         this._coinText.text = coinTxt;
         this._coinNumText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.treasureLostShopFrame.coinNumText");
         this._coinNumText.text = coinNum;
         addToContent(this._goodItemContainerBg);
         addToContent(this._goodItemContainerAll);
         addToContent(this._navigationBarContainer);
         addToContent(this._coinNumBG);
         addToContent(this._coinText);
         addToContent(this._coinNumText);
         for(i = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = new TreasureLostShopItem();
            dx = this._goodItems[i].width;
            dy = this._goodItems[i].height;
            dx *= int(i % 2);
            dy *= int(i / 2);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].setItemLight(this._rightItemLightMc);
         }
         this.loadList();
         this.initEvent();
         this._goodItemContainerBg.height = 228;
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.TreasureLostUpdata_Stone_Count,this.upDateStoneHander);
      }
      
      private function upDateStoneHander(e:TreasureLostEvents) : void
      {
         this._coinNumText.text = TreasureLostManager.Instance.getTreasureLostStoneNum();
      }
      
      public function removeEvent() : void
      {
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.TreasureLostUpdata_Stone_Count,this.upDateStoneHander);
         if(Boolean(this._prePageBtn))
         {
            this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         }
         if(Boolean(this._nextPageBtn))
         {
            this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         }
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this.CURRENT_PAGE,SHOP_ITEM_NUM));
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
         this._currentPageTxt.text = this.CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType(),SHOP_ITEM_NUM);
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(this.getType()) == 0)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._firstPage:
               if(this.CURRENT_PAGE != 1)
               {
                  this.CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(this.CURRENT_PAGE == 1)
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType(),SHOP_ITEM_NUM) + 1;
               }
               --this.CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(this.CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType(),SHOP_ITEM_NUM))
               {
                  this.CURRENT_PAGE = 0;
               }
               ++this.CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(this.CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
               }
         }
         this.loadList();
      }
      
      public function getType() : int
      {
         return 89;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function disposeItems() : void
      {
         if(this._goodItems == null)
         {
            return;
         }
         for(var i:int = 0; i < this._goodItems.length; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         this._goodItems = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         if(Boolean(this._rightItemLightMc))
         {
            ObjectUtils.disposeObject(this._rightItemLightMc);
            this._rightItemLightMc = null;
         }
         if(Boolean(this._goodItemContainerBg))
         {
            ObjectUtils.disposeObject(this._goodItemContainerBg);
            this._goodItemContainerBg = null;
         }
         if(Boolean(this._firstPage))
         {
            ObjectUtils.disposeObject(this._firstPage);
            this._firstPage = null;
         }
         if(Boolean(this._prePageBtn))
         {
            ObjectUtils.disposeObject(this._prePageBtn);
            this._prePageBtn = null;
         }
         if(Boolean(this._nextPageBtn))
         {
            ObjectUtils.disposeObject(this._nextPageBtn);
            this._nextPageBtn = null;
         }
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         ObjectUtils.disposeObject(this._coinNumBG);
         this._coinNumBG = null;
         ObjectUtils.disposeObject(this._coinText);
         this._coinText = null;
         ObjectUtils.disposeObject(this._coinNumText);
         this._coinNumText = null;
         ObjectUtils.disposeObject(this._lable);
         this._lable = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

