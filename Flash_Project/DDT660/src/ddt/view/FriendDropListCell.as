package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IDropListCell;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   
   public class FriendDropListCell extends Component implements IDropListCell
   {
      
      private var _sex_icon:SexIcon;
      
      private var _data:String;
      
      private var _textField:FilterFrameText;
      
      private var _selected:Boolean;
      
      private var _bg:Bitmap;
      
      public function FriendDropListCell()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("asset.core.comboxItembg3");
         this._bg.width = 220;
         this._textField = ComponentFactory.Instance.creatComponentByStylename("droplist.CellText");
         this._sex_icon = new SexIcon();
         PositionUtils.setPos(this._sex_icon,"IM.IMLookup.SexPos");
         this._bg.alpha = 0;
         width = this._bg.width;
         height = this._bg.height;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         if(Boolean(this._textField))
         {
            addChild(this._textField);
         }
         if(Boolean(this._sex_icon))
         {
            addChild(this._sex_icon);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         if(this._selected)
         {
            this._bg.alpha = 1;
         }
         else
         {
            this._bg.alpha = 0;
         }
      }
      
      public function getCellValue() : *
      {
         if(Boolean(this._data))
         {
            return (this._data as PlayerInfo).NickName;
         }
         return "";
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value;
         if(value)
         {
            this._textField.text = value.NickName;
            this._sex_icon.visible = true;
            this._sex_icon.setSex(value.Sex);
         }
         else
         {
            this._textField.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
            this._sex_icon.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._sex_icon))
         {
            ObjectUtils.disposeObject(this._sex_icon);
         }
         this._sex_icon = null;
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

