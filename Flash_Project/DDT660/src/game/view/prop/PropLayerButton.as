package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PropLayerButton extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private var _background:ScaleFrameImage;
      
      private var _shine:Bitmap;
      
      private var _tipData:String;
      
      private var _mode:int;
      
      private var _mouseOver:Boolean = false;
      
      private var _tipDirction:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function PropLayerButton(mode:int)
      {
         super();
         this._mode = mode;
         this.configUI();
         this.addEvent();
         buttonMode = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOut(evt:MouseEvent) : void
      {
         if(Boolean(this._shine) && Boolean(this._shine.parent))
         {
            this._shine.parent.removeChild(this._shine);
         }
         this._mouseOver = false;
      }
      
      public function set enabled(val:Boolean) : void
      {
      }
      
      public function get enabled() : Boolean
      {
         return true;
      }
      
      private function __mouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._shine))
         {
            addChild(this._shine);
         }
         this._mouseOver = true;
      }
      
      private function configUI() : void
      {
         this._background = ComponentFactory.Instance.creatComponentByStylename("asset.game.prop.ModeBack");
         addChild(this._background);
         this.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.proplayer" + this._mode);
         DisplayUtils.setFrame(this._background,this._mode);
         this._shine = ComponentFactory.Instance.creatBitmap("asset.game.prop.ModeShine");
         ShowTipManager.Instance.addTip(this);
         this._shine.y = -3;
         this._shine.x = -3;
      }
      
      public function setMode(mode:int) : void
      {
         this.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.proplayer" + mode);
         DisplayUtils.setFrame(this._background,mode);
         if(this._mouseOver)
         {
            ShowTipManager.Instance.showTip(this);
         }
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         this.removeEvent();
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
         }
         if(Boolean(this._shine))
         {
            ObjectUtils.disposeObject(this._shine);
            this._shine = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value.toString();
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirction;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirction = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

