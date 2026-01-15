package church.controller
{
   import baglocked.BaglockedManager;
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.view.weddingRoom.WeddingRoomSwitchMovie;
   import church.view.weddingRoom.WeddingRoomView;
   import church.vo.PlayerVO;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ChurchRoomController extends BaseStateView
   {
      
      private static const RESTART_WEDDING_FEE:int = 500;
      
      private var _sceneModel:ChurchRoomModel;
      
      private var _view:WeddingRoomView;
      
      private var timer:Timer;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      public function ChurchRoomController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function getBackType() : String
      {
         return StateType.DDTCHURCH_ROOM_LIST;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         ChurchManager.instance.removeLoadingEvent();
         CacheSysManager.lock(CacheConsts.ALERT_IN_MARRY);
         super.enter(prev,data);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         SocketManager.Instance.out.sendCurrentState(0);
         MainToolBar.Instance.hide();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._sceneModel = new ChurchRoomModel();
         this._view = new WeddingRoomView(this,this._sceneModel);
         this._view.show();
         this.resetTimer();
      }
      
      public function resetTimer() : void
      {
         var beginDate:Date = null;
         var diff:Number = NaN;
         var valid:Number = NaN;
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            beginDate = ChurchManager.instance.currentRoom.creactTime;
            diff = TimeManager.Instance.TotalDaysToNow(beginDate) * 24;
            valid = (ChurchManager.instance.currentRoom.valideTimes - diff) * 60;
            if(valid > 10)
            {
               this.stopTimer();
               this.timer = new Timer((valid - 10) * 60 * 1000,1);
               this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
               this.timer.start();
            }
         }
      }
      
      private function __timerComplete(event:TimerEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete"));
         var msg:ChatData = new ChatData();
         msg.channel = ChatInputView.SYS_NOTICE;
         msg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete.msg");
         ChatManager.Instance.chat(msg);
         this.stopTimer();
      }
      
      private function stopTimer() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this.timer = null;
         }
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOVE,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL,this.__startWedding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINUATION,this.__continuation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,this.__stopWedding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,this.__onUseFire);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUNSALUTE,this.__onUseSalute);
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__updateWeddingStatus);
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE,this.__updateValidTime);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__sceneChange);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOVE,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL,this.__startWedding);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINUATION,this.__continuation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,this.__stopWedding);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,this.__onUseFire);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GUNSALUTE,this.__onUseSalute);
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__updateWeddingStatus);
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE,this.__updateValidTime);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__sceneChange);
      }
      
      private function __continuation(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(ChurchManager.instance.currentRoom))
         {
            ChurchManager.instance.currentRoom.valideTimes = event.pkg.readInt();
         }
      }
      
      private function __updateValidTime(event:WeddingRoomEvent) : void
      {
         this.resetTimer();
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         ChurchManager.instance.currentRoom = null;
         ChurchManager.instance.currentScene = false;
         SocketManager.Instance.out.sendExitRoom();
         super.leaving(next);
      }
      
      override public function getType() : String
      {
         return StateType.CHURCH_ROOM;
      }
      
      public function __addPlayer(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var playerInfo:PlayerInfo = new PlayerInfo();
         playerInfo.beginChanges();
         playerInfo.Grade = pkg.readInt();
         playerInfo.Hide = pkg.readInt();
         playerInfo.Repute = pkg.readInt();
         playerInfo.ID = pkg.readInt();
         playerInfo.NickName = pkg.readUTF();
         playerInfo.typeVIP = pkg.readByte();
         playerInfo.VIPLevel = pkg.readInt();
         playerInfo.Sex = pkg.readBoolean();
         playerInfo.Style = pkg.readUTF();
         playerInfo.Colors = pkg.readUTF();
         playerInfo.Skin = pkg.readUTF();
         var posx:int = pkg.readInt();
         var posy:int = pkg.readInt();
         playerInfo.FightPower = pkg.readInt();
         playerInfo.WinCount = pkg.readInt();
         playerInfo.TotalCount = pkg.readInt();
         playerInfo.Offer = pkg.readInt();
         playerInfo.isOld = pkg.readBoolean();
         playerInfo.commitChanges();
         var playerVO:PlayerVO = new PlayerVO();
         playerVO.playerInfo = playerInfo;
         playerVO.playerPos = new Point(posx,posy);
         if(playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         this._sceneModel.addPlayer(playerVO);
      }
      
      public function __removePlayer(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.clientId;
         if(id == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
         }
         else
         {
            if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
               return;
            }
            this._sceneModel.removePlayer(id);
         }
      }
      
      public function __movePlayer(event:CrazyTankSocketEvent) : void
      {
         var p:Point = null;
         var id:int = event.pkg.clientId;
         var posX:int = event.pkg.readInt();
         var posY:int = event.pkg.readInt();
         var pathStr:String = event.pkg.readUTF();
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            return;
         }
         if(id == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var arr:Array = pathStr.split(",");
         var path:Array = [];
         for(var i:uint = 0; i < arr.length; i += 2)
         {
            p = new Point(arr[i],arr[i + 1]);
            path.push(p);
         }
         this._view.movePlayer(id,path);
      }
      
      private function __updateWeddingStatus(event:WeddingRoomEvent) : void
      {
         if(!ChurchManager.instance.currentScene)
         {
            this._view.switchWeddingView();
         }
      }
      
      public function playWeddingMovie() : void
      {
         this._view.playerWeddingMovie();
      }
      
      public function startWedding() : void
      {
         var beginDate:Date = null;
         var diff:Number = NaN;
         var valid:Number = NaN;
         var spouse:PlayerVO = null;
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self) && ChurchManager.instance.currentRoom.status != ChurchRoomInfo.WEDDING_ING)
         {
            beginDate = ChurchManager.instance.currentRoom.creactTime;
            diff = TimeManager.Instance.TotalDaysToNow(beginDate) * 24;
            valid = (ChurchManager.instance.currentRoom.valideTimes - diff) * 60;
            if(valid < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.valid"));
               return;
            }
            spouse = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
            if(!spouse)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
               return;
            }
            if(ChurchManager.instance.currentRoom.isStarted)
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.isStarted",RESTART_WEDDING_FEE),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
               return;
            }
            SocketManager.Instance.out.sendStartWedding();
         }
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         var spouse:PlayerVO = null;
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Money < RESTART_WEDDING_FEE)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               spouse = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
               if(!spouse)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
                  return;
               }
               SocketManager.Instance.out.sendStartWedding();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
      }
      
      private function __startWedding(event:CrazyTankSocketEvent) : void
      {
         var roomID:int = event.pkg.readInt();
         var result:Boolean = event.pkg.readBoolean();
         if(result)
         {
            ChurchManager.instance.currentRoom.isStarted = true;
            ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_ING;
         }
      }
      
      private function __stopWedding(event:CrazyTankSocketEvent) : void
      {
         ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_NONE;
      }
      
      public function modifyDiscription(roomName:String, modifyPSW:Boolean, psw:String, discription:String) : void
      {
         SocketManager.Instance.out.sendModifyChurchDiscription(roomName,modifyPSW,psw,discription);
      }
      
      public function useFire(playerID:int, fireTemplateID:int) : void
      {
         this._view.useFire(playerID,fireTemplateID);
      }
      
      private function __onUseFire(e:CrazyTankSocketEvent) : void
      {
         var userID:int = e.pkg.readInt();
         var fireID:int = e.pkg.readInt();
         this.useFire(userID,fireID);
      }
      
      private function __onUseSalute(event:CrazyTankSocketEvent) : void
      {
         var userID:int = event.pkg.readInt();
         this.setSaulte(userID);
      }
      
      public function setSaulte(id:int) : void
      {
         this._view.setSaulte(id);
      }
      
      private function __sceneChange(event:WeddingRoomEvent) : void
      {
         this.readyEnterScene();
      }
      
      public function readyEnterScene() : void
      {
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         var switchMovie:WeddingRoomSwitchMovie = new WeddingRoomSwitchMovie(true,0.06);
         addChild(switchMovie);
         switchMovie.playMovie();
         switchMovie.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__readyEnterOk);
      }
      
      private function __readyEnterOk(event:Event) : void
      {
         event.currentTarget.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__readyEnterOk);
         this.enterScene();
      }
      
      public function enterScene() : void
      {
         var pos:Point = null;
         this._sceneModel.reset();
         if(!ChurchManager.instance.currentScene)
         {
            pos = new Point(514,637);
         }
         this._view.setMap(pos);
         var sceneIndex:int = ChurchManager.instance.currentScene ? 2 : 1;
         SocketManager.Instance.out.sendSceneChange(sceneIndex);
      }
      
      public function giftSubmit(money:uint) : void
      {
         SocketManager.Instance.out.sendChurchLargess(money);
      }
      
      public function roomContinuation(secondType:int) : void
      {
         SocketManager.Instance.out.sendChurchContinuation(secondType);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.stopTimer();
         if(Boolean(this._sceneModel))
         {
            this._sceneModel.dispose();
         }
         this._sceneModel = null;
         if(Boolean(this._view))
         {
            if(Boolean(this._view.parent))
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.dispose();
         }
         this._view = null;
         CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MARRY);
      }
   }
}

