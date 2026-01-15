package consortion.data
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   
   public class ConsortionSkillInfo
   {
      
      public var id:int;
      
      public var type:int;
      
      public var descript:String;
      
      public var value:int;
      
      public var level:int;
      
      public var riches:int;
      
      public var name:String;
      
      public var pic:int;
      
      public var group:int;
      
      public var metal:int;
      
      public var isOpen:Boolean;
      
      public var beginDate:Date;
      
      public var validDate:int;
      
      public function ConsortionSkillInfo()
      {
         super();
      }
      
      public function get validity() : String
      {
         var days:int = TimeManager.Instance.TotalDaysToNow(this.beginDate);
         var valid:int = this.validDate - days;
         if(valid <= 1)
         {
            valid = this.validDate * 24 - TimeManager.Instance.TotalHoursToNow(this.beginDate);
            if(valid < 1)
            {
               return int(this.validDate * 24 * 60 - TimeManager.Instance.TotalMinuteToNow(this.beginDate)) + LanguageMgr.GetTranslation("minute");
            }
            return int(this.validDate * 24 - TimeManager.Instance.TotalHoursToNow(this.beginDate)) + LanguageMgr.GetTranslation("hours");
         }
         return valid + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
      }
   }
}

