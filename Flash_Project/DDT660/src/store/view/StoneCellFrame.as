package store.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StoneCellFrame extends Sprite
   {
      
      private var _textField:FilterFrameText;
      
      private var _textFieldX:Number;
      
      private var _textFieldY:Number;
      
      private var _bg:Bitmap;
      
      private var _text:String;
      
      private var _textStyle:String;
      
      private var _backStyle:String;
      
      public function StoneCellFrame()
      {
         super();
      }
      
      public function set label(value:String) : void
      {
         if(this._textField == null)
         {
            return;
         }
         this._text = value;
         this._textField.text = this._text;
         this._textField.x = this.textFieldX;
         this._textField.y = this.textFieldY;
      }
      
      private function init() : void
      {
         addChild(this._bg);
         addChild(this._textField);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
      }
      
      public function get textStyle() : String
      {
         return this._textStyle;
      }
      
      public function set textStyle(value:String) : void
      {
         if(value == null || value.length == 0)
         {
            return;
         }
         this._textStyle = value;
         this._textField = ComponentFactory.Instance.creatComponentByStylename(this._textStyle);
         addChild(this._textField);
      }
      
      public function get backStyle() : String
      {
         return this._backStyle;
      }
      
      public function set backStyle(value:String) : void
      {
         if(value == null || value.length == 0)
         {
            return;
         }
         this._backStyle = value;
         this._bg = ComponentFactory.Instance.creatBitmap(this._backStyle);
         addChild(this._bg);
      }
      
      public function get textFieldX() : Number
      {
         return this._textFieldX;
      }
      
      public function set textFieldX(value:Number) : void
      {
         this._textFieldX = value;
      }
      
      public function get textFieldY() : Number
      {
         return this._textFieldY;
      }
      
      public function set textFieldY(value:Number) : void
      {
         this._textFieldY = value;
      }
   }
}

