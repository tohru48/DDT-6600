package overSeasCommunity.vietnam.view.screenshot
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import overSeasCommunity.vietnam.ScreenshotController;
   
   public class PreviewView extends Frame
   {
      
      private var _borderBg:ScaleBitmapImage;
      
      private var _inputText:TextInput;
      
      private var _submitBtn:BaseButton;
      
      private var _image:Bitmap;
      
      private var _bgTitle:Bitmap;
      
      public var _controller:ScreenshotController;
      
      public function PreviewView()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._borderBg = ComponentFactory.Instance.creat("screenshot.PreviewBg");
         this._bgTitle = ComponentFactory.Instance.creatBitmap("asset.screenshot.PreviewTitle");
         this._image = ComponentFactory.Instance.creatCustomObject("screenshot.cutImage");
         var box:Sprite = new Sprite();
         box.addChild(this._borderBg);
         box.addChild(this._bgTitle);
         box.addChild(this._image);
         addToContent(box);
         this._inputText = ComponentFactory.Instance.creat("screenshot.descInput");
         this._submitBtn = ComponentFactory.Instance.creat("screenshot.submitBtn");
         var box2:Sprite = new Sprite();
         box2.addChild(this._inputText);
         box2.addChild(this._submitBtn);
         addToContent(box2);
      }
      
      private function addEvent() : void
      {
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitClick);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __submitClick(event:MouseEvent) : void
      {
         this._controller.publish(this._image.bitmapData.clone(),this._inputText.text);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._controller.cancel();
         }
      }
      
      public function set controller(value:ScreenshotController) : void
      {
         this._controller = value;
      }
      
      public function show(bitmapdata:BitmapData) : void
      {
         var box:Sprite = null;
         var box2:Sprite = null;
         this._image.bitmapData = bitmapdata;
         this._borderBg.width = Math.max(bitmapdata.width + 44,this._borderBg.width);
         this._borderBg.height = Math.max(bitmapdata.height + 90,this._borderBg.height);
         this._bgTitle.x = (this._borderBg.width - this._bgTitle.width) / 2;
         this._image.x = (this._borderBg.width - this._image.width) / 2 + 1;
         this._image.y = (this._borderBg.height - this._image.height) / 2 + 6;
         box = this._image.parent as Sprite;
         box2 = this._inputText.parent as Sprite;
         box2.y = box.height + 8;
         box.x = (_container.width - box.width) / 2;
         box2.x = (_container.width - box2.width) / 2;
         width = _container.width + _containerX * 2;
         height = _container.height + _containerY * 2;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._controller = null;
         ObjectUtils.disposeObject(this._image);
         this._borderBg = null;
         ObjectUtils.disposeObject(this._bgTitle);
         this._bgTitle = null;
         ObjectUtils.disposeObject(this._borderBg);
         this._borderBg = null;
         ObjectUtils.disposeObject(this._inputText);
         this._inputText = null;
         ObjectUtils.disposeObject(this._submitBtn);
         this._submitBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

