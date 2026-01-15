package activeEvents.view
{
   import activeEvents.ActiveConductEvent;
   import activeEvents.ActiveController;
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ActiveMainFrame extends Frame
   {
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _activeLeftLine:Bitmap;
      
      private var _bg:Bitmap;
      
      private var _closeBtn:TextButton;
      
      private var _control:ActiveController;
      
      private var _isSelect:Boolean = false;
      
      private var _selectBg:Bitmap;
      
      private var _currentItem:ActiveMainItem;
      
      private var _activitiesLine:Bitmap;
      
      private var _items:Array;
      
      public function ActiveMainFrame()
      {
         super();
         this._init();
      }
      
      public function set control(value:ActiveController) : void
      {
         this._control = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.remvoeEvent();
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._activeLeftLine);
         this._activeLeftLine = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         ObjectUtils.disposeObject(this._selectBg);
         this._selectBg = null;
         ObjectUtils.disposeObject(this._currentItem);
         this._currentItem = null;
         ObjectUtils.disposeObject(this._activitiesLine);
         this._activitiesLine = null;
         this._control.activeMainFrame = null;
         this._control = null;
         this._items = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         this.upData();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND,true);
      }
      
      private function _init() : void
      {
         this._items = [];
         titleText = LanguageMgr.GetTranslation("tank.view.movement.MovementLeftView.action");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.mainBg");
         addToContent(this._bg);
         this._list = new VBox();
         this._list.spacing = 3;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("activeEvents.leftSrollPanel");
         this._panel.setView(this._list);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeCloseBtn");
         this._closeBtn.text = LanguageMgr.GetTranslation("close");
         addToContent(this._closeBtn);
         addToContent(this._panel);
         this.addEvent();
      }
      
      private function upData() : void
      {
         var info:ActiveEventsInfo = null;
         var item:ActiveMainItem = null;
         this._list.disposeAllChildren();
         var data:Array = this._control.actives;
         for(var i:int = 0; i < data.length; i++)
         {
            info = data[i] as ActiveEventsInfo;
            if(info.Type < 10)
            {
               item = new ActiveMainItem();
               item.info = info;
               item.addEventListener(ActiveConductEvent.ONLINK,this._onClickItemHandler);
               this._list.addChild(item);
               this._activitiesLine = ComponentFactory.Instance.creatBitmap("asset.activeEvents.leftLine");
               this._list.addChild(this._activitiesLine);
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function _onClickItemHandler(evt:ActiveConductEvent) : void
      {
         var item:ActiveMainItem = evt.currentTarget as ActiveMainItem;
         this.displayerActiveContext(item);
      }
      
      private function displayerActiveContext($item:ActiveMainItem) : void
      {
         if(!$item)
         {
            return;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.selectState = false;
         }
         this._currentItem = $item;
         this._currentItem.selectState = true;
         if(Boolean($item.info))
         {
            this._control.openSubFrame($item.info);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._frameEventHandler);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this._closeBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         var item:ActiveMainItem = null;
         for each(item in this._items)
         {
            item.removeEventListener(ActiveConductEvent.ONLINK,this._onClickItemHandler);
         }
         removeEventListener(FrameEvent.RESPONSE,this._frameEventHandler);
         removeEventListener(MouseEvent.CLICK,this._closeBtnClick);
      }
      
      private function _closeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._control.closeAllFrame();
      }
      
      private function _frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._control.closeAllFrame();
         }
      }
   }
}

