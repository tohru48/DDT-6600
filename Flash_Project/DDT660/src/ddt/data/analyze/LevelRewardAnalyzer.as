package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   import trainer.data.LevelRewardInfo;
   
   public class LevelRewardAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function LevelRewardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var level:int = 0;
         var rewardItems:Dictionary = null;
         var rewardItemList:XMLList = null;
         var i:XML = null;
         var rewardInfo:LevelRewardInfo = null;
         var xml:XML = XML(data);
         var rewards:XMLList = xml.reward;
         for each(item in rewards)
         {
            level = int(item.@level);
            rewardItems = new Dictionary();
            rewardItemList = item.rewardItem;
            for each(i in rewardItemList)
            {
               rewardInfo = new LevelRewardInfo();
               rewardInfo.sort = int(i.@sort);
               rewardInfo.title = String(i.@title);
               rewardInfo.content = String(i.@content);
               rewardInfo.girlItems = String(i.@items).split("|")[0].split(",");
               rewardInfo.boyItems = String(i.@items).split("|")[1].split(",");
               rewardItems[rewardInfo.sort] = rewardInfo;
            }
            this.list[level] = rewardItems;
         }
         onAnalyzeComplete();
      }
   }
}

