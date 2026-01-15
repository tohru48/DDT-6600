package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.data.CampModel;
   import campbattle.data.RoleData;
   import campbattle.event.MapEvent;
   import campbattle.view.rank.ScoreRankView;
   import campbattle.view.roleView.CampBattlePlayer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.socket.CampPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.SmallEnemy;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class CampBattleView extends BaseStateView
   {
      
      private var _mapID:int;
      
      private var _mapLayer:Sprite;
      
      private var _uiLayer:Sprite;
      
      private var _headView:HeadInfoView;
      
      private var _titleView:CampBattleTitle;
      
      private var _backBtn:CampBattleReturnBtn;
      
      private var _smallMap:Bitmap;
      
      private var _mapView:CampBattleMap;
      
      private var _campLight:Bitmap;
      
      private var _progressBar:CampProgress;
      
      private var _statueBtn:CampStatueBtn;
      
      private var _clickDoor:ClickDoor;
      
      private var _battleTimer:CampBattleInTimer;
      
      private var _chatView:ChatView;
      
      private var _hideBtn:CampStateHideBtn;
      
      private var _helpBtn:BaseButton;
      
      private var _rankView:ScoreRankView;
      
      private var _itemList:Array;
      
      public function CampBattleView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this._mapID = int(data);
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._uiLayer = new Sprite();
         addChild(this._uiLayer);
      }
      
      private function initView() : void
      {
         this._headView = new HeadInfoView(PlayerManager.Instance.Self);
         this._uiLayer.addChild(this._headView);
         this._titleView = new CampBattleTitle();
         this._uiLayer.addChild(this._titleView);
         this._titleView.setTitleTxt2(CampBattleManager.instance.model.captureName);
         this._titleView.setTitleTxt4(CampBattleManager.instance.model.winCount.toString());
         this._battleTimer = new CampBattleInTimer();
         this._uiLayer.addChild(this._battleTimer);
         this._backBtn = new CampBattleReturnBtn();
         PositionUtils.setPos(this._backBtn,"ddtCampBattle.views.returnBtnPos");
         this._uiLayer.addChild(this._backBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("stateMap.texpSystem.btnHelp");
         addChild(this._helpBtn);
         this._hideBtn = new CampStateHideBtn();
         PositionUtils.setPos(this._hideBtn,"ddtCampBattle.views.hideBtnPos");
         this._hideBtn.visible = false;
         addChild(this._hideBtn);
         this._rankView = new ScoreRankView();
         PositionUtils.setPos(this._rankView,"ddtCampBattle.views.rankViewPos");
         addChild(this._rankView);
         this.createBg();
         this.addChatView();
      }
      
      public function changeMap(id:int) : void
      {
         this._mapID = id;
         this.createBg();
      }
      
      private function createActItem() : void
      {
         this._itemList = [];
         this._progressBar = new CampProgress();
         PositionUtils.setPos(this._progressBar,"ddtCampBattle.views.progressBarPos");
         this._campLight = ComponentFactory.Instance.creat("camp.campBattle.light");
         if(CampBattleManager.instance.model.isCapture)
         {
            this._progressBar.setCapture();
            if(CampBattleManager.instance.model.captureZoneID == PlayerManager.Instance.Self.ZoneID && CampBattleManager.instance.model.captureUserID == PlayerManager.Instance.Self.ID)
            {
               this._campLight.visible = true;
            }
         }
         this._statueBtn = new CampStatueBtn();
         PositionUtils.setPos(this._statueBtn,"ddtCampBattle.views.statueBtnPos");
         this._itemList.push(this._campLight);
         this._itemList.push(this._statueBtn);
         this._itemList.push(this._progressBar);
      }
      
      private function initEvent() : void
      {
         this._backBtn.returnBtn.addEventListener(MouseEvent.CLICK,this.__onBackBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._hideBtn.addEventListener(MouseEvent.CLICK,this.__onHideBtnClick);
         SocketManager.Instance.addEventListener(CampPackageType.MONSTER_STATE_CHANGE_EVENT,this.__onMonsterStateChange);
         SocketManager.Instance.addEventListener(CampPackageType.ROLE_MOVE_EVENT,this.__onRoleMoveHander);
         SocketManager.Instance.addEventListener(CampPackageType.CAPTURE_MAP_EVENT,this.__onCapMapHander);
         SocketManager.Instance.addEventListener(CampPackageType.ADD_MONSTER_LIST_EVENT,this.__onAddMonstersList);
         SocketManager.Instance.addEventListener(CampPackageType.DOOR_STATUS_EVENT,this.__onDoorstatus);
         CampBattleManager.instance.addEventListener(MapEvent.ENTER_FIGHT,this.__onFighterHander);
         CampBattleManager.instance.addEventListener(MapEvent.TO_OTHER_MAP,this.__onToOhterMapHander);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_STATUE,this.__onCaptureMapHander);
         CampBattleManager.instance.addEventListener(MapEvent.STATUE_GOTO_FIGHT,this.__onStatueGotoFightHander);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_OVER,this.__onCaptureOverHander);
         CampBattleManager.instance.addEventListener(MapEvent.GOTO_FIGHT,this.__onGotoFightHander);
         CampBattleManager.instance.addEventListener(MapEvent.WIN_COUNT_PVP,this.__onUpdateWinCount);
         CampBattleManager.instance.addEventListener(MapEvent.PLAYER_STATE_CHANGE,this.__onPlayerStateChange);
         CampBattleManager.instance.addEventListener(MapEvent.UPDATE_SCORE,this.__onUpdateScoreHander);
         CampBattleManager.instance.addEventListener(MapEvent.ADD_ROLE,this.__onAddRole);
         CampBattleManager.instance.addEventListener(MapEvent.REMOVE_ROLE,this.__onRemoveRole);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrameHander);
      }
      
      protected function __onAddRole(event:MapEvent) : void
      {
         this._mapView.playerModel.add(event.data[0],event.data[1]);
      }
      
      protected function __onRemoveRole(event:MapEvent) : void
      {
         this._mapView.playerModel.remove(event.data);
      }
      
      protected function __onUpdateWinCount(event:MapEvent) : void
      {
         if(Boolean(this._titleView))
         {
            this._titleView.setTitleTxt4(CampBattleManager.instance.model.winCount.toString());
         }
      }
      
      private function __onDoorstatus(evt:CrazyTankSocketEvent) : void
      {
         CampBattleManager.instance.model.doorIsOpen = true;
         this._clickDoor.doorStatus();
      }
      
      private function __onUpdateScoreHander(event:MapEvent) : void
      {
         this._headView.updateScore(CampBattleManager.instance.model.myScore);
      }
      
      private function __onEnterFrameHander(event:Event) : void
      {
         var p:Point = null;
         var mainRole:CampBattlePlayer = null;
         var fp:Point = null;
         var disX:int = 0;
         var disY:int = 0;
         if(CampBattleManager.instance.model.isCapture)
         {
            p = new Point(1459,864);
            if(Boolean(this._mapView) && Boolean(this._mapView.getMainRole()))
            {
               mainRole = this._mapView.getMainRole();
               fp = new Point(mainRole.x,mainRole.y);
               disX = Math.abs(fp.x - p.x);
               disY = Math.abs(fp.y - p.y);
               if(disX > 300 || disY > 200)
               {
                  if(mainRole.playerInfo.isCapture)
                  {
                     SocketManager.Instance.out.captureMap(false);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.outofCaptrue"));
                  }
               }
            }
         }
      }
      
      private function createBg() : void
      {
         if(CampBattleManager.instance.model.isShowResurrectView)
         {
            this.createRrsurrectView();
         }
         if(this._mapID == 0)
         {
            this._titleView.visible = false;
            this._clickDoor = new ClickDoor();
            PositionUtils.setPos(this._clickDoor,"ddtCampBattle.views.clickDoorPos");
            this._smallMap = ComponentFactory.Instance.creat("campbattle.passSmall");
            this.creatMap(CampBattleManager.resClassUrl,CampBattleManager.PVE_MAPRESOURCEURL,CampBattleManager.instance.model.playerModel,CampBattleManager.instance.model.monsterList,[this._clickDoor],this._smallMap);
         }
         else if(this._mapID == 1)
         {
            this._titleView.visible = true;
            this.createActItem();
            this._smallMap = ComponentFactory.Instance.creat("campbattle.pkSmall");
            this.creatMap(CampBattleManager.resClassUrl2,CampBattleManager.PVP_MAPRESOURCEURL,CampBattleManager.instance.model.playerModel,CampBattleManager.instance.model.monsterList,this._itemList,this._smallMap);
         }
      }
      
      private function addChatView() : void
      {
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
      }
      
      private function __onStatueGotoFightHander(event:MapEvent) : void
      {
         var p:Point = new Point(event.data[0],event.data[1]);
         var zoneID:int = CampBattleManager.instance.model.captureZoneID;
         var userID:int = CampBattleManager.instance.model.captureUserID;
         var mainRole:CampBattlePlayer = this._mapView.getMainRole();
         if(this._mapView.getCurrRole(zoneID,userID).playerInfo.team == mainRole.playerInfo.team)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.statuCaptured"));
            return;
         }
         if(!mainRole.playerInfo.isDead)
         {
            this._mapView.checkPonitDistance(p,SocketManager.Instance.out.enterPTPFight,userID,zoneID);
         }
      }
      
      private function creatMap(clsStr:String = null, resStr:String = null, playerModel:DictionaryData = null, monsterModel:DictionaryData = null, itemList:Array = null, smallMap:Bitmap = null) : void
      {
         this._mapView = new CampBattleMap(clsStr,resStr,playerModel,monsterModel,itemList,smallMap);
         this._mapLayer.addChild(this._mapView);
      }
      
      private function __onGotoFightHander(event:MapEvent) : void
      {
         var p:Point = new Point(event.data[0],event.data[1]);
         var zoneID:int = int(event.data[2]);
         var userID:int = int(event.data[3]);
         if(Boolean(this._mapView.getMainRole()))
         {
            if(!this._mapView.getMainRole().playerInfo.isDead)
            {
               this._mapView.checkPonitDistance(p,SocketManager.Instance.out.enterPTPFight,userID,zoneID);
            }
         }
      }
      
      private function __onCaptureMapHander(event:MapEvent) : void
      {
         var p:Point = new Point(event.data[0],event.data[1]);
         this._mapView.checkPonitDistance(p,this.captureMap);
      }
      
      private function captureMap() : void
      {
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.CAPTURE_START));
      }
      
      private function __onCapMapHander(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var model:CampModel = CampBattleManager.instance.model;
         model.isCapture = pkg.readBoolean();
         model.captureZoneID = pkg.readInt();
         model.captureUserID = pkg.readInt();
         model.captureName = pkg.readUTF();
         if(model.captureName.length > 4)
         {
            model.captureName = model.captureName.replace(4,"......");
         }
         model.captureTeam = pkg.readInt();
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.CAPTURE_OVER,[model.captureZoneID,model.captureUserID]));
         var role:RoleData = this.getRoleData(model.captureZoneID,model.captureUserID);
         if(Boolean(role))
         {
            role.isCapture = model.isCapture;
         }
      }
      
      private function __onAddMonstersList(evt:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var id:int = 0;
         var living:SmallEnemy = null;
         var str:String = null;
         var outPos:Point = null;
         var npcID:int = 0;
         var pkg:PackageIn = evt.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            CampBattleManager.instance.model.monsterCount = pkg.readInt();
            count = pkg.readInt();
            for(i = 0; i < count; i++)
            {
               id = pkg.readInt();
               living = new SmallEnemy(id,2,1000);
               living.typeLiving = 2;
               living.actionMovieName = pkg.readUTF();
               str = pkg.readUTF();
               living.direction = 1;
               outPos = new Point(pkg.readInt(),pkg.readInt());
               living.name = "虫子";
               living.stateType = pkg.readInt();
               npcID = pkg.readInt();
               CampBattleManager.instance.model.monsterList.add(living.LivingID,living);
               if(npcID > 0)
               {
                  if(CampBattleManager.instance.model.monsterCount == 10)
                  {
                     living.pos = new Point(CampBattleManager.instance.model.monsterPosList[i][0],CampBattleManager.instance.model.monsterPosList[i][1]);
                  }
                  else
                  {
                     living.pos = outPos;
                  }
               }
               else
               {
                  living.pos = new Point(CampBattleManager.instance.model.monsterPosList[i][0],CampBattleManager.instance.model.monsterPosList[i][1]);
               }
            }
            dispatchEvent(new MapEvent(MapEvent.PVE_COUNT));
         }
      }
      
      private function __onCaptureOverHander(event:MapEvent) : void
      {
         var zoneID:int = int(event.data[0]);
         var userID:int = int(event.data[1]);
         if(CampBattleManager.instance.model.isCapture)
         {
            if(Boolean(this._titleView))
            {
               this._titleView.setTitleTxt2(CampBattleManager.instance.model.captureName);
               this._titleView.setTitleTxt4("0");
            }
            this._statueBtn._arrowMc.stop();
            this._statueBtn._arrowMc.visible = false;
         }
         else if(Boolean(this._titleView))
         {
            this._titleView.setTitleTxt2(LanguageMgr.GetTranslation("ddt.campBattle.NOcapture"));
            this._titleView.setTitleTxt4("0");
         }
         var otherPlayer:CampBattlePlayer = this._mapView.getCurrRole(zoneID,userID);
         if(Boolean(otherPlayer))
         {
            otherPlayer.setCaptureVisible(CampBattleManager.instance.model.isCapture);
         }
         var selfPlayer:CampBattlePlayer = CampBattlePlayer(this._mapView.getMainRole());
         if(Boolean(selfPlayer))
         {
            if(selfPlayer.playerInfo.zoneID == zoneID && selfPlayer.playerInfo.ID == userID)
            {
               this._campLight.visible = CampBattleManager.instance.model.isCapture;
            }
         }
      }
      
      private function __onRoleMoveHander(event:CrazyTankSocketEvent) : void
      {
         var x:int = 0;
         var y:int = 0;
         var zoneID:int = 0;
         var userID:int = 0;
         var role:RoleData = null;
         var p:Point = null;
         var pkg:PackageIn = event.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            x = pkg.readInt();
            y = pkg.readInt();
            zoneID = pkg.readInt();
            userID = pkg.readInt();
            role = this.getRoleData(zoneID,userID);
            if(Boolean(role))
            {
               role.posX = x;
               role.posY = y;
               role.stateType = 1;
               if(PlayerManager.Instance.Self.ZoneID == zoneID && PlayerManager.Instance.Self.ID == userID)
               {
                  return;
               }
               p = new Point(x,y);
               this._mapView.roleMoves(zoneID,userID,p);
            }
         }
      }
      
      private function __onToOhterMapHander(event:MapEvent) : void
      {
         var p:Point = new Point(event.data[0],event.data[1]);
         if(!this._mapView.getMainRole().playerInfo.isDead)
         {
            this._mapView.checkPonitDistance(p,SocketManager.Instance.out.changeMap);
         }
      }
      
      private function __onPlayerStateChange(evt:MapEvent) : void
      {
         this._mapView.setRoleState(evt.data[0],evt.data[1],evt.data[2]);
      }
      
      private function __onMonsterStateChange(evt:CrazyTankSocketEvent) : void
      {
         var monsterID:int = 0;
         var type:int = 0;
         var pkg:PackageIn = evt.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            monsterID = pkg.readInt();
            type = pkg.readInt();
            if(type == 4)
            {
               CampBattleManager.instance.model.monsterList.remove(monsterID);
            }
            else
            {
               this._mapView.setMonsterState(monsterID,type);
            }
         }
      }
      
      private function getRoleData(zoneID:int, userID:int) : RoleData
      {
         var key:String = zoneID + "_" + userID;
         var data:RoleData = null;
         if(Boolean(CampBattleManager.instance.model.playerModel))
         {
            data = CampBattleManager.instance.model.playerModel[key];
         }
         return data;
      }
      
      private function createRrsurrectView() : void
      {
         CampBattleManager.instance.model.isShowResurrectView = false;
         var _resurrectView:CampBattleResurrectView = new CampBattleResurrectView(CampBattleManager.instance.model.liveTime);
         _resurrectView.addEventListener(Event.COMPLETE,this.__onResurrectHandler,false,0,true);
         LayerManager.Instance.addToLayer(_resurrectView,LayerManager.GAME_DYNAMIC_LAYER,true);
      }
      
      private function __onResurrectHandler(event:Event) : void
      {
         var _resurrectView:CampBattleResurrectView = event.currentTarget as CampBattleResurrectView;
         if(Boolean(_resurrectView))
         {
            _resurrectView.removeEventListener(Event.COMPLETE,this.__onResurrectHandler);
            _resurrectView.dispose();
            _resurrectView = null;
         }
         SocketManager.Instance.out.resurrect(false,false);
         this._mapView.setRoleState(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID,1);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __onFighterHander(event:MapEvent) : void
      {
         var p:Point = new Point(event.data[0],event.data[1]);
         var id:int = int(event.data[2]);
         if(!this._mapView || !this._mapView.getMainRole() || !this._mapView.getMainRole().playerInfo || this._mapView.getMainRole().playerInfo.isDead)
         {
            return;
         }
         this._mapView.checkPonitDistance(p,SocketManager.Instance.out.CampbattleEnterFight,id);
      }
      
      protected function __onHideBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._mapView.hideRoles(this._hideBtn.isHide);
      }
      
      protected function __onHelpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var helpframe:CampBattleHelpView = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.views.helpView");
         helpframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(helpframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.frameEvent);
         event.currentTarget.dispose();
      }
      
      protected function __onBackBtnClick(event:MouseEvent) : void
      {
         var msg:String = LanguageMgr.GetTranslation("ddt.campBattle.outCampBattle");
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__onConfirm);
      }
      
      protected function __onConfirm(event:FrameEvent) : void
      {
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.outCampBatttle();
            StateManager.setState(StateType.MAIN);
         }
         confirmFrame.dispose();
         confirmFrame = null;
      }
      
      override public function getType() : String
      {
         return StateType.CAMP_BATTLE_SCENE;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         super.dispose();
      }
      
      private function removeEvent() : void
      {
         this._backBtn.returnBtn.removeEventListener(MouseEvent.CLICK,this.__onBackBtnClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._hideBtn.removeEventListener(MouseEvent.CLICK,this.__onHideBtnClick);
         SocketManager.Instance.removeEventListener(CampPackageType.MONSTER_STATE_CHANGE_EVENT,this.__onMonsterStateChange);
         SocketManager.Instance.removeEventListener(CampPackageType.ROLE_MOVE_EVENT,this.__onRoleMoveHander);
         SocketManager.Instance.removeEventListener(CampPackageType.CAPTURE_MAP_EVENT,this.__onCapMapHander);
         SocketManager.Instance.removeEventListener(CampPackageType.ADD_MONSTER_LIST_EVENT,this.__onAddMonstersList);
         SocketManager.Instance.removeEventListener(CampPackageType.DOOR_STATUS_EVENT,this.__onDoorstatus);
         CampBattleManager.instance.removeEventListener(MapEvent.ENTER_FIGHT,this.__onFighterHander);
         CampBattleManager.instance.removeEventListener(MapEvent.TO_OTHER_MAP,this.__onToOhterMapHander);
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_STATUE,this.__onCaptureMapHander);
         CampBattleManager.instance.removeEventListener(MapEvent.STATUE_GOTO_FIGHT,this.__onStatueGotoFightHander);
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_OVER,this.__onCaptureOverHander);
         CampBattleManager.instance.removeEventListener(MapEvent.GOTO_FIGHT,this.__onGotoFightHander);
         CampBattleManager.instance.removeEventListener(MapEvent.WIN_COUNT_PVP,this.__onUpdateWinCount);
         CampBattleManager.instance.removeEventListener(MapEvent.PLAYER_STATE_CHANGE,this.__onPlayerStateChange);
         CampBattleManager.instance.removeEventListener(MapEvent.UPDATE_SCORE,this.__onUpdateScoreHander);
         CampBattleManager.instance.removeEventListener(MapEvent.ADD_ROLE,this.__onAddRole);
         CampBattleManager.instance.removeEventListener(MapEvent.REMOVE_ROLE,this.__onRemoveRole);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrameHander);
      }
      
      private function removeMap() : void
      {
         if(Boolean(this._smallMap))
         {
            this._smallMap.bitmapData.dispose();
         }
         this._smallMap = null;
         if(Boolean(this._mapView))
         {
            this._mapView.dispose();
         }
         this._mapView = null;
         if(Boolean(this._clickDoor))
         {
            this._clickDoor.dispose();
         }
         this._clickDoor = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeMap();
         if(Boolean(this._campLight))
         {
            this._campLight.bitmapData.dispose();
         }
         this._campLight = null;
         if(Boolean(this._headView))
         {
            this._headView.dispose();
         }
         this._headView = null;
         if(Boolean(this._titleView))
         {
            this._titleView.dispose();
         }
         this._titleView = null;
         if(Boolean(this._backBtn))
         {
            this._backBtn.dispose();
         }
         this._backBtn = null;
         if(Boolean(this._progressBar))
         {
            this._progressBar.dispose();
         }
         this._progressBar = null;
         if(Boolean(this._statueBtn))
         {
            this._statueBtn.dispose();
         }
         this._statueBtn = null;
         if(Boolean(this._battleTimer))
         {
            this._battleTimer.dispose();
         }
         this._battleTimer = null;
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
         }
         this._helpBtn = null;
         if(Boolean(this._hideBtn))
         {
            this._hideBtn.dispose();
         }
         this._hideBtn = null;
         if(Boolean(this._rankView))
         {
            this._rankView.dispose();
         }
         this._rankView = null;
         if(Boolean(this._mapLayer))
         {
            this._mapLayer = null;
         }
         if(Boolean(this._uiLayer))
         {
            this._uiLayer = null;
         }
      }
   }
}

