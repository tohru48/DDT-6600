package surpriseRoulette.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SurpriseRouletteCell extends BaseCell
   {
      
      private var _bmpBg:Bitmap;
      
      private var _txtCount:FilterFrameText;
      
      private var _text_x:int;
      
      private var _text_y:int;
      
      private var _count:int;
      
      private var _mc:MovieClip;
      
      public function SurpriseRouletteCell(bg:DisplayObject, text_x:int, text_y:int)
      {
         super(bg);
         this._text_x = text_x;
         this._text_y = text_y;
         this.initView();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         PicPos = new Point(-21,-21);
         surpriseRouletteCellGQ = true;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
         addChild(this._txtCount);
         if(this._count <= 1)
         {
            this._txtCount.text = "";
            return;
         }
         this._txtCount.text = String(this._count);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      private function initView() : void
      {
         var rect:Rectangle = null;
         rect = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.rectGlow");
         this._mc = ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectGlintAsset");
         this._mc.visible = false;
         this._mc.width = this._mc.height = rect.width;
         this._mc.x = rect.x;
         this._mc.y = rect.y;
         addChild(this._mc);
         this._txtCount = ComponentFactory.Instance.creat("roulette.RouletteCellCount");
         this._txtCount.x = this._text_x;
         this._txtCount.y = this._text_y;
         addChild(this._txtCount);
         tipDirctions = "1,2,7,0";
      }
      
      public function setEffect(value:Number) : void
      {
         scaleX = scaleY = value;
         if(value == 1)
         {
            this._mc.visible = false;
         }
         else
         {
            this._mc.gotoAndStop(1);
            this._mc.visible = true;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._bmpBg = null;
         this._txtCount = null;
      }
   }
}

