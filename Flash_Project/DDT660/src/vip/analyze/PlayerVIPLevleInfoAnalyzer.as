package vip.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   import vip.data.VipModelInfo;
   
   public class PlayerVIPLevleInfoAnalyzer extends DataAnalyzer
   {
      
      public var info:VipModelInfo;
      
      public function PlayerVIPLevleInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = null;
         var levels:XMLList = null;
         var i:int = 0;
         var level:Dictionary = null;
         this.info = new VipModelInfo();
         xml = new XML(data);
         if(xml.@value == "true")
         {
            this.info.maxExp = xml.@maxExp;
            this.info.ExpForEachDay = xml.@ExpForEachDay;
            this.info.ExpDecreaseForEachDay = xml.@ExpDecreaseForEachDay;
            this.info.upRuleDescription = xml.@Description;
            this.info.RewardDescription = xml.@RewardInfo;
            levels = xml..Levels;
            for(i = 0; i < levels.length(); i++)
            {
               level = new Dictionary();
               level["level"] = levels[i].@Level;
               level["ExpNeeded"] = levels[i].@ExpNeeded;
               level["Description"] = levels[i].@Description;
               this.info.levelInfo[i] = level;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

