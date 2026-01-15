package roomList.pvpRoomList
{
   import LimitAward.LimitAwardButton;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import road7th.data.DictionaryEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import serverlist.view.RoomListServerDropList;
   import superWinner.manager.SuperWinnerManager;
   import trainer.TrainStep;
   import trainer.data.Step;
   
   public class RoomListBGView extends Sprite implements Disposeable
   {
      
      public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
      
      public static const FULL_MODE:int = 0;
      
      public static const ATHLETICS_MODE:int = 1;
      
      public static const CHALLENGE_MODE:int = 2;
      
      private var _bottom:ScaleBitmapImage;
      
      private var _roomListBG:Bitmap;
      
      private var _listTitle:Bitmap;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _rivalshipBtn:SimpleBitmapButton;
      
      private var _lookUpView:RoomLookUpView;
      
      private var _encounterBtn:SimpleBitmapButton;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _model:RoomListModel;
      
      private var _controller:RoomListController;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _serverlist:RoomListServerDropList;
      
      private var _tempDataList:Array;
      
      private var _modeMenu:ComboBox;
      
      private var _currentMode:int;
      
      private var _isPermissionEnter:Boolean;
      
      private var _modeArray:Array = ["ddt.roomList.roomListBG.full","ddt.roomList.roomListBG.Athletics","ddt.roomList.roomListBG.challenge"];
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      private var _lastCreatTime:int = 0;
      
      public function RoomListBGView(controller:RoomListController, model:RoomListModel)
      {
         this._model = model;
         this._controller = controller;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bottom = ComponentFactory.Instance.creatComponentByStylename("roomList.roomListView.frameBottom");
         this._roomListBG = ComponentFactory.Instance.creat("asset.background.roomlist.right");
         PositionUtils.setPos(this._roomListBG,"asset.ddtRoomlist.pvp.listBgpos");
         this._listTitle = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.right.listtitle");
         this._modeMenu = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoomlist.pvp.modeMenu");
         this._modeMenu.textField.text = LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]);
         this._currentMode = FULL_MODE;
         this._itemList = ComponentFactory.Instance.creat("asset.ddtRoomList.pvp.itemContainer",[2]);
         addChild(this._bottom);
         addChild(this._roomListBG);
         addChild(this._listTitle);
         addChild(this._modeMenu);
         addChild(this._itemList);
         this.updateList();
         this.initButton();
         this._isPermissionEnter = true;
      }
      
      private function initButton() : void
      {
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.nextBtn");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.preBtn");
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.pvpBtn.startBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         this._rivalshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.pvpBtn.formAteamBtn");
         this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinBattleQuickly");
         this._lookUpView = new RoomLookUpView(this.__updateClick,1);
         PositionUtils.setPos(this._lookUpView,"roomList.lookupView.Pos");
         this._encounterBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.pvpBtn.encounterBtn");
         this._encounterBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.fastMatchTip");
         this._serverlist = ComponentFactory.Instance.creat("asset.ddtRoomlist.pvp.serverlist");
         PositionUtils.setPos(this._serverlist,"roomList.serverlist.Pos");
         this.addTipPanel();
         addChild(this._nextBtn);
         addChild(this._preBtn);
         addChild(this._createBtn);
         addChild(this._rivalshipBtn);
         addChild(this._lookUpView);
         addChild(this._encounterBtn);
         addChild(this._serverlist);
         this._itemArray = [];
      }
      
      private function initEvent() : void
      {
         this._encounterBtn.addEventListener(MouseEvent.CLICK,this.__encounterBtnClick);
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createBtnClick);
         this._rivalshipBtn.addEventListener(MouseEvent.CLICK,this._rivalshipClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.addEventListener(RoomListModel.ROOM_ITEM_UPDATE,this.__updateItem);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         this._modeMenu.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         SuperWinnerManager.instance.addEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
      }
      
      private function removeEvent() : void
      {
         this._encounterBtn.removeEventListener(MouseEvent.CLICK,this.__encounterBtnClick);
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createBtnClick);
         this._rivalshipBtn.removeEventListener(MouseEvent.CLICK,this._rivalshipClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.removeEventListener(RoomListModel.ROOM_ITEM_UPDATE,this.__updateItem);
         if(Boolean(this._model.getRoomList()))
         {
            this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         }
         SuperWinnerManager.instance.removeEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
      }
      
      private function __superWinnerIsOpen(e:Event) : void
      {
         var alertFrame:BaseAlerFrame = null;
         if(SuperWinnerManager.instance.isOpen)
         {
            if(PlayerManager.Instance.Self.Grade >= 20)
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.superWinner.openSuperWinner"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
            }
         }
      }
      
      private function _responseEnterSuperWinner(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
         SoundManager.instance.playButtonSound();
         alert.dispose();
      }
      
      private function __updateItem(event:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function __onListClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentMode = this.getCurrentMode(event.cellValue);
         this.addTipPanel();
      }
      
      private function getCurrentMode(value:String) : int
      {
         for(var i:int = 0; i < this._modeArray.length; i++)
         {
            if(LanguageMgr.GetTranslation(this._modeArray[i]) == value)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function addTipPanel() : void
      {
         var comboxModel:VectorListModel = this._modeMenu.listPanel.vectorListModel;
         comboxModel.clear();
         switch(this._currentMode)
         {
            case FULL_MODE:
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
               break;
            case ATHLETICS_MODE:
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_ATHLETICTICS);
               break;
            case CHALLENGE_MODE:
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
               comboxModel.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFY);
         }
      }
      
      private function __clearRoom(event:DictionaryEvent) : void
      {
         this.cleanItem();
         this._isPermissionEnter = true;
      }
      
      private function updateList() : void
      {
         var info:RoomInfo = null;
         var item:RoomListItemView = null;
         for(var i:int = 0; i < this._model.getRoomList().length; i++)
         {
            info = this._model.getRoomList().list[i];
            item = new RoomListItemView(info);
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._itemList.addChild(item);
            this._itemArray.push(item);
         }
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            (this._itemArray[i] as RoomListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[i] as RoomListItemView).dispose();
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         this.gotoIntoRoom((event.currentTarget as RoomListItemView).info);
         this.getSelectItemPos((event.currentTarget as RoomListItemView).id);
      }
      
      private function getSelectItemPos(id:int) : int
      {
         if(!this._itemList)
         {
            return 0;
         }
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            if(!(this._itemArray[i] as RoomListItemView))
            {
               return 0;
            }
            if((this._itemArray[i] as RoomListItemView).id == id)
            {
               this._selectItemPos = i;
               this._selectItemID = (this._itemArray[i] as RoomListItemView).id;
               return i;
            }
         }
         return 0;
      }
      
      public function get currentDataList() : Array
      {
         if(this._model.roomShowMode == 1)
         {
            return this._model.getRoomList().filter("isPlaying",false).concat(this._model.getRoomList().filter("isPlaying",true));
         }
         return this._model.getRoomList().list;
      }
      
      private function getInfosPos(id:int) : int
      {
         this._tempDataList = this.currentDataList;
         if(!this._tempDataList)
         {
            return 0;
         }
         for(var i:int = 0; i < this._tempDataList.length; i++)
         {
            if((this._tempDataList[i] as RoomInfo).ID == id)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function upadteItemPos() : void
      {
         var temInfo:RoomInfo = null;
         var temPos:int = 0;
         var info:RoomInfo = null;
         var item:RoomListItemView = null;
         this._tempDataList = this.currentDataList;
         if(Boolean(this._tempDataList))
         {
            temInfo = this._tempDataList[this._selectItemPos];
            temPos = this.getInfosPos(this._selectItemID);
            this._tempDataList[this._selectItemPos] = this._tempDataList[temPos];
            this._tempDataList[temPos] = temInfo;
            this._tempDataList = this.sortRooInfo(this._tempDataList);
            this.cleanItem();
            for each(info in this._tempDataList)
            {
               if(!info)
               {
                  return;
               }
               item = new RoomListItemView(info);
               item.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
               this._itemList.addChild(item);
               this._itemArray.push(item);
            }
         }
      }
      
      private function sortRooInfo(roomInfos:Array) : Array
      {
         var roomType:int = 0;
         var info:RoomInfo = null;
         var newRoomInfos:Array = new Array();
         switch(this._currentMode)
         {
            case ATHLETICS_MODE:
               roomType = 0;
               break;
            case CHALLENGE_MODE:
               roomType = 1;
         }
         for each(info in roomInfos)
         {
            if(info)
            {
               if(info.type == roomType && !info.isPlaying)
               {
                  newRoomInfos.unshift(info);
               }
               else
               {
                  newRoomInfos.push(info);
               }
            }
         }
         return newRoomInfos;
      }
      
      private function gotoTip(type:int) : Boolean
      {
         if(type == 0)
         {
            if(PlayerManager.Instance.Self.Grade < 6)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom",6,LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream")));
               return true;
            }
         }
         else if(type == 1)
         {
            if(PlayerManager.Instance.Self.Grade < 12)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom",12,LanguageMgr.GetTranslation("tank.roomlist.challenge")));
               return true;
            }
         }
         return false;
      }
      
      public function gotoIntoRoom(info:RoomInfo) : void
      {
         SoundManager.instance.play("008");
         if(this.gotoTip(info.type))
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(1,-1,info.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function _rivalshipClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         if(this.gotoTip(0))
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(1,0);
         this._isPermissionEnter = false;
      }
      
      private function __updateClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __placeCountClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __hardLevelClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __roomModeClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __roomNameClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __idBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      public function sendUpdate() : void
      {
         switch(this._currentMode)
         {
            case FULL_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
               break;
            case ATHLETICS_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_ATHLETICTICS);
               break;
            case CHALLENGE_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFY);
         }
      }
      
      private function __createBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime > 2000)
         {
            this._lastCreatTime = getTimer();
            GameInSocketOut.sendCreateRoom(PREWORD[int(Math.random() * PREWORD.length)],0,3);
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CREATE_ROOM_TIP))
         {
            TrainStep.send(TrainStep.Step.CREATE_ROOM);
         }
      }
      
      protected function __encounterBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            RoomManager.Instance.addBattleSingleRoom();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         if(Boolean(this._roomListBG))
         {
            ObjectUtils.disposeObject(this._roomListBG);
         }
         this._roomListBG = null;
         ObjectUtils.disposeObject(this._bottom);
         this._bottom = null;
         if(Boolean(this._listTitle))
         {
            ObjectUtils.disposeObject(this._listTitle);
         }
         this._listTitle = null;
         this._nextBtn.dispose();
         this._nextBtn = null;
         this._preBtn.dispose();
         this._preBtn = null;
         this._createBtn.dispose();
         this._createBtn = null;
         this._rivalshipBtn.dispose();
         this._rivalshipBtn = null;
         this._lookUpView.dispose();
         this._lookUpView = null;
         if(Boolean(this._itemList))
         {
            this._itemList.disposeAllChildren();
         }
         ObjectUtils.disposeObject(this._itemList);
         this._itemList = null;
         this._itemArray = null;
         if(Boolean(this._modeMenu))
         {
            ObjectUtils.disposeObject(this._modeMenu);
            this._modeMenu = null;
         }
         if(Boolean(this._serverlist))
         {
            this._serverlist.dispose();
            this._serverlist = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
      }
   }
}

