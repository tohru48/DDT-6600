package ddt.view.caddyII
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class LookTrophy extends Frame
   {
      
      public static const SUM_NUMBER:int = 20;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<BagCell>;
      
      private var _prevBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _boxTempIDList:Vector.<InventoryItemInfo>;
      
      private var _page:int = 1;
      
      public function LookTrophy()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var item:BagCell = null;
         var _bg1:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("caddy.TrophyBGI");
         var font:Bitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.lookFont");
         this._list = ComponentFactory.Instance.creatCustomObject("caddy.TrophyList",[5]);
         var _bg2:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("caddy.PageCountBg");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.pageTxt");
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.prevBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.nextBtn");
         this._items = new Vector.<BagCell>();
         this._list.beginChanges();
         for(var i:int = 0; i < SUM_NUMBER; i++)
         {
            item = new BagCell(i);
            this._items.push(item);
            this._list.addChild(item);
         }
         this._list.commitChanges();
         addToContent(_bg1);
         addToContent(_bg2);
         addToContent(font);
         addToContent(this._list);
         addToContent(this._pageTxt);
         addToContent(this._prevBtn);
         addToContent(this._nextBtn);
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("tank.view.caddy.lookTrophy");
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._prevBtn.addEventListener(MouseEvent.CLICK,this._prevClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this._nextClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._prevBtn))
         {
            this._prevBtn.removeEventListener(MouseEvent.CLICK,this._prevClick);
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this._nextClick);
         }
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this.hide();
         }
      }
      
      private function _nextClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this.page;
         if(this.page > this.pageSum())
         {
            this.page = 1;
         }
         this.fillPage();
      }
      
      private function _prevClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this.page;
         if(this.page < 1)
         {
            this.page = this.pageSum();
         }
         this.fillPage();
      }
      
      private function fillPage() : void
      {
         var begin:int = (this.page - 1) * SUM_NUMBER;
         var end:int = this.page * SUM_NUMBER;
         var cellNumber:int = 0;
         for(var i:int = begin; i < end; i++,cellNumber++)
         {
            if(cellNumber < this._items.length && i < this._boxTempIDList.length)
            {
               this._items[cellNumber].info = this._boxTempIDList[i];
            }
            else
            {
               this._items[cellNumber].info = null;
            }
         }
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      public function set page(value:int) : void
      {
         this._page = value;
         this._pageTxt.text = this._page + "/" + this.pageSum();
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function pageSum() : int
      {
         return Math.ceil(this._boxTempIDList.length / SUM_NUMBER);
      }
      
      public function show(list:Vector.<InventoryItemInfo>) : void
      {
         this._boxTempIDList = list;
         this.page = 1;
         this.fillPage();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         this.removeEvents();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._prevBtn))
         {
            ObjectUtils.disposeObject(this._prevBtn);
         }
         this._prevBtn = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         this._pageTxt = null;
         if(this._items != null)
         {
            for(i = 0; i < this._items.length; i++)
            {
               ObjectUtils.disposeObject(this._items[i]);
            }
            this._items = null;
         }
         this._boxTempIDList = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

