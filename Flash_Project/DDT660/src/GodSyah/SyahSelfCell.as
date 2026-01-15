package GodSyah
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Bitmap;
   import flash.filters.ColorMatrixFilter;
   
   public class SyahSelfCell extends BaseCell
   {
      
      private var _cellShineBg:Bitmap;
      
      private var _shineEnable:Boolean;
      
      public function SyahSelfCell()
      {
         super(ComponentFactory.Instance.creatBitmap("wonderfulactivity.GodSyah.syahView.0aphacell"));
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(this._shineEnable)
         {
            if(Boolean(_pic))
            {
               _pic.filters = [];
            }
            this._cellShineBg = ComponentFactory.Instance.creatBitmap("wonderfulactivity.GodSyah.syahView.cellShine");
            addChild(this._cellShineBg);
         }
         else
         {
            _pic.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      public function get shineEnable() : Boolean
      {
         return this._shineEnable;
      }
      
      public function set shineEnable(value:Boolean) : void
      {
         this._shineEnable = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._cellShineBg))
         {
            ObjectUtils.disposeObject(this._cellShineBg);
            this._cellShineBg = null;
         }
      }
   }
}

