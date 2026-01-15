package guildMemberWeek.controller
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import road7th.comm.PackageIn;
   
   public class GuildMemberWeekController
   {
      
      private static var _instance:GuildMemberWeekController;
      
      public function GuildMemberWeekController(pct:PrivateClass)
      {
         super();
         if(pct == null)
         {
            throw new Error("错误：GuildMemberWeekController类属于单例，请使用本类的istance获取实例");
         }
         this.initEvent();
      }
      
      public static function get instance() : GuildMemberWeekController
      {
         if(!_instance)
         {
            _instance = new GuildMemberWeekController(new PrivateClass());
         }
         return _instance;
      }
      
      public function initEvent() : void
      {
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_FINISHACTIVITY,this.__ShowFinishFrame);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING,this.__ShowRankingFrame);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,this.__UpMyRanking);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,this.__UpTop10Data);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,this.__UpAddPointBook);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,this._UpAddPointRecord);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_UPADDPOINTBOOK,this._UpImmediatelyRecord);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,this.__activityEndShowRanking);
      }
      
      public function removeEvent() : void
      {
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_FINISHACTIVITY,this.__ShowFinishFrame);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING,this.__ShowRankingFrame);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,this.__UpMyRanking);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,this.__UpTop10Data);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,this.__UpAddPointBook);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,this._UpAddPointRecord);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,this.__activityEndShowRanking);
      }
      
      private function __ShowFinishFrame(event:CrazyTankSocketEvent) : void
      {
         GuildMemberWeekManager.instance.LoadAndOpenShowTop10PromptFrame();
      }
      
      private function __ShowRankingFrame(event:CrazyTankSocketEvent) : void
      {
         GuildMemberWeekManager.instance.LoadAndOpenGuildMemberWeekFinishActivity();
      }
      
      private function __UpTop10Data(event:CrazyTankSocketEvent) : void
      {
         var PlayerID:int = 0;
         var PlayerName:String = null;
         var PlayerRanking:int = 0;
         var PlayeroCntribute:int = 0;
         var pkg:PackageIn = event.pkg;
         var upTime:String = pkg.readUTF();
         GuildMemberWeekManager.instance.model.upData = upTime;
         var count:int = pkg.readInt();
         if(Boolean(GuildMemberWeekManager.instance.model))
         {
            GuildMemberWeekManager.instance.model.TopTenMemberData.splice(0);
         }
         if(Boolean(GuildMemberWeekManager.instance.MainFrame))
         {
            GuildMemberWeekManager.instance.MainFrame.upDataTimeTxt();
         }
         for(var i:int = 0; i < count; i++)
         {
            PlayerID = pkg.readInt();
            PlayerName = pkg.readUTF();
            PlayerRanking = pkg.readInt();
            PlayeroCntribute = pkg.readInt();
            GuildMemberWeekManager.instance.model.TopTenMemberData.push([PlayerID,PlayerName,PlayerRanking,PlayeroCntribute]);
         }
         this.UpTop10Data("Member");
      }
      
      private function __UpAddPointBook(event:CrazyTankSocketEvent) : void
      {
         var AddPointBook:int = 0;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         GuildMemberWeekManager.instance.model.TopTenAddPointBook.splice(0);
         for(var i:int = 0; i < count; i++)
         {
            AddPointBook = pkg.readInt();
            GuildMemberWeekManager.instance.model.TopTenAddPointBook.push(AddPointBook);
         }
         this.UpTop10Data("PointBook");
      }
      
      private function __activityEndShowRanking(event:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var playerID:int = 0;
         var playerName:String = null;
         var playerRanking:int = 0;
         var playerCntribute:int = 0;
         var addPointBook:int = 0;
         GuildMemberWeekManager.instance.model.TopTenMemberData.splice(0);
         GuildMemberWeekManager.instance.model.TopTenAddPointBook.splice(0);
         var getRanking:Boolean = false;
         var i:int = 0;
         var pkg:PackageIn = event.pkg;
         var upTime:String = pkg.readUTF();
         GuildMemberWeekManager.instance.model.upData = upTime;
         if(Boolean(GuildMemberWeekManager.instance.MainFrame))
         {
            GuildMemberWeekManager.instance.MainFrame.upDataTimeTxt();
         }
         count = pkg.readInt();
         for(i = 0; i < count; i++)
         {
            playerID = pkg.readInt();
            playerName = pkg.readUTF();
            playerRanking = pkg.readInt();
            playerCntribute = pkg.readInt();
            GuildMemberWeekManager.instance.model.TopTenMemberData.push([playerID,playerName,playerRanking,playerCntribute]);
            if(PlayerManager.Instance.Self.ID == playerID)
            {
               getRanking = true;
            }
         }
         count = pkg.readInt();
         for(i = 0; i < count; i++)
         {
            addPointBook = pkg.readInt();
            GuildMemberWeekManager.instance.model.TopTenAddPointBook.push(addPointBook);
         }
         GuildMemberWeekManager.instance.model.MyRanking = pkg.readInt();
         GuildMemberWeekManager.instance.model.MyContribute = pkg.readInt();
         this.UpTop10Data("Member");
         this.UpTop10Data("PointBook");
         this.UpTop10Data("Gift");
         if(Boolean(GuildMemberWeekManager.instance.MainFrame))
         {
            GuildMemberWeekManager.instance.MainFrame.UpMyRanking();
         }
         if(Boolean(GuildMemberWeekManager.instance.FinishActivityFrame))
         {
            GuildMemberWeekManager.instance.FinishActivityFrame.UpMyRanking();
         }
         if(getRanking)
         {
            if(GuildMemberWeekManager.instance.model.MyRanking <= 0 || GuildMemberWeekManager.instance.model.MyRanking > 10)
            {
               getRanking = false;
            }
         }
         GuildMemberWeekManager.instance.CheckShowEndFrame(getRanking);
      }
      
      public function _UpAddPointRecord(event:CrazyTankSocketEvent) : void
      {
         var Record:String = null;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            Record = pkg.readUTF();
            GuildMemberWeekManager.instance.model.AddRanking.push(Record);
         }
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpRecord();
         }
      }
      
      public function _UpImmediatelyRecord(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var Ranking:int = pkg.readInt() - 1;
         var Money:int = pkg.readInt();
         var Record:String = pkg.readUTF();
         GuildMemberWeekManager.instance.model.TopTenAddPointBook[Ranking] += Money;
         GuildMemberWeekManager.instance.model.AddRanking.push(Record);
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpRecord();
            this.UpTop10Data("PointBook");
         }
      }
      
      public function __UpMyRanking(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         GuildMemberWeekManager.instance.model.MyRanking = pkg.readInt();
         GuildMemberWeekManager.instance.model.MyContribute = pkg.readInt();
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpMyRanking();
         }
         if(GuildMemberWeekManager.instance.FinishActivityFrame != null)
         {
            GuildMemberWeekManager.instance.FinishActivityFrame.UpMyRanking();
         }
      }
      
      private function UpTop10Data(UpType:String) : void
      {
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            if(GuildMemberWeekManager.instance.MainFrame.TopTenShowSprite != null)
            {
               GuildMemberWeekManager.instance.MainFrame.TopTenShowSprite.UpTop10data(UpType);
            }
         }
      }
      
      public function CheckAddBookIsOK() : void
      {
         var Type:Boolean = true;
         var HavePointBook:Boolean = false;
         var i:int = 0;
         var TAddPointBook:int = 0;
         var L:int = int(GuildMemberWeekManager.instance.model.PlayerAddPointBook.length);
         var TAddRankingArray:Array = new Array();
         for(i = 0; i < L; i++)
         {
            TAddPointBook = int(GuildMemberWeekManager.instance.model.PlayerAddPointBook[i]);
            TAddRankingArray.push(TAddPointBook);
            if(TAddPointBook >= 10)
            {
               HavePointBook = true;
            }
            else if(TAddPointBook > 0 && TAddPointBook < 10)
            {
               Type = false;
               break;
            }
         }
         if(Type)
         {
            if(HavePointBook)
            {
               SocketManager.Instance.out.sendGuildMemberWeekAddRanking(TAddRankingArray.concat());
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddOKPointBook"));
               GuildMemberWeekManager.instance.model.PlayerAddPointBook = [0,0,0,0,0,0,0,0,0,0];
               GuildMemberWeekManager.instance.CloseAddRankingFrame();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddNoPointBook"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddPointBookMustUp100"));
         }
      }
      
      public function upPointBookData(ItemID:int, Money:Number, ChangeMoneyShow:Boolean = true) : void
      {
         var i:int = ItemID - 1;
         var tax:Number = Money / 10;
         var GetMoney:int = 0;
         if(String(tax).indexOf(".") >= 0)
         {
            tax = Math.round(tax);
            GetMoney = Money - tax;
         }
         else
         {
            GetMoney = Money - int(tax);
         }
         GuildMemberWeekManager.instance.model.PlayerAddPointBook[i] = Money;
         GuildMemberWeekManager.instance.AddRankingFrame.ChangePointBookShow(ItemID,GetMoney);
         if(ChangeMoneyShow)
         {
            this.ChangePlayerMoney();
         }
      }
      
      public function ChangePlayerMoney() : void
      {
         var AddMoney:Number = 0;
         var L:int = int(GuildMemberWeekManager.instance.model.PlayerAddPointBook.length);
         var i:int = 0;
         var N:int = 0;
         for(i = 0; i < L; i++)
         {
            AddMoney += GuildMemberWeekManager.instance.model.PlayerAddPointBook[i];
         }
         if(AddMoney > PlayerManager.Instance.Self.Money)
         {
            for(i = 0; i < L; i++)
            {
               N = int(GuildMemberWeekManager.instance.model.PlayerAddPointBookBefor[i]);
               GuildMemberWeekManager.instance.model.PlayerAddPointBook[i] = N;
               this.upPointBookData(i + 1,N,false);
            }
         }
         else
         {
            AddMoney = PlayerManager.Instance.Self.Money - AddMoney;
            for(i = 0; i < L; i++)
            {
               N = int(GuildMemberWeekManager.instance.model.PlayerAddPointBook[i]);
               GuildMemberWeekManager.instance.model.PlayerAddPointBookBefor[i] = N;
            }
            GuildMemberWeekManager.instance.AddRankingFrame.ChangePlayerMoneyShow(AddMoney);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
