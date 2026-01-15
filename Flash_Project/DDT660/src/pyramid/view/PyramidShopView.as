package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pyramid.PyramidManager;
   import pyramid.event.PyramidEvent;
   
   public class PyramidShopView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _firstPageBtn:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _navigationBarContainer:Sprite;
      
      private var _goodItems:Vector.<PyramidShopItem>;
      
      private var SHOP_ITEM_NUM:int = 8;
      
      private var CURRENT_PAGE:int = 1;
      
      public function PyramidShopView()
      {
         super();
         this.initView();
         this.initEvent();
         this.loadList();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.shopViewBg");
         addChild(this._bg);
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("pyramid.view.goodItemContainerAll");
         addChild(this._goodItemContainerAll);
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("pyramid.view.navigationBarContainer");
         addChild(this._navigationBarContainer);
         this._firstPageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnFirstPage",this._navigationBarContainer);
         this._prePageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnPrePage",this._navigationBarContainer);
         this._nextPageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnNextPage",this._navigationBarContainer);
         this._endPageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnEndPage",this._navigationBarContainer);
         this._currentPageInput = UICreatShortcut.creatAndAdd("ddtshop.CurrentPageInput",this._navigationBarContainer);
         this._currentPageTxt = UICreatShortcut.creatAndAdd("ddtshop.CurrentPage",this._navigationBarContainer);
         this._goodItems = new Vector.<PyramidShopItem>();
         for(i = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("pyramid.view.pyramidShopItem");
            dx = this._goodItems[i].width;
            dy = this._goodItems[i].height;
            dx *= int(i % 2);
            dy *= int(i / 2);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this.CURRENT_PAGE));
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            if(!list)
            {
               break;
            }
            if(i < list.length && Boolean(list[i]))
            {
               this._goodItems[i].shopItemInfo = list[i];
            }
         }
         this._currentPageTxt.text = this.CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._firstPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PyramidManager.instance.model.addEventListener(PyramidEvent.START_OR_STOP,this.__stopScoreUpdateHandler);
         PyramidManager.instance.model.addEventListener(PyramidEvent.DATA_CHANGE,this.__dataChangeHandler);
      }
      
      private function __stopScoreUpdateHandler(event:PyramidEvent) : void
      {
         this.updateShopItemGreyState();
      }
      
      private function __dataChangeHandler(event:PyramidEvent) : void
      {
         this.updateShopItemGreyState();
      }
      
      private function updateShopItemGreyState() : void
      {
         var i:int = 0;
         if(Boolean(this._goodItems))
         {
            for(i = 0; i < this._goodItems.length; i++)
            {
               this._goodItems[i].updateGreyState();
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
            case this._firstPageBtn:
               if(this.CURRENT_PAGE != 1)
               {
                  this.CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(this.CURRENT_PAGE == 1)
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
               }
               --this.CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(this.CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
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
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      public function getType() : int
      {
         return 98;
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._firstPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.START_OR_STOP,this.__stopScoreUpdateHandler);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.DATA_CHANGE,this.__dataChangeHandler);
      }
      
      private function disposeItems() : void
      {
         for(var i:int = 0; i < this._goodItems.length; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         this._goodItems = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._goodItemContainerAll);
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._firstPageBtn);
         this._firstPageBtn = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeAllChildren(this._navigationBarContainer);
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

