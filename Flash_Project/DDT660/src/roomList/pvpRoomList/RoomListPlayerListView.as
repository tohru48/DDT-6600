package roomList.pvpRoomList
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.buff.BuffControl;
   import ddt.view.buff.BuffControlManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import hall.event.NewHallEvent;
   import kingBless.KingBlessManager;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import vip.VipController;
   
   public class RoomListPlayerListView extends Sprite implements Disposeable
   {
      
      private var _selfInfo:SelfInfo;
      
      protected var _characterBg:MovieClip;
      
      protected var _propbg:MovieClip;
      
      protected var _listbg:MovieClip;
      
      protected var _listbg2:DisplayObject;
      
      private var _player:ICharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _iconContainer:VBox;
      
      private var _nickNameText:FilterFrameText;
      
      private var _consortiaNameText:FilterFrameText;
      
      private var _repute:FilterFrameText;
      
      private var _reputeText:FilterFrameText;
      
      private var _geste:FilterFrameText;
      
      private var _gesteText:FilterFrameText;
      
      protected var _level:FilterFrameText;
      
      protected var _sex:FilterFrameText;
      
      private var _playerList:ListPanel;
      
      private var _data:DictionaryData;
      
      private var _currentItem:RoomListPlayerItem;
      
      private var _marriedIcon:MarriedIcon;
      
      protected var _buffbgVec:Vector.<Bitmap>;
      
      private var _buff:BuffControl;
      
      private var _vipName:GradientText;
      
      public function RoomListPlayerListView(data:DictionaryData)
      {
         this._data = data;
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initbg();
         this.initView();
         this.initEvent();
      }
      
      public function set type(value:int) : void
      {
      }
      
      protected function initbg() : void
      {
         var startPos:Point = null;
         var i:int = 0;
         this._characterBg = ClassUtils.CreatInstance("asset.ddtroomlist.characterbg") as MovieClip;
         PositionUtils.setPos(this._characterBg,"asset.ddtRoomlist.pvp.left.characterbgpos");
         addChild(this._characterBg);
         this._propbg = ClassUtils.CreatInstance("asset.ddtroomlist.proprbg") as MovieClip;
         PositionUtils.setPos(this._propbg,"asset.ddtRoomlist.pvp.left.propbgpos");
         addChild(this._propbg);
         this._listbg2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.playerlistbg");
         addChild(this._listbg2);
         this._listbg = ClassUtils.CreatInstance("asset.ddtroomlist.listTitle.bg") as MovieClip;
         PositionUtils.setPos(this._listbg,"asset.ddtRoomlist.pvp.left.listbgpos");
         addChild(this._listbg);
         this._buffbgVec = new Vector.<Bitmap>(6);
         startPos = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.pvp.buffbgpos");
         for(i = 0; i < 6; i++)
         {
            this._buffbgVec[i] = ComponentFactory.Instance.creatBitmap("asset.core.buff.buffTiledBg");
            this._buffbgVec[i].x = startPos.x + (this._buffbgVec[i].width - 1) * i;
            this._buffbgVec[i].y = startPos.y;
            addChild(this._buffbgVec[i]);
         }
      }
      
      protected function initView() : void
      {
         this._level = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.levelText");
         this._level.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.level");
         addChild(this._level);
         this._sex = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.sexText");
         this._sex.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
         addChild(this._sex);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.iconContainer");
         addChild(this._iconContainer);
         this._consortiaNameText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.consortiaNameText");
         addChild(this._consortiaNameText);
         this._repute = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.repute");
         this._repute.text = LanguageMgr.GetTranslation("repute");
         this._repute.mouseEnabled = false;
         addChild(this._repute);
         this._reputeText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.reputeTxt");
         addChild(this._reputeText);
         this._geste = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.geste");
         this._geste.text = LanguageMgr.GetTranslation("offer");
         addChild(this._geste);
         this._gesteText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.gesteText");
         addChild(this._gesteText);
         this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.nickNameText");
         this._nickNameText.text = this._selfInfo.NickName;
         addChild(this._nickNameText);
         if(this._selfInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(104,this._selfInfo.typeVIP);
            this._vipName.textSize = 16;
            this._vipName.x = this._nickNameText.x;
            this._vipName.y = this._nickNameText.y + 1;
            this._vipName.text = this._selfInfo.NickName;
            addChild(this._vipName);
         }
         PositionUtils.adaptNameStyle(this._selfInfo,this._nickNameText,this._vipName);
         this._reputeText.text = String(this._selfInfo.Repute);
         this._gesteText.text = String(this._selfInfo.Offer);
         if(this._selfInfo.ConsortiaName == "")
         {
            this._consortiaNameText.text = "";
         }
         else
         {
            this._consortiaNameText.text = String("<" + this._selfInfo.ConsortiaName + ">");
         }
         if(this._consortiaNameText.text.substr(this._consortiaNameText.text.length - 1) == ".")
         {
            this._consortiaNameText.text += ">";
         }
         this._player = CharactoryFactory.createCharacter(this._selfInfo,"room");
         this._player.showGun = true;
         this._player.show();
         this._player.setShowLight(true);
         PositionUtils.setPos(this._player,"asset.ddtroomList.pvp.left.playerPos");
         addChild(this._player as DisplayObject);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pvp.left.levelIcon");
         this._levelIcon.setInfo(this._selfInfo.Grade,this._selfInfo.Repute,this._selfInfo.WinCount,this._selfInfo.TotalCount,this._selfInfo.FightPower,this._selfInfo.Offer,true,false);
         this._levelIcon.allowClick();
         addChild(this._levelIcon);
         if(this._selfInfo.IsVIP)
         {
            this._levelIcon.x += 2;
         }
         this._selfInfo.isOpenKingBless = KingBlessManager.instance.getRemainTimeTxt().isOpen;
         if(this._selfInfo.SpouseID > 0 && !this._marriedIcon)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pvp.left.MarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":this._selfInfo.SpouseName,
               "gender":this._selfInfo.Sex
            };
            this._iconContainer.addChild(this._marriedIcon);
         }
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.playerlistII");
         addChild(this._playerList);
         this._playerList.list.updateListView();
         this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._buff = BuffControlManager.instance.buff;
         PositionUtils.setPos(this._buff,"asset.ddtroomList.pvp.left.buffPos");
         addChild(this._buff);
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
      }
      
      private function __updatePlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.remove(player);
         this._playerList.vectorListModel.insertElementAt(player,this.getInsertIndex(player));
         this._playerList.list.updateListView();
         this.upSelfItem();
      }
      
      private function __addPlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.insertElementAt(player,this.getInsertIndex(player));
         this.upSelfItem();
      }
      
      private function __removePlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.remove(player);
         this.upSelfItem();
      }
      
      private function upSelfItem() : void
      {
         var selfInfo:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
         var index:int = this._playerList.vectorListModel.indexOf(selfInfo);
         if(index == -1 || index == 0)
         {
            return;
         }
         this._playerList.vectorListModel.removeAt(index);
         this._playerList.vectorListModel.append(selfInfo,0);
      }
      
      private function __itemClick(evt:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = evt.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,evt.index);
         }
         if(this._currentItem != evt.cell as RoomListPlayerItem)
         {
            this._currentItem.setListCellStatus(this._playerList.list,false,evt.index);
            this._currentItem = evt.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,evt.index);
         }
      }
      
      private function getInsertIndex(info:PlayerInfo) : int
      {
         var tempInfo:PlayerInfo = null;
         var tempIndex:int = 0;
         var tempArray:Array = this._playerList.vectorListModel.elements;
         if(tempArray.length == 0)
         {
            return 0;
         }
         for(var i:int = tempArray.length - 1; i >= 0; i--)
         {
            tempInfo = tempArray[i] as PlayerInfo;
            if(!(info.IsVIP && !tempInfo.IsVIP))
            {
               if(!info.IsVIP && tempInfo.IsVIP)
               {
                  return i + 1;
               }
               if(info.IsVIP == tempInfo.IsVIP)
               {
                  if(info.Grade <= tempInfo.Grade)
                  {
                     return i + 1;
                  }
                  tempIndex = i - 1;
               }
            }
         }
         return tempIndex < 0 ? 0 : tempIndex;
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         SocketManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.SHOWBUFFCONTROL));
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         this._playerList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._player.dispose();
         this._player = null;
         this._levelIcon.dispose();
         this._levelIcon = null;
         if(Boolean(this._listbg2))
         {
            ObjectUtils.disposeObject(this._listbg2);
         }
         this._listbg2 = null;
         if(Boolean(this._nickNameText))
         {
            this._nickNameText.dispose();
         }
         this._nickNameText = null;
         if(Boolean(this._repute))
         {
            ObjectUtils.disposeObject(this._repute);
         }
         this._repute = null;
         this._consortiaNameText.dispose();
         this._consortiaNameText = null;
         this._reputeText.dispose();
         this._reputeText = null;
         if(Boolean(this._characterBg))
         {
            ObjectUtils.disposeObject(this._characterBg);
         }
         this._characterBg = null;
         if(Boolean(this._propbg))
         {
            ObjectUtils.disposeObject(this._propbg);
         }
         this._propbg = null;
         if(Boolean(this._listbg))
         {
            ObjectUtils.disposeObject(this._listbg);
         }
         this._listbg = null;
         if(Boolean(this._level))
         {
            ObjectUtils.disposeObject(this._level);
         }
         this._level = null;
         if(Boolean(this._geste))
         {
            ObjectUtils.disposeObject(this._geste);
         }
         this._geste = null;
         if(Boolean(this._sex))
         {
            ObjectUtils.disposeObject(this._sex);
         }
         this._sex = null;
         if(Boolean(this._buffbgVec))
         {
            for(i = 0; i < this._buffbgVec.length; i++)
            {
               ObjectUtils.disposeObject(this._buffbgVec[i]);
               this._buffbgVec[i] = null;
            }
            this._buffbgVec = null;
         }
         this._gesteText.dispose();
         this._gesteText = null;
         this._playerList.vectorListModel.clear();
         this._playerList.dispose();
         this._playerList = null;
         if(Boolean(this._marriedIcon))
         {
            ObjectUtils.disposeObject(this._marriedIcon);
            this._marriedIcon = null;
         }
         this._data = null;
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

