package sevenDouble.view
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
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   import sevenDouble.SevenDoubleManager;
   import sevenDouble.event.SevenDoubleEvent;
   
   public class SevenDoubleMainView extends BaseStateView
   {
      
      private var _mapView:SevenDoubleMapView;
      
      private var _exitBtn:SevenDoubleExitBtn;
      
      private var _threeBtnView:SevenDoubleThreeBtnView;
      
      private var _countDownView:SevenDoubleCountDownView;
      
      private var _sevenDoubleRankView:SevenDoubleRankView;
      
      private var _chatView:Sprite;
      
      private var _waitMc:MovieClip;
      
      private var _gameStartCountDownView:SevenDoubleStartCountDownView;
      
      private var _helpBtn:SevenDoubleHelpBtn;
      
      private var _runPercent:SevenDoubleRunPercentView;
      
      private var _sprintCountDownView:SevenDoubleSprintCountDownView;
      
      public function SevenDoubleMainView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         if(!SevenDoubleManager.instance.isInGame)
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
         SevenDoubleManager.instance.loadSound();
         this.initView();
         this.initEvent();
         SocketManager.Instance.out.sendSevenDoubleReady();
         SevenDoubleManager.instance.enterMainViewHandler();
         SocketManager.Instance.out.sendSevenDoubleEnterOrLeaveScene(true);
      }
      
      private function initView() : void
      {
         this._mapView = new SevenDoubleMapView();
         addChild(this._mapView);
         this._exitBtn = new SevenDoubleExitBtn();
         addChild(this._exitBtn);
         this._threeBtnView = new SevenDoubleThreeBtnView();
         this._threeBtnView.mouseChildren = false;
         this._threeBtnView.mouseEnabled = false;
         addChild(this._threeBtnView);
         this._countDownView = new SevenDoubleCountDownView();
         addChild(this._countDownView);
         this._runPercent = new SevenDoubleRunPercentView();
         addChild(this._runPercent);
         this._mapView.runPercent = this._runPercent;
         this._sprintCountDownView = new SevenDoubleSprintCountDownView();
         addChild(this._sprintCountDownView);
         this._sevenDoubleRankView = new SevenDoubleRankView();
         addChild(this._sevenDoubleRankView);
         this._chatView = ChatManager.Instance.view;
         this._chatView.visible = true;
         addChild(this._chatView);
         ChatManager.Instance.state = ChatManager.CHAT_SEVENDOUBLEGAME_SECENE;
         this._waitMc = ComponentFactory.Instance.creat("asset.sevenDouble.waitOtherPlayerPrompt");
         this._waitMc.gotoAndStop(1);
         PositionUtils.setPos(this._waitMc,"sevenDouble.game.waitStartGamePromptPos");
         addChild(this._waitMc);
         this._helpBtn = new SevenDoubleHelpBtn();
         addChild(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.ALL_READY,this.allReadyHandler);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.DESTROY,this.destroyHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.ARRIVE,this.arriveHandler);
      }
      
      private function destroyHandler(e:Event) : void
      {
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.timeEnd.tipTxt"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.returnMainState,false,0,true);
         this._mapView.endGame();
      }
      
      private function arriveHandler(event:SevenDoubleEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         var tmpData:Object = event.data;
         if(tmpData.zoneId == PlayerManager.Instance.Self.ZoneID && tmpData.id == PlayerManager.Instance.Self.ID)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.arrive.tipTxt"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
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
      
      private function allReadyHandler(event:SevenDoubleEvent) : void
      {
         if(Boolean(this._waitMc))
         {
            this._waitMc.gotoAndStop(2);
            this._waitMc.visible = false;
         }
         if(Boolean(event.data.isShowStartCountDown))
         {
            this._gameStartCountDownView = new SevenDoubleStartCountDownView(this.doStartGame,[event.data.endTime,event.data.sprintEndTime]);
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
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ALL_READY,this.allReadyHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.DESTROY,this.destroyHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ARRIVE,this.arriveHandler);
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
         ObjectUtils.disposeObject(this._sevenDoubleRankView);
         this._sevenDoubleRankView = null;
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
         SevenDoubleManager.instance.leaveMainViewHandler();
         SocketManager.Instance.out.sendSevenDoubleEnterOrLeaveScene(false);
      }
      
      override public function getType() : String
      {
         return StateType.SEVEN_DOUBLE_SCENE;
      }
   }
}

