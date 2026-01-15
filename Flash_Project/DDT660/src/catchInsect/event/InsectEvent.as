package catchInsect.event
{
   import flash.events.Event;
   
   public class InsectEvent extends Event
   {
      
      public static const UPDATE_SELF_RANK_INFO:String = "update_self_rank_info";
      
      public static const UPDATE_MONSTER_STATE:String = "update_monster_state";
      
      public static const MONSTER_ACTIVE_START:String = "monster_active_start";
      
      public static const USE_PROP:String = "useProp";
      
      public var data:Object;
      
      public function InsectEvent(type:String, dat:Object = null)
      {
         this.data = dat;
         super(type);
      }
   }
}

