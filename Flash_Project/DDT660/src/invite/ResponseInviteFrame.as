package invite
{
   import bombKing.BombKingManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.InviteInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class ResponseInviteFrame extends Frame
   {
      
      private static const InvitePool:DictionaryData = new DictionaryData(true);
      
      private var _titleBackground:ScaleBitmapImage;
      
      private var _responseTitle:FilterFrameText;
      
      private var _modeLabel:FilterFrameText;
      
      private var _mode:ScaleFrameImage;
      
      private var _leftLabel:FilterFrameText;
      
      private var _leftField:FilterFrameText;
      
      private var _rightLabel:FilterFrameText;
      
      private var _rightField:FilterFrameText;
      
      private var _levelField:FilterFrameText;
      
      private var _levelLabel:FilterFrameText;
      
      private var _tipField:FilterFrameText;
      
      private var _doButton:TextButton;
      
      private var _cancelButton:TextButton;
      
      private var _startTime:int = 0;
      
      private var _elapsed:int = 0;
      
      private var _titleString:String = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingni");
      
      private var _timeUnit:String = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
      
      private var _startupMark:Boolean = false;
      
      private var _markTime:int = 15;
      
      private var _visible:Boolean = true;
      
      private var _inviteInfo:InviteInfo;
      
      private var _resState:String;
      
      private var _timer:Timer;
      
      private var _uiReady:Boolean = false;
      
      public function ResponseInviteFrame()
      {
         super();
         this.configUi();
         this.addEvent();
         if(Boolean(this._inviteInfo))
         {
            this.onUpdateData();
         }
         this._timer = new Timer(1000,this._markTime);
      }
      
      private static function removeInvite(inviteFrame:ResponseInviteFrame) : void
      {
         InvitePool.remove(String(inviteFrame.inviteInfo.playerid));
      }
      
      public static function clearInviteFrame() : void
      {
         var resp:ResponseInviteFrame = null;
         var responseArr:Array = InvitePool.list;
         while(responseArr.length > 0)
         {
            resp = responseArr[0];
            if(Boolean(resp))
            {
               ObjectUtils.disposeObject(resp);
            }
         }
      }
      
      public static function newInvite(info:InviteInfo) : ResponseInviteFrame
      {
         var response:ResponseInviteFrame = null;
         if(InvitePool[String(info.playerid)] != null)
         {
            response = InvitePool[String(info.playerid)];
            response.inviteInfo = info;
         }
         else
         {
            response = ComponentFactory.Instance.creatComponentByStylename("ResponseInviteFrame");
            InvitePool.add(String(info.playerid),response);
            response.inviteInfo = info;
         }
         return response;
      }
      
      private function configUi() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._titleBackground = ComponentFactory.Instance.creatComponentByStylename("response.background_response_title");
         addToContent(this._titleBackground);
         this._responseTitle = ComponentFactory.Instance.creatComponentByStylename("invite.response.TitleField");
         this._responseTitle.text = this._titleString;
         addToContent(this._responseTitle);
         this._modeLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.ModeLabel");
         this._modeLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.ModeLabel");
         addToContent(this._modeLabel);
         this._mode = ComponentFactory.Instance.creatComponentByStylename("invite.response.GameMode");
         DisplayUtils.setFrame(this._mode,1);
         addToContent(this._mode);
         this._leftLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapLabel");
         this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
         addToContent(this._leftLabel);
         this._leftField = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapField");
         addToContent(this._leftField);
         this._rightLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeLabel");
         this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
         addToContent(this._rightLabel);
         this._rightField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeField");
         addToContent(this._rightField);
         this._levelLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelLabel");
         addToContent(this._levelLabel);
         this._levelField = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelField");
         addToContent(this._levelField);
         this._tipField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TipField");
         this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.meifanying");
         addToContent(this._tipField);
         this._doButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.DoButton");
         this._doButton.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._doButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.CancelButton");
         this._cancelButton.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._cancelButton);
         this._uiReady = true;
      }
      
      private function addEvent() : void
      {
         this._doButton.addEventListener(MouseEvent.CLICK,this.__onInviteAccept);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCloseClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__toStage);
         addEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         addEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
      }
      
      private function removeEvent() : void
      {
         this._doButton.removeEventListener(MouseEvent.CLICK,this.__onInviteAccept);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__toStage);
         removeEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
         removeEventListener(MouseEvent.CLICK,this.__bodyClick,true);
      }
      
      public function show() : void
      {
         if(!stage)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
            if(!WonderfulActivityManager.Instance.frame && !BuriedManager.Instance.isOpening && !BombKingManager.instance.frame)
            {
               LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false);
            }
         }
      }
      
      private function __focusOut(evt:FocusEvent) : void
      {
         addEventListener(MouseEvent.CLICK,this.__bodyClick,true);
      }
      
      private function __bodyClick(evt:MouseEvent) : void
      {
         StageReferance.stage.focus = this;
      }
      
      private function __toStage(evt:Event) : void
      {
         var lastFrame:ResponseInviteFrame = null;
         var bounds:Rectangle = null;
         var displayRect:Rectangle = null;
         var offset:Point = null;
         if(InvitePool.length > 1)
         {
            lastFrame = InvitePool.list[InvitePool.length - 2];
            bounds = lastFrame.getBounds(stage);
            displayRect = ComponentFactory.Instance.creatCustomObject("invite.response.DispalyRect");
            offset = ComponentFactory.Instance.creatCustomObject("invite.response.FrameOffset");
            if(bounds.right + offset.x >= displayRect.right || bounds.bottom + offset.y >= displayRect.bottom)
            {
               x = displayRect.x;
               y = displayRect.y;
            }
            else
            {
               x = bounds.x + offset.x;
               y = bounds.y + offset.y;
            }
         }
         else
         {
            bounds = getBounds(this);
            x = StageReferance.stageWidth - bounds.width >> 1;
            y = StageReferance.stageHeight - bounds.height >> 1;
         }
      }
      
      private function __focusIn(evt:FocusEvent) : void
      {
         removeEventListener(MouseEvent.CLICK,this.__bodyClick,true);
         this.bringToTop();
      }
      
      private function bringToTop() : void
      {
         if(Boolean(parent))
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
      }
      
      private function __onInviteAccept(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameManager.Instance.setup();
         if(this._inviteInfo.gameMode == RoomInfo.ENTERTAINMENT_ROOM || this._inviteInfo.gameMode == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            SocketManager.Instance.out.sendGameLogin(8,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else if(StateManager.currentStateType == StateType.ROOM_LIST)
         {
            SocketManager.Instance.out.sendGameLogin(1,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else if(StateManager.currentStateType == StateType.DUNGEON_LIST)
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(4,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         this.close();
         clearInviteFrame();
      }
      
      private function onUpdateData() : void
      {
         var data:InviteInfo = this._inviteInfo;
         var time:int = 1;
         if(data.secondType == 1)
         {
            time = 5;
         }
         if(data.secondType == 2)
         {
            time = 7;
         }
         if(data.secondType == 3)
         {
            time = 10;
         }
         if(data.secondType == 4)
         {
            time = 15;
         }
         titleText = LanguageMgr.GetTranslation("tank.invite.response.title",data.nickname);
         if(data.isOpenBoss)
         {
            this._titleString = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingniboss");
         }
         this._responseTitle.text = "“" + data.nickname + "”" + this._titleString;
         this._modeLabel.visible = true;
         if(data.gameMode < 2)
         {
            DisplayUtils.setFrame(this._mode,data.gameMode + 1);
            this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
            this._rightField.text = time + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
            this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
            this._leftField.text = String(MapManager.getMapName(data.mapid));
         }
         else if(data.gameMode == 2)
         {
            DisplayUtils.setFrame(this._mode,data.gameMode + 1);
            this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.levelRange");
            this._rightField.text = this.getLevelLimits(data.levelLimits);
            this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.roomLevel");
            this._leftField.text = this.getRoomHardLevel(data.hardLevel);
         }
         else if(data.gameMode > 2)
         {
            DisplayUtils.setFrame(this._mode,data.gameMode + 1);
            if(data.gameMode == 11 || data.gameMode == 21 || data.gameMode == 23)
            {
               DisplayUtils.setFrame(this._mode,5);
            }
            if(data.gameMode == 41)
            {
               DisplayUtils.setFrame(this._mode,1);
            }
            this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.duplicateName");
            PositionUtils.setPos(this._leftLabel,"duplicatePos");
            this._leftField.text = String(MapManager.getMapName(data.mapid));
            this._leftField.x = PositionUtils.creatPoint("duplicateNamePos").x;
            this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.gameLevel");
            this._rightLabel.x = PositionUtils.creatPoint("TimeLabelPos").x;
            this._rightField.text = this.getRoomHardLevel(data.hardLevel);
            this._rightField.x = PositionUtils.creatPoint("TimeFieldPos").x;
         }
         if(data.barrierNum == -1 || data.gameMode < 2)
         {
            this._levelLabel.visible = this._levelField.visible = false;
         }
         else
         {
            this._levelLabel.visible = this._levelField.visible = true;
            this._levelLabel.text = LanguageMgr.GetTranslation("tank.view.common.InviteAlertPanel.pass");
            this._levelField.text = String(data.barrierNum <= 0 ? 1 : data.barrierNum);
         }
         if(data.gameMode > 2 && (data.mapid <= 0 || data.mapid >= 10000))
         {
            if(data.mapid != 70001 && data.mapid != 12016)
            {
               this._leftField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
               this._rightField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
               this._levelField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
            }
         }
         if(data.gameMode == RoomInfo.FARM_BOSS && data.mapid == 70002)
         {
            this._modeLabel.visible = false;
            this._rightLabel.text = this._rightField.text = this._levelLabel.text = this._levelField.text = "";
            this._leftField.text = String(MapManager.getMapName(data.mapid));
            PositionUtils.setPos(this._leftLabel,"duplicatePos1");
            PositionUtils.setPos(this._leftField,"duplicateNamePos1");
         }
         this.restartMark();
      }
      
      private function __onMark(evt:TimerEvent) : void
      {
         this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.ruguo",this._markTime - this._timer.currentCount);
      }
      
      private function __onMarkComplete(evt:TimerEvent) : void
      {
         this.markComplete();
      }
      
      override protected function __onCloseClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      private function getLevelLimits(levelLimits:int) : String
      {
         var result:String = "";
         switch(levelLimits)
         {
            case 1:
               result = "1-10";
               break;
            case 2:
               result = "11-20";
               break;
            case 3:
               result = "20-30";
               break;
            case 4:
               result = "30-40";
               break;
            default:
               result = "";
         }
         return result + LanguageMgr.GetTranslation("grade");
      }
      
      private function getRoomHardLevel(HardLevel:int) : String
      {
         switch(HardLevel)
         {
            case 0:
               return LanguageMgr.GetTranslation("tank.room.difficulty.simple");
            case 1:
               return LanguageMgr.GetTranslation("tank.room.difficulty.normal");
            case 2:
               return LanguageMgr.GetTranslation("tank.room.difficulty.hard");
            case 3:
               return LanguageMgr.GetTranslation("tank.room.difficulty.hero");
            case 4:
               return LanguageMgr.GetTranslation("ddt.dungeonRoom.level4");
            default:
               return "";
         }
      }
      
      private function restartMark() : void
      {
         if(this._startupMark)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
            this._timer.stop();
         }
         this._startupMark = true;
         this._timer.addEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this._timer.reset();
         this._timer.start();
      }
      
      private function markComplete() : void
      {
         this._startupMark = false;
         this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this.close();
      }
      
      public function close() : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      public function get inviteInfo() : InviteInfo
      {
         return this._inviteInfo;
      }
      
      public function set inviteInfo(val:InviteInfo) : void
      {
         this._inviteInfo = val;
         if(this._uiReady)
         {
            this.onUpdateData();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this._timer = null;
         if(Boolean(this._titleBackground))
         {
            ObjectUtils.disposeObject(this._titleBackground);
            this._titleBackground = null;
         }
         if(Boolean(this._responseTitle))
         {
            ObjectUtils.disposeObject(this._responseTitle);
            this._responseTitle = null;
         }
         if(Boolean(this._modeLabel))
         {
            ObjectUtils.disposeObject(this._modeLabel);
            this._modeLabel = null;
         }
         if(Boolean(this._mode))
         {
            ObjectUtils.disposeObject(this._mode);
            this._mode = null;
         }
         if(Boolean(this._leftLabel))
         {
            ObjectUtils.disposeObject(this._leftLabel);
            this._leftLabel = null;
         }
         if(Boolean(this._leftField))
         {
            ObjectUtils.disposeObject(this._leftField);
            this._leftField = null;
         }
         if(Boolean(this._rightLabel))
         {
            ObjectUtils.disposeObject(this._rightLabel);
            this._rightLabel = null;
         }
         if(Boolean(this._rightField))
         {
            ObjectUtils.disposeObject(this._rightField);
            this._rightField = null;
         }
         if(Boolean(this._tipField))
         {
            ObjectUtils.disposeObject(this._tipField);
            this._tipField = null;
         }
         if(Boolean(this._doButton))
         {
            ObjectUtils.disposeObject(this._doButton);
            this._doButton = null;
         }
         if(Boolean(this._cancelButton))
         {
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         if(Boolean(this._levelLabel))
         {
            ObjectUtils.disposeObject(this._levelLabel);
            this._levelLabel = null;
         }
         if(Boolean(this._levelField))
         {
            ObjectUtils.disposeObject(this._levelLabel);
            this._levelField = null;
         }
         removeInvite(this);
         super.dispose();
      }
   }
}

