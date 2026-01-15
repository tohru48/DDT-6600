package fightFootballTime.events
{
   import flash.events.Event;
   
   public class FightFootballTimeEvent extends Event
   {
      
      public function FightFootballTimeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

