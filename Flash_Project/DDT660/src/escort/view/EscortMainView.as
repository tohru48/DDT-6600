package escort.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import escort.EscortManager;
   import escort.event.EscortEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   
   public class EscortMainView extends BaseStateView
   {
      
      private var _mapView:EscortMapView;
      
      private var _exitBtn:EscortExitBtn;
      
      private var _threeBtnView:EscortThreeBtnView;
      
      private var _countDownView:EscortCountDownView;
      
      private var _rankView:EscortRankView;
      
      private var _chatView:Sprite;
      
      private var _waitMc:MovieClip;
      
      private var _gameStartCountDownView:EscortStartCountDownView;
      
      private var _helpBtn:EscortHelpBtn;
      
      private var _runPercent:EscortRunPercentView;
      
      private var _sprintCountDownView:EscortSprintCountDownView;
      
      public function EscortMainView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         if(!EscortManager.instance.isInGame)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         SocketManager.Instance.out.sendUpdateSysDate();
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.SEVEN_DOUBLE_IN_ROOM);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         super.enter(prev,data);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.hide();
         SoundManager.instance.playMusic("12020");
         EscortManager.instance.loadSound();
         this.initView();
         this.initEvent();
         SocketManager.Instance.out.sendEscortReady();
         EscortManager.instance.enterMainViewHandler();
         SocketManager.Instance.out.sendEscortEnterOrLeaveScene(true);
      }
      
      private function initView() : void
      {
         this._mapView = new EscortMapView();
         addChild(this._mapView);
         this._exitBtn = new EscortExitBtn();
         addChild(this._exitBtn);
         this._threeBtnView = new EscortThreeBtnView();
         this._threeBtnView.mouseChildren = false;
         this._threeBtnView.mouseEnabled = false;
         addChild(this._threeBtnView);
         this._countDownView = new EscortCountDownView();
         addChild(this._countDownView);
         this._runPercent = new EscortRunPercentView();
         addChild(this._runPercent);
         this._mapView.runPercent = this._runPercent;
         this._sprintCountDownView = new EscortSprintCountDownView();
         addChild(this._sprintCountDownView);
         this._rankView = new EscortRankView();
         addChild(this._rankView);
         this._chatView = ChatManager.Instance.view;
         this._chatView.visible = true;
         addChild(this._chatView);
         ChatManager.Instance.state = ChatManager.CHAT_ESCORT_SECENE;
         this._waitMc = ComponentFactory.Instance.creat("asset.escort.waitOtherPlayerPrompt");
         this._waitMc.gotoAndStop(1);
         PositionUtils.setPos(this._waitMc,"escort.game.waitStartGamePromptPos");
         addChild(this._waitMc);
         this._helpBtn = new EscortHelpBtn();
         addChild(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         EscortManager.instance.addEventListener(EscortManager.ALL_READY,this.allReadyHandler);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
         EscortManager.instance.addEventListener(EscortManager.DESTROY,this.destroyHandler);
         EscortManager.instance.addEventListener(EscortManager.ARRIVE,this.arriveHandler);
      }
      
      private function destroyHandler(e:Event) : void
      {
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.timeEnd.tipTxt"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.returnMainState,false,0,true);
         this._mapView.endGame();
      }
      
      private function arriveHandler(event:EscortEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         var tmpData:Object = event.data;
         if(tmpData.zoneId == PlayerManager.Instance.Self.ZoneID && tmpData.id == PlayerManager.Instance.Self.ID)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.arrive.tipTxt"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.returnMainState,false,0,true);
            this._mapView.runPercent = null;
            this._runPercent.refreshView(22780);
            this._mapView.endGame();
         }
      }
      
      private function returnMainState(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.returnMainState);
         StateManager.setState(StateType.MAIN);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function allReadyHandler(event:EscortEvent) : void
      {
         if(Boolean(this._waitMc))
         {
            this._waitMc.gotoAndStop(2);
         }
         if(Boolean(event.data.isShowStartCountDown))
         {
            this._gameStartCountDownView = new EscortStartCountDownView(this.doStartGame,[event.data.endTime,event.data.sprintEndTime]);
            addChild(this._gameStartCountDownView);
         }
         else
         {
            this.doStartGame(event.data.endTime,event.data.sprintEndTime);
         }
      }
      
      private function doStartGame(endTime:Date, sprintEndTime:Date) : void
      {
         if(!this._mapView)
         {
            return;
         }
         this._mapView.startGame();
         this._countDownView.setCountDown(endTime);
         this._sprintCountDownView.setCountDown(sprintEndTime);
         this._threeBtnView.mouseChildren = true;
         this._threeBtnView.mouseEnabled = true;
      }
      
      private function removeEvent() : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
         EscortManager.instance.removeEventListener(EscortManager.ALL_READY,this.allReadyHandler);
         EscortManager.instance.removeEventListener(EscortManager.DESTROY,this.destroyHandler);
         EscortManager.instance.removeEventListener(EscortManager.ARRIVE,this.arriveHandler);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.SEVEN_DOUBLE_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.SEVEN_DOUBLE_IN_ROOM);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         this.removeEvent();
         super.leaving(next);
         ObjectUtils.disposeObject(this._mapView);
         this._mapView = null;
         ObjectUtils.disposeObject(this._exitBtn);
         this._exitBtn = null;
         ObjectUtils.disposeObject(this._threeBtnView);
         this._threeBtnView = null;
         ObjectUtils.disposeObject(this._countDownView);
         this._countDownView = null;
         ObjectUtils.disposeObject(this._sprintCountDownView);
         this._sprintCountDownView = null;
         ObjectUtils.disposeObject(this._runPercent);
         this._runPercent = null;
         ObjectUtils.disposeObject(this._rankView);
         this._rankView = null;
         ObjectUtils.disposeObject(this._gameStartCountDownView);
         this._gameStartCountDownView = null;
         if(Boolean(this._chatView) && this.contains(this._chatView))
         {
            this.removeChild(this._chatView);
         }
         this._chatView = null;
         if(Boolean(this._waitMc))
         {
            this._waitMc.gotoAndStop(2);
            if(this.contains(this._waitMc))
            {
               this.removeChild(this._waitMc);
            }
         }
         this._waitMc = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         EscortManager.instance.leaveMainViewHandler();
         SocketManager.Instance.out.sendEscortEnterOrLeaveScene(false);
      }
      
      override public function getType() : String
      {
         return StateType.ESCORT;
      }
   }
}

