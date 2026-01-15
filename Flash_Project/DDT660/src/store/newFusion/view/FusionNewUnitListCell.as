package store.newFusion.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import store.newFusion.data.FusionNewVo;
   
   public class FusionNewUnitListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _countTxt:FilterFrameText;
      
      private var _selectedCover:Bitmap;
      
      private var _data:FusionNewVo;
      
      public function FusionNewUnitListCell()
      {
         super();
         this.mouseChildren = false;
         this.buttonMode = true;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.cellNameTxt");
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.cellCountTxt");
         this._selectedCover = ComponentFactory.Instance.creatBitmap("asset.newFusion.unitCell.selectedCover");
         this._selectedCover.visible = false;
         addChild(this._selectedCover);
         addChild(this._nameTxt);
         addChild(this._countTxt);
         this.graphics.lineStyle(1,4137989);
         this.graphics.moveTo(0,24);
         this.graphics.lineTo(205,24);
         this.graphics.lineStyle(1,9334339);
         this.graphics.moveTo(0,25);
         this.graphics.lineTo(205,25);
      }
      
      private function updateViewData() : void
      {
         if(this._data.fusionItemInfo == null)
         {
            return;
         }
         this._nameTxt.text = this._data.fusionItemInfo.Name;
         var tmp:int = this._data.canFusionCount;
         if(tmp > 0)
         {
            this._countTxt.text = "(" + tmp + ")";
         }
         else
         {
            this._countTxt.text = "";
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._selectedCover.visible = isSelected;
         this._nameTxt.textColor = isSelected ? 16051939 : 16768669;
         this._countTxt.textColor = isSelected ? 16051939 : 16768669;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value as FusionNewVo;
         this.updateViewData();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._selectedCover = null;
         this._nameTxt = null;
         this._countTxt = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

