package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.fightLib.FightLibAwardInfo;
   import ddt.data.fightLib.FightLibInfo;
   
   public class FightLibAwardAnalyzer extends DataAnalyzer
   {
      
      public var list:Array = [];
      
      public function FightLibAwardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var awardInfo:XML = null;
         var awardItem:Object = null;
         var tempList:Array = [];
         var infos:XMLList = XML(data).Item;
         for each(awardInfo in infos)
         {
            awardItem = new Object();
            awardItem.id = int(awardInfo.@ID);
            awardItem.diff = int(awardInfo.@Easy);
            awardItem.itemID = int(awardInfo.@AwardItem);
            awardItem.count = int(awardInfo.@Count);
            tempList.push(awardItem);
         }
         this.sortItems(tempList);
         onAnalyzeComplete();
      }
      
      private function sortItems(items:Array) : void
      {
         var item:Object = null;
         for each(item in items)
         {
            this.pushInListByIDAndDiff({
               "id":item.itemID,
               "count":item.count
            },item.id,item.diff);
         }
      }
      
      private function pushInListByIDAndDiff(item:Object, id:int, diff:int) : void
      {
         var awardInfo:FightLibAwardInfo = this.findAwardInfoByID(id);
         switch(diff)
         {
            case FightLibInfo.EASY:
               awardInfo.easyAward.push(item);
               break;
            case FightLibInfo.NORMAL:
               awardInfo.normalAward.push(item);
               break;
            case FightLibInfo.DIFFICULT:
               awardInfo.difficultAward.push(item);
         }
      }
      
      private function findAwardInfoByID(id:int) : FightLibAwardInfo
      {
         var result:FightLibAwardInfo = null;
         var len:int = int(this.list.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.list[i].id == id)
            {
               return this.list[i];
            }
         }
         if(result == null)
         {
            result = new FightLibAwardInfo();
            result.id = id;
            this.list.push(result);
         }
         return result;
      }
   }
}

