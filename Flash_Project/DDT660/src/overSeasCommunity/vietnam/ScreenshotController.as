package overSeasCommunity.vietnam
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import overSeasCommunity.vietnam.view.screenshot.PreviewView;
   import overSeasCommunity.vietnam.view.screenshot.ScreenshotView;
   
   public class ScreenshotController extends EventDispatcher
   {
      
      private var _api:InterfaceController;
      
      private var _screenshotView:ScreenshotView;
      
      private var _previewView:PreviewView;
      
      public function ScreenshotController(api:InterfaceController)
      {
         super();
         this._api = api;
      }
      
      public function cancel() : void
      {
         this.disposeAll();
      }
      
      public function preview(bitmapdata:BitmapData) : void
      {
         if(Boolean(this._screenshotView))
         {
            ObjectUtils.disposeObject(this._screenshotView);
            this._screenshotView = null;
         }
         if(!this._previewView)
         {
            this._previewView = ComponentFactory.Instance.creat("community.screenshot.PreviewView");
            this._previewView.controller = this;
         }
         this._previewView.show(bitmapdata);
      }
      
      public function show() : void
      {
         if(!this._screenshotView)
         {
            this._screenshotView = new ScreenshotView(this);
            this._screenshotView.show();
         }
         else
         {
            this.disposeAll();
         }
      }
      
      public function publish(image:BitmapData, desc:String) : void
      {
         this._api.pushAndUpload(image,desc);
         this.disposeAll();
      }
      
      private function disposeAll() : void
      {
         if(Boolean(this._screenshotView))
         {
            ObjectUtils.disposeObject(this._screenshotView);
            this._screenshotView = null;
         }
         if(Boolean(this._previewView))
         {
            ObjectUtils.disposeObject(this._previewView);
            this._previewView = null;
         }
      }
   }
}

