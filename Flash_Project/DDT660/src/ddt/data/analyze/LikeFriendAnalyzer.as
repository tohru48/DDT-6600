package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.LikeFriendInfo;
   
   public class LikeFriendAnalyzer extends DataAnalyzer
   {
      
      public var likeFriendList:Array;
      
      public function LikeFriendAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var info:LikeFriendInfo = null;
         this.likeFriendList = new Array();
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml..Item;
         if(xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new LikeFriendInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               info.isOld = int(xmllist[i].@OldPlayer) == 1;
               this.likeFriendList.push(info);
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

