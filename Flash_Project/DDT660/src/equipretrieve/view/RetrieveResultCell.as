package equipretrieve.view
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class RetrieveResultCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 5;
      
      public static const SHINE_SIZE:int = 76;
      
      private var bg:Sprite = new Sprite();
      
      private var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell1");
      
      private var _text:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.reworkname.Text1");
      
      public function RetrieveResultCell($index:int)
      {
         this._text.text = LanguageMgr.GetTranslation("store.Fusion.FusionCellText");
         this.bg.addChild(this.bgBit);
         this.bg.addChild(this._text);
         super(this.bg,$index);
      }
      
      override public function startShine() : void
      {
         _shiner.x = SHINE_XY;
         _shiner.y = SHINE_XY;
         _shiner.width = _shiner.height = SHINE_SIZE;
         super.startShine();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("equipretrieve.goodsCountTextII");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.bgBit))
         {
            ObjectUtils.disposeObject(this.bgBit);
         }
         if(Boolean(this._text))
         {
            ObjectUtils.disposeObject(this._text);
         }
         if(Boolean(this.bg))
         {
            ObjectUtils.disposeObject(this.bg);
         }
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         this.bgBit = null;
         this.bg = null;
         _tbxCount = null;
         this._text = null;
      }
   }
}

