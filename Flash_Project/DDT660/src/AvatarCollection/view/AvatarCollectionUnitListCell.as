package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class AvatarCollectionUnitListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _canActivityIcon:Bitmap;
      
      public function AvatarCollectionUnitListCell()
      {
         super();
         this.mouseChildren = false;
         this.buttonMode = true;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitListCell.bg");
         this._bg.setFrame(1);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitListCell.nameTxt");
         this._nameTxt.setFrame(1);
         this._canActivityIcon = ComponentFactory.Instance.creatBitmap("asset.avatarColl.unitCell.canActivityIcon");
         this._canActivityIcon.visible = false;
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._canActivityIcon);
      }
      
      private function updateViewData() : void
      {
         var totalCount:int = int(this._data.totalItemList.length);
         var activityCount:int = this._data.totalActivityItemCount;
         this._nameTxt.text = this._data.name + "（" + activityCount + "/" + totalCount + "）";
         if(this._data.canActivityCount > 0)
         {
            this._canActivityIcon.visible = true;
         }
         else
         {
            this._canActivityIcon.visible = false;
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._bg.setFrame(isSelected ? 2 : 1);
         this._nameTxt.setFrame(isSelected ? 2 : 1);
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value as AvatarCollectionUnitVo;
         this.updateViewData();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._nameTxt = null;
         this._canActivityIcon = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

