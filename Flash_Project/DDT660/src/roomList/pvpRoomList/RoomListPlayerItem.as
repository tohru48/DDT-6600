package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerTipManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class RoomListPlayerItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _name:FilterFrameText;
      
      private var _BG:Bitmap;
      
      private var _isSelected:Boolean;
      
      private var _vipName:GradientText;
      
      public function RoomListPlayerItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.playerItemBG");
         this._BG.visible = false;
         this._BG.y = 2;
         addChild(this._BG);
         this._name = ComponentFactory.Instance.creat("asset.ddtroomList.pvp.playerItem.Name");
         addChild(this._name);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.PlayerItem.SexIcon");
         addChild(this._sexIcon);
         addEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      private function itemClick(event:MouseEvent) : void
      {
         PlayerTipManager.show(this._info,localToGlobal(new Point(0,0)).y);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._isSelected = isSelected;
         if(Boolean(this._BG))
         {
            this._BG.visible = this._isSelected;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         ObjectUtils.disposeObject(this._vipName);
         if(this._info.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(120,this._info.typeVIP);
            this._vipName.x = this._name.x;
            this._vipName.y = this._name.y;
            this._vipName.text = this._info.NickName;
            addChild(this._vipName);
         }
         this._name.text = this._info.NickName;
         PositionUtils.adaptNameStyle(this._info,this._name,this._vipName);
         this._sexIcon.setSex(this._info.Sex);
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.itemClick);
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
         }
         this._vipName = null;
         if(Boolean(this._name))
         {
            this._name.dispose();
            this._name = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._sexIcon))
         {
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
            this._BG = null;
         }
      }
   }
}

