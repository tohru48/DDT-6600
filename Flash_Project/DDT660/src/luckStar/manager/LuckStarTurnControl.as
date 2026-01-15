package luckStar.manager
{
   import ddt.view.roulette.TurnSoundControl;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import luckStar.cell.LuckStarCell;
   
   public class LuckStarTurnControl extends EventDispatcher
   {
      
      public static const SPEEDUP_RATE:int = -60;
      
      public static const SPEEDDOWN_RATE:int = 40;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      public static const TURNCOMPLETE:String = "turn_complete";
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const SHADOW_NUMBER:int = 3;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 9;
      
      private var _goodsList:Vector.<LuckStarCell>;
      
      private var _sound:TurnSoundControl;
      
      private var _delay:Array = [300,30,500];
      
      private var _moveTime:Array = [1000,2000];
      
      private var _nowDelayTime:int = 1000;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _timer:Timer;
      
      private var _turnType:int = 0;
      
      private var _stepTime:int;
      
      private var _isStopTurn:Boolean = true;
      
      private var _selectedGoodsNumber:Number;
      
      private var _moderationNumber:Number;
      
      private var _startModerationNumber:Number;
      
      private var _turnStop:Boolean;
      
      private var _sparkleNumber:Number;
      
      private var _turnContinue:Boolean;
      
      public function LuckStarTurnControl(target:IEventDispatcher = null)
      {
         super(target);
         this.init();
      }
      
      private function init() : void
      {
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._sound = new TurnSoundControl();
      }
      
      private function __onTimerComplete(e:TimerEvent) : void
      {
         this._updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this._nextNode();
         this._startTimer(this.nowDelayTime);
      }
      
      private function _nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            this._goodsList[this.sparkleNumber].setSparkle();
            this._clearPrevSelct(this.sparkleNumber,this.prevSelected);
            if(this.nowDelayTime > SPEEDDOWN_RATE && this.turnType == TYPE_SPEED_UP)
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
               if(this._turnTypeTimeSum >= this._moveTime[0] && this._sparkleNumber == this._startModerationNumber)
               {
                  this.turnType = TYPE_SPEED_DOWN;
               }
               break;
            case TYPE_SPEED_DOWN:
               --this._moderationNumber;
               if(this._moderationNumber <= 0)
               {
                  this.turnComplete();
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
      
      public function turn(list:Vector.<LuckStarCell>, _select:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this._goodsList = list;
         this.selectedGoodsNumber = _select;
         this.startTurn();
         this._startTimer(this.nowDelayTime);
      }
      
      public function set turnContinue(value:Boolean) : void
      {
         this._turnContinue = value;
      }
      
      public function get turnContinue() : Boolean
      {
         return this._turnContinue;
      }
      
      private function startTurn() : void
      {
         this._isStopTurn = false;
         this._turnStop = false;
         --this.sparkleNumber;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
      }
      
      public function stopTurn() : void
      {
         this._turnStop = true;
         this._turnContinue = false;
      }
      
      private function turnComplete() : void
      {
         for(var i:int = 0; i < this._goodsList.length; i++)
         {
            this._goodsList[i].selected = false;
         }
         this._isStopTurn = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         dispatchEvent(new Event(TURNCOMPLETE));
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
      
      public function set nowDelayTime(value:int) : void
      {
         this._turnTypeTimeSum += this._nowDelayTime;
         this._nowDelayTime = value;
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
      
      public function set sparkleNumber(value:int) : void
      {
         this._sparkleNumber = value;
         if(this._sparkleNumber >= this._goodsList.length)
         {
            this._sparkleNumber = 0;
         }
      }
      
      private function get prevSelected() : int
      {
         var step:int = 0;
         var prev:int = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               prev = this.sparkleNumber == 0 ? this._goodsList.length - 1 : int(this._sparkleNumber - 1);
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
                  step = this._moderationNumber >= 7 ? int(this._moderationNumber - 6) : 1;
                  prev = this.sparkleNumber - step < 0 ? this.sparkleNumber - step + this._goodsList.length : int(this._sparkleNumber - step);
                  if(this._moderationNumber >= 8)
                  {
                     this._goodsList[prev + 1 >= this._goodsList.length ? 0 : prev + 1].selected = false;
                  }
               }
         }
         return prev;
      }
      
      public function get turnType() : int
      {
         return this._turnType;
      }
      
      public function get nowDelayTime() : int
      {
         return this._nowDelayTime;
      }
      
      public function get sparkleNumber() : int
      {
         return this._sparkleNumber;
      }
      
      public function get isTurn() : Boolean
      {
         return !this._isStopTurn;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
            this._timer = null;
         }
         if(Boolean(this._sound))
         {
            this._sound.dispose();
            this._sound = null;
         }
      }
   }
}

