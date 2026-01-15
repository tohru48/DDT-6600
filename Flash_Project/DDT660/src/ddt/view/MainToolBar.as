package ddt.view
{
   import bagAndInfo.BagAndInfoManager;
   import calendar.CalendarManager;
   import com.greensock.TweenLite;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.*;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import exitPrompt.ExitPromptManager;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import gotopage.view.GotoPageController;
   import hall.tasktrack.HallTaskGuideManager;
   import horse.HorseManager;
   import im.IMController;
   import magicStone.MagicStoneManager;
   import petsBag.PetsBagManager;
   import quest.QuestBubbleManager;
   import road7th.utils.MovieClipWrapper;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class MainToolBar extends Sprite
   {
      
      private static var _instance:MainToolBar;
      
      public static const ENTER_HALL:int = 0;
      
      public static const LEAVE_HALL:int = 1;
      
      private var _toolBarBg:Bitmap;
      
      private var _bgGradient:Bitmap;
      
      private var _goSupplyBtn:BaseButton;
      
      private var _goShopBtn:BaseButton;
      
      private var _goBagBtn:BaseButton;
      
      private var _goTaskBtn:BaseButton;
      
      private var _goFriendListBtn:BaseButton;
      
      private var _goSignBtn:BaseButton;
      
      private var _goChannelBtn:BaseButton;
      
      private var _goReturnBtn:BaseButton;
      
      private var _goExitBtn:BaseButton;
      
      private var _competitionBtn:BaseButton;
      
      private var _goPetBtn:BaseButton;
      
      private var _horseBtn:BaseButton;
      
      private var _callBackFun:Function;
      
      private var _unReadTask:Boolean;
      
      private var _enabled:Boolean;
      
      private var _unReadMovement:Boolean;
      
      private var _taskEffectEnable:Boolean;
      
      private var _signEffectEnable:Boolean = true;
      
      private var _boxContainer:HBox;
      
      private var allBtns:Array;
      
      private var _isEvent:Boolean;
      
      private var _guideBtnTxtList:Array;
      
      private var _openBtnList:Array;
      
      private var _placePointList:Array;
      
      private var _taskShineEffect:IEffect;
      
      private var _signShineEffect:IEffect;
      
      private var _friendShineEffec:IEffect;
      
      private var _bagShineEffect:IEffect;
      
      private var _talkTimer:Timer = new Timer(1000);
      
      public function MainToolBar()
      {
         super();
         this.initView();
         this.initEvent();
         this.createGuideData();
      }
      
      public static function get Instance() : MainToolBar
      {
         if(_instance == null)
         {
            _instance = new MainToolBar();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._toolBarBg = ComponentFactory.Instance.creatBitmap("asset.toolbar.toolBarBg");
         this._goSupplyBtn = ComponentFactory.Instance.creat("toolbar.gochargebtn");
         this._goShopBtn = ComponentFactory.Instance.creat("toolbar.goshopbtn");
         this._goBagBtn = ComponentFactory.Instance.creat("toolbar.gobagbtn");
         this._goTaskBtn = ComponentFactory.Instance.creat("toolbar.gotaskbtn");
         this._goFriendListBtn = ComponentFactory.Instance.creat("toolbar.goimbtn");
         this._goChannelBtn = ComponentFactory.Instance.creat("toolbar.turntobtn");
         this._goReturnBtn = ComponentFactory.Instance.creat("toolbar.gobackbtn");
         this._goExitBtn = ComponentFactory.Instance.creat("toolbar.goexitbtn");
         this._goPetBtn = ComponentFactory.Instance.creat("toolbar.petbtn");
         this._competitionBtn = ComponentFactory.Instance.creat("toolbar.competitionbtn");
         this._horseBtn = ComponentFactory.Instance.creat("toolbar.horsebtn");
         this._goSupplyBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.supply");
         this._goShopBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.shop");
         this._goBagBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.bag");
         this._goTaskBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.task");
         this._goFriendListBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.friend");
         this._goChannelBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.channel");
         this._goReturnBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.back");
         this._goExitBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.exit");
         this._goPetBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.pet");
         this._competitionBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.liansai");
         this._horseBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.horse");
         this.allBtns = [];
         this.allBtns.push(this._goShopBtn);
         this.allBtns.push(this._goBagBtn);
         this.allBtns.push(this._goPetBtn);
         this.allBtns.push(this._horseBtn);
         this.allBtns.push(this._goFriendListBtn);
         this.allBtns.push(this._goChannelBtn);
         this.allBtns.push(this._goReturnBtn);
         this.allBtns.push(this._goSupplyBtn);
         this.allBtns.push(this._competitionBtn);
         addChild(this._toolBarBg);
         addChild(this._goReturnBtn);
         var bagShineIconPos:Point = ComponentFactory.Instance.creatCustomObject("toolbar.bagShineIconPos");
         var glowPos:Point = ComponentFactory.Instance.creatCustomObject("toolbar.ShineAssetPos");
         this._signShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goSignBtn,"asset.toolbar.SignBtnGlow",glowPos);
         this._friendShineEffec = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goFriendListBtn,"asset.toolbar.friendBtnGlow",glowPos);
         this._taskShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goTaskBtn,"asset.toolbar.TaskBtnGlow",glowPos);
         this._bagShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goBagBtn,"asset.toolbar.bagBtnGlow",bagShineIconPos);
      }
      
      private function createGuideData() : void
      {
         var obj:Object = {};
         obj["btn"] = this._goShopBtn;
         obj["place"] = 7;
         obj["level"] = 6;
         var obj2:Object = {};
         obj2["btn"] = this._goBagBtn;
         obj2["place"] = 6;
         obj2["level"] = 0;
         var obj3:Object = {};
         obj3["btn"] = this._goPetBtn;
         obj3["place"] = 5;
         obj3["level"] = 25;
         var obj4:Object = {};
         obj4["btn"] = this._horseBtn;
         obj4["place"] = 4;
         obj4["level"] = 28;
         var obj5:Object = {};
         obj5["btn"] = this._competitionBtn;
         obj5["place"] = 3;
         obj5["level"] = 26;
         var obj6:Object = {};
         obj6["btn"] = this._goFriendListBtn;
         obj6["place"] = 2;
         obj6["level"] = 11;
         var obj7:Object = {};
         obj7["btn"] = this._goChannelBtn;
         obj7["place"] = 1;
         obj7["level"] = 0;
         var obj8:Object = {};
         obj8["btn"] = this._goExitBtn;
         obj8["place"] = 0;
         obj8["level"] = 0;
         this._guideBtnTxtList = [];
         this._guideBtnTxtList.push(obj);
         this._guideBtnTxtList.push(obj2);
         this._guideBtnTxtList.push(obj3);
         this._guideBtnTxtList.push(obj4);
         this._guideBtnTxtList.push(obj5);
         this._guideBtnTxtList.push(obj6);
         this._guideBtnTxtList.push(obj7);
         this._guideBtnTxtList.push(obj8);
         this._placePointList = [];
         this._placePointList.push({
            "btn":new Point(946,540),
            "txt":new Point(943,579)
         });
         this._placePointList.push({
            "btn":new Point(891,540),
            "txt":new Point(891,575)
         });
         this._placePointList.push({
            "btn":new Point(835,542),
            "txt":new Point(841,580)
         });
         this._placePointList.push({
            "btn":new Point(780,543),
            "txt":new Point(782,584)
         });
         this._placePointList.push({
            "btn":new Point(730,539),
            "txt":new Point(733,586)
         });
         this._placePointList.push({
            "btn":new Point(677,543),
            "txt":new Point(680,574)
         });
         this._placePointList.push({
            "btn":new Point(623,539),
            "txt":new Point(623,579)
         });
         this._placePointList.push({
            "btn":new Point(567,539),
            "txt":new Point(567,579)
         });
      }
      
      public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
         this.update();
      }
      
      public function enableAll() : void
      {
         this.enabled = true;
         this._goExitBtn.enable = true;
         this.setReturnEnable(true);
      }
      
      public function disableAll() : void
      {
         this.enabled = false;
         this._goExitBtn.enable = false;
      }
      
      private function initEvent() : void
      {
         this._isEvent = true;
         this._goSupplyBtn.addEventListener(MouseEvent.CLICK,this.__onSupplyClick);
         this._goShopBtn.addEventListener(MouseEvent.CLICK,this.__onShopClick);
         this._goBagBtn.addEventListener(MouseEvent.CLICK,this.__onBagClick);
         this._goTaskBtn.addEventListener(MouseEvent.MOUSE_OVER,this._overTaskBtn);
         this._goTaskBtn.addEventListener(MouseEvent.MOUSE_OUT,this._outTaskBtn);
         this._goTaskBtn.addEventListener(MouseEvent.CLICK,this.__onTaskClick);
         this._goFriendListBtn.addEventListener(MouseEvent.CLICK,this.__onImClick);
         this._goFriendListBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__friendOverHandler);
         this._goFriendListBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__friendOutHandler);
         this._goChannelBtn.addEventListener(MouseEvent.CLICK,this.__onChannelClick);
         this._goReturnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
         this._goExitBtn.addEventListener(MouseEvent.CLICK,this.__onExitClick);
         this._goPetBtn.addEventListener(MouseEvent.CLICK,this.__onPetClick);
         this._competitionBtn.addEventListener(MouseEvent.CLICK,this.__onCompetitionClick);
         this._horseBtn.addEventListener(MouseEvent.CLICK,this.__onHorseClick);
         IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.addEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_MANU_GET,this.questManuGetHandler);
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.taskChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      protected function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]))
         {
            if(PlayerManager.Instance.Self.Grade == 40)
            {
               MagicStoneManager.instance.upTo40Flag = true;
               if(BagAndInfoManager.Instance.isShown)
               {
                  MagicStoneManager.instance.weakGuide(3);
                  MagicStoneManager.instance.removeWeakGuide(0);
               }
               else if(this._goBagBtn.enable)
               {
                  MagicStoneManager.instance.weakGuide(0,this);
               }
            }
         }
      }
      
      private function taskChangeHandler(event:TaskEvent) : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_2))
         {
            if(PlayerManager.Instance.Self.Grade >= 28 && event.info.QuestID == 568 && event.data.isAchieved && Boolean(this._horseBtn.parent))
            {
               NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(748,484),"","",this);
            }
         }
         if(event.info.QuestID == 7 && event.data.isAchieved)
         {
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE) && PlayerManager.Instance.Self.Grade == 13)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TEXP_GUIDE,0,new Point(805,484),"","",this);
            }
            else
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.TEXP_GUIDE);
            }
         }
         if(event.info.QuestID == 25 && event.data.isAchieved)
         {
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.CARD_GUIDE) && PlayerManager.Instance.Self.Grade == 14)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,0,new Point(805,484),"","",this);
            }
            else
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.CARD_GUIDE);
            }
         }
         if(event.info.QuestID == 29 && event.data.isAchieved)
         {
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.BEAD_GUIDE) && PlayerManager.Instance.Self.Grade == 16)
            {
               NewHandContainer.Instance.showArrow(ArrowType.BEAD_GUIDE,0,new Point(805,484),"","",this);
            }
            else
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.BEAD_GUIDE);
            }
         }
      }
      
      private function checkHorseGuide() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_2))
         {
            if(PlayerManager.Instance.Self.Grade >= 28 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(568)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(748,484),"","",this);
            }
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 13 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(7)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.TEXP_GUIDE,0,new Point(805,484),"","",this);
            }
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.CARD_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 14 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(25)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,0,new Point(805,484),"","",this);
            }
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.BEAD_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 16 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(29)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.BEAD_GUIDE,0,new Point(805,484),"","",this);
            }
         }
      }
      
      protected function __addToStageHandler(event:Event) : void
      {
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this.showFriendShineEffec(true);
         }
         else
         {
            this.showFriendShineEffec(false);
         }
      }
      
      protected function __noMessageHandler(event:Event) : void
      {
         this.showFriendShineEffec(false);
      }
      
      protected function __hasNewHandler(event:Event) : void
      {
         if(!this._talkTimer.running)
         {
            SoundManager.instance.play("200");
            this._talkTimer.start();
            this._talkTimer.addEventListener(TimerEvent.TIMER,this.__stopTalkTime);
         }
         this.showFriendShineEffec(true);
      }
      
      private function __stopTalkTime(event:TimerEvent) : void
      {
         this._talkTimer.stop();
         this._talkTimer.removeEventListener(TimerEvent.TIMER,this.__stopTalkTime);
      }
      
      protected function __friendOverHandler(event:MouseEvent) : void
      {
         IMController.Instance.showMessageBox(this._goFriendListBtn);
      }
      
      protected function __friendOutHandler(event:MouseEvent) : void
      {
         IMController.Instance.hideMessageBox();
      }
      
      public function newBtnOpenCartoon() : Point
      {
         var openBtn:Object = null;
         var destPosObj:Object = null;
         var curGrade:int = PlayerManager.Instance.Self.Grade;
         var tmpLen:int = int(this._guideBtnTxtList.length);
         for(var i:int = 0; i < tmpLen; i++)
         {
            if(curGrade == this._guideBtnTxtList[i].level)
            {
               openBtn = this._guideBtnTxtList[i];
               break;
            }
         }
         var tmpLen2:int = int(this._openBtnList.length);
         var tmpMoveBtnList:Array = [];
         var openPlace:int = int(openBtn.place);
         for(var k:int = 0; k < tmpLen2; k++)
         {
            if(this._openBtnList[k].place > openPlace)
            {
               tmpMoveBtnList.push(this._openBtnList[k]);
            }
         }
         tmpMoveBtnList.sortOn("place",Array.NUMERIC);
         var tmpLen3:int = int(tmpMoveBtnList.length);
         var tmpIndex:int = this._openBtnList.length - tmpLen3;
         openBtn["btn"].x = this._placePointList[tmpIndex]["btn"].x;
         openBtn["btn"].y = this._placePointList[tmpIndex]["btn"].y;
         var tmpStartPlace:int = tmpIndex + 1;
         for(var j:int = 0; j < tmpLen3; j++)
         {
            destPosObj = this._placePointList[tmpStartPlace + j];
            TweenLite.to(tmpMoveBtnList[j]["btn"],0.3,{
               "x":destPosObj["btn"].x,
               "y":destPosObj["btn"].y
            });
         }
         setTimeout(this.showCurLevelOpenBtn,300,openBtn);
         return this._placePointList[tmpIndex]["btn"] as Point;
      }
      
      private function showCurLevelOpenBtn(openBtn:Object) : void
      {
         var tmpLightMc:MovieClip = null;
         openBtn.btn.scaleX = 0.2;
         openBtn.btn.scaleY = 0.2;
         var tmpBtnX:int = int(openBtn.btn.x);
         var tmpBtnY:int = int(openBtn.btn.y);
         openBtn.btn.x += 23;
         openBtn.btn.y += 25;
         TweenLite.to(openBtn.btn,0.4,{
            "x":tmpBtnX,
            "y":tmpBtnY,
            "scaleX":1,
            "scaleY":1
         });
         tmpLightMc = ComponentFactory.Instance.creat("asset.newOpenGuide.bagOpenLightMc");
         tmpLightMc.mouseEnabled = false;
         tmpLightMc.mouseChildren = false;
         tmpLightMc.x = tmpBtnX;
         tmpLightMc.y = tmpBtnY;
         addChild(tmpLightMc);
         var mcw:MovieClipWrapper = new MovieClipWrapper(tmpLightMc,true,true);
         addChild(openBtn.btn);
         if(openBtn.btn == this._goShopBtn)
         {
            addChild(this._goSupplyBtn);
         }
         this.checkHorseGuide();
         HallTaskGuideManager.instance.showTask1ClickBagArrow();
      }
      
      public function btnOpen() : void
      {
         this._openBtnList = [];
         var tmpLen:int = int(this._guideBtnTxtList.length);
         var curGrade:int = PlayerManager.Instance.Self.Grade;
         for(var i:int = 0; i < tmpLen; i++)
         {
            if(curGrade > this._guideBtnTxtList[i].level || curGrade == this._guideBtnTxtList[i].level && PlayerManager.Instance.Self.isNewOnceFinish(Step.NEW_OPEN_GUIDE_START + this._guideBtnTxtList[i].level))
            {
               this._openBtnList.push(this._guideBtnTxtList[i]);
            }
         }
         this._openBtnList.sortOn("place",Array.NUMERIC);
         var tmpLen2:int = int(this._openBtnList.length);
         for(var k:int = 0; k < tmpLen2; k++)
         {
            if(!this._openBtnList[k]["btn"].parent)
            {
               addChild(this._openBtnList[k]["btn"]);
            }
            this._openBtnList[k]["btn"].x = this._placePointList[k]["btn"].x;
            this._openBtnList[k]["btn"].y = this._placePointList[k]["btn"].y;
         }
         if(Boolean(this._goShopBtn.parent))
         {
            addChild(this._goSupplyBtn);
         }
         this.checkHorseGuide();
         HallTaskGuideManager.instance.showTask1ClickBagArrow();
      }
      
      private function questManuGetHandler(event:CrazyTankSocketEvent) : void
      {
         HallTaskGuideManager.instance.showTask1ClickBagArrow();
      }
      
      public function set backFunction(fn:Function) : void
      {
         this._callBackFun = fn;
      }
      
      private function removeEvent() : void
      {
         this._isEvent = false;
         this._goSupplyBtn.removeEventListener(MouseEvent.CLICK,this.__onSupplyClick);
         this._goShopBtn.removeEventListener(MouseEvent.CLICK,this.__onShopClick);
         this._goBagBtn.removeEventListener(MouseEvent.CLICK,this.__onBagClick);
         this._goTaskBtn.removeEventListener(MouseEvent.MOUSE_OVER,this._overTaskBtn);
         this._goTaskBtn.removeEventListener(MouseEvent.MOUSE_OUT,this._outTaskBtn);
         this._goTaskBtn.removeEventListener(MouseEvent.CLICK,this.__onTaskClick);
         this._goFriendListBtn.removeEventListener(MouseEvent.CLICK,this.__onImClick);
         this._goFriendListBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__friendOverHandler);
         this._goFriendListBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__friendOutHandler);
         this._goChannelBtn.removeEventListener(MouseEvent.CLICK,this.__onChannelClick);
         this._goReturnBtn.removeEventListener(MouseEvent.CLICK,this.__onReturnClick);
         this._goExitBtn.removeEventListener(MouseEvent.CLICK,this.__onExitClick);
         this._goPetBtn.removeEventListener(MouseEvent.CLICK,this.__onPetClick);
         this._competitionBtn.removeEventListener(MouseEvent.CLICK,this.__onCompetitionClick);
         this._horseBtn.removeEventListener(MouseEvent.CLICK,this.__onHorseClick);
         IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.removeEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.QUEST_MANU_GET,this.questManuGetHandler);
         TaskManager.instance.removeEventListener(TaskEvent.CHANGED,this.taskChangeHandler);
      }
      
      public function show() : void
      {
         if(!this._isEvent)
         {
            this.initEvent();
         }
         this.enableAll();
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this.showFriendShineEffec(true);
         }
         else
         {
            this.showFriendShineEffec(false);
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
         this.refresh();
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      public function setRoomWaitState() : void
      {
         KeyboardShortcutsManager.Instance.forbiddenSection(1,true);
      }
      
      public function setRoomStartState() : void
      {
         KeyboardShortcutsManager.Instance.forbiddenSection(1,false);
         this._goReturnBtn.enable = this._goShopBtn.enable = this._goSupplyBtn.enable = this._goPetBtn.enable = this._competitionBtn.enable = false;
         this.setChannelEnable(false);
         this.setBagEnable(false);
      }
      
      public function setFightRoomStartState() : void
      {
         KeyboardShortcutsManager.Instance.forbiddenSection(1,false);
         this._goReturnBtn.enable = this._goShopBtn.enable = this._goSupplyBtn.enable = this._goPetBtn.enable = false;
         this.setChannelEnable(false);
         this.setBagEnable(false);
         this.showTaskShineEffect(false);
      }
      
      public function setRoomStartState2(value:Boolean) : void
      {
         KeyboardShortcutsManager.Instance.forbiddenSection(1,value);
         this._goReturnBtn.enable = this._goShopBtn.enable = this._goSupplyBtn.enable = this._goPetBtn.enable = this._competitionBtn.enable = value;
         this.setChannelEnable(value);
         this.setBagEnable(value);
      }
      
      private function setSeverListStartState() : void
      {
         this._goReturnBtn.enable = this._goTaskBtn.enable = this._goShopBtn.enable = this._goSupplyBtn.enable = this._goPetBtn.enable = this._competitionBtn.enable = false;
         this.setChannelEnable(false);
         this.setFriendBtnEnable(false);
         this.setBagEnable(false);
         if(Boolean(this._taskShineEffect))
         {
            this.showTaskShineEffect(false);
         }
      }
      
      public function setReturnEnable(value:Boolean) : void
      {
         this._goReturnBtn.enable = value;
      }
      
      public function updateReturnBtn(type:int) : void
      {
         switch(type)
         {
            case ENTER_HALL:
               addChild(this._goExitBtn);
               this._goExitBtn.visible = true;
               this._goReturnBtn.visible = false;
               break;
            case LEAVE_HALL:
               addChild(this._goReturnBtn);
               this._goExitBtn.visible = false;
               this._goReturnBtn.visible = true;
         }
      }
      
      public function set ExitBtnVisible(value:Boolean) : void
      {
         this._goExitBtn.visible = value;
      }
      
      private function isBitMapAddGrayFilter(bmp:Bitmap, flg:Boolean) : void
      {
         if(bmp == null)
         {
            return;
         }
         if(!flg)
         {
            bmp.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            bmp.filters = null;
         }
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         QuestBubbleManager.Instance.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __onReturnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("015");
         if(StateManager.currentStateType == StateType.MAIN)
         {
            KeyboardShortcutsManager.Instance.forbiddenFull();
         }
         else if(StateManager.currentStateType == StateType.FARM)
         {
            FarmModelController.instance.exitFarm(PlayerManager.Instance.Self.ID);
         }
         if(this._callBackFun != null)
         {
            this._callBackFun();
         }
         else
         {
            StateManager.back();
         }
      }
      
      private function __onExitClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ExitPromptManager.Instance.showView("1");
      }
      
      private function __onCompetitionClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         SocketManager.Instance.out.enterBuried();
      }
      
      private function __onPetClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         PetsBagManager.instance.show();
      }
      
      private function __onImClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         IMController.Instance.switchVisible();
      }
      
      private function __onChannelClick(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         GotoPageController.Instance.switchVisible();
      }
      
      private function __onSignClick(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         this._signEffectEnable = false;
         CalendarManager.getInstance().open(2);
      }
      
      private function __onHorseClick(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         HorseManager.instance.loadModule();
      }
      
      public function set signEffectEnable(value:Boolean) : void
      {
         this._signEffectEnable = value;
      }
      
      private function _overTaskBtn(e:MouseEvent) : void
      {
         ShowTipManager.Instance.removeTip(this._goTaskBtn);
         QuestBubbleManager.Instance.addEventListener(QuestBubbleManager.Instance.SHOWTASKTIP,this._showTaskTip);
         QuestBubbleManager.Instance.show();
      }
      
      private function _outTaskBtn(e:MouseEvent) : void
      {
         QuestBubbleManager.Instance.dispose();
      }
      
      private function _showTaskTip(e:Event) : void
      {
         ShowTipManager.Instance.addTip(this._goTaskBtn);
         ShowTipManager.Instance.showTip(this._goTaskBtn);
         QuestBubbleManager.Instance.dispose();
      }
      
      private function __onTaskClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         if(Boolean(this._taskShineEffect) && this._taskEffectEnable)
         {
            this._taskEffectEnable = false;
            this.showTaskShineEffect(false);
         }
         QuestBubbleManager.Instance.dispose(true);
         this.showTask();
      }
      
      private function showTask() : void
      {
         TaskManager.instance.switchVisible();
      }
      
      private function __onBagClick(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         BagAndInfoManager.Instance.showBagAndInfo();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
         {
            SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
            SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
         }
         MagicStoneManager.instance.removeWeakGuide(0);
      }
      
      private function __onShopClick(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(this.toShopNeedConfirm())
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.ToShopConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__confirmToShopResponse);
         }
         else
         {
            StateManager.setState(StateType.SHOP);
         }
         SoundManager.instance.play("003");
      }
      
      private function toShopNeedConfirm() : Boolean
      {
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM)
         {
            return true;
         }
         return false;
      }
      
      private function __confirmToShopResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__confirmToShopResponse);
         ObjectUtils.disposeObject(alert);
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.SHOP);
         }
      }
      
      private function __onSupplyClick(evnet:MouseEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      public function set unReadTask(value:Boolean) : void
      {
         if(this._unReadTask == value)
         {
            return;
         }
         this._unReadTask = value;
         if(this._enabled)
         {
            this.updateTask();
         }
      }
      
      public function get unReadTask() : Boolean
      {
         return this._unReadTask;
      }
      
      public function set unReadMovement(value:Boolean) : void
      {
      }
      
      public function get unReadMovement() : Boolean
      {
         return this._unReadMovement;
      }
      
      public function showTaskHightLight() : void
      {
         this.unReadTask = true;
      }
      
      public function hideTaskHightLight() : void
      {
         this.unReadTask = false;
      }
      
      public function showmovementHightLight() : void
      {
         this.unReadMovement = true;
      }
      
      public function setRoomState() : void
      {
         this.setChannelEnable(false);
      }
      
      public function setShopState() : void
      {
         this.setBagEnable(false);
      }
      
      public function setAuctionHouseState() : void
      {
         this.setBagEnable(false);
      }
      
      private function update() : void
      {
         for(var i:uint = 0; i < this.allBtns.length; i++)
         {
            this.setEnableByIndex(i,this._enabled);
         }
         this.setRoomWaitState();
      }
      
      private function setEnableByIndex(index:int, value:Boolean) : void
      {
         if(index == 1)
         {
            this.setBagEnable(value);
         }
         else if(index == 4)
         {
            this.setFriendBtnEnable(value);
         }
         else if(index != 5)
         {
            if(index == 6)
            {
               this.setChannelEnable(value);
            }
            else
            {
               this.allBtns[index].enable = value;
            }
         }
      }
      
      private function updateTask() : void
      {
         if(this._unReadTask)
         {
            this.showTaskShineEffect(true);
         }
         else
         {
            this.showTaskShineEffect(false);
         }
         this._goTaskBtn.enable = true;
         this.tipTask();
      }
      
      private function showFriendShineEffec(show:Boolean) : void
      {
         if(show && Boolean(this._goFriendListBtn.parent))
         {
            this._friendShineEffec.play();
            this._goFriendListBtn.alpha = 0;
         }
         else
         {
            this._friendShineEffec.stop();
            this._goFriendListBtn.alpha = 1;
         }
      }
      
      private function showTaskShineEffect(show:Boolean) : void
      {
      }
      
      public function showSignShineEffect(show:Boolean) : void
      {
         if(show)
         {
            this._signShineEffect.play();
         }
         else
         {
            this._signShineEffect.stop();
         }
      }
      
      public function showBagShineEffect(show:Boolean) : void
      {
         if(show && Boolean(this._goBagBtn.parent))
         {
            this._bagShineEffect.play();
            this._goBagBtn.alpha = 0;
         }
         else
         {
            this._bagShineEffect.stop();
            this._goBagBtn.alpha = 1;
         }
      }
      
      public function __player(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function refresh() : void
      {
      }
      
      private function setChannelEnable(value:Boolean) : void
      {
         this._goChannelBtn.enable = value;
         if(value && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHANNEL_OPEN))
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandChannel(true);
            KeyboardShortcutsManager.Instance.prohibitNewHandSeting(true);
         }
         else
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandChannel(false);
            KeyboardShortcutsManager.Instance.prohibitNewHandSeting(false);
         }
      }
      
      private function setBagEnable(value:Boolean) : void
      {
         this._goBagBtn.enable = value;
         if(value)
         {
            if(MagicStoneManager.instance.upTo40Flag)
            {
               MagicStoneManager.instance.weakGuide(0,this);
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.MAGIC_STONE_OPEN);
            this.showBagShineEffect(false);
         }
         if(value && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.BAG_OPEN))
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandBag(true);
         }
         else
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandBag(false);
         }
      }
      
      private function setFriendBtnEnable(value:Boolean) : void
      {
         this._goFriendListBtn.enable = value;
         if(value && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_OPEN))
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandFriend(true);
         }
         else
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandFriend(false);
         }
      }
      
      private function setSignEnable(value:Boolean) : void
      {
         this._goSignBtn.enable = value;
         if(value && this._goSignBtn.parent && this._signEffectEnable && !CalendarManager.getInstance().hasTodaySigned())
         {
            this.showSignShineEffect(true);
         }
         else
         {
            this.showSignShineEffect(false);
         }
         if(value && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.SIGN_OPEN))
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandCalendar(true);
         }
         else
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandCalendar(false);
         }
      }
      
      public function tipTask() : void
      {
      }
      
      public function get goBagBtn() : BaseButton
      {
         return this._goBagBtn;
      }
   }
}

