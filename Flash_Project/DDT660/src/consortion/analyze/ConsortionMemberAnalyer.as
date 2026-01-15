package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import consortion.ConsortionModelControl;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class ConsortionMemberAnalyer extends DataAnalyzer
   {
      
      public var consortionMember:DictionaryData;
      
      public function ConsortionMemberAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortiaPlayerInfo = null;
         var statePlayerState:PlayerState = null;
         var xml:XML = new XML(data);
         this.consortionMember = new DictionaryData();
         if(xml.@value == "true")
         {
            ConsortionModelControl.Instance.model.systemDate = XML(xml).@currentDate;
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortiaPlayerInfo();
               info.beginChanges();
               info.IsVote = this.converBoolean(xmllist[i].@IsVote);
               info.privateID = xmllist[i].@ID;
               info.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
               info.ConsortiaName = PlayerManager.Instance.Self.ConsortiaName;
               info.DutyID = xmllist[i].@DutyID;
               info.DutyName = xmllist[i].@DutyName;
               info.GP = xmllist[i].@GP;
               info.Grade = xmllist[i].@Grade;
               info.FightPower = xmllist[i].@FightPower;
               info.AchievementPoint = xmllist[i].@AchievementPoint;
               info.honor = xmllist[i].@Rank;
               info.IsChat = this.converBoolean(xmllist[i].@IsChat);
               info.IsDiplomatism = this.converBoolean(xmllist[i].@IsDiplomatism);
               info.IsDownGrade = this.converBoolean(xmllist[i].@IsDownGrade);
               info.IsEditorDescription = this.converBoolean(xmllist[i].@IsEditorDescription);
               info.IsEditorPlacard = this.converBoolean(xmllist[i].@IsEditorPlacard);
               info.IsEditorUser = this.converBoolean(xmllist[i].@IsEditorUser);
               info.IsExpel = this.converBoolean(xmllist[i].@IsExpel);
               info.IsInvite = this.converBoolean(xmllist[i].@IsInvite);
               info.IsManageDuty = this.converBoolean(xmllist[i].@IsManageDuty);
               info.IsRatify = this.converBoolean(xmllist[i].@IsRatify);
               info.IsUpGrade = this.converBoolean(xmllist[i].@IsUpGrade);
               info.IsBandChat = this.converBoolean(xmllist[i].@IsBanChat);
               info.Offer = int(xmllist[i].@Offer);
               info.RatifierID = xmllist[i].@RatifierID;
               info.RatifierName = xmllist[i].@RatifierName;
               info.Remark = xmllist[i].@Remark;
               info.Repute = xmllist[i].@Repute;
               statePlayerState = new PlayerState(int(xmllist[i].@State));
               info.playerState = statePlayerState;
               info.LastDate = xmllist[i].@LastDate;
               info.ID = xmllist[i].@UserID;
               info.NickName = xmllist[i].@UserName;
               info.typeVIP = xmllist[i].@typeVIP;
               info.VIPLevel = xmllist[i].@VIPLevel;
               info.LoginName = xmllist[i].@LoginName;
               info.Sex = this.converBoolean(xmllist[i].@Sex);
               info.EscapeCount = xmllist[i].@EscapeCount;
               info.Right = xmllist[i].@Right;
               info.WinCount = xmllist[i].@WinCount;
               info.TotalCount = xmllist[i].@TotalCount;
               info.RichesOffer = xmllist[i].@RichesOffer;
               info.RichesRob = xmllist[i].@RichesRob;
               info.UseOffer = xmllist[i].@TotalRichesOffer;
               info.DutyLevel = xmllist[i].@DutyLevel;
               info.LastWeekRichesOffer = parseInt(xmllist[i].@LastWeekRichesOffer);
               info.isOld = int(xmllist[i].@OldPlayer) == 1;
               info.commitChanges();
               this.consortionMember.add(info.ID,info);
               if(info.ID == PlayerManager.Instance.Self.ID)
               {
                  PlayerManager.Instance.Self.ConsortiaID = info.ConsortiaID;
                  PlayerManager.Instance.Self.DutyLevel = info.DutyLevel;
                  PlayerManager.Instance.Self.DutyName = info.DutyName;
                  PlayerManager.Instance.Self.Right = info.Right;
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
      
      private function converBoolean(b:String) : Boolean
      {
         return b == "true" ? true : false;
      }
   }
}

