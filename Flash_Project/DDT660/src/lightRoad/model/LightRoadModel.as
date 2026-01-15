package lightRoad.model
{
   import flash.events.EventDispatcher;
   import lightRoad.info.LightGiftInfo;
   
   public class LightRoadModel extends EventDispatcher
   {
      
      public var isOpen:Boolean = false;
      
      public var ActivityStartTime:String = "0000.00.00";
      
      public var ActivityEndTime:String = "0000.00.00";
      
      private var _thingsArray:Vector.<LightGiftInfo>;
      
      private var _thingsXY:Array;
      
      private var _thingsIntType:int;
      
      private var _thingsType:Array = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      private var _pointGroup:Array = [[5,[1,2]],[6,[3,4]],[8,[5,6]],[11,[7,8]],[12,[8,9]],[14,[10,11]],[16,[12,13]],[17,[14,15,16]]];
      
      public function LightRoadModel()
      {
         super();
      }
      
      public function get thingsIntType() : int
      {
         return this._thingsIntType;
      }
      
      public function set thingsIntType(Message:int) : void
      {
         this._thingsIntType = Message;
      }
      
      public function initThingsArray() : void
      {
         this._thingsXY = new Array();
         this._thingsArray = new Vector.<LightGiftInfo>();
         this._thingsXY.push([44,114]);
         this._thingsXY.push([44,214]);
         this._thingsXY.push([44,314]);
         this._thingsXY.push([44,414]);
         this._thingsXY.push([174,158]);
         this._thingsXY.push([174,362]);
         this._thingsXY.push([307,160]);
         this._thingsXY.push([307,261]);
         this._thingsXY.push([307,369]);
         this._thingsXY.push([444,114]);
         this._thingsXY.push([444,213]);
         this._thingsXY.push([444,316]);
         this._thingsXY.push([443,413]);
         this._thingsXY.push([584,156]);
         this._thingsXY.push([584,260]);
         this._thingsXY.push([584,360]);
         this._thingsXY.push([748,261]);
      }
      
      public function get thingsXYArray() : Array
      {
         return this._thingsXY;
      }
      
      public function get thingsArray() : Vector.<LightGiftInfo>
      {
         return this._thingsArray;
      }
      
      public function set thingsArray(Message:Vector.<LightGiftInfo>) : void
      {
         this._thingsArray = Message;
      }
      
      public function get thingsType() : Array
      {
         return this._thingsType;
      }
      
      public function set thingsType(Message:Array) : void
      {
         this._thingsType = Message;
      }
      
      public function get pointGroup() : Array
      {
         return this._pointGroup;
      }
      
      public function set pointGroup(Message:Array) : void
      {
         this._pointGroup = Message;
      }
   }
}

