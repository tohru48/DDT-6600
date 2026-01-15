// Decompiled with JetBrains decompiler
// Type: Bussiness.AreaBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Text;

#nullable disable
namespace Bussiness
{
  public class AreaBussiness : IDisposable
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected Sql_DbObject db;
    private string string_0;
    private int int_0;

    public AreaBussiness(AreaConfigInfo config)
    {
      this.string_0 = "Area 1";
      this.int_0 = 1;
      StringBuilder stringBuilder = new StringBuilder();
      stringBuilder.Append("Data Source=");
      stringBuilder.Append(config.DataSource);
      stringBuilder.Append(";Initial Catalog=");
      stringBuilder.Append(config.Catalog);
      stringBuilder.Append(";Persist Security Info=True;User ID=");
      stringBuilder.Append(config.UserID);
      stringBuilder.Append(";Password=");
      stringBuilder.Append(config.Password);
      this.db = new Sql_DbObject("AreaConfig", stringBuilder.ToString());
      this.string_0 = config.AreaName;
      this.int_0 = config.AreaID;
    }

    public AreaBussiness()
    {
      this.string_0 = "Area 1";
      this.int_0 = 1;
      this.db = new Sql_DbObject("AppConfig", "areaDb");
    }

    public bool ExeSqlQuery(string sqlQuery)
    {
      bool flag = false;
      try
      {
        flag = this.db.Exesqlcomm(sqlQuery);
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "ExeSqlQuery: ", ex);
      }
      return flag;
    }

    public ActiveSystemInfo[] GetAllActiveSystemData()
    {
      List<ActiveSystemInfo> activeSystemInfoList = new List<ActiveSystemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      int num = 1;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ActiveSystem_All");
        while (ResultDataReader.Read())
        {
          activeSystemInfoList.Add(this.InitActiveSystemInfo(ResultDataReader));
          ++num;
        }
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "GetAllActiveSystem", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeSystemInfoList.ToArray();
    }

    public ActiveSystemInfo InitActiveSystemInfo(SqlDataReader dr)
    {
      return new ActiveSystemInfo()
      {
        ID = (int) dr["ID"],
        UserID = (int) dr["UserID"],
        useableScore = (int) dr["useableScore"],
        totalScore = (int) dr["totalScore"],
        AvailTime = (int) dr["AvailTime"],
        NickName = dr["NickName"] == null ? "" : dr["NickName"].ToString(),
        dayScore = (int) dr["dayScore"],
        CanGetGift = (bool) dr["CanGetGift"],
        canOpenCounts = (int) dr["canOpenCounts"],
        canEagleEyeCounts = (int) dr["canEagleEyeCounts"],
        lastFlushTime = (DateTime) dr["lastFlushTime"],
        isShowAll = (bool) dr["isShowAll"],
        ActiveMoney = (int) dr["AvtiveMoney"],
        activityTanabataNum = (int) dr["activityTanabataNum"],
        ChallengeNum = (int) dr["ChallengeNum"],
        BuyBuffNum = (int) dr["BuyBuffNum"],
        lastEnterYearMonter = (DateTime) dr["lastEnterYearMonter"],
        DamageNum = (int) dr["DamageNum"],
        BoxState = dr["BoxState"] == null ? "" : dr["BoxState"].ToString(),
        LuckystarCoins = (int) dr["LuckystarCoins"],
        CryptBoss = dr["CryptBoss"] == null ? "" : dr["CryptBoss"].ToString(),
        Int32_0 = (int) dr["DDPlayPoint"],
        lastEnterWorshiped = (DateTime) dr["lastEnterWorshiped"],
        updateFreeCounts = (int) dr["updateFreeCounts"],
        updateWorshipedCounts = (int) dr["updateWorshipedCounts"],
        update200State = (int) dr["update200State"],
        luckCount = (int) dr["luckCount"],
        remainTimes = (int) dr["remainTimes"]
      };
    }

    public AreaConfigInfo[] GetAllAreaConfig()
    {
      List<AreaConfigInfo> areaConfigInfoList = new List<AreaConfigInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_AreaConfig_All");
        while (ResultDataReader.Read())
          areaConfigInfoList.Add(this.InitAreaConfigInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "InitAreaConfigInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return areaConfigInfoList.ToArray();
    }

    public AreaConfigInfo InitAreaConfigInfo(SqlDataReader dr)
    {
      return new AreaConfigInfo()
      {
        AreaID = (int) dr["AreaID"],
        AreaServer = dr["AreaServer"] == null ? "" : dr["AreaServer"].ToString(),
        AreaName = dr["AreaName"] == null ? "" : dr["AreaName"].ToString(),
        DataSource = dr["DataSource"] == null ? "" : dr["DataSource"].ToString(),
        Catalog = dr["Catalog"] == null ? "" : dr["Catalog"].ToString(),
        UserID = dr["UserID"] == null ? "" : dr["UserID"].ToString(),
        Password = dr["Password"] == null ? "" : dr["Password"].ToString()
      };
    }

    public DataTable GetPage(
      string queryStr,
      string queryWhere,
      int pageCurrent,
      int pageSize,
      string fdShow,
      string fdOreder,
      string fdKey,
      ref int total)
    {
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[8]
        {
          new SqlParameter("@QueryStr", (object) queryStr),
          new SqlParameter("@QueryWhere", (object) queryWhere),
          new SqlParameter("@PageSize", (object) pageSize),
          new SqlParameter("@PageCurrent", (object) pageCurrent),
          new SqlParameter("@FdShow", (object) fdShow),
          new SqlParameter("@FdOrder", (object) fdOreder),
          new SqlParameter("@FdKey", (object) fdKey),
          new SqlParameter("@TotalRow", (object) total)
        };
        SqlParameters[7].Direction = ParameterDirection.Output;
        DataTable dataTable = this.db.GetDataTable(queryStr, "SP_CustomPage", SqlParameters, 120);
        total = (int) SqlParameters[7].Value;
        return dataTable;
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "Init", ex);
      }
      return new DataTable(queryStr);
    }

    public PlayerInfo[] GetPlayerPage(
      int page,
      int size,
      ref int total,
      int order,
      int userID,
      ref bool resultValue)
    {
      List<PlayerInfo> playerInfoList = new List<PlayerInfo>();
      try
      {
        string queryWhere = " IsExist=1 and IsFirst<> 0";
        if (userID != -1)
          queryWhere = queryWhere + " and UserID =" + (object) userID + " ";
        string str = "GP desc";
        switch (order)
        {
          case 1:
            str = "Offer desc";
            break;
          case 2:
            str = "AddDayGP desc";
            break;
          case 3:
            str = "AddWeekGP desc";
            break;
          case 4:
            str = "AddDayOffer desc";
            break;
          case 5:
            str = "AddWeekOffer desc";
            break;
          case 6:
            str = "FightPower desc";
            break;
          case 7:
            str = "AchievementPoint desc";
            break;
          case 8:
            str = "AddDayAchievementPoint desc";
            break;
          case 9:
            str = "AddWeekAchievementPoint desc";
            break;
          case 10:
            str = "GiftGp desc";
            break;
          case 11:
            str = "AddDayGiftGp desc";
            break;
          case 12:
            str = "AddWeekGiftGp desc";
            break;
          case 13:
            str = "totalPrestige desc";
            break;
          case 14:
            str = "curExp desc";
            break;
        }
        string fdOreder = str + ",UserID";
        foreach (DataRow row in (InternalDataCollectionBase) this.GetPage("V_Sys_Users_Detail", queryWhere, page, size, "*", fdOreder, "UserID", ref total).Rows)
        {
          PlayerInfo playerInfo = new PlayerInfo()
          {
            ZoneName = this.string_0,
            Agility = (int) row["Agility"],
            Attack = (int) row["Attack"],
            Colors = row["Colors"] == null ? "" : row["Colors"].ToString(),
            ConsortiaID = (int) row["ConsortiaID"],
            Defence = (int) row["Defence"],
            Gold = (int) row["Gold"],
            GP = (int) row["GP"],
            Grade = (int) row["Grade"],
            ID = (int) row["UserID"],
            Luck = (int) row["Luck"],
            Money = (int) row["Money"],
            NickName = row["NickName"] == null ? "" : row["NickName"].ToString(),
            Sex = (bool) row["Sex"],
            State = (int) row["State"],
            Style = row["Style"] == null ? "" : row["Style"].ToString(),
            Hide = (int) row["Hide"],
            Repute = (int) row["Repute"],
            UserName = row["UserName"] == null ? "" : row["UserName"].ToString(),
            ConsortiaName = row["ConsortiaName"] == null ? "" : row["ConsortiaName"].ToString(),
            Offer = (int) row["Offer"],
            Skin = row["Skin"] == null ? "" : row["Skin"].ToString(),
            IsBanChat = (bool) row["IsBanChat"],
            ReputeOffer = (int) row["ReputeOffer"],
            ConsortiaRepute = (int) row["ConsortiaRepute"],
            ConsortiaLevel = (int) row["ConsortiaLevel"],
            StoreLevel = (int) row["StoreLevel"],
            ShopLevel = (int) row["ShopLevel"],
            SmithLevel = (int) row["SmithLevel"],
            ConsortiaHonor = (int) row["ConsortiaHonor"],
            RichesOffer = (int) row["RichesOffer"],
            RichesRob = (int) row["RichesRob"],
            DutyLevel = (int) row["DutyLevel"],
            DutyName = row["DutyName"] == null ? "" : row["DutyName"].ToString(),
            Right = (int) row["Right"],
            ChairmanName = row["ChairmanName"] == null ? "" : row["ChairmanName"].ToString(),
            Win = (int) row["Win"],
            Total = (int) row["Total"],
            Escape = (int) row["Escape"]
          };
          playerInfo.AddDayGP = (int) row["AddDayGP"] == 0 ? playerInfo.GP : (int) row["AddDayGP"];
          playerInfo.AddDayOffer = (int) row["AddDayOffer"] == 0 ? playerInfo.Offer : (int) row["AddDayOffer"];
          playerInfo.AddWeekGP = (int) row["AddWeekGP"] == 0 ? playerInfo.GP : (int) row["AddWeekGP"];
          playerInfo.AddWeekOffer = (int) row["AddWeekOffer"] == 0 ? playerInfo.Offer : (int) row["AddWeekOffer"];
          playerInfo.ConsortiaRiches = (int) row["ConsortiaRiches"];
          playerInfo.CheckCount = (int) row["CheckCount"];
          playerInfo.Nimbus = (int) row["Nimbus"];
          playerInfo.DDTMoney = (int) row["GiftToken"];
          playerInfo.QuestSite = row["QuestSite"] == null ? new byte[200] : (byte[]) row["QuestSite"];
          playerInfo.PvePermission = row["PvePermission"] == null ? "" : row["PvePermission"].ToString();
          playerInfo.FightPower = (int) row["FightPower"];
          playerInfo.Honor = row["Honor"] == null ? "" : row["Honor"].ToString();
          playerInfo.GiftGp = (int) row["GiftGp"];
          playerInfo.GiftLevel = (int) row["GiftLevel"];
          playerInfo.AddWeekLeagueScore = (int) row["weeklyScore"];
          playerInfo.TotalPrestige = (int) row["totalPrestige"];
          playerInfo.MountExp = (int) row["curExp"];
          playerInfo.MountLv = (int) row["curLevel"];
          playerInfo.IsOldPlayer = (bool) row["IsOldPlayer"];
          playerInfoList.Add(playerInfo);
        }
        resultValue = true;
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "Init", ex);
      }
      return playerInfoList.ToArray();
    }

    public ConsortiaInfo[] GetConsortiaPage(
      int page,
      int size,
      ref int total,
      int order,
      string name,
      int consortiaID,
      int level,
      int openApply)
    {
      List<ConsortiaInfo> consortiaInfoList = new List<ConsortiaInfo>();
      try
      {
        string queryWhere = " IsExist=1";
        if (!string.IsNullOrEmpty(name))
          queryWhere = queryWhere + " and ConsortiaName like '%" + name + "%' ";
        if (consortiaID != -1)
          queryWhere = queryWhere + " and ConsortiaID =" + (object) consortiaID + " ";
        if (level != -1)
          queryWhere = queryWhere + " and Level =" + (object) level + " ";
        if (openApply != -1)
          queryWhere = queryWhere + " and OpenApply =" + (object) openApply + " ";
        string str = "ConsortiaName";
        switch (order)
        {
          case 1:
            str = "ReputeSort";
            break;
          case 2:
            str = "ChairmanName";
            break;
          case 3:
            str = "Count desc";
            break;
          case 4:
            str = "Level desc";
            break;
          case 5:
            str = "Honor desc";
            break;
          case 6:
            str = "Riches desc";
            break;
          case 10:
            str = "LastDayRiches desc";
            break;
          case 11:
            str = "AddDayRiches desc";
            break;
          case 12:
            str = "AddWeekRiches desc";
            break;
          case 13:
            str = "LastDayHonor desc";
            break;
          case 14:
            str = "AddDayHonor desc";
            break;
          case 15:
            str = "AddWeekHonor desc";
            break;
          case 16:
            str = "Level desc,LastDayRiches desc";
            break;
          case 17:
            str = "FightPower desc";
            break;
        }
        string fdOreder = str + ",ConsortiaID ";
        foreach (DataRow row in (InternalDataCollectionBase) this.GetPage("V_Consortia", queryWhere, page, size, "*", fdOreder, "ConsortiaID", ref total).Rows)
          consortiaInfoList.Add(new ConsortiaInfo()
          {
            ZoneID = this.int_0,
            ZoneName = this.string_0,
            ConsortiaID = (int) row["ConsortiaID"],
            BuildDate = (DateTime) row["BuildDate"],
            CelebCount = (int) row["CelebCount"],
            ChairmanID = (int) row["ChairmanID"],
            ChairmanName = row["ChairmanName"].ToString(),
            ChairmanTypeVIP = Convert.ToByte(row["typeVIP"]),
            ChairmanVIPLevel = (int) row["VIPLevel"],
            ConsortiaName = row["ConsortiaName"].ToString(),
            CreatorID = (int) row["CreatorID"],
            CreatorName = row["CreatorName"].ToString(),
            Description = row["Description"].ToString(),
            Honor = (int) row["Honor"],
            IsExist = (bool) row["IsExist"],
            Level = (int) row["Level"],
            MaxCount = (int) row["MaxCount"],
            Placard = row["Placard"].ToString(),
            IP = row["IP"].ToString(),
            Port = (int) row["Port"],
            FightPower = (int) row["FightPower"],
            Repute = (int) row["Repute"],
            Count = (int) row["Count"],
            Riches = (int) row["Riches"],
            DeductDate = (DateTime) row["DeductDate"],
            AddDayHonor = (int) row["AddDayHonor"],
            AddDayRiches = (int) row["AddDayRiches"],
            AddWeekHonor = (int) row["AddWeekHonor"],
            AddWeekRiches = (int) row["AddWeekRiches"],
            LastDayRiches = (int) row["LastDayRiches"],
            OpenApply = (bool) row["OpenApply"],
            StoreLevel = (int) row["StoreLevel"],
            SmithLevel = (int) row["SmithLevel"],
            ShopLevel = (int) row["ShopLevel"],
            SkillLevel = (int) row["SkillLevel"]
          });
      }
      catch (Exception ex)
      {
        if (AreaBussiness.ilog_0.IsErrorEnabled)
          AreaBussiness.ilog_0.Error((object) "Init", ex);
      }
      return consortiaInfoList.ToArray();
    }

    public void Dispose()
    {
      this.db.Dispose();
      GC.SuppressFinalize((object) this);
    }
  }
}
