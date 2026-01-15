package treasureLost.events
{
   import flash.events.Event;
   
   public class TreasureLostEvents extends Event
   {
      
      public static const ROLEWALKEND:String = "roleWalkEnd";
      
      public static const SELECTGOLDDICEROLL:String = "selectGoldDiceRoll";
      
      public static const SELECTDIRECTION:String = "selectDirection";
      
      public static const PLAYER_ROLL_DICE:String = "player_roll_dice";
      
      public static const PLAYER_ROLL_GOLDDICE:String = "player_roll_golddice";
      
      public static const PLAYER_SELECT_CHADAO:String = "player_select_chadao";
      
      public static const PLAYER_EVENT_DISPATCH:String = "player_event_dispatch";
      
      public static const PLAYER_BUY_ITEM:String = "player_buy_item";
      
      public static const PLAYER_BUY_BALL:String = "player_buy_ball";
      
      public static const TreasureLostUpdata_Stone_Count:String = "treasureLostupdata_stone_count";
      
      public static const UpDate_FIVE_ITEM:String = "updata_five_item";
      
      public var data:Object;
      
      public function TreasureLostEvents(type:String, data:Object = null)
      {
         super(type);
         this.data = data;
      }
   }
}

