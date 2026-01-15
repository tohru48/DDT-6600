package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import farm.modelx.FramFriendStateInfo;
   import farm.modelx.SimpleLandStateInfo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class FarmFriendListAnalyzer extends DataAnalyzer
   {
      
      public var list:DictionaryData = new DictionaryData();
      
      public function FarmFriendListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var friendStateInfo:FramFriendStateInfo = null;
         var landStateVec:Vector.<SimpleLandStateInfo> = null;
         var items2:XMLList = null;
         var item2:XML = null;
         var simpleLandStateInfo:SimpleLandStateInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml.Item;
         for each(item in items)
         {
            friendStateInfo = new FramFriendStateInfo();
            friendStateInfo.id = item.@UserID;
            friendStateInfo.isFeed = item.@isFeed == "true" ? true : false;
            landStateVec = new Vector.<SimpleLandStateInfo>();
            items2 = item.Item;
            for each(item2 in items2)
            {
               simpleLandStateInfo = new SimpleLandStateInfo();
               simpleLandStateInfo.seedId = item2.@SeedID;
               simpleLandStateInfo.AccelerateDate = item2.@AcclerateDate;
               simpleLandStateInfo.plantTime = DateUtils.decodeDated(item2.@GrowTime);
               simpleLandStateInfo.isStolen = item2.@IsCanStolen == "true" ? true : false;
               landStateVec.push(simpleLandStateInfo);
            }
            friendStateInfo.setLandStateVec = landStateVec;
            this.list.add(friendStateInfo.id,friendStateInfo);
         }
         onAnalyzeComplete();
      }
   }
}

