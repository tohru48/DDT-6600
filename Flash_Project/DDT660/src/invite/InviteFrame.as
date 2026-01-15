package invite
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import invite.data.InvitePlayerInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class InviteFrame extends Frame
   {
      
      public static const RECENT:int = 0;
      
      public static const Brotherhood:int = 1;
      
      public static const Friend:int = 2;
      
      public static const Hall:int = 3;
      
      private var _visible:Boolean = true;
      
      private var _resState:String;
      
      private var _listBack:MutipleImage;
      
      private var _refreshButton:TextButton;
      
      private var _fastInviteBtn:TextButton;
      
      private var _hbox:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _hallButton:SelectedTextButton;
      
      private var _frientButton:SelectedTextButton;
      
      private var _brotherhoodButton:SelectedTextButton;
      
      private var _recentContactBtn:SelectedTextButton;
      
      private var _list:ListPanel;
      
      private var _changeComplete:Boolean = false;
      
      private var _refleshCount:int = 0;
      
      private var _invitePlayerInfos:Array;
      
      public var roomType:int;
      
      private var _titleSelectStatus:Object;
      
      private var _oldSelected:int;
      
      public function InviteFrame()
      {
         super();
         this.configUi();
         this.addEvent();
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            this.refleshList(Brotherhood);
         }
         else
         {
            this.refleshList(Friend);
         }
      }
      
      private function configUi() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._listBack = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame.bg");
         addToContent(this._listBack);
         this._refreshButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.RefreshButton");
         this._refreshButton.text = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
         addToContent(this._refreshButton);
         this._fastInviteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.FastInviteButton");
         this._fastInviteBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.fastInvite");
         addToContent(this._fastInviteBtn);
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.hbox");
         addToContent(this._hbox);
         this._btnGroup = new SelectedButtonGroup();
         this._recentContactBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.recentButton");
         this._recentContactBtn.text = LanguageMgr.GetTranslation("ddt.inviteFrame.recent");
         this._btnGroup.addSelectItem(this._recentContactBtn);
         this._brotherhoodButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.consortiaButton");
         this._brotherhoodButton.text = LanguageMgr.GetTranslation("ddt.inviteFrame.consortia");
         this._btnGroup.addSelectItem(this._brotherhoodButton);
         this._frientButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.friendButton");
         this._frientButton.text = LanguageMgr.GetTranslation("ddt.inviteFrame.friend");
         this._btnGroup.addSelectItem(this._frientButton);
         this._hallButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.HallButton");
         this._hallButton.text = LanguageMgr.GetTranslation("ddt.inviteFrame.hall");
         this._btnGroup.addSelectItem(this._hallButton);
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._hbox.addChild(this._recentContactBtn);
            this._hbox.addChild(this._frientButton);
            this._hbox.addChild(this._hallButton);
            this._hbox.addChild(this._brotherhoodButton);
         }
         else
         {
            this._hbox.addChild(this._recentContactBtn);
            this._hbox.addChild(this._brotherhoodButton);
            this._hbox.addChild(this._frientButton);
            this._hbox.addChild(this._hallButton);
         }
         this._list = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.List");
         addToContent(this._list);
         IMController.Instance.loadRecentContacts();
      }
      
      private function addEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._refreshButton.addEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         if(Boolean(this._fastInviteBtn))
         {
            this._fastInviteBtn.addEventListener(MouseEvent.CLICK,this.__onFastInviteClick);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      protected function __onFastInviteClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.game.room.fastInvite.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmFastInvite);
      }
      
      private function __confirmFastInvite(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmFastInvite);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            ChatManager.Instance.sendBugle("",EquipType.T_SBUGLE,true);
         }
      }
      
      private function __btnChangeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._hbox.arrange();
         if(this._changeComplete)
         {
            this._changeComplete = false;
            switch(this._btnGroup.selectIndex)
            {
               case RECENT:
                  this.refleshList(RECENT);
                  break;
               case Brotherhood:
                  if(PlayerManager.Instance.Self.ConsortiaID != 0)
                  {
                     this.refleshList(Brotherhood);
                  }
                  else
                  {
                     this._changeComplete = true;
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.consortiaRateI"));
                     this._btnGroup.selectIndex = this._oldSelected;
                  }
                  break;
               case Friend:
                  this.clearList();
                  this.refleshList(Friend);
                  break;
               case Hall:
                  this.refleshList(Hall);
            }
            this._oldSelected = this._btnGroup.selectIndex;
         }
      }
      
      private function __response(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.__onCloseClick(null);
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__onRefreshClick(null);
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
         if(Boolean(this._refreshButton))
         {
            this._refreshButton.removeEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         }
         if(Boolean(this._fastInviteBtn))
         {
            this._fastInviteBtn.removeEventListener(MouseEvent.CLICK,this.__onFastInviteClick);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         if(Boolean(this._list) && Boolean(this._list.list))
         {
            this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
      }
      
      private function __onRefreshClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._changeComplete)
         {
            if(this._btnGroup.selectIndex == Hall)
            {
               this.refleshList(Hall,++this._refleshCount);
            }
            else
            {
               this.clearList();
               this.refleshList(this._btnGroup.selectIndex);
            }
         }
      }
      
      private function __onGetList(evt:CrazyTankSocketEvent) : void
      {
         var info:PlayerInfo = null;
         var pkg:PackageIn = evt.pkg;
         var list:Array = [];
         var _length:int = pkg.readByte();
         for(var i:uint = 0; i < _length; i++)
         {
            info = new PlayerInfo();
            info.ID = pkg.readInt();
            info.NickName = pkg.readUTF();
            info.typeVIP = pkg.readByte();
            info.VIPLevel = pkg.readInt();
            info.Sex = pkg.readBoolean();
            info.Grade = pkg.readInt();
            info.ConsortiaID = pkg.readInt();
            info.ConsortiaName = pkg.readUTF();
            info.Offer = pkg.readInt();
            info.WinCount = pkg.readInt();
            info.TotalCount = pkg.readInt();
            info.EscapeCount = pkg.readInt();
            info.Repute = pkg.readInt();
            info.FightPower = pkg.readInt();
            info.isOld = pkg.readBoolean();
            list.push(info);
         }
         this.updateList(Hall,list);
      }
      
      override protected function __onCloseClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         var _playerArray:Array = null;
         var titleType:int = 0;
         var _titleList:Array = null;
         var tmpStr:String = null;
         var temp:int = 0;
         var n:int = 0;
         var tempArray:Array = null;
         var tempArr:Array = null;
         var tempArr1:Array = null;
         var i:int = 0;
         var j:int = 0;
         var info:FriendListPlayer = null;
         if((event.cellValue as InvitePlayerInfo).type == 0)
         {
            SoundManager.instance.play("008");
            _playerArray = [];
            titleType = (event.cellValue as InvitePlayerInfo).titleType;
            _titleList = PlayerManager.Instance.friendAndCustomTitle;
            if(this._titleSelectStatus[titleType] == true)
            {
               _playerArray = _titleList;
            }
            else
            {
               temp = 0;
               for(n = 0; n < _titleList.length; n++)
               {
                  _playerArray.push(_titleList[n]);
                  if(titleType == _titleList[n].titleType)
                  {
                     temp = n;
                     break;
                  }
               }
               tempArray = PlayerManager.Instance.getOnlineFriendForCustom(titleType);
               tempArr = [];
               tempArr1 = [];
               for(i = 0; i < tempArray.length; i++)
               {
                  info = tempArray[i] as FriendListPlayer;
                  if(info.IsVIP)
                  {
                     tempArr.push(info);
                  }
                  else
                  {
                     tempArr1.push(info);
                  }
               }
               tempArr = this.sort(tempArr);
               tempArr1 = this.sort(tempArr1);
               tempArray = tempArr.concat(tempArr1);
               tempArray = IMController.Instance.sortAcademyPlayer(tempArray);
               _playerArray = _playerArray.concat(tempArray);
               for(j = temp + 1; j < _titleList.length; j++)
               {
                  _playerArray.push(_titleList[j]);
               }
            }
            for(tmpStr in this._titleSelectStatus)
            {
               if(int(tmpStr) == titleType)
               {
                  this._titleSelectStatus[tmpStr] = !this._titleSelectStatus[tmpStr];
               }
               else
               {
                  this._titleSelectStatus[tmpStr] = false;
               }
            }
            this.updateList(Friend,_playerArray);
         }
      }
      
      private function sort(arr:Array) : Array
      {
         return arr.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
      }
      
      private function updateList(type:int, list:Array) : void
      {
         var invitePlayer:InvitePlayerInfo = null;
         var cpInfo:BasePlayer = null;
         var friendList:Array = null;
         var intPoint:IntPoint = null;
         this._changeComplete = true;
         var tmpPosY:int = this._list.list.viewPosition.y;
         this.clearList();
         this._invitePlayerInfos = [];
         for(var i:int = 0; i < list.length; i++)
         {
            cpInfo = list[i] as BasePlayer;
            if(cpInfo.ID != PlayerManager.Instance.Self.ID)
            {
               invitePlayer = new InvitePlayerInfo();
               invitePlayer.NickName = cpInfo.NickName;
               invitePlayer.typeVIP = cpInfo.typeVIP;
               invitePlayer.Sex = cpInfo.Sex;
               invitePlayer.Grade = cpInfo.Grade;
               invitePlayer.Repute = cpInfo.Repute;
               invitePlayer.WinCount = cpInfo.WinCount;
               invitePlayer.TotalCount = cpInfo.TotalCount;
               invitePlayer.FightPower = cpInfo.FightPower;
               invitePlayer.ID = cpInfo.ID;
               invitePlayer.Offer = cpInfo.Offer;
               invitePlayer.isOld = cpInfo.isOld;
               if(type == Friend)
               {
                  invitePlayer.titleType = (cpInfo as FriendListPlayer).titleType;
                  invitePlayer.type = (cpInfo as FriendListPlayer).type;
                  invitePlayer.titleText = (cpInfo as FriendListPlayer).titleText;
                  invitePlayer.titleNumText = (cpInfo as FriendListPlayer).titleNumText;
                  if(this._titleSelectStatus.hasOwnProperty(invitePlayer.titleType.toString()))
                  {
                     invitePlayer.titleIsSelected = this._titleSelectStatus[invitePlayer.titleType.toString()];
                  }
                  else
                  {
                     invitePlayer.titleIsSelected = false;
                  }
               }
               if(type != Friend)
               {
                  this._list.vectorListModel.insertElementAt(invitePlayer,this.getInsertIndex(cpInfo));
               }
               this._invitePlayerInfos.push(invitePlayer);
            }
         }
         if(type == Friend)
         {
            friendList = this._invitePlayerInfos;
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(friendList);
         }
         this._list.list.updateListView();
         if(type == Friend)
         {
            intPoint = new IntPoint(0,tmpPosY);
            this._list.list.viewPosition = intPoint;
         }
      }
      
      private function clearList() : void
      {
         this._list.vectorListModel.clear();
      }
      
      private function getInsertIndex(info:BasePlayer) : int
      {
         var tempInfo:PlayerInfo = null;
         var tempArray:Array = this._list.vectorListModel.elements;
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
            }
         }
         return 0;
      }
      
      private function __onResError(evt:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
      }
      
      private function __onResComplete(evt:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         if(evt.module == UIModuleTypes.DDTINVITE && this._visible)
         {
            this._resState = "complete";
            this.configUi();
            this.addEvent();
            if(PlayerManager.Instance.Self.ConsortiaID != 0)
            {
               this.refleshList(Brotherhood);
            }
            else
            {
               this.refleshList(Friend);
            }
         }
      }
      
      private function refleshList(type:int, count:int = 0) : void
      {
         var titleList:Array = null;
         var tmpFInfo:FriendListPlayer = null;
         this._btnGroup.selectIndex = type;
         this._oldSelected = type;
         if(type == Hall)
         {
            GameInSocketOut.sendGetScenePlayer(count);
         }
         else if(type == Friend)
         {
            titleList = PlayerManager.Instance.friendAndCustomTitle;
            this._titleSelectStatus = {};
            for each(tmpFInfo in titleList)
            {
               this._titleSelectStatus[tmpFInfo.titleType] = false;
            }
            this.updateList(Friend,titleList);
         }
         else if(type == Brotherhood)
         {
            this.updateList(Brotherhood,ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
         }
         else if(type == RECENT)
         {
            this.updateList(RECENT,this.rerecentContactList);
         }
      }
      
      private function get rerecentContactList() : Array
      {
         var tempInfo:FriendListPlayer = null;
         var i:int = 0;
         var state:PlayerState = null;
         var tempDictionaryData:DictionaryData = PlayerManager.Instance.recentContacts;
         var recentContactsList:Array = IMController.Instance.recentContactsList;
         var tempArray:Array = [];
         if(Boolean(recentContactsList))
         {
            for(i = 0; i < recentContactsList.length; i++)
            {
               if(recentContactsList[i] != 0)
               {
                  tempInfo = tempDictionaryData[recentContactsList[i]];
                  if(Boolean(tempInfo) && tempArray.indexOf(tempInfo) == -1)
                  {
                     if(Boolean(PlayerManager.Instance.findPlayer(tempInfo.ID,PlayerManager.Instance.Self.ZoneID)))
                     {
                        state = new PlayerState(PlayerManager.Instance.findPlayer(tempInfo.ID,PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                        tempInfo.playerState = state;
                     }
                     if(tempInfo.playerState.StateID != PlayerState.OFFLINE)
                     {
                        tempArray.push(tempInfo);
                     }
                  }
               }
            }
         }
         return tempArray;
      }
      
      override public function dispose() : void
      {
         this._visible = false;
         if(this._resState == "loading")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         }
         else
         {
            this.removeEvent();
            if(Boolean(this._list))
            {
               ObjectUtils.disposeObject(this._list);
               this._list = null;
            }
            if(Boolean(this._hbox))
            {
               ObjectUtils.disposeObject(this._hbox);
               this._hbox = null;
            }
            if(Boolean(this._brotherhoodButton))
            {
               ObjectUtils.disposeObject(this._brotherhoodButton);
               this._brotherhoodButton = null;
            }
            if(Boolean(this._frientButton))
            {
               ObjectUtils.disposeObject(this._frientButton);
               this._frientButton = null;
            }
            if(Boolean(this._hallButton))
            {
               ObjectUtils.disposeObject(this._hallButton);
               this._hallButton = null;
            }
            if(Boolean(this._fastInviteBtn))
            {
               ObjectUtils.disposeObject(this._fastInviteBtn);
               this._fastInviteBtn = null;
            }
            if(Boolean(this._refreshButton))
            {
               ObjectUtils.disposeObject(this._refreshButton);
               this._refreshButton = null;
            }
            if(Boolean(this._listBack))
            {
               ObjectUtils.disposeObject(this._listBack);
               this._listBack = null;
            }
            if(Boolean(this._recentContactBtn))
            {
               ObjectUtils.disposeObject(this._recentContactBtn);
               this._recentContactBtn = null;
            }
         }
         super.dispose();
      }
   }
}

