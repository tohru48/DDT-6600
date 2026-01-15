package christmas.model
{
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.manager.ChristmasManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   
   public class ChristmasModel extends EventDispatcher
   {
      
      public var isOpen:Boolean;
      
      public var isEnter:Boolean;
      
      public var beginTime:Date;
      
      public var endTime:Date;
      
      public var gameBeginTime:Date;
      
      public var gameEndTime:Date;
      
      public var count:int;
      
      public var exp:int = 0;
      
      public var totalExp:int = 10;
      
      public var awardState:int;
      
      public var packsNumber:int;
      
      public var packsLen:int;
      
      public var myGiftData:Vector.<ChristmasSystemItemsInfo>;
      
      public var isSelect:Boolean;
      
      public var snowPackNum:Array;
      
      public var lastPacks:int;
      
      public var money:int;
      
      public var snowPackNumber:int;
      
      public var maxSnowMenNumber:int = 2000;
      
      public var todayCount:int;
      
      public function ChristmasModel()
      {
         super();
      }
      
      public function get activityTime() : String
      {
         var minutes1:String = null;
         var minutes2:String = null;
         var dateString:String = "";
         this.beginTime = ChristmasManager.instance.model.beginTime;
         this.endTime = ChristmasManager.instance.model.endTime;
         if(Boolean(this.beginTime) && Boolean(this.endTime))
         {
            minutes1 = this.beginTime.minutes > 9 ? this.beginTime.minutes + "" : "0" + this.beginTime.minutes;
            minutes2 = this.endTime.minutes > 9 ? this.endTime.minutes + "" : "0" + this.endTime.minutes;
            dateString = this.beginTime.fullYear + "." + (this.beginTime.month + 1) + "." + this.beginTime.date + " - " + this.endTime.fullYear + "." + (this.endTime.month + 1) + "." + this.endTime.date;
         }
         return dateString;
      }
      
      public function serverTime() : Number
      {
         var dat:Date = TimeManager.Instance.Now();
         return dat.hours;
      }
   }
}

