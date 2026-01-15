package christmas.view.playingSnowman
{
   import christmas.controller.ChristmasRoomController;
   import christmas.loader.LoaderChristmasUIModule;
   import christmas.manager.ChristmasManager;
   import christmas.model.ChristmasRoomModel;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatView;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ChristmasRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [1738,1300];
      
      private var _contoller:ChristmasRoomController;
      
      private var _model:ChristmasRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:ChristmasScneneMap;
      
      private var _chatFrame:ChatView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _snowPackNumImg:Bitmap;
      
      private var _snowPackNumTxt:FilterFrameText;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      public function ChristmasRoomView(controller:ChristmasRoomController, model:ChristmasRoomModel)
      {
         super();
         this._contoller = controller;
         this._model = model;
         this.initialize();
      }
      
      public function show() : void
      {
         this._contoller.addChild(this);
      }
      
      private function initialize() : void
      {
         SoundManager.instance.playMusic("christmasRoom");
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_CHRISTMAS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         this._chatFrame.output.isLock = true;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._snowPackNumImg = ComponentFactory.Instance.creatBitmap("asset.christmas.snowpacknum");
         this._snowPackNumTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.christmasRoom.snowPackNumTxt");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.christmasRoom.activeTimeTxt");
         this._snowPackNumTxt.text = ChristmasManager.instance.getBagSnowPacksCount() + "";
         addChild(this._snowPackNumImg);
         addChild(this._snowPackNumTxt);
         addChild(this._activeTimeTxt);
         this._roomMenuView = ComponentFactory.Instance.creat("christmas.room.menuView");
         addChild(this._roomMenuView);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
         this.flushTip();
         this.setMap();
         this.firestGetTime();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,this.__updateRoomTimes);
      }
      
      private function removeEvent() : void
      {
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,this.__updateRoomTimes);
      }
      
      private function __updateRoomTimes(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var begin:Date = pkg.readDate();
         ChristmasManager.instance.model.gameEndTime = pkg.readDate();
         ChristmasScneneMap.packsNum = 2;
         this.firestGetTime();
      }
      
      public function removeTimer() : void
      {
         this._sceneMap.stopAllTimer();
      }
      
      public function setViewAgain() : void
      {
         SoundManager.instance.playMusic("christmasRoom");
         ChatManager.Instance.state = ChatManager.CHAT_CHRISTMAS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._chatFrame.output.isLock = true;
         this._sceneMap.enterIng = false;
         this.firestGetTime();
      }
      
      private function flushTip() : void
      {
         this._timer = new Timer(60000,0);
         this._timer.addEventListener(TimerEvent.TIMER,this.updateTip);
         this._timer.start();
      }
      
      private function updateTip(e:TimerEvent) : void
      {
         this.firestGetTime();
      }
      
      private function firestGetTime() : void
      {
         var now:Date = TimeManager.Instance.Now();
         var nowNum:Number = Number(now.getTime());
         var endTime:Number = Number(ChristmasManager.instance.model.gameEndTime.getTime());
         var bettwentime:Number = endTime - nowNum;
         var hours:int = bettwentime / (1000 * 60 * 60);
         var minitues:int = (bettwentime - hours * 1000 * 60 * 60) / (1000 * 60);
         if(minitues >= 0)
         {
            this._activeTimeTxt.text = LanguageMgr.GetTranslation("christmas.flushTimecut",hours,minitues);
         }
         else
         {
            this._activeTimeTxt.text = LanguageMgr.GetTranslation("christmas.flushTimecut",0,0);
         }
         this._snowPackNumTxt.text = ChristmasManager.instance.getBagSnowPacksCount() + "";
      }
      
      public function setMap(localPos:Point = null) : void
      {
         ChristmasManager.isFrameChristmas = true;
         this.clearMap();
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(LoaderChristmasUIModule.Instance.getMapRes()) as Class)() as MovieClip;
         var entity:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         var sky:Sprite = mapRes.getChildByName("NPCMouse") as Sprite;
         var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         var bgSize:Sprite = mapRes.getChildByName("bgSize") as Sprite;
         var snow:Sprite = mapRes.getChildByName("snowCenter") as Sprite;
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
            this._sceneMap = new ChristmasScneneMap(this._model,this._sceneScene,this._model.getPlayers(),this._model.getObjects(),bg,mesh,entity,sky,decoration,snow);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(Boolean(localPos))
         {
            this._sceneMap.sceneMapVO.defaultPos = localPos;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var sceneMapVO:SceneMapVO = new SceneMapVO();
         sceneMapVO.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         sceneMapVO.mapW = MAP_SIZEII[0];
         sceneMapVO.mapH = MAP_SIZEII[1];
         sceneMapVO.defaultPos = ComponentFactory.Instance.creatCustomObject("christmas.RoomView.sceneMapVOPosII");
         return sceneMapVO;
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
      
      public function playerRevive(id:int) : void
      {
         if(Boolean(this._sceneMap.selfPlayer) && id == this._sceneMap.selfPlayer.ID)
         {
            if(Boolean(this._roomMenuView))
            {
               this._roomMenuView.visible = true;
            }
         }
         this._sceneMap.playerRevive(id);
      }
      
      private function _leaveRoom(e:Event) : void
      {
         StateManager.setState(StateType.MAIN);
         this._contoller.dispose();
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
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.updateTip);
         }
         this._roomMenuView = null;
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
      }
   }
}

