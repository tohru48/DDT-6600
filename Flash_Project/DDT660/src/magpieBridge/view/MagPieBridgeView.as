package magpieBridge.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import ddtBuried.items.BuriedBox;
   import ddtBuried.items.BuriedReturnBtn;
   import ddtBuried.items.DiceRoll;
   import ddtBuried.role.BuriedPlayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import magpieBridge.MagpieBridgeManager;
   import magpieBridge.event.MagpieBridgeEvent;
   import road7th.comm.PackageIn;
   
   public class MagPieBridgeView extends BaseStateView implements Disposeable
   {
      
      private var _playerPosArray:Array = [[new Point(802,83),new Point(718,83),new Point(651,83),new Point(578,83),new Point(507,83),new Point(514,118),new Point(521,159),new Point(599,159),new Point(674,159),new Point(686,197),new Point(698,238),new Point(715,283),new Point(729,331),new Point(645,331),new Point(562,331),new Point(477,331),new Point(394,331),new Point(312,331),new Point(221,331),new Point(140,331),new Point(56,331),new Point(59,284),new Point(63,239),new Point(68,198),new Point(70,160),new Point(75,117),new Point(76,82),new Point(150,82),new Point(219,82),new Point(292,82),new Point(294,117),new Point(296,159),new Point(300,198),new Point(376,198),new Point(453,198),new Point(462,239)],[new Point(819,167),new Point(736,167),new Point(664,167),new Point(649,130),new Point(640,93),new Point(574,93),new Point(505,93),new Point(439,93),new Point(370,93),new Point(302,93),new Point(234,93),new Point(167,93),new Point(99,93),new Point(98,128),new Point(96,166),new Point(91,203),new Point(89
      ,245),new Point(86,287),new Point(83,334),new Point(163,334),new Point(244,334),new Point(320,334),new Point(400,334),new Point(480,334),new Point(560,334),new Point(548,285),new Point(539,243),new Point(530,203),new Point(522,164),new Point(451,164),new Point(379,164),new Point(309,164),new Point(236,164),new Point(238,202),new Point(240,244),new Point(312,244)],[new Point(805,122),new Point(725,122),new Point(653,122),new Point(664,157),new Point(675,195),new Point(754,195),new Point(768,239),new Point(783,282),new Point(800,328),new Point(720,328),new Point(638,328),new Point(558,328),new Point(546,282),new Point(538,237),new Point(529,195),new Point(521,158),new Point(446,158),new Point(371,158),new Point(298,158),new Point(296,120),new Point(295,84),new Point(225,84),new Point(152,84),new Point(84,84),new Point(81,121),new Point(78,159),new Point(76,195),new Point(71,238),new Point(71,282),new Point(66,331),new Point(147,331),new Point(230,331),new Point(310,331),new Point(393,331)
      ,new Point(389,284),new Point(380,236)]];
      
      private var _diceArray:Array = ["one","two","three","four","five","six"];
      
      private var _bg:Bitmap;
      
      private var _returnBtn:BuriedReturnBtn;
      
      private var _magpieView:MagpieView;
      
      private var _helpBtn:BaseButton;
      
      private var _controlBg:Bitmap;
      
      private var _diceRoll:DiceRoll;
      
      private var _duckBtn:BaseButton;
      
      private var _lastNum:FilterFrameText;
      
      private var _buyCountBtn:SimpleBitmapButton;
      
      private var _magpieMap:MagpieBridgeMap;
      
      private var _selfPlayer:BuriedPlayer;
      
      private var _walkArray:Array;
      
      private var _magpiePos:int;
      
      private var _addMagpie0:MovieClip;
      
      private var _addMagpie1:MovieClip;
      
      private var _awardCell:BagCell;
      
      private var _awardBox:BuriedBox;
      
      private var _desPos:int;
      
      private var _closeIconFlag:Boolean;
      
      private var _getAwardFlag:Boolean;
      
      private var _addMagpieFlag:Boolean;
      
      private var _stepFlag:Boolean;
      
      private var _addCountFlag:Boolean;
      
      private var _magpieEndNum:int;
      
      private var _endFlag:Boolean;
      
      public function MagPieBridgeView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.magpieBridge.bg");
         addChild(this._bg);
         this._returnBtn = new BuriedReturnBtn();
         addChild(this._returnBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("magpieBridgeView.helpBtn");
         addChild(this._helpBtn);
         this._magpieView = new MagpieView();
         PositionUtils.setPos(this._magpieView,"magpieBridgeView.Pos");
         addChild(this._magpieView);
         this._controlBg = ComponentFactory.Instance.creat("asset.magpieBridge.controlBg");
         addChild(this._controlBg);
         this._diceRoll = new DiceRoll();
         PositionUtils.setPos(this._diceRoll,"magpieBridgeView.dicePos");
         addChild(this._diceRoll);
         this._duckBtn = ComponentFactory.Instance.creatComponentByStylename("magpieBridgeView.duckBtn");
         addChild(this._duckBtn);
         this._lastNum = ComponentFactory.Instance.creatComponentByStylename("magpieBridgeView.lastNum");
         this._lastNum.text = MagpieBridgeManager.instance.magpieModel.LastNum.toString();
         addChild(this._lastNum);
         this._buyCountBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.energyAddBtn");
         this._buyCountBtn.tipData = LanguageMgr.GetTranslation("magpieBridgeView.buyCountTxt");
         PositionUtils.setPos(this._buyCountBtn,"magpieBridgeView.buyCountsPos");
         addChild(this._buyCountBtn);
         this._magpieMap = new MagpieBridgeMap();
         PositionUtils.setPos(this._magpieMap,"magpieBridgeView.mapPos" + MagpieBridgeManager.instance.magpieModel.MapId.toString());
         addChild(this._magpieMap);
         this._selfPlayer = new BuriedPlayer(PlayerManager.Instance.Self,this.roleCallback);
      }
      
      private function initEvent() : void
      {
         this._duckBtn.addEventListener(MouseEvent.CLICK,this.__onDuckClick);
         this._buyCountBtn.addEventListener(MouseEvent.CLICK,this.__onBuyCountClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._magpieView.addEventListener(MagpieBridgeEvent.SETBTNENABLE,this.__onSetBtnEnable);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.DICEOVER,this.__onDiceOver);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.BOXMOVIE_OVER,this.__onBoxMovieOver);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.ROLL_DICE,this.__onRollDice);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.BUY_COUNT,this.__onBuyCount);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.CLOSE_ICON,this.__onCloseIcon);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.UPDATE_PLAYERPOS,this.__onUpdatePlayerPos);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.GET_AWARD,this.__onGetAward);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.MAGPIE_NUM,this.__onMagpieNum);
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.SET_COUNT,this.__onSetCount);
      }
      
      protected function __onHelpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var helpframe:MagpieHelpView = ComponentFactory.Instance.creatComponentByStylename("magpie.view.helpView");
         helpframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(helpframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         event.currentTarget.dispose();
      }
      
      override public function refresh() : void
      {
         if(Boolean(this._magpieMap))
         {
            this._magpieMap.dispose();
            this._magpieMap = null;
         }
         this._magpieMap = new MagpieBridgeMap();
         PositionUtils.setPos(this._magpieMap,"magpieBridgeView.mapPos" + MagpieBridgeManager.instance.magpieModel.MapId.toString());
         addChildAt(this._magpieMap,numChildren - 2);
         this._selfPlayer.sceneCharacterDirection = SceneCharacterDirection.LB;
         PositionUtils.setPos(this._selfPlayer,this._playerPosArray[MagpieBridgeManager.instance.magpieModel.MapId][MagpieBridgeManager.instance.magpieModel.NowPosition]);
         super.refresh();
      }
      
      protected function __onMagpieNum(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var num:int = pkg.readInt();
         MagpieBridgeManager.instance.magpieModel.MagpieNum = num;
         this._addMagpieFlag = true;
      }
      
      private function addMagpie() : void
      {
         this._magpiePos = MagpieBridgeManager.instance.magpieModel.NowPosition;
         if(!this._addMagpie0)
         {
            this._addMagpie0 = ComponentFactory.Instance.creat("asset.magpieBridge.magpie0");
            this._addMagpie0.addFrameScript(this._addMagpie0.totalFrames - 1,this.playMagpieAnimation);
         }
         var point:Point = new Point(this._magpieMap.mapVec[this._magpiePos].x - 5,this._magpieMap.mapVec[this._magpiePos].y - 10);
         PositionUtils.setPos(this._addMagpie0,point);
         this._addMagpie0.gotoAndPlay(1);
         this._magpieMap.addChild(this._addMagpie0);
      }
      
      private function playMagpieAnimation() : void
      {
         this._addMagpie0.stop();
         this._addMagpie1 = ComponentFactory.Instance.creat("asset.magpieBridge.magpie1");
         PositionUtils.setPos(this._addMagpie1,this._magpieMap.localToGlobal(new Point(this._magpieMap.mapVec[this._magpiePos].x,this._magpieMap.mapVec[this._magpiePos].y)));
         var point:Point = this._magpieView.localToGlobal(this._magpieView.getCurrentMagpiePos(true));
         addChild(this._addMagpie1);
         TweenLite.to(this._addMagpie1,0.5,{
            "x":point.x,
            "y":point.y,
            "onComplete":this.setMagpieNum
         });
      }
      
      private function setMagpieNum() : void
      {
         ObjectUtils.disposeObject(this._addMagpie1);
         this._addMagpie1 = null;
         this._magpieView.showMagpie();
      }
      
      protected function __onGetAward(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         MagpieBridgeManager.instance.magpieModel.CurrentTempId = pkg.readInt();
         this._getAwardFlag = true;
      }
      
      private function flyGoods() : void
      {
         var id:int = MagpieBridgeManager.instance.magpieModel.CurrentTempId;
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(id);
         this._awardCell = new BagCell(0,info);
         PositionUtils.setPos(this._awardCell,this._selfPlayer);
         addChild(this._awardCell);
         TweenMax.to(this._awardCell,1,{
            "x":461,
            "y":518,
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":this.complete,
            "bezier":[{
               "x":this._selfPlayer.x,
               "y":this._selfPlayer.y - 80
            }]
         });
      }
      
      private function complete() : void
      {
         ObjectUtils.disposeObject(this._awardCell);
         this._awardCell = null;
         this._magpieMap.closeIcon();
         this.setBtnEnable(true);
      }
      
      protected function __onUpdatePlayerPos(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._desPos = pkg.readInt();
         this._stepFlag = true;
      }
      
      protected function __onWalkOver(event:MagpieBridgeEvent) : void
      {
         this.setBtnEnable(true);
         if(this._stepFlag)
         {
            this.setBtnEnable(false);
            this._stepFlag = false;
            this._magpieMap.closeIcon();
            this.showPromptInfo();
            this.setPlayerWalk(this._desPos);
            if(this._walkArray.length > 0)
            {
               this._selfPlayer.roleWalk(this._walkArray);
               return;
            }
         }
         if(MagpieBridgeManager.instance.magpieModel.NowPosition == this._magpieMap.mapVec.length - 1)
         {
            this._endFlag = true;
            this.setBtnEnable(false);
            ++MagpieBridgeManager.instance.magpieModel.MagpieNum;
            this.addMagpie();
         }
         if(this._getAwardFlag)
         {
            this.setBtnEnable(false);
            this._getAwardFlag = false;
            this.flyGoods();
         }
         if(this._addMagpieFlag)
         {
            this.setBtnEnable(false);
            this._addMagpieFlag = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magpieBridgeView.addMagpieTxt"));
            this.addMagpie();
         }
         if(this._addCountFlag)
         {
            this._addCountFlag = false;
            this._lastNum.text = MagpieBridgeManager.instance.magpieModel.LastNum.toString();
            this._magpieMap.closeIcon();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magpieBridgeView.addCountTxt"));
         }
      }
      
      private function showPromptInfo() : void
      {
         var nowPos:int = MagpieBridgeManager.instance.magpieModel.NowPosition;
         var offPos:int = this._desPos - nowPos;
         if(offPos == 1)
         {
            MessageTipManager.getInstance().show("ileri Adım!");
         }
         else if(offPos == -1)
         {
            MessageTipManager.getInstance().show("geri çekil!");
         }
         else if(offPos > 1)
         {
            MessageTipManager.getInstance().show("sonuna kadar!");
         }
         else if(offPos < -1)
         {
            MessageTipManager.getInstance().show("başlatmak dön!");
         }
      }
      
      private function __onBoxMovieOver(event:BuriedEvent) : void
      {
         this.setBtnEnable(true);
         ObjectUtils.disposeObject(this._awardBox);
         this._awardBox = null;
         var frame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("buried.alertInfo.mapover"),LanguageMgr.GetTranslation("ok"),"",true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         frame.addEventListener(FrameEvent.RESPONSE,this.onMapOverResponse);
      }
      
      private function onMapOverResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.onMapOverResponse);
         if(e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SocketManager.Instance.out.refreshMagpieView();
         }
         frame.dispose();
      }
      
      protected function __onCloseIcon(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readInt();
         var value:int = pkg.readInt();
         if(value == 0)
         {
            this._closeIconFlag = true;
         }
      }
      
      protected function __onBuyCountClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var buyView:MagpieBuyCountsView = ComponentFactory.Instance.creat("magpieBridge.buyCountsView");
         buyView.price = ServerConfigManager.instance.magpieBridgeCountPrice;
         buyView.show();
      }
      
      protected function __onBuyCount(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var lastNum:int = pkg.readInt();
         this._lastNum.text = lastNum.toString();
         MagpieBridgeManager.instance.magpieModel.LastNum = lastNum;
      }
      
      protected function __onSetCount(event:Event) : void
      {
         ++MagpieBridgeManager.instance.magpieModel.LastNum;
         this._addCountFlag = true;
      }
      
      protected function __onSetBtnEnable(event:MagpieBridgeEvent) : void
      {
         if(this._endFlag)
         {
            ++this._magpieEndNum;
            if(this._magpieEndNum < 2)
            {
               ++MagpieBridgeManager.instance.magpieModel.MagpieNum;
               this.addMagpie();
            }
            else
            {
               this._endFlag = false;
               this._magpieEndNum = 0;
               this._awardBox = new BuriedBox();
               this._awardBox.initView(MagpieBridgeManager.instance.magpieModel.MapId,"asset.magpieBridge.awardBox");
               addChild(this._awardBox);
               this._awardBox.play();
            }
         }
         else
         {
            this._magpieMap.closeIcon();
            this.setBtnEnable(true);
         }
      }
      
      private function setBtnEnable(flag:Boolean) : void
      {
         this._duckBtn.enable = flag;
         this._returnBtn.setBtnEnable(flag);
      }
      
      protected function __onDuckClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SocketManager.Instance.out.magpieRollDice();
         if(MagpieBridgeManager.instance.magpieModel.LastNum > 0)
         {
            this.setBtnEnable(false);
         }
      }
      
      protected function __onRollDice(event:MagpieBridgeEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var lastNum:int = pkg.readInt();
         var diceNum:int = pkg.readInt();
         var desPos:int = pkg.readInt();
         this._lastNum.text = lastNum.toString();
         MagpieBridgeManager.instance.magpieModel.LastNum = lastNum;
         this.setPlayerWalk(desPos);
         this._diceRoll.setCrFrame(this._diceArray[diceNum - 1]);
         this._diceRoll.resetFrame();
         this._diceRoll.play();
      }
      
      protected function __onDiceOver(event:BuriedEvent) : void
      {
         if(this._walkArray.length > 0)
         {
            this._selfPlayer.roleWalk(this._walkArray);
         }
      }
      
      private function setPlayerWalk(desNum:int) : void
      {
         var posArray:Array = this._playerPosArray[MagpieBridgeManager.instance.magpieModel.MapId];
         this._walkArray = new Array();
         var nowPos:int = MagpieBridgeManager.instance.magpieModel.NowPosition;
         var flag:int = desNum < nowPos ? -1 : 1;
         while(nowPos != desNum)
         {
            nowPos += flag;
            this._walkArray.push(posArray[nowPos]);
         }
         MagpieBridgeManager.instance.magpieModel.NowPosition = nowPos;
      }
      
      private function roleCallback(role:BuriedPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!role)
            {
               return;
            }
            this._selfPlayer = role;
            this._selfPlayer.sceneCharacterStateType = "natural";
            this._selfPlayer.update();
            PositionUtils.setPos(this._selfPlayer,this._playerPosArray[MagpieBridgeManager.instance.magpieModel.MapId][MagpieBridgeManager.instance.magpieModel.NowPosition]);
            addChild(this._selfPlayer);
            this._selfPlayer.addEventListener(MagpieBridgeEvent.WALK_OVER,this.__onWalkOver);
         }
      }
      
      override public function getType() : String
      {
         return StateType.MAGPIEBRIDGE;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      private function removeEvent() : void
      {
         this._duckBtn.removeEventListener(MouseEvent.CLICK,this.__onDuckClick);
         this._buyCountBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyCountClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._selfPlayer.removeEventListener(MagpieBridgeEvent.WALK_OVER,this.__onWalkOver);
         this._magpieView.removeEventListener(MagpieBridgeEvent.SETBTNENABLE,this.__onSetBtnEnable);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.DICEOVER,this.__onDiceOver);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.BOXMOVIE_OVER,this.__onBoxMovieOver);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.ROLL_DICE,this.__onRollDice);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.BUY_COUNT,this.__onBuyCount);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.CLOSE_ICON,this.__onCloseIcon);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.UPDATE_PLAYERPOS,this.__onUpdatePlayerPos);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.GET_AWARD,this.__onGetAward);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.MAGPIE_NUM,this.__onMagpieNum);
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.SET_COUNT,this.__onSetCount);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._controlBg);
         this._controlBg = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         ObjectUtils.disposeObject(this._magpieView);
         this._magpieView = null;
         ObjectUtils.disposeObject(this._diceRoll);
         this._diceRoll = null;
         ObjectUtils.disposeObject(this._duckBtn);
         this._duckBtn = null;
         ObjectUtils.disposeObject(this._lastNum);
         this._lastNum = null;
         ObjectUtils.disposeObject(this._buyCountBtn);
         this._buyCountBtn = null;
         ObjectUtils.disposeObject(this._magpieMap);
         this._magpieMap = null;
         ObjectUtils.disposeObject(this._selfPlayer);
         this._selfPlayer = null;
         super.dispose();
      }
   }
}

