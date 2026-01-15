package dayActivity.data
{
   import com.pickgliss.utils.StringUtils;
   
   public class DayActiveData
   {
      
      public var ID:int;
      
      public var ActiveName:String;
      
      public var ActiveTime:String;
      
      public var Count:int;
      
      public var TotalCount:int;
      
      public var Description:String;
      
      public var JumpType:String;
      
      public var LevelLimit:String;
      
      public var ActivityTypeID:int;
      
      public var DayOfWeek:String;
      
      public function DayActiveData()
      {
         super();
      }
      
      public function setLong() : void
      {
         this.ActiveName = StringUtils.trim(this.ActiveName);
         this.ActiveTime = StringUtils.trim(this.ActiveTime);
         this.Description = StringUtils.trim(this.Description);
      }
   }
}

