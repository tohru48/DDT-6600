package campbattle.data
{
   public class RoleData
   {
      
      public var type:int;
      
      public var name:String;
      
      public var team:int;
      
      public var baseURl:String;
      
      public var posX:int;
      
      public var posY:int;
      
      public var zoneID:int;
      
      public var stateType:int;
      
      public var isCapture:Boolean;
      
      public var timerCount:int;
      
      public var isVip:Boolean;
      
      public var vipLev:int;
      
      public var isDead:Boolean;
      
      public var ID:int;
      
      public var Sex:Boolean;
      
      public var MountsType:int = 0;
      
      private var canRideMountsArr:Array = [1,2,3,4,5,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,120];
      
      private var specialMountsArr:Array = [4,5,6,7,8,9,103];
      
      public function RoleData()
      {
         super();
      }
      
      public function get IsMounts() : Boolean
      {
         return this.MountsType > 0;
      }
      
      public function getIsRide() : Boolean
      {
         return this.canRideMountsArr.indexOf(this.MountsType) != -1;
      }
      
      public function getIsSpecialRide() : Boolean
      {
         return this.specialMountsArr.indexOf(this.MountsType) != -1;
      }
   }
}

