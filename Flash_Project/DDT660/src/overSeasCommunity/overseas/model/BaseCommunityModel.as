package overSeasCommunity.overseas.model
{
   import flash.events.EventDispatcher;
   
   public class BaseCommunityModel extends EventDispatcher
   {
      
      private var _typeId:int;
      
      public var backgroundServerTxt:String;
      
      public var receptionistTxt:String;
      
      public function BaseCommunityModel()
      {
         super();
      }
      
      public function get typeId() : int
      {
         return this._typeId;
      }
      
      public function set typeId(value:int) : void
      {
         this._typeId = value;
      }
   }
}

