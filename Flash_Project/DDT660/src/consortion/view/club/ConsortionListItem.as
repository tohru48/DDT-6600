package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.ConsortiaInfo;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ConsortionListItem extends Sprite implements Disposeable
   {
      
      private var _itemBG:ScaleFrameImage;
      
      private var _vline:MutipleImage;
      
      private var _index:int;
      
      private var _info:ConsortiaInfo;
      
      private var _selected:Boolean;
      
      private var _consortionName:FilterFrameText;
      
      private var _chairMan:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _exploit:FilterFrameText;
      
      private var _light:Scale9CornerImage;
      
      private var _badge:Badge;
      
      public function ConsortionListItem(index:int)
      {
         super();
         this._index = index;
         this.init();
      }
      
      private function init() : void
      {
         this._badge = new Badge();
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListItem");
         if(this._index % 2 == 0)
         {
            this._itemBG.setFrame(2);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
         this._vline = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberItemVLine");
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("club.consortionName");
         this._chairMan = ComponentFactory.Instance.creatComponentByStylename("club.chairMan");
         this._count = ComponentFactory.Instance.creatComponentByStylename("club.count");
         this._level = ComponentFactory.Instance.creatComponentByStylename("club.level");
         this._exploit = ComponentFactory.Instance.creatComponentByStylename("club.exploit");
         this._light = ComponentFactory.Instance.creatComponentByStylename("consortion.club.listItemlight");
         this._light.visible = false;
         addChild(this._itemBG);
         addChild(this._vline);
         addChild(this._badge);
         addChild(this._consortionName);
         addChild(this._chairMan);
         addChild(this._count);
         addChild(this._level);
         addChild(this._exploit);
         addChild(this._light);
         PositionUtils.setPos(this._badge,"consortionClubItem.badge.pos");
      }
      
      public function set info(info:ConsortiaInfo) : void
      {
         if(this._info == info)
         {
            return;
         }
         this._info = info;
         this._badge.badgeID = this._info.BadgeID;
         this._badge.visible = this._info.BadgeID > 0;
         this._consortionName.text = String(info.ConsortiaName);
         this._chairMan.text = String(info.ChairmanName);
         this._count.text = String(info.Count);
         this._level.text = String(info.Level);
         this._exploit.text = String(info.Honor);
      }
      
      public function get info() : ConsortiaInfo
      {
         return this._info;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this._light.visible = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set light(value:Boolean) : void
      {
         if(this._selected)
         {
            return;
         }
         this._light.visible = value;
      }
      
      override public function get height() : Number
      {
         if(this._itemBG == null)
         {
            return 0;
         }
         return this._itemBG.y + this._itemBG.height;
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set isApply(value:Boolean) : void
      {
         if(value)
         {
            alpha = 0.5;
            mouseChildren = false;
            mouseEnabled = false;
            this._light.visible = false;
         }
         else
         {
            alpha = 1;
            mouseChildren = true;
            mouseEnabled = true;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemBG = null;
         this._vline = null;
         this._consortionName = null;
         this._chairMan = null;
         this._count = null;
         this._level = null;
         this._exploit = null;
         this._light = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

