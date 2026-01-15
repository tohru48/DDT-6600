package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BeadItem extends Sprite implements ISelectable, Disposeable
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _numberTxt:FilterFrameText;
      
      private var _beadCell:BaseCell;
      
      private var _count:int;
      
      private var _isSelected:Boolean = false;
      
      private var _inputBg:Bitmap;
      
      public function BeadItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function hideBg() : void
      {
         this._inputBg.visible = false;
         this._numberTxt.visible = false;
         this._bg.visible = false;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bead.selectBox.sparkBorder");
         this._numberTxt = ComponentFactory.Instance.creatComponentByStylename("bead.numberTxt");
         var point:Point = ComponentFactory.Instance.creatCustomObject("bead.cellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,point.x,point.y);
         shape.graphics.endFill();
         this._beadCell = ComponentFactory.Instance.creatCustomObject("bead.selectCell",[shape]);
         this._inputBg = ComponentFactory.Instance.creatBitmap("asset.numInput.bg");
         addChild(this._inputBg);
         addChild(this._numberTxt);
         addChild(this._beadCell);
         addChild(this._bg);
         this._bg.visible = false;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this._over);
         addEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._over);
         removeEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function _over(e:MouseEvent) : void
      {
      }
      
      private function _out(e:MouseEvent) : void
      {
      }
      
      public function set info(info:ItemTemplateInfo) : void
      {
         this._beadCell.info = info;
      }
      
      public function set autoSelect(value:Boolean) : void
      {
      }
      
      public function set selected(value:Boolean) : void
      {
         this._bg.visible = value;
         this._isSelected = value;
      }
      
      public function get selected() : Boolean
      {
         return this._isSelected;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
         this._numberTxt.text = String(this._count);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._numberTxt))
         {
            ObjectUtils.disposeObject(this._numberTxt);
         }
         this._numberTxt = null;
         if(Boolean(this._beadCell))
         {
            ObjectUtils.disposeObject(this._beadCell);
         }
         this._beadCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

