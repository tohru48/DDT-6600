package cityWide
{
   import ddt.data.player.PlayerInfo;
   import flash.events.Event;
   
   public class CityWideEvent extends Event
   {
      
      public static const ONS_PLAYERINFO:String = "ons_playerInfo";
      
      private var _playerInfo:PlayerInfo;
      
      public function CityWideEvent(type:String, info:PlayerInfo = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._playerInfo = info;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
   }
}

