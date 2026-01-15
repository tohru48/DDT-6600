package drgnBoatBuild.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class DrgnBoatFriendsAnalyzer extends DataAnalyzer
   {
      
      public var list:Array = [];
      
      public function DrgnBoatFriendsAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var friendStateInfo:DrgnBoatBuildCellInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml.Item;
         for each(item in items)
         {
            friendStateInfo = new DrgnBoatBuildCellInfo();
            friendStateInfo.id = item.@ID;
            friendStateInfo.stage = item.@Stage;
            friendStateInfo.progress = item.@Process;
            this.list.push(friendStateInfo);
         }
         onAnalyzeComplete();
      }
   }
}

