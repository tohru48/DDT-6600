package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import league.manager.LeagueManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.MatchRoomBigMapInfoPanel;
   import room.view.smallMapInfoPanel.MatchRoomSmallMapInfoPanel;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import trainer.view.VaneTipView;
   
   public class MatchRoomView extends BaseRoomView
   {
      
      private static const MATCH_NPC:int = 40;
      
      private static const BOTH_MODE_ALERT_TIME:int = 60;
      
      private static const DISABLE_RETURN:int = 20;
      
      private static const MATCH_NPC_ENABLE:Boolean = false;
      
      private var _bg:MovieClip;
      
      private var _itemListBg:MovieClip;
      
      private var _bigMapInfoPanel:MatchRoomBigMapInfoPanel;
      
      private var _smallMapInfoPanel:MatchRoomSmallMapInfoPanel;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _crossZoneBtn:SelectedButton;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _timerII:Timer = new Timer(1000);
      
      private var _leagueTxt:FilterFrameText;
      
      private var _roomIdTxt:FilterFrameText;
      
      private var _roomDesbit:MovieClip;
      
      private var _alert1:BaseAlerFrame;
      
      private var _alert2:BaseAlerFrame;
      
      public function MatchRoomView(info:RoomInfo)
      {
         super(info);
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.addEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.addEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.addEventListener(TimerEvent.TIMER,this.__onTimer);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         EliteGameController.Instance.addEventListener(EliteGameEvent.READY_TIME_OVER,this.__eliteTimeHandler);
      }
      
      protected function __eliteTimeHandler(event:EliteGameEvent) : void
      {
         __startClick(null);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.removeEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.removeEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         EliteGameController.Instance.removeEventListener(EliteGameEvent.READY_TIME_OVER,this.__eliteTimeHandler);
         if(Boolean(this._alert1))
         {
            this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(Boolean(this._alert2))
         {
            this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         }
      }
      
      private function __loadWeakGuild(evt:Event) : void
      {
         var vane:VaneTipView = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(!WeakGuildManager.Instance.switchUserGuide)
         {
            return;
         }
         this.showStart();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_TIP) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN))
         {
            vane = ComponentFactory.Instance.creat("trainer.vane.mainFrame");
            vane.show();
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHALLENGE_TIP) && PlayerManager.Instance.Self.Grade >= 12)
         {
            this.userGuideAlert(Step.CHALLENGE_TIP,"room.view.roomView.MatchRoomView.challengeTip");
         }
      }
      
      private function showStart() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.START_GAME_TIP))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.START_GAME,-45,"trainer.startGameArrowPos","asset.trainer.startGameTipAsset","trainer.startGameTipPos",this);
            NoviceDataManager.instance.firstEnterGame = true;
            NoviceDataManager.instance.saveNoviceData(420,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      private function showWait() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.START_GAME_TIP))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.WAIT_GAME,-45,"trainer.startGameArrowPos","asset.trainer.txtWait","trainer.startGameTipPos",this);
         }
      }
      
      private function userGuideAlert(step:int, info:String) : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(info),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__responseTip);
         SocketManager.Instance.out.syncWeakStep(step);
      }
      
      private function __responseTip(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__responseTip);
         ObjectUtils.disposeObject(alert);
      }
      
      private function __crossZoneChangeHandler(evt:RoomEvent) : void
      {
         this._crossZoneBtn.selected = _info.isCrossZone;
         if(_info.isCrossZone)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.kuaqu"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.benqu"));
         }
      }
      
      private function __onTweentySec(event:RoomEvent) : void
      {
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            return;
         }
         _cancelBtn.enable = true;
      }
      
      private function __onTimer(evt:TimerEvent) : void
      {
         if(MATCH_NPC_ENABLE && this._timerII.currentCount == MATCH_NPC && _info.selfRoomPlayer.isHost)
         {
            this.showMatchNpc();
         }
         if((_info.gameMode == RoomInfo.GUILD_MODE || _info.gameMode == RoomInfo.GUILD_LEAGE_MODE) && this._timerII.currentCount == BOTH_MODE_ALERT_TIME && _info.selfRoomPlayer.isHost)
         {
            this.showBothMode();
         }
      }
      
      private function showMatchNpc() : void
      {
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         alertInfo.data = LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle");
         this._alert1 = AlertManager.Instance.alert("SimpleAlert",alertInfo,LayerManager.ALPHA_BLOCKGOUND);
         this._alert1.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         var msg:ChatData = null;
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            msg = new ChatData();
            msg.channel = ChatInputView.SYS_TIP;
            msg.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(msg);
         }
         this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._alert1.dispose();
      }
      
      override protected function __startHandler(evt:RoomEvent) : void
      {
         super.__startHandler(evt);
         if(_info.started)
         {
            this._timerII.start();
            this.showWait();
         }
         else
         {
            this._timerII.stop();
            this._timerII.reset();
            this.showStart();
         }
      }
      
      private function showBothMode() : void
      {
         this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._alert2.addEventListener(FrameEvent.RESPONSE,this.__onResponseII);
      }
      
      private function __onResponseII(evt:FrameEvent) : void
      {
         var msg:ChatData = null;
         SoundManager.instance.play("008");
         this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         this._alert2.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            msg = new ChatData();
            msg.channel = ChatInputView.SYS_TIP;
            msg.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(msg);
         }
      }
      
      private function __crossZoneClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendGameRoomSetUp(_info.mapId,_info.type,false,_info.roomPass,_info.roomName,3,0,0,!_info.isCrossZone,0);
         this._crossZoneBtn.selected = _info.isCrossZone;
      }
      
      private function __onFightNpc(evt:CrazyTankSocketEvent) : void
      {
         this.showMatchNpc();
      }
      
      override protected function updateButtons() : void
      {
         super.updateButtons();
         this._crossZoneBtn.enable = _info.selfRoomPlayer.isHost && !_info.started;
         this._smallMapInfoPanel._actionStatus = _info.selfRoomPlayer.isHost && !_info.started && _info.type != RoomInfo.RANK_ROOM && _info.type != RoomInfo.SCORE_ROOM;
         if(_info.type == RoomInfo.SCORE_ROOM || _info.type == RoomInfo.RANK_ROOM)
         {
            _inviteBtn.enable = false;
            this._crossZoneBtn.enable = false;
         }
         if(_info.type == RoomInfo.RANK_ROOM)
         {
            _startBtn.removeEventListener(MouseEvent.CLICK,__startClick);
            _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            _startBtn.gotoAndStop(1);
            _startBtn.buttonMode = false;
            _prepareBtn.enabled = false;
            _cancelBtn.enable = false;
         }
         if(_info.gameMode == RoomInfo.ENTERTAINMENT_ROOM || _info.gameMode == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            this._crossZoneBtn.selected = true;
            this._crossZoneBtn.enable = false;
         }
      }
      
      override protected function initView() : void
      {
         this._bg = ClassUtils.CreatInstance("asset.background.room.right") as MovieClip;
         PositionUtils.setPos(this._bg,"asset.ddtmatchroom.bgPos");
         addChild(this._bg);
         this._itemListBg = ClassUtils.CreatInstance("asset.ddtroom.playerItemlist.bg") as MovieClip;
         PositionUtils.setPos(this._itemListBg,"asset.ddtroom.playerItemlist.bgPos");
         addChild(this._itemListBg);
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomBigMapInfoPanel");
         this._bigMapInfoPanel.info = _info;
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
         this._crossZoneBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.crossZoneButton");
         this._crossZoneBtn.selected = _info.isCrossZone;
         addChild(this._crossZoneBtn);
         super.initView();
         if(_info.gameMode == RoomInfo.ENTERTAINMENT_ROOM || _info.gameMode == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            _roomPropView.visible = false;
            this._roomDesbit = ClassUtils.CreatInstance("asset.Entertainment.mode.explain") as MovieClip;
            PositionUtils.setPos(this._roomDesbit,"asset.ddtmatchroom.entertainmentBgPos");
            addChild(this._roomDesbit);
            this._roomIdTxt = ComponentFactory.Instance.creatComponentByStylename("room.roomID.text");
            PositionUtils.setPos(this._roomIdTxt,"asset.ddtmatchroom.entertainmentNumPos");
            this._roomIdTxt.text = RoomManager.Instance.current.ID.toString();
            addChild(this._roomIdTxt);
         }
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.PVP_ROOM_POINT);
            addChild(this._boxButton);
         }
         if(LeagueManager.instance.maxCount != -1 && LeagueManager.instance.isOpen && PlayerManager.Instance.Self.Grade >= 22 && _info.gameMode != RoomInfo.ENTERTAINMENT_ROOM && _info.gameMode != RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            this._leagueTxt = ComponentFactory.Instance.creatComponentByStylename("league.restCount.tipTxt");
            this._leagueTxt.text = LanguageMgr.GetTranslation("ddt.league.restCountTipTxt",LeagueManager.instance.restCount.toString(),LeagueManager.instance.maxCount.toString());
            addChild(this._leagueTxt);
         }
      }
      
      override protected function initTileList() : void
      {
         var item:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainer = new SimpleTileList(2);
         var space:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.matchRoom.listSpace");
         this._playerItemContainer.hSpace = space.x;
         this._playerItemContainer.vSpace = space.y;
         var p:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerListPos");
         this._playerItemContainer.x = this._bg.x + p.x;
         this._playerItemContainer.y = this._bg.y + p.y;
         for(var i:int = 0; i < 4; i++)
         {
            item = new RoomPlayerItem(i);
            this._playerItemContainer.addChild(item);
            _playerItems.push(item);
         }
         addChild(this._playerItemContainer);
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.ddtmatchroom.ViewerItemPos");
            addChild(_viewerItems[0]);
            if(_info.gameMode == RoomInfo.ENTERTAINMENT_ROOM || _info.gameMode == RoomInfo.ENTERTAINMENT_ROOM_PK)
            {
               for(i = 0; i < _viewerItems.length; i++)
               {
                  _viewerItems[i].visible = false;
               }
            }
         }
      }
      
      override protected function __addPlayer(evt:RoomEvent) : void
      {
         var player:RoomPlayer = evt.params[0] as RoomPlayer;
         if(player.isFirstIn)
         {
            SoundManager.instance.play("158");
         }
         if(player.isViewer)
         {
            _viewerItems[player.place - 8].info = player;
         }
         else
         {
            _playerItems[player.place].info = player;
         }
         this.updateButtons();
      }
      
      override protected function __removePlayer(evt:RoomEvent) : void
      {
         var player:RoomPlayer = evt.params[0] as RoomPlayer;
         if(player.place >= 8)
         {
            _viewerItems[player.place - 8].info = null;
         }
         else
         {
            _playerItems[player.place].info = null;
         }
         player.dispose();
         this.updateButtons();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            removeChild(this._bg);
         }
         this._bg = null;
         if(Boolean(this._roomIdTxt))
         {
            removeChild(this._roomIdTxt);
         }
         this._roomIdTxt = null;
         if(Boolean(this._roomDesbit))
         {
            removeChild(this._roomDesbit);
         }
         this._roomDesbit = null;
         if(Boolean(this._boxButton))
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         this._boxButton = null;
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         this._playerItemContainer.dispose();
         this._playerItemContainer = null;
         this._crossZoneBtn.dispose();
         this._crossZoneBtn = null;
         if(Boolean(this._alert1))
         {
            this._alert1.dispose();
         }
         this._alert1 = null;
         if(Boolean(this._alert2))
         {
            this._alert2.dispose();
         }
         this._alert2 = null;
         if(Boolean(this._leagueTxt))
         {
            ObjectUtils.disposeObject(this._leagueTxt);
         }
         this._leagueTxt = null;
      }
   }
}

