package room.view.roomView
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.RoomEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import hall.event.NewHallEvent;
   import invite.InviteFrame;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.RoomRightPropView;
   import room.view.RoomViewerItem;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BaseRoomView extends Sprite implements Disposeable
   {
      
      protected static const HURRY_UP_TIME:int = 30;
      
      protected static const KICK_TIME:int = 60;
      
      protected static const KICK_TIMEII:int = 300;
      
      protected static const KICK_TIMEIII:int = 1200;
      
      protected static const ACTIVITY_MINGRADE:int = 25;
      
      protected var _hostTimer:Timer;
      
      protected var _normalTimer:Timer;
      
      protected var _info:RoomInfo;
      
      protected var _roomPropView:RoomRightPropView;
      
      protected var _btnBg:Bitmap;
      
      protected var _startBtn:MovieClip;
      
      protected var _prepareBtn:MovieClip;
      
      protected var _cancelBtn:SimpleBitmapButton;
      
      protected var _inviteBtn:SimpleBitmapButton;
      
      protected var _inviteFrame:InviteFrame;
      
      protected var _startInvite:Boolean = false;
      
      protected var _playerItems:Array;
      
      protected var _viewerItems:Vector.<RoomViewerItem>;
      
      protected var _emailBtn:MovieImage;
      
      protected var _taskIconBtn:MovieImage;
      
      public function BaseRoomView(info:RoomInfo)
      {
         super();
         this._info = info;
         this.initTimer();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         this._roomPropView = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.roomPropView");
         addChild(this._roomPropView);
         this._btnBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.btnBg");
         addChild(this._btnBg);
         PositionUtils.setPos(this._btnBg,"asset.ddtroom.btnBgPos");
         this._startBtn = ClassUtils.CreatInstance("asset.ddtroom.startMovie") as MovieClip;
         addChild(this._startBtn);
         PositionUtils.setPos(this._startBtn,"asset.ddtroom.startMoviePos");
         this._prepareBtn = ClassUtils.CreatInstance("asset.ddtroom.preparMovie") as MovieClip;
         addChild(this._prepareBtn);
         PositionUtils.setPos(this._prepareBtn,"asset.ddtroom.startMoviePos");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.cancelButton");
         addChild(this._cancelBtn);
         this.initInviteBtn();
         this._emailBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.mailBtn");
         this._emailBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.email");
         this._emailBtn.buttonMode = true;
         this.showEmailEffect(true);
         PositionUtils.setPos(this._emailBtn,"hall.playerInfo.mailBtnPos");
         addChild(this._emailBtn);
         this._taskIconBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.taskIconBtn");
         this._taskIconBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.task");
         this._taskIconBtn.buttonMode = true;
         this.showTaskEffect(TaskManager.instance.isTaskHightLight);
         PositionUtils.setPos(this._taskIconBtn,"hall.playerInfo.taskIconBtnPos");
         addChild(this._taskIconBtn);
         this._prepareBtn.buttonMode = true;
         this._startBtn.buttonMode = true;
         this.initTileList();
         this.initPlayerItems();
         this.updateButtons();
      }
      
      protected function initInviteBtn() : void
      {
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.inviteButton");
         addChild(this._inviteBtn);
      }
      
      private function initTimer() : void
      {
         this._hostTimer = new Timer(1000);
         this._normalTimer = new Timer(1000);
         if(!this._info || !this._info.selfRoomPlayer)
         {
            return;
         }
         if(!this._info.selfRoomPlayer.isHost)
         {
            this.startNormalTimer();
         }
         else if(this._info.isAllReady())
         {
            this.startHostTimer();
         }
      }
      
      protected function updateButtons() : void
      {
         this.updateTimer();
         this._startBtn.visible = this._info.selfRoomPlayer.isHost && !this._info.started;
         this._prepareBtn.visible = !this._info.selfRoomPlayer.isHost && !this._info.selfRoomPlayer.isReady;
         this._cancelBtn.visible = this._info.selfRoomPlayer.isHost ? this._info.started : this._info.selfRoomPlayer.isReady;
         this._cancelBtn.enable = this._info.selfRoomPlayer.isHost || !this._info.started;
         this._inviteBtn.enable = !this._info.started;
         if(this._info.isAllReady())
         {
            this._startBtn.addEventListener(MouseEvent.CLICK,this.__startClick);
            this._startBtn.filters = null;
            if(Boolean(this._startBtn) && Boolean(this._startBtn.hasOwnProperty("startA")))
            {
               this._startBtn["startA"].play();
            }
            this._startBtn.buttonMode = true;
         }
         else
         {
            this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startClick);
            this._startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            if(Boolean(this._startBtn) && Boolean(this._startBtn.hasOwnProperty("startA")))
            {
               this._startBtn["startA"].gotoAndStop(1);
            }
            this._startBtn.buttonMode = false;
         }
         if(this._info.selfRoomPlayer.isViewer)
         {
            this._prepareBtn.visible = false;
            this._cancelBtn.visible = true;
            this._cancelBtn.enable = false;
         }
      }
      
      protected function initTileList() : void
      {
         var i:int = 0;
         var viewerItem:RoomViewerItem = null;
         this._playerItems = [];
         if(this.isViewerRoom)
         {
            this._viewerItems = new Vector.<RoomViewerItem>();
            for(i = 8; i < 10; i++)
            {
               if(this._info.type == RoomInfo.MATCH_ROOM)
               {
                  viewerItem = new RoomViewerItem(i);
               }
               else
               {
                  viewerItem = new RoomViewerItem(i,RoomViewerItem.SHORT);
               }
               this._viewerItems.push(viewerItem);
            }
         }
      }
      
      protected function get isViewerRoom() : Boolean
      {
         return this._info.type == RoomInfo.CHALLENGE_ROOM || this._info.type == RoomInfo.MATCH_ROOM || this._info.type == RoomInfo.DUNGEON_ROOM || this._info.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._info.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || this._info.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON;
      }
      
      protected function initPlayerItems() : void
      {
         var item:RoomPlayerItem = null;
         var viewerItem:RoomViewerItem = null;
         for(var i:int = 0; i < this._playerItems.length; i++)
         {
            item = this._playerItems[i] as RoomPlayerItem;
            item.info = this._info.findPlayerByPlace(i);
            item.opened = this._info.placesState[i] != 0;
         }
         if(this.isViewerRoom)
         {
            for(i = 0; i < 2; i++)
            {
               if(Boolean(this._viewerItems) && Boolean(this._viewerItems[i]))
               {
                  viewerItem = this._viewerItems[i] as RoomViewerItem;
                  viewerItem.info = this._info.findPlayerByPlace(i + 8);
                  viewerItem.opened = this._info.placesState[i + 8] != 0;
               }
            }
         }
      }
      
      protected function initEvents() : void
      {
         var i:int = 0;
         var viewerItem:RoomViewerItem = null;
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__inviteClick);
         this._info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__updatePlayerItems);
         this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__updateState);
         this._info.addEventListener(RoomEvent.ADD_PLAYER,this.__addPlayer);
         this._info.addEventListener(RoomEvent.REMOVE_PLAYER,this.__removePlayer);
         this._info.addEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__startClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClick);
         this._prepareBtn.addEventListener(MouseEvent.CLICK,this.__prepareClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(this.isViewerRoom)
         {
            for(i = 0; i < 2; i++)
            {
               if(Boolean(this._viewerItems) && Boolean(this._viewerItems[i]))
               {
                  viewerItem = this._viewerItems[i];
                  this._viewerItems[i].addEventListener(RoomEvent.VIEWER_ITEM_INFO_SET,this.__switchClickEnabled);
               }
            }
         }
         this._emailBtn.addEventListener(MouseEvent.CLICK,this.__onMailClick);
         MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         MailManager.Instance.Model.addEventListener(NewHallEvent.CANCELEMAILSHINE,this.__onSetEmailShine);
         this._taskIconBtn.addEventListener(MouseEvent.CLICK,this.__onTaskClick);
         TaskManager.instance.addEventListener(TaskManager.SHOW_TASK_HIGHTLIGHT,this.__showTaskHightLight);
         TaskManager.instance.addEventListener(TaskManager.HIDE_TASK_HIGHTLIGHT,this.__hideTaskHightLight);
      }
      
      protected function __onMailClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         if(PlayerManager.Instance.Self.Grade >= 11)
         {
            MailManager.Instance.switchVisible();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("hall.playerTool.emailLimit"));
         }
      }
      
      protected function __onSetEmailShine(event:NewHallEvent) : void
      {
         this.showEmailEffect(false);
      }
      
      protected function __updateEmail(event:Event) : void
      {
         if(Boolean(this._emailBtn))
         {
            this.showEmailEffect(true);
         }
      }
      
      private function showEmailEffect(show:Boolean) : void
      {
         if(show && MailManager.Instance.Model.hasUnReadEmail())
         {
            this._emailBtn.movie.gotoAndStop(2);
            this._emailBtn.mouseEnabled = true;
            this._emailBtn.mouseChildren = true;
         }
         else
         {
            this._emailBtn.movie.gotoAndStop(1);
         }
      }
      
      protected function __onTaskClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         TaskManager.instance.switchVisible();
      }
      
      protected function __showTaskHightLight(event:Event) : void
      {
         this.showTaskEffect(true);
      }
      
      protected function __hideTaskHightLight(event:Event) : void
      {
         this.showTaskEffect(false);
      }
      
      private function showTaskEffect(show:Boolean) : void
      {
         if(show)
         {
            this._taskIconBtn.movie.gotoAndStop(2);
            this._taskIconBtn.mouseEnabled = true;
            this._taskIconBtn.mouseChildren = true;
         }
         else
         {
            this._taskIconBtn.movie.gotoAndStop(1);
         }
      }
      
      private function __switchClickEnabled(event:RoomEvent) : void
      {
         var item:RoomPlayerItem = null;
         for(var i:int = 0; i < this._playerItems.length; i++)
         {
            item = this._playerItems[i] as RoomPlayerItem;
            item.switchInEnabled = event.params[0] == 1;
         }
      }
      
      private function __loadWeakGuild(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      protected function __inviteClick(evt:MouseEvent) : void
      {
         if(this._inviteFrame != null)
         {
            SoundManager.instance.play("008");
            this.__onInviteComplete(null);
         }
         else
         {
            if(RoomManager.Instance.current.placeCount < 1)
            {
               if(RoomManager.Instance.current.players.length > 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
               }
               return;
            }
            this.startInvite();
         }
      }
      
      protected function startInvite() : void
      {
         if(!this._startInvite && this._inviteFrame == null)
         {
            this._startInvite = true;
            this.loadInviteRes();
         }
      }
      
      private function loadInviteRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTINVITE);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onInviteResComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDTINVITE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
            if(this._startInvite && this._inviteFrame == null)
            {
               this._inviteFrame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame");
               LayerManager.Instance.addToLayer(this._inviteFrame,LayerManager.GAME_DYNAMIC_LAYER,true);
               this._inviteFrame.addEventListener(Event.COMPLETE,this.__onInviteComplete);
               this._startInvite = false;
            }
         }
      }
      
      private function __onInviteComplete(evt:Event) : void
      {
         this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
         ObjectUtils.disposeObject(this._inviteFrame);
         this._inviteFrame = null;
      }
      
      private function __onInviteResError(evt:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
      }
      
      protected function removeEvents() : void
      {
         var i:int = 0;
         var viewerItem:RoomViewerItem = null;
         this._info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__updatePlayerItems);
         this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__updateState);
         this._info.removeEventListener(RoomEvent.ADD_PLAYER,this.__addPlayer);
         this._info.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__removePlayer);
         this._info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
         this._hostTimer.removeEventListener(TimerEvent.TIMER,this.__onHostTimer);
         this._normalTimer.removeEventListener(TimerEvent.TIMER,this.__onTimerII);
         this._prepareBtn.removeEventListener(MouseEvent.CLICK,this.__prepareClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(this.isViewerRoom)
         {
            for(i = 0; i < 2; i++)
            {
               if(Boolean(this._viewerItems) && Boolean(this._viewerItems[i]))
               {
                  viewerItem = this._viewerItems[i];
                  this._viewerItems[i].removeEventListener(RoomEvent.VIEWER_ITEM_INFO_SET,this.__switchClickEnabled);
               }
            }
         }
         this._emailBtn.removeEventListener(MouseEvent.CLICK,this.__onMailClick);
         MailManager.Instance.Model.removeEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         MailManager.Instance.Model.removeEventListener(NewHallEvent.CANCELEMAILSHINE,this.__onSetEmailShine);
         this._taskIconBtn.removeEventListener(MouseEvent.CLICK,this.__onTaskClick);
         TaskManager.instance.removeEventListener(TaskManager.SHOW_TASK_HIGHTLIGHT,this.__showTaskHightLight);
         TaskManager.instance.removeEventListener(TaskManager.HIDE_TASK_HIGHTLIGHT,this.__hideTaskHightLight);
      }
      
      private function updateTimer() : void
      {
         if(this._info.selfRoomPlayer.isHost && this._startBtn.buttonMode == !this._info.isAllReady())
         {
            this.resetHostTimer();
         }
         if(!this._info.selfRoomPlayer.isHost && this._prepareBtn.visible == this._info.selfRoomPlayer.isReady)
         {
            this.resetNormalTimer();
         }
      }
      
      protected function __updatePlayerItems(evt:RoomEvent) : void
      {
         var element:RoomPlayerItem = null;
         for(var i:int = 0; i < this._playerItems.length; i++)
         {
            element = this._playerItems[i] as RoomPlayerItem;
            element.opened = this._info.placesState[i] != 0;
         }
         if(this.isViewerRoom)
         {
            if(Boolean(this._viewerItems))
            {
               if(Boolean(this._viewerItems[0]))
               {
                  this._viewerItems[0].opened = this._info.placesState[8] != 0;
               }
               if(Boolean(this._viewerItems[1]))
               {
                  this._viewerItems[1].opened = this._info.placesState[9] != 0;
               }
            }
         }
         this.initPlayerItems();
         this.updateButtons();
      }
      
      protected function __updateState(evt:RoomEvent) : void
      {
         this.updateButtons();
         if(this._info.selfRoomPlayer.isHost)
         {
            this.startHostTimer();
            this.stopNormalTimer();
            if(!this._info.isAllReady() && this._info.started)
            {
               GameInSocketOut.sendCancelWait();
               this._info.started = false;
               SoundManager.instance.stop("007");
            }
            if(this._info.started)
            {
               MainToolBar.Instance.setRoomStartState2(true);
            }
            else
            {
               MainToolBar.Instance.enableAll();
            }
         }
         else
         {
            this.stopHostTimer();
            this.startNormalTimer();
            if(this._info.selfRoomPlayer.isReady)
            {
               MainToolBar.Instance.setRoomStartState();
            }
            else if(!this._info.selfRoomPlayer.isViewer)
            {
               MainToolBar.Instance.enableAll();
            }
         }
      }
      
      protected function __addPlayer(evt:RoomEvent) : void
      {
         var player:RoomPlayer = evt.params[0] as RoomPlayer;
         if(player.isFirstIn)
         {
            SoundManager.instance.play("158");
         }
         if(player.place >= 8)
         {
            this._viewerItems[player.place - 8].info = player;
         }
         else
         {
            this._playerItems[player.place].info = player;
         }
         this.updateButtons();
      }
      
      protected function __removePlayer(evt:RoomEvent) : void
      {
         var player:RoomPlayer = evt.params[0] as RoomPlayer;
         if(player.place >= 8)
         {
            this._viewerItems[player.place - 8].info = null;
         }
         else
         {
            this._playerItems[player.place].info = null;
         }
         player.dispose();
         this.updateButtons();
      }
      
      protected function __startClick(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(!this._info.isAllReady())
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.checkCanStartGame())
         {
            if(this._info.type == 42)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("tank.room.RoomView.costMoney",ServerConfigManager.instance.entertainmentPkCostMoney(),ServerConfigManager.instance.entertainmentPkAddMoney()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
            }
            else
            {
               this.startGame();
               this._info.started = true;
            }
         }
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.entertainmentPkCostMoney())
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertMoneyResponse);
               return;
            }
            this.startGame();
            this._info.started = true;
         }
      }
      
      private function __onAlertMoneyResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertMoneyResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      protected function __prepareClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         this.prepareGame();
      }
      
      protected function prepareGame() : void
      {
         GameInSocketOut.sendPlayerState(1);
      }
      
      protected function startGame() : void
      {
         this._startInvite = false;
         GameInSocketOut.sendGameStart();
      }
      
      protected function __cancelClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendCancelWait();
         }
         else if(this._info.started)
         {
            GameInSocketOut.sendCancelWait();
         }
         else
         {
            GameInSocketOut.sendPlayerState(0);
         }
      }
      
      protected function checkCanStartGame() : Boolean
      {
         var result:Boolean = true;
         if(this._info.selfRoomPlayer.isViewer)
         {
            return result;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            result = false;
         }
         return result;
      }
      
      protected function academyDungeonAllow() : Boolean
      {
         var i:RoomPlayer = null;
         var l:RoomPlayer = null;
         var num:int = 0;
         if(RoomManager.Instance.current.players.length < 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
            return false;
         }
         for each(i in RoomManager.Instance.current.players)
         {
            if(i.playerInfo.apprenticeshipState == AcademyManager.NONE_STATE && !i.isViewer)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning1"));
               return false;
            }
            if((i.playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || i.playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE || i.playerInfo.apprenticeshipState == AcademyManager.APPRENTICE_STATE) && !i.isViewer)
            {
               num++;
            }
         }
         if(num < 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
            return false;
         }
         num = 0;
         for each(l in RoomManager.Instance.current.players)
         {
            if((l.playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || l.playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE) && !l.isViewer)
            {
               num++;
               if(num > 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning3"));
                  return false;
               }
            }
         }
         if(num == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning2"));
            return false;
         }
         return true;
      }
      
      protected function activityDungeonAllow() : Boolean
      {
         var player:RoomPlayer = null;
         for each(player in RoomManager.Instance.current.players)
         {
            if(player.playerInfo.Grade < ACTIVITY_MINGRADE)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.ActivityDungeon.roomPromptInfo",player.playerInfo.NickName));
               return false;
            }
            if(player.playerInfo.activityTanabataNum <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.ActivityDungeon.roomPromptNum",player.playerInfo.NickName));
               return false;
            }
         }
         return true;
      }
      
      protected function __startHandler(evt:RoomEvent) : void
      {
         this.updateButtons();
         if(this._info.started)
         {
            this.stopHostTimer();
            if(this._info.type == 42)
            {
               MainToolBar.Instance.setFightRoomStartState();
            }
            else
            {
               MainToolBar.Instance.setRoomStartState();
            }
            SoundManager.instance.stop("007");
         }
         else
         {
            if(this._info.selfRoomPlayer.isHost && this._info.isAllReady())
            {
               this.startHostTimer();
            }
            if(this._info.selfRoomPlayer.isHost)
            {
               MainToolBar.Instance.enableAll();
            }
            else
            {
               if(this._info.selfRoomPlayer.isViewer)
               {
                  MainToolBar.Instance.setRoomStartState();
                  MainToolBar.Instance.setReturnEnable(true);
                  return;
               }
               if(this._info.selfRoomPlayer.isReady)
               {
                  MainToolBar.Instance.setRoomStartState();
               }
               else
               {
                  MainToolBar.Instance.enableAll();
               }
            }
         }
      }
      
      protected function startHostTimer() : void
      {
         if(!this._hostTimer.running)
         {
            this._hostTimer.start();
            this._hostTimer.addEventListener(TimerEvent.TIMER,this.__onHostTimer);
         }
      }
      
      protected function startNormalTimer() : void
      {
         if(!this._normalTimer.running)
         {
            this._normalTimer.start();
            this._normalTimer.addEventListener(TimerEvent.TIMER,this.__onTimerII);
         }
      }
      
      protected function stopHostTimer() : void
      {
         this._hostTimer.reset();
         this._hostTimer.removeEventListener(TimerEvent.TIMER,this.__onHostTimer);
         SoundManager.instance.stop("007");
      }
      
      protected function stopNormalTimer() : void
      {
         this._normalTimer.reset();
         this._normalTimer.removeEventListener(TimerEvent.TIMER,this.__onTimerII);
         SoundManager.instance.stop("007");
      }
      
      protected function resetHostTimer() : void
      {
         this.stopHostTimer();
         this.startHostTimer();
         SoundManager.instance.stop("007");
      }
      
      protected function resetNormalTimer() : void
      {
         this.stopNormalTimer();
         this.startNormalTimer();
         SoundManager.instance.stop("007");
      }
      
      protected function __onTimerII(evt:TimerEvent) : void
      {
         if(!this._info.selfRoomPlayer.isHost && !this._info.selfRoomPlayer.isViewer)
         {
            if(this._normalTimer.currentCount >= HURRY_UP_TIME && !this._info.selfRoomPlayer.isReady)
            {
               if(!TaskManager.instance.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      protected function __onHostTimer(evt:TimerEvent) : void
      {
         if(this._info.selfRoomPlayer.isHost && !this._info.isOpenBoss && !this._info.mapId == 12016)
         {
            if(this._hostTimer.currentCount >= KICK_TIMEIII && this._info.players.length - this._info.currentViewerCnt > 1)
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount >= KICK_TIMEII && this._info.players.length - this._info.currentViewerCnt == 1)
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount >= KICK_TIME && this._info.players.length - this._info.currentViewerCnt > 1 && this._info.currentViewerCnt == 0 && this._info.isAllReady())
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount == KICK_TIMEIII - 30 && this._info.players.length - this._info.currentViewerCnt > 1 || this._hostTimer.currentCount == KICK_TIMEII - 30 && this._info.players.length - this._info.currentViewerCnt == 1 || this._hostTimer.currentCount == KICK_TIME - 30 && this._info.players.length - this._info.currentViewerCnt > 1 && this._info.currentViewerCnt == 0 && this._info.isAllReady())
            {
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
            }
            else if(this._hostTimer.currentCount >= HURRY_UP_TIME && this._info.isAllReady())
            {
               if(!TaskManager.instance.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      protected function kickHandler() : void
      {
         ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.room.RoomIIView2.kick"));
         if(this._info.type == RoomInfo.DUNGEON_ROOM || this._info.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._info.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || this._info.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
         else
         {
            StateManager.setState(StateType.ROOM_LIST);
         }
         PlayerManager.Instance.Self.unlockAllBag();
      }
      
      public function dispose() : void
      {
         var item:RoomPlayerItem = null;
         var vi:RoomViewerItem = null;
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_ZXC_ITEM);
         this.removeEvents();
         this._roomPropView.dispose();
         this._roomPropView = null;
         if(Boolean(this._btnBg))
         {
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
         }
         if(Boolean(this._startBtn.parent))
         {
            this._startBtn.parent.removeChild(this._startBtn);
         }
         this._startBtn.stop();
         this._startBtn = null;
         if(Boolean(this._prepareBtn.parent))
         {
            this._prepareBtn.parent.removeChild(this._prepareBtn);
         }
         this._prepareBtn.stop();
         this._cancelBtn.dispose();
         this._cancelBtn = null;
         this._inviteBtn.dispose();
         this._inviteBtn = null;
         if(Boolean(this._inviteFrame))
         {
            this._inviteFrame.dispose();
         }
         this._inviteFrame = null;
         if(Boolean(this._viewerItems))
         {
            for each(vi in this._viewerItems)
            {
               vi.dispose();
               vi = null;
            }
         }
         this._viewerItems = null;
         for each(item in this._playerItems)
         {
            item.dispose();
         }
         this._playerItems = null;
         this._hostTimer.stop();
         this._hostTimer = null;
         this._normalTimer.stop();
         this._normalTimer = null;
         this._info = null;
         SoundManager.instance.stop("007");
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

