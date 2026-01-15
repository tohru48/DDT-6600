package room.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.PlayerPortraitView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.GameInfo;
   import im.IMController;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class RoomViewerItem extends Sprite implements Disposeable
   {
      
      public static const LONG:uint = 186;
      
      public static const SHORT:uint = 90;
      
      private var _bg:Bitmap;
      
      private var _bgWidth:int;
      
      private var _waitingBitmap:Bitmap;
      
      private var _closeBitmap:Bitmap;
      
      private var _headFigureFrame:Bitmap;
      
      private var _info:RoomPlayer;
      
      private var _portrait:PlayerPortraitView;
      
      private var _kickOutBtn:SimpleBitmapButton;
      
      private var _viewInfoBtn:SimpleBitmapButton;
      
      private var _addFriendBtn:SimpleBitmapButton;
      
      private var _nameTxt:FilterFrameText;
      
      private var _place:int;
      
      private var _opened:Boolean;
      
      private var _loadingMode:Boolean;
      
      public function RoomViewerItem(place:int = 8, widthType:uint = 186)
      {
         super();
         this._place = place;
         this._bgWidth = widthType;
         this.init();
      }
      
      private function init() : void
      {
         buttonMode = true;
         if(this._bgWidth == LONG)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.bigbg");
            this._waitingBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.bigWaitAsset");
            this._closeBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.bigOpenAsset");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.smallbg");
            this._waitingBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.smallWaitAsset");
            this._closeBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroom.viewerItem.smallOpenAsset");
         }
         this._headFigureFrame = ComponentFactory.Instance.creatBitmap("asset.ddtroom.ViewerHeadFigureFrame");
         this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.ViewInfoButton");
         PositionUtils.setPos(this._viewInfoBtn,"asset.ddtroom.viewer.viewInfoPos");
         this._kickOutBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.kickOutButton");
         PositionUtils.setPos(this._kickOutBtn,"asset.ddtroom.viewer.closePos");
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.addFriendButton");
         PositionUtils.setPos(this._addFriendBtn,"asset.ddtroom.viewer.addFriendPos");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.ViewerItem.NameTxt");
         this._viewInfoBtn.transparentEnable = this._kickOutBtn.transparentEnable = this._addFriendBtn.transparentEnable = true;
         this._portrait = new PlayerPortraitView("right");
         this._portrait.isShowFrame = false;
         this._portrait.scaleX = this._portrait.scaleY = 0.5;
         PositionUtils.setPos(this._portrait,"asset.ddtroom.ViewerItem.PortraitPos");
         this._addFriendBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.addFriend");
         this._viewInfoBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
         this._kickOutBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom");
         if(this._bgWidth == SHORT)
         {
            this._addFriendBtn.x = 39;
            this._viewInfoBtn.x = 57;
            this._kickOutBtn.x = 73;
            this._nameTxt.width = 44;
            this._nameTxt.x = 43;
         }
         this.setCenterPos(this._waitingBitmap);
         addChild(this._bg);
         addChild(this._waitingBitmap);
         this.initEvents();
      }
      
      public function changeBg() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomloading.hasViewer");
         addChildAt(this._bg,0);
      }
      
      public function set opened(value:Boolean) : void
      {
         this._opened = value;
         if(this._opened && this._info == null)
         {
            if(contains(this._closeBitmap))
            {
               removeChild(this._closeBitmap);
            }
            this.setCenterPos(this._waitingBitmap);
            addChildAt(this._waitingBitmap,1);
            buttonMode = true;
         }
         else if(this._info == null)
         {
            if(contains(this._waitingBitmap))
            {
               removeChild(this._waitingBitmap);
            }
            this.setCenterPos(this._closeBitmap);
            addChildAt(this._closeBitmap,1);
            if(!RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
               buttonMode = false;
            }
         }
      }
      
      public function set loadingMode(value:Boolean) : void
      {
         if(value)
         {
            this._loadingMode = value;
            if(contains(this._viewInfoBtn))
            {
               removeChild(this._viewInfoBtn);
            }
            if(contains(this._kickOutBtn))
            {
               removeChild(this._kickOutBtn);
            }
            if(contains(this._addFriendBtn))
            {
               removeChild(this._addFriendBtn);
            }
         }
      }
      
      private function setCenterPos(display:DisplayObject) : void
      {
         display.x = (this._bgWidth - display.width) / 2;
         display.y = (this._bg.height - display.height) / 2;
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      public function set info(info:RoomPlayer) : void
      {
         var _gameInfo:GameInfo = null;
         if(info != null && info.isSelf)
         {
            MainToolBar.Instance.setRoomStartState();
            MainToolBar.Instance.setReturnEnable(true);
         }
         this._kickOutBtn.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
         if(this._info == info)
         {
            return;
         }
         this._info = info;
         if(Boolean(this._info))
         {
            if(contains(this._closeBitmap))
            {
               removeChild(this._closeBitmap);
            }
            if(contains(this._waitingBitmap))
            {
               removeChild(this._waitingBitmap);
            }
            if(!this._loadingMode)
            {
               addChild(this._viewInfoBtn);
               addChild(this._kickOutBtn);
               addChild(this._addFriendBtn);
            }
            _gameInfo = GameManager.Instance.Current;
            if(!this._loadingMode && _gameInfo != null && _gameInfo.hasNextMission && (RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM))
            {
               _gameInfo.livingToViewer(this._info.playerInfo.ID,this._info.playerInfo.ZoneID);
            }
            this._info.place = this._place;
            this._portrait.info = this._info.playerInfo;
            this._nameTxt.text = this._info.playerInfo.NickName;
            addChild(this._headFigureFrame);
            addChild(this._portrait);
            addChild(this._nameTxt);
            if(this._info == RoomManager.Instance.current.selfRoomPlayer)
            {
               dispatchEvent(new RoomEvent(RoomEvent.VIEWER_ITEM_INFO_SET,[1]));
            }
            return;
         }
         if(contains(this._headFigureFrame))
         {
            removeChild(this._headFigureFrame);
         }
         if(contains(this._portrait))
         {
            removeChild(this._portrait);
         }
         if(contains(this._nameTxt))
         {
            removeChild(this._nameTxt);
         }
         if(contains(this._viewInfoBtn))
         {
            removeChild(this._viewInfoBtn);
         }
         if(contains(this._kickOutBtn))
         {
            removeChild(this._kickOutBtn);
         }
         if(contains(this._addFriendBtn))
         {
            removeChild(this._addFriendBtn);
         }
         this.setCenterPos(this._waitingBitmap);
         addChildAt(this._waitingBitmap,1);
         dispatchEvent(new RoomEvent(RoomEvent.VIEWER_ITEM_INFO_SET,[0]));
      }
      
      private function __infoStateChange(event:RoomPlayerEvent) : void
      {
      }
      
      private function initEvents() : void
      {
         this._viewInfoBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._kickOutBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         addEventListener(MouseEvent.CLICK,this.__changePlace);
         RoomManager.Instance.current.addEventListener(RoomEvent.STARTED_CHANGED,this.__updateBtns);
         RoomManager.Instance.current.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateBtns);
      }
      
      private function removeEvents() : void
      {
         this._viewInfoBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._kickOutBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         removeEventListener(MouseEvent.CLICK,this.__changePlace);
         RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED,this.__updateBtns);
         RoomManager.Instance.current.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateBtns);
      }
      
      private function __updateBtns(e:Event) : void
      {
         buttonMode = !RoomManager.Instance.current.started;
         if(this._info != null)
         {
            buttonMode = true;
         }
         this._kickOutBtn.enable = !RoomManager.Instance.current.started && RoomManager.Instance.current.selfRoomPlayer.isHost;
      }
      
      private function __changePlace(event:MouseEvent) : void
      {
         if(Boolean(this._info))
         {
            PlayerInfoViewControl.view(this._info.playerInfo);
            SoundManager.instance.play("008");
            return;
         }
         if(RoomManager.Instance.current.started)
         {
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameRoomPlaceState(this._place,this._opened ? 0 : -1);
         }
         else
         {
            if(!this._opened)
            {
               return;
            }
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.UnableToSwitchToAnotherViewer"));
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isReady)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.UnableToSwitchToAnotherViewerWhenIsReady"));
            }
            else
            {
               GameInSocketOut.sendGameRoomPlaceState(RoomManager.Instance.current.selfRoomPlayer.place,-1,true,this._place);
            }
         }
         SoundManager.instance.play("008");
      }
      
      private function __clickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         e.stopImmediatePropagation();
         switch(e.currentTarget)
         {
            case this._viewInfoBtn:
               PlayerTipManager.show(this._info.playerInfo,localToGlobal(new Point(0,0)).y);
               break;
            case this._addFriendBtn:
               IMController.Instance.addFriend(this._info.playerInfo.NickName);
               break;
            case this._kickOutBtn:
               GameInSocketOut.sendGameRoomKick(this._info.place);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._waitingBitmap))
         {
            if(Boolean(this._waitingBitmap.parent))
            {
               this._waitingBitmap.parent.removeChild(this._waitingBitmap);
            }
            this._waitingBitmap.bitmapData.dispose();
            this._waitingBitmap = null;
         }
         if(Boolean(this._closeBitmap))
         {
            if(Boolean(this._closeBitmap.parent))
            {
               this._closeBitmap.parent.removeChild(this._closeBitmap);
            }
            this._closeBitmap.bitmapData.dispose();
            this._closeBitmap = null;
         }
         if(Boolean(this._headFigureFrame))
         {
            if(Boolean(this._headFigureFrame.parent))
            {
               this._headFigureFrame.parent.removeChild(this._headFigureFrame);
            }
            this._headFigureFrame.bitmapData.dispose();
            this._headFigureFrame = null;
         }
         this._info = null;
         if(Boolean(this._nameTxt))
         {
            this._nameTxt.dispose();
         }
         this._nameTxt = null;
         if(Boolean(this._portrait))
         {
            this._portrait.dispose();
         }
         this._portrait = null;
         if(Boolean(this._viewInfoBtn))
         {
            this._viewInfoBtn.dispose();
         }
         this._viewInfoBtn = null;
         if(Boolean(this._addFriendBtn))
         {
            this._addFriendBtn.dispose();
         }
         this._addFriendBtn = null;
         if(Boolean(this._kickOutBtn))
         {
            this._kickOutBtn.dispose();
         }
         this._kickOutBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

