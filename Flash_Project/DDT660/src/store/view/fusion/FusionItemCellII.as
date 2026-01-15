package store.view.fusion
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   import store.view.StoneCellFrame;
   
   public class FusionItemCellII extends StoreCell
   {
      
      public static const CONTENTSIZE:int = 77;
      
      public static const PICPOS:int = 25;
      
      private var _cellBg:StoneCellFrame;
      
      public function FusionItemCellII($index:int)
      {
         var bg:Sprite = new Sprite();
         this._cellBg = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIFusionBG.EquipmentCell");
         this._cellBg.label = LanguageMgr.GetTranslation("store.Fusion.FusionCellText");
         bg.addChild(this._cellBg);
         super(bg,$index);
         setContentSize(CONTENTSIZE,CONTENTSIZE);
         PicPos = new Point(PICPOS,PICPOS);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("ddtstore.StoreIIFusionBG.FunsionstoneCountTextI");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.width = _contentWidth - 18;
            sp.height = _contentHeight - 18;
            if(_picPos != null)
            {
               sp.x = _picPos.x;
            }
            else
            {
               sp.x = Math.abs(sp.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               sp.y = _picPos.y;
            }
            else
            {
               sp.y = Math.abs(sp.height - _contentHeight) / 2;
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._cellBg))
         {
            ObjectUtils.disposeObject(this._cellBg);
         }
         this._cellBg = null;
      }
   }
}

