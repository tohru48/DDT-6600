package bagAndInfo
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.events.Event;
   import giftSystem.GiftController;
   import giftSystem.view.GiftView;
   
   public class GiftFrame extends Frame
   {
      
      private var _giftView:GiftView;
      
      private var _firstOpenGift:Boolean = true;
      
      private var _back:Bitmap;
      
      public function GiftFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("ddt.giftSystem.giftView.giftTitle");
         this.showGiftFrame();
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
      }
      
      private function showGiftFrame() : void
      {
         if(this._firstOpenGift)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_GIFT_SYSTEM);
         }
         else
         {
            if(!this._giftView)
            {
               this.initView();
               this._giftView = ComponentFactory.Instance.creatCustomObject("giftView");
               this._giftView.y = 41;
               this._giftView.x = 21;
               addToContent(this._giftView);
            }
            GiftController.Instance.canActive = true;
            SocketManager.Instance.out.sendUpdateGoodsCount();
            this._giftView.info = PlayerManager.Instance.Self;
         }
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("asset.giftSystem.giftBack");
         addToContent(this._back);
      }
      
      private function __createGift(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_GIFT_SYSTEM)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
            this._firstOpenGift = false;
            this.showGiftFrame();
         }
      }
      
      protected function __onGiftSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
      }
      
      protected function __onGiftUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_GIFT_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
   }
}

