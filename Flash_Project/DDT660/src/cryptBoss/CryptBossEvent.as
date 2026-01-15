package cryptBoss
{
   import flash.events.Event;
   
   public class CryptBossEvent extends Event
   {
      
      public static const GET_BOSS_DATA:int = 1;
      
      public static const UPDATE_SINGLEBOSS_DATA:int = 2;
      
      public static const FIGHT:int = 3;
      
      public function CryptBossEvent(type:String, bubbles:Boolean, cancelable:Boolean)
      {
         super(type,bubbles,cancelable);
      }
   }
}

