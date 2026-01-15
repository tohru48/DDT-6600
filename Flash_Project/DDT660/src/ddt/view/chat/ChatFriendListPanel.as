package ddt.view.chat
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChatFriendListPanel extends ChatBasePanel implements Disposeable
   {
      
      public static const FRIEND:uint = 0;
      
      public static const CONSORTIA:uint = 1;
      
      private var _bg:ScaleBitmapImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _btnConsortia:SelectedTextButton;
      
      private var _btnFriend:SelectedTextButton;
      
      private var _func:Function;
      
      private var _playerList:ListPanel;
      
      private var _showOffLineList:Boolean;
      
      private var _currentType:uint;
      
      public function ChatFriendListPanel()
      {
         super();
      }
      
      public function setup(fun:Function, showOffLineList:Boolean = true) : void
      {
         this._func = fun;
         this._showOffLineList = showOffLineList;
         this.__onFriendListComplete();
      }
      
      public function set currentType(value:int) : void
      {
         this._currentType = value;
         this._btnGroup.selectIndex = this._currentType;
         this.updateBtns();
      }
      
      private function updateBtns() : void
      {
         this._btnFriend.buttonMode = this._btnGroup.selectIndex == CONSORTIA;
         this._btnConsortia.buttonMode = !this._btnFriend.buttonMode;
      }
      
      public function refreshAllList() : void
      {
         this._btnGroup.selectIndex = FRIEND;
         this.__onFriendListComplete();
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
      }
      
      override protected function __hideThis(event:MouseEvent) : void
      {
         if(!(event.target is ScaleBitmapImage) && !(event.target is BaseButton))
         {
            SoundManager.instance.play("008");
            setVisible = false;
            if(Boolean(parent))
            {
               parent.removeChild(this);
            }
         }
      }
      
      private function __btnsClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         e.stopImmediatePropagation();
         if(e.currentTarget == this._btnFriend)
         {
            this.__onFriendListComplete();
            this._currentType = FRIEND;
         }
         else
         {
            if(this._showOffLineList)
            {
               this.setList(ConsortionModelControl.Instance.model.memberList.list);
            }
            else
            {
               this.setList(ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
            }
            this._currentType = CONSORTIA;
         }
      }
      
      private function _scrollClick(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
      }
      
      private function __onFriendListComplete(e:Event = null) : void
      {
         if(this._showOffLineList)
         {
            this.setList(PlayerManager.Instance.friendList.list);
         }
         else
         {
            this.setList(PlayerManager.Instance.onlineFriendList);
         }
      }
      
      private function __updateConsortiaList(e:Event) : void
      {
         this.setList(ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
      }
      
      private function __updateFriendList(e:Event) : void
      {
         this.setList(PlayerManager.Instance.onlineFriendList);
      }
      
      override protected function init() : void
      {
         super.init();
         this._btnGroup = new SelectedButtonGroup();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListBg");
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("chat.FriendList");
         this._btnFriend = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListFriendBtn");
         this._btnConsortia = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListConsortiaBtn");
         this._btnFriend.text = LanguageMgr.GetTranslation("chat.ChatFriendList.FriendBtnTxt");
         this._btnConsortia.text = LanguageMgr.GetTranslation("chat.ChatFriendList.ConsortiaBtnTxt");
         this._btnGroup.addSelectItem(this._btnFriend);
         this._btnGroup.addSelectItem(this._btnConsortia);
         this._btnGroup.selectIndex = FRIEND;
         this._btnConsortia.displacement = false;
         this._btnFriend.displacement = false;
         addChild(this._bg);
         addChild(this._btnFriend);
         addChild(this._btnConsortia);
         addChild(this._playerList);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._btnFriend.addEventListener(MouseEvent.CLICK,this.__btnsClick);
         this._btnConsortia.addEventListener(MouseEvent.CLICK,this.__btnsClick);
         this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__onFriendListComplete);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._btnFriend.removeEventListener(MouseEvent.CLICK,this.__btnsClick);
         this._btnConsortia.removeEventListener(MouseEvent.CLICK,this.__btnsClick);
         this._playerList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         PlayerManager.Instance.removeEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__onFriendListComplete);
      }
      
      private function setList(list:Array) : void
      {
         this._playerList.vectorListModel.clear();
         this._playerList.vectorListModel.appendAll(list);
         this._playerList.list.updateListView();
         this.updateBtns();
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         var player:BasePlayer = event.cellValue as BasePlayer;
         this._func(player.NickName,player.ID);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._func = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._btnConsortia))
         {
            ObjectUtils.disposeObject(this._btnConsortia);
         }
         this._btnConsortia = null;
         if(Boolean(this._btnFriend))
         {
            ObjectUtils.disposeObject(this._btnFriend);
         }
         this._btnFriend = null;
         if(Boolean(this._playerList))
         {
            ObjectUtils.disposeObject(this._playerList);
         }
         this._playerList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

