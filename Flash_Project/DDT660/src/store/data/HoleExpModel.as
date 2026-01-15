package store.data
{
   public class HoleExpModel
   {
      
      private var _expList:Array;
      
      private var _maxLv:int;
      
      private var _maxOpLv:int;
      
      public function HoleExpModel()
      {
         super();
      }
      
      public function set explist(val:String) : void
      {
         this._expList = val.split("|");
      }
      
      public function set maxLv(lv:String) : void
      {
         this._maxLv = int(lv);
      }
      
      public function set oprationLv(lv:String) : void
      {
         this._maxOpLv = int(lv);
      }
      
      public function getMaxLv() : int
      {
         return this._maxLv;
      }
      
      public function getMaxOpLv() : int
      {
         return this._maxOpLv;
      }
      
      public function getExpByLevel(lv:int) : int
      {
         var exp:int = int(this._expList[lv]);
         if(exp >= 0)
         {
            return exp;
         }
         return -1;
      }
   }
}

