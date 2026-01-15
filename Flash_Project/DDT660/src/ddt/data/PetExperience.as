package ddt.data
{
   import ddt.data.analyze.PetExpericenceAnalyze;
   
   public class PetExperience
   {
      
      public static var expericence:Array;
      
      public static var MAX_LEVEL:int = 0;
      
      public function PetExperience()
      {
         super();
      }
      
      public static function setup(analyzer:PetExpericenceAnalyze) : void
      {
         expericence = analyzer.expericence;
         expericence.sort(Array.NUMERIC);
         MAX_LEVEL = analyzer.expericence.length;
      }
      
      public static function getExpMax(maxExp:int) : int
      {
         for(var i:int = 0; i < expericence.length; i++)
         {
            if(expericence[i] > maxExp)
            {
               return expericence[i];
            }
         }
         return expericence[i];
      }
      
      public static function getLevelByGP(gp:int) : int
      {
         for(var i:int = MAX_LEVEL - 1; i > -1; i--)
         {
            if(expericence[i] <= gp)
            {
               return i + 1;
            }
         }
         return 1;
      }
   }
}

