package login.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RoleItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _roleInfo:Role;
      
      private var _backImage:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _nicknameField:FilterFrameText;
      
      private var _data:Object;
      
      private var _light:ScaleBitmapImage;
      
      private var _isSelected:Boolean;
      
      private var _deletedIcon:Bitmap;
      
      public function RoleItem()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this.configUi();
         this.initEvent();
      }
      
      private function configUi() : void
      {
         this._backImage = ComponentFactory.Instance.creatBitmap("login.chooserole.cell.bg");
         addChild(this._backImage);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("login.ChooseRole.cell.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.Nickname");
         addChild(this._nicknameField);
         this._light = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRoleListItem.light");
         addChild(this._light);
         this._deletedIcon = ComponentFactory.Instance.creatBitmap("asset.login.chooseRoleFrame.deletedIcon");
         addChild(this._deletedIcon);
         this._deletedIcon.visible = false;
         this._light.visible = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function __mouseOverHandler(evt:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(evt:MouseEvent) : void
      {
         this._light.visible = this._isSelected;
      }
      
      public function get selected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set selected(val:Boolean) : void
      {
         this._light.visible = this._isSelected = val;
      }
      
      public function get roleInfo() : Role
      {
         return this._roleInfo;
      }
      
      public function set roleInfo(val:Role) : void
      {
         this._roleInfo = val;
         this._levelIcon.setInfo(this._roleInfo.Grade,0,this._roleInfo.WinCount,this._roleInfo.TotalCount,1,0);
         this._nicknameField.text = this._roleInfo.NickName;
         this.refreshDeleteIcon();
      }
      
      public function refreshDeleteIcon() : void
      {
         if(this._roleInfo.LoginState == 1)
         {
            this._deletedIcon.visible = true;
         }
         else
         {
            this._deletedIcon.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._backImage))
         {
            ObjectUtils.disposeObject(this._backImage);
            this._backImage.bitmapData.dispose();
            this._backImage.bitmapData = null;
            this._backImage = null;
         }
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._nicknameField))
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
         if(Boolean(this._deletedIcon))
         {
            ObjectUtils.disposeObject(this._deletedIcon);
            this._deletedIcon = null;
         }
         if(Boolean(this._light))
         {
            ObjectUtils.disposeObject(this._light);
            this._light = null;
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value;
         this.roleInfo = this._data as Role;
      }
   }
}

