package activeEvents.data
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class ActiveEventsInfo
   {
      
      public static const COMMON:int = 0;
      
      public static const GOODS_EXCHANGE:int = 1;
      
      public static const PICC:int = 2;
      
      public static const SENIOR_PLAYER:int = 5;
      
      public var ActiveID:int;
      
      public var Title:String;
      
      public var isAttend:Boolean = false;
      
      public var Description:String;
      
      private var _StartDate:String;
      
      public var IsShow:Boolean;
      
      public var viewId:int;
      
      private var _start:Date;
      
      private var _EndDate:String;
      
      private var _end:Date;
      
      public var Content:String;
      
      public var AwardContent:String;
      
      public var IsAdvance:Boolean;
      
      public var Type:int;
      
      public var IsOnly:int;
      
      public var HasKey:int;
      
      public var ActiveType:int;
      
      public var IconID:int = 1;
      
      public var GoodsExchangeTypes:String;
      
      public var limitType:String;
      
      public var limitValue:String;
      
      public var GoodsExchangeNum:String;
      
      public var ActionTimeContent:String;
      
      public function ActiveEventsInfo()
      {
         super();
      }
      
      public function get StartDate() : String
      {
         return this._StartDate;
      }
      
      public function set StartDate(val:String) : void
      {
         this._StartDate = val;
         this._start = DateUtils.getDateByStr(this._StartDate);
      }
      
      public function get start() : Date
      {
         return this._start;
      }
      
      public function get EndDate() : String
      {
         return this._EndDate;
      }
      
      public function set EndDate(val:String) : void
      {
         this._EndDate = val;
         this._end = DateUtils.getDateByStr(this._EndDate);
      }
      
      public function get end() : Date
      {
         return this._end;
      }
      
      public function activeTime() : String
      {
         var result:String = null;
         var begin:Date = null;
         var end:Date = null;
         if(Boolean(this.ActionTimeContent))
         {
            result = this.ActionTimeContent;
         }
         else if(Boolean(this.EndDate))
         {
            begin = DateUtils.getDateByStr(this.StartDate);
            end = DateUtils.getDateByStr(this.EndDate);
            result = this.getActiveString(begin) + "-" + this.getActiveString(end);
         }
         else
         {
            result = LanguageMgr.GetTranslation("tank.data.MovementInfo.begin",this.getActiveString(begin));
         }
         return result;
      }
      
      private function getActiveString(date:Date) : String
      {
         return LanguageMgr.GetTranslation("tank.data.MovementInfo.date",this.addZero(date.getFullYear()),this.addZero(date.getMonth() + 1),this.addZero(date.getDate()));
      }
      
      private function addZero(value:Number) : String
      {
         var result:String = null;
         if(value < 10)
         {
            result = "0" + value.toString();
         }
         else
         {
            result = value.toString();
         }
         return result;
      }
      
      public function overdue() : Boolean
      {
         var end:Date = null;
         var now:Date = TimeManager.Instance.Now();
         var time:Number = now.time;
         var begin:Date = DateUtils.getDateByStr(this.StartDate);
         if(time < begin.getTime())
         {
            return true;
         }
         if(Boolean(this.EndDate))
         {
            end = DateUtils.getDateByStr(this.EndDate);
            if(time > end.getTime())
            {
               return true;
            }
         }
         return false;
      }
   }
}

