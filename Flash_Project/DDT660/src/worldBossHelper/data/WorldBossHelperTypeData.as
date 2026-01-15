package worldBossHelper.data
{
   public class WorldBossHelperTypeData
   {
      
      private var _requestType:int;
      
      private var _isOpen:Boolean;
      
      private var _buffNum:int;
      
      private var _type:int;
      
      private var _openType:int = 1;
      
      public function WorldBossHelperTypeData()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(value:Boolean) : void
      {
         this._isOpen = value;
      }
      
      public function get requestType() : int
      {
         return this._requestType;
      }
      
      public function set requestType(value:int) : void
      {
         this._requestType = value;
      }
      
      public function get openType() : int
      {
         return this._openType;
      }
      
      public function set openType(value:int) : void
      {
         this._openType = value;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
      }
      
      public function get buffNum() : int
      {
         return this._buffNum;
      }
      
      public function set buffNum(value:int) : void
      {
         this._buffNum = value;
      }
   }
}

