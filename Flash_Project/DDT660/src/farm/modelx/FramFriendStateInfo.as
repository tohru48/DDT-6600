package farm.modelx
{
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   
   public class FramFriendStateInfo
   {
      
      public var id:int;
      
      public var landStateVec:Vector.<SimpleLandStateInfo>;
      
      private var _isFeed:Boolean;
      
      public function FramFriendStateInfo()
      {
         super();
         this.landStateVec = new Vector.<SimpleLandStateInfo>();
      }
      
      public function get playerinfo() : FriendListPlayer
      {
         return PlayerManager.Instance.friendList[this.id];
      }
      
      public function get hasGrownLand() : Boolean
      {
         for(var i:int = 0; i < this.landStateVec.length; i++)
         {
            if(this.landStateVec[i].hasPlantGrown)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get isStolen() : Boolean
      {
         var i:int = 0;
         if(this.hasGrownLand)
         {
            for(i = 0; i < this.landStateVec.length; i++)
            {
               if(this.landStateVec[i].isStolen)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function set isFeed(value:Boolean) : void
      {
         this._isFeed = value;
      }
      
      public function get isFeed() : Boolean
      {
         return this._isFeed;
      }
      
      public function set setLandStateVec(value:Vector.<SimpleLandStateInfo>) : void
      {
         this.landStateVec = value;
      }
   }
}

