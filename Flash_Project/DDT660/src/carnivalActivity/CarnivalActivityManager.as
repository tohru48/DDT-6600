package carnivalActivity
{
   import ddt.manager.TimeManager;
   
   public class CarnivalActivityManager
   {
      
      private static var _instance:CarnivalActivityManager;
      
      public var currentType:int;
      
      public var currentChildType:int;
      
      public var actBeginTime:Number;
      
      public var actEndTime:Number;
      
      public var getBeginTime:Number;
      
      public var getEndTime:Number;
      
      public var lastClickTime:int;
      
      public function CarnivalActivityManager()
      {
         super();
      }
      
      public static function get instance() : CarnivalActivityManager
      {
         if(!_instance)
         {
            _instance = new CarnivalActivityManager();
         }
         return _instance;
      }
      
      public function canGetAward() : Boolean
      {
         var time:Number = TimeManager.Instance.Now().time;
         if(time >= this.getBeginTime && time <= this.getEndTime)
         {
            return true;
         }
         return false;
      }
      
      public function rookieRankCanGetAward() : Boolean
      {
         var time:Number = TimeManager.Instance.Now().time;
         if(time >= this.actEndTime && time <= this.getEndTime)
         {
            return true;
         }
         return false;
      }
   }
}

