package roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.roulette.TurnSoundControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class RouletteFrame extends Sprite implements Disposeable
   {
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const SHADOW_NUMBER:int = 1;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 3;
      
      public static const GLINT_ONE_TIME:int = 3000;
      
      public static const SPEEDUP_RATE:int = -70;
      
      public static const SPEEDDOWN_RATE:int = 40;
      
      public static const MINTIME_PLAY_SOUNDONESTEP:int = 30;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      private static const ESCkeyCode:int = 27;
      
      private var _rouletteBG:Bitmap;
      
      private var _rechargeableBG:Bitmap;
      
      private var _recurBG:Bitmap;
      
      private var _goodsList:Vector.<RouletteCell>;
      
      private var _glintView:LeftRouletteGlintView;
      
      private var _pointArray:Array;
      
      private var _pointNumArr:Array;
      
      private var _isStopTurn:Boolean = false;
      
      private var _turnSlectedNumber:int;
      
      private var _timer:Timer;
      
      private var _moderationNumber:int = 0;
      
      private var _nowDelayTime:int = 1000;
      
      private var _turnType:int = 1;
      
      private var _delay:Array = [600,50,600];
      
      private var _moveTime:Array = [2000,3000,2000];
      
      private var _selectedGoodsNumber:int = 0;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _stepTime:int = 0;
      
      private var _startModerationNumber:int = 0;
      
      private var _arrNum:Array;
      
      private var _close:SelectedButton;
      
      private var _help:SelectedButton;
      
      private var _start:SelectedButton;
      
      private var _exchange:SelectedButton;
      
      private var _numbmpVec:Vector.<Bitmap>;
      
      private var _pointLength:Array = [6,20];
      
      private var _sound:TurnSoundControl;
      
      private var _mask:Sprite;
      
      private var _isSend:Boolean;
      
      private var _sparkleNumber:int = 0;
      
      public function RouletteFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var rotationsNum:Array = null;
         var rotations:Array = null;
         var j:int = 0;
         var bg:Bitmap = null;
         var bg1:Bitmap = null;
         var cell:RouletteCell = null;
         this.getAllNumPoint();
         this.getAllGoodsPoint();
         rotationsNum = new Array();
         rotationsNum.push(0,0,0,0,60,60,60,80,-60,-60,-70,-60,0,0,0,0,60,60,50,60);
         rotations = new Array();
         rotations.push(0,60,120,180,240,300);
         this._goodsList = new Vector.<RouletteCell>();
         this._sound = new TurnSoundControl();
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._rouletteBG = ComponentFactory.Instance.creatBitmap("asset.roulette.TurnplateMainView");
         addChild(this._rouletteBG);
         this._rechargeableBG = ComponentFactory.Instance.creatBitmap("asset.roulette.rechargeable");
         addChild(this._rechargeableBG);
         this._recurBG = ComponentFactory.Instance.creatBitmap("asset.roulette.recur");
         this._recurBG.smoothing = true;
         this._recurBG.rotation = -60;
         addChild(this._recurBG);
         this._arrNum = [];
         this._arrNum = LeftGunRouletteManager.instance.ArrNum;
         this._numbmpVec = new Vector.<Bitmap>();
         for(var a:int = 0; a < this._arrNum.length; a++)
         {
            bg = ComponentFactory.Instance.creatBitmap("asset.roulette.number.bg" + this._arrNum[a]);
            bg.x = this._pointNumArr[a].x;
            bg.y = this._pointNumArr[a].y;
            bg.rotation = rotationsNum[a];
            bg.smoothing = true;
            addChild(bg);
            this._numbmpVec.push(bg);
         }
         this._start = ComponentFactory.Instance.creatComponentByStylename("roulette.startBtn");
         this._exchange = ComponentFactory.Instance.creatComponentByStylename("roulette.exchangeBtn");
         this._help = ComponentFactory.Instance.creatComponentByStylename("roulette.helpBtn");
         addChild(this._start);
         this._start.transparentEnable = true;
         addChild(this._exchange);
         this._exchange.transparentEnable = true;
         addChild(this._help);
         for(j = 0; j <= 5; j++)
         {
            bg1 = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.CellBGAsset");
            cell = new RouletteCell(bg1);
            cell.x = this._pointArray[j].x;
            cell.y = this._pointArray[j].y;
            cell.rotation = rotations[j];
            cell.selected = false;
            addChild(cell);
            this._goodsList.push(cell);
         }
         this._glintView = new LeftRouletteGlintView(this._pointArray);
         addChild(this._glintView);
         var gCount:int = LeftGunRouletteManager.instance.gCount;
         var reward:String = LeftGunRouletteManager.instance.reward;
         if(LeftGunRouletteManager.instance.gCount == 0 && LeftGunRouletteManager.instance.reward != "0")
         {
            this._start.visible = false;
            this._start.mouseEnabled = false;
            this.test(LeftGunRouletteManager.instance.gCount,LeftGunRouletteManager.instance.reward);
         }
         else
         {
            this._exchange.visible = false;
            this._exchange.mouseEnabled = false;
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,this._getItem);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._start.addEventListener(MouseEvent.CLICK,this.__startHandler);
         this._exchange.addEventListener(MouseEvent.CLICK,this.__exchangeHandler);
         this._help.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __keyDownHandler(event:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function getAllGoodsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Array();
         for(var i:int = 0; i < this._pointLength[0]; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("roulette.aperture.point" + i);
            this._pointArray.push(point);
         }
      }
      
      private function getAllNumPoint() : void
      {
         var point:Point = null;
         this._pointNumArr = new Array();
         for(var i:int = 0; i < this._pointLength[1]; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("roulette.number.point" + i);
            this._pointNumArr.push(point);
         }
      }
      
      private function test(num:int, str:String) : void
      {
         var count:int = num;
         var result:String = str;
         this._isSend = this.isSendNotice(result);
         if(count <= 0)
         {
            this._start.visible = this._start.mouseEnabled = false;
            this._exchange.visible = this._exchange.mouseEnabled = true;
            dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.ROULETTE_VISIBLE,result,null));
         }
         var rewards:Array = new Array();
         var num1:String = this._arrNum[0] + "." + this._arrNum[2];
         var num2:String = this._arrNum[4] + "." + this._arrNum[6];
         var num3:String = this._arrNum[8] + "." + this._arrNum[10];
         var num4:String = this._arrNum[12] + "." + this._arrNum[14];
         var num5:String = this._arrNum[16] + "." + this._arrNum[18];
         rewards.push(num1,num2,num3,num4,num5,"0");
         this.turnSlectedNumber = rewards.indexOf(result);
         if(this.turnSlectedNumber == -1)
         {
            return;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._goodsList[this.turnSlectedNumber].selected = false;
         this._glintView.showThreeCell(this.turnSlectedNumber);
      }
      
      private function _getItem(event:CrazyTankSocketEvent) : void
      {
         var result:String = null;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         result = pkg.readUTF();
         LeftGunRouletteManager.instance.gCount = count;
         LeftGunRouletteManager.instance.reward = result;
         this._isSend = this.isSendNotice(result);
         if(count <= 0)
         {
            this._start.visible = this._start.mouseEnabled = false;
            this._exchange.visible = this._exchange.mouseEnabled = true;
            dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.ROULETTE_VISIBLE,result,null));
         }
         var rewards:Array = new Array();
         var num1:String = this._arrNum[0] + "." + this._arrNum[2];
         var num2:String = this._arrNum[4] + "." + this._arrNum[6];
         var num3:String = this._arrNum[8] + "." + this._arrNum[10];
         var num4:String = this._arrNum[12] + "." + this._arrNum[14];
         var num5:String = this._arrNum[16] + "." + this._arrNum[18];
         rewards.push(num1,num2,num3,num4,num5,"0");
         this.turnSlectedNumber = rewards.indexOf(result);
         if(this.turnSlectedNumber == -1)
         {
            return;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this.addMask();
         this.turnPlate(this.turnSlectedNumber);
      }
      
      public function addMask() : void
      {
         if(this._mask == null)
         {
            this._mask = new Sprite();
            this._mask.graphics.beginFill(0,0);
            this._mask.graphics.drawRect(0,0,2000,1200);
            this._mask.graphics.endFill();
            this._mask.addEventListener(MouseEvent.CLICK,this.onMaskClick);
         }
         LayerManager.Instance.addToLayer(this._mask,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function removeMask() : void
      {
         if(this._mask != null)
         {
            this._mask.parent.removeChild(this._mask);
            this._mask.removeEventListener(MouseEvent.CLICK,this.onMaskClick);
            this._mask = null;
         }
      }
      
      private function onMaskClick(event:MouseEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roulette.running"));
      }
      
      private function isSendNotice(str:String) : Boolean
      {
         var arr:Array = str.split(".");
         var num:int = int(arr[0]);
         if(num >= 2)
         {
            return true;
         }
         return false;
      }
      
      private function _timeComplete(e:TimerEvent) : void
      {
         this.updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this.nextNode();
         this.startTimer(this.nowDelayTime);
      }
      
      private function __startHandler(event:MouseEvent) : void
      {
         SoundManager.instance.stopMusic();
         SoundManager.instance.play("008");
         this._glintView.stopGlint();
         this._exchange.mouseEnabled = false;
         this._exchange.visible = false;
         SocketManager.Instance.out.sendStartTurn_LeftGun();
      }
      
      private function __exchangeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._start.mouseEnabled = false;
         this._start.visible = false;
         dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.BUTTON_CLICK));
      }
      
      private function __closeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __helpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeftGunRouletteManager.instance.showhelpFrame();
      }
      
      private function updateTurnType(value:int) : void
      {
         var i:int = this.turnSlectedNumber;
         switch(this.turnType)
         {
            case TYPE_SPEED_UP:
               if(value <= this._delay[1])
               {
                  this.turnType = TYPE_SPEED_UNCHANGE;
               }
               break;
            case TYPE_SPEED_UNCHANGE:
               if(this._turnTypeTimeSum >= this._moveTime[1] && this._sparkleNumber == this._startModerationNumber)
               {
                  this.turnType = TYPE_SPEED_DOWN;
               }
               break;
            case TYPE_SPEED_DOWN:
               --this._moderationNumber;
               if(this._moderationNumber <= 0)
               {
                  this.stopTurn();
               }
         }
      }
      
      private function startTimer(time:int) : void
      {
         if(!this._isStopTurn)
         {
            this._timer.delay = time;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            if(this.sparkleNumber == -1)
            {
               return;
            }
            this._goodsList[this.sparkleNumber].setSparkle();
            this.clearPrevSelct(this.sparkleNumber,this.prevSelected);
            if(this.nowDelayTime > MINTIME_PLAY_SOUNDONESTEP && this.turnType == TYPE_SPEED_UP)
            {
               this._sound.stop();
               this._sound.playOneStep();
            }
            else if(this.turnType == TYPE_SPEED_DOWN && this._moderationNumber <= PLAY_SOUNDTHREESTEP_NUMBER)
            {
               this._sound.stop();
               this._sound.playThreeStep(this._moderationNumber);
            }
            else
            {
               this._sound.playSound();
            }
         }
      }
      
      private function turnPlate(_select:int, type:int = 1) : void
      {
         this.turnType = type;
         this.selectedGoodsNumber = _select;
         this.startTurn();
         this.startTimer(this.nowDelayTime);
      }
      
      private function startTurn() : void
      {
         this._isStopTurn = false;
         --this.sparkleNumber;
         WonderfulActivityManager.Instance.isRuning = false;
         this._start.mouseEnabled = this._exchange.mouseEnabled = this._help.mouseEnabled = false;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
      }
      
      private function stopTurn() : void
      {
         this._isStopTurn = true;
         WonderfulActivityManager.Instance.isRuning = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._turnComplete();
      }
      
      private function _turnComplete() : void
      {
         SoundManager.instance.playMusic("140");
         SoundManager.instance.play("126");
         this._start.mouseEnabled = this._exchange.mouseEnabled = this._help.mouseEnabled = true;
         this._goodsList[this.turnSlectedNumber].selected = false;
         this._glintView.showThreeCell(this.turnSlectedNumber);
         SocketManager.Instance.out.sendEndTurn_LeftGun();
         this._start.visible = this._start.mouseEnabled = this.turnSlectedNumber == 5 ? true : false;
         this._exchange.visible = this._exchange.mouseEnabled = this.turnSlectedNumber == 5 ? false : true;
         addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this.removeMask();
      }
      
      private function clearPrevSelct(now:int, prev:int) : void
      {
         var one:int = 0;
         var between:int = now - prev < 0 ? now - prev + this._goodsList.length : now - prev;
         if(between == 1)
         {
            this._goodsList[prev].selected = false;
         }
         else
         {
            one = now - 1 < 0 ? now - 1 + this._goodsList.length : now - 1;
            this._goodsList[one].setGreep();
            this._goodsList[prev].selected = false;
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,this._getItem);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._start.removeEventListener(MouseEvent.CLICK,this.__startHandler);
         this._exchange.removeEventListener(MouseEvent.CLICK,this.__exchangeHandler);
         this._help.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         var j:int = 0;
         this.removeEvent();
         if(this._mask != null)
         {
            ObjectUtils.disposeObject(this._mask);
         }
         this._mask = null;
         if(Boolean(this._rouletteBG))
         {
            ObjectUtils.disposeObject(this._rouletteBG);
         }
         this._rouletteBG = null;
         if(Boolean(this._rechargeableBG))
         {
            ObjectUtils.disposeObject(this._rechargeableBG);
         }
         this._rechargeableBG = null;
         if(Boolean(this._recurBG))
         {
            ObjectUtils.disposeObject(this._recurBG);
         }
         this._recurBG = null;
         if(Boolean(this._goodsList) && this._goodsList.length > 0)
         {
            for(i = 0; i < this._goodsList.length; i++)
            {
               if(Boolean(this._goodsList[i]))
               {
                  ObjectUtils.disposeObject(this._goodsList[i]);
               }
               this._goodsList[i] = null;
            }
         }
         this._goodsList = null;
         if(Boolean(this._glintView))
         {
            ObjectUtils.disposeObject(this._glintView);
         }
         this._glintView = null;
         if(Boolean(this._close))
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(Boolean(this._help))
         {
            ObjectUtils.disposeObject(this._help);
         }
         this._help = null;
         if(Boolean(this._start))
         {
            ObjectUtils.disposeObject(this._start);
         }
         this._start = null;
         if(Boolean(this._exchange))
         {
            ObjectUtils.disposeObject(this._exchange);
         }
         this._exchange = null;
         if(Boolean(this._numbmpVec) && this._numbmpVec.length > 0)
         {
            for(j = 0; j < this._numbmpVec.length; j++)
            {
               if(Boolean(this._numbmpVec[j]))
               {
                  ObjectUtils.disposeObject(this._numbmpVec[j]);
               }
               this._numbmpVec[j] = null;
            }
         }
         this._numbmpVec = null;
         if(Boolean(this._timer))
         {
            this._timer = null;
         }
         if(Boolean(this._sound))
         {
            this._sound.stop();
            this._sound.dispose();
            this._sound = null;
         }
         SoundManager.instance.playMusic("062");
         LeftGunRouletteManager.instance.setRouletteFramenull();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function set turnSlectedNumber(value:int) : void
      {
         this._turnSlectedNumber = value;
      }
      
      public function set sparkleNumber(value:int) : void
      {
         this._sparkleNumber = value;
         if(this._sparkleNumber >= this._goodsList.length)
         {
            this._sparkleNumber = 0;
         }
      }
      
      public function get sparkleNumber() : int
      {
         return this._sparkleNumber;
      }
      
      public function set nowDelayTime(value:int) : void
      {
         this._turnTypeTimeSum += this._nowDelayTime;
         this._nowDelayTime = value;
      }
      
      public function get nowDelayTime() : int
      {
         return this._nowDelayTime;
      }
      
      public function set turnType(value:int) : void
      {
         this._turnType = value;
         this._turnTypeTimeSum = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               this._nowDelayTime = this._delay[0];
               this._stepTime = SPEEDUP_RATE;
               break;
            case TYPE_SPEED_UNCHANGE:
               this._nowDelayTime = this._delay[1];
               this._stepTime = 0;
               break;
            case TYPE_SPEED_DOWN:
               this._nowDelayTime = this._delay[1];
               this._stepTime = SPEEDDOWN_RATE;
         }
      }
      
      public function get turnType() : int
      {
         return this._turnType;
      }
      
      public function set selectedGoodsNumber(value:int) : void
      {
         this._selectedGoodsNumber = value;
         this._moderationNumber = (this._delay[2] - this._delay[1]) / SPEEDDOWN_RATE;
         var m:int = this._selectedGoodsNumber - this._moderationNumber;
         while(m < 0)
         {
            m += this._goodsList.length;
         }
         this._startModerationNumber = m;
      }
      
      private function get prevSelected() : int
      {
         var step:int = 0;
         var prev:int = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               prev = this.sparkleNumber == 0 ? this._goodsList.length - 1 : this._sparkleNumber - 1;
               break;
            case TYPE_SPEED_UNCHANGE:
               prev = this.sparkleNumber - SHADOW_NUMBER < 0 ? this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length : this.sparkleNumber - SHADOW_NUMBER;
               break;
            case TYPE_SPEED_DOWN:
               if(this._moderationNumber > DOWN_SUB_SHADOW_BOL)
               {
                  prev = this.sparkleNumber - SHADOW_NUMBER < 0 ? this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length : this.sparkleNumber - SHADOW_NUMBER;
               }
               else
               {
                  step = this._moderationNumber >= 3 ? this._moderationNumber - 2 : 1;
                  prev = this.sparkleNumber - step < 0 ? this.sparkleNumber - step + this._goodsList.length : this._sparkleNumber - step;
                  if(this._moderationNumber >= 6)
                  {
                     this._goodsList[prev + 1 >= this._goodsList.length ? 0 : prev + 1].selected = false;
                  }
               }
         }
         return prev;
      }
   }
}

