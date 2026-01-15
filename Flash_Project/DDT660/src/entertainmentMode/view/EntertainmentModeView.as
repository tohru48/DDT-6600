package entertainmentMode.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import entertainmentMode.EntertainmentModeManager;
   import entertainmentMode.model.EntertainmentModel;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.pvpRoomList.RoomListBGView;
   import shop.view.ShopItemCell;
   
   public class EntertainmentModeView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _joinBtn:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _enterBtn:SimpleBitmapButton;
      
      private var _helpBtn:BaseButton;
      
      private var _searchBg:Image;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _searchTxt:SimpleDropListTarget;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _timeTitleTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _isPermissionEnter:Boolean;
      
      private var _box:Sprite = new Sprite();
      
      private var list:ScrollPanel;
      
      private var pkBtn:MovieClip;
      
      public function EntertainmentModeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var _bitmap:Bitmap = null;
         var _txt:FilterFrameText = null;
         var _itemCell:ShopItemCell = null;
         var _info:ItemTemplateInfo = null;
         this._itemArray = [];
         titleText = LanguageMgr.GetTranslation("ddt.entertainmentMode.title");
         if(PathManager.pkEnable)
         {
            this._bg = ComponentFactory.Instance.creat("asset.Entertainment.mode.bg2");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creat("asset.Entertainment.mode.bg");
         }
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("entertainment.HelpBtn");
         addToContent(this._helpBtn);
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.joinBtn");
         this._joinBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinBattleQuickly");
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.createBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.enterBtn");
         addToContent(this._joinBtn);
         addToContent(this._createBtn);
         addToContent(this._enterBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.nextBtn");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.preBtn");
         addToContent(this._nextBtn);
         addToContent(this._preBtn);
         this._searchBg = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.searchBg");
         addToContent(this._searchBg);
         this._itemList = ComponentFactory.Instance.creat("asset.entertainment.ItemList",[2]);
         addToContent(this._itemList);
         this._searchTxt = ComponentFactory.Instance.creat("asset.entertainment.searchtxt");
         addToContent(this._searchTxt);
         this._searchTxt.restrict = "0-9";
         this._scoreTxt = ComponentFactory.Instance.creat("asset.entertainment.score");
         addToContent(this._scoreTxt);
         this._timeTitleTxt = ComponentFactory.Instance.creat("asset.entertainment.time.title");
         addToContent(this._timeTitleTxt);
         this._timeTitleTxt.text = LanguageMgr.GetTranslation("ddt.entertainmentMode.TimeFieldTitle");
         this._timeTxt = ComponentFactory.Instance.creat("asset.entertainment.time");
         addToContent(this._timeTxt);
         this._timeTxt.text = EntertainmentModeManager.instance.openTime;
         this.list = ComponentFactory.Instance.creat("asset.entertainment.panel");
         addToContent(this.list);
         this.list.hScrollProxy = ScrollPanel.OFF;
         this.list.vScrollProxy = ScrollPanel.ON;
         for(i = 0; i < ServerConfigManager.instance.entertainmentScore().length; i++)
         {
            if(i % 2 == 0)
            {
               _bitmap = ComponentFactory.Instance.creat("asset.Entertainment.mode.dark");
            }
            else
            {
               _bitmap = ComponentFactory.Instance.creat("asset.Entertainment.mode.light");
            }
            this._box.addChild(_bitmap);
            _txt = ComponentFactory.Instance.creat("asset.entertainment.list.score");
            this._box.addChild(_txt);
            _txt.text = String(ServerConfigManager.instance.entertainmentScore()[i].split("|")[0]);
            _txt.y = i * _bitmap.height + 9;
            _bitmap.y = i * _bitmap.height;
            _itemCell = this.creatItemCell();
            _itemCell.buttonMode = true;
            _itemCell.cellSize = 39;
            _info = ItemManager.Instance.getTemplateById(ServerConfigManager.instance.entertainmentScore()[i].split("|")[1]);
            _itemCell.info = _info;
            _itemCell.x = 126;
            _itemCell.y = i * _bitmap.height - 7;
            this._box.addChild(_itemCell);
         }
         this.list.setView(this._box);
         if(PathManager.pkEnable)
         {
            this.list.height = 303;
            this.pkBtn = ComponentFactory.Instance.creat("asset.Entertainment.mode.pkBtn");
            this.pkBtn.buttonMode = true;
            addToContent(this.pkBtn);
            PositionUtils.setPos(this.pkBtn,"asset.Entertainment.pkBtn.Pos");
         }
         this.list.invalidateViewport();
         this._isPermissionEnter = true;
         SocketManager.Instance.out.sendEntertainment();
      }
      
      private function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,23,23);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      private function initEvent() : void
      {
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._searchTxt.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._searchTxt.addEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.__joinBtnHandler);
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createBtnHandler);
         this._enterBtn.addEventListener(MouseEvent.CLICK,this.__enterBtnHandler);
         EntertainmentModel.instance.addEventListener(EntertainmentModel.ROOMLIST_CHANGE,this.__roomListChanger);
         EntertainmentModel.instance.addEventListener(EntertainmentModel.SCORE_CHANGE,this.__scoreChanger);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__onEnter);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.helpBtnClickHandler);
         if(Boolean(this.pkBtn))
         {
            this.pkBtn.addEventListener(MouseEvent.CLICK,this.__pkBtnHandler);
         }
         this._scoreTxt.text = EntertainmentModel.instance.score.toString();
         this.updateRoomList();
      }
      
      private function helpBtnClickHandler(e:MouseEvent) : void
      {
         var helpPage:EntertainmentInfoFrame = ComponentFactory.Instance.creatCustomObject("entertainment.infoFrame");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __pkBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],42,3);
      }
      
      private function __onEnter(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var info:RoomInfo = null;
         var listArr:Array = [];
         var pkg:PackageIn = evt.pkg;
         EntertainmentModel.instance.roomTotal = pkg.readInt();
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            id = pkg.readInt();
            info = new RoomInfo();
            info.ID = id;
            info.type = pkg.readByte();
            info.timeType = pkg.readByte();
            info.totalPlayer = pkg.readByte();
            info.viewerCnt = pkg.readByte();
            info.maxViewerCnt = pkg.readByte();
            info.placeCount = pkg.readByte();
            info.IsLocked = pkg.readBoolean();
            info.mapId = pkg.readInt();
            info.isPlaying = pkg.readBoolean();
            info.Name = pkg.readUTF();
            info.gameMode = pkg.readByte();
            info.hardLevel = pkg.readByte();
            info.levelLimits = pkg.readInt();
            info.isOpenBoss = pkg.readBoolean();
            listArr.push(info);
         }
         EntertainmentModel.instance.updateRoom(listArr);
      }
      
      private function __scoreChanger(e:Event) : void
      {
         this._scoreTxt.text = EntertainmentModel.instance.score.toString();
      }
      
      private function __gameStart(evt:CrazyTankSocketEvent) : void
      {
      }
      
      private function __enterBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
            return;
         }
         SocketManager.Instance.out.sendGameLogin(8,-1,int(this._searchTxt.text));
      }
      
      private function __createBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],41,3);
      }
      
      private function __joinBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(8,41);
         this._isPermissionEnter = false;
      }
      
      private function __updateClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendSift();
      }
      
      private function sendSift() : void
      {
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOMLIST_ENTERTAINMENT);
      }
      
      private function __roomListChanger(e:Event) : void
      {
         this.updateRoomList();
      }
      
      private function updateRoomList() : void
      {
         var room:RoomInfo = null;
         var item:EntertainmentListItem = null;
         this.cleanItem();
         for each(room in EntertainmentModel.instance.roomList)
         {
            item = new EntertainmentListItem(room);
            item.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
            this._itemList.addChild(item);
            this._itemArray.push(item);
         }
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         SoundManager.instance.play("008");
         var itemView:EntertainmentListItem = event.currentTarget as EntertainmentListItem;
         SocketManager.Instance.out.sendGameLogin(8,-1,itemView.info.ID);
         this._isPermissionEnter = false;
      }
      
      private function _clickName(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == LanguageMgr.GetTranslation("ddt.entertainmentMode.input.roomNumber"))
         {
            this._searchTxt.text = "";
         }
      }
      
      private function setFocus(e:Event) : void
      {
         this._searchTxt.text = LanguageMgr.GetTranslation("ddt.entertainmentMode.input.roomNumber");
         this._searchTxt.setFocus();
         this._searchTxt.setCursor(this._searchTxt.text.length);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               EntertainmentModeManager.instance.hide();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._searchTxt.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._searchTxt.removeEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._joinBtn.removeEventListener(MouseEvent.CLICK,this.__joinBtnHandler);
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createBtnHandler);
         this._enterBtn.removeEventListener(MouseEvent.CLICK,this.__enterBtnHandler);
         EntertainmentModel.instance.removeEventListener(EntertainmentModel.ROOMLIST_CHANGE,this.__roomListChanger);
         EntertainmentModel.instance.removeEventListener(EntertainmentModel.SCORE_CHANGE,this.__scoreChanger);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__onEnter);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.helpBtnClickHandler);
         if(Boolean(this.pkBtn))
         {
            this.pkBtn.removeEventListener(MouseEvent.CLICK,this.__pkBtnHandler);
         }
      }
      
      private function cleanItem() : void
      {
         this._isPermissionEnter = true;
         for(var i:int = 0; i < this._itemArray.length; i++)
         {
            this._itemArray[i].removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._itemArray[i].dispose();
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._searchBg);
         this._searchBg = null;
         ObjectUtils.disposeObject(this._searchTxt);
         this._searchTxt = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._timeTitleTxt);
         this._timeTitleTxt = null;
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         if(Boolean(this.pkBtn))
         {
            ObjectUtils.disposeObject(this.pkBtn);
            this.pkBtn = null;
         }
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
            this._helpBtn = null;
         }
         if(Boolean(this._joinBtn))
         {
            this._joinBtn.dispose();
            this._joinBtn = null;
         }
         if(Boolean(this._createBtn))
         {
            this._createBtn.dispose();
            this._createBtn = null;
         }
         if(Boolean(this._enterBtn))
         {
            this._enterBtn.dispose();
            this._enterBtn = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._preBtn))
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         this._itemList.dispose();
         this._itemList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

