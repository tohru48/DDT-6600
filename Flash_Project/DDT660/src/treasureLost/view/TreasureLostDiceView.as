package treasureLost.view
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
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import treasureLost.controller.TreasureLostManager;
   import treasureLost.events.TreasureLostEvents;
   import treasurePuzzle.model.TreasureLostStaticValue;
   
   public class TreasureLostDiceView extends Sprite implements Disposeable
   {
      
      private var _back:Bitmap;
      
      private var _returnBtn:TreasureLostRetrunBtn;
      
      private var _lifeBlood:int;
      
      private var _floors:int;
      
      private var _rollPoint:int;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _powerProgress:TreasureLostPowerProgress;
      
      private var _energyAddBtn:SimpleBitmapButton;
      
      private var role:TreasureLostPlayer;
      
      private var diceRoll:TreasureLostDiceRoll;
      
      private var goldDiceRoll:TreasureLostDiceRoll;
      
      private var goldDiceRollBuyCountbg:Bitmap;
      
      private var goldDiceRollBuyCountTxt:FilterFrameText;
      
      private var goldSelectView:TreasureLostDiceSelectView;
      
      private var mapView:TreasureLostMapView;
      
      private var layerName:MovieClip;
      
      public var unWalkPoint:Array;
      
      public var selecDirectionType:int = 0;
      
      public var directionSelected:Boolean = false;
      
      private var isHideView:Boolean = false;
      
      private var buyBattalOne:TreasureLostButtonItemCell;
      
      private var buyBattalAll:TreasureLostButtonItemCell;
      
      private var itemExchange:SimpleBitmapButton;
      
      private var _rewardTipText:FilterFrameText;
      
      private var _fiveItemArr:Array;
      
      private var treasureMC:MovieClip;
      
      private var cell:BagCell;
      
      private var alertAsk2:BaseAlerFrame;
      
      private var buyGoldDicePrice:int;
      
      private var alertAsk:BaseAlerFrame;
      
      private var buyPowerPrice:int;
      
      private var _shopframe:TreasureLostShopFrame;
      
      public var unWalkNum:int;
      
      public function TreasureLostDiceView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var now:int = 0;
         this._back = ComponentFactory.Instance.creat("treasureLost.treasureLostBack");
         addChild(this._back);
         this.layerName = ComponentFactory.Instance.creat("treasureLost.treasureLostLayer");
         PositionUtils.setPos(this.layerName,"treasureLost.treasureLostLayerPos");
         addChild(this.layerName);
         this.layerName.gotoAndStop(TreasureLostManager.Instance.currentMap + "");
         this._powerProgress = ComponentFactory.Instance.creatComponentByStylename("treasureLost.powerProgress");
         addChild(this._powerProgress);
         this._powerProgress.showProgressBar(TreasureLostManager.Instance.power,TreasureLostStaticValue.FULLPOWER);
         this._energyAddBtn = ComponentFactory.Instance.creatComponentByStylename("treasureLost.energyAddBtn");
         addChild(this._energyAddBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("treasureLost.helpBtn");
         addChild(this._helpBtn);
         this._returnBtn = new TreasureLostRetrunBtn();
         addChild(this._returnBtn);
         this.addMapView();
         this.role = new TreasureLostPlayer(PlayerManager.Instance.Self);
         this.role.setSceneCharacterDirectionDefault();
         now = TreasureLostManager.Instance.playerCurrentPath;
         this.role.setPos(TreasureLostManager.Instance.playerCurrentPath);
         addChild(this.role);
         this.diceRoll = new TreasureLostDiceRoll("normal");
         PositionUtils.setPos(this.diceRoll,"treasureLost.diceRollPos");
         addChild(this.diceRoll);
         this.goldDiceRoll = new TreasureLostDiceRoll("gold");
         PositionUtils.setPos(this.goldDiceRoll,"treasureLost.goldDiceRollPos");
         addChild(this.goldDiceRoll);
         this.goldDiceRollBuyCountbg = ComponentFactory.Instance.creat("treasureLost.goldDiceBuyNumBg");
         addChild(this.goldDiceRollBuyCountbg);
         this.goldDiceRollBuyCountTxt = ComponentFactory.Instance.creatComponentByStylename("treasureLost.goldDiceBuyNumText");
         this.goldDiceRollBuyCountTxt.text = TreasureLostManager.Instance.goldDiceRollBuyCount + "";
         addChild(this.goldDiceRollBuyCountTxt);
         this.goldSelectView = new TreasureLostDiceSelectView();
         PositionUtils.setPos(this.goldSelectView,"treasureLost.goldSelectViewPos");
         addChild(this.goldSelectView);
         this.goldSelectView.visible = false;
         this.goldSelectView.reset();
         this.buyBattalOne = new TreasureLostButtonItemCell("treasureLost.treasureLostBattleOne");
         this.buyBattalAll = new TreasureLostButtonItemCell("treasureLost.treasureLostBattleAll");
         PositionUtils.setPos(this.buyBattalOne,"treasureLost.buyBattalOnePos");
         PositionUtils.setPos(this.buyBattalAll,"treasureLost.buyBattalAllPos");
         addChild(this.buyBattalOne);
         addChild(this.buyBattalAll);
         this.itemExchange = ComponentFactory.Instance.creatComponentByStylename("treasureLost.itemExchangeBnt");
         addChild(this.itemExchange);
         this._rewardTipText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.view.rewardTipText");
         this._rewardTipText.text = LanguageMgr.GetTranslation("treasureLost.rewardTipText");
         addChild(this._rewardTipText);
         this.initFiveItem();
         if(now == TreasureLostManager.Instance.specialMapNum)
         {
            this.mapView.selectDirecionMcVisible(true);
            this.rollUnClick(false);
         }
      }
      
      private function initFiveItem() : void
      {
         var item:TreasureLostFiveItemCell = null;
         var itemCell:TreasureLostFiveItemCell = null;
         var isHave:Boolean = false;
         var id:int = 0;
         this._fiveItemArr = [];
         this.treasureMC = ComponentFactory.Instance.creat("treasureLost.treasureLostMc");
         PositionUtils.setPos(this.treasureMC,"treasureLost.treasureLostMcPos");
         addChild(this.treasureMC);
         for(var i:int = 0; i < 5; i++)
         {
            isHave = Boolean(TreasureLostManager.Instance.isHaveItemRewardArr[i]);
            id = int(TreasureLostManager.Instance.isHaveItemIdArr[i]);
            itemCell = new TreasureLostFiveItemCell(id,isHave);
            addChild(itemCell);
            PositionUtils.setPos(itemCell,"treasureLost.isHaveItemPos" + i);
            if(isHave)
            {
               itemCell.cell.lightPic();
            }
            else
            {
               itemCell.cell.grayPic();
            }
            this._fiveItemArr.push(itemCell);
         }
         this.treasureMC.visible = false;
         var arr:Array = TreasureLostManager.Instance.isHaveItemRewardArr;
         if(Boolean(arr[0]) && Boolean(arr[1]) && Boolean(arr[2]) && Boolean(arr[3]) && arr[4] == false)
         {
            item = this._fiveItemArr[4] as TreasureLostFiveItemCell;
            item.setEnable(true,true);
            this.treasureMC.visible = true;
            item.buttonMode = true;
         }
         else if(Boolean(arr[0]) && Boolean(arr[1]) && Boolean(arr[2]) && Boolean(arr[3]) && Boolean(arr[4]))
         {
            item = this._fiveItemArr[4] as TreasureLostFiveItemCell;
            item.setEnable(true,false);
            this.treasureMC.visible = false;
         }
      }
      
      private function __updateFiveItem(e:TreasureLostEvents) : void
      {
         var isHave:Boolean = false;
         var itemCell:TreasureLostFiveItemCell = null;
         var arr:Array = null;
         var item:TreasureLostFiveItemCell = null;
         var pkg:PackageIn = e.data as PackageIn;
         for(var i:int = 0; i < this._fiveItemArr.length; i++)
         {
            TreasureLostManager.Instance.isHaveItemIdArr[i] = pkg.readInt();
            TreasureLostManager.Instance.isHaveItemRewardArr[i] = pkg.readBoolean();
            isHave = Boolean(TreasureLostManager.Instance.isHaveItemRewardArr[i]);
            itemCell = this._fiveItemArr[i] as TreasureLostFiveItemCell;
            if(isHave)
            {
               itemCell.cell.lightPic();
            }
            else
            {
               itemCell.cell.grayPic();
            }
            arr = TreasureLostManager.Instance.isHaveItemRewardArr;
            if(Boolean(arr[0]) && Boolean(arr[1]) && Boolean(arr[2]) && Boolean(arr[3]) && arr[4] == false)
            {
               item = this._fiveItemArr[4] as TreasureLostFiveItemCell;
               item.setEnable(true,true);
               this.treasureMC.visible = true;
            }
            else if(Boolean(arr[0]) && Boolean(arr[1]) && Boolean(arr[2]) && Boolean(arr[3]) && Boolean(arr[4]))
            {
               item = this._fiveItemArr[4] as TreasureLostFiveItemCell;
               item.setEnable(true,false);
               this.treasureMC.visible = false;
            }
         }
      }
      
      public function getPathArr(path:Array) : Array
      {
         var id:int = 0;
         var pathStr:String = null;
         var pathArr:Array = null;
         var x:int = 0;
         var y:int = 0;
         var pathPosArr:Array = [];
         var allPathStr:String = TreasureLostManager.Instance.mapPlayerPath;
         var allPathArr:Array = allPathStr.split("|");
         for(var i:int = 0; i < path.length; i++)
         {
            id = int(path[i]);
            pathStr = allPathArr[id];
            pathArr = pathStr.split(",");
            x = int(pathArr[0]);
            y = int(pathArr[1]);
            pathPosArr.push({
               "x":x,
               "y":y
            });
         }
         return pathPosArr;
      }
      
      public function rollUnClick(value:Boolean) : void
      {
         if(value)
         {
            this.diceRoll.mouseEnabled = true;
            this.diceRoll.mouseChildren = true;
            this.goldDiceRoll.mouseEnabled = true;
            this.goldDiceRoll.mouseChildren = true;
         }
         else
         {
            this.diceRoll.mouseEnabled = false;
            this.diceRoll.mouseChildren = false;
            this.goldDiceRoll.mouseEnabled = false;
            this.goldDiceRoll.mouseChildren = false;
         }
      }
      
      private function __walkEnd(e:TreasureLostEvents) : void
      {
         var max:int = TreasureLostManager.Instance.maxMapItemNum;
         var current:int = TreasureLostManager.Instance.playerCurrentPath;
         var special:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         var type:int = this.mapView.getTypeById(current);
         if(current < max)
         {
            if(current != 0)
            {
               if(current != special && type != 0)
               {
                  this.mapView.changeMapItemState(current,-10);
               }
            }
            this.rollUnClick(true);
            if(current == special + specialLength || current == special)
            {
               this.rollUnClick(false);
            }
            else if(type == -1 || type == -2)
            {
               this.rollUnClick(false);
            }
         }
         else
         {
            this.rollUnClick(false);
         }
         this.roleWalkEnd(type);
      }
      
      public function roleWalkEnd($type:int) : void
      {
         var current:int = TreasureLostManager.Instance.playerCurrentPath;
         var special:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         if($type > 0)
         {
            this.flyGoods($type);
            SocketManager.Instance.out.treasureLostEventDispatch($type);
         }
         else
         {
            if($type == 0)
            {
               TreasureLostManager.Instance.isMove = false;
               return;
            }
            if($type == -1)
            {
               SocketManager.Instance.out.treasureLostEventDispatch(-1);
            }
            else if($type == -2)
            {
               SocketManager.Instance.out.treasureLostEventDispatch(-2);
            }
            else if($type == -3)
            {
               SocketManager.Instance.out.treasureLostEventDispatch(-3);
            }
            else if($type == -4)
            {
               SocketManager.Instance.out.treasureLostEventDispatch(-4);
            }
            else
            {
               if($type == -5)
               {
                  SocketManager.Instance.out.treasureLostMissBoss();
                  return;
               }
               if($type == -10)
               {
                  if(current == special + specialLength)
                  {
                     SocketManager.Instance.out.treasureLostEventDispatch(-10);
                     TreasureLostManager.Instance.playerCurrentPath = special;
                     this.role.setPos(TreasureLostManager.Instance.playerCurrentPath);
                     this.unWalkNum = 0;
                     this.mapView.selectDirecionMcVisible(true);
                  }
                  TreasureLostManager.Instance.isMove = false;
                  return;
               }
               if($type == -11)
               {
                  this.mapView.selectDirecionMcVisible(true);
               }
               else if($type != -13)
               {
                  if($type == -6)
                  {
                     SocketManager.Instance.out.treasureLostEventDispatch(-6);
                     this.rollUnClick(false);
                  }
               }
            }
         }
         TreasureLostManager.Instance.isMove = false;
      }
      
      private function __playerEventDispatch(e:TreasureLostEvents) : void
      {
         var count:int = 0;
         var pkg:PackageIn = e.data as PackageIn;
         var type:int = pkg.readInt();
         var old:int = pkg.readInt();
         var now:int = pkg.readInt();
         if(type == 2)
         {
            this.rollUnClick(false);
            this.goBackToZero(TreasureLostManager.Instance.playerCurrentPath);
         }
         else if(type == 3)
         {
            this.rollUnClick(false);
            this.goToEnd(TreasureLostManager.Instance.playerCurrentPath);
         }
         else if(type == 0)
         {
            this.rollUnClick(true);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.getDoubleBUFFText"));
         }
         else if(type == 1)
         {
            this.rollUnClick(true);
            count = TreasureLostManager.Instance.goldDiceRollBuyCount;
            TreasureLostManager.Instance.goldDiceRollBuyCount = now;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.getGoldRollAdd"));
            this.goldDiceRollBuyCountTxt.text = now + "";
         }
         else if(type == 4)
         {
            TreasureLostManager.Instance.treasureLostStoneNum = now;
            TreasureLostManager.Instance.dispatchEvent(new TreasureLostEvents(TreasureLostEvents.TreasureLostUpdata_Stone_Count,now));
         }
         else if(type == 5)
         {
            this.rollUnClick(true);
         }
      }
      
      private function goBackToZero(nowPosition:int) : void
      {
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         var pathArr:Array = [];
         for(var i:int = 0; i < nowPosition; i++)
         {
            pathArr.push(i);
         }
         if(!(nowPosition > specialNum && nowPosition < specialNum + specialLength))
         {
            pathArr = this.getPathWithNoSpecial(pathArr);
         }
         pathArr = pathArr.reverse();
         var rollPath:Array = this.getPathArr(pathArr);
         TreasureLostManager.Instance.playerCurrentPath = 0;
         this.role.roleWalk(rollPath);
      }
      
      private function goToEnd(nowPosition:int) : void
      {
         var j:int = 0;
         var num:int = 0;
         var max:int = TreasureLostManager.Instance.maxMapItemNum;
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         var pathArr:Array = [];
         var specialArr:Array = [];
         for(var i:int = nowPosition + 1; i < max + 1; i++)
         {
            pathArr.push(i);
         }
         if(nowPosition > specialNum && nowPosition < specialNum + specialLength)
         {
            for(j = 0; j < nowPosition - specialNum; j++)
            {
               num = nowPosition - j - 1;
               specialArr.push(num);
            }
            pathArr = this.getPathWithNoSpecial(pathArr);
            pathArr = specialArr.concat(pathArr);
         }
         else
         {
            pathArr = this.getPathWithNoSpecial(pathArr);
         }
         var rollPath:Array = this.getPathArr(pathArr);
         TreasureLostManager.Instance.playerCurrentPath = max;
         this.role.roleWalk(rollPath);
      }
      
      private function flyGoods($id:int) : void
      {
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById($id);
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
      
      private function _diceRoll(e:MouseEvent) : void
      {
         if(TreasureLostManager.Instance.power <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.noPowerForRoll"));
            return;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.noWeapon"));
            return;
         }
         this.rollUnClick(false);
         this.diceRoll.play();
         var timer:Timer = new Timer(1000,1);
         timer.addEventListener(TimerEvent.TIMER,this._timerOut);
         timer.start();
         TreasureLostManager.Instance.isMove = true;
      }
      
      private function _goldDiceRoll(e:MouseEvent) : void
      {
         var tipText:FilterFrameText = null;
         var buyCount:int = TreasureLostManager.Instance.goldDiceRollBuyCountLimite;
         this.buyGoldDicePrice = TreasureLostManager.Instance.goldDiceBuyPrice[buyCount];
         if(TreasureLostManager.Instance.goldDiceRollBuyCount <= 0)
         {
            if(buyCount >= TreasureLostManager.Instance.maxGoldDiceCount)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.buyPowerEnough"));
               return;
            }
            this.alertAsk2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("treasureLost.buyGoldDiceTxt",this.buyGoldDicePrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertAsk2.height = 180;
            tipText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.buyPowerCountTip");
            tipText.htmlText = LanguageMgr.GetTranslation("treasureLost.buyGoldDiceCountTipText",TreasureLostManager.Instance.maxGoldDiceCount,buyCount + 1,TreasureLostManager.Instance.maxGoldDiceCount);
            this.alertAsk2.addToContent(tipText);
            this.alertAsk2.addEventListener(FrameEvent.RESPONSE,this.__alertBuyGoldDice);
            return;
         }
         this.isHideView = !this.isHideView;
         if(this.isHideView)
         {
            this.goldDiceRoll.play();
            this.goldSelectView.visible = true;
            this.goldSelectView.reset();
            this.diceRoll.mouseEnabled = false;
            this.diceRoll.mouseChildren = false;
         }
         else
         {
            this.goldDiceRoll.stop();
            this.goldDiceRoll.resetFrame();
            this.goldSelectView.visible = false;
            this.goldSelectView.reset();
            this.diceRoll.mouseEnabled = true;
            this.diceRoll.mouseChildren = true;
         }
      }
      
      private function _timerOut(e:TimerEvent) : void
      {
         var timer:Timer = e.currentTarget as Timer;
         timer.stop();
         timer.removeEventListener(TimerEvent.TIMER,this._timerOut);
         timer = null;
         SocketManager.Instance.out.treasureLostRollDice();
      }
      
      private function getRollPoint(rollStr:String) : int
      {
         var rollPoint:int = 0;
         switch(rollStr)
         {
            case "one":
               rollPoint = 1;
               break;
            case "two":
               rollPoint = 2;
               break;
            case "three":
               rollPoint = 3;
               break;
            case "four":
               rollPoint = 4;
               break;
            case "five":
               rollPoint = 5;
               break;
            case "six":
               rollPoint = 6;
         }
         return rollPoint;
      }
      
      private function getRandomRoll(roll:int) : String
      {
         var randomStr:String = null;
         var random:int = roll;
         switch(random)
         {
            case 1:
               randomStr = "one";
               break;
            case 2:
               randomStr = "two";
               break;
            case 3:
               randomStr = "three";
               break;
            case 4:
               randomStr = "four";
               break;
            case 5:
               randomStr = "five";
               break;
            case 6:
               randomStr = "six";
         }
         return randomStr;
      }
      
      protected function __addEnergyHandler(event:MouseEvent) : void
      {
         var tipText:FilterFrameText = null;
         SoundManager.instance.playButtonSound();
         var buyCount:int = TreasureLostManager.Instance.powerBuyCountLimite;
         this.buyPowerPrice = TreasureLostManager.Instance.powerBuyPrice[buyCount];
         if(TreasureLostManager.Instance.powerBuyCountLimite >= TreasureLostManager.Instance.maxPowerCount)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.buyPowerEnough"));
            return;
         }
         this.alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("treasureLost.buyPowerTxt",this.buyPowerPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         this.alertAsk.height = 180;
         tipText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.buyPowerCountTip");
         tipText.htmlText = LanguageMgr.GetTranslation("treasureLost.buyPowerCountTipText",TreasureLostManager.Instance.maxPowerCount,TreasureLostManager.Instance.powerBuyCountLimite + 1,TreasureLostManager.Instance.maxPowerCount);
         this.alertAsk.addToContent(tipText);
         this.alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
      }
      
      public function addMapView() : void
      {
         this.mapView = new TreasureLostMapView(TreasureLostManager.Instance.mapTypeArr,TreasureLostManager.Instance.mapPosArr,TreasureLostManager.Instance.currentMap);
         this.mapView.rotationX = -30;
         this.mapView.scaleX = 1.2;
         this.mapView.scaleY = 0.8;
         PositionUtils.setPos(this.mapView,"treasureLost.treasureLostMapPos1");
         addChild(this.mapView);
      }
      
      protected function __alertBuyEnergy(event:FrameEvent) : void
      {
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(PlayerManager.Instance.Self.Money < this.buyPowerPrice)
               {
                  LeavePageManager.showFillFrame();
                  frame.dispose();
                  return;
               }
               if(TreasureLostManager.Instance.power > 0 && TreasureLostManager.Instance.power < TreasureLostStaticValue.FULLPOWER)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.cantBuyPower"));
                  frame.dispose();
                  return;
               }
               SocketManager.Instance.out.treasureLostBuyItem(1);
               break;
         }
         frame.dispose();
      }
      
      protected function __alertBuyGoldDice(event:FrameEvent) : void
      {
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyGoldDice);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyGoldDice);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(PlayerManager.Instance.Self.Money < this.buyGoldDicePrice)
               {
                  LeavePageManager.showFillFrame();
                  frame.dispose();
                  return;
               }
               SocketManager.Instance.out.treasureLostBuyItem(2);
               break;
         }
         frame.dispose();
      }
      
      private function initEvents() : void
      {
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.PLAYER_ROLL_DICE,this.__playerWalk);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.PLAYER_ROLL_GOLDDICE,this.__playerWalkgold);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.PLAYER_SELECT_CHADAO,this.__playerSelectChadao);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.PLAYER_EVENT_DISPATCH,this.__playerEventDispatch);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.PLAYER_BUY_ITEM,this.__playerBuyItem);
         TreasureLostManager.Instance.addEventListener(TreasureLostEvents.UpDate_FIVE_ITEM,this.__updateFiveItem);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__playerBuyBall);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         this._energyAddBtn.addEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         this.diceRoll.addEventListener(MouseEvent.CLICK,this._diceRoll);
         this.role.addEventListener(TreasureLostEvents.ROLEWALKEND,this.__walkEnd);
         this.goldDiceRoll.addEventListener(MouseEvent.CLICK,this._goldDiceRoll);
         this.goldSelectView.addEventListener(TreasureLostEvents.SELECTGOLDDICEROLL,this.__selectGoldDiceRoll);
         this.mapView.addEventListener(TreasureLostEvents.SELECTDIRECTION,this.__selectDirection);
         this.itemExchange.addEventListener(MouseEvent.CLICK,this._itemExchange);
      }
      
      private function __playerBuyBall(evt:BagEvent) : void
      {
         this.buyBattalOne.updateCount();
         this.buyBattalAll.updateCount();
      }
      
      private function __playerBuyItem(e:TreasureLostEvents) : void
      {
         var power:int = 0;
         var powerLimit:int = 0;
         var pkg:PackageIn = e.data as PackageIn;
         var type:int = pkg.readInt();
         var success:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         var countLimit:int = pkg.readInt();
         if(success)
         {
            if(type == 1)
            {
               power = TreasureLostManager.Instance.power;
               TreasureLostManager.Instance.power = count;
               powerLimit = TreasureLostManager.Instance.powerBuyCountLimite;
               TreasureLostManager.Instance.powerBuyCountLimite = countLimit;
               this._powerProgress.showProgressBar(TreasureLostManager.Instance.power,TreasureLostStaticValue.FULLPOWER);
            }
            else if(type == 2)
            {
               TreasureLostManager.Instance.goldDiceRollBuyCount = count;
               TreasureLostManager.Instance.goldDiceRollBuyCountLimite = countLimit;
               this.goldDiceRollBuyCountTxt.text = TreasureLostManager.Instance.goldDiceRollBuyCount + "";
            }
         }
      }
      
      private function __playerWalk(e:TreasureLostEvents) : void
      {
         var rolePath:Array = null;
         TreasureLostManager.Instance.power -= 5;
         this._powerProgress.showProgressBar(TreasureLostManager.Instance.power,TreasureLostStaticValue.FULLPOWER);
         var pkg:PackageIn = e.data as PackageIn;
         var nowPosition:int = pkg.readInt();
         var rollPoint:int = pkg.readInt();
         var endType:int = pkg.readInt();
         var ke:int = TreasureLostManager.Instance.playerCurrentPath;
         if(nowPosition != ke)
         {
            return;
         }
         var random:String = this.getRandomRoll(rollPoint);
         this.diceRoll.goFrame(random);
         if(this.directionSelected)
         {
            rolePath = this.getPlayerPathWithDiceRoll_Direction(rollPoint);
         }
         else
         {
            rolePath = this.getPlayerPathWithDiceRoll(rollPoint);
         }
         this.role.roleWalk(rolePath);
      }
      
      private function __playerWalkgold(e:TreasureLostEvents) : void
      {
         var rolePath:Array = null;
         var pkg:PackageIn = e.data as PackageIn;
         var nowPosition:int = pkg.readInt();
         var rollPoint:int = pkg.readInt();
         var endType:int = pkg.readInt();
         var ke:int = TreasureLostManager.Instance.playerCurrentPath;
         if(rollPoint == 0)
         {
            this.rollUnClick(true);
            return;
         }
         TreasureLostManager.Instance.power -= 5;
         this._powerProgress.showProgressBar(TreasureLostManager.Instance.power,TreasureLostStaticValue.FULLPOWER);
         --TreasureLostManager.Instance.goldDiceRollBuyCount;
         this.goldDiceRollBuyCountTxt.text = TreasureLostManager.Instance.goldDiceRollBuyCount + "";
         if(nowPosition != ke)
         {
            MessageTipManager.getInstance().show("服务器当前位置和客户端当前位置不一致" + "客：" + ke + "服:" + nowPosition);
            return;
         }
         var random:String = this.getRandomRoll(rollPoint);
         if(this.directionSelected)
         {
            rolePath = this.getPlayerPathWithDiceRoll_Direction(rollPoint);
         }
         else
         {
            rolePath = this.getPlayerPathWithDiceRoll(rollPoint);
         }
         this.role.roleWalk(rolePath);
      }
      
      private function __playerSelectChadao(e:TreasureLostEvents) : void
      {
         var pkg:PackageIn = e.data as PackageIn;
         var nowPosition:int = pkg.readInt();
         var rollPoint:int = pkg.readInt();
         var endType:int = pkg.readInt();
         if(rollPoint != this.unWalkNum)
         {
            MessageTipManager.getInstance().show("服务器剩余步数和客户端当前位置不一致" + "客：" + TreasureLostManager.Instance.playerCurrentPath + "服:" + nowPosition);
            return;
         }
      }
      
      private function _itemExchange(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._shopframe = ComponentFactory.Instance.creatComponentByStylename("treasureLost.view.treasureLostShopFrame");
         this._shopframe.addEventListener(FrameEvent.RESPONSE,this.shopframeEvent);
         LayerManager.Instance.addToLayer(this._shopframe,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function shopframeEvent(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._shopframe.dispose();
      }
      
      private function __selectDirection(e:TreasureLostEvents) : void
      {
         var type:int = int(e.data);
         var num:int = TreasureLostManager.Instance.unWalkPoint;
         if(num > 0)
         {
            this.unWalkNum = TreasureLostManager.Instance.unWalkPoint;
         }
         if(type == 1)
         {
            SocketManager.Instance.out.treasureLostSelcetDirection(true);
            this.selecDirectionType = 1;
            if(this.unWalkNum <= 0)
            {
               this.directionSelected = true;
               this.rollUnClick(true);
            }
            else if(this.unWalkNum > 0)
            {
               this.walkUnWakeNum(this.selecDirectionType);
               this.directionSelected = false;
            }
         }
         else if(type == 2)
         {
            SocketManager.Instance.out.treasureLostSelcetDirection(false);
            this.selecDirectionType = 2;
            if(this.unWalkNum <= 0)
            {
               this.directionSelected = true;
               this.rollUnClick(true);
            }
            else if(this.unWalkNum > 0)
            {
               this.walkUnWakeNum(this.selecDirectionType);
               this.directionSelected = false;
            }
         }
      }
      
      public function getPathWithNoSpecial(pathArr:Array) : Array
      {
         var special:int = 0;
         var path:int = 0;
         var n:int = 0;
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         var specialArr:Array = [];
         for(var j:int = 0; j < specialLength; j++)
         {
            specialArr.push(specialNum + j + 1);
         }
         for(var m:int = 0; m < pathArr.length; m++)
         {
            for(n = 0; n < specialArr.length; n++)
            {
               path = int(pathArr[m]);
               special = int(specialArr[n]);
               if(path == special)
               {
                  pathArr.splice(m,1);
               }
            }
         }
         return pathArr;
      }
      
      public function getPlayerPathWithDiceRoll(rollPoint:int) : Array
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var bool:Boolean = true;
         var nowPosition:int = TreasureLostManager.Instance.playerCurrentPath;
         var mapId:int = TreasureLostManager.Instance.currentMap;
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         if(nowPosition + rollPoint > TreasureLostManager.Instance.maxMapItemNum)
         {
            rollPoint = TreasureLostManager.Instance.maxMapItemNum - nowPosition;
         }
         var pathArr:Array = [];
         if(nowPosition + rollPoint < specialNum)
         {
            for(i = 0; i < rollPoint; i++)
            {
               nowPosition++;
               pathArr.push(nowPosition);
            }
            this.unWalkNum = 0;
            TreasureLostManager.Instance.unWalkPoint = 0;
         }
         else if(nowPosition + rollPoint == specialNum)
         {
            for(j = 0; j < rollPoint; j++)
            {
               nowPosition++;
               pathArr.push(nowPosition);
            }
            this.unWalkNum = 0;
            TreasureLostManager.Instance.unWalkPoint = 0;
         }
         else if(nowPosition + rollPoint > specialNum)
         {
            for(k = 0; k < rollPoint; k++)
            {
               if(nowPosition < specialNum)
               {
                  nowPosition++;
               }
               else
               {
                  if(nowPosition == specialNum)
                  {
                     if(bool)
                     {
                        this.unWalkNum = rollPoint - k;
                        bool = false;
                     }
                     continue;
                  }
                  if(nowPosition > specialNum)
                  {
                     if(nowPosition <= specialNum + specialLength)
                     {
                        nowPosition++;
                        if(nowPosition > specialNum + specialLength)
                        {
                           nowPosition = specialNum + specialLength;
                           continue;
                        }
                     }
                     else if(nowPosition > specialNum + specialLength)
                     {
                        nowPosition++;
                     }
                  }
               }
               pathArr.push(nowPosition);
            }
         }
         TreasureLostManager.Instance.playerCurrentPath = nowPosition;
         return this.getPathArr(pathArr);
      }
      
      public function getPlayerPathWithDiceRoll_Direction(rollPoint:int) : Array
      {
         var nowPosition:int = TreasureLostManager.Instance.playerCurrentPath;
         var mapId:int = TreasureLostManager.Instance.currentMap;
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         if(nowPosition + rollPoint > TreasureLostManager.Instance.maxMapItemNum)
         {
            rollPoint = TreasureLostManager.Instance.maxMapItemNum - nowPosition;
         }
         var pathArr:Array = [];
         for(var k:int = 0; k < rollPoint; k++)
         {
            if(this.selecDirectionType == 1 && this.directionSelected)
            {
               if(nowPosition <= specialNum + specialLength)
               {
                  nowPosition++;
                  if(nowPosition > specialNum + specialLength)
                  {
                     nowPosition = specialNum + specialLength;
                     continue;
                  }
               }
               pathArr.push(nowPosition);
            }
            else if(this.selecDirectionType == 2 && this.directionSelected)
            {
               if(nowPosition == specialNum)
               {
                  nowPosition = specialNum + specialLength + 1;
               }
               else
               {
                  nowPosition++;
               }
               pathArr.push(nowPosition);
            }
         }
         TreasureLostManager.Instance.playerCurrentPath = nowPosition;
         var rollPath:Array = this.getPathArr(pathArr);
         this.directionSelected = false;
         return rollPath;
      }
      
      private function walkUnWakeNum(directionType:int) : void
      {
         var i:int = 0;
         var j:int = 0;
         var nowPosition:int = TreasureLostManager.Instance.playerCurrentPath;
         var mapId:int = TreasureLostManager.Instance.currentMap;
         var specialNum:int = TreasureLostManager.Instance.specialMapNum;
         var specialLength:int = TreasureLostManager.Instance.specialLength;
         var pathArr:Array = [];
         if(directionType == 1)
         {
            for(i = 0; i < this.unWalkNum; i++)
            {
               if(this.unWalkNum <= specialLength)
               {
                  nowPosition++;
               }
               else if(this.unWalkNum > specialLength)
               {
                  nowPosition++;
                  if(nowPosition > specialNum + specialLength)
                  {
                     nowPosition = specialNum + specialLength;
                     continue;
                  }
               }
               pathArr.push(nowPosition);
            }
         }
         else if(directionType == 2)
         {
            for(j = 0; j < this.unWalkNum; j++)
            {
               if(nowPosition == specialNum)
               {
                  nowPosition = specialNum + specialLength + 1;
               }
               else if(nowPosition > specialNum)
               {
                  nowPosition++;
               }
               pathArr.push(nowPosition);
            }
         }
         else if(directionType == 0)
         {
         }
         TreasureLostManager.Instance.playerCurrentPath = nowPosition;
         var rollPath:Array = this.getPathArr(pathArr);
         this.role.roleWalk(rollPath);
      }
      
      private function __selectGoldDiceRoll(e:TreasureLostEvents) : void
      {
         var diceRollPoint:int = int(e.data);
         this.goldDiceRoll.resetFrame();
         this.goldSelectView.visible = false;
         this.goldSelectView.reset();
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.noWeapon"));
            return;
         }
         SocketManager.Instance.out.treasureLostRollGoldDice(diceRollPoint);
      }
      
      private function removeEvents() : void
      {
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.PLAYER_ROLL_DICE,this.__playerWalk);
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.PLAYER_ROLL_GOLDDICE,this.__playerWalkgold);
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.PLAYER_SELECT_CHADAO,this.__playerSelectChadao);
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.PLAYER_EVENT_DISPATCH,this.__playerEventDispatch);
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.PLAYER_BUY_ITEM,this.__playerBuyItem);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__playerBuyBall);
         TreasureLostManager.Instance.removeEventListener(TreasureLostEvents.UpDate_FIVE_ITEM,this.__updateFiveItem);
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         }
         if(Boolean(this._energyAddBtn))
         {
            this._energyAddBtn.removeEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         }
         if(Boolean(this.diceRoll))
         {
            this.diceRoll.removeEventListener(MouseEvent.CLICK,this._diceRoll);
         }
         if(Boolean(this.role))
         {
            this.role.removeEventListener(TreasureLostEvents.ROLEWALKEND,this.__walkEnd);
         }
         if(Boolean(this.goldSelectView))
         {
            this.goldSelectView.removeEventListener(TreasureLostEvents.SELECTGOLDDICEROLL,this.__selectGoldDiceRoll);
         }
         if(Boolean(this.mapView))
         {
            this.mapView.removeEventListener(TreasureLostEvents.SELECTDIRECTION,this.__selectDirection);
         }
         if(Boolean(this.itemExchange))
         {
            this.itemExchange.removeEventListener(MouseEvent.CLICK,this._itemExchange);
         }
      }
      
      private function openHelpViewHander(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var helpframe:TreasureLostHelpFrame = ComponentFactory.Instance.creatComponentByStylename("treasureLost.view.helpFrame");
         helpframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(helpframe,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.currentTarget.dispose();
      }
      
      public function dispose() : void
      {
         TreasureLostManager.Instance.isMove = false;
         SocketManager.Instance.out.treasureLostExit();
         this.removeEvents();
         TreasureLostManager.Instance.playerCurrentPath = 0;
         if(Boolean(this.alertAsk))
         {
            this.alertAsk.dispose();
         }
         if(Boolean(this._shopframe))
         {
            this._shopframe.dispose();
         }
         if(Boolean(this.alertAsk2))
         {
            this.alertAsk2.dispose();
         }
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(Boolean(this._returnBtn))
         {
            ObjectUtils.disposeObject(this._returnBtn);
            this._returnBtn = null;
         }
      }
   }
}

