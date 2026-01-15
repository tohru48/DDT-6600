package im
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.MD5;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import im.info.CustomInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class IMListView extends Sprite implements Disposeable
   {
      
      private var _listPanel:ListPanel;
      
      private var _playerArray:Array;
      
      private var _titleList:Vector.<FriendListPlayer>;
      
      private var _currentItemInfo:FriendListPlayer;
      
      private var _currentTitleInfo:FriendListPlayer;
      
      private var _pos:int;
      
      private var _timer:Timer;
      
      private var _responseR:Sprite;
      
      private var _currentItem:IMListItemView;
      
      public function IMListView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.initTitle();
         this._timer = new Timer(200);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("IM.IMlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._listPanel);
         this._listPanel.list.updateListView();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._currentTitleInfo = this._titleList[1];
         this._responseR = new Sprite();
         this._responseR.graphics.beginFill(16777215,0);
         this._responseR.graphics.drawRect(0,0,this._listPanel.width,this._listPanel.height);
         this._responseR.graphics.endFill();
         addChild(this._responseR);
         this._responseR.mouseChildren = false;
         this._responseR.mouseEnabled = false;
         this.updateList();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__removeRecentContact);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,this.__addItem);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.ADD,this.__addBlackItem);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN,this.__listItemDownHandler);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP,this.__listItemUpHandler);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT,this.__listItemOutHandler);
         this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_TOP,this.__topRangeHandler);
         this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_BUTTOM,this.__buttomRangeHandler);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         IMController.Instance.addEventListener(IMEvent.ADD_NEW_GROUP,this.__addNewGroup);
         IMController.Instance.addEventListener(IMEvent.UPDATE_GROUP,this.__updaetGroup);
         IMController.Instance.addEventListener(IMEvent.DELETE_GROUP,this.__deleteGroup);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_CALLAPPLY,this.__onRegressCallApply);
      }
      
      protected function __deleteGroup(event:Event) : void
      {
         for(var temp1:int = 0; temp1 < this._titleList.length; temp1++)
         {
            if(this._titleList[temp1].titleType == IMController.Instance.deleteCustomID)
            {
               this._titleList.splice(temp1,1);
               break;
            }
         }
         this._currentTitleInfo.titleIsSelected = false;
         this.updateTitle();
         this.updateList();
      }
      
      protected function __updaetGroup(event:Event) : void
      {
         for(var temp3:int = 0; temp3 < this._titleList.length; temp3++)
         {
            if(this._titleList[temp3].titleType == IMController.Instance.customInfo.ID)
            {
               this._titleList[temp3].titleText = IMController.Instance.customInfo.Name;
               break;
            }
         }
         this._currentTitleInfo.titleIsSelected = false;
         this.updateTitle();
         this.updateList();
      }
      
      protected function __addNewGroup(event:Event) : void
      {
         var i:int = 0;
         var title:FriendListPlayer = new FriendListPlayer();
         title.type = 0;
         title.titleType = IMController.Instance.customInfo.ID;
         title.titleIsSelected = false;
         title.titleText = IMController.Instance.customInfo.Name;
         if(this._titleList.length == 4)
         {
            this._titleList.splice(2,0,title);
            PlayerManager.Instance.customList.splice(1,0,IMController.Instance.customInfo);
         }
         else
         {
            for(i = 2; i < this._titleList.length - 2; i++)
            {
               if(IMController.Instance.customInfo.ID < this._titleList[i].titleType)
               {
                  this._titleList.splice(i,0,title);
                  PlayerManager.Instance.customList.splice(i - 1,0,IMController.Instance.customInfo);
                  break;
               }
               if(i == this._titleList.length - 3)
               {
                  this._titleList.splice(i + 1,0,title);
                  PlayerManager.Instance.customList.splice(i,0,IMController.Instance.customInfo);
                  break;
               }
            }
         }
         this.updateTitle();
         this.updateList();
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.recentContacts.removeEventListener(DictionaryEvent.REMOVE,this.__removeRecentContact);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.ADD,this.__addItem);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.ADD,this.__addBlackItem);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN,this.__listItemDownHandler);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP,this.__listItemUpHandler);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT,this.__listItemOutHandler);
         this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_TOP,this.__topRangeHandler);
         this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_BUTTOM,this.__buttomRangeHandler);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         IMController.Instance.removeEventListener(IMEvent.ADD_NEW_GROUP,this.__addNewGroup);
         IMController.Instance.removeEventListener(IMEvent.UPDATE_GROUP,this.__updaetGroup);
         IMController.Instance.removeEventListener(IMEvent.DELETE_GROUP,this.__deleteGroup);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_CALLAPPLY,this.__onRegressCallApply);
      }
      
      protected function __addToStage(event:Event) : void
      {
         var listpos:Point = null;
         listpos = this._listPanel.localToGlobal(new Point(0,0));
         this._responseR.x = listpos.x;
         this._responseR.y = listpos.y;
      }
      
      protected function __listItemOutHandler(event:ListItemEvent) : void
      {
         this._timer.stop();
      }
      
      protected function __listItemUpHandler(event:ListItemEvent) : void
      {
         this._timer.stop();
      }
      
      protected function __listItemDownHandler(event:ListItemEvent) : void
      {
         this._currentItem = event.cell as IMListItemView;
         var info:FriendListPlayer = this._currentItem.getCellValue() as FriendListPlayer;
         if(info.type == 1 && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      protected function __onRegressCallApply(event:CrazyTankSocketEvent) : void
      {
         var ur:URLRequest = null;
         var variable:URLVariables = null;
         var urlLoader:URLLoader = null;
         var pkg:PackageIn = event.pkg;
         var callID:int = pkg.readInt();
         if(callID != 1)
         {
            this._currentItem.callBackBtn.enable = false;
            this._currentItem.callBackBtn.mouseEnabled = true;
            this._currentItem.info.callBtnEnable = false;
            ur = new URLRequest(PathManager.callBackInterfacePath());
            variable = new URLVariables();
            variable["gname"] = PlayerManager.Instance.Self.NickName;
            variable["user2"] = this._currentItem.info.LoginName;
            variable["gname2"] = this._currentItem.info.NickName;
            variable["area"] = this._currentItem.info.ZoneID;
            variable["token"] = MD5.hash(PlayerManager.Instance.Self.LoginName + "d!d@t#z$h" + this._currentItem.info.LoginName);
            ur.method = URLRequestMethod.POST;
            ur.data = variable;
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE,this.__onComplete);
            urlLoader.load(ur);
         }
      }
      
      protected function __onComplete(event:Event) : void
      {
         var value:int = int(event.target.data);
         switch(value)
         {
            case 0:
               break;
            case 1:
               this._currentItem.callBackBtn.enable = false;
               this._currentItem.callBackBtn.mouseEnabled = true;
               this._currentItem.info.callBtnEnable = false;
               break;
            case 2:
            case 3:
            case 4:
         }
      }
      
      protected function __topRangeHandler(event:Event) : void
      {
         this._listPanel.setViewPosition(-1);
      }
      
      protected function __buttomRangeHandler(event:Event) : void
      {
         this._listPanel.setViewPosition(1);
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         var listpos:Point = null;
         this._timer.stop();
         listpos = this._listPanel.localToGlobal(new Point(0,0));
         this._responseR.x = listpos.x;
         this._responseR.y = listpos.y;
         DragManager.startDrag(this._currentItem,this._currentItem.getCellValue(),this.createImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,false,true,true,this._responseR,this._currentItem.height + 10);
         this.showTitle();
      }
      
      private function createImg() : DisplayObject
      {
         var img:Bitmap = new Bitmap(new BitmapData(this._currentItem.width - 6,this._currentItem.height - 6,false,0),"auto",true);
         var martix:Matrix = new Matrix(1,0,0,1,-2,-2);
         img.bitmapData.draw(this._currentItem,martix);
         return img;
      }
      
      private function initTitle() : void
      {
         var title:FriendListPlayer = null;
         this._titleList = new Vector.<FriendListPlayer>();
         var customList:Vector.<CustomInfo> = PlayerManager.Instance.customList;
         for(var i:int = 0; i < customList.length; i++)
         {
            title = new FriendListPlayer();
            title.type = 0;
            title.titleType = customList[i].ID;
            title.titleIsSelected = false;
            if(i == customList.length - 1)
            {
               title.titleNumText = "[" + "0/" + String(PlayerManager.Instance.blackList.length) + "]";
            }
            else
            {
               title.titleNumText = "[" + String(PlayerManager.Instance.getOnlineFriendForCustom(customList[i].ID).length) + "/" + String(PlayerManager.Instance.getFriendForCustom(customList[i].ID).length) + "]";
            }
            title.titleText = customList[i].Name;
            this._titleList.push(title);
         }
         var recentContactTitle:FriendListPlayer = new FriendListPlayer();
         recentContactTitle.type = 0;
         recentContactTitle.titleType = 2;
         recentContactTitle.titleIsSelected = false;
         recentContactTitle.titleNumText = "[" + String(PlayerManager.Instance.onlineRecentContactList.length) + "/" + String(PlayerManager.Instance.recentContacts.length) + "]";
         recentContactTitle.titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.recentContact");
         this._titleList.unshift(recentContactTitle);
         var customTitle:FriendListPlayer = new FriendListPlayer();
         customTitle.type = 0;
         customTitle.titleType = 3;
         customTitle.titleText = LanguageMgr.GetTranslation("tank.game.IM.custom");
         this._titleList.push(customTitle);
         this._titleList[1].titleIsSelected = true;
      }
      
      private function __addBlackItem(event:DictionaryEvent) : void
      {
         if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected == true && this._listPanel && Boolean(this._listPanel.vectorListModel))
         {
            this._listPanel.vectorListModel.append(event.data,this.getInsertIndex(event.data as FriendListPlayer));
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
         else
         {
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function __updateItem(event:DictionaryEvent) : void
      {
         this.updateTitle();
         this.updateList();
      }
      
      private function __addItem(event:DictionaryEvent) : void
      {
         if((this._currentTitleInfo.titleType == 0 || this._currentTitleInfo.titleType >= 10) && this._currentTitleInfo.titleIsSelected == true && this._listPanel && Boolean(this._listPanel.vectorListModel))
         {
            this._listPanel.vectorListModel.append(event.data,this.getInsertIndex(event.data as FriendListPlayer));
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
         else
         {
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function __removeItem(event:DictionaryEvent) : void
      {
         if(Boolean(this._listPanel) && Boolean(this._listPanel.vectorListModel))
         {
            this._listPanel.vectorListModel.remove(event.data);
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function getInsertIndex(info:FriendListPlayer) : int
      {
         var tempIndex:int = 0;
         var tempInfo:FriendListPlayer = null;
         var length:int = 0;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var tempArray:Array = this._listPanel.vectorListModel.elements;
         for(var n:int = 0; n < this._titleList.length; n++)
         {
            if(this._titleList[n].titleIsSelected)
            {
               tempIndex = n + 1;
            }
         }
         if(tempArray.length == this._titleList.length)
         {
            return tempIndex;
         }
         if(this._currentTitleInfo.titleType != 1 && this._currentTitleInfo.titleIsSelected)
         {
            length = 0;
            if(info.playerState.StateID != 0)
            {
               length = PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + tempIndex - 1;
               if(length != 0)
               {
                  for(i = tempIndex; i < length; i++)
                  {
                     tempInfo = tempArray[i] as FriendListPlayer;
                     if(info.IsVIP && tempInfo.IsVIP && info.Grade < tempInfo.Grade)
                     {
                        tempIndex++;
                     }
                     if(!info.IsVIP && tempInfo.IsVIP)
                     {
                        tempIndex++;
                     }
                     if(!info.IsVIP && !tempInfo.IsVIP && info.Grade < tempInfo.Grade)
                     {
                        tempIndex++;
                     }
                  }
               }
               return tempIndex;
            }
            tempIndex = PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + tempIndex;
            length = PlayerManager.Instance.getOfflineFriendForCustom(this._currentTitleInfo.titleType).length + tempIndex - 1;
            if(length != 0)
            {
               for(j = tempIndex; j < length; j++)
               {
                  tempInfo = tempArray[j] as FriendListPlayer;
                  if(info.Grade > tempInfo.Grade)
                  {
                     break;
                  }
                  tempIndex++;
               }
            }
            return tempIndex;
         }
         length = PlayerManager.Instance.blackList.length + tempIndex - 1;
         if(length != 0)
         {
            for(k = tempIndex; k < length; k++)
            {
               tempInfo = tempArray[k] as FriendListPlayer;
               if(info.Grade > tempInfo.Grade)
               {
                  break;
               }
               tempIndex++;
            }
         }
         return tempIndex;
      }
      
      private function __removeRecentContact(event:DictionaryEvent) : void
      {
         this.updateTitle();
         this.updateList();
      }
      
      private function updateTitle() : void
      {
         var i:int = 0;
         var elememt:int = 0;
         var deno:int = 0;
         if(Boolean(PlayerManager.Instance.friendList))
         {
            for(i = 1; i < this._titleList.length - 2; i++)
            {
               elememt = int(PlayerManager.Instance.getOnlineFriendForCustom(this._titleList[i].titleType).length);
               deno = PlayerManager.Instance.getFriendForCustom(this._titleList[i].titleType).length;
               this._titleList[i].titleNumText = "[" + String(elememt) + "/" + String(deno) + "]";
            }
         }
         if(Boolean(PlayerManager.Instance.blackList))
         {
            this._titleList[this._titleList.length - 2].titleNumText = "[" + "0/" + String(PlayerManager.Instance.blackList.length) + "]";
         }
         if(Boolean(PlayerManager.Instance.recentContacts))
         {
            this._titleList[0].titleNumText = "[" + String(PlayerManager.Instance.onlineRecentContactList.length) + "/" + String(PlayerManager.Instance.recentContacts.length) + "]";
         }
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         var i:int = 0;
         if((event.cellValue as FriendListPlayer).type == 1)
         {
            if(!this._currentItemInfo)
            {
               this._currentItemInfo = event.cellValue as FriendListPlayer;
               this._currentItemInfo.titleIsSelected = true;
            }
            if(this._currentItemInfo != event.cellValue as FriendListPlayer)
            {
               this._currentItemInfo.titleIsSelected = false;
               this._currentItemInfo = event.cellValue as FriendListPlayer;
               this._currentItemInfo.titleIsSelected = true;
            }
         }
         else
         {
            if(!this._currentTitleInfo)
            {
               this._currentTitleInfo = event.cellValue as FriendListPlayer;
               this._currentTitleInfo.titleIsSelected = true;
            }
            if(this._currentTitleInfo != event.cellValue as FriendListPlayer)
            {
               this._currentTitleInfo.titleIsSelected = false;
               this._currentTitleInfo = event.cellValue as FriendListPlayer;
               this._currentTitleInfo.titleIsSelected = true;
            }
            else
            {
               this._currentTitleInfo.titleIsSelected = !this._currentTitleInfo.titleIsSelected;
            }
            for(i = 0; i < this._titleList.length; i++)
            {
               if(this._titleList[i] != this._currentTitleInfo)
               {
                  this._titleList[i].titleIsSelected = false;
               }
            }
            this.updateList();
            SoundManager.instance.play("008");
         }
         this._listPanel.list.updateListView();
      }
      
      private function updateList() : void
      {
         this._pos = this._listPanel.list.viewPosition.y;
         IMController.Instance.titleType = this._currentTitleInfo.titleType;
         if(this._currentTitleInfo.titleType != 1 && this._currentTitleInfo.titleType != 2 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateFriendList(this._currentTitleInfo.titleType);
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateBlackList();
         }
         else if(this._currentTitleInfo.titleType == 2 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateRecentContactList();
         }
         else if(!this._currentTitleInfo.titleIsSelected)
         {
            this.showTitle();
         }
         this.updateTitle();
         this._listPanel.list.updateListView();
         var intPoint:IntPoint = new IntPoint(0,this._pos);
         this._listPanel.list.viewPosition = intPoint;
      }
      
      private function showTitle() : void
      {
         this._playerArray = [];
         for(var i:int = 0; i < this._titleList.length; i++)
         {
            this._playerArray.push(this._titleList[i]);
            this._titleList[i].titleIsSelected = false;
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateFriendList(relation:int = 0) : void
      {
         var info:FriendListPlayer = null;
         this._playerArray = [];
         var temp:int = 0;
         for(var n:int = 0; n < this._titleList.length; n++)
         {
            this._playerArray.push(this._titleList[n]);
            if(relation == this._titleList[n].titleType)
            {
               temp = n;
               break;
            }
         }
         var tempArray:Array = PlayerManager.Instance.getOnlineFriendForCustom(relation);
         var tempArr:Array = [];
         var tempArr1:Array = [];
         for(var i:int = 0; i < tempArray.length; i++)
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
         this._playerArray = this._playerArray.concat(tempArray);
         tempArray = PlayerManager.Instance.getOfflineFriendForCustom(relation);
         tempArray = this.sort(tempArray);
         tempArray = IMController.Instance.sortAcademyPlayer(tempArray);
         this._playerArray = this._playerArray.concat(tempArray);
         for(var j:int = temp + 1; j < this._titleList.length; j++)
         {
            this._playerArray.push(this._titleList[j]);
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateBlackList() : void
      {
         this._playerArray = [];
         for(var i:int = 0; i < this._titleList.length - 1; i++)
         {
            this._playerArray.push(this._titleList[i]);
         }
         var tempArray:Array = PlayerManager.Instance.blackList.list;
         this._playerArray = this._playerArray.concat(tempArray);
         this._playerArray.push(this._titleList[this._titleList.length - 1]);
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateRecentContactList() : void
      {
         var tempInfo:FriendListPlayer = null;
         var i:int = 0;
         var state:PlayerState = null;
         this._playerArray = [];
         this._playerArray.unshift(this._titleList[0]);
         var tempArray:Array = [];
         var tempDictionaryData:DictionaryData = PlayerManager.Instance.recentContacts;
         var recentContactsList:Array = IMController.Instance.recentContactsList;
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
                     tempArray.push(tempInfo);
                  }
               }
            }
         }
         this._playerArray = this._playerArray.concat(tempArray);
         for(var j:int = 1; j < this._titleList.length; j++)
         {
            this._playerArray.push(this._titleList[j]);
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function sort(arr:Array) : Array
      {
         return arr.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._listPanel) && Boolean(this._listPanel.parent))
         {
            this._listPanel.parent.removeChild(this._listPanel);
            this._listPanel.dispose();
            this._listPanel = null;
         }
         if(Boolean(this._currentItemInfo))
         {
            this._currentItemInfo.titleIsSelected = false;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
            this._currentItem = null;
         }
      }
      
      public function get currentItem() : IMListItemView
      {
         return this._currentItem;
      }
      
      public function set currentItem(value:IMListItemView) : void
      {
         this._currentItem = value;
      }
   }
}

