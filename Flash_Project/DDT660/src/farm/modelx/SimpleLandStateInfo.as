package farm.modelx
{
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class SimpleLandStateInfo
   {
      
      public var id:int;
      
      public var seedId:int;
      
      public var AccelerateDate:int;
      
      public var plantTime:Date;
      
      public var isStolen:Boolean = false;
      
      public function SimpleLandStateInfo()
      {
         super();
      }
      
      public function get hasPlantGrown() : Boolean
      {
         var tempTime:int = 0;
         var realTime:int = 0;
         var grownTime:int = 0;
         if(this.seedId == 0)
         {
            return false;
         }
         tempTime = parseInt(ItemManager.Instance.getTemplateById(this.seedId).Property3);
         realTime = tempTime - this.AccelerateDate;
         grownTime = (TimeManager.Instance.Now().time - this.plantTime.time) / 60000;
         return grownTime >= realTime;
      }
   }
}

