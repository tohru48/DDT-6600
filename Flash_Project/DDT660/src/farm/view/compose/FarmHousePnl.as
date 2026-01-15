package farm.view.compose
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import farm.view.compose.item.FarmHouseItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FarmHousePnl extends Sprite implements Disposeable
   {
      
      public static var CURRENT_PAGE:int = 1;
      
      public static const House_ITEM_NUM:uint = 10;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _PageBg:DisplayObject;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _endPageBtn:BaseButton;
      
      private var _listView:SimpleTileList;
      
      protected var _bagdata:BagInfo;
      
      protected var _cells:Vector.<FarmHouseItem>;
      
      private var _bgBottom:DisplayObject;
      
      private var _bgHouseItem:DisplayObject;
      
      private var _bgPageTxt:DisplayObject;
      
      private var _totalPage:int;
      
      private var _currentPage:int;
      
      public function FarmHousePnl()
      {
         super();
         this._cells = new Vector.<FarmHouseItem>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var cell:FarmHouseItem = null;
         this._bgBottom = ComponentFactory.Instance.creat("assets.farmHouse.BottomBg");
         addChild(this._bgBottom);
         this._bgHouseItem = ComponentFactory.Instance.creat("asset.farmHouse.houseBg");
         addChild(this._bgHouseItem);
         this._firstPage = ComponentFactory.Instance.creat("farmHouse.btnFirstPage");
         addChild(this._firstPage);
         this._prePageBtn = ComponentFactory.Instance.creat("farmHouse.btnPrePage");
         addChild(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creat("farmHouse.btnNextPage");
         addChild(this._nextPageBtn);
         this._endPageBtn = ComponentFactory.Instance.creat("farmHouse.btnEndPage");
         addChild(this._endPageBtn);
         this._bgPageTxt = ComponentFactory.Instance.creat("farmHouse.farmHouse.pageBG");
         addChild(this._bgPageTxt);
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.HouseCurrent");
         addChild(this._currentPageTxt);
         this._listView = ComponentFactory.Instance.creat("farm.simpleTileList.farmHouse",[5]);
         addChild(this._listView);
         for(var i:int = 0; i < House_ITEM_NUM; i++)
         {
            cell = new FarmHouseItem(i);
            this._listView.addChild(cell);
            this._cells.push(cell);
         }
         this._bagdata = PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE);
         this._totalPage = this._bagdata.items.list.length % House_ITEM_NUM == 0 ? (this._bagdata.items.list.length / House_ITEM_NUM == 0 ? 1 : int(this._bagdata.items.list.length / House_ITEM_NUM)) : int(this._bagdata.items.list.length / House_ITEM_NUM + 1);
         this._currentPage = 1;
         this.update();
      }
      
      private function initEvent() : void
      {
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      private function removeEvent() : void
      {
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      private function __updateGoods(event:BagEvent) : void
      {
         this._totalPage = this._bagdata.items.list.length % House_ITEM_NUM == 0 ? (this._bagdata.items.list.length / House_ITEM_NUM == 0 ? 1 : int(this._bagdata.items.list.length / House_ITEM_NUM)) : int(this._bagdata.items.list.length / House_ITEM_NUM + 1);
         this.update();
      }
      
      private function update() : void
      {
         this.clearitems();
         var start:int = (this._currentPage - 1) * House_ITEM_NUM;
         var end:int = this._bagdata.items.list.length < this._currentPage * House_ITEM_NUM ? int(this._bagdata.items.list.length) : int(this._currentPage * House_ITEM_NUM);
         for(var i:int = start; i < end; i++)
         {
            this._cells[i - start].info = this._bagdata.items.list[i];
         }
         this._currentPageTxt.text = this._currentPage + "/" + this._totalPage;
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._totalPage == 1)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._firstPage:
               this._currentPage = 1;
               break;
            case this._prePageBtn:
               if(this._currentPage - 1 >= 1)
               {
                  this._currentPage -= 1;
               }
               break;
            case this._nextPageBtn:
               if(this._currentPage + 1 <= this._totalPage)
               {
                  this._currentPage += 1;
               }
               break;
            case this._endPageBtn:
               this._currentPage = this._totalPage;
         }
         this.update();
      }
      
      private function clearitems() : void
      {
         var i:int = 0;
         if(this._cells.length > 0)
         {
            for(i = 0; i < House_ITEM_NUM; i++)
            {
               this._cells[i].info = null;
            }
         }
      }
      
      public function dispose() : void
      {
         var item:FarmHouseItem = null;
         this.removeEvent();
         this.clearitems();
         for each(item in this._cells)
         {
            if(Boolean(item))
            {
               ObjectUtils.disposeObject(item);
               item = null;
            }
         }
         this._cells.splice(0,this._cells.length);
         this._bagdata = null;
         this._totalPage = 0;
         this._currentPage = 1;
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
         if(Boolean(this._PageBg))
         {
            ObjectUtils.disposeObject(this._PageBg);
            this._PageBg = null;
         }
         if(Boolean(this._currentPageTxt))
         {
            ObjectUtils.disposeObject(this._currentPageTxt);
            this._currentPageTxt = null;
         }
         if(Boolean(this._endPageBtn))
         {
            ObjectUtils.disposeObject(this._endPageBtn);
            this._endPageBtn = null;
         }
         if(Boolean(this._listView))
         {
            ObjectUtils.disposeObject(this._listView);
            this._listView = null;
         }
         if(Boolean(this._bgBottom))
         {
            ObjectUtils.disposeObject(this._bgBottom);
            this._bgBottom = null;
         }
         if(Boolean(this._bgHouseItem))
         {
            ObjectUtils.disposeObject(this._bgHouseItem);
            this._bgHouseItem = null;
         }
         if(Boolean(this._bgPageTxt))
         {
            ObjectUtils.disposeObject(this._bgPageTxt);
            this._bgPageTxt = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

