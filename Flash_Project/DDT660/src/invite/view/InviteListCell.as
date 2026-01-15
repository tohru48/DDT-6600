package invite.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import vip.VipController;
   
   public class InviteListCell extends Sprite implements Disposeable, IListCell
   {
      
      private static const LevelLimit:int = 6;
      
      private static const RoomTypeLimit:int = 2;
      
      public var roomType:int;
      
      private var _data:Object;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _masterIcon:ScaleFrameImage;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _BG:Bitmap;
      
      private var _BGII:Bitmap;
      
      private var _isSelected:Boolean;
      
      private var _inviteButton:TextButton;
      
      private var _titleBG:ScaleFrameImage;
      
      private var _triangle:ScaleFrameImage;
      
      private var _titleText:FilterFrameText;
      
      private var _numText:FilterFrameText;
      
      public function InviteListCell()
      {
         super();
         this.configUi();
         this.addEvent();
         mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._titleBG))
         {
            ObjectUtils.disposeObject(this._titleBG);
            this._titleBG = null;
         }
         if(Boolean(this._triangle))
         {
            ObjectUtils.disposeObject(this._triangle);
            this._triangle = null;
         }
         if(Boolean(this._titleText))
         {
            ObjectUtils.disposeObject(this._titleText);
            this._titleText = null;
         }
         if(Boolean(this._numText))
         {
            ObjectUtils.disposeObject(this._numText);
            this._numText = null;
         }
         if(Boolean(this._inviteButton))
         {
            ObjectUtils.disposeObject(this._inviteButton);
            this._inviteButton = null;
         }
         if(Boolean(this._sexIcon))
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
            this._name = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function configUi() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.playerItemName");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.SexIcon");
         addChild(this._sexIcon);
         this._masterIcon = UICreatShortcut.creatAndAdd("asset.ddtinvite.cell.masterRelationIcon",this);
         this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.inviteBtn");
         this._inviteButton.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.Title");
         addChild(this._inviteButton);
         this._titleBG = ComponentFactory.Instance.creat("ddtinvite.titleItemBg");
         this._titleBG.setFrame(1);
         addChild(this._titleBG);
         this._triangle = ComponentFactory.Instance.creatComponentByStylename("ddtinvite.triangle");
         this._triangle.setFrame(1);
         addChild(this._triangle);
         this._titleText = ComponentFactory.Instance.creat("IM.item.title");
         PositionUtils.setPos(this._titleText,"ddtinvite.titleTxtPos");
         this._titleText.text = "";
         addChild(this._titleText);
         this._numText = ComponentFactory.Instance.creat("IM.item.title");
         this._numText.text = "";
         this._numText.y = this._titleText.y;
         addChild(this._numText);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._inviteButton.addEventListener(MouseEvent.CLICK,this.__onInviteClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._inviteButton.removeEventListener(MouseEvent.CLICK,this.__onInviteClick);
      }
      
      private function __onInviteClick(evt:MouseEvent) : void
      {
         var roominfo:RoomInfo = null;
         SoundManager.instance.play("008");
         roominfo = RoomManager.Instance.current;
         if(roominfo != null)
         {
            if(roominfo.placeCount < 1)
            {
               if(roominfo.players.length > 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
               }
               return;
            }
            this._inviteButton.enable = false;
            this._inviteButton.filters = [ComponentFactory.Instance.model.getSet("asset.ddtinvite.GF4")];
            this._data.invited = true;
            if(roominfo.type == RoomInfo.MATCH_ROOM)
            {
               if(this.inviteLvTip(LevelLimit))
               {
                  return;
               }
            }
            else if(roominfo.type == RoomInfo.CHALLENGE_ROOM)
            {
               if(this.inviteLvTip(12))
               {
                  return;
               }
            }
            if((roominfo.type == RoomInfo.DUNGEON_ROOM || roominfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM || roominfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON) && this._data.Grade < GameManager.MinLevelDuplicate)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
               return;
            }
            if(roominfo.type == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._data.Grade < GameManager.MinLevelActivity)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.activityLow"));
               return;
            }
         }
         else
         {
            this._inviteButton.enable = false;
            this._inviteButton.filters = [ComponentFactory.Instance.model.getSet("asset.ddtinvite.GF4")];
            this._data.invited = true;
            if(this.checkLevel(this._data.Grade))
            {
               SocketManager.Instance.out.sendInviteYearFoodRoom(false,this._data.ID);
            }
         }
         if(this._data is ConsortiaPlayerInfo)
         {
            if(this.checkLevel(this._data.info.Grade))
            {
               GameInSocketOut.sendInviteGame(this._data.info.ID);
            }
         }
         else if(this.checkLevel(this._data.Grade))
         {
            GameInSocketOut.sendInviteGame(this._data.ID);
         }
      }
      
      private function inviteLvTip(lv:int) : Boolean
      {
         if(this._data is ConsortiaPlayerInfo)
         {
            if(this._data.info.Grade < lv)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot",lv));
               return true;
            }
         }
         else if(this._data.Grade < lv)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot",lv));
            return true;
         }
         return false;
      }
      
      private function checkLevel(level:int) : Boolean
      {
         var roominfo:RoomInfo = RoomManager.Instance.current;
         if(roominfo != null)
         {
            if(roominfo.type > RoomTypeLimit)
            {
               if(level < GameManager.MinLevelDuplicate)
               {
                  return false;
               }
            }
            else if(roominfo.type == RoomTypeLimit)
            {
               if((roominfo.levelLimits - 1) * 10 > level)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value;
         this.update();
      }
      
      private function update() : void
      {
         if(this._data.type == 0)
         {
            this.updateTitle();
         }
         else
         {
            this.updatePlayer();
         }
         if(this._triangle.visible)
         {
            this.updateItemState();
         }
      }
      
      private function updateItemState() : void
      {
         if(Boolean(this._data.titleIsSelected))
         {
            this._triangle.setFrame(2);
            this._titleBG.setFrame(2);
            this._titleBG.alpha = 1;
         }
         else
         {
            this._triangle.setFrame(1);
            this._titleBG.setFrame(1);
            this._titleBG.alpha = 0;
         }
      }
      
      private function __itemOver(evt:MouseEvent) : void
      {
         this._titleBG.alpha = 1;
      }
      
      private function __itemOut(evt:MouseEvent) : void
      {
         if(this._titleBG.visible && !this._data.titleIsSelected)
         {
            this._titleBG.alpha = 0;
         }
      }
      
      private function showTitle(isShowTitle:Boolean) : void
      {
         this._name.visible = !isShowTitle;
         this._levelIcon.visible = !isShowTitle;
         this._sexIcon.visible = !isShowTitle;
         this._masterIcon.visible = !isShowTitle;
         this._inviteButton.visible = !isShowTitle;
         if(Boolean(this._vipName))
         {
            this._vipName.visible = !isShowTitle;
         }
         this.buttonMode = isShowTitle;
         this._titleBG.visible = isShowTitle;
         this._titleBG.alpha = 0;
         this._triangle.visible = isShowTitle;
         this._titleText.visible = isShowTitle;
         this._numText.visible = isShowTitle;
      }
      
      private function updateTitle() : void
      {
         this.showTitle(true);
         this._triangle.setFrame(1);
         this._titleText.text = this._data.titleText;
         this._numText.text = this._data.titleNumText;
         this._numText.x = this._titleText.x + this._titleText.width;
      }
      
      private function updatePlayer() : void
      {
         this.showTitle(false);
         if(!this._data.invited)
         {
            this._inviteButton.enable = true;
            this._inviteButton.filters = null;
         }
         this._name.text = this._data.NickName;
         if(Boolean(this._data.IsVIP))
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(121,this._data.typeVIP);
            this._vipName.x = this._name.x;
            this._vipName.y = this._name.y;
            this._vipName.text = this._name.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._name);
         }
         addChild(this._name);
         PositionUtils.adaptNameStyle(BasePlayer(this._data),this._name,this._vipName);
         this._sexIcon.setSex(this._data.Sex);
         this._levelIcon.setInfo(this._data.Grade,this._data.Repute,this._data.WinCount,this._data.TotalCount,this._data.FightPower,this._data.Offer,true,false);
         this._masterIcon.visible = PlayerManager.Instance.Self.isMyApprent(this._data.ID) || PlayerManager.Instance.Self.isMyMaster(this._data.ID);
         this._sexIcon.visible = !this._masterIcon.visible;
         if(PlayerManager.Instance.Self.isMyMaster(this._data.ID))
         {
            if(Boolean(this._data.Sex))
            {
               this._masterIcon.setFrame(1);
            }
            else
            {
               this._masterIcon.setFrame(2);
            }
         }
         else if(Boolean(this._data.Sex))
         {
            this._masterIcon.setFrame(3);
         }
         else
         {
            this._masterIcon.setFrame(4);
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

