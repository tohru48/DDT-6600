package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   
   public class AcademyMemberListAnalyze extends DataAnalyzer
   {
      
      public var academyMemberList:Vector.<AcademyPlayerInfo>;
      
      public var totalPage:int;
      
      public var selfIsRegister:Boolean;
      
      public var selfDescribe:String;
      
      public var isAlter:Boolean;
      
      public var isSelfPublishEquip:Boolean;
      
      public function AcademyMemberListAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var player:PlayerInfo = null;
         var state:PlayerState = null;
         var academyPlayerInfo:AcademyPlayerInfo = null;
         var xml:XML = new XML(data);
         this.academyMemberList = new Vector.<AcademyPlayerInfo>();
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
               player.SpouseID = xmllist[i].@SpouseID;
               player.SpouseName = xmllist[i].@SpouseName;
               player.WeaponID = xmllist[i].@WeaponID;
               player.graduatesCount = xmllist[i].@GraduatesCount;
               player.honourOfMaster = xmllist[i].@HonourOfMaster;
               player.badgeID = xmllist[i].@BadgeID;
               player.isOld = int(xmllist[i].@OldPlayer) == 1;
               state = new PlayerState(xmllist[i].@State);
               player.playerState = state;
               academyPlayerInfo = new AcademyPlayerInfo();
               academyPlayerInfo.IsPublishEquip = this.converBoolean(xmllist[i].@IsPublishEquip);
               academyPlayerInfo.Introduction = xmllist[i].@Introduction;
               academyPlayerInfo.info = player;
               this.academyMemberList.push(academyPlayerInfo);
               player.commitChanges();
            }
            this.totalPage = Math.ceil(int(xml.@total) / 9);
            this.selfIsRegister = this.converBoolean(xml.@isPlayerRegeisted);
            if(xml.@isPlayerRegeisted == "")
            {
               this.isAlter = false;
            }
            else
            {
               this.isAlter = true;
            }
            this.selfDescribe = xml.@selfMessage;
            this.isSelfPublishEquip = this.converBoolean(xml.@isSelfPublishEquip);
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

