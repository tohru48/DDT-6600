package Dice.VO
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellContentCreator;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DiceCell extends BaseCell
   {
      
      private var _txtCount:FilterFrameText;
      
      private var _count:int;
      
      private var _position:int;
      
      private var _strengthLevel:int;
      
      private var _validate:int;
      
      private var _isBind:Boolean = false;
      
      private var _isDestination:Boolean = false;
      
      private var _vertices:Vector.<Number>;
      
      private var _indices:Vector.<int>;
      
      private var _uvtData:Vector.<Number>;
      
      private var _cellInfo:DiceCellInfo;
      
      private var _mask:DisplayObject;
      
      private var _lightByMask:DisplayObject;
      
      private var _Deform:Shape;
      
      public function DiceCell(bg:DisplayObject, cellInfo:DiceCellInfo, $info:ItemTemplateInfo = null, mask:DisplayObject = null, showLoading:Boolean = true, showTip:Boolean = true)
      {
         super(bg,$info,showLoading,showTip);
         this._cellInfo = cellInfo;
         this._mask = mask;
         this.preInitialize();
         this.initialize();
      }
      
      private function preInitialize() : void
      {
         var ClassRef:Class = getDefinitionByName(getQualifiedClassName(this._mask)) as Class;
         this._lightByMask = new ClassRef();
         this._lightByMask.x = this._mask.x;
         this._lightByMask.y = this._mask.y;
      }
      
      public function get isDestination() : Boolean
      {
         return this._isDestination;
      }
      
      public function set isDestination(value:Boolean) : void
      {
         var _x:int = 0;
         var _y:int = 0;
         if(this._isDestination != value)
         {
            this._isDestination = value;
            if(this._isDestination)
            {
               this._lightByMask.filters = [new GlowFilter(16777215,1,10,10,2,1,false,true)];
               addChild(this._lightByMask);
               _x = x - (width * 1.2 - width >> 1);
               _y = y - (height * 1.2 - height >> 1);
               TweenLite.to(this,0.5,{
                  "x":_x,
                  "y":_y,
                  "scaleX":1.2,
                  "scaleY":1.2
               });
               if(Boolean(parent))
               {
                  parent.setChildIndex(this,parent.numChildren - 1);
               }
            }
            else
            {
               TweenLite.to(this,0.5,{
                  "x":this._cellInfo.Position.x,
                  "y":this._cellInfo.Position.y,
                  "scaleX":1,
                  "scaleY":1
               });
               this._lightByMask.filters = null;
               removeChild(this._lightByMask);
            }
         }
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
      
      public function set isBind(value:Boolean) : void
      {
         this._isBind = value;
      }
      
      public function get validate() : int
      {
         return this._validate;
      }
      
      public function set validate(value:int) : void
      {
         this._validate = value;
      }
      
      public function get strengthLevel() : int
      {
         return this._strengthLevel;
      }
      
      public function set strengthLevel(value:int) : void
      {
         this._strengthLevel = value;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(value:int) : void
      {
         this._position = value;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
         this._txtCount.text = String(this._count);
         this._txtCount.visible = true;
         if(value == 1)
         {
            this._txtCount.visible = false;
         }
      }
      
      private function initialize() : void
      {
         _tipGapH = -15;
         _tipGapV = -15;
         this._Deform = new Shape();
         _pic.visible = false;
         _bg.visible = true;
         addChild(_bg);
         addChild(this._Deform);
         addChild(this._mask);
         this._Deform.mask = this._mask;
         this._indices = new Vector.<int>();
         this._indices.push(0,2,1);
         this._indices.push(2,1,3);
         this._uvtData = new Vector.<Number>();
         this._uvtData.push(0,0);
         this._uvtData.push(0,1);
         this._uvtData.push(1,0);
         this._uvtData.push(1,1);
         this._vertices = new Vector.<Number>();
         this._vertices.push(-2,-2);
         this._vertices.push(this._cellInfo.vertices1.x,this._cellInfo.vertices1.y);
         this._vertices.push(this._cellInfo.vertices2.x,this._cellInfo.vertices2.y);
         this._vertices.push(this._cellInfo.vertices3.x,this._cellInfo.vertices3.y);
         this._txtCount = ComponentFactory.Instance.creatComponentByStylename("asset.dice.cellTextCount");
         this._txtCount.x = this._cellInfo.vertices3.x - this._txtCount.width - 17;
         this._txtCount.y = this._cellInfo.vertices3.y - this._txtCount.height - 17;
         x = this._cellInfo.Position.x;
         y = this._cellInfo.Position.y;
      }
      
      override public function setContentSize(cWidth:Number, cHeight:Number) : void
      {
         _contentWidth = _pic.width;
         _contentHeight = _pic.height;
         PicPos = new Point(-_contentWidth >> 1,-_contentHeight >> 1);
         updateSize(_pic);
      }
      
      override protected function createChildren() : void
      {
         _pic = new CellContentCreator();
      }
      
      override protected function createContentComplete() : void
      {
         super.createContentComplete();
         var bmp:BitmapData = new BitmapData(_pic.width,_pic.height,true,0);
         bmp.draw(_pic,null,null,null,null,true);
         this._Deform.graphics.clear();
         this._Deform.graphics.beginBitmapFill(bmp);
         this._Deform.graphics.drawTriangles(this._vertices,this._indices,this._uvtData);
         addChild(this._Deform);
         addChild(this._txtCount);
      }
      
      override public function dispose() : void
      {
         this._vertices = null;
         this._indices = null;
         this._uvtData = null;
         if(Boolean(this._Deform))
         {
            if(Boolean(this._Deform.parent))
            {
               this._Deform.parent.removeChild(this._Deform);
            }
            this._Deform = null;
         }
         super.dispose();
      }
   }
}

