package game.motions
{
   import road7th.data.DictionaryData;
   
   public class ScreenMotionManager
   {
      
      private var _motions:DictionaryData;
      
      public function ScreenMotionManager()
      {
         super();
      }
      
      public function addMotion(motion:BaseMotionFunc) : void
      {
      }
      
      public function removeMotion(motion:BaseMotionFunc) : void
      {
      }
      
      public function execute() : void
      {
         var motion:BaseMotionFunc = null;
         for each(motion in this._motions)
         {
            motion.getResult();
         }
      }
   }
}

