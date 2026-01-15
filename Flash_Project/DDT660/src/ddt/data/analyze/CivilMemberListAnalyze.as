package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   
   public class CivilMemberListAnalyze extends DataAnalyzer
   {
      
      public static const PATH:String = "MarryInfoPageList.ashx";
      
      public var civilMemberList:Array;
      
      public var _page:int;
      
      public var _name:String;
      
      public var _sex:Boolean;
      
      public var _totalPage:int;
      
      public function CivilMemberListAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var player:PlayerInfo = null;
         var civilPlayer:CivilPlayerInfo = null;
         this.civilMemberList = [];
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Info;
            for(i = 0; i < xmllist.length(); i++)
            {
               player = new PlayerInfo();
               player.beginChanges();
               player.ID = xmllist[i].@UserID;
               player.NickName = xmllist[i].@NickName;
               player.ConsortiaID = xmllist[i].@ConsortiaID;
               player.ConsortiaName = xmllist[i].@ConsortiaName;
               player.Sex = this.converBoolean(xmllist[i].@Sex);
               player.WinCount = xmllist[i].@Win;
               player.TotalCount = xmllist[i].@Total;
               player.EscapeCount = xmllist[i].@Escape;
               player.GP = xmllist[i].@GP;
               player.Style = xmllist[i].@Style;
               player.Colors = xmllist[i].@Colors;
               player.Hide = xmllist[i].@Hide;
               player.Grade = xmllist[i].@Grade;
               player.playerState = new PlayerState(int(xmllist[i].@State));
               player.Repute = xmllist[i].@Repute;
               player.Skin = xmllist[i].@Skin;
               player.Offer = xmllist[i].@Offer;
               player.IsMarried = this.converBoolean(xmllist[i].@IsMarried);
               player.Nimbus = int(xmllist[i].@Nimbus);
               player.DutyName = xmllist[i].@DutyName;
               player.FightPower = xmllist[i].@FightPower;
               player.AchievementPoint = xmllist[i].@AchievementPoint;
               player.honor = xmllist[i].@Rank;
               player.typeVIP = xmllist[i].@typeVIP;
               player.VIPLevel = xmllist[i].@VIPLevel;
               player.isOld = int(xmllist[i].@OldPlayer) == 1;
               civilPlayer = new CivilPlayerInfo();
               civilPlayer.UserId = player.ID;
               civilPlayer.MarryInfoID = xmllist[i].@ID;
               civilPlayer.IsPublishEquip = this.converBoolean(xmllist[i].@IsPublishEquip);
               civilPlayer.Introduction = xmllist[i].@Introduction;
               civilPlayer.IsConsortia = this.converBoolean(xmllist[i].@IsConsortia);
               civilPlayer.info = player;
               this.civilMemberList.push(civilPlayer);
               player.commitChanges();
            }
            this._totalPage = Math.ceil(int(xml.@total) / 12);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function converBoolean(str:String) : Boolean
      {
         if(str == "true")
         {
            return true;
         }
         return false;
      }
   }
}

