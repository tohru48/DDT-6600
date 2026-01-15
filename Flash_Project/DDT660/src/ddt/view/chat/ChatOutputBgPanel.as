package ddt.view.chat
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   
   public class ChatOutputBgPanel extends Sprite implements Disposeable
   {
      
      public static var MIN:int = 172;
      
      public static var MAX:int = 396;
      
      private var _topDB:BitmapData;
      
      private var _bottomDB:BitmapData;
      
      private var _midDB:BitmapData;
      
      private var _height:Number = MIN;
      
      private var _matrix:Matrix;
      
      private var _splitBar:Sprite;
      
      private var _cursor:Sprite;
      
      private var _isDrag:Boolean;
      
      public var _isLock:Boolean = false;
      
      public function ChatOutputBgPanel()
      {
         super();
         this.preinitialize();
         this.initialize();
      }
      
      protected function preinitialize() : void
      {
         this._topDB = ComponentFactory.Instance.creatBitmapData("asset.chat.OutputBg_Top");
         this._midDB = ComponentFactory.Instance.creatBitmapData("asset.chat.OutputBg_Mid");
         this._bottomDB = ComponentFactory.Instance.creatBitmapData("asset.chat.OutputBg_Bottom");
         this._cursor = ComponentFactory.Instance.creat("SplitCursor");
         this._cursor.mouseChildren = false;
         this._cursor.mouseEnabled = false;
         this._matrix = new Matrix();
         this._splitBar = new Sprite();
         with(this._splitBar.graphics)
         {
            beginFill(16777215,0);
            drawRect(0,0,494,8);
            endFill();
         }
         this._splitBar.y = -MIN;
      }
      
      protected function initialize() : void
      {
         addChild(this._splitBar);
         this.addEvent();
         this.invalidate();
      }
      
      protected function addEvent() : void
      {
         this._splitBar.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         this._splitBar.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._splitBar.addEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseDown);
         this._splitBar.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onMouseUp);
      }
      
      protected function removeEvent() : void
      {
         this._splitBar.removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         this._splitBar.removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._splitBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseDown);
         this._splitBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onMouseUp);
      }
      
      private function __onMouseUp(event:MouseEvent) : void
      {
         if(this._isDrag)
         {
            this._isDrag = false;
            this._splitBar.stopDrag();
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
            if(Boolean(this._cursor.parent))
            {
               this._cursor.parent.removeChild(this._cursor);
            }
         }
      }
      
      private function __onMouseDown(event:MouseEvent) : void
      {
         if(!this._isLock)
         {
            this._isDrag = true;
            this._splitBar.startDrag(false,new Rectangle(0,-MIN,0,-MAX + MIN));
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
         }
      }
      
      private function __onMouseOver(event:MouseEvent) : void
      {
         Mouse.hide();
         this._cursor.x = StageReferance.stage.mouseX;
         this._cursor.y = StageReferance.stage.mouseY;
         StageReferance.stage.addChild(this._cursor);
      }
      
      private function __onMouseOut(event:MouseEvent) : void
      {
         if(Boolean(this._cursor.parent))
         {
            this._cursor.parent.removeChild(this._cursor);
         }
         Mouse.show();
      }
      
      private function __onMouseMove(event:MouseEvent) : void
      {
         if(Boolean(this._cursor.parent))
         {
            this._cursor.x = StageReferance.stage.mouseX;
            this._cursor.y = StageReferance.stage.mouseY;
         }
         if(this._isDrag)
         {
            this.Height = -(this._splitBar.y >> 0);
         }
      }
      
      public function set Height(value:Number) : void
      {
         if(value != this._height && value >= MIN && value <= MAX)
         {
            this._height = value;
            this.invalidate();
            dispatchEvent(new Event(Event.RESIZE));
         }
      }
      
      public function resetSplit() : void
      {
         this._splitBar.y = -this._height;
      }
      
      public function get Height() : Number
      {
         return this._height;
      }
      
      private function invalidate() : void
      {
         with(graphics)
         {
            clear();
            _matrix.ty = -_bottomDB.height;
            beginBitmapFill(_bottomDB,_matrix,false);
            drawRect(0,-_bottomDB.height,_bottomDB.width,_bottomDB.height);
            beginBitmapFill(_midDB,_matrix,true);
            drawRect(0,-_height + _topDB.height,_midDB.width,_height - _topDB.height - _bottomDB.height);
            _matrix.ty = -_height;
            beginBitmapFill(_topDB,_matrix,false);
            drawRect(0,-_height,_topDB.width,_topDB.height);
            endFill();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._topDB.dispose();
         this._midDB.dispose();
         this._bottomDB.dispose();
         if(Boolean(this._cursor.parent))
         {
            this._cursor.parent.removeChild(this._cursor);
         }
         this._cursor = null;
         if(Boolean(this._splitBar.parent))
         {
            this._splitBar.parent.removeChild(this._splitBar);
         }
         this._splitBar = null;
         this._matrix = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

