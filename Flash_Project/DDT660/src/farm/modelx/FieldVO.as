package farm.modelx
{
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class FieldVO
   {
      
      public var fieldID:int;
      
      public var seedID:int;
      
      public var plantTime:Date;
      
      public var AccelerateTime:int;
      
      public var fieldValidDate:int;
      
      public var payTime:Date;
      
      public var gainCount:int;
      
      public var autoSeedID:int;
      
      public var autoFertilizerID:int;
      
      public var autoSeedIDCount:int;
      
      public var autoFertilizerCount:int;
      
      public var isAutomatic:Boolean;
      
      public var automaticTime:Date;
      
      public function FieldVO()
      {
         super();
      }
      
      public function get isGrow() : Boolean
      {
         return this.seedID != 0;
      }
      
      public function get realNeedTime() : int
      {
         var needTime:int = parseInt(ItemManager.Instance.getTemplateById(this.seedID).Property3);
         var grownTime:int = (TimeManager.Instance.Now().time - this.plantTime.time) / 60000 + this.AccelerateTime;
         return needTime - grownTime;
      }
      
      public function get plantGrownPhase() : int
      {
         if(!this.isGrow)
         {
            return -1;
         }
         var needTime:int = parseInt(ItemManager.Instance.getTemplateById(this.seedID).Property3);
         var grownTime:int = (TimeManager.Instance.Now().time - this.plantTime.time) / 60000 + this.AccelerateTime;
         if(this.seedID == 332100 && grownTime >= 1)
         {
            return 2;
         }
         if(grownTime < 60)
         {
            return 0;
         }
         if(grownTime < needTime)
         {
            return 1;
         }
         return 2;
      }
      
      public function get isDig() : Boolean
      {
         return this.fieldValidDate == -1 || (TimeManager.Instance.Now().time - this.payTime.time) / 3600000 <= this.fieldValidDate;
      }
   }
}

