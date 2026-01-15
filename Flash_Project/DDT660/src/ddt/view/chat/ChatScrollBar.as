package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChatScrollBar extends Sprite implements Disposeable
   {
      
      private var _currentIndex:int;
      
      private var _rowsOfScreen:int = 16;
      
      private var _length:int;
      
      private var _height:Number;
      
      private var _moveBtn:Sprite;
      
      private var _bitDB:BitmapData;
      
      private var _isDrag:Boolean = false;
      
      private var _backFun:Function;
      
      public function ChatScrollBar(_fun:Function)
      {
         super();
         this._backFun = _fun;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bitDB = ComponentFactory.Instance.creatBitmapData("asset.core.scroll.thumbV2");
         this._moveBtn = new Sprite();
         this._moveBtn.buttonMode = true;
         this._moveBtn.filters = [new GlowFilter(6705447,0.9)];
         addChild(this._moveBtn);
      }
      
      private function initEvent() : void
      {
         this._moveBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
      }
      
      private function removeEvent() : void
      {
         this._moveBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         if(stage.hasEventListener(MouseEvent.MOUSE_UP))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         }
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         }
      }
      
      private function __mouseDown(event:MouseEvent) : void
      {
         this._isDrag = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         this._moveBtn.startDrag(false,new Rectangle(0,0,0,this._height - this._moveBtn.height));
      }
      
      private function __mouseUp(event:MouseEvent) : void
      {
         this._isDrag = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         this._moveBtn.stopDrag();
      }
      
      private function __mouseMove(event:MouseEvent) : void
      {
         var pos:int = 0;
         if(this._length > this._rowsOfScreen)
         {
            pos = this._length - this._rowsOfScreen - int(this._moveBtn.y / ((this._height - this._moveBtn.height) / (this._length - this._rowsOfScreen)));
            if(pos != this._currentIndex)
            {
               this._backFun(this._moveBtn.y + this._moveBtn.height + 1 >= this._height ? 0 : pos);
            }
         }
      }
      
      private function drawBackground() : void
      {
         graphics.clear();
         graphics.beginFill(0,0.5);
         graphics.drawRoundRect(4,1,4,this._height,4,4);
         graphics.endFill();
      }
      
      private function draw() : void
      {
         var _h:Number = NaN;
         if(this._length > this._rowsOfScreen)
         {
            _h = this._rowsOfScreen / this._length * this._height;
            this.drawThumb(_h);
            this._moveBtn.y = this._height - this._moveBtn.height - this._currentIndex * (1 / (this._length - this._rowsOfScreen)) * (this._height - _h);
         }
         else
         {
            this._moveBtn.graphics.clear();
         }
      }
      
      private function drawThumb(val:Number) : void
      {
         var _matrix:Matrix = new Matrix();
         var _topBit:BitmapData = new BitmapData(12,4);
         var _midBit:BitmapData = new BitmapData(12,4);
         var _bottomBit:BitmapData = new BitmapData(12,4);
         _topBit.copyPixels(this._bitDB,new Rectangle(0,0,12,4),new Point(0,0));
         _midBit.copyPixels(this._bitDB,new Rectangle(0,4,12,4),new Point(0,0));
         _bottomBit.copyPixels(this._bitDB,new Rectangle(0,this._bitDB.height - 4,12,4),new Point(0,0));
         this._moveBtn.graphics.clear();
         this._moveBtn.graphics.beginBitmapFill(_topBit,_matrix,false);
         this._moveBtn.graphics.drawRect(0,0,12,4);
         this._moveBtn.graphics.beginBitmapFill(_midBit,_matrix);
         this._moveBtn.graphics.drawRect(0,4,12,val - 4);
         _matrix.ty = val - 4;
         this._moveBtn.graphics.beginBitmapFill(_bottomBit,_matrix,false);
         this._moveBtn.graphics.drawRect(0,val - 4,12,4);
         this._moveBtn.graphics.endFill();
      }
      
      public function set length(val:int) : void
      {
         if(this._length != val)
         {
            this._length = val;
            this.draw();
         }
      }
      
      public function set rowsOfScreen(val:int) : void
      {
         if(this._rowsOfScreen != val)
         {
            this._rowsOfScreen = val;
         }
      }
      
      public function set currentIndex(val:int) : void
      {
         if(this._currentIndex != val && !this._isDrag)
         {
            this._currentIndex = val + this._rowsOfScreen > this._length ? this._length - this._rowsOfScreen : val;
            this.draw();
         }
      }
      
      public function set Height(val:Number) : void
      {
         visible = val > 6 ? true : false;
         if(this._height != val)
         {
            this._height = val;
            this.drawBackground();
            this.draw();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._moveBtn = null;
         this._bitDB.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

