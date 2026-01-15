package ddt.data.quest
{
   public class QuestCondition
   {
      
      private var _description:String;
      
      private var _type:int;
      
      private var _param1:int;
      
      private var _param2:int;
      
      private var _questId:int;
      
      private var _conId:int;
      
      public var isOpitional:Boolean;
      
      public function QuestCondition(questId:int, conId:int, type:int, desc:String = "", para1:int = 0, para2:int = 0)
      {
         super();
         this._questId = questId;
         this._conId = conId;
         this._description = desc;
         this._type = type;
         this._param1 = para1;
         this._param2 = para2;
      }
      
      public function get target() : int
      {
         if(this._type == 20 && this._param1 != 3)
         {
            if(!this._param2)
            {
               return 0;
            }
         }
         return this._param2;
      }
      
      public function get param() : int
      {
         if(!this._param1)
         {
            return 0;
         }
         return this._param1;
      }
      
      public function get param2() : int
      {
         if(!this._param2)
         {
            return 0;
         }
         return this._param2;
      }
      
      public function get description() : String
      {
         if(this._description == "")
         {
            return "no description";
         }
         return this._description;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function tos() : String
      {
         return this._description;
      }
      
      public function get questID() : int
      {
         return this._questId;
      }
      
      public function get ConID() : int
      {
         return this._conId;
      }
   }
}

