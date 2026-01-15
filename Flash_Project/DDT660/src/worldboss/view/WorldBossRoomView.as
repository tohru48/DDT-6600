package worldboss.view
{
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.model.WorldBossRoomModel;
   
   public class WorldBossRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [1738,1300];
      
      private var _contoller:WorldBossRoomController;
      
      private var _model:WorldBossRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:WorldBossScneneMap;
      
      private var _chatFrame:ChatView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _bossHP:WorldBossHPScript;
      
      private var _totalContainer:WorldBossRoomTotalInfoView;
      
      private var _resurrectFrame:WorldBossResurrectView;
      
      private var _buffIcon:WorldBossBuffIcon;
      
      private var _buffIconArr:Array = new Array();
      
      private var _timer:Timer;
      
      private var _diff:int;
      
      private var _hideBtn:WorldBossHideBtn;
      
      public function WorldBossRoomView(controller:WorldBossRoomController, model:WorldBossRoomModel)
      {
         super();
         this._contoller = controller;
         this._model = model;
         this.initialize();
      }
      
      public static function getImagePath(id:int) : String
      {
         return PathManager.solveWorldbossBuffPath() + id + ".png";
      }
      
      public function show() : void
      {
         this._contoller.addChild(this);
      }
      
      private function initialize() : void
      {
         SoundManager.instance.playMusic("worldbossroom-" + WorldBossManager.Instance.BossResourceId);
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         this._chatFrame.output.isLock = false;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._roomMenuView = ComponentFactory.Instance.creat("worldboss.room.menuView");
         addChild(this._roomMenuView);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
         this._bossHP = ComponentFactory.Instance.creat("worldboss.room.bossHP");
         addChild(this._bossHP);
         this.refreshHpScript();
         this._diff = WorldBossManager.Instance.bossInfo.fightOver ? 0 : WorldBossManager.Instance.bossInfo.getLeftTime();
         this._totalContainer = ComponentFactory.Instance.creat("worldboss.room.infoView");
         addChildAt(this._totalContainer,0);
         this._totalContainer.updata_yourSelf_damage();
         this._totalContainer.setTimeCount(this._diff);
         this._buffIcon = ComponentFactory.Instance.creat("worldboss.room.buffIcon");
         addChild(this._buffIcon);
         this._buffIcon.visible = !WorldBossManager.Instance.bossInfo.fightOver;
         this._buffIcon.addEventListener(Event.CHANGE,this.showBuff);
         this._hideBtn = new WorldBossHideBtn();
         addChild(this._hideBtn);
         this.setMap();
         this._timer = new Timer(1000,this._diff);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timeOne);
         this._timer.start();
      }
      
      public function refreshHpScript() : void
      {
         if(!this._bossHP)
         {
            return;
         }
         if(WorldBossManager.Instance.isShowBlood && (!WorldBossManager.Instance.bossInfo.fightOver || !WorldBossManager.Instance.bossInfo.isLiving))
         {
            this._bossHP.visible = true;
            this._bossHP.refreshBossName();
            this._bossHP.refreshBlood();
         }
         else
         {
            this._bossHP.visible = false;
         }
      }
      
      public function setViewAgain() : void
      {
         SoundManager.instance.playMusic("worldbossroom-" + WorldBossManager.Instance.BossResourceId);
         ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._totalContainer.updata_yourSelf_damage();
         this._sceneMap.enterIng = false;
         this._sceneMap.removePrompt();
         this._buffIcon.visible = !WorldBossManager.Instance.bossInfo.fightOver;
         this.refreshHpScript();
      }
      
      public function __timeOne(event:TimerEvent) : void
      {
         --this._diff;
         if(this._diff < 0)
         {
            this.timeComplete();
         }
         else
         {
            this._totalContainer.setTimeCount(this._diff);
         }
      }
      
      public function timeComplete() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timeOne);
         if(this._timer.running)
         {
            this._timer.reset();
         }
         if(WorldBossManager.Instance.bossInfo.isLiving && Boolean(this._bossHP))
         {
            removeChild(this._bossHP);
            this._bossHP.dispose();
            this._bossHP = null;
         }
      }
      
      public function setMap(localPos:Point = null) : void
      {
         this.clearMap();
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this.getMapRes()) as Class)() as MovieClip;
         var entity:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         var sky:Sprite = mapRes.getChildByName("worldbossMouse") as Sprite;
         var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         var bgSize:Sprite = mapRes.getChildByName("bgSize") as Sprite;
         var decoration:Sprite = mapRes.getChildByName("decoration") as Sprite;
         if(Boolean(bgSize))
         {
            MAP_SIZEII[0] = bgSize.width;
            MAP_SIZEII[1] = bgSize.height;
         }
         else
         {
            MAP_SIZEII[0] = bg.width;
            MAP_SIZEII[1] = bg.height;
         }
         this._sceneScene.setHitTester(new PathMapHitTester(mesh));
         if(!this._sceneMap)
         {
            this._sceneMap = new WorldBossScneneMap(this._model,this._sceneScene,this._model.getPlayers(),bg,mesh,entity,sky,decoration);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(Boolean(localPos))
         {
            this._sceneMap.sceneMapVO.defaultPos = localPos;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
         SocketManager.Instance.out.sendAddPlayer(WorldBossManager.Instance.bossInfo.myPlayerVO.playerPos);
         if(WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD > 0)
         {
            this.showResurrectFrame(WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD);
         }
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var sceneMapVO:SceneMapVO = new SceneMapVO();
         sceneMapVO.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         sceneMapVO.mapW = MAP_SIZEII[0];
         sceneMapVO.mapH = MAP_SIZEII[1];
         sceneMapVO.defaultPos = ComponentFactory.Instance.creatCustomObject("worldboss.RoomView.sceneMapVOPosII");
         return sceneMapVO;
      }
      
      public function clearBuff() : void
      {
         var item:BuffItem = null;
         while(this._buffIconArr.length > 0)
         {
            item = this._buffIconArr[0] as BuffItem;
            this._buffIconArr.shift();
            removeChild(item);
            item.dispose();
         }
      }
      
      public function showBuff(evt:Event = null) : void
      {
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.movePlayer(id,p);
         }
      }
      
      public function updatePlayerStauts(id:int, status:int, point:Point = null) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.updatePlayersStauts(id,status,point);
         }
      }
      
      public function updateSelfStatus(value:int) : void
      {
         this._sceneMap.updateSelfStatus(value);
      }
      
      public function checkSelfStatus() : void
      {
         if(this._sceneMap.checkSelfStatus() == 3 || !WorldBossManager.Instance.bossInfo.fightOver && WorldBossManager.IsSuccessStartGame)
         {
            this.showResurrectFrame(WorldBossManager.Instance.bossInfo.timeCD);
         }
         else
         {
            this._sceneMap.updateSelfStatus(1);
         }
      }
      
      private function showResurrectFrame(cd:int) : void
      {
         this._resurrectFrame = new WorldBossResurrectView(cd);
         PositionUtils.setPos(this._resurrectFrame,"worldRoom.resurrectView.pos");
         addChild(this._resurrectFrame);
         this._resurrectFrame.addEventListener(Event.COMPLETE,this.__resurrectTimeOver);
         this._roomMenuView.visible = false;
      }
      
      public function playerRevive(id:int) : void
      {
         if(Boolean(this._sceneMap.selfPlayer) && id == this._sceneMap.selfPlayer.ID)
         {
            if(Boolean(this._resurrectFrame))
            {
               this.removeFrame();
            }
            if(Boolean(this._roomMenuView))
            {
               this._roomMenuView.visible = true;
            }
         }
         this._sceneMap.playerRevive(id);
      }
      
      private function __resurrectTimeOver(e:Event = null) : void
      {
         this.removeFrame();
         this._roomMenuView.visible = true;
         this._sceneMap.updateSelfStatus(1);
      }
      
      private function removeFrame() : void
      {
         if(Boolean(this._resurrectFrame))
         {
            this._resurrectFrame.removeEventListener(Event.COMPLETE,this.__resurrectTimeOver);
            if(Boolean(this._resurrectFrame.parent))
            {
               removeChild(this._resurrectFrame);
            }
            this._resurrectFrame.dispose();
            this._resurrectFrame = null;
         }
      }
      
      private function _leaveRoom(e:Event) : void
      {
         StateManager.setState(StateType.WORLDBOSS_AWARD);
         this._contoller.dispose();
      }
      
      public function gameOver() : void
      {
         this._sceneMap.gameOver();
         this._buffIcon.visible = false;
         this._totalContainer.restTimeInfo();
      }
      
      public function updataRanking(arr:Array) : void
      {
         this._totalContainer.updataRanking(arr);
      }
      
      public function getMapRes() : String
      {
         return "tank.WorldBoss.Map-" + WorldBossManager.Instance.BossResourceId;
      }
      
      private function clearMap() : void
      {
         if(Boolean(this._sceneMap))
         {
            if(Boolean(this._sceneMap.parent))
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function dispose() : void
      {
         WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timeOne);
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._buffIcon = null;
         this._roomMenuView = null;
         this._totalContainer = null;
         this._bossHP = null;
         this._resurrectFrame = null;
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
         this._hideBtn = null;
      }
   }
}

