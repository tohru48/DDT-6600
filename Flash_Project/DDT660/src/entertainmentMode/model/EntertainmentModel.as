package entertainmentMode.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import room.model.RoomInfo;
   
   public class EntertainmentModel extends EventDispatcher
   {
      
      public static const ROOMLIST_CHANGE:String = "roomlistchange";
      
      public static const SCORE_CHANGE:String = "scoreChange";
      
      private static var _instance:EntertainmentModel = null;
      
      private var _roomList:Object = {};
      
      private var _score:int;
      
      private var _roomTotal:int;
      
      private var _scoreArr:Array;
      
      private var _selfScore:int;
      
      public function EntertainmentModel()
      {
         super();
      }
      
      public static function get instance() : EntertainmentModel
      {
         if(_instance == null)
         {
            _instance = new EntertainmentModel();
         }
         return _instance;
      }
      
      public function get roomList() : Object
      {
         return this._roomList;
      }
      
      public function updateRoom(arr:Array) : void
      {
         this._roomList = {};
         for(var i:int = 0; i < arr.length; i++)
         {
            this._roomList[arr[i].ID] = arr[i];
         }
         dispatchEvent(new Event(ROOMLIST_CHANGE));
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(value:int) : void
      {
         this._score = value;
         dispatchEvent(new Event(SCORE_CHANGE));
      }
      
      public function set roomTotal(value:int) : void
      {
         this._roomTotal = value;
      }
      
      public function get roomTotal() : int
      {
         return this._roomTotal;
      }
      
      public function getRoomById(id:int) : RoomInfo
      {
         return this._roomList[id];
      }
      
      public function get scoreArr() : Array
      {
         return this._scoreArr;
      }
      
      public function set scoreArr(value:Array) : void
      {
         this._scoreArr = value;
      }
      
      public function get selfScore() : int
      {
         return this._selfScore;
      }
      
      public function set selfScore(value:int) : void
      {
         this._selfScore = value;
      }
   }
}

