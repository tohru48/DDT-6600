package ddt.view.roulette
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TurnControl extends EventDispatcher
   {
      
      public static const TURNCOMPLETE:String = "turn_complete";
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const MINTIME_PLAY_SOUNDONESTEP:int = 30;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      public static const SHADOW_NUMBER:int = 3;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 9;
      
      public static const SPEEDUP_RATE:int = -60;
      
      public static const SPEEDDOWN_RATE:int = 30;
      
      private var _goodsList:Vector.<RouletteGoodsCell>;
      
      private var _turnType:int = 1;
      
      private var _timer:Timer;
      
      private var _timerII:Timer;
      
      private var _isStopTurn:Boolean = false;
      
      private var _nowDelayTime:int = 1000;
      
      private var _sparkleNumber:int = 0;
      
      private var _delay:Array = [500,30,500];
      
      private var _moveTime:Array = [2000,3000,2000];
      
      private var _selectedGoodsNumber:int = 0;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _stepTime:int = 0;
      
      private var _startModerationNumber:int = 0;
      
      private var _moderationNumber:int = 0;
      
      private var _sound:TurnSoundControl;
      
      public function TurnControl(target:IEventDispatcher = null)
      {
         super(target);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._sound = new TurnSoundControl();
         this._timerII = new Timer(600);
         this._timerII.stop();
      }
      
      public function set autoMove(boo:Boolean) : void
      {
         if(boo)
         {
            this._timerII.start();
         }
         else
         {
            this._timerII.stop();
         }
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._timerII.addEventListener(TimerEvent.TIMER,this._timerIITimer);
      }
      
      private function _startTimer(time:int) : void
      {
         if(!this._isStopTurn)
         {
            this._timer.delay = time;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function _nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            this._goodsList[this.sparkleNumber].setSparkle();
            this._clearPrevSelct(this.sparkleNumber,this.prevSelected);
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
      
      private function _clearPrevSelct(now:int, prev:int) : void
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
      
      private function _timeComplete(e:TimerEvent) : void
      {
         this._updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this._nextNode();
         this._startTimer(this.nowDelayTime);
      }
      
      private function _timerIITimer(e:TimerEvent) : void
      {
         this._goodsList[this.sparkleNumber].setGreep();
         this._goodsList[this.sparkleNumber].selected = false;
         this.sparkleNumber += 1;
         if(this.sparkleNumber == this._goodsList.length)
         {
            this.sparkleNumber = 0;
         }
         this._goodsList[this.sparkleNumber].setSparkle();
      }
      
      private function _updateTurnType(value:int) : void
      {
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
      
      public function startTurn() : void
      {
         this._isStopTurn = false;
         --this.sparkleNumber;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
      }
      
      public function stopTurn() : void
      {
         this._isStopTurn = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._turnComplete();
      }
      
      private function _turnComplete() : void
      {
         dispatchEvent(new Event(TurnControl.TURNCOMPLETE));
      }
      
      public function turnPlate(list:Vector.<RouletteGoodsCell>, _select:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this._goodsList = list;
         this.selectedGoodsNumber = _select;
         this.startTurn();
         this._startTimer(this.nowDelayTime);
      }
      
      public function turnPlateII(list:Vector.<RouletteGoodsCell>) : void
      {
         this._goodsList = list;
         this.autoMove = true;
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
                  step = this._moderationNumber >= 7 ? this._moderationNumber - 6 : 1;
                  prev = this.sparkleNumber - step < 0 ? this.sparkleNumber - step + this._goodsList.length : this._sparkleNumber - step;
                  if(this._moderationNumber >= 8)
                  {
                     this._goodsList[prev + 1 >= this._goodsList.length ? 0 : prev + 1].selected = false;
                  }
               }
         }
         return prev;
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
      
      public function set goodsList(list:Vector.<RouletteGoodsCell>) : void
      {
         this._goodsList = list;
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
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
            this._timerII.removeEventListener(TimerEvent.TIMER,this._timerIITimer);
            this._timer = null;
         }
         if(Boolean(this._sound))
         {
            this._sound.stop();
            this._sound.dispose();
            this._sound = null;
         }
      }
   }
}

