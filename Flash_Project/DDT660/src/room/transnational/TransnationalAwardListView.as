package room.transnational
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopGoodItem;
   
   public class TransnationalAwardListView extends BaseAlerFrame implements Disposeable
   {
      
      public static const AWARD_ITEM_NUM:uint = 12;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPage:int;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _goodItems:Vector.<TransnationalAwardItem>;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _list:Vector.<ShopItemInfo>;
      
      private var _pointTable:FilterFrameText;
      
      private var _pointTxt:FilterFrameText;
      
      private var __pointTxtbg:Bitmap;
      
      private var _bg:ScaleBitmapImage;
      
      private var _getbackBtn:TextButton;
      
      private var _getbackBtnBg:ScaleBitmapImage;
      
      public function TransnationalAwardListView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("TransnationalAwardRoom.bg1");
         addToContent(this._bg);
         this._getbackBtnBg = ComponentFactory.Instance.creatComponentByStylename("TransnationalAward.GetButtonBackBg");
         addToContent(this._getbackBtnBg);
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("ddtTransnationalViewBG5");
         addToContent(this._pageBg);
         this._getbackBtn = ComponentFactory.Instance.creatComponentByStylename("asset.Transnationalshop.getBackBtn");
         this._getbackBtn.text = LanguageMgr.GetTranslation("ddt.transnationalshop.getback");
         addToContent(this._getbackBtn);
         this._pointTable = ComponentFactory.Instance.creatComponentByStylename("Transnational.Scores.MypointTxt");
         this._pointTable.text = LanguageMgr.GetTranslation("Transnational.HaveAwardScore");
         addToContent(this._pointTable);
         this.__pointTxtbg = ComponentFactory.Instance.creatBitmap("Transnational.Scores.pointTxt.bg");
         addToContent(this.__pointTxtbg);
         this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("Transnational.Scores.pointTxt");
         this._pointTxt.text = TransnationalFightManager.Instance.currentScores.toString();
         addToContent(this._pointTxt);
         this._prePageBtn = ComponentFactory.Instance.creat("TransnationalAwardRoom.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creat("TransnationalAwardRoom.BtnNextPage");
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("TransnationalAwardRoom.CurrentPage");
         addToContent(this._prePageBtn);
         addToContent(this._nextPageBtn);
         addToContent(this._currentPageTxt);
         this._goodItems = new Vector.<TransnationalAwardItem>();
         this._goodItemContainerAll = new Sprite();
         PositionUtils.setPos(this._goodItemContainerAll,"Transnational.goodItemContainer.pos");
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("TransnationalAwardRoom.GoodItem");
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
         }
         DisplayUtils.horizontalArrange(this._goodItemContainerAll,3,3);
         addToContent(this._goodItemContainerAll);
         this._currentPage = 1;
         this.loadList();
      }
      
      private function addEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._getbackBtn.addEventListener(MouseEvent.CLICK,this.__getback);
      }
      
      public function set Scores(value:int) : void
      {
         this._pointTxt.text = String(value);
      }
      
      private function __getback(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.parent.removeChild(this);
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(ShopType.TRANSNATIONAL_AWARD_TYPE,12) == 0)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._prePageBtn:
               if(this._currentPage == 1)
               {
                  this._currentPage = ShopManager.Instance.getResultPages(ShopType.TRANSNATIONAL_AWARD_TYPE,12) + 1;
               }
               --this._currentPage;
               break;
            case this._nextPageBtn:
               if(this._currentPage == ShopManager.Instance.getResultPages(ShopType.TRANSNATIONAL_AWARD_TYPE,12))
               {
                  this._currentPage = 0;
               }
               ++this._currentPage;
         }
         this.loadList();
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(ShopType.TRANSNATIONAL_AWARD_TYPE,this._currentPage,12));
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         var i:int = 0;
         if(list != null)
         {
            this._list = list;
            this.clearitems();
            for(i = 0; i < AWARD_ITEM_NUM; i++)
            {
               this._goodItems[i].selected = false;
               if(i < list.length && Boolean(list[i]))
               {
                  this._goodItems[i].shopItemInfo = list[i];
               }
            }
            this._currentPageTxt.text = this._currentPage + "/" + ShopManager.Instance.getResultPages(ShopType.TRANSNATIONAL_AWARD_TYPE,12);
         }
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._getbackBtn.removeEventListener(MouseEvent.CLICK,this.__getback);
         for(var i:int = 0; i < this._goodItems.length; i++)
         {
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
         }
      }
      
      private function __itemClick(evt:ItemEvent) : void
      {
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
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._getbackBtnBg);
         this._getbackBtnBg = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._getbackBtn);
         this._getbackBtn = null;
         ObjectUtils.disposeObject(this.__pointTxtbg);
         this.__pointTxtbg = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            if(Boolean(this._goodItems[i]))
            {
               ObjectUtils.disposeObject(this._goodItems[i]);
               this._goodItems[i].dispose();
               this._goodItems[i] = null;
            }
         }
         ObjectUtils.disposeObject(this._goodItems);
         this._goodItems = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

