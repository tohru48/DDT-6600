package socialContact.friendBirthday
{
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import road7th.data.DictionaryData;
   
   public class FriendBirthdayManager
   {
      
      private static var _instance:FriendBirthdayManager;
      
      private const INTERVAL:int = 86400;
      
      private var _friendName:String;
      
      public function FriendBirthdayManager()
      {
         super();
      }
      
      public static function get Instance() : FriendBirthdayManager
      {
         if(_instance == null)
         {
            _instance = new FriendBirthdayManager();
         }
         return _instance;
      }
      
      public function findFriendBirthday() : void
      {
         var str:String = null;
         var friend:FriendListPlayer = null;
         var brithdayVec:Vector.<FriendListPlayer> = new Vector.<FriendListPlayer>();
         var dic:DictionaryData = PlayerManager.Instance.friendList;
         for(str in dic)
         {
            friend = dic[str] as FriendListPlayer;
            if(friend.BirthdayDate && this._countBrithday(friend.BirthdayDate) && this._countNameInShare(friend.NickName))
            {
               brithdayVec.push(friend);
               SharedManager.Instance.friendBrithdayName = SharedManager.Instance.friendBrithdayName + "," + friend.NickName;
               SharedManager.Instance.save();
            }
         }
         if(brithdayVec.length > 0)
         {
            this._sendMySelfEmail(brithdayVec);
         }
      }
      
      private function _countBrithday(date:Date) : Boolean
      {
         var nowDate:Date = new Date();
         var boo:Boolean = false;
         if(nowDate.monthUTC == date.monthUTC && date.dateUTC - nowDate.dateUTC <= 1 && date.dateUTC - nowDate.dateUTC > -1)
         {
            boo = true;
         }
         return boo;
      }
      
      private function _sendMySelfEmail(vec:Vector.<FriendListPlayer>) : void
      {
         SocketManager.Instance.out.sendWithBrithday(vec);
      }
      
      public function set friendName(str:String) : void
      {
         this._friendName = str;
      }
      
      public function get friendName() : String
      {
         return this._friendName;
      }
      
      private function _countNameInShare(str:String) : Boolean
      {
         var arr:Array = SharedManager.Instance.friendBrithdayName.split(/,/);
         for(var i:int = 0; i < arr.length; i++)
         {
            if(str == arr[i])
            {
               return false;
            }
         }
         return true;
      }
   }
}

