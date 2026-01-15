package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AuctionRightView extends Sprite implements Disposeable
   {
      
      private var _prePage_btn:BaseButton;
      
      private var _nextPage_btn:BaseButton;
      
      private var _first_btn:BaseButton;
      
      private var _end_btn:BaseButton;
      
      public var page_txt:FilterFrameText;
      
      private var _sorttxtItems:Vector.<FilterFrameText>;
      
      private var _sortBtItems:Vector.<Sprite>;
      
      private var _sortArrowItems:Vector.<ScaleFrameImage>;
      
      private var _stripList:ListPanel;
      
      private var _state:String;
      
      private var _currentButtonIndex:uint = 0;
      
      private var _currentIsdown:Boolean = true;
      
      private var _selectStrip:StripView;
      
      private var _selectInfo:AuctionGoodsInfo;
      
      private var help_mc:Bitmap;
      
      private var help_BG:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _bidNumberTxt:FilterFrameText;
      
      private var _RemainingTimeTxt:FilterFrameText;
      
      private var _SellPersonTxt:FilterFrameText;
      
      private var _bidpriceTxt:FilterFrameText;
      
      private var _BidPersonTxt:FilterFrameText;
      
      private var _tableline:Bitmap;
      
      private var _tableline1:Bitmap;
      
      private var _tableline2:Bitmap;
      
      private var _tableline3:Bitmap;
      
      private var _tableline4:Bitmap;
      
      private var GoodsName_btn:Sprite;
      
      private var RemainingTime_btn:Sprite;
      
      private var SellPerson_btn:Sprite;
      
      private var BidPrice_btn:Sprite;
      
      private var BidPerson_btn:Sprite;
      
      private var _startNum:int = 0;
      
      private var _endNum:int = 0;
      
      private var _totalCount:int = 0;
      
      public function AuctionRightView()
      {
         super();
      }
      
      public function setup($state:String = "") : void
      {
         this._state = $state;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var img:ScaleFrameImage = null;
         this._sortBtItems = new Vector.<Sprite>(6);
         this._sorttxtItems = new Vector.<FilterFrameText>(6);
         this._sortArrowItems = new Vector.<ScaleFrameImage>(4);
         var bg1:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightBG1");
         addChild(bg1);
         var PageBg:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.PageCountBg");
         addChild(PageBg);
         this.help_BG = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.HelpBG");
         addChild(this.help_BG);
         this.help_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Help");
         addChild(this.help_mc);
         this._prePage_btn = ComponentFactory.Instance.creat("auctionHouse.Prev_btn");
         addChild(this._prePage_btn);
         this._nextPage_btn = ComponentFactory.Instance.creat("auctionHouse.Next_btn");
         addChild(this._nextPage_btn);
         this._first_btn = ComponentFactory.Instance.creat("auctionHouse.first_btn");
         this._end_btn = ComponentFactory.Instance.creat("auctionHouse.end_btn");
         this.page_txt = ComponentFactory.Instance.creat("auctionHouse.RightPageText");
         addChild(this.page_txt);
         var _sellItembg:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG");
         addChild(_sellItembg);
         this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
         this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
         addChild(this._bidNumberTxt);
         this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
         this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
         this._SellPersonTxt = ComponentFactory.Instance.creat("ddtauction.SellPersonTxt");
         this._SellPersonTxt.text = LanguageMgr.GetTranslation("singlePrice");
         this._BidPersonTxt = ComponentFactory.Instance.creat("ddtauction.BidPersonTxt");
         this._BidPersonTxt.text = LanguageMgr.GetTranslation("singlePrice");
         this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
         this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
         this._tableline = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline);
         this._tableline.x = 240;
         this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline1);
         this._tableline1.x = 314;
         this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline2);
         this._tableline2.x = 426;
         this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline3);
         this._tableline3.x = 517;
         this._tableline4 = ComponentFactory.Instance.creatBitmap("asset.ddtcore.TwotableLine");
         addChild(this._tableline4);
         this.GoodsName_btn = new Sprite();
         this.GoodsName_btn.graphics.beginFill(16777215,1);
         this.GoodsName_btn.graphics.drawRect(0,6,190,30);
         this.GoodsName_btn.graphics.endFill();
         this.GoodsName_btn.alpha = 0;
         this.GoodsName_btn.buttonMode = true;
         addChild(this.GoodsName_btn);
         this.GoodsName_btn.x = 74;
         this.RemainingTime_btn = new Sprite();
         this.RemainingTime_btn.graphics.beginFill(16777215,1);
         this.RemainingTime_btn.graphics.drawRect(0,6,109,30);
         this.RemainingTime_btn.graphics.endFill();
         this.RemainingTime_btn.alpha = 0;
         this.RemainingTime_btn.buttonMode = true;
         addChild(this.RemainingTime_btn);
         this.RemainingTime_btn.x = 317;
         this.SellPerson_btn = new Sprite();
         this.SellPerson_btn.graphics.beginFill(16777215,1);
         this.SellPerson_btn.graphics.drawRect(0,6,88,30);
         this.SellPerson_btn.graphics.endFill();
         this.SellPerson_btn.alpha = 0;
         this.SellPerson_btn.buttonMode = true;
         addChild(this.SellPerson_btn);
         this.SellPerson_btn.x = 429;
         this.BidPrice_btn = new Sprite();
         this.BidPrice_btn.graphics.beginFill(16777215,1);
         this.BidPrice_btn.graphics.drawRect(0,6,173,30);
         this.BidPrice_btn.graphics.endFill();
         this.BidPrice_btn.alpha = 0;
         this.BidPrice_btn.buttonMode = true;
         addChild(this.BidPrice_btn);
         this.BidPrice_btn.x = 520;
         this.BidPerson_btn = new Sprite();
         this.BidPerson_btn.graphics.beginFill(16777215,1);
         this.BidPerson_btn.graphics.drawRect(0,6,88,30);
         this.BidPerson_btn.graphics.endFill();
         this.BidPerson_btn.alpha = 0;
         this.BidPerson_btn.buttonMode = true;
         this.BidPerson_btn.x = 429;
         addChild(this.BidPerson_btn);
         this._sorttxtItems[0] = this._nameTxt;
         this._sorttxtItems[2] = this._RemainingTimeTxt;
         this._sorttxtItems[3] = this._SellPersonTxt;
         this._sorttxtItems[4] = this._bidpriceTxt;
         this._sorttxtItems[5] = this._BidPersonTxt;
         for(var i:int = 0; i < this._sorttxtItems.length; i++)
         {
            if(i != 1)
            {
               if(i == 3)
               {
                  if(this._state == AuctionState.BROWSE)
                  {
                     addChild(this._sorttxtItems[i]);
                  }
               }
               else if(i == 5)
               {
                  if(this._state == AuctionState.SELL)
                  {
                     addChild(this._sorttxtItems[i]);
                  }
               }
               else
               {
                  addChild(this._sorttxtItems[i]);
               }
            }
         }
         this._sortBtItems[0] = this.GoodsName_btn;
         this._sortBtItems[2] = this.RemainingTime_btn;
         this._sortBtItems[3] = this.SellPerson_btn;
         this._sortBtItems[4] = this.BidPrice_btn;
         this._sortBtItems[5] = this.BidPerson_btn;
         for(var j:int = 0; j < this._sortBtItems.length; j++)
         {
            if(j != 1)
            {
               if(j == 3)
               {
                  if(this._state == AuctionState.BROWSE)
                  {
                     addChild(this._sortBtItems[j]);
                  }
               }
               else if(j == 5)
               {
                  if(this._state == AuctionState.SELL)
                  {
                     addChild(this._sortBtItems[j]);
                  }
               }
               else
               {
                  addChild(this._sortBtItems[j]);
               }
            }
         }
         this._sortArrowItems[0] = ComponentFactory.Instance.creat("auctionHouse.ArrowI");
         this._sortArrowItems[1] = ComponentFactory.Instance.creat("auctionHouse.ArrowII");
         this._sortArrowItems[2] = ComponentFactory.Instance.creat("auctionHouse.ArrowIII");
         this._sortArrowItems[3] = ComponentFactory.Instance.creat("auctionHouse.ArrowV");
         for each(img in this._sortArrowItems)
         {
            addChild(img);
            img.visible = false;
         }
         this._stripList = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.rightListII");
         addChild(this._stripList);
         this._stripList.list.updateListView();
         this._stripList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
            this.help_BG.visible = false;
         }
         this.addStageInit();
         this._nextPage_btn.enable = false;
         this._prePage_btn.enable = false;
         this._first_btn.enable = false;
         this._end_btn.enable = false;
      }
      
      private function addEvent() : void
      {
         for(var i:int = 0; i < this._sortBtItems.length; i++)
         {
            if(i != 1)
            {
               this._sortBtItems[i].addEventListener(MouseEvent.CLICK,this.sortHandler);
            }
         }
      }
      
      public function addStageInit() : void
      {
      }
      
      public function hideReady() : void
      {
         this._hideArrow();
      }
      
      public function addAuction(info:AuctionGoodsInfo) : void
      {
         this._stripList.vectorListModel.append(info);
         this._stripList.list.updateListView();
         this.help_mc.visible = false;
         this.help_BG.visible = false;
      }
      
      public function updateAuction(info:AuctionGoodsInfo) : void
      {
         var targetItem:AuctionGoodsInfo = null;
         var item:AuctionGoodsInfo = null;
         for each(item in this._stripList.vectorListModel.elements)
         {
            if(item.AuctionID == info.AuctionID)
            {
               targetItem = item;
               break;
            }
         }
         if(targetItem != null)
         {
            info.BagItemInfo = targetItem.BagItemInfo;
         }
         if(this._stripList.vectorListModel.indexOf(targetItem) != -1)
         {
            this._stripList.vectorListModel.replaceAt(this._stripList.vectorListModel.indexOf(targetItem),info);
         }
         else
         {
            this._stripList.vectorListModel.append(info);
         }
         this._stripList.list.updateListView();
      }
      
      internal function getStripCount() : int
      {
         return this._stripList.vectorListModel.size();
      }
      
      internal function setPage(start:int, totalCount:int) : void
      {
         var end:int = 0;
         start = 1 + AuctionHouseModel.SINGLE_PAGE_NUM * (start - 1);
         if(start + AuctionHouseModel.SINGLE_PAGE_NUM - 1 < totalCount)
         {
            end = start + AuctionHouseModel.SINGLE_PAGE_NUM - 1;
         }
         else
         {
            end = totalCount;
         }
         this._startNum = start;
         this._endNum = end;
         this._totalCount = totalCount;
         if(totalCount == 0)
         {
            if(this._stripList.vectorListModel.elements.length == 0)
            {
               this.page_txt.text = "";
            }
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         this.buttonStatus(start,end,totalCount);
      }
      
      private function upPageTxt() : void
      {
         if(this._endNum < this._startNum)
         {
            this.page_txt.text = "";
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.page_txt.text = "";
         }
         if(this._endNum < this._totalCount)
         {
            this._nextPage_btn.enable = true;
            this._end_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
            this._end_btn.enable = false;
         }
      }
      
      private function buttonStatus(start:int, end:int, totalCount:int) : void
      {
         if(start <= 1)
         {
            this._prePage_btn.enable = false;
            this._first_btn.enable = false;
         }
         else
         {
            this._prePage_btn.enable = true;
            this._first_btn.enable = true;
         }
         if(end < totalCount)
         {
            this._nextPage_btn.enable = true;
            this._end_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
            this._end_btn.enable = false;
         }
         this._nextPage_btn.alpha = 1;
         this._prePage_btn.alpha = 1;
      }
      
      internal function clearList() : void
      {
         this._clearItems();
         this._selectInfo = null;
         this.page_txt.text = "";
         if(this._state == AuctionState.BROWSE)
         {
            this.help_mc.visible = true;
            this.help_BG.visible = true;
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.help_mc.visible = true;
            this.help_BG.visible = true;
         }
         else
         {
            this.help_mc.visible = false;
            this.help_BG.visible = false;
         }
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
            this.help_BG.visible = false;
         }
      }
      
      private function _clearItems() : void
      {
         this._stripList.vectorListModel.clear();
         this._stripList.list.updateListView();
      }
      
      private function invalidatePanel() : void
      {
      }
      
      internal function getSelectInfo() : AuctionGoodsInfo
      {
         if(Boolean(this._selectInfo))
         {
            return this._selectInfo;
         }
         return null;
      }
      
      internal function deleteItem() : void
      {
         var info1:AuctionGoodsInfo = null;
         for each(info1 in this._stripList.vectorListModel.elements)
         {
            if(info1.AuctioneerID == this._selectInfo.AuctioneerID)
            {
               this._stripList.vectorListModel.remove(info1);
               this._selectInfo = null;
               this.upPageTxt();
               break;
            }
         }
         this._stripList.list.updateListView();
      }
      
      internal function clearSelectStrip() : void
      {
         this._stripList.vectorListModel.remove(this._selectInfo);
         this._selectInfo = null;
         this.upPageTxt();
         this._stripList.list.unSelectedAll();
         this._stripList.list.updateListView();
      }
      
      internal function setSelectEmpty() : void
      {
         this._selectStrip.isSelect = false;
         this._selectStrip = null;
         this._selectInfo = null;
      }
      
      internal function get sortCondition() : int
      {
         return this._currentButtonIndex;
      }
      
      internal function get sortBy() : Boolean
      {
         return this._currentIsdown;
      }
      
      private function __itemClick(evt:ListItemEvent) : void
      {
         var currentStrip:StripView = evt.cell as StripView;
         this._selectStrip = currentStrip;
         this._selectInfo = currentStrip.info;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i < this._sortBtItems.length; i++)
         {
            if(i != 1)
            {
               this._sortBtItems[i].removeEventListener(MouseEvent.CLICK,this.sortHandler);
               ObjectUtils.disposeObject(this._sortBtItems[i]);
            }
         }
         this._sortBtItems = null;
      }
      
      private function sortHandler(e:MouseEvent) : void
      {
         AuctionHouseModel._dimBooble = false;
         SoundManager.instance.play("047");
         var _index:uint = uint(this._sortBtItems.indexOf(e.target as Sprite));
         if(this._currentButtonIndex == _index)
         {
            this.changeArrow(_index,!this._currentIsdown);
         }
         else
         {
            this.changeArrow(_index,true);
         }
      }
      
      private function _showOneArrow(index:uint) : void
      {
         this._hideArrow();
         this._sortArrowItems[index].visible = true;
      }
      
      private function _hideArrow() : void
      {
         var img:ScaleFrameImage = null;
         for each(img in this._sortArrowItems)
         {
            img.visible = false;
         }
      }
      
      private function changeArrow(index:uint, isdown:Boolean) : void
      {
         var _index:uint = index;
         if(index == 5)
         {
            index = 3;
         }
         index = index == 0 ? 0 : uint(index - 1);
         this._showOneArrow(index);
         this._currentIsdown = isdown;
         this._currentButtonIndex = _index;
         AuctionHouseModel.searchType = 3;
         if(isdown)
         {
            this._sortArrowItems[index].setFrame(2);
         }
         else
         {
            this._sortArrowItems[index].setFrame(1);
         }
         if(this._stripList.vectorListModel.elements.length < 1)
         {
            return;
         }
         if(isdown)
         {
            this._stripList.vectorListModel.elements.sortOn("Price",Array.NUMERIC);
         }
         else
         {
            this._stripList.vectorListModel.elements.sortOn("Price",Array.DESCENDING | Array.NUMERIC);
         }
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
      }
      
      public function get prePage_btn() : BaseButton
      {
         return this._prePage_btn;
      }
      
      public function get nextPage_btn() : BaseButton
      {
         return this._nextPage_btn;
      }
      
      public function dispose() : void
      {
         var img:ScaleFrameImage = null;
         this.removeEvent();
         this._selectInfo = null;
         if(Boolean(this._first_btn))
         {
            ObjectUtils.disposeObject(this._first_btn);
         }
         this._first_btn = null;
         if(Boolean(this._end_btn))
         {
            ObjectUtils.disposeObject(this._end_btn);
         }
         this._end_btn = null;
         if(Boolean(this._prePage_btn))
         {
            ObjectUtils.disposeObject(this._prePage_btn);
         }
         this._prePage_btn = null;
         if(Boolean(this._nextPage_btn))
         {
            ObjectUtils.disposeObject(this._nextPage_btn);
         }
         this._nextPage_btn = null;
         if(Boolean(this.page_txt))
         {
            ObjectUtils.disposeObject(this.page_txt);
         }
         this.page_txt = null;
         for each(img in this._sortArrowItems)
         {
            ObjectUtils.disposeObject(img);
         }
         this._sortArrowItems = null;
         if(Boolean(this._selectStrip))
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         this._stripList.vectorListModel.clear();
         if(Boolean(this._stripList))
         {
            this._stripList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            ObjectUtils.disposeObject(this._stripList);
         }
         this._stripList = null;
         if(Boolean(this.help_mc))
         {
            ObjectUtils.disposeObject(this.help_mc);
         }
         this.help_mc = null;
         if(Boolean(this.help_BG))
         {
            ObjectUtils.disposeObject(this.help_BG);
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

