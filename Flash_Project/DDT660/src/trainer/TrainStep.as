package trainer
{
   import flash.utils.getDefinitionByName;
   
   public class TrainStep
   {
      
      private static const MAX_LEVEL:int = 15;
      
      public static const CLICK_WONDERFULACTIVITY:int = -1;
      
      public static var Step:* = getDefinitionByName("TrainerStep") as Class;
      
      public function TrainStep()
      {
         super();
      }
      
      public static function send(value:int) : void
      {
         if(Step)
         {
            Step.instance.sendOther(value);
         }
      }
      
      public static function get currentStep() : int
      {
         if(Step)
         {
            return Step.instance.currentStep;
         }
         return 0;
      }
   }
}

