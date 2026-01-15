package entertainmentMode.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class EntertainmentInfoFrame extends BaseAlerFrame
   {
      
      public static const SUM_NUMBER:int = 20;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<PropItemView>;
      
      private var _page:int = 1;
      
      private var propList:Array = new Array();
      
      public function EntertainmentInfoFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var prop:PropInfo = null;
         var item:PropItemView = null;
         var propBox:Bitmap = null;
         this.propList = ItemManager.Instance.getPropByTypeAndPro();
         var _bottom:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("entertainment.frameBottom");
         this._list = ComponentFactory.Instance.creatCustomObject("entertainment.TrophyList",[5]);
         this.titleText = LanguageMgr.GetTranslation("entertainment.view.title");
         this._items = new Vector.<PropItemView>();
         this._list.beginChanges();
         for(var i:int = 0; i < this.propList.length; i++)
         {
            prop = new PropInfo(this.propList[i]);
            item = new PropItemView(prop,true,false);
            item.propPos = 5;
            propBox = ComponentFactory.Instance.creat("asset.Entertainment.mode.propBox");
            propBox.width = 48;
            propBox.height = 48;
            item.width = 50;
            item.height = 50;
            item.addChildAt(propBox,0);
            this._items.push(item);
            this._list.addChild(item);
         }
         this._list.commitChanges();
         var _explanationPanel:ScrollPanel = ComponentFactory.Instance.creatComponentByStylename("entertainment.view.scrollPanel");
         _explanationPanel.setView(this._list);
         addToContent(_bottom);
         addToContent(_explanationPanel);
         escEnable = true;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this.hide();
         }
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function _nextClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._page;
         if(this._page > this.pageSum())
         {
            this._page = 1;
         }
      }
      
      private function _prevClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._page;
         if(this._page < 1)
         {
            this._page = this.pageSum();
         }
      }
      
      public function pageSum() : int
      {
         return 1;
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
         if(this._items != null)
         {
            for(i = 0; i < this._items.length; i++)
            {
               ObjectUtils.disposeObject(this._items[i]);
            }
            this._items = null;
         }
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

