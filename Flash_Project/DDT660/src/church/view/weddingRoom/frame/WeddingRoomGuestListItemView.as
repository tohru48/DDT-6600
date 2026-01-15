package church.view.weddingRoom.frame
{
   import church.view.menu.MenuView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class WeddingRoomGuestListItemView extends Sprite implements Disposeable, IListCell
   {
      
      private var _data:Object;
      
      private var _playerInfo:PlayerInfo;
      
      private var _index:int;
      
      private var _levelIcon:LevelIcon;
      
      private var _txtItemInfo:FilterFrameText;
      
      private var _ltemBgAc:Bitmap;
      
      private var _sexIcon:SexIcon;
      
      private var _isSelected:Boolean;
      
      private var _vipName:GradientText;
      
      private var _itemBG:DisplayObject;
      
      private var _line:TiledImage;
      
      public function WeddingRoomGuestListItemView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this._itemBG = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListView.listItemBG");
         addChild(this._itemBG);
         this._line = ComponentFactory.Instance.creatComponentByStylename("church.room.VerticalLine");
         addChild(this._line);
         this._txtItemInfo = ComponentFactory.Instance.creat("church.room.listGuestListItemInfoAsset");
         this._txtItemInfo.mouseEnabled = false;
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListItemLevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListItemSexIcon");
         this._sexIcon.size = 0.8;
         addChild(this._sexIcon);
      }
      
      private function setEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      private function itemClick(event:MouseEvent) : void
      {
         if(this._playerInfo.ID == ChurchManager.instance.currentRoom.brideID || this._playerInfo.ID == ChurchManager.instance.currentRoom.groomID)
         {
            return;
         }
         MenuView.show(this._playerInfo);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._isSelected = isSelected;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value;
         this._playerInfo = value.playerInfo;
         this._index = value.index;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         this._itemBG.visible = Boolean(this._index % 2) ? false : true;
         this._txtItemInfo.text = this._playerInfo.NickName;
         if(this._playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(109,this._playerInfo.typeVIP);
            this._vipName.x = 65;
            this._vipName.y = 6;
            this._vipName.text = this._txtItemInfo.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._txtItemInfo);
         }
         else
         {
            addChild(this._txtItemInfo);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._sexIcon.setSex(this._playerInfo.Sex);
         this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer,true,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function removeView() : void
      {
         if(Boolean(this._levelIcon))
         {
            if(Boolean(this._levelIcon.parent))
            {
               this._levelIcon.parent.removeChild(this._levelIcon);
            }
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(Boolean(this._txtItemInfo))
         {
            if(Boolean(this._txtItemInfo.parent))
            {
               this._txtItemInfo.parent.removeChild(this._txtItemInfo);
            }
            this._txtItemInfo.dispose();
         }
         this._txtItemInfo = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(this._sexIcon))
         {
            if(Boolean(this._sexIcon.parent))
            {
               this._sexIcon.parent.removeChild(this._sexIcon);
            }
            this._sexIcon.dispose();
         }
         this._sexIcon = null;
         if(Boolean(this._line))
         {
            if(Boolean(this._line.parent))
            {
               this._line.parent.removeChild(this._line);
            }
         }
         this._line = null;
         if(Boolean(this._itemBG))
         {
            if(Boolean(this._itemBG.parent))
            {
               this._itemBG.parent.removeChild(this._itemBG);
            }
         }
         this._itemBG = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

