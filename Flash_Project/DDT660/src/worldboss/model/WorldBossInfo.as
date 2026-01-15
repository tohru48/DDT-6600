package worldboss.model
{
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import worldboss.player.PlayerVO;
   
   public class WorldBossInfo extends EventDispatcher
   {
      
      private var _total_Blood:Number;
      
      private var _current_Blood:Number;
      
      private var _isLiving:Boolean;
      
      private var _begin_time:Date;
      
      private var _fight_time:int;
      
      private var _end_time:Date;
      
      private var _fightOver:Boolean;
      
      private var _room_close:Boolean;
      
      private var _currentState:int = 0;
      
      private var _ticketID:int;
      
      private var _need_ticket_count:int;
      
      private var _cutValue:Number;
      
      private var _name:String;
      
      private var _timeCD:int;
      
      private var _reviveMoney:int;
      
      private var _reFightMoney:int;
      
      private var _addInjureBuffMoney:int;
      
      private var _addInjureValue:int;
      
      private var _myPlayerVO:PlayerVO;
      
      private var _playerDefaultPos:Point;
      
      private var _buffArray:Array = new Array();
      
      public function WorldBossInfo()
      {
         super();
      }
      
      public function set total_Blood(value:Number) : void
      {
         this._total_Blood = value;
      }
      
      public function get total_Blood() : Number
      {
         return this._total_Blood;
      }
      
      public function set current_Blood(value:Number) : void
      {
         if(this._current_Blood == value)
         {
            this._cutValue = -1;
            return;
         }
         this._cutValue = this._current_Blood - value;
         this._current_Blood = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get current_Blood() : Number
      {
         return this._current_Blood;
      }
      
      public function set isLiving(value:Boolean) : void
      {
         this._isLiving = value;
         if(!this._isLiving)
         {
            this.current_Blood = 0;
         }
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      public function get begin_time() : Date
      {
         return this._begin_time;
      }
      
      public function set begin_time(value:Date) : void
      {
         this._begin_time = value;
      }
      
      public function get end_time() : Date
      {
         return this._end_time;
      }
      
      public function set end_time(value:Date) : void
      {
         this._end_time = value;
      }
      
      public function get fight_time() : int
      {
         return this._fight_time;
      }
      
      public function set fight_time(value:int) : void
      {
         this._fight_time = value;
      }
      
      public function getLeftTime() : int
      {
         var left_time:Number = TimeManager.Instance.TotalSecondToNow(this.begin_time);
         if(left_time > 0 && left_time < this.fight_time * 60)
         {
            return this.fight_time * 60 - left_time;
         }
         return 0;
      }
      
      public function get fightOver() : Boolean
      {
         return this._fightOver;
      }
      
      public function set fightOver(value:Boolean) : void
      {
         this._fightOver = value;
      }
      
      public function get roomClose() : Boolean
      {
         return this._room_close;
      }
      
      public function set roomClose(value:Boolean) : void
      {
         this._room_close = value;
      }
      
      public function get currentState() : int
      {
         return this._currentState;
      }
      
      public function set currentState(value:int) : void
      {
         this._currentState = value;
      }
      
      public function set ticketID(value:int) : void
      {
         this._ticketID = value;
      }
      
      public function get ticketID() : int
      {
         return this._ticketID;
      }
      
      public function set need_ticket_count(value:int) : void
      {
         this._need_ticket_count = value;
      }
      
      public function get need_ticket_count() : int
      {
         return this._need_ticket_count;
      }
      
      public function get cutValue() : Number
      {
         return this._cutValue;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set timeCD(value:int) : void
      {
         this._timeCD = value;
      }
      
      public function get timeCD() : int
      {
         return this._timeCD;
      }
      
      public function set reviveMoney(value:int) : void
      {
         this._reviveMoney = value;
      }
      
      public function get reviveMoney() : int
      {
         return this._reviveMoney;
      }
      
      public function get buffArray() : Array
      {
         return this._buffArray;
      }
      
      public function getbuffInfoByID(id:int) : WorldBossBuffInfo
      {
         for(var i:int = 0; i < this._buffArray.length; i++)
         {
            if(id == (this._buffArray[i] as WorldBossBuffInfo).ID)
            {
               return this._buffArray[i];
            }
         }
         return new WorldBossBuffInfo();
      }
      
      public function set myPlayerVO(value:PlayerVO) : void
      {
         this._myPlayerVO = value;
      }
      
      public function get myPlayerVO() : PlayerVO
      {
         return this._myPlayerVO;
      }
      
      public function set playerDefaultPos(value:Point) : void
      {
         this._playerDefaultPos = value;
      }
      
      public function get playerDefaultPos() : Point
      {
         return this._playerDefaultPos;
      }
      
      public function get reFightMoney() : int
      {
         return this._reFightMoney;
      }
      
      public function set reFightMoney(value:int) : void
      {
         this._reFightMoney = value;
      }
      
      public function get addInjureBuffMoney() : int
      {
         return this._addInjureBuffMoney;
      }
      
      public function set addInjureBuffMoney(value:int) : void
      {
         this._addInjureBuffMoney = value;
      }
      
      public function get addInjureValue() : int
      {
         return this._addInjureValue;
      }
      
      public function set addInjureValue(value:int) : void
      {
         this._addInjureValue = value;
      }
   }
}

