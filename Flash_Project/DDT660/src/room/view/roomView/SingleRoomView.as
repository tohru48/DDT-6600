package room.view.roomView
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.SingleRoomRightPropView;
   import vip.VipController;
   
   public class SingleRoomView extends BaseAlerFrame
   {
      
      public static const ENCOUNTER:int = 1;
      
      protected var _roomInfo:RoomInfo;
      
      protected var _bg:Bitmap;
      
      protected var _singleRoomRightPropView:SingleRoomRightPropView;
      
      protected var _nameText:FilterFrameText;
      
      protected var _vipName:GradientText;
      
      protected var _guildTitle:FilterFrameText;
      
      protected var _guildName:FilterFrameText;
      
      protected var _player:ICharacter;
      
      protected var _selfInfo:SelfInfo;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _vipIcon:VipLevelIcon;
      
      protected var _marriedIcon:MarriedIcon;
      
      protected var _academyIcon:AcademyIcon;
      
      protected var _iconContainer:VBox;
      
      protected var _badge:Badge;
      
      protected var _model:ScaleFrameImage;
      
      protected var _model2:ScaleFrameImage;
      
      protected var _explain:FilterFrameText;
      
      protected var _cancelBtn:SimpleBitmapButton;
      
      protected var _timerText:FilterFrameText;
      
      protected var _waiting:Bitmap;
      
      protected var _chatBtn:SimpleBitmapButton;
      
      protected var _timer:Timer;
      
      private var _singBattleState:int;
      
      private var _isCloseOrEscClick:Boolean = false;
      
      private var _type:int;
      
      private var _cancelBtnBg:Bitmap;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _cancelMatchBtn:SimpleBitmapButton;
      
      private var _1v1Btn:SelectedCheckButton;
      
      private var _1v1Txt:FilterFrameText;
      
      private var _2v2Btn:SelectedCheckButton;
      
      private var _2v2Txt:FilterFrameText;
      
      private var _3v3Btn:SelectedCheckButton;
      
      private var _3v3Txt:FilterFrameText;
      
      private var _4v4Btn:SelectedCheckButton;
      
      private var _4v4Txt:FilterFrameText;
      
      private var _BtnGroup:SelectedButtonGroup;
      
      protected var _isCancelWait:Boolean = true;
      
      public function SingleRoomView(type:int = 6)
      {
         this._type = type;
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.roomView.SingleRoomView.BG");
         addToContent(this._bg);
         this._selfInfo = PlayerManager.Instance.Self;
         this.createRightView();
         this.createLeftView();
         this.initTitle();
      }
      
      protected function createRightView() : void
      {
         this._player = CharactoryFactory.createCharacter(this._selfInfo,"room");
         this._player.showGun = true;
         this._player.show();
         this._player.setShowLight(true);
         this._player.scaleX = -1.3;
         this._player.scaleY = 1.3;
         PositionUtils.setPos(this._player,"room.view.roomView.singleRoomView.playerPos");
         addToContent(this._player as DisplayObject);
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.nickNameText");
         this._nameText.text = this._selfInfo.NickName;
         addToContent(this._nameText);
         if(this._selfInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(104,this._selfInfo.typeVIP);
            this._vipName.textSize = 16;
            this._vipName.x = this._nameText.x;
            this._vipName.y = this._nameText.y - 2;
            this._vipName.text = this._selfInfo.NickName;
            addToContent(this._vipName);
         }
         PositionUtils.adaptNameStyle(this._selfInfo,this._nameText,this._vipName);
         this._guildTitle = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.guildTitle");
         this._guildTitle.text = LanguageMgr.GetTranslation("tank.menu.ClubName");
         addToContent(this._guildTitle);
         this._guildName = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.guildName");
         this._guildName.text = this._selfInfo.ConsortiaName;
         addToContent(this._guildName);
         this._explain = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.explainText");
         addToContent(this._explain);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.iconContainer");
         addToContent(this._iconContainer);
         this._levelIcon = ComponentFactory.Instance.creat("room.view.roomView.singleRoomView.levelIcon");
         this._levelIcon.setInfo(this._selfInfo.Grade,this._selfInfo.Repute,this._selfInfo.WinCount,this._selfInfo.TotalCount,this._selfInfo.FightPower,this._selfInfo.Offer,true,false);
         addToContent(this._levelIcon);
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("room.view.roomView.singleRoomView.VipIcon");
         this._vipIcon.setInfo(this._selfInfo);
         this._iconContainer.addChild(this._vipIcon);
         if(!this._selfInfo.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(this._selfInfo.SpouseID > 0 && !this._marriedIcon)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("room.view.roomView.singleRoomView.MarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":this._selfInfo.SpouseName,
               "gender":this._selfInfo.Sex
            };
            this._iconContainer.addChild(this._marriedIcon);
         }
         if(this._selfInfo.shouldShowAcademyIcon())
         {
            this._academyIcon = ComponentFactory.Instance.creatCustomObject("room.view.roomView.singleRoomView.AcademyIcon");
            this._academyIcon.tipData = this._selfInfo;
            this._iconContainer.addChild(this._academyIcon);
         }
         if(this._selfInfo.ConsortiaID > 0 && Boolean(this._selfInfo.badgeID))
         {
            this._badge = new Badge();
            this._badge.badgeID = this._selfInfo.badgeID;
            this._badge.showTip = true;
            this._badge.tipData = this._selfInfo.ConsortiaName;
            this._iconContainer.addChild(this._badge);
         }
      }
      
      private function initTitle() : void
      {
         if(this._type == RoomManager.BATTLE_MODEL)
         {
            info = new AlertInfo(LanguageMgr.GetTranslation("ddt.battleGroud"));
            this._model = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.battleTitle");
            addToContent(this._model);
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.cancelBtn2");
            addToContent(this._cancelBtn);
            this._explain.text = LanguageMgr.GetTranslation("room.view.roomView.SingleRoomView.explain2");
            this._timer.start();
            this._timerText.visible = true;
            this._waiting.visible = true;
         }
         else
         {
            info = new AlertInfo(LanguageMgr.GetTranslation("room.view.roomView.SingleRoomView.title"));
            this._model = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.modelTitle1");
            addToContent(this._model);
            this._model2 = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.modelTitle2");
            addToContent(this._model2);
            this._1v1Btn = ComponentFactory.Instance.creatComponentByStylename("singleroom.SelectBtn");
            addToContent(this._1v1Btn);
            this._1v1Txt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.typeTxt");
            this._1v1Txt.text = LanguageMgr.GetTranslation("ddt.roomlist.1v1");
            this._1v1Txt.x = this._1v1Btn.x + 28;
            this._1v1Txt.y = this._1v1Btn.y + 8;
            addToContent(this._1v1Txt);
            this._2v2Btn = ComponentFactory.Instance.creatComponentByStylename("singleroom.SelectBtn");
            addToContent(this._2v2Btn);
            this._2v2Btn.x = this._1v1Btn.x + 108;
            this._2v2Txt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.typeTxt");
            this._2v2Txt.x = this._2v2Btn.x + 28;
            this._2v2Txt.y = this._2v2Btn.y + 8;
            this._2v2Txt.text = LanguageMgr.GetTranslation("ddt.roomlist.2v2");
            addToContent(this._2v2Txt);
            this._3v3Btn = ComponentFactory.Instance.creatComponentByStylename("singleroom.SelectBtn");
            addToContent(this._3v3Btn);
            this._3v3Btn.y = this._2v2Btn.y + 24;
            this._3v3Txt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.typeTxt");
            this._3v3Txt.x = this._3v3Btn.x + 28;
            this._3v3Txt.y = this._3v3Btn.y + 8;
            this._3v3Txt.text = LanguageMgr.GetTranslation("ddt.roomlist.3v3");
            addToContent(this._3v3Txt);
            this._4v4Btn = ComponentFactory.Instance.creatComponentByStylename("singleroom.SelectBtn");
            addToContent(this._4v4Btn);
            this._4v4Btn.x = this._3v3Btn.x + 108;
            this._4v4Btn.y = this._3v3Btn.y;
            this._4v4Txt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.typeTxt");
            this._4v4Txt.x = this._4v4Btn.x + 28;
            this._4v4Txt.y = this._4v4Btn.y + 8;
            this._4v4Txt.text = LanguageMgr.GetTranslation("ddt.roomlist.4v4");
            addToContent(this._4v4Txt);
            this._BtnGroup = new SelectedButtonGroup();
            this._BtnGroup.addSelectItem(this._1v1Btn);
            this._BtnGroup.addSelectItem(this._2v2Btn);
            this._BtnGroup.addSelectItem(this._3v3Btn);
            this._BtnGroup.addSelectItem(this._4v4Btn);
            if(this._selfInfo.Grade < 6)
            {
               this._2v2Btn.enable = this._3v3Btn.enable = this._4v4Btn.enable = false;
            }
            this._BtnGroup.selectIndex = 0;
            this._cancelBtnBg = ComponentFactory.Instance.creat("asset.ddtroom.cancelBtnBg");
            addToContent(this._cancelBtnBg);
            this._startBtn = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.startBtn");
            addToContent(this._startBtn);
            this._cancelMatchBtn = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.cancelBtn");
            addToContent(this._cancelMatchBtn);
            this._cancelMatchBtn.visible = false;
            this._explain.text = LanguageMgr.GetTranslation("room.view.roomView.SingleRoomView.explainI");
            this.changeState(1);
         }
         this.initEvent();
      }
      
      protected function __BtnGroupChange(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function createLeftView() : void
      {
         this._singleRoomRightPropView = new SingleRoomRightPropView();
         PositionUtils.setPos(this._singleRoomRightPropView,"room.view.roomView.singleRoomView.SingleRoomRightPropViewPos");
         addToContent(this._singleRoomRightPropView);
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.chatButton");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addToContent(this._chatBtn);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timerText = ComponentFactory.Instance.creatComponentByStylename("room.view.roomView.SingleRoomView.timeTxt");
         this._timerText.text = "00";
         this._timerText.visible = false;
         addToContent(this._timerText);
         this._waiting = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.matchingTxt");
         PositionUtils.setPos(this._waiting,"room.view.roomView.singleRoomView.waitingPos");
         this._waiting.visible = false;
         addToContent(this._waiting);
      }
      
      protected function initEvent() : void
      {
         if(this._type == RoomManager.BATTLE_MODEL)
         {
            this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancel);
         }
         else
         {
            this._BtnGroup.addEventListener(Event.CHANGE,this.__BtnGroupChange);
            this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStart);
            this._cancelMatchBtn.addEventListener(MouseEvent.CLICK,this.__onCancelMatch);
         }
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
         GameManager.Instance.addEventListener(GameManager.START_MATCH,this.__onStartMatch);
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
      }
      
      protected function __onStartMatch(event:Event) : void
      {
         StateManager.setState(StateType.SINGLEBATTLE_MATCHING,GameManager.Instance.Current);
      }
      
      protected function __onStart(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendSingleRoomBegin(this._BtnGroup.selectIndex + 7);
      }
      
      public function startTime() : void
      {
         this.changeState(2);
         this._startBtn.visible = false;
         this._cancelMatchBtn.visible = true;
      }
      
      private function changeState(type:int) : void
      {
         this._singBattleState = type;
         if(type == 1)
         {
            this._1v1Btn.visible = this._1v1Txt.visible = this._model2.visible = true;
            this._2v2Btn.visible = this._2v2Txt.visible = true;
            this._3v3Btn.visible = this._3v3Txt.visible = true;
            this._4v4Btn.visible = this._4v4Txt.visible = true;
            this._timerText.text = "00";
            this._timer.stop();
            this._timer.reset();
            this._timerText.visible = this._waiting.visible = false;
         }
         else
         {
            this._1v1Btn.visible = this._1v1Txt.visible = this._model2.visible = false;
            this._2v2Btn.visible = this._2v2Txt.visible = false;
            this._3v3Btn.visible = this._3v3Txt.visible = false;
            this._4v4Btn.visible = this._4v4Txt.visible = false;
            this._timerText.text = "00";
            this._timer.start();
            this._timerText.visible = this._waiting.visible = true;
         }
      }
      
      protected function __chatClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LayerManager.Instance.addToLayer(ChatManager.Instance.view,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      protected function removeEvent() : void
      {
         if(this._type == RoomManager.BATTLE_MODEL)
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__onCancel);
         }
         else
         {
            this._BtnGroup.removeEventListener(Event.CHANGE,this.__BtnGroupChange);
            this._startBtn.removeEventListener(MouseEvent.CLICK,this.__onStart);
            this._cancelMatchBtn.removeEventListener(MouseEvent.CLICK,this.__onCancelMatch);
         }
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
         GameManager.Instance.removeEventListener(GameManager.START_MATCH,this.__onStartMatch);
         this._chatBtn.removeEventListener(MouseEvent.CLICK,this.__chatClick);
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         this._isCancelWait = false;
         var roomInfo:RoomInfo = RoomManager.Instance.current;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
      }
      
      protected function __onCancel(event:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
      }
      
      protected function __onCancelMatch(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._cancelMatchBtn.visible = false;
         this._startBtn.visible = true;
         this.changeState(1);
         GameInSocketOut.sendCancelWait();
      }
      
      protected function __timer(evt:TimerEvent) : void
      {
         var min:uint = this._timer.currentCount / 60;
         var sec:uint = this._timer.currentCount % 60;
         this._timerText.text = sec > 9 ? sec.toString() : "0" + sec;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         if(this._type == RoomManager.SINGLEBATTLE_MODEL)
         {
            if(this._isCloseOrEscClick && this._singBattleState == 2)
            {
               GameInSocketOut.sendCancelWait();
            }
         }
         else if(this._isCancelWait && this._type == RoomManager.BATTLE_MODEL)
         {
            GameInSocketOut.sendCancelWait();
         }
         if(PlayerInfoViewControl._isBattle)
         {
            PlayerInfoViewControl._isBattle = false;
         }
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this._timer.stop();
            this._timer = null;
         }
         if(Boolean(this._timerText))
         {
            ObjectUtils.disposeObject(this._timerText);
         }
         this._timerText = null;
         if(Boolean(this._waiting))
         {
            ObjectUtils.disposeObject(this._waiting);
         }
         this._waiting = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._singleRoomRightPropView);
         this._singleRoomRightPropView = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._guildTitle);
         this._guildTitle = null;
         ObjectUtils.disposeObject(this._guildName);
         this._guildName = null;
         ObjectUtils.disposeObject(this._player);
         this._player = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._marriedIcon);
         this._marriedIcon = null;
         ObjectUtils.disposeObject(this._academyIcon);
         this._academyIcon = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         ObjectUtils.disposeObject(this._explain);
         this._explain = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         if(Boolean(this._model2))
         {
            ObjectUtils.disposeObject(this._model2);
         }
         this._model2 = null;
         if(Boolean(this._startBtn))
         {
            ObjectUtils.disposeObject(this._startBtn);
         }
         this._startBtn = null;
         if(Boolean(this._1v1Btn))
         {
            ObjectUtils.disposeObject(this._1v1Btn);
         }
         this._1v1Btn = null;
         if(Boolean(this._2v2Btn))
         {
            ObjectUtils.disposeObject(this._2v2Btn);
         }
         this._2v2Btn = null;
         if(Boolean(this._3v3Btn))
         {
            ObjectUtils.disposeObject(this._3v3Btn);
         }
         this._3v3Btn = null;
         if(Boolean(this._4v4Btn))
         {
            ObjectUtils.disposeObject(this._4v4Btn);
         }
         this._4v4Btn = null;
         if(Boolean(this._1v1Txt))
         {
            ObjectUtils.disposeObject(this._1v1Txt);
         }
         this._1v1Txt = null;
         if(Boolean(this._2v2Txt))
         {
            ObjectUtils.disposeObject(this._2v2Txt);
         }
         this._2v2Txt = null;
         if(Boolean(this._3v3Txt))
         {
            ObjectUtils.disposeObject(this._3v3Txt);
         }
         this._3v3Txt = null;
         if(Boolean(this._4v4Txt))
         {
            ObjectUtils.disposeObject(this._4v4Txt);
         }
         this._4v4Txt = null;
         if(Boolean(this._cancelBtnBg))
         {
            ObjectUtils.disposeObject(this._cancelBtnBg);
         }
         this._cancelBtnBg = null;
         if(Boolean(this._cancelMatchBtn))
         {
            ObjectUtils.disposeObject(this._cancelMatchBtn);
         }
         this._cancelMatchBtn = null;
         super.dispose();
      }
      
      public function set isCloseOrEscClick(value:Boolean) : void
      {
         this._isCloseOrEscClick = value;
      }
   }
}

