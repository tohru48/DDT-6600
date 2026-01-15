package ddtBuried.views
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
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
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import ddtBuried.items.BuriedBox;
   import ddtBuried.items.BuriedReturnBtn;
   import ddtBuried.items.DiceRoll;
   import ddtBuried.items.StarItem;
   import ddtBuried.map.Scence1;
   import ddtBuried.role.BuriedPlayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DiceView extends Sprite implements Disposeable
   {
      
      private var _back:Bitmap;
      
      private var _mapContent:Sprite;
      
      private var _downBack:Bitmap;
      
      private var _starBtn:SimpleBitmapButton;
      
      private var _starBtnTip:SimpleBitmapButton;
      
      private var _freeBtn:SimpleBitmapButton;
      
      private var _shopBtn:SimpleBitmapButton;
      
      private var _scence:Scence1;
      
      private var _diceRoll:DiceRoll;
      
      private var _txtNum:FilterFrameText;
      
      private var _starItem:StarItem;
      
      private var _isWalkOver:Boolean = false;
      
      private var _buriedBox:BuriedBox;
      
      private var _returnBtn:BuriedReturnBtn;
      
      private var role:BuriedPlayer;
      
      private var rolePosition:int;
      
      private var rolePoint:Point;
      
      private var roleNowPosition:int;
      
      private var index:uint;
      
      private var _walkArray:Array;
      
      private var _fountain1:MovieClip;
      
      private var _fountain2:MovieClip;
      
      private var cell:BagCell;
      
      private var _fileTxt:FilterFrameText;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _isRemoeEvent:Boolean;
      
      private var _isOneStep:Boolean;
      
      private var currPos:int;
      
      private var onstep:int;
      
      private var _isCount:Boolean = false;
      
      private var _taskTrackView:TaskTrackView;
      
      private var _boxMoiveFrame:BaseAlerFrame;
      
      private var _levelFrame:BaseAlerFrame;
      
      public function DiceView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         if(BuriedManager.Instance.mapID == BuriedManager.MAP1)
         {
            this._walkArray = BuriedManager.Instance.mapArrays.roadMapsList1;
         }
         else if(BuriedManager.Instance.mapID == BuriedManager.MAP2)
         {
            this._walkArray = BuriedManager.Instance.mapArrays.roadMapsList2;
         }
         else if(BuriedManager.Instance.mapID == BuriedManager.MAP3)
         {
            this._walkArray = BuriedManager.Instance.mapArrays.roadMapsList3;
         }
         this.rolePosition = BuriedManager.Instance.nowPosition;
         this.rolePoint = new Point(this._walkArray[this.rolePosition].x,this._walkArray[this.rolePosition].y);
         this._back = ComponentFactory.Instance.creat("buried.shaizi.back");
         addChild(this._back);
         this._fountain1 = ComponentFactory.Instance.creat("buried.dice.fountain");
         this._fountain1.scaleX = this._fountain1.scaleY = 2.5;
         this._fountain1.x = 64;
         this._fountain1.y = 460;
         addChild(this._fountain1);
         this._fountain2 = ComponentFactory.Instance.creat("buried.dice.fountain");
         this._fountain2.scaleX = this._fountain2.scaleY = 2.5;
         this._fountain2.x = 955;
         this._fountain2.y = 460;
         addChild(this._fountain2);
         this._fileTxt = ComponentFactory.Instance.creatComponentByStylename("ddtburied.right.aTtionTxt");
         this._fileTxt.text = LanguageMgr.GetTranslation("buried.alertInfo.diceAtion");
         addChild(this._fileTxt);
         this._mapContent = new Sprite();
         addChild(this._mapContent);
         this._downBack = ComponentFactory.Instance.creat("buried.shaizi.downBack");
         addChild(this._downBack);
         this._starBtnTip = ComponentFactory.Instance.creatComponentByStylename("ddtburied.updateStar");
         this._starBtnTip.tipData = LanguageMgr.GetTranslation("buried.alertInfo.starBtnTipfree");
         addChild(this._starBtnTip);
         this._starBtnTip.alpha = 0;
         this._starBtnTip.visible = false;
         this._starBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.updateStar");
         this._starBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.starBtnTipfree");
         if(BuriedManager.Instance.nowPosition > 0)
         {
            this._starBtn.enable = false;
            this._starBtnTip.visible = true;
         }
         addChild(this._starBtn);
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.freeBtn");
         this._freeBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.btnTipfree");
         addChild(this._freeBtn);
         this._txtNum = ComponentFactory.Instance.creatComponentByStylename("ddtburied.right.btnTxt");
         this._freeBtn.addChild(this._txtNum);
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.shopBtn");
         addChild(this._shopBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.helpBtn");
         addChild(this._helpBtn);
         this._starItem = new StarItem();
         this._starItem.x = 374;
         this._starItem.y = 547;
         addChild(this._starItem);
         this._diceRoll = new DiceRoll();
         this._diceRoll.x = 151;
         this._diceRoll.y = 238;
         addChild(this._diceRoll);
         this._taskTrackView = new TaskTrackView();
         PositionUtils.setPos(this._taskTrackView,"ddtburied.taskTrack.pos");
         this.role = new BuriedPlayer(PlayerManager.Instance.Self,this.roleCallback);
         this._returnBtn = new BuriedReturnBtn();
         addChild(this._returnBtn);
         this._buriedBox = new BuriedBox();
         this._buriedBox.visible = false;
         addChild(this._buriedBox);
      }
      
      private function roleCallback(role:BuriedPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!role)
            {
               return;
            }
            role.sceneCharacterStateType = "natural";
            role.update();
            role.x = this.rolePoint.x;
            role.y = this.rolePoint.y;
            addChild(role);
            addChild(this._taskTrackView);
         }
      }
      
      public function upDataBtn() : void
      {
         if(this._isCount)
         {
            if(Boolean(BuriedManager.Instance.getPayData()))
            {
               this._freeBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.btnTip",BuriedManager.Instance.getPayData().NeedMoney);
            }
            else
            {
               this._freeBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.DiceOver");
            }
            this._freeBtn.addChild(this._txtNum);
            return;
         }
         var tmpMouseEnable:Boolean = true;
         if(Boolean(this._freeBtn))
         {
            tmpMouseEnable = this._freeBtn.mouseEnabled;
            this._freeBtn.removeEventListener(MouseEvent.CLICK,this.rollClickHander);
            ObjectUtils.disposeObject(this._freeBtn);
            this._freeBtn = null;
         }
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.payBtn");
         this._freeBtn.mouseEnabled = tmpMouseEnable;
         this._isCount = true;
         if(Boolean(BuriedManager.Instance.getPayData()))
         {
            this._freeBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.btnTip",BuriedManager.Instance.getPayData().NeedMoney);
         }
         else
         {
            this._freeBtn.tipData = LanguageMgr.GetTranslation("buried.alertInfo.DiceOver");
         }
         addChild(this._freeBtn);
         this._freeBtn.addChild(this._txtNum);
         this._txtNum.y = 22;
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.rollClickHander);
      }
      
      public function setTxt(str:String) : void
      {
         if(str == "0")
         {
            this._txtNum.text = "";
         }
         else
         {
            this._txtNum.text = "(" + str + ")";
         }
      }
      
      public function setCrFrame(str:String) : void
      {
         this._diceRoll.setCrFrame(str);
      }
      
      public function play() : void
      {
         this._diceRoll.play();
      }
      
      private function initEvents() : void
      {
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.rollClickHander);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this.openshopHander);
         this._starBtn.addEventListener(MouseEvent.CLICK,this.uplevelClickHander);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.RemoveEvent,this.removeEventHandler);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.DICEOVER,this.diceOverHandler);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.MAPOVER,this.mapOverHandler);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.WALKOVER,this.roleWalkOverHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.UPDATABTNSTATS,this.starBtnstatsHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.BOXMOVIE_OVER,this.boxMoiveOverHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.OneStep,this.oneStepHander);
      }
      
      private function removeEvents() : void
      {
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.rollClickHander);
         this._shopBtn.removeEventListener(MouseEvent.CLICK,this.openshopHander);
         this._starBtn.removeEventListener(MouseEvent.CLICK,this.uplevelClickHander);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.OneStep,this.oneStepHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.RemoveEvent,this.removeEventHandler);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.DICEOVER,this.diceOverHandler);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.MAPOVER,this.mapOverHandler);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.UPDATABTNSTATS,this.starBtnstatsHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.WALKOVER,this.roleWalkOverHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.BOXMOVIE_OVER,this.boxMoiveOverHander);
      }
      
      private function oneStepHander(e:BuriedEvent) : void
      {
         var obj:Object = e.data;
         this.onstep = obj.key;
         this._isOneStep = true;
      }
      
      private function removeEventHandler(e:BuriedEvent) : void
      {
         var obj:Object = e.data;
         this.currPos = obj.key;
         this._isRemoeEvent = true;
      }
      
      private function openHelpViewHander(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var helpframe:DuriedHelpFrame = ComponentFactory.Instance.creatComponentByStylename("ddtburied.view.helpFrame");
         helpframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(helpframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.currentTarget.dispose();
      }
      
      private function boxMoiveOverHander(e:BuriedEvent) : void
      {
         this._boxMoiveFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("buried.alertInfo.mapover"),LanguageMgr.GetTranslation("ok"),"",true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         this._boxMoiveFrame.addEventListener(FrameEvent.RESPONSE,this.onMapOverResponse);
      }
      
      private function starBtnstatsHander(e:BuriedEvent) : void
      {
         this._starBtn.enable = true;
         this._starBtnTip.visible = false;
      }
      
      private function flyGoods() : void
      {
         var id:int = BuriedManager.Instance.currGoodID;
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(id);
         this.cell = new BagCell(0,info);
         this.cell.x = this.role.x;
         this.cell.y = this.role.y;
         addChild(this.cell);
         TweenMax.to(this.cell,1,{
            "x":461,
            "y":518,
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":this.comp,
            "bezier":[{
               "x":this.role.x,
               "y":this.role.y - 80
            }]
         });
      }
      
      private function comp() : void
      {
         ObjectUtils.disposeObject(this.cell);
      }
      
      private function walkContinueHander(e:BuriedEvent) : void
      {
         var roadArray:Array = null;
         if(BuriedManager.Instance.isGetGoods)
         {
            BuriedManager.Instance.isGetGoods = false;
            this._scence.updateRoadPoint();
            this.flyGoods();
         }
         if(this._isWalkOver)
         {
            this._isWalkOver = false;
            BuriedManager.Instance.isContinue = false;
            BuriedManager.Instance.nowPosition = BuriedManager.Instance.eventPosition;
            roadArray = this.configRoadArray();
            this.role.roleWalk(roadArray);
            this.roleWalkPosition(BuriedManager.Instance.nowPosition);
         }
      }
      
      private function roleWalkOverHander(e:BuriedEvent) : void
      {
         var roadArray:Array = null;
         this._isWalkOver = true;
         if(BuriedManager.Instance.isBackToStart)
         {
            BuriedManager.Instance.isBackToStart = false;
            this._starBtn.enable = true;
            this._starBtnTip.visible = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.toStart"));
         }
         else if(BuriedManager.Instance.isGo)
         {
            BuriedManager.Instance.isGo = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.toGo"));
         }
         else if(BuriedManager.Instance.isGoEnd)
         {
            BuriedManager.Instance.isOver = true;
            BuriedManager.Instance.isGoEnd = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.toEnd"));
         }
         else if(BuriedManager.Instance.isBack)
         {
            BuriedManager.Instance.isBack = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.toBack"));
         }
         if(BuriedManager.Instance.isOpenBuried)
         {
            BuriedManager.Instance.isOpenBuried = false;
            BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.OPEN_BURIEDVIEW));
         }
         this._freeBtn.mouseEnabled = true;
         this._returnBtn.mouseEnabled = true;
         this._returnBtn.mouseChildren = true;
         if(this._isRemoeEvent && this._isWalkOver)
         {
            this._isRemoeEvent = false;
            this._scence.updateRoadPoint(this.currPos);
         }
         if(this._isOneStep && this._isWalkOver)
         {
            this._isOneStep = false;
            this._scence.updateRoadPoint(this.onstep);
         }
         this._taskTrackView.refreshTask();
         if(BuriedManager.Instance.isContinue)
         {
            BuriedManager.Instance.isContinue = false;
            this._freeBtn.mouseEnabled = false;
            this._returnBtn.mouseEnabled = false;
            this._returnBtn.mouseChildren = false;
            this._isWalkOver = false;
            BuriedManager.Instance.nowPosition = BuriedManager.Instance.eventPosition;
            this.roleWalkPosition(BuriedManager.Instance.nowPosition);
            roadArray = this.configRoadArray();
            this.role.roleWalk(roadArray);
         }
         if(BuriedManager.Instance.isGetGoods && this._isWalkOver)
         {
            BuriedManager.Instance.isGetGoods = false;
            this._scence.updateRoadPoint();
            this.flyGoods();
         }
      }
      
      private function mapOverHandler(e:BuriedEvent) : void
      {
         this._buriedBox.visible = true;
         this._buriedBox.initView(BuriedManager.Instance.level);
         this._buriedBox.play();
         this._freeBtn.mouseEnabled = false;
         this._returnBtn.mouseEnabled = false;
         this._returnBtn.mouseChildren = false;
      }
      
      private function onMapOverResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.onMapOverResponse);
         if(e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SocketManager.Instance.out.refreshMap();
         }
         frame.dispose();
      }
      
      private function diceOverHandler(e:BuriedEvent) : void
      {
         var roadArray:Array = this.configRoadArray();
         this._isWalkOver = false;
         this.role.roleWalk(roadArray);
         this.roleWalkPosition(BuriedManager.Instance.nowPosition);
         this.rolePosition = this.roleNowPosition;
         this._starBtn.enable = false;
         this._starBtnTip.visible = true;
         this._freeBtn.mouseEnabled = false;
         this._returnBtn.mouseEnabled = false;
         this._returnBtn.mouseChildren = false;
      }
      
      private function configRoadArray() : Array
      {
         var i:int = 0;
         var j:int = 0;
         this.roleNowPosition = BuriedManager.Instance.nowPosition;
         var roadArray:Array = [];
         if(this.rolePosition < this.roleNowPosition)
         {
            for(i = this.rolePosition; i <= this.roleNowPosition; i++)
            {
               roadArray.push(this._walkArray[i]);
            }
         }
         else
         {
            for(j = this.rolePosition; j >= this.roleNowPosition; j--)
            {
               roadArray.push(this._walkArray[j]);
            }
         }
         this.rolePosition = this.roleNowPosition;
         return roadArray;
      }
      
      private function roleWalkPosition(position:int) : void
      {
         var xpos:int = 0;
         var ypos:int = 0;
         if(BuriedManager.Instance.mapID == BuriedManager.MAP1)
         {
            xpos = int(BuriedManager.Instance.mapArrays.standArray1[position].x);
            ypos = int(BuriedManager.Instance.mapArrays.standArray1[position].y);
         }
         else if(BuriedManager.Instance.mapID == BuriedManager.MAP2)
         {
            xpos = int(BuriedManager.Instance.mapArrays.standArray2[position].x);
            ypos = int(BuriedManager.Instance.mapArrays.standArray2[position].y);
         }
         else
         {
            xpos = int(BuriedManager.Instance.mapArrays.standArray3[position].x);
            ypos = int(BuriedManager.Instance.mapArrays.standArray3[position].y);
         }
         this._scence.selfFindPath(xpos,ypos);
      }
      
      private function rollClickHander(e:MouseEvent) : void
      {
         this._diceRoll.resetFrame();
         SoundManager.instance.playButtonSound();
         if(TaskManager.instance.isHaveBuriedQuest())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.questsContiniue"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(BuriedManager.Instance.currPayLevel >= 0)
         {
            if(!BuriedManager.Instance.getPayData() && BuriedManager.Instance.currPayLevel >= 21)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.DiceOver"));
               return;
            }
            if(BuriedManager.Instance.getRemindRoll())
            {
               if(BuriedManager.Instance.checkMoney(BuriedManager.Instance.getRemindRollBind(),BuriedManager.Instance.getPayData().NeedMoney,SocketManager.Instance.out.rollDice))
               {
                  BuriedManager.Instance.setRemindRoll(false);
                  BuriedManager.Instance.setRemindRollBind(false);
                  BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDiceContiniue",BuriedManager.Instance.getPayData().NeedMoney),this.payRollHander,this.clickCallBack);
                  return;
               }
               SocketManager.Instance.out.rollDice(BuriedManager.Instance.getRemindRollBind());
               if(BuriedManager.Instance.finalNum <= 0)
               {
                  return;
               }
               this._isWalkOver = false;
               this._starBtn.enable = false;
               this._starBtnTip.visible = true;
               this._freeBtn.mouseEnabled = false;
               this._returnBtn.mouseEnabled = false;
               this._returnBtn.mouseChildren = false;
               return;
            }
            BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDiceContiniue",BuriedManager.Instance.getPayData().NeedMoney),this.payRollHander,this.clickCallBack);
            return;
         }
         SocketManager.Instance.out.rollDice();
         this._isWalkOver = false;
         this._starBtn.enable = false;
         this._starBtnTip.visible = true;
         this._freeBtn.mouseEnabled = false;
         this._returnBtn.mouseEnabled = false;
         this._returnBtn.mouseChildren = false;
      }
      
      private function clickCallBack(bool:Boolean) : void
      {
         BuriedManager.Instance.setRemindRoll(bool);
      }
      
      private function payRollHander(bool:Boolean) : void
      {
         if(BuriedManager.Instance.checkMoney(bool,BuriedManager.Instance.getPayData().NeedMoney,SocketManager.Instance.out.rollDice))
         {
            BuriedManager.Instance.setRemindRoll(false);
            BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDiceContiniue",BuriedManager.Instance.getPayData().NeedMoney),this.payRollHander,this.clickCallBack);
            return;
         }
         if(BuriedManager.Instance.getRemindRoll())
         {
            BuriedManager.Instance.setRemindRollBind(bool);
         }
         SocketManager.Instance.out.rollDice(bool);
         this._freeBtn.mouseEnabled = false;
         this._starBtn.enable = false;
         this._returnBtn.mouseEnabled = false;
         this._returnBtn.mouseChildren = false;
         this._diceRoll.resetFrame();
      }
      
      private function openshopHander(e:MouseEvent) : void
      {
         BuriedManager.Instance.openshopHander();
         SoundManager.instance.playButtonSound();
      }
      
      private function uplevelClickHander(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(BuriedManager.Instance.level >= 5)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("buried.alertInfo.starFull"));
            return;
         }
         this._levelFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("buried.alertInfo.uplevel",BuriedManager.Instance.getUpdateData(true).NeedMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         this._levelFrame.addEventListener(FrameEvent.RESPONSE,this.onUpLevelResponse);
      }
      
      private function onUpLevelResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.onUpLevelResponse);
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            frame.dispose();
            return;
         }
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(BuriedManager.Instance.checkMoney(frame.isBand,BuriedManager.Instance.getUpdateData(true).NeedMoney,SocketManager.Instance.out.upgradeStartLevel))
            {
               frame.dispose();
               return;
            }
            SocketManager.Instance.out.upgradeStartLevel(frame.isBand);
         }
         frame.dispose();
      }
      
      public function clearScene() : void
      {
         if(Boolean(this._scence))
         {
            ObjectUtils.disposeObject(this._scence);
            this._scence = null;
         }
      }
      
      public function setStarList(num:int) : void
      {
         this._starItem.setStarList(num);
      }
      
      public function updataStarLevel(num:int) : void
      {
         this._starItem.updataStarLevel(num);
      }
      
      public function addMaps(str:String, row:int, col:int, _x:int, _y:int) : void
      {
         this.clearScene();
         this._scence = new Scence1(str,row,col);
         this._scence.x = _x;
         this._scence.y = _y;
         this._mapContent.addChild(this._scence);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._fountain1))
         {
            this._fountain1.stop();
            while(Boolean(this._fountain1.numChildren))
            {
               ObjectUtils.disposeObject(this._fountain1.getChildAt(0));
            }
         }
         if(Boolean(this._fountain2))
         {
            this._fountain2.stop();
            while(Boolean(this._fountain2.numChildren))
            {
               ObjectUtils.disposeObject(this._fountain2.getChildAt(0));
            }
         }
         if(Boolean(this._levelFrame))
         {
            ObjectUtils.disposeObject(this._levelFrame);
            this._levelFrame = null;
         }
         if(Boolean(this._boxMoiveFrame))
         {
            ObjectUtils.disposeObject(this._boxMoiveFrame);
            this._boxMoiveFrame = null;
         }
         if(Boolean(this._starItem))
         {
            this._starItem.dispose();
         }
         if(Boolean(this._scence))
         {
            this._scence.dispose();
         }
         ObjectUtils.disposeObject(this._scence);
         ObjectUtils.disposeObject(this._txtNum);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._scence = null;
         this._txtNum = null;
         this._fountain1 = null;
         this._fountain2 = null;
      }
   }
}

