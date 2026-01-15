package ddt.manager
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.AddPublicInfo;
   import ddt.data.analyze.AddPublicTipDataAnalyzer;
   import flash.events.EventDispatcher;
   
   public class AddPublicTipManager extends EventDispatcher
   {
      
      private static var _instance:AddPublicTipManager;
      
      public static var DICESYS:int = 2;
      
      public static var CHICKEN:int = 1;
      
      public static var MIGONG:int = 9;
      
      public static var XINGYUNXING:int = 13;
      
      public static var JINZITA:int = 8;
      
      public static var SHENMILUNPAN:int = 31;
      
      public var addPublicTipData:Array;
      
      public var type:int = 0;
      
      public function AddPublicTipManager()
      {
         super();
      }
      
      public static function get Instance() : AddPublicTipManager
      {
         if(_instance == null)
         {
            _instance = new AddPublicTipManager();
         }
         return _instance;
      }
      
      public function getAddPublicTipInfoByID(id:int, type:int) : AddPublicInfo
      {
         var info:AddPublicInfo = null;
         if(this.addPublicTipData == null)
         {
            return null;
         }
         for(var i:int = 0; i < this.addPublicTipData.length; i++)
         {
            info = this.addPublicTipData[i];
            if(info.templateID == id && info.activityType == type)
            {
               return info;
            }
         }
         return null;
      }
      
      public function templateDataSetup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is AddPublicTipDataAnalyzer)
         {
            this.addPublicTipData = AddPublicTipDataAnalyzer(analyzer).list;
         }
      }
   }
}

