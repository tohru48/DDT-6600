package wantstrong.data
{
   public class WantStrongContentInfo
   {
      
      private var _id:int;
      
      private var _title:String;
      
      private var _icoID:int;
      
      public function WantStrongContentInfo()
      {
         super();
      }
      
      public function get icoID() : int
      {
         return this._icoID;
      }
      
      public function set icoID(value:int) : void
      {
         this._icoID = value;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
   }
}

