package catchInsect.model
{
   import ddt.manager.ServerConfigManager;
   
   public class CatchInsectModel
   {
      
      public var isOpen:Boolean;
      
      public var isEnter:Boolean;
      
      public var beginDate:String;
      
      public var endDate:String;
      
      public var score:int;
      
      public var avaibleScore:int;
      
      public var prizeStatus:int;
      
      public function CatchInsectModel()
      {
         super();
      }
      
      public function get activityTime() : String
      {
         var dateString:String = "";
         this.beginDate = ServerConfigManager.instance.catchInsectBeginTime[0];
         this.endDate = ServerConfigManager.instance.catchInsectEndTime[0];
         if(Boolean(this.beginDate) && Boolean(this.endDate))
         {
            dateString = this.beginDate.replace(/-/g,".") + "-" + this.endDate.replace(/-/g,".");
         }
         return dateString;
      }
   }
}

