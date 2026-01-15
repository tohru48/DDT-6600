package superWinner.data
{
   import ddt.manager.ItemManager;
   
   public class SuperWinnerAwardsMode
   {
      
      private var _type:uint = 0;
      
      private var _goodId:uint = 0;
      
      private var _goodName:String = "";
      
      private var _count:uint = 0;
      
      public function SuperWinnerAwardsMode()
      {
         super();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function set type(val:uint) : void
      {
         this._type = val;
      }
      
      public function get goodId() : uint
      {
         return this._goodId;
      }
      
      public function set goodId(val:uint) : void
      {
         this._goodId = val;
         this.formatGood(this._goodId);
      }
      
      public function get goodName() : String
      {
         return this._goodName;
      }
      
      private function formatGood(val:uint) : void
      {
         this._goodName = ItemManager.Instance.getTemplateById(val).Name;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      public function set count(val:uint) : void
      {
         this._count = val;
      }
   }
}

