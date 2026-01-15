package drgnBoatBuild.data
{
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   
   public class DrgnBoatBuildCellInfo
   {
      
      public var id:int;
      
      public var stage:int;
      
      public var progress:int;
      
      public function DrgnBoatBuildCellInfo()
      {
         super();
      }
      
      public function get playerinfo() : FriendListPlayer
      {
         return PlayerManager.Instance.friendList[this.id];
      }
      
      public function get canBuild() : Boolean
      {
         switch(this.stage)
         {
            case 1:
               return this.progress >= 0 && this.progress < 330;
            case 2:
               return this.progress >= 330 && this.progress < 660;
            case 3:
               return this.progress >= 660 && this.progress < 990;
            default:
               return false;
         }
      }
   }
}

