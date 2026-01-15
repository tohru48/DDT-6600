package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import road7th.data.DictionaryData;
   
   public class RecentContactsAnalyze extends DataAnalyzer
   {
      
      public var recentContacts:DictionaryData;
      
      public function RecentContactsAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:FriendListPlayer = null;
         var statePlayerState:PlayerState = null;
         var xml:XML = new XML(data);
         this.recentContacts = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               statePlayerState = new PlayerState(int(xml.Item[i].@State));
               info.playerState = statePlayerState;
               info.isOld = int(xmllist[i].@OldPlayer) == 1;
               this.recentContacts.add(info.ID,info);
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

