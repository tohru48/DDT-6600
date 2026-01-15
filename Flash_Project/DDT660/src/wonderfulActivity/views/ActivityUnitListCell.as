package wonderfulActivity.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import wonderfulActivity.data.ActivityCellVo;
   
   public class ActivityUnitListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _selectedLight:Scale9CornerImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _data:ActivityCellVo;
      
      private var icon:Bitmap;
      
      public function ActivityUnitListCell()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.listCellBG");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._selectedLight = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.listCellLight");
         addChild(this._selectedLight);
         this._selectedLight.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.listCellTxt");
         this._nameTxt.setFrame(1);
         addChild(this._nameTxt);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._selectedLight.visible = isSelected;
         if(isSelected)
         {
            this._bg.setFrame(2);
            this._nameTxt.setFrame(2);
         }
         else
         {
            this._bg.setFrame(1);
            this._nameTxt.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value as ActivityCellVo;
         this._nameTxt.text = this._data.activityName;
         this.initIcon();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._selectedLight))
         {
            ObjectUtils.disposeObject(this._selectedLight);
         }
         this._selectedLight = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
      }
      
      private function initIcon() : void
      {
         if(Boolean(this.icon))
         {
            ObjectUtils.disposeObject(this.icon);
            this.icon = null;
         }
         if(this._data == null)
         {
            return;
         }
         var iconId:int = this._data.iconId;
         if(iconId == 1)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_chongzhi");
         }
         else if(iconId == 2)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_qita");
         }
         else if(iconId == 3)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_duihuan");
         }
         else if(iconId == 4)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_hunli");
         }
         else if(iconId == 5)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_lingqu");
         }
         else if(iconId == 6)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_xiaofei");
         }
         else if(iconId == 0)
         {
            return;
         }
         PositionUtils.setPos(this.icon,"wonderfulactivity.left.iconPos");
         addChild(this.icon);
      }
   }
}

