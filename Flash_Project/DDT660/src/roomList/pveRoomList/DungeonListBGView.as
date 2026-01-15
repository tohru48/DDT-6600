package roomList.pveRoomList
{
   import LimitAward.LimitAwardButton;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Scrollbar;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.data.DictionaryEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.chooseMap.DungeonChooseMapView;
   import roomList.LookupEnumerate;
   import roomList.RoomListMapTipPanel;
   import roomList.RoomListTipPanel;
   import roomList.pvpRoomList.RoomLookUpView;
   import serverlist.view.RoomListServerDropList;
   
   public class DungeonListBGView extends Sprite implements Disposeable
   {
      
      public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
      
      private var _dungeonListBG:Bitmap;
      
      private var _roomlistWord:Bitmap;
      
      private var _model:DungeonListModel;
      
      private var _bmpSiftFb:FilterFrameText;
      
      private var _bmpSiftHardLv:FilterFrameText;
      
      private var _btnSiftReset:TextButton;
      
      private var _bmpCbFb:BaseButton;
      
      private var _bmpCbHardLv:BaseButton;
      
      private var _txtCbFb:FilterFrameText;
      
      private var _txtCbHardLv:FilterFrameText;
      
      private var _iconBtnII:SimpleBitmapButton;
      
      private var _iconBtnIII:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _rivalshipBtn:SimpleBitmapButton;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _pveHardLeveRoomListTipPanel:RoomListTipPanel;
      
      private var _pveMapRoomListTipPanel:RoomListMapTipPanel;
      
      private var _controlle:DungeonListController;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _tempDataList:Array;
      
      private var _serverlist:RoomListServerDropList;
      
      private var _cut:Bitmap;
      
      private var _isPermissionEnter:Boolean;
      
      private var _bottom:ScaleBitmapImage;
      
      private var _lookUpView:RoomLookUpView;
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      private var _last_creat:uint;
      
      public function DungeonListBGView(controlle:DungeonListController, model:DungeonListModel)
      {
         this._controlle = controlle;
         this._model = model;
         super();
         this.init();
         this.initEvent();
         this.initControl();
      }
      
      private function init() : void
      {
         this._itemArray = [];
         this._bottom = ComponentFactory.Instance.creatComponentByStylename("roomList.dungeonListView.frameBottom");
         addChild(this._bottom);
         this._dungeonListBG = ComponentFactory.Instance.creat("asset.ddtroomlist.pve.moviebg");
         PositionUtils.setPos(this._dungeonListBG,"asset.ddtRoomlist.pve.roomlistBgPos");
         addChild(this._dungeonListBG);
         this._roomlistWord = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.pveRoomlist");
         addChild(this._roomlistWord);
         this._bmpSiftFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.siftFB");
         this._bmpSiftFb.text = LanguageMgr.GetTranslation("ddt.pve.roomlist.itemlist.siftFb");
         addChild(this._bmpSiftFb);
         this._bmpSiftHardLv = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.siftHard");
         this._bmpSiftHardLv.text = LanguageMgr.GetTranslation("ddt.pve.roomlist.itemlist.siftHard");
         addChild(this._bmpSiftHardLv);
         this._btnSiftReset = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.resetBtn");
         this._btnSiftReset.text = LanguageMgr.GetTranslation("ddt.pve.roomlist.itemlist.reset");
         addChild(this._btnSiftReset);
         this._bmpCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.bmpCbFb");
         addChild(this._bmpCbFb);
         this._bmpCbHardLv = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.bmpCbHardLv");
         addChild(this._bmpCbHardLv);
         this._txtCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.txtCbFb");
         this._txtCbFb.mouseEnabled = false;
         addChild(this._txtCbFb);
         this._txtCbHardLv = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.txtHardLv");
         this._txtCbHardLv.mouseEnabled = false;
         addChild(this._txtCbHardLv);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.nextBtn");
         addChild(this._nextBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.preBtn");
         addChild(this._preBtn);
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.createBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         addChild(this._createBtn);
         this._rivalshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.quickBtn");
         this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinDuplicateQuickly");
         addChild(this._rivalshipBtn);
         this._iconBtnII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.iconbtn2");
         addChild(this._iconBtnII);
         this._iconBtnIII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.iconbtn3");
         addChild(this._iconBtnIII);
         this._cut = UICreatShortcut.creatAndAdd("asset.ddtroomList.cut",this);
         var severName:String = String(ServerManager.Instance.current.Name);
         var num:int = int(severName.indexOf("("));
         num = num == -1 ? severName.length : num;
         this._itemList = ComponentFactory.Instance.creat("asset.ddtroomList.DungeonList.ItemList",[2]);
         addChild(this._itemList);
         this._serverlist = ComponentFactory.Instance.creat("asset.ddtRoomlist.pvp.serverlist");
         addChild(this._serverlist);
         this._lookUpView = new RoomLookUpView(this.__updateClick,2);
         PositionUtils.setPos(this._lookUpView,"dungeonList.lookupView.Pos");
         addChild(this._lookUpView);
         this.addTipPanel();
         this.resetSift();
         this._isPermissionEnter = true;
      }
      
      private function initEvent() : void
      {
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.addEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtnII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._iconBtnIII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._bmpCbFb.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._bmpCbHardLv.addEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._btnSiftReset.addEventListener(MouseEvent.CLICK,this.__siftReset);
         this._pveMapRoomListTipPanel.addEventListener(RoomListMapTipPanel.FB_CHANGE,this.__fbChange);
         this._pveHardLeveRoomListTipPanel.addEventListener(RoomListTipPanel.HARD_LV_CHANGE,this.__hardLvChange);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.addEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
         RoomManager.Instance.addEventListener(RoomManager.LOGIN_ROOM_RESULT,this.__loginRoomRes);
      }
      
      private function initControl() : void
      {
         this.sendSift();
      }
      
      private function removeEvent() : void
      {
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.removeEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtnII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._iconBtnIII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._bmpCbFb.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._bmpCbHardLv.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._btnSiftReset.removeEventListener(MouseEvent.CLICK,this.__siftReset);
         this._pveMapRoomListTipPanel.removeEventListener(RoomListMapTipPanel.FB_CHANGE,this.__fbChange);
         this._pveHardLeveRoomListTipPanel.removeEventListener(RoomListTipPanel.HARD_LV_CHANGE,this.__hardLvChange);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.removeEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
         RoomManager.Instance.removeEventListener(RoomManager.LOGIN_ROOM_RESULT,this.__loginRoomRes);
      }
      
      private function __loginRoomRes(evt:Event) : void
      {
         this._isPermissionEnter = true;
      }
      
      private function __rivalshipBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(LookupEnumerate.DUNGEON_LIST,4);
         this._isPermissionEnter = false;
      }
      
      private function __stageClick(event:MouseEvent) : void
      {
         if(!DisplayUtils.isTargetOrContain(event.target as DisplayObject,this._iconBtnII) && !DisplayUtils.isTargetOrContain(event.target as DisplayObject,this._iconBtnIII) && !DisplayUtils.isTargetOrContain(event.target as DisplayObject,this._bmpCbFb) && !DisplayUtils.isTargetOrContain(event.target as DisplayObject,this._bmpCbHardLv) && !(event.target is BaseButton) && !(event.target is ScaleBitmapImage && (event.target as DisplayObject).parent is Scrollbar))
         {
            this._pveMapRoomListTipPanel.visible = false;
            this._pveHardLeveRoomListTipPanel.visible = false;
         }
      }
      
      private function __lookupClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controlle.showFindRoom();
      }
      
      private function __fbChange(evt:Event) : void
      {
         this.sendSift();
         if(this._pveMapRoomListTipPanel.value == 10000)
         {
            this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
         }
         else
         {
            this.setTxtCbFb(MapManager.getMapName(this._pveMapRoomListTipPanel.value));
         }
      }
      
      private function __hardLvChange(evt:Event) : void
      {
         this.sendSift();
         this.setTxtCbHardLv(this.getHardLvTxt(this._pveHardLeveRoomListTipPanel.value));
      }
      
      private function __siftReset(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.resetSift();
         this.sendSift();
      }
      
      private function sendSift() : void
      {
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST,-2,this._pveMapRoomListTipPanel.value,this._pveHardLeveRoomListTipPanel.value);
      }
      
      private function resetSift() : void
      {
         this._pveMapRoomListTipPanel.resetValue();
         this._pveHardLeveRoomListTipPanel.resetValue();
         this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
         this.setTxtCbHardLv("tank.room.difficulty.all");
      }
      
      private function setTxtCbFb(txt:String) : void
      {
         this._txtCbFb.text = txt;
         this._txtCbFb.x = this._bmpCbFb.x + (this._bmpCbFb.width - this._iconBtnII.width - this._txtCbFb.width) / 2;
      }
      
      private function setTxtCbHardLv(txt:String) : void
      {
         this._txtCbHardLv.text = LanguageMgr.GetTranslation(txt);
         this._txtCbHardLv.x = this._bmpCbHardLv.x + (this._bmpCbHardLv.width - this._iconBtnIII.width - this._txtCbHardLv.width) / 2;
      }
      
      private function getHardLvTxt(value:int) : String
      {
         switch(value)
         {
            case LookupEnumerate.DUNGEON_LIST_SIMPLE:
               return "tank.room.difficulty.simple";
            case LookupEnumerate.DUNGEON_LIST_COMMON:
               return "tank.room.difficulty.normal";
            case LookupEnumerate.DUNGEON_LIST_STRAIT:
               return "tank.room.difficulty.hard";
            case LookupEnumerate.DUNGEON_LIST_HERO:
               return "tank.room.difficulty.hero";
            case LookupEnumerate.DUNGEON_LIST_EPIC:
               return "ddt.dungeonRoom.level4";
            case LookupEnumerate.DUNGEON_LIST_EPIC:
               return "tank.room.difficulty.epic";
            default:
               return "tank.room.difficulty.all";
         }
      }
      
      private function addTipPanel() : void
      {
         var hardLeve_01:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_01");
         var hardLeve_02:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_02");
         var hardLeve_03:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_03");
         var hardLeve_04:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_04");
         var hardLeve_05:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_05");
         var hardLeve_06:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_06");
         var dungeonListTipPanelSizeII:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.DungeonListTipPanelSizeII");
         this._pveHardLeveRoomListTipPanel = new RoomListTipPanel(dungeonListTipPanelSizeII.x,dungeonListTipPanelSizeII.y);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_05,LookupEnumerate.DUNGEON_LIST_ALL);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_01,LookupEnumerate.DUNGEON_LIST_SIMPLE);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_02,LookupEnumerate.DUNGEON_LIST_COMMON);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_03,LookupEnumerate.DUNGEON_LIST_STRAIT);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_04,LookupEnumerate.DUNGEON_LIST_HERO);
         this._pveHardLeveRoomListTipPanel.addItem(hardLeve_06,LookupEnumerate.DUNGEON_LIST_EPIC);
         var posII:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveHardLeveRoomListTipPanelPos");
         this._pveHardLeveRoomListTipPanel.x = posII.x;
         this._pveHardLeveRoomListTipPanel.y = posII.y;
         this._pveHardLeveRoomListTipPanel.visible = false;
         addChild(this._pveHardLeveRoomListTipPanel);
         var posIII:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveMapPanelPos");
         var dungeonListTipPanelSizeIII:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSizeIII");
         this._pveMapRoomListTipPanel = new RoomListMapTipPanel(dungeonListTipPanelSizeIII.x,dungeonListTipPanelSizeIII.y);
         this._pveMapRoomListTipPanel.x = posIII.x;
         this._pveMapRoomListTipPanel.y = posIII.y;
         this._pveMapRoomListTipPanel.addItem(10000);
         for(var i:int = 1; i < DungeonChooseMapView.DUNGEON_NO; i++)
         {
            if(Boolean(MapManager.getByOrderingDungeonInfo(i)))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingDungeonInfo(i).ID);
            }
         }
         for(var j:int = 1; j < DungeonChooseMapView.DUNGEON_NO; j++)
         {
            if(Boolean(MapManager.getByOrderingAcademyDungeonInfo(j)))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingAcademyDungeonInfo(j).ID);
            }
         }
         for(var k:int = 0; k < MapManager.getAdvancedList().length; k++)
         {
            this._pveMapRoomListTipPanel.addItem(MapManager.getAdvancedList()[k].ID);
         }
         for(var m:int = 0; m < MapManager.getPveActivityList().length; m++)
         {
            this._pveMapRoomListTipPanel.addItem(MapManager.getPveActivityList()[m].ID);
         }
         this._pveMapRoomListTipPanel.visible = false;
         addChild(this._pveMapRoomListTipPanel);
      }
      
      private function __clearRoom(event:DictionaryEvent) : void
      {
         this.cleanItem();
         this._isPermissionEnter = true;
      }
      
      private function __addRoom(event:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function upadteItemPos() : void
      {
         var temInfo:RoomInfo = null;
         var temPos:int = 0;
         var info:RoomInfo = null;
         var item:DungeonListItemView = null;
         this._tempDataList = this.currentDataList;
         if(Boolean(this._tempDataList))
         {
            temInfo = this._tempDataList[this._selectItemPos];
            temPos = this.getInfosPos(this._selectItemID);
            this._tempDataList[this._selectItemPos] = this._tempDataList[temPos];
            this._tempDataList[temPos] = temInfo;
            this.cleanItem();
            for each(info in this._tempDataList)
            {
               if(info)
               {
                  item = new DungeonListItemView(info);
                  item.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
                  this._itemList.addChild(item);
                  this._itemArray.push(item);
               }
            }
         }
      }
      
      private function getSelectItemPos(id:int) : int
      {
         if(!this._itemList)
         {
            return 0;
         }
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            if(!(this._itemArray[i] as DungeonListItemView))
            {
               return 0;
            }
            if((this._itemArray[i] as DungeonListItemView).id == id)
            {
               this._selectItemPos = i;
               this._selectItemID = (this._itemArray[i] as DungeonListItemView).id;
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
      
      private function __iconBtnIIClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveMapRoomListTipPanel.visible = !this._pveMapRoomListTipPanel.visible;
         this._pveHardLeveRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnIIIClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveHardLeveRoomListTipPanel.visible = !this._pveHardLeveRoomListTipPanel.visible;
         this._pveMapRoomListTipPanel.visible = false;
      }
      
      private function __updateClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendSift();
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         SoundManager.instance.play("008");
         var itemView:DungeonListItemView = event.currentTarget as DungeonListItemView;
         if(PlayerManager.Instance.Self.Grade < 25 && itemView.info.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.ActivityDungeon.promptInfo"));
            return;
         }
         this.gotoIntoRoom(itemView.info);
         this.getSelectItemPos(itemView.id);
      }
      
      public function gotoIntoRoom(info:RoomInfo) : void
      {
         SocketManager.Instance.out.sendGameLogin(2,-1,info.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function __createClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._last_creat >= 2000)
         {
            this._last_creat = getTimer();
            GameInSocketOut.sendCreateRoom(PREWORD[int(Math.random() * PREWORD.length)],4,3);
         }
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            (this._itemArray[i] as DungeonListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[i] as DungeonListItemView).dispose();
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         if(Boolean(this._bottom))
         {
            this._bottom.dispose();
            this._bottom = null;
         }
         if(Boolean(this._lookUpView))
         {
            this._lookUpView.dispose();
            this._lookUpView = null;
         }
         this._itemList.dispose();
         this._itemList = null;
         this._iconBtnII.dispose();
         this._iconBtnII = null;
         this._iconBtnIII.dispose();
         this._iconBtnIII = null;
         if(Boolean(this._roomlistWord))
         {
            ObjectUtils.disposeObject(this._roomlistWord);
         }
         this._roomlistWord = null;
         if(Boolean(this._cut))
         {
            ObjectUtils.disposeObject(this._cut);
         }
         this._cut = null;
         ObjectUtils.disposeObject(this._bmpSiftFb);
         this._bmpSiftFb = null;
         ObjectUtils.disposeObject(this._bmpSiftHardLv);
         this._bmpSiftHardLv = null;
         ObjectUtils.disposeObject(this._bmpCbFb);
         this._bmpCbFb = null;
         ObjectUtils.disposeObject(this._bmpCbHardLv);
         this._bmpCbHardLv = null;
         ObjectUtils.disposeObject(this._txtCbFb);
         this._txtCbFb = null;
         ObjectUtils.disposeObject(this._txtCbHardLv);
         this._txtCbHardLv = null;
         ObjectUtils.disposeObject(this._btnSiftReset);
         this._btnSiftReset = null;
         this._nextBtn.dispose();
         this._nextBtn = null;
         this._preBtn.dispose();
         this._preBtn = null;
         this._createBtn.dispose();
         this._createBtn = null;
         this._rivalshipBtn.dispose();
         this._rivalshipBtn = null;
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         if(Boolean(this._pveHardLeveRoomListTipPanel) && Boolean(this._pveHardLeveRoomListTipPanel.parent))
         {
            this._pveHardLeveRoomListTipPanel.parent.removeChild(this._pveHardLeveRoomListTipPanel);
         }
         this._pveHardLeveRoomListTipPanel.dispose();
         this._pveHardLeveRoomListTipPanel = null;
         if(Boolean(this._pveMapRoomListTipPanel) && Boolean(this._pveMapRoomListTipPanel.parent))
         {
            this._pveMapRoomListTipPanel.parent.removeChild(this._pveMapRoomListTipPanel);
         }
         this._pveMapRoomListTipPanel.dispose();
         this._pveMapRoomListTipPanel = null;
         if(Boolean(this._serverlist))
         {
            ObjectUtils.disposeObject(this._serverlist);
            this._serverlist = null;
         }
         if(Boolean(this._dungeonListBG))
         {
            ObjectUtils.disposeObject(this._dungeonListBG);
            this._dungeonListBG = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

