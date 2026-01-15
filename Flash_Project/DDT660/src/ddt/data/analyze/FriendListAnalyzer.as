package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import im.IMController;
   import im.info.CustomInfo;
   import road7th.data.DictionaryData;
   
   public class FriendListAnalyzer extends DataAnalyzer
   {
      
      public var customList:Vector.<CustomInfo>;
      
      public var friendlist:DictionaryData;
      
      public var blackList:DictionaryData;
      
      public function FriendListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var list:XMLList = null;
         var li:int = 0;
         var n:int = 0;
         var xmllist:XMLList = null;
         var i:int = 0;
         var customInfo:CustomInfo = null;
         var tempInfo:CustomInfo = null;
         var info:FriendListPlayer = null;
         var dateStr:String = null;
         var statePlayerState:PlayerState = null;
         var birthdayArr:Array = null;
         var xml:XML = new XML(data);
         this.friendlist = new DictionaryData();
         this.blackList = new DictionaryData();
         this.customList = new Vector.<CustomInfo>();
         if(xml.@value == "true")
         {
            list = xml..customList;
            for(li = 0; li < list.length(); li++)
            {
               if(list[li].@Name != "")
               {
                  customInfo = new CustomInfo();
                  ObjectUtils.copyPorpertiesByXML(customInfo,list[li]);
                  this.customList.push(customInfo);
               }
            }
            for(n = 0; n < this.customList.length; n++)
            {
               if(this.customList[n].ID == 1)
               {
                  tempInfo = this.customList[n];
                  this.customList.splice(n,1);
                  this.customList.push(tempInfo);
               }
            }
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               info.isOld = int(xmllist[i].@OldPlayer) == 1;
               dateStr = String(xmllist[i].@LastDate).replace(/-/g,"/");
               info.LastLoginDate = new Date(dateStr);
               if(info.Birthday != "Null")
               {
                  birthdayArr = info.Birthday.split(/-/g);
                  info.BirthdayDate = new Date();
                  info.BirthdayDate.fullYearUTC = Number(birthdayArr[0]);
                  info.BirthdayDate.monthUTC = Number(birthdayArr[1]) - 1;
                  info.BirthdayDate.dateUTC = Number(birthdayArr[2]);
               }
               statePlayerState = new PlayerState(int(xml.Item[i].@State));
               info.playerState = statePlayerState;
               info.apprenticeshipState = xml.Item[i].@ApprenticeshipState;
               if(info.Relation != 1)
               {
                  this.friendlist.add(info.ID,info);
               }
               else
               {
                  this.blackList.add(info.ID,info);
               }
            }
            if(PlayerManager.Instance.Self.IsFirst == 1 && PathManager.CommunityExist())
            {
               IMController.Instance.createConsortiaLoader();
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

