package church.view.invite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import invite.data.InvitePlayerInfo;
   import vip.VipController;
   
   public class ChurchInvitePlayerItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _playerInfo:InvitePlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _inviteItemInfo:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _inviteBtn:TextButton;
      
      private var _itemLine:TiledImage;
      
      private var _isInvite:Boolean;
      
      private var _isSelected:Boolean;
      
      private var _masterIcon:ScaleFrameImage;
      
      private var _itemBG:DisplayObject;
      
      private var _data:Object;
      
      private var _index:int;
      
      public function ChurchInvitePlayerItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatCustomObject("church.ChurchInvitePlayerItem.listItemBG");
         addChild(this._itemBG);
         this._itemLine = ComponentFactory.Instance.creatComponentByStylename("church.ChurchInvitePlayerItem.VerticalLine");
         addChild(this._itemLine);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomInviteItemLevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomInviteItemSexIcon");
         this._sexIcon.size = 0.8;
         addChild(this._sexIcon);
         this._masterIcon = UICreatShortcut.creatAndAdd("church.invite.masterRelationIcon",this);
         this._masterIcon.visible = false;
         this._inviteItemInfo = ComponentFactory.Instance.creat("church.room.inviteItemInfoAsset");
         addChild(this._inviteItemInfo);
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("church.room.inviteItemInviteBtnAsset");
         this._inviteBtn.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.Title");
         addChild(this._inviteBtn);
      }
      
      private function initEvent() : void
      {
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function __mouseClick(evt:MouseEvent) : void
      {
         if(this._playerInfo.invited)
         {
            return;
         }
         SoundManager.instance.play("008");
         this._inviteBtn.enable = false;
         this._inviteBtn.filters = [ComponentFactory.Instance.model.getSet("church.room.inviteItemInviteBtnAssetGF1")];
         this._playerInfo.invited = true;
         var roominfo:ChurchRoomInfo = ChurchManager.instance.currentRoom;
         if(this._playerInfo is ConsortiaPlayerInfo)
         {
            SocketManager.Instance.out.sendChurchInvite(this._playerInfo.ID);
         }
         else
         {
            SocketManager.Instance.out.sendChurchInvite(this._playerInfo.ID);
         }
         this._playerInfo.invited = true;
      }
      
      public function set isInvite(value:Boolean) : void
      {
         this._isInvite = value;
         if(this._playerInfo.invited)
         {
            this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
         else
         {
            this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
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
         if(!this._playerInfo.invited)
         {
            this._inviteBtn.enable = true;
            this._inviteBtn.filters = null;
         }
         this._inviteItemInfo.text = this._playerInfo.NickName;
         if(this._playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(115,this._playerInfo.typeVIP);
            this._vipName.x = this._inviteItemInfo.x;
            this._vipName.y = this._inviteItemInfo.y;
            this._vipName.text = this._inviteItemInfo.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._inviteItemInfo);
         }
         else
         {
            addChild(this._inviteItemInfo);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._sexIcon.setSex(this._playerInfo.Sex);
         this._masterIcon.visible = PlayerManager.Instance.Self.ID != this._playerInfo.ID && (PlayerManager.Instance.Self.isMyApprent(this._playerInfo.ID) || PlayerManager.Instance.Self.isMyMaster(this._playerInfo.ID));
         this._sexIcon.visible = !this._masterIcon.visible;
         this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer,true,false);
         if(PlayerManager.Instance.Self.isMyMaster(this._playerInfo.ID))
         {
            if(this._playerInfo.Sex)
            {
               this._masterIcon.setFrame(1);
            }
            else
            {
               this._masterIcon.setFrame(2);
            }
         }
         else if(this._playerInfo.Sex)
         {
            this._masterIcon.setFrame(3);
         }
         else
         {
            this._masterIcon.setFrame(4);
         }
         this.initEvent();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         ObjectUtils.disposeObject(this._itemBG);
         this._itemBG = null;
         ObjectUtils.disposeObject(this._itemLine);
         this._itemLine = null;
         this._playerInfo = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._sexIcon);
         this._sexIcon = null;
         ObjectUtils.disposeObject(this._masterIcon);
         this._masterIcon = null;
         ObjectUtils.disposeObject(this._inviteItemInfo);
         this._inviteItemInfo = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         ObjectUtils.disposeObject(this._inviteBtn);
         this._inviteBtn = null;
         ObjectUtils.disposeObject(this._itemLine);
         this._itemLine = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

