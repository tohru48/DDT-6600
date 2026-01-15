package magicStone.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
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
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import magicStone.MagicStoneManager;
   import magicStone.components.MagicStoneShopItem;
   import magicStone.data.MagicStoneEvent;
   import road7th.comm.PackageIn;
   
   public class MagicStoneShopFrame extends BaseAlerFrame
   {
      
      public static const SHOP_ITEM_NUM:uint = 8;
      
      private var _goodItems:Vector.<MagicStoneShopItem>;
      
      private var _rightItemLightMc:MovieClip;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _goodItemContainerBg:Image;
      
      private var _navigationBarContainer:Sprite;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _scoreNumBG:Scale9CornerImage;
      
      private var _scoreText:FilterFrameText;
      
      private var _scoreNumText:FilterFrameText;
      
      private var _label:FilterFrameText;
      
      private var curPage:int = 1;
      
      public function MagicStoneShopFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         MagicStoneManager.instance.shopFrame = this;
         this.initView();
         this.initEvents();
         this.loadList();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var title:String = LanguageMgr.GetTranslation("magicStone.shopFrameTitle");
         var alerInfo:AlertInfo = new AlertInfo(title,"",LanguageMgr.GetTranslation("tank.calendar.Activity.BackButtonText"));
         info = alerInfo;
         this._goodItems = new Vector.<MagicStoneShopItem>();
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("magicStone.shopFrame.RightItemLightMc");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("magicStone.shopFrame.GoodItemContainerAll");
         this._goodItemContainerBg = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.GoodItemContainerBg");
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("magicStone.shopFrame.navigationBarContainer");
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.BtnPrePage");
         this._navigationBarContainer.addChild(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.BtnNextPage");
         this._navigationBarContainer.addChild(this._nextPageBtn);
         this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.CurrentPageInput");
         this._navigationBarContainer.addChild(this._currentPageInput);
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.pageTxt");
         this._navigationBarContainer.addChild(this._currentPageTxt);
         this._scoreNumBG = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.coinBG");
         this._scoreText = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.scoreText");
         this._scoreText.text = LanguageMgr.GetTranslation("magicStone.remainScore");
         this._scoreNumText = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.scoreNumTxt");
         this._scoreNumText.text = MagicStoneManager.instance.mgStoneScore.toString();
         this._label = ComponentFactory.Instance.creatComponentByStylename("magicStone.shopFrame.label");
         this._label.text = LanguageMgr.GetTranslation("magicStone.onlyBindedCanBuy");
         addToContent(this._goodItemContainerBg);
         addToContent(this._goodItemContainerAll);
         addToContent(this._navigationBarContainer);
         addToContent(this._scoreNumBG);
         addToContent(this._scoreText);
         addToContent(this._scoreNumText);
         addToContent(this._label);
         for(i = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = new MagicStoneShopItem();
            dx = this._goodItems[i].width;
            dy = this._goodItems[i].height;
            dx *= int(i % 2);
            dy *= int(i / 2);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].setItemLight(this._rightItemLightMc);
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this.curPage));
         SocketManager.Instance.out.updateRemainCount();
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
         this._currentPageTxt.text = this.curPage + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i <= this._goodItems.length - 1; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      private function initEvents() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         SocketManager.Instance.addEventListener(MagicStoneEvent.UPDATE_REMAIN_COUNT,this.__updateRemainCount);
      }
      
      protected function __updateRemainCount(event:MagicStoneEvent) : void
      {
         var item:MagicStoneShopItem = null;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         for(var i:int = 0; i <= this._goodItems.length - 1; i++)
         {
            item = this._goodItems[i];
            if(Boolean(item.shopItemInfo) && item.shopItemInfo.TemplateInfo.Property3 == "0")
            {
               item.setRemainCount(count);
            }
         }
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
            case this._prePageBtn:
               if(this.curPage == 1)
               {
                  this.curPage = ShopManager.Instance.getResultPages(this.getType()) + 1;
               }
               --this.curPage;
               break;
            case this._nextPageBtn:
               if(this.curPage == ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.curPage = 0;
               }
               ++this.curPage;
         }
         this.loadList();
      }
      
      public function updateScore(num:int) : void
      {
         if(Boolean(this._scoreNumText))
         {
            this._scoreNumText.text = num.toString();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvents() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         SocketManager.Instance.removeEventListener(MagicStoneEvent.UPDATE_REMAIN_COUNT,this.__updateRemainCount);
      }
      
      override public function dispose() : void
      {
         MagicStoneManager.instance.shopFrame = null;
         this.removeEvents();
         for(var i:int = 0; i <= this._goodItems.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._goodItemContainerBg);
         this._goodItemContainerBg = null;
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._scoreNumBG);
         this._scoreNumBG = null;
         ObjectUtils.disposeObject(this._scoreText);
         this._scoreText = null;
         ObjectUtils.disposeObject(this._scoreNumText);
         this._scoreNumText = null;
         ObjectUtils.disposeObject(this._label);
         this._label = null;
         super.dispose();
      }
      
      public function getType() : int
      {
         return 101;
      }
   }
}

