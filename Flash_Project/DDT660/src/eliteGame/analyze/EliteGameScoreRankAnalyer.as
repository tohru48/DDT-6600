package eliteGame.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameScroeRankInfo;
   
   public class EliteGameScoreRankAnalyer extends DataAnalyzer
   {
      
      public var scoreRankInfo:EliteGameAllScoreRankInfo;
      
      public function EliteGameScoreRankAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemSet:XMLList = null;
         var i:int = 0;
         var items:XMLList = null;
         var infos:Vector.<EliteGameScroeRankInfo> = null;
         var j:int = 0;
         var info:EliteGameScroeRankInfo = null;
         this.scoreRankInfo = new EliteGameAllScoreRankInfo();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.scoreRankInfo.lassUpdateTime = xml.@lastUpdateTime;
            itemSet = xml.ItemSet;
            for(i = 0; i < itemSet.length(); i++)
            {
               items = itemSet[i].Item;
               infos = new Vector.<EliteGameScroeRankInfo>();
               for(j = 0; j < items.length(); j++)
               {
                  info = new EliteGameScroeRankInfo();
                  info.nickName = items[j].@PlayerName;
                  info.rank = items[j].@PlayerRank;
                  info.scroe = items[j].@PlayerScore;
                  infos.push(info);
               }
               infos.sort(this.compare);
               if(itemSet[i].@value == "1")
               {
                  this.scoreRankInfo.rank30_40 = infos;
               }
               else
               {
                  this.scoreRankInfo.rank41_50 = infos;
               }
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
      
      private function compare(args1:EliteGameScroeRankInfo, args2:EliteGameScroeRankInfo) : Number
      {
         return args1.rank > args2.rank ? 1 : (args1.rank == args2.rank ? 0 : -1);
      }
   }
}

