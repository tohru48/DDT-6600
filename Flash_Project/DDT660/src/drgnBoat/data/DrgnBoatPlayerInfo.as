package drgnBoat.data
{
   public class DrgnBoatPlayerInfo
   {
      
      public var zoneId:int;
      
      public var id:int;
      
      public var index:int;
      
      public var carType:int;
      
      public var name:String;
      
      public var level:int;
      
      public var vipType:int;
      
      public var vipLevel:int;
      
      public var isSelf:Boolean;
      
      public var acceleEndTime:Date = new Date(2000);
      
      public var deceleEndTime:Date = new Date(2000);
      
      public var invisiEndTime:Date = new Date(2000);
      
      public var missileHitEndTime:Date = new Date(2000);
      
      public var missileEndTime:Date = new Date(2000);
      
      public var missileLaunchEndTime:Date = new Date(2000);
      
      public var posX:int = 0;
      
      public var fightState:int;
      
      public function DrgnBoatPlayerInfo()
      {
         super();
      }
   }
}

