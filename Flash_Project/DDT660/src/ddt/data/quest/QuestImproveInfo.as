package ddt.data.quest
{
   public class QuestImproveInfo
   {
      
      private var _bindMoneyRate:Array;
      
      private var _expRate:Array;
      
      private var _goldRate:Array;
      
      private var _exploitRate:Array;
      
      private var _canOneKeyFinishTime:int;
      
      public function QuestImproveInfo()
      {
         super();
      }
      
      public function get canOneKeyFinishTime() : int
      {
         return this._canOneKeyFinishTime;
      }
      
      public function set canOneKeyFinishTime(value:int) : void
      {
         this._canOneKeyFinishTime = value;
      }
      
      public function get exploitRate() : Array
      {
         return this._exploitRate;
      }
      
      public function set exploitRate(value:Array) : void
      {
         this._exploitRate = value;
      }
      
      public function get goldRate() : Array
      {
         return this._goldRate;
      }
      
      public function set goldRate(value:Array) : void
      {
         this._goldRate = value;
      }
      
      public function get expRate() : Array
      {
         return this._expRate;
      }
      
      public function set expRate(value:Array) : void
      {
         this._expRate = value;
      }
      
      public function get bindMoneyRate() : Array
      {
         return this._bindMoneyRate;
      }
      
      public function set bindMoneyRate(value:Array) : void
      {
         this._bindMoneyRate = value;
      }
   }
}

