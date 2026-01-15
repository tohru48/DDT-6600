// Decompiled with JetBrains decompiler
// Type: Bussiness.AreaPlayerBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Bussiness.Managers;
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
  public class AreaPlayerBussiness : IDisposable
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected Sql_DbObject db;
    private string string_0;
    private int int_0;

    public AreaPlayerBussiness(AreaConfigInfo config)
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

    public bool UpdateRenames(string data)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@Db_A", SqlDbType.NVarChar, 100)
        };
        SqlParameters[0].Value = (object) data;
        flag = this.db.RunProcedure("Sp_Renames_Batch", SqlParameters);
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init Sp_Renames_Batch", ex);
      }
      return flag;
    }

    public PlayerInfo GetUserSingleByUserID(int UserID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Users_SingleByUserID", SqlParameters);
        if (ResultDataReader.Read())
          return this.InitPlayerInfo(ResultDataReader);
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (PlayerInfo) null;
    }

    public PlayerInfo InitPlayerInfo(SqlDataReader reader)
    {
      PlayerInfo playerInfo1 = new PlayerInfo();
      playerInfo1.Password = (string) reader["Password"];
      playerInfo1.IsConsortia = (bool) reader["IsConsortia"];
      playerInfo1.Agility = (int) reader["Agility"];
      playerInfo1.Attack = (int) reader["Attack"];
      playerInfo1.hp = (int) reader["hp"];
      playerInfo1.Colors = reader["Colors"] == null ? "" : reader["Colors"].ToString();
      playerInfo1.ConsortiaID = (int) reader["ConsortiaID"];
      playerInfo1.Defence = (int) reader["Defence"];
      playerInfo1.Gold = (int) reader["Gold"];
      playerInfo1.GP = (int) reader["GP"];
      playerInfo1.Grade = (int) reader["Grade"];
      playerInfo1.ID = (int) reader["UserID"];
      playerInfo1.Luck = (int) reader["Luck"];
      playerInfo1.Money = (int) reader["Money"];
      playerInfo1.NickName = (string) reader["NickName"] == null ? "" : (string) reader["NickName"];
      playerInfo1.Sex = (bool) reader["Sex"];
      playerInfo1.State = (int) reader["State"];
      playerInfo1.Style = reader["Style"] == null ? "" : reader["Style"].ToString();
      playerInfo1.Hide = (int) reader["Hide"];
      playerInfo1.Repute = (int) reader["Repute"];
      playerInfo1.UserName = reader["UserName"] == null ? "" : reader["UserName"].ToString();
      playerInfo1.ConsortiaName = reader["ConsortiaName"] == null ? "" : reader["ConsortiaName"].ToString();
      playerInfo1.Offer = (int) reader["Offer"];
      playerInfo1.Win = (int) reader["Win"];
      playerInfo1.Total = (int) reader["Total"];
      playerInfo1.Escape = (int) reader["Escape"];
      playerInfo1.Skin = reader["Skin"] == null ? "" : reader["Skin"].ToString();
      playerInfo1.IsBanChat = (bool) reader["IsBanChat"];
      playerInfo1.ReputeOffer = (int) reader["ReputeOffer"];
      playerInfo1.ConsortiaRepute = (int) reader["ConsortiaRepute"];
      playerInfo1.ConsortiaLevel = (int) reader["ConsortiaLevel"];
      playerInfo1.StoreLevel = (int) reader["StoreLevel"];
      playerInfo1.ShopLevel = (int) reader["ShopLevel"];
      playerInfo1.SmithLevel = (int) reader["SmithLevel"];
      playerInfo1.ConsortiaHonor = (int) reader["ConsortiaHonor"];
      playerInfo1.RichesOffer = (int) reader["RichesOffer"];
      playerInfo1.RichesRob = (int) reader["RichesRob"];
      playerInfo1.AntiAddiction = (int) reader["AntiAddiction"];
      playerInfo1.DutyLevel = (int) reader["DutyLevel"];
      playerInfo1.DutyName = reader["DutyName"] == null ? "" : reader["DutyName"].ToString();
      playerInfo1.Right = (int) reader["Right"];
      playerInfo1.ChairmanName = reader["ChairmanName"] == null ? "" : reader["ChairmanName"].ToString();
      playerInfo1.AddDayGP = (int) reader["AddDayGP"];
      playerInfo1.AddDayOffer = (int) reader["AddDayOffer"];
      playerInfo1.AddWeekGP = (int) reader["AddWeekGP"];
      playerInfo1.AddWeekOffer = (int) reader["AddWeekOffer"];
      playerInfo1.ConsortiaRiches = (int) reader["ConsortiaRiches"];
      playerInfo1.CheckCount = (int) reader["CheckCount"];
      playerInfo1.IsMarried = (bool) reader["IsMarried"];
      playerInfo1.SpouseID = (int) reader["SpouseID"];
      playerInfo1.SpouseName = reader["SpouseName"] == null ? "" : reader["SpouseName"].ToString();
      playerInfo1.MarryInfoID = (int) reader["MarryInfoID"];
      playerInfo1.IsCreatedMarryRoom = (bool) reader["IsCreatedMarryRoom"];
      playerInfo1.DayLoginCount = (int) reader["DayLoginCount"];
      playerInfo1.PasswordTwo = reader["PasswordTwo"] == null ? "" : reader["PasswordTwo"].ToString();
      playerInfo1.SelfMarryRoomID = (int) reader["SelfMarryRoomID"];
      playerInfo1.IsGotRing = (bool) reader["IsGotRing"];
      playerInfo1.Rename = (bool) reader["Rename"];
      playerInfo1.ConsortiaRename = (bool) reader["ConsortiaRename"];
      playerInfo1.IsDirty = false;
      playerInfo1.IsFirst = (int) reader["IsFirst"];
      playerInfo1.Nimbus = (int) reader["Nimbus"];
      playerInfo1.LastAward = (DateTime) reader["LastAward"];
      playerInfo1.DDTMoney = (int) reader["GiftToken"];
      playerInfo1.QuestSite = reader["QuestSite"] == null ? new byte[200] : (byte[]) reader["QuestSite"];
      playerInfo1.PvePermission = reader["PvePermission"] == null ? "" : reader["PvePermission"].ToString();
      playerInfo1.FightPower = (int) reader["FightPower"];
      playerInfo1.PasswordQuest1 = reader["PasswordQuestion1"] == null ? "" : reader["PasswordQuestion1"].ToString();
      playerInfo1.PasswordQuest2 = reader["PasswordQuestion2"] == null ? "" : reader["PasswordQuestion2"].ToString();
      PlayerInfo playerInfo2 = playerInfo1;
      DateTime dateTime = (DateTime) reader["LastFindDate"];
      playerInfo2.FailedPasswordAttemptCount = (int) reader["FailedPasswordAttemptCount"];
      playerInfo1.AnswerSite = (int) reader["AnswerSite"];
      playerInfo1.medal = (int) reader["Medal"];
      playerInfo1.ChatCount = (int) reader["ChatCount"];
      playerInfo1.SpaPubGoldRoomLimit = (int) reader["SpaPubGoldRoomLimit"];
      playerInfo1.LastSpaDate = (DateTime) reader["LastSpaDate"];
      playerInfo1.FightLabPermission = (string) reader["FightLabPermission"];
      playerInfo1.SpaPubMoneyRoomLimit = (int) reader["SpaPubMoneyRoomLimit"];
      playerInfo1.IsInSpaPubGoldToday = (bool) reader["IsInSpaPubGoldToday"];
      playerInfo1.IsInSpaPubMoneyToday = (bool) reader["IsInSpaPubMoneyToday"];
      playerInfo1.AchievementPoint = (int) reader["AchievementPoint"];
      playerInfo1.LastWeekly = (DateTime) reader["LastWeekly"];
      playerInfo1.LastWeeklyVersion = (int) reader["LastWeeklyVersion"];
      playerInfo1.GiftGp = (int) reader["GiftGp"];
      playerInfo1.GiftLevel = (int) reader["GiftLevel"];
      playerInfo1.IsOpenGift = (bool) reader["IsOpenGift"];
      playerInfo1.badgeID = (int) reader["badgeID"];
      playerInfo1.typeVIP = Convert.ToByte(reader["typeVIP"]);
      playerInfo1.VIPLevel = (int) reader["VIPLevel"];
      playerInfo1.VIPExp = (int) reader["VIPExp"];
      playerInfo1.VIPExpireDay = (DateTime) reader["VIPExpireDay"];
      playerInfo1.LastVIPPackTime = (DateTime) reader["LastVIPPackTime"];
      playerInfo1.CanTakeVipReward = (bool) reader["CanTakeVipReward"];
      playerInfo1.WeaklessGuildProgressStr = (string) reader["WeaklessGuildProgressStr"];
      playerInfo1.IsOldPlayer = (bool) reader["IsOldPlayer"];
      playerInfo1.LastDate = (DateTime) reader["LastDate"];
      playerInfo1.DateTime_0 = (DateTime) reader["VIPLastDate"];
      playerInfo1.Score = (int) reader["Score"];
      playerInfo1.OptionOnOff = (int) reader["OptionOnOff"];
      playerInfo1.isOldPlayerHasValidEquitAtLogin = (bool) reader["isOldPlayerHasValidEquitAtLogin"];
      playerInfo1.badLuckNumber = (int) reader["badLuckNumber"];
      playerInfo1.luckyNum = (int) reader["luckyNum"];
      playerInfo1.lastLuckyNumDate = (DateTime) reader["lastLuckyNumDate"];
      playerInfo1.lastLuckNum = (int) reader["lastLuckNum"];
      playerInfo1.CardSoul = (int) reader["CardSoul"];
      playerInfo1.uesedFinishTime = (int) reader["uesedFinishTime"];
      playerInfo1.totemId = (int) reader["totemId"];
      playerInfo1.damageScores = (int) reader["damageScores"];
      playerInfo1.petScore = (int) reader["petScore"];
      playerInfo1.IsShowConsortia = (bool) reader["IsShowConsortia"];
      playerInfo1.LastRefreshPet = (DateTime) reader["LastRefreshPet"];
      playerInfo1.GetSoulCount = (int) reader["GetSoulCount"];
      playerInfo1.isFirstDivorce = (int) reader["isFirstDivorce"];
      playerInfo1.myScore = (int) reader["myScore"];
      playerInfo1.LastGetEgg = (DateTime) reader["LastGetEgg"];
      playerInfo1.TimeBox = (DateTime) reader["TimeBox"];
      playerInfo1.IsFistGetPet = (bool) reader["IsFistGetPet"];
      playerInfo1.myHonor = (int) reader["myHonor"];
      playerInfo1.hardCurrency = (int) reader["hardCurrency"];
      playerInfo1.MaxBuyHonor = (int) reader["MaxBuyHonor"];
      playerInfo1.LeagueMoney = (int) reader["LeagueMoney"];
      playerInfo1.Honor = (string) reader["Honor"];
      playerInfo1.necklaceExp = (int) reader["necklaceExp"];
      playerInfo1.necklaceExpAdd = (int) reader["necklaceExpAdd"];
      playerInfo1.accumulativeLoginDays = (int) reader["accumulativeLoginDays"];
      playerInfo1.accumulativeAwardDays = (int) reader["accumulativeAwardDays"];
      playerInfo1.MountsType = (int) reader["MountsType"];
      playerInfo1.PveEpicPermission = (string) reader["PveEpicPermission"];
      playerInfo1.evolutionGrade = (int) reader["evolutionGrade"];
      playerInfo1.evolutionExp = (int) reader["evolutionExp"];
      playerInfo1.MagicAttack = (int) reader["MagicAttack"];
      playerInfo1.MagicDefence = (int) reader["MagicDefence"];
      playerInfo1.honorId = (int) reader["honorId"];
      playerInfo1.MountExp = (int) reader["curExp"];
      playerInfo1.MountLv = (int) reader["curLevel"];
      playerInfo1.PetsID = (int) reader["PetsID"];
      return playerInfo1;
    }

    public SqlDataProvider.Data.ItemInfo InitItem(SqlDataReader reader)
    {
      SqlDataProvider.Data.ItemInfo itemInfo = new SqlDataProvider.Data.ItemInfo(ItemMgr.FindItemTemplate((int) reader["TemplateID"]));
      itemInfo.AgilityCompose = (int) reader["AgilityCompose"];
      itemInfo.AttackCompose = (int) reader["AttackCompose"];
      itemInfo.Color = reader["Color"].ToString();
      itemInfo.Count = (int) reader["Count"];
      itemInfo.DefendCompose = (int) reader["DefendCompose"];
      itemInfo.ItemID = (int) reader["ItemID"];
      itemInfo.LuckCompose = (int) reader["LuckCompose"];
      itemInfo.Place = (int) reader["Place"];
      itemInfo.StrengthenLevel = (int) reader["StrengthenLevel"];
      itemInfo.TemplateID = (int) reader["TemplateID"];
      itemInfo.UserID = (int) reader["UserID"];
      itemInfo.ValidDate = (int) reader["ValidDate"];
      itemInfo.IsDirty = false;
      itemInfo.IsExist = (bool) reader["IsExist"];
      itemInfo.IsBinds = (bool) reader["IsBinds"];
      itemInfo.IsUsed = (bool) reader["IsUsed"];
      itemInfo.BeginDate = (DateTime) reader["BeginDate"];
      itemInfo.IsJudge = (bool) reader["IsJudge"];
      itemInfo.BagType = (int) reader["BagType"];
      itemInfo.Skin = reader["Skin"].ToString();
      itemInfo.RemoveDate = (DateTime) reader["RemoveDate"];
      itemInfo.RemoveType = (int) reader["RemoveType"];
      itemInfo.Hole1 = (int) reader["Hole1"];
      itemInfo.Hole2 = (int) reader["Hole2"];
      itemInfo.Hole3 = (int) reader["Hole3"];
      itemInfo.Hole4 = (int) reader["Hole4"];
      itemInfo.Hole5 = (int) reader["Hole5"];
      itemInfo.Hole6 = (int) reader["Hole6"];
      itemInfo.StrengthenTimes = (int) reader["StrengthenTimes"];
      itemInfo.StrengthenExp = (int) reader["StrengthenExp"];
      itemInfo.Int32_0 = (int) reader["Hole5Level"];
      itemInfo.Hole5Exp = (int) reader["Hole5Exp"];
      itemInfo.Int32_1 = (int) reader["Hole6Level"];
      itemInfo.Hole6Exp = (int) reader["Hole6Exp"];
      itemInfo.goldBeginTime = (DateTime) reader["goldBeginTime"];
      itemInfo.goldValidDate = (int) reader["goldValidDate"];
      itemInfo.beadExp = (int) reader["beadExp"];
      itemInfo.beadLevel = (int) reader["beadLevel"];
      itemInfo.beadIsLock = (bool) reader["beadIsLock"];
      itemInfo.isShowBind = (bool) reader["isShowBind"];
      itemInfo.latentEnergyCurStr = (string) reader["latentEnergyCurStr"];
      itemInfo.latentEnergyNewStr = (string) reader["latentEnergyNewStr"];
      itemInfo.latentEnergyEndTime = (DateTime) reader["latentEnergyEndTime"];
      itemInfo.Damage = (int) reader["Damage"];
      itemInfo.Guard = (int) reader["Guard"];
      itemInfo.Blood = (int) reader["Blood"];
      itemInfo.Bless = (int) reader["Bless"];
      itemInfo.AdvanceDate = (DateTime) reader["AdvanceDate"];
      itemInfo.AvatarActivity = (bool) reader["AvatarActivity"];
      itemInfo.goodsLock = (bool) reader["goodsLock"];
      itemInfo.MagicAttack = (int) reader["MagicAttack"];
      itemInfo.MagicDefence = (int) reader["MagicDefence"];
      itemInfo.GoldEquip = ItemMgr.FindGoldItemTemplate(itemInfo.TemplateID, itemInfo.IsGold);
      return itemInfo;
    }

    public UsersPetinfo InitPet(SqlDataReader reader)
    {
      return new UsersPetinfo()
      {
        ID = (int) reader["ID"],
        TemplateID = (int) reader["TemplateID"],
        Name = reader["Name"].ToString(),
        UserID = (int) reader["UserID"],
        Attack = (int) reader["Attack"],
        AttackGrow = (int) reader["AttackGrow"],
        Agility = (int) reader["Agility"],
        AgilityGrow = (int) reader["AgilityGrow"],
        Defence = (int) reader["Defence"],
        DefenceGrow = (int) reader["DefenceGrow"],
        Luck = (int) reader["Luck"],
        LuckGrow = (int) reader["LuckGrow"],
        Blood = (int) reader["Blood"],
        BloodGrow = (int) reader["BloodGrow"],
        Damage = (int) reader["Damage"],
        DamageGrow = (int) reader["DamageGrow"],
        Guard = (int) reader["Guard"],
        GuardGrow = (int) reader["GuardGrow"],
        Level = (int) reader["Level"],
        GP = (int) reader["GP"],
        MaxGP = (int) reader["MaxGP"],
        Hunger = (int) reader["Hunger"],
        MP = (int) reader["MP"],
        Place = (int) reader["Place"],
        IsEquip = (bool) reader["IsEquip"],
        IsExit = (bool) reader["IsExit"],
        Skill = reader["Skill"].ToString(),
        SkillEquip = reader["SkillEquip"].ToString(),
        currentStarExp = (int) reader["currentStarExp"]
      };
    }

    public UsersCardInfo InitCard(SqlDataReader reader)
    {
      return new UsersCardInfo()
      {
        UserID = (int) reader["UserID"],
        TemplateID = (int) reader["TemplateID"],
        CardID = (int) reader["CardID"],
        CardType = (int) reader["CardType"],
        Attack = (int) reader["Attack"],
        Agility = (int) reader["Agility"],
        Defence = (int) reader["Defence"],
        Luck = (int) reader["Luck"],
        Damage = (int) reader["Damage"],
        Guard = (int) reader["Guard"],
        Level = (int) reader["Level"],
        Place = (int) reader["Place"],
        isFirstGet = (bool) reader["isFirstGet"],
        Type = (int) reader["Type"],
        CardGP = (int) reader["CardGP"]
      };
    }

    public TexpInfo InitTexpInfo(SqlDataReader reader)
    {
      return new TexpInfo()
      {
        UserID = (int) reader["UserID"],
        attTexpExp = (int) reader["attTexpExp"],
        defTexpExp = (int) reader["defTexpExp"],
        hpTexpExp = (int) reader["hpTexpExp"],
        lukTexpExp = (int) reader["lukTexpExp"],
        spdTexpExp = (int) reader["spdTexpExp"],
        texpCount = (int) reader["texpCount"],
        texpTaskCount = (int) reader["texpTaskCount"],
        texpTaskDate = (DateTime) reader["texpTaskDate"]
      };
    }

    public UserGemStone InitGemStones(SqlDataReader reader)
    {
      return new UserGemStone()
      {
        ID = (int) reader["ID"],
        UserID = (int) reader["UserID"],
        FigSpiritId = (int) reader["FigSpiritId"],
        FigSpiritIdValue = (string) reader["FigSpiritIdValue"],
        EquipPlace = (int) reader["EquipPlace"]
      };
    }

    public List<UsersCardInfo> GetUserCardEuqip(int UserID)
    {
      List<UsersCardInfo> userCardEuqip = new List<UsersCardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Card_Equip", SqlParameters);
        while (ResultDataReader.Read())
          userCardEuqip.Add(this.InitCard(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return userCardEuqip;
    }

    public List<UserGemStone> GetSingleGemstones(int ID)
    {
      List<UserGemStone> singleGemstones = new List<UserGemStone>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) ID;
        this.db.GetReader(ref ResultDataReader, "SP_GetSingleGemStone", SqlParameters);
        while (ResultDataReader.Read())
          singleGemstones.Add(this.InitGemStones(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "SP_GetSingleUserGemStones", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return singleGemstones;
    }

    public TexpInfo GetUserTexpInfoSingle(int ID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", (object) ID)
        };
        this.db.GetReader(ref ResultDataReader, "SP_Get_UserTexp_By_ID", SqlParameters);
        if (ResultDataReader.Read())
          return this.InitTexpInfo(ResultDataReader);
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "GetTexpInfoSingle", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (TexpInfo) null;
    }

    public List<SqlDataProvider.Data.ItemInfo> GetUserEuqip(int UserID)
    {
      List<SqlDataProvider.Data.ItemInfo> userEuqip = new List<SqlDataProvider.Data.ItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Equip", SqlParameters);
        while (ResultDataReader.Read())
          userEuqip.Add(this.InitItem(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return userEuqip;
    }

    public List<SqlDataProvider.Data.ItemInfo> GetUserBeadEuqip(int UserID)
    {
      List<SqlDataProvider.Data.ItemInfo> userBeadEuqip = new List<SqlDataProvider.Data.ItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Users_Bead_Equip", SqlParameters);
        while (ResultDataReader.Read())
          userBeadEuqip.Add(this.InitItem(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return userBeadEuqip;
    }

    public List<SqlDataProvider.Data.ItemInfo> GetUserMagicstoneEuqip(int UserID)
    {
      List<SqlDataProvider.Data.ItemInfo> userMagicstoneEuqip = new List<SqlDataProvider.Data.ItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Magicstone_Equip", SqlParameters);
        while (ResultDataReader.Read())
          userMagicstoneEuqip.Add(this.InitItem(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return userMagicstoneEuqip;
    }

    public SqlDataProvider.Data.ItemInfo[] GetUserBagByType(int UserID, int bagType)
    {
      List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[2]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4),
          null
        };
        SqlParameters[0].Value = (object) UserID;
        SqlParameters[1] = new SqlParameter("@BagType", (object) bagType);
        this.db.GetReader(ref ResultDataReader, "SP_Users_BagByType", SqlParameters);
        while (ResultDataReader.Read())
          itemInfoList.Add(this.InitItem(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemInfoList.ToArray();
    }

    public UsersPetinfo[] GetUserPetSingles(int UserID)
    {
      List<UsersPetinfo> usersPetinfoList = new List<UsersPetinfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) UserID;
        this.db.GetReader(ref ResultDataReader, "SP_Get_UserPet_By_ID", SqlParameters);
        while (ResultDataReader.Read())
          usersPetinfoList.Add(this.InitPet(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (AreaPlayerBussiness.ilog_0.IsErrorEnabled)
          AreaPlayerBussiness.ilog_0.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return usersPetinfoList.ToArray();
    }

    public void Dispose()
    {
      this.db.Dispose();
      GC.SuppressFinalize((object) this);
    }
  }
}
