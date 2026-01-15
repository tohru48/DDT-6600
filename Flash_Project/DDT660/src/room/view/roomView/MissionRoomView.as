package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.MissionRoomBigMapInfoPanel;
   import room.view.smallMapInfoPanel.MissionRoomSmallMapInfoPanel;
   
   public class MissionRoomView extends BaseRoomView
   {
      
      private var _bigMapInfoPanel:MissionRoomBigMapInfoPanel;
      
      private var _smallMapInfoPanel:MissionRoomSmallMapInfoPanel;
      
      private var _rightBg:MovieClip;
      
      private var _itemListBg:MovieClip;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _btnSwitchTeam:BaseButton;
      
      public function MissionRoomView(info:RoomInfo)
      {
         super(info);
         _info.started = false;
      }
      
      override protected function initView() : void
      {
         this._rightBg = ClassUtils.CreatInstance("asset.background.room.right") as MovieClip;
         PositionUtils.setPos(this._rightBg,"asset.ddtmatchroom.bgPos");
         addChild(this._rightBg);
         this.initPanel();
         this._itemListBg = ClassUtils.CreatInstance("asset.ddtroom.playerItemlist.bg") as MovieClip;
         PositionUtils.setPos(this._itemListBg,"asset.ddtroom.playerItemlist.bgPos");
         addChild(this._itemListBg);
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
         addChild(this._btnSwitchTeam);
         this._btnSwitchTeam.enable = false;
         super.initView();
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.PVR_ROOMLIST_POINT);
            addChild(this._boxButton);
         }
      }
      
      override protected function checkCanStartGame() : Boolean
      {
         var player:RoomPlayer = null;
         var dungeon:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
         if(super.checkCanStartGame())
         {
            if(_info.mapId == 12)
            {
               for each(player in _info.players)
               {
                  if(player.playerInfo.Grade < 18)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.playerGradeNotEnough",18));
                     return false;
                  }
               }
            }
            if(dungeon.Type == MapManager.PVE_ACADEMY_MAP && !super.academyDungeonAllow())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      protected function initPanel() : void
      {
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.room.missionBigMapInfoPanel");
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.room.missionSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
      }
      
      override protected function initTileList() : void
      {
         var p:Point = null;
         var item:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainer = new SimpleTileList(2);
         var space:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.matchRoom.listSpace");
         this._playerItemContainer.hSpace = space.x;
         this._playerItemContainer.vSpace = space.y;
         p = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerListPos");
         this._playerItemContainer.x = this._rightBg.x + p.x;
         this._playerItemContainer.y = this._rightBg.y + p.y;
         for(var i:int = 0; i < 4; i++)
         {
            item = new RoomPlayerItem(i);
            this._playerItemContainer.addChild(item);
            _playerItems.push(item);
         }
         addChild(this._playerItemContainer);
         PositionUtils.setPos(_viewerItems[0],"asset.ddtchallengeroom.ViewerItemPos_0");
         PositionUtils.setPos(_viewerItems[1],"asset.ddtchallengeroom.ViewerItemPos_1");
         addChild(_viewerItems[0]);
         addChild(_viewerItems[1]);
      }
      
      override protected function prepareGame() : void
      {
         GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place,true);
         GameInSocketOut.sendPlayerState(1);
      }
      
      override protected function startGame() : void
      {
         GameInSocketOut.sendGameMissionStart(true);
      }
      
      override protected function __onHostTimer(evt:TimerEvent) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            if(_hostTimer.currentCount >= KICK_TIMEIII && _info.players.length - _info.currentViewerCnt > 1)
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= KICK_TIMEII && _info.players.length - _info.currentViewerCnt == 1)
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= KICK_TIME && _info.players.length - _info.currentViewerCnt > 1 && _info.currentViewerCnt == 0 && _info.isAllReady())
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= HURRY_UP_TIME && _info.isAllReady())
            {
               if(!TaskManager.instance.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      override protected function kickHandler() : void
      {
      }
      
      override protected function __cancelClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place,false);
            GameInSocketOut.sendPlayerState(0);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bigMapInfoPanel))
         {
            ObjectUtils.disposeObject(this._bigMapInfoPanel);
         }
         this._bigMapInfoPanel = null;
         if(Boolean(this._smallMapInfoPanel))
         {
            ObjectUtils.disposeObject(this._smallMapInfoPanel);
         }
         this._smallMapInfoPanel = null;
         if(Boolean(this._rightBg))
         {
            ObjectUtils.disposeObject(this._rightBg);
         }
         this._rightBg = null;
         if(Boolean(this._itemListBg))
         {
            ObjectUtils.disposeObject(this._itemListBg);
         }
         this._itemListBg = null;
         if(Boolean(this._playerItemContainer))
         {
            ObjectUtils.disposeObject(this._playerItemContainer);
         }
         this._playerItemContainer = null;
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         if(Boolean(this._btnSwitchTeam))
         {
            ObjectUtils.disposeObject(this._btnSwitchTeam);
         }
         this._btnSwitchTeam = null;
         if(Boolean(this._boxButton))
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         this._boxButton = null;
      }
   }
}

