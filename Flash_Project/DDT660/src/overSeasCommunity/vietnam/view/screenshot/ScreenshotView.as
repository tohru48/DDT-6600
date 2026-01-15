package overSeasCommunity.vietnam.view.screenshot
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import overSeasCommunity.vietnam.ScreenshotController;
   
   public class ScreenshotView extends Sprite implements Disposeable
   {
      
      public static const MAX_PHOTO_WIDTH:Number = 400;
      
      public static const MAX_PHOTO_HEIGHT:Number = 400;
      
      private var _bg:Bitmap;
      
      private var _originalImg:Bitmap;
      
      private var _blackGound:Sprite;
      
      private var _camera:Shape;
      
      private var _okBtn:BaseButton;
      
      private var _cancelBtn:BaseButton;
      
      private var _btnBox:HBox;
      
      private var _btnBoxBg:Bitmap;
      
      private var _menuBox:Sprite;
      
      private var _controller:ScreenshotController;
      
      public function ScreenshotView(controller:ScreenshotController)
      {
         super();
         this._controller = controller;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         var bitmapdata:BitmapData = new BitmapData(StageReferance.stageWidth,StageReferance.stageHeight);
         var clipRect:Rectangle = new Rectangle(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         bitmapdata.draw(StageReferance.stage,null,null,null,clipRect);
         this._bg = new Bitmap(bitmapdata);
         addChild(this._bg);
         this._blackGound = new Sprite();
         this._blackGound.graphics.beginFill(0,0.4);
         this._blackGound.graphics.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         this._blackGound.graphics.endFill();
         addChild(this._blackGound);
         this._camera = new Shape();
         this._originalImg = new Bitmap(bitmapdata);
         this._originalImg.mask = this._camera;
         addChild(this._originalImg);
         this._menuBox = new Sprite();
         this._btnBox = ComponentFactory.Instance.creat("screenshot.shot.btnBox");
         this._btnBoxBg = ComponentFactory.Instance.creatBitmap("asset.screenshot.btnBg");
         this._okBtn = ComponentFactory.Instance.creat("screenshot.applyBtn");
         this._cancelBtn = ComponentFactory.Instance.creat("screenshot.cancelBtn");
         this._btnBox.addChild(this._cancelBtn);
         this._btnBox.addChild(this._okBtn);
         this._menuBox.addChild(this._btnBoxBg);
         this._menuBox.addChild(this._btnBox);
      }
      
      private function addEvent() : void
      {
         this._blackGound.addEventListener(MouseEvent.MOUSE_DOWN,this.__blackGoundMouseDown);
         this._blackGound.addEventListener(MouseEvent.MOUSE_UP,this.__blackGoundMouseUp);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function removeEvent() : void
      {
         this._blackGound.removeEventListener(MouseEvent.MOUSE_DOWN,this.__blackGoundMouseDown);
         this._blackGound.removeEventListener(MouseEvent.MOUSE_UP,this.__blackGoundMouseUp);
         this._blackGound.removeEventListener(MouseEvent.MOUSE_MOVE,this.__blackGoundMouseMove);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      private function __blackGoundMouseDown(event:MouseEvent) : void
      {
         this._blackGound.removeEventListener(MouseEvent.MOUSE_DOWN,this.__blackGoundMouseDown);
         this._blackGound.addEventListener(MouseEvent.MOUSE_MOVE,this.__blackGoundMouseMove);
         this._camera.x = event.localX;
         this._camera.y = event.localY;
         addChild(this._camera);
      }
      
      private function __blackGoundMouseMove(event:MouseEvent) : void
      {
         this.drawShape(event);
      }
      
      private function __blackGoundMouseUp(event:MouseEvent) : void
      {
         this._blackGound.removeEventListener(MouseEvent.MOUSE_MOVE,this.__blackGoundMouseMove);
         this._blackGound.removeEventListener(MouseEvent.MOUSE_UP,this.__blackGoundMouseUp);
         this.drawShape(event);
         this._menuBox.x = this._camera.x + this._camera.width - this._menuBox.width;
         this._menuBox.y = this._camera.y + this._camera.height + 10;
         addChild(this._menuBox);
      }
      
      private function drawShape(event:MouseEvent) : void
      {
         this._camera.graphics.clear();
         this._camera.graphics.beginFill(0);
         this._camera.graphics.drawRect(0,0,event.localX - this._camera.x,event.localY - this._camera.y);
         this._camera.graphics.endFill();
      }
      
      private function __okBtnClick(event:MouseEvent) : void
      {
         if(this._camera.width == 0)
         {
            return;
         }
         if(this._camera.height == 0)
         {
            return;
         }
         if(this._camera.width > MAX_PHOTO_WIDTH)
         {
            this._camera.width = MAX_PHOTO_WIDTH;
         }
         if(this._camera.height > MAX_PHOTO_HEIGHT)
         {
            this._camera.height = MAX_PHOTO_HEIGHT;
         }
         var bitmapData:BitmapData = new BitmapData(this._camera.width,this._camera.height);
         var clipRect:Rectangle = new Rectangle(this._camera.x,this._camera.y,this._camera.width,this._camera.height);
         bitmapData.copyPixels(this._bg.bitmapData,clipRect,new Point(0,0));
         this._controller.preview(bitmapData);
      }
      
      private function __cancelBtnClick(event:MouseEvent) : void
      {
         this._controller.cancel();
      }
      
      private function __onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            event.stopImmediatePropagation();
            this._controller.cancel();
         }
      }
      
      public function show() : void
      {
         width = StageReferance.stageWidth;
         height = StageReferance.stageHeight;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,0);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._originalImg);
         this._originalImg = null;
         ObjectUtils.disposeObject(this._camera);
         this._camera = null;
         ObjectUtils.disposeObject(this._blackGound);
         this._blackGound = null;
         ObjectUtils.disposeObject(this._menuBox);
         this._menuBox = null;
         ObjectUtils.disposeObject(this._btnBoxBg);
         this._btnBoxBg = null;
         ObjectUtils.disposeObject(this._btnBox);
         this._btnBox = null;
         ObjectUtils.disposeObject(this._okBtn);
         this._okBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

