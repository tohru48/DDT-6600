package im
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.CMFriendInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.PlayerTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class IMLookupView extends Sprite implements Disposeable
   {
      
      public const MAX_ITEM_NUM:int = 8;
      
      public const ITEM_MAX_HEIGHT:int = 33;
      
      public const ITEM_MIN_HEIGHT:int = 28;
      
      private var _bg:Scale9CornerImage;
      
      private var _cleanUpBtn:BaseButton;
      
      private var _inputText:TextInput;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _currentList:Array;
      
      private var _itemArray:Array;
      
      private var _listType:int;
      
      private var _currentItemInfo:*;
      
      private var _currentItem:IMLookupItem;
      
      private var _list:VBox;
      
      private var _NAN:FilterFrameText;
      
      private var _lookBtn:Bitmap;
      
      public function IMLookupView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("im.Browse.baiduBG");
         addChild(this._bg);
         this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.searchIcon");
         PositionUtils.setPos(this._lookBtn,"ListItemView.lookBtn");
         addChild(this._lookBtn);
         this._cleanUpBtn = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.cleanUpBtn");
         this._cleanUpBtn.visible = false;
         addChild(this._cleanUpBtn);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.textinput");
         addChild(this._inputText);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.lookUpBG");
         this._bg2.visible = false;
         addChild(this._bg2);
         this._list = ComponentFactory.Instance.creat("IM.IMLookup.lookupList");
         addChild(this._list);
         this._NAN = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.IMLookupItemName");
         this._NAN.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
         this._NAN.visible = false;
         this._NAN.x = this._bg2.x + 10;
         this._NAN.y = this._bg2.y + 7;
         addChild(this._NAN);
      }
      
      private function initEvent() : void
      {
         this._inputText.addEventListener(Event.CHANGE,this.__textInput);
         this._inputText.addEventListener(MouseEvent.CLICK,this.__inputClick);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__stopEvent);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         if(Boolean(PlayerManager.Instance.blackList))
         {
            PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         if(Boolean(PlayerManager.Instance.recentContacts))
         {
            PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         this._cleanUpBtn.addEventListener(MouseEvent.CLICK,this.__cleanUpClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function __inputClick(event:MouseEvent) : void
      {
         this.strTest();
      }
      
      private function __stageClick(event:MouseEvent) : void
      {
         if(DisplayUtils.isTargetOrContain(event.target as DisplayObject,this._inputText) || event.target is ScaleFrameImage || event.target is PlayerTip || event.target is SimpleBitmapButton)
         {
            return;
         }
         this.hide();
      }
      
      private function hide() : void
      {
         this._bg2.visible = false;
         this._NAN.visible = false;
         this._cleanUpBtn.visible = false;
         this._list.visible = false;
         this._lookBtn.visible = true;
      }
      
      private function __stopEvent(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         event.stopPropagation();
      }
      
      private function __cleanUpClick(event:MouseEvent) : void
      {
         this._inputText.text = "";
         this.strTest();
         SoundManager.instance.play("008");
      }
      
      private function __updateList(event:Event) : void
      {
         if(Boolean(this._list) && this._list.visible)
         {
            this.strTest();
         }
      }
      
      private function __textInput(event:Event) : void
      {
         this.strTest();
      }
      
      private function strTest() : void
      {
         this.disposeItems();
         this.updateList();
         if(this._listType == IMView.FRIEND_LIST)
         {
            this.friendStrTest();
         }
         else if(this._listType == IMView.CMFRIEND_LIST)
         {
            this.CMFriendStrTest();
         }
         this.setFlexBg();
      }
      
      private function friendStrTest() : void
      {
         var name:String = null;
         var temp:String = null;
         var item:IMLookupItem = null;
         var itemI:IMLookupItem = null;
         for(var i:int = 0; i < this._currentList.length; i++)
         {
            if(this._itemArray.length >= this.MAX_ITEM_NUM)
            {
               this.setFlexBg();
               return;
            }
            name = "";
            temp = "";
            if(this._currentList[i] is PlayerInfo)
            {
               name = (this._currentList[i] as PlayerInfo).NickName;
               temp = this._inputText.text;
            }
            else if(this._currentList[i] is ConsortiaPlayerInfo)
            {
               name = (this._currentList[i] as ConsortiaPlayerInfo).NickName;
               temp = this._inputText.text;
            }
            if(temp == "")
            {
               this.setFlexBg();
               return;
            }
            if(!name)
            {
               this.setFlexBg();
               return;
            }
            if(name.indexOf(this._inputText.text) != -1)
            {
               if(this._currentList[i] is PlayerInfo)
               {
                  item = new IMLookupItem(this._currentList[i] as PlayerInfo);
                  item.addEventListener(MouseEvent.CLICK,this.__clickHandler);
                  this._list.addChild(item);
                  this._itemArray.push(item);
               }
               else if(this._currentList[i] is ConsortiaPlayerInfo)
               {
                  if(this.testAlikeName((this._currentList[i] as ConsortiaPlayerInfo).NickName))
                  {
                     itemI = new IMLookupItem(this._currentList[i] as ConsortiaPlayerInfo);
                     itemI.addEventListener(MouseEvent.CLICK,this.__clickHandler);
                     this._list.addChild(itemI);
                     this._itemArray.push(itemI);
                  }
               }
            }
         }
      }
      
      private function __doubleClickHandler(event:InteractiveEvent) : void
      {
         ChatManager.Instance.privateChatTo((event.currentTarget as IMLookupItem).info.NickName,(event.currentTarget as IMLookupItem).info.ID);
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         this._currentItemInfo = (event.currentTarget as IMLookupItem).info;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function CMFriendStrTest() : void
      {
         var name:String = null;
         var tempII:String = null;
         var item:IMLookupItem = null;
         for(var j:int = 0; j < this._currentList.length; j++)
         {
            if(this._itemArray.length >= this.MAX_ITEM_NUM)
            {
               this.setFlexBg();
               return;
            }
            name = (this._currentList[j] as CMFriendInfo).NickName;
            if(name == "")
            {
               name = (this._currentList[j] as CMFriendInfo).OtherName;
            }
            tempII = this._inputText.text;
            if(tempII == "")
            {
               this.setFlexBg();
               return;
            }
            if(name.indexOf(this._inputText.text) != -1)
            {
               item = new IMLookupItem(this._currentList[j] as CMFriendInfo);
               item.addEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._list.addChild(item);
               this._itemArray.push(item);
            }
         }
      }
      
      private function setFlexBg() : void
      {
         if(this._inputText.text == "")
         {
            this._bg2.visible = false;
            this._NAN.visible = false;
            this._cleanUpBtn.visible = false;
            this._lookBtn.visible = true;
         }
         else if(this._inputText.text != "" && this._itemArray.length == 0)
         {
            this._bg2.visible = true;
            this._bg2.height = this.ITEM_MAX_HEIGHT;
            this._NAN.visible = true;
            this._cleanUpBtn.visible = true;
            this._list.visible = true;
            this._lookBtn.visible = false;
         }
         else
         {
            this._NAN.visible = false;
            this._cleanUpBtn.visible = true;
            this._bg2.visible = true;
            this._list.visible = true;
            this._lookBtn.visible = false;
            if(Boolean(this._itemArray))
            {
               this._bg2.height = this._itemArray.length * this.ITEM_MIN_HEIGHT == 0 ? this.ITEM_MAX_HEIGHT : this._itemArray.length * this.ITEM_MIN_HEIGHT;
            }
         }
      }
      
      private function disposeItems() : void
      {
         var i:int = 0;
         if(Boolean(this._itemArray))
         {
            for(i = 0; i < this._itemArray.length; i++)
            {
               (this._itemArray[i] as IMLookupItem).removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               (this._itemArray[i] as IMLookupItem).dispose();
            }
         }
         this._list.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function updateList() : void
      {
         if(this._listType == 0)
         {
            this._currentList = [];
            this._currentList = PlayerManager.Instance.friendList.list;
            this._currentList = this._currentList.concat(ConsortionModelControl.Instance.model.memberList.list);
            if(Boolean(PlayerManager.Instance.blackList) && Boolean(PlayerManager.Instance.blackList.list))
            {
               this._currentList = this._currentList.concat(PlayerManager.Instance.blackList.list);
            }
            if(Boolean(PlayerManager.Instance.recentContacts) && Boolean(PlayerManager.Instance.recentContacts.list))
            {
               this._currentList = this._currentList.concat(IMController.Instance.getRecentContactsStranger());
            }
         }
         else if(this._listType == 2)
         {
            this._currentList = [];
            if(!PlayerManager.Instance.CMFriendList)
            {
               return;
            }
            this._currentList = PlayerManager.Instance.CMFriendList.list;
         }
      }
      
      private function testAlikeName(name:String) : Boolean
      {
         var temList:Array = [];
         temList = PlayerManager.Instance.friendList.list;
         temList = temList.concat(PlayerManager.Instance.blackList.list);
         for(var i:int = 0; i < temList.length; i++)
         {
            if((temList[i] as FriendListPlayer).NickName == name)
            {
               return false;
            }
         }
         return true;
      }
      
      public function set listType(value:int) : void
      {
         this._listType = value;
         this.updateList();
      }
      
      public function get currentItemInfo() : *
      {
         return this._currentItemInfo;
      }
      
      public function dispose() : void
      {
         this._inputText.removeEventListener(Event.CHANGE,this.__textInput);
         this._inputText.removeEventListener(MouseEvent.CLICK,this.__inputClick);
         this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__stopEvent);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__updateList);
         if(Boolean(PlayerManager.Instance.blackList))
         {
            PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         if(Boolean(PlayerManager.Instance.recentContacts))
         {
            PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         this._cleanUpBtn.removeEventListener(MouseEvent.CLICK,this.__cleanUpClick);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
         this.disposeItems();
         if(Boolean(this._bg2))
         {
            this._bg2.dispose();
            this._bg2 = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._cleanUpBtn))
         {
            this._cleanUpBtn.dispose();
            this._cleanUpBtn = null;
         }
         if(Boolean(this._inputText))
         {
            this._inputText.dispose();
            this._inputText = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
            this._currentItem = null;
         }
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._NAN))
         {
            ObjectUtils.disposeObject(this._NAN);
            this._NAN = null;
         }
      }
   }
}

