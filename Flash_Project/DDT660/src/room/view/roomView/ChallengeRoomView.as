package room.view.roomView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.view.DefyAfficheViewFrame;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.smallMapInfoPanel.ChallengeRoomSmallMapInfoPanel;
   
   public class ChallengeRoomView extends BaseRoomView implements Disposeable
   {
      
      public static const PLAYER_POS_CHANGE:String = "playerposchange";
      
      private var _bg:MovieClip;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _playerItemContainers:Vector.<SimpleTileList>;
      
      private var _smallMapInfoPanel:ChallengeRoomSmallMapInfoPanel;
      
      private var _blueTeam:Bitmap;
      
      private var _redTeam:Bitmap;
      
      private var _blueTeamBitmap:MovieClip;
      
      private var _redTeamBitmap:MovieClip;
      
      private var _self:SelfInfo;
      
      public function ChallengeRoomView(info:RoomInfo)
      {
         super(info);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._btnSwitchTeam.dispose();
         this._smallMapInfoPanel.dispose();
         removeChild(this._bg);
         this._bg = null;
         this._btnSwitchTeam = null;
         this._playerItemContainers = null;
         this._smallMapInfoPanel = null;
      }
      
      override protected function updateButtons() : void
      {
         var item:RoomPlayerItem = null;
         super.updateButtons();
         if(_info.selfRoomPlayer.isViewer)
         {
            this._btnSwitchTeam.enable = false;
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            this._btnSwitchTeam.enable = _startBtn.visible;
            _cancelBtn.visible = !_startBtn.visible;
         }
         else
         {
            this._btnSwitchTeam.enable = _prepareBtn.visible;
            _cancelBtn.visible = !_prepareBtn.visible;
         }
         var sbInBlueTeam:Boolean = false;
         var sbInRedTeam:Boolean = false;
         for(var i:int = 0; i < _playerItems.length; i++)
         {
            item = _playerItems[i] as RoomPlayerItem;
            if(Boolean(item.info) && item.info.team == RoomPlayer.BLUE_TEAM)
            {
               sbInBlueTeam = true;
            }
            if(Boolean(item.info) && item.info.team == RoomPlayer.RED_TEAM)
            {
               sbInRedTeam = true;
            }
         }
         if(!sbInBlueTeam || !sbInRedTeam)
         {
            _startBtn.removeEventListener(MouseEvent.CLICK,__startClick);
            _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            if(Boolean(_startBtn) && Boolean(_startBtn.hasOwnProperty("startA")))
            {
               _startBtn["startA"].gotoAndStop(1);
            }
            _startBtn.buttonMode = false;
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._btnSwitchTeam.addEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      override protected function initTileList() : void
      {
         var item1:RoomPlayerItem = null;
         var item2:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainers = new Vector.<SimpleTileList>();
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.RED_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].hSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].hSpace = 2;
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].vSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].vSpace = 4;
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1],"asset.ddtchallengeRoom.BlueTeamPos");
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.RED_TEAM - 1],"asset.ddtchallengeRoom.RedTeamPos");
         for(var i:int = 0; i < 8; i += 2)
         {
            item1 = new RoomPlayerItem(i);
            this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].addChild(item1);
            _playerItems.push(item1);
            item2 = new RoomPlayerItem(i + 1);
            this._playerItemContainers[RoomPlayer.RED_TEAM - 1].addChild(item2);
            _playerItems.push(item2);
         }
         addChild(this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1]);
         addChild(this._playerItemContainers[RoomPlayer.RED_TEAM - 1]);
         PositionUtils.setPos(_viewerItems[0],"asset.ddtchallengeroom.ViewerItemPos_0");
         PositionUtils.setPos(_viewerItems[1],"asset.ddtchallengeroom.ViewerItemPos_1");
         addChild(_viewerItems[0]);
         addChild(_viewerItems[1]);
         addChild(this._blueTeam);
         addChild(this._redTeam);
      }
      
      override protected function initView() : void
      {
         this._bg = ClassUtils.CreatInstance("asset.background.room.right") as MovieClip;
         PositionUtils.setPos(this._bg,"asset.ddtmatchroom.bgPos");
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.smallMapInfoPanel");
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
         this._blueTeamBitmap = ClassUtils.CreatInstance("asset.ddtChallengeRoom.blueBg") as MovieClip;
         PositionUtils.setPos(this._blueTeamBitmap,"asset.ddtchallengeroom.blueBgpos");
         this._redTeamBitmap = ClassUtils.CreatInstance("asset.ddtChallengeRoom.redBg") as MovieClip;
         PositionUtils.setPos(this._redTeamBitmap,"asset.ddtchallengeroom.redBgpos");
         this._blueTeam = ComponentFactory.Instance.creatBitmap("asset.ddtChallengeRoom.blueTeam");
         this._redTeam = ComponentFactory.Instance.creatBitmap("asset.ddtChallengeRoom.readTeam");
         this._smallMapInfoPanel.info = _info;
         this._self = PlayerManager.Instance.Self;
         addChild(this._bg);
         addChild(this._blueTeamBitmap);
         addChild(this._redTeamBitmap);
         addChild(this._btnSwitchTeam);
         addChild(this._smallMapInfoPanel);
         super.initView();
         if(!_info.selfRoomPlayer.isViewer)
         {
            this.openDefyAffiche();
         }
      }
      
      private function openDefyAffiche() : void
      {
         var defyAfficheViewFrame:DefyAfficheViewFrame = null;
         if(!_info || !_info.defyInfo)
         {
            return;
         }
         for(var i:int = 0; i <= _info.defyInfo[0].length; i++)
         {
            if(this._self.NickName == _info.defyInfo[0][i])
            {
               if(_info.defyInfo[1].length != 0)
               {
                  defyAfficheViewFrame = ComponentFactory.Instance.creatComponentByStylename("game.view.defyAfficheViewFrame");
                  defyAfficheViewFrame.roomInfo = _info;
                  defyAfficheViewFrame.show();
               }
            }
         }
      }
      
      override protected function __updatePlayerItems(evt:RoomEvent) : void
      {
         initPlayerItems();
         this.updateButtons();
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._btnSwitchTeam.removeEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      private function __switchTeam(evt:MouseEvent) : void
      {
         SoundManager.instance.play("012");
         if(!_info.selfRoomPlayer.isReady || _info.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameTeam(int(_info.selfRoomPlayer.team == RoomPlayer.BLUE_TEAM ? RoomPlayer.RED_TEAM : RoomPlayer.BLUE_TEAM));
         }
      }
   }
}

