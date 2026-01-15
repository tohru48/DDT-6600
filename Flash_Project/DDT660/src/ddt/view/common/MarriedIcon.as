package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class MarriedIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _gender:Boolean;
      
      public function MarriedIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.core.MarriedIcon");
         addChild(this._icon);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeChild(this._icon);
         this._icon.bitmapData.dispose();
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

