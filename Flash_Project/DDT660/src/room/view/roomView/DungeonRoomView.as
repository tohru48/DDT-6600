package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import bagAndInfo.energyData.EnergyData;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import overSeasCommunity.OverSeasCommunController;
   import overSeasCommunity.overseas.vo.OverSeasCommunType;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomDupSimpleTipFram;
   import room.view.RoomNotEnoughEnergyAlert;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.DungeonBigMapInfoPanel;
   import room.view.chooseMap.DungeonChooseMapFrame;
   import room.view.smallMapInfoPanel.DungeonSmallMapInfoPanel;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import trainer.view.VaneTipView;
   
   public class DungeonRoomView extends BaseRoomView
   {
      
      private var _bigMapInfoPanel:DungeonBigMapInfoPanel;
      
      private var _smallMapInfoPanel:DungeonSmallMapInfoPanel;
      
      private var _rightBg:MovieClip;
      
      private var _itemListBg:MovieClip;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _singleAlsert:BaseAlerFrame;
      
      public function DungeonRoomView(info:RoomInfo)
      {
         super(info);
      }
      
      override protected function initView() : void
      {
         this._rightBg = ClassUtils.CreatInstance("asset.background.room.right") as MovieClip;
         PositionUtils.setPos(this._rightBg,"asset.ddtmatchroom.bgPos");
         addChild(this._rightBg);
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.BigMapInfoPanel");
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.SmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
         this._itemListBg = ClassUtils.CreatInstance("asset.ddtroom.playerItemlist.bg") as MovieClip;
         PositionUtils.setPos(this._itemListBg,"asset.ddtroom.playerItemlist.bgPos");
         addChild(this._itemListBg);
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
         addChild(this._btnSwitchTeam);
         this._btnSwitchTeam.enable = false;
         super.initView();
         if(OverSeasCommunController.instance().communityType == OverSeasCommunType.VIETNAME_COMMUNITY)
         {
            OverSeasCommunController.instance().checkKillHeroBoss();
         }
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.PVP_ROOM_POINT);
            addChild(this._boxButton);
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ENERGY_NOT_ENOUGH,this.notEnoughEnergyBuy);
      }
      
      override protected function __prepareClick(evt:MouseEvent) : void
      {
         super.__prepareClick(evt);
         if(Boolean(PlayerManager.Instance.Self.dungeonFlag[_info.mapId]) && PlayerManager.Instance.Self.dungeonFlag[_info.mapId] == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
         }
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ENERGY_NOT_ENOUGH,this.notEnoughEnergyBuy);
      }
      
      private function __loadWeakGuild(evt:Event) : void
      {
         var vane:VaneTipView = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(!WeakGuildManager.Instance.switchUserGuide)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_TIP) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN))
         {
            vane = ComponentFactory.Instance.creat("trainer.vane.mainFrame");
            vane.show();
         }
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
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.ddtchallengeroom.ViewerItemPos_0");
            PositionUtils.setPos(_viewerItems[1],"asset.ddtchallengeroom.ViewerItemPos_1");
            addChild(_viewerItems[0]);
            addChild(_viewerItems[1]);
         }
      }
      
      override protected function checkCanStartGame() : Boolean
      {
         var player:RoomPlayer = null;
         var mapChooser:DungeonChooseMapFrame = null;
         var dungeon:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
         if(super.checkCanStartGame())
         {
            if(_info.type == RoomInfo.FRESHMAN_ROOM || _info.type == RoomInfo.FARM_BOSS)
            {
               return true;
            }
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
            if(_info.mapId == 0 || _info.mapId == 10000)
            {
               mapChooser = new DungeonChooseMapFrame();
               mapChooser.show();
               dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
               return false;
            }
            if(RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt == 1 && (dungeon.Type != MapManager.PVE_ACADEMY_MAP || _info.mapId == 1405))
            {
               this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent"),"",LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               this._singleAlsert.moveEnable = false;
               this._singleAlsert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_4))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"guide.dungeon.step7ArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER));
               }
               return false;
            }
            if(dungeon.Type == MapManager.PVE_ACADEMY_MAP && !super.academyDungeonAllow())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._singleAlsert.dispose();
         this._singleAlsert = null;
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM && PlayerManager.Instance.Self.activityTanabataNum < 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.ActivityDungeon.roomPromptDes"));
               return;
            }
            this.checkSendCheckEnergy();
         }
         else if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_4))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,-45,"trainer.startGameArrowPos","asset.trainer.startGameTipAsset","trainer.startGameTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      override protected function kickHandler() : void
      {
         GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,false,_info.roomPass,_info.roomName,1,0,0,false,0);
         super.kickHandler();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._itemListBg))
         {
            ObjectUtils.disposeObject(this._itemListBg);
            this._itemListBg = null;
         }
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
         if(Boolean(this._singleAlsert))
         {
            this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._singleAlsert.dispose();
            this._singleAlsert = null;
         }
         this._boxButton = null;
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         removeChild(this._rightBg);
         this._rightBg = null;
         this._playerItemContainer.dispose();
         this._playerItemContainer = null;
         this._btnSwitchTeam.dispose();
         this._btnSwitchTeam = null;
      }
      
      override protected function __startClick(evt:MouseEvent) : void
      {
         if(!_info.isAllReady())
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.checkCanStartGame())
         {
            this.checkSendCheckEnergy();
         }
      }
      
      override protected function prepareGame() : void
      {
         this.checkSendCheckEnergy();
      }
      
      private function checkSendCheckEnergy() : void
      {
         if(RoomManager.Instance.isNotAlertEnergyNotEnough)
         {
            this.doSendStartOrPreGame();
         }
         else
         {
            GameInSocketOut.sendStartOrPreCheckEnergy();
         }
      }
      
      private function doStart() : void
      {
         startGame();
         _info.started = true;
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_4))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_GUIDE_4);
            NewHandContainer.Instance.clearArrowByID(ArrowType.DUNGEON_GUIDE);
         }
      }
      
      private function doPrepareGame() : void
      {
         GameInSocketOut.sendPlayerState(1);
      }
      
      private function doSendStartOrPreGame() : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            this.doStart();
         }
         else
         {
            this.doPrepareGame();
         }
      }
      
      protected function notEnoughEnergyBuy(e:CrazyTankSocketEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         var isAlert:Boolean = e.pkg.readBoolean();
         if(!isAlert)
         {
            this.doSendStartOrPreGame();
         }
         else
         {
            alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.energy.takeCardOutBuyPromptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"RoomNotEnoughEnergyAlert",60,false,AlertManager.SELECTBTN);
            alertAsk.moveEnable = false;
            alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
         }
      }
      
      protected function __alertBuyEnergy(event:FrameEvent) : void
      {
         var energyData:EnergyData = null;
         var confirmFrame2:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var frame:RoomNotEnoughEnergyAlert = event.currentTarget as RoomNotEnoughEnergyAlert;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
         RoomManager.Instance.isNotAlertEnergyNotEnough = frame.isNoPrompt;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               ObjectUtils.disposeObject(frame);
               return;
            }
            energyData = PlayerManager.Instance.energyData[PlayerManager.Instance.Self.buyEnergyCount + 1];
            if(!energyData)
            {
               ObjectUtils.disposeObject(frame);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.energy.cannotbuyEnergy"));
               return;
            }
            if(frame.isBand && PlayerManager.Instance.Self.BandMoney < energyData.Money)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.energy.changeMoneyCostTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.__changeMoneyBuyConfirm,false,0,true);
            }
            else if(!frame.isBand && PlayerManager.Instance.Self.Money < energyData.Money)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendBuyEnergy(frame.isBand);
            }
         }
         else if(event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            this.doSendStartOrPreGame();
         }
         ObjectUtils.disposeObject(frame);
      }
      
      protected function __changeMoneyBuyConfirm(evt:FrameEvent) : void
      {
         var energyData:EnergyData = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__changeMoneyBuyConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            energyData = PlayerManager.Instance.energyData[PlayerManager.Instance.Self.buyEnergyCount + 1];
            if(PlayerManager.Instance.Self.Money < energyData.Money)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBuyEnergy(false);
         }
      }
      
      private function _showBoGuTip() : void
      {
         var boGu:RoomDupSimpleTipFram = null;
         if(PlayerManager.Instance.Self._isDupSimpleTip)
         {
            PlayerManager.Instance.Self._isDupSimpleTip = false;
            boGu = ComponentFactory.Instance.creatComponentByStylename("room.RoomDupSimpleTipFram");
            boGu.show();
         }
      }
   }
}

