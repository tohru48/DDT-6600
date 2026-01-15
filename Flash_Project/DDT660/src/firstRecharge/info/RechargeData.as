package firstRecharge.info
{
   public class RechargeData
   {
      
      public var ID:int;
      
      public var RewardID:int;
      
      public var RewardItemID:int;
      
      public var IsSelect:int;
      
      public var IsBind:Boolean;
      
      public var RewardItemValid:int = 0;
      
      public var RewardItemCount:int;
      
      public var StrengthenLevel:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var AgilityCompose:int;
      
      public var LuckCompose:int;
      
      public function RechargeData()
      {
         super();
      }
   }
}

