package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.PropInfo;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class PropItemView extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static var _prop:Dictionary;
      
      public static const OVER:String = "over";
      
      public static const OUT:String = "out";
      
      private var _info:PropInfo;
      
      private var _asset:Bitmap;
      
      private var _isExist:Boolean;
      
      private var _tipStyle:String;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapV:int;
      
      private var _tipGapH:int;
      
      public function PropItemView(info:PropInfo, $isExist:Boolean = true, $showPrice:Boolean = true, $count:int = 1)
      {
         super();
         mouseEnabled = true;
         this._info = info;
         this._isExist = $isExist;
         this._asset = PropItemView.createView(this._info.Template.Pic,38,38);
         this._asset.x = 1;
         this._asset.y = 1;
         if(!this._isExist)
         {
            filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         addChild(this._asset);
         this.tipStyle = "core.ToolPropTips";
         this.tipDirctions = "2,7,5,1,6,4";
         this.tipGapH = 20;
         this.tipGapV = 20;
         var tipInfo:ToolPropInfo = new ToolPropInfo();
         tipInfo.info = info.Template;
         tipInfo.count = $count;
         tipInfo.showTurn = $showPrice;
         tipInfo.showThew = true;
         tipInfo.showCount = true;
         this.tipData = tipInfo;
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      public static function createView(id:String, width:int = 62, height:int = 62, smoothing:Boolean = true) : Bitmap
      {
         var className:String = null;
         var t:Bitmap = null;
         var wishBtn:Bitmap = null;
         if(id != "wish")
         {
            className = "game.crazyTank.view.Prop" + id.toString() + "Asset";
            t = ComponentFactory.Instance.creatBitmap(className);
            t.smoothing = smoothing;
            t.width = width;
            t.height = height;
            return t;
         }
         wishBtn = ComponentFactory.Instance.creatBitmap("asset.game.wishBtn");
         wishBtn.smoothing = smoothing;
         wishBtn.width = width;
         wishBtn.height = height;
         return wishBtn;
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      public function set propPos(val:int) : void
      {
         this._asset.x = val;
         this._asset.y = val;
      }
      
      private function __out(event:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OUT));
      }
      
      private function __over(event:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OVER));
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._asset) && Boolean(this._asset.parent))
         {
            this._asset.parent.removeChild(this._asset);
         }
         this._asset.bitmapData.dispose();
         this._asset = null;
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
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
         if(this._tipStyle == value)
         {
            return;
         }
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         if(this._tipData == value)
         {
            return;
         }
         this._tipData = value;
      }
      
      public function set tipDirctions(value:String) : void
      {
         if(this._tipDirctions == value)
         {
            return;
         }
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         if(this._tipGapV == value)
         {
            return;
         }
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         if(this._tipGapH == value)
         {
            return;
         }
         this._tipGapH = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

