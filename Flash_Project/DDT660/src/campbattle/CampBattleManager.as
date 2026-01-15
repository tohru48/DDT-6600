package campbattle
{
   import campbattle.data.CampModel;
   import campbattle.data.RoleData;
   import campbattle.event.MapEvent;
   import campbattle.view.rank.CampRankView;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.rank.RankData;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.data.socket.CampPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import game.model.SmallEnemy;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class CampBattleManager extends EventDispatcher
   {
      
      private static var _instance:CampBattleManager;
      
      public static const resClassUrl:String = "tank.campBattle.Map-1";
      
      public static const resClassUrl2:String = "tank.campBattle.Map-2";
      
      public static const PVE_MAPRESOURCEURL:String = PathManager.SITE_MAIN + "image/camp/map/campBattlePassage.swf";
      
      public static const PVP_MAPRESOURCEURL:String = PathManager.SITE_MAIN + "image/camp/map/campBattleMap.swf";
      
      private var _lastCreatTime:int;
      
      private var _model:CampModel;
      
      private var _endTime:Date;
      
      private var completeCount:int = 0;
      
      public function CampBattleManager(target:IEventDispatcher = null)
      {
         super(target);
         this._model = new CampModel();
      }
      
      public static function get instance() : CampBattleManager
      {
         if(!_instance)
         {
            _instance = new CampBattleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CampPackageType.INIT_SECEN_EVENT,this.__onInitSecenHander);
         SocketManager.Instance.addEventListener(CampPackageType.ACTION_ISOPEN_EVENT,this.__onActionIsOpenHander);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CampPackageType.ADD_ROLE_LIST_EVENT,this.__onAddRoleList);
         SocketManager.Instance.addEventListener(CampPackageType.OUT_CAMPBATTLE_EVENT,this.__onOutBattleHander);
         SocketManager.Instance.addEventListener(CampPackageType.CAMP_SOCER_RANK_EVENT,this.__onCampScoreRankHander);
         SocketManager.Instance.addEventListener(CampPackageType.PER_SCORE_RANK_EVENT,this.__onPerScoreRankHander);
         SocketManager.Instance.addEventListener(CampPackageType.REMOVE_ROLE_EVENT,this.__onRemoveRoleChange);
         SocketManager.Instance.addEventListener(CampPackageType.WIN_COUNT_PTP_EVENT,this.__onWinCountHander);
         SocketManager.Instance.addEventListener(CampPackageType.PLAYER_STATE_CHANGE_EVENT,this.__onPlayerStateChange);
         SocketManager.Instance.addEventListener(CampPackageType.UPDATE_SCORE_EVENT,this.__onUpdateScoreHander);
      }
      
      protected function __onPlayerStateChange(event:CrazyTankSocketEvent) : void
      {
         var zoneID:int = 0;
         var userID:int = 0;
         var type:int = 0;
         var timeCount:int = 0;
         var role:RoleData = null;
         var pkg:PackageIn = event.pkg;
         if(!this._model.isFighting)
         {
            zoneID = pkg.readInt();
            userID = pkg.readInt();
            type = pkg.readInt();
            timeCount = pkg.readInt();
            role = this.getRoleData(zoneID,userID);
            if(Boolean(role))
            {
               if(timeCount > 0)
               {
                  type = 4;
                  role.stateType = 4;
                  role.isDead = true;
               }
               else
               {
                  role.stateType = type;
               }
            }
            dispatchEvent(new MapEvent(MapEvent.PLAYER_STATE_CHANGE,[zoneID,userID,type]));
         }
      }
      
      protected function __onInitSecenHander(event:CrazyTankSocketEvent) : void
      {
         var roleData:RoleData = null;
         var id:int = 0;
         var living:SmallEnemy = null;
         var str:String = null;
         var outPos:Point = null;
         var npcid:int = 0;
         var pkg:PackageIn = event.pkg;
         var mapIndex:int = pkg.readInt();
         this._model.monsterCount = pkg.readInt();
         this._model.isCapture = pkg.readBoolean();
         if(this._model.isCapture)
         {
            this._model.captureZoneID = pkg.readInt();
            this._model.captureUserID = pkg.readInt();
         }
         else
         {
            this._model.captureName = LanguageMgr.GetTranslation("ddt.campBattle.NOcapture");
            this._model.captureZoneID = 0;
            this._model.captureUserID = 0;
         }
         var count:int = pkg.readInt();
         this._model.playerModel.clear();
         for(var i:int = 0; i < count; i++)
         {
            roleData = new RoleData();
            roleData.ID = pkg.readInt();
            roleData.zoneID = pkg.readInt();
            roleData.Sex = pkg.readBoolean();
            roleData.name = pkg.readUTF();
            roleData.team = pkg.readInt();
            roleData.posX = pkg.readInt();
            roleData.posY = pkg.readInt();
            roleData.stateType = pkg.readInt();
            roleData.timerCount = pkg.readInt();
            roleData.baseURl = PathManager.SITE_MAIN + "image/camp/";
            roleData.isVip = pkg.readBoolean();
            roleData.vipLev = pkg.readInt();
            roleData.MountsType = pkg.readInt();
            if(this._model.captureZoneID == roleData.zoneID && this._model.captureUserID == roleData.ID)
            {
               roleData.isCapture = true;
               this._model.captureName = roleData.name;
               this._model.captureTeam = roleData.team;
               if(this._model.captureName.length > 50)
               {
                  this._model.captureName = this._model.captureName.replace(10,"......");
               }
            }
            if(roleData.timerCount > 0)
            {
               roleData.stateType = 4;
               this._model.liveTime = roleData.timerCount / 1000;
               roleData.isDead = true;
            }
            if(PlayerManager.Instance.Self.ZoneID == roleData.zoneID && PlayerManager.Instance.Self.ID == roleData.ID)
            {
               this._model.myTeam = roleData.team;
               this._model.myOutPos = new Point(roleData.posX,roleData.posY);
               if(roleData.timerCount > 0)
               {
                  this._model.isShowResurrectView = true;
               }
               roleData.type = 1;
            }
            else
            {
               roleData.type = 2;
            }
            this._model.playerModel.add(roleData.zoneID + "_" + roleData.ID,roleData);
         }
         var mCount:int = pkg.readInt();
         var index:int = 0;
         this._model.monsterList.clear();
         for(var j:int = 0; j < mCount; j++)
         {
            id = pkg.readInt();
            living = new SmallEnemy(id,2,1000);
            living.typeLiving = 2;
            living.actionMovieName = pkg.readUTF();
            str = pkg.readUTF();
            living.direction = 1;
            outPos = new Point(pkg.readInt(),pkg.readInt());
            living.name = LanguageMgr.GetTranslation("ddt.campleBattle.insectText");
            living.stateType = pkg.readInt();
            npcid = pkg.readInt();
            if(living.stateType != 4)
            {
               this._model.monsterList.add(living.LivingID,living);
               if(this._model.monsterCount == 10)
               {
                  living.pos = new Point(this._model.monsterPosList[index][0],this._model.monsterPosList[index][1]);
               }
               else if(npcid > 0)
               {
                  living.pos = outPos;
               }
               else
               {
                  living.pos = new Point(this._model.monsterPosList[index][0],this._model.monsterPosList[index][1]);
               }
               index++;
            }
         }
         this._model.myScore = pkg.readInt();
         this._model.doorIsOpen = pkg.readBoolean();
         StateManager.setState(StateType.CAMP_BATTLE_SCENE,mapIndex,mapIndex);
         this.initEvent();
      }
      
      private function __onAddRoleList(event:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var roleData:RoleData = null;
         var pkg:PackageIn = event.pkg;
         if(!this._model.isFighting)
         {
            count = pkg.readInt();
            for(i = 0; i < count; i++)
            {
               roleData = new RoleData();
               roleData.ID = pkg.readInt();
               roleData.zoneID = pkg.readInt();
               roleData.Sex = pkg.readBoolean();
               roleData.name = pkg.readUTF();
               roleData.team = pkg.readInt();
               roleData.posX = pkg.readInt();
               roleData.posY = pkg.readInt();
               roleData.stateType = pkg.readInt();
               roleData.timerCount = pkg.readInt();
               roleData.isVip = pkg.readBoolean();
               roleData.vipLev = pkg.readInt();
               roleData.MountsType = pkg.readInt();
               if(roleData.timerCount > 0)
               {
                  roleData.stateType = 4;
               }
               if(roleData.ID == PlayerManager.Instance.Self.ID && PlayerManager.Instance.Self.ZoneID == roleData.zoneID)
               {
                  roleData.type = 1;
               }
               else
               {
                  roleData.type = 2;
               }
               roleData.baseURl = this.clothPath;
               if(Boolean(this._model.playerModel))
               {
                  this._model.playerModel.add(roleData.zoneID + "_" + roleData.ID,roleData);
                  dispatchEvent(new MapEvent(MapEvent.ADD_ROLE,[roleData.zoneID + "_" + roleData.ID,roleData]));
               }
            }
         }
      }
      
      private function __onActionIsOpenHander(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._model.isOpen = pkg.readBoolean();
         var startTime:Date = pkg.readDate();
         this._endTime = pkg.readDate();
         if(!this._model.isOpen)
         {
            this.deleCanpBtn();
            DdtActivityIconManager.Instance.currObj = null;
            this._model.captureName = LanguageMgr.GetTranslation("ddt.campBattle.NOcapture");
            this._model.captureTeam = 0;
            this._model.captureUserID = 0;
            this._model.captureZoneID = 0;
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.campBattle.close"));
            SocketManager.Instance.out.outCampBatttle();
         }
         else
         {
            this.addCampBtn();
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.campBattle.open"));
         }
      }
      
      public function addCampBtn($isOpen:Boolean = true, timeStr:String = null) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CAMP,$isOpen,timeStr);
      }
      
      public function deleCanpBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CAMP,false);
      }
      
      public function onCampBtnHander(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
            return;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            GameInSocketOut.sendSingleRoomBegin(RoomManager.CAMP_BATTLE_ROOM);
         }
      }
      
      private function __onOutBattleHander(event:CrazyTankSocketEvent) : void
      {
         StateManager.setState(StateType.MAIN);
         this.removeEvent();
      }
      
      private function __onPerScoreRankHander(event:CrazyTankSocketEvent) : void
      {
         var obj:RankData = null;
         var pkg:PackageIn = event.pkg;
         this._model.perScoreRankList = [];
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new RankData();
            obj.ZoneID = pkg.readInt();
            obj.UserID = pkg.readInt();
            obj.ZoneName = pkg.readUTF();
            obj.Name = pkg.readUTF();
            obj.Score = pkg.readInt();
            obj.Rank = i + 1;
            this._model.perScoreRankList.push(obj);
         }
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT) && StateManager.currentStateType != StateType.CAMP_BATTLE_SCENE)
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(this.loadFrameUIModule));
         }
         else
         {
            this.loadFrameUIModule();
         }
         dispatchEvent(new MapEvent(MapEvent.PER_SCORE_RANK,this._model.perScoreRankList));
      }
      
      private function __onRemoveRoleChange(evt:CrazyTankSocketEvent) : void
      {
         var zoneID:int = 0;
         var userID:int = 0;
         var key:String = null;
         var pkg:PackageIn = evt.pkg;
         if(!this._model.isFighting)
         {
            zoneID = pkg.readInt();
            userID = pkg.readInt();
            key = zoneID + "_" + userID;
            if(Boolean(this._model.playerModel))
            {
               this._model.playerModel.remove(key);
               dispatchEvent(new MapEvent(MapEvent.REMOVE_ROLE,key));
            }
         }
      }
      
      private function __onWinCountHander(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var winCount:int = pkg.readInt();
         this._model.winCount = winCount;
         dispatchEvent(new MapEvent(MapEvent.WIN_COUNT_PVP));
      }
      
      public function rankFrame() : void
      {
         var frame:CampRankView = ComponentFactory.Instance.creatComponentByStylename("campBattle.views.CampRankView");
         frame.setList(this._model.perScoreRankList);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onCampScoreRankHander(event:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var pkg:PackageIn = event.pkg;
         this._model.scoreList = [];
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.team = pkg.readInt();
            obj.score = pkg.readInt();
            obj.roles = pkg.readInt();
            this._model.scoreList.push(obj);
         }
         dispatchEvent(new MapEvent(MapEvent.CAMP_SOCER_RANK,this._model.scoreList));
      }
      
      private function __onUpdateScoreHander(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var score:int = pkg.readInt();
         this._model.myScore = score;
         dispatchEvent(new MapEvent(MapEvent.UPDATE_SCORE));
      }
      
      private function getRoleData(zoneID:int, userID:int) : RoleData
      {
         var key:String = zoneID + "_" + userID;
         var data:RoleData = null;
         if(Boolean(this._model.playerModel))
         {
            data = this._model.playerModel[key];
         }
         return data;
      }
      
      public function get toEndTime() : int
      {
         if(!this._endTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._endTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      private function getDateHourTime(date:Date) : int
      {
         return int(date.hours * 3600 + date.minutes * 60 + date.seconds);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CampPackageType.ADD_ROLE_LIST_EVENT,this.__onAddRoleList);
         SocketManager.Instance.removeEventListener(CampPackageType.OUT_CAMPBATTLE_EVENT,this.__onOutBattleHander);
         SocketManager.Instance.removeEventListener(CampPackageType.CAMP_SOCER_RANK_EVENT,this.__onCampScoreRankHander);
         SocketManager.Instance.removeEventListener(CampPackageType.PER_SCORE_RANK_EVENT,this.__onPerScoreRankHander);
         SocketManager.Instance.removeEventListener(CampPackageType.REMOVE_ROLE_EVENT,this.__onRemoveRoleChange);
         SocketManager.Instance.removeEventListener(CampPackageType.WIN_COUNT_PTP_EVENT,this.__onWinCountHander);
         SocketManager.Instance.removeEventListener(CampPackageType.PLAYER_STATE_CHANGE_EVENT,this.__onPlayerStateChange);
         SocketManager.Instance.removeEventListener(CampPackageType.UPDATE_SCORE_EVENT,this.__onUpdateScoreHander);
      }
      
      public function get model() : CampModel
      {
         return this._model;
      }
      
      public function get clothPath() : String
      {
         return PathManager.SITE_MAIN + "image/camp/";
      }
      
      public function loadFrameUIModule() : void
      {
         this.completeCount = 0;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CAMP_BATTLE_SCENE);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTCONSORTIA);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CAMP_BATTLE_SCENE || event.module == UIModuleTypes.DDTCONSORTIA)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CAMP_BATTLE_SCENE || event.module == UIModuleTypes.DDTCONSORTIA)
         {
            ++this.completeCount;
         }
         if(this.completeCount >= 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.rankFrame();
            this.completeCount = 0;
         }
      }
   }
}

