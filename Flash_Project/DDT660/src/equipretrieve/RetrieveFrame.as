package equipretrieve
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import equipretrieve.view.RetrieveBagFrame;
   import equipretrieve.view.RetrieveBagView;
   import equipretrieve.view.RetrieveBagcell;
   import equipretrieve.view.RetrieveBgView;
   import flash.utils.Dictionary;
   
   public class RetrieveFrame extends Frame
   {
      
      private var _retrieveBgView:RetrieveBgView;
      
      private var _retrieveBagView:RetrieveBagFrame;
      
      private var _alertInfo:AlertInfo;
      
      private var _BG:ScaleBitmapImage;
      
      public function RetrieveFrame()
      {
         super();
         this.mouseEnabled = false;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BAGANDINFO);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.BAGANDINFO)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.BAGANDINFO)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.start();
         }
      }
      
      private function start() : void
      {
         this._retrieveBgView = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveBgView");
         this._retrieveBagView = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveBagView");
         addToContent(this._retrieveBagView);
         addToContent(this._retrieveBgView);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function updateBag(dic:Dictionary) : void
      {
         if(Boolean(this._retrieveBgView))
         {
            this._retrieveBgView.refreshData(dic);
         }
      }
      
      public function cellDoubleClick(cell:RetrieveBagcell) : void
      {
         if(Boolean(this._retrieveBgView))
         {
            this._retrieveBgView.cellDoubleClick(cell);
         }
      }
      
      public function set bagType(i:int) : void
      {
         RetrieveBagView(this._retrieveBagView.bagView).resultPoint(i,this._retrieveBagView.x - this._retrieveBgView.x,this._retrieveBagView.y - this._retrieveBgView.y);
      }
      
      public function set shine(boo:Boolean) : void
      {
         if(boo == true)
         {
            if(Boolean(this._retrieveBgView))
            {
               this._retrieveBgView.startShine();
            }
         }
         else if(Boolean(this._retrieveBgView))
         {
            this._retrieveBgView.stopShine();
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(!value)
         {
            SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      public function clearItemCell() : void
      {
         if(Boolean(this._retrieveBgView))
         {
            this._retrieveBgView.clearCellInfo();
         }
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!RetrieveController.Instance.viewMouseEvtBoolean)
         {
            return;
         }
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || RetrieveController.Instance.viewMouseEvtBoolean)
         {
            RetrieveController.Instance.close();
         }
      }
      
      override public function dispose() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         RetrieveController.Instance.close();
         if(Boolean(this._retrieveBagView))
         {
            this._retrieveBagView.bagView.setBagType(0);
         }
         disposeChildren = true;
         if(Boolean(this._retrieveBgView))
         {
            ObjectUtils.disposeObject(this._retrieveBgView);
         }
         this._retrieveBgView = null;
         if(Boolean(this._retrieveBagView))
         {
            ObjectUtils.disposeObject(this._retrieveBagView);
         }
         this._retrieveBagView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

