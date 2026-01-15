package guildMemberWeek.model
{
   import flash.events.EventDispatcher;
   
   public class GuildMemberWeekModel extends EventDispatcher
   {
      
      public var isOpen:Boolean;
      
      public var upData:String = "no record...";
      
      public var MyRanking:int = 10;
      
      public var MyContribute:int = 0;
      
      public var AddRanking:Array = new Array();
      
      public var TopTenMemberData:Array = new Array();
      
      public var TopTenGiftData:Array = new Array("7007,5,7010,5,7012,5,7006,5","7007,5,7010,5,7012,5,7006,4","7007,5,7010,5,7012,4,7006,4","7007,5,7010,4,7012,4,7006,4","7007,4,7010,4,7012,4,7006,4","7007,4,7010,4,7012,4,7006,3","7007,4,7010,4,7012,3,7006,3","7007,4,7010,3,7012,3,7006,3","7007,3,7010,3,7012,3,7006,3","7007,3,7010,3,7012,3,7006,2");
      
      public var TopTenAddPointBook:Array = new Array(0,0,0,0,0,0,0,0,0,0);
      
      public var PlayerAddPointBook:Array = new Array(0,0,0,0,0,0,0,0,0,0);
      
      public var PlayerAddPointBookBefor:Array = new Array(0,0,0,0,0,0,0,0,0,0);
      
      public var CanAddPointBook:Boolean = true;
      
      public var ActivityStartTime:String = "活动开始时间";
      
      public var ActivityEndTime:String = "活动结束时间";
      
      public var items:Array;
      
      public function GuildMemberWeekModel()
      {
         super();
      }
   }
}

