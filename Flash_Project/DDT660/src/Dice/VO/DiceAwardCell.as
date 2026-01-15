package Dice.VO
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class DiceAwardCell extends BaseCell
   {
      
      private var _count:int;
      
      private var _background:Shape;
      
      private var _counttext:FilterFrameText;
      
      private var _caption:FilterFrameText;
      
      public function DiceAwardCell($info:ItemTemplateInfo = null, count:int = 1, showLoading:Boolean = true, showTip:Boolean = true)
      {
         this._background = new Shape();
         with(this._background.graphics)
         {
            lineStyle(1,16777215,0.6);
            beginFill(0,0.5);
            drawRoundRect(0,0,38,38,8,8);
            endFill();
         }
         this._count = count;
         super(this._background,$info,showLoading,showTip);
         this.initialize();
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
      }
      
      private function initialize() : void
      {
         _bg.visible = false;
         this._counttext = ComponentFactory.Instance.creatComponentByStylename("asset.dice.awardcell.count");
         this._counttext.text = String(this._count);
         this._caption = ComponentFactory.Instance.creatComponentByStylename("asset.dice.awardcell.caption");
         this._caption.text = _info.Name;
         if(this._caption.numLines > 1)
         {
            this._caption.y = 2;
         }
         else
         {
            this._caption.y = 10;
         }
         if(this._count > 1)
         {
            addChild(this._counttext);
         }
         addChild(this._caption);
      }
      
      override public function setContentSize(cWidth:Number, cHeight:Number) : void
      {
         PicPos = new Point(-21,-21);
         updateSize(_pic);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._counttext);
         this._counttext = null;
         ObjectUtils.disposeObject(this._caption);
         this._caption = null;
         super.dispose();
      }
   }
}

