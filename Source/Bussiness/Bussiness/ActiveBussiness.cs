// Decompiled with JetBrains decompiler
// Type: Bussiness.ActiveBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
  public class ActiveBussiness : BaseBussiness
  {
    public ActivityQuestInfo[] GetAllActivityQuest()
    {
      List<ActivityQuestInfo> activityQuestInfoList = new List<ActivityQuestInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Activity_Quest_All");
        while (ResultDataReader.Read())
          activityQuestInfoList.Add(this.InitActivityQuestInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitActivityQuestInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activityQuestInfoList.ToArray();
    }

    public AtivityQuestConditionInfo[] GetAllAtivityQuestCondition()
    {
      List<AtivityQuestConditionInfo> questConditionInfoList = new List<AtivityQuestConditionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Ativity_Quest_Condition_All");
        while (ResultDataReader.Read())
          questConditionInfoList.Add(this.InitAtivityQuestConditionInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitAtivityQuestConditionInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return questConditionInfoList.ToArray();
    }

    public AtivityQuestConditionInfo InitAtivityQuestConditionInfo(SqlDataReader dr)
    {
      return new AtivityQuestConditionInfo()
      {
        QuestID = (int) dr["QuestID"],
        CondictionID = (int) dr["CondictionID"],
        CondictionTitle = (int) dr["CondictionTitle"],
        CondictionType = (int) dr["CondictionType"],
        Para1 = (int) dr["Para1"],
        Para2 = (int) dr["Para2"],
        IndexType = (int) dr["IndexType"]
      };
    }

    public ActivityQuestInfo InitActivityQuestInfo(SqlDataReader dr)
    {
      return new ActivityQuestInfo()
      {
        ID = (int) dr["ID"],
        QuestType = (int) dr["QuestType"],
        Title = (string) dr["Title"],
        Detail = (string) dr["Detail"],
        Objective = (string) dr["Objective"],
        NeedMinLevel = (int) dr["NeedMinLevel"],
        NeedMaxLevel = (int) dr["NeedMaxLevel"],
        Period = (int) dr["Period"]
      };
    }

    public ActivityHalloweenItemsInfo[] GetAllActivityHalloweenItems()
    {
      List<ActivityHalloweenItemsInfo> halloweenItemsInfoList = new List<ActivityHalloweenItemsInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Activity_Halloween_Items_All");
        while (ResultDataReader.Read())
          halloweenItemsInfoList.Add(this.InitActivityHalloweenItemsInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitActivityHalloweenItemsInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return halloweenItemsInfoList.ToArray();
    }

    public ActivityHalloweenItemsInfo InitActivityHalloweenItemsInfo(SqlDataReader dr)
    {
      return new ActivityHalloweenItemsInfo()
      {
        rewardLevel = (int) dr["rewardLevel"],
        templateId = (int) dr["templateId"],
        count = (int) dr["count"],
        validate = (int) dr["validate"],
        strenthLevel = (int) dr["strenthLevel"],
        attack = (int) dr["attack"],
        defend = (int) dr["defend"],
        luck = (int) dr["luck"],
        agility = (int) dr["agility"],
        isBind = (bool) dr["isBind"]
      };
    }

    public bool AddActiveNumber(string AwardID, int ActiveID)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[3]
        {
          new SqlParameter("@AwardID", (object) AwardID),
          new SqlParameter("@ActiveID", (object) ActiveID),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[2].Direction = ParameterDirection.ReturnValue;
        flag = this.db.RunProcedure("SP_Active_Number_Add", SqlParameters);
        flag = (int) SqlParameters[2].Value == 0;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      return flag;
    }

    public ActiveInfo[] GetAllActives()
    {
      List<ActiveInfo> activeInfoList = new List<ActiveInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Active_All");
        while (ResultDataReader.Read())
          activeInfoList.Add(this.InitActiveInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeInfoList.ToArray();
    }

    public ActiveInfo GetSingleActives(int activeID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) activeID;
        this.db.GetReader(ref ResultDataReader, "SP_Active_Single", SqlParameters);
        if (ResultDataReader.Read())
          return this.InitActiveInfo(ResultDataReader);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (ActiveInfo) null;
    }

    public ActiveInfo InitActiveInfo(SqlDataReader reader)
    {
      ActiveInfo activeInfo = new ActiveInfo();
      activeInfo.ActiveID = (int) reader["ActiveID"];
      activeInfo.Description = reader["Description"] == null ? "" : reader["Description"].ToString();
      activeInfo.Content = reader["Content"] == null ? "" : reader["Content"].ToString();
      activeInfo.AwardContent = reader["AwardContent"] == null ? "" : reader["AwardContent"].ToString();
      activeInfo.HasKey = (int) reader["HasKey"];
      if (!string.IsNullOrEmpty(reader["EndDate"].ToString()))
        activeInfo.EndDate = (DateTime) reader["EndDate"];
      activeInfo.IsOnly = (int) reader["IsOnly"];
      activeInfo.StartDate = (DateTime) reader["StartDate"];
      activeInfo.Title = reader["Title"].ToString();
      activeInfo.Type = (int) reader["Type"];
      activeInfo.ActiveType = (int) reader["ActiveType"];
      activeInfo.ActionTimeContent = reader["ActionTimeContent"] == null ? "" : reader["ActionTimeContent"].ToString();
      activeInfo.IsAdvance = (bool) reader["IsAdvance"];
      activeInfo.GoodsExchangeTypes = reader["GoodsExchangeTypes"] == null ? "" : reader["GoodsExchangeTypes"].ToString();
      activeInfo.GoodsExchangeNum = reader["GoodsExchangeNum"] == null ? "" : reader["GoodsExchangeNum"].ToString();
      activeInfo.limitType = reader["limitType"] == null ? "" : reader["limitType"].ToString();
      activeInfo.limitValue = reader["limitValue"] == null ? "" : reader["limitValue"].ToString();
      activeInfo.IsShow = (bool) reader["IsShow"];
      activeInfo.IconID = (int) reader["IconID"];
      return activeInfo;
    }

    public ActiveAwardInfo[] GetAllActiveAwardInfo()
    {
      List<ActiveAwardInfo> activeAwardInfoList = new List<ActiveAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Active_Award_All");
        while (ResultDataReader.Read())
        {
          ActiveAwardInfo activeAwardInfo = new ActiveAwardInfo()
          {
            ID = (int) ResultDataReader["ID"],
            ActiveID = (int) ResultDataReader["ActiveID"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            Count = (int) ResultDataReader["Count"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            Gold = (int) ResultDataReader["Gold"],
            ItemID = (int) ResultDataReader["ItemID"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            Mark = (int) ResultDataReader["Mark"],
            Money = (int) ResultDataReader["Money"],
            Sex = (int) ResultDataReader["Sex"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            ValidDate = (int) ResultDataReader["ValidDate"]
          };
          activeAwardInfoList.Add(activeAwardInfo);
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllActiveAwardInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeAwardInfoList.ToArray();
    }

    public ActiveConvertItemInfo[] GetAllActiveConvertItem()
    {
      List<ActiveConvertItemInfo> activeConvertItemInfoList = new List<ActiveConvertItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Active_Convert_Item_All");
        while (ResultDataReader.Read())
          activeConvertItemInfoList.Add(this.InitActiveConvertItemInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitActiveConvertItemInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeConvertItemInfoList.ToArray();
    }

    public ActiveConvertItemInfo[] GetSingleActiveConvertItems(int activeID)
    {
      List<ActiveConvertItemInfo> activeConvertItemInfoList = new List<ActiveConvertItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) activeID;
        this.db.GetReader(ref ResultDataReader, "SP_Active_Convert_Item_Info_Single", SqlParameters);
        while (ResultDataReader.Read())
          activeConvertItemInfoList.Add(this.InitActiveConvertItemInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeConvertItemInfoList.ToArray();
    }

    public ActiveConvertItemInfo InitActiveConvertItemInfo(SqlDataReader reader)
    {
      return new ActiveConvertItemInfo()
      {
        ActiveID = (int) reader["ActiveID"],
        TemplateID = (int) reader["TemplateID"],
        ItemType = (int) reader["ItemType"],
        ItemCount = (int) reader["ItemCount"],
        LimitValue = (int) reader["LimitValue"],
        IsBind = (bool) reader["IsBind"],
        ValidDate = (int) reader["ValidDate"]
      };
    }

    public int PullDown(int activeID, string awardID, int userID, ref string msg)
    {
      int num = 1;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[4]
        {
          new SqlParameter("@ActiveID", (object) activeID),
          new SqlParameter("@AwardID", (object) awardID),
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[3].Direction = ParameterDirection.ReturnValue;
        if (this.db.RunProcedure("SP_Active_PullDown", SqlParameters))
        {
          num = (int) SqlParameters[3].Value;
          switch (num)
          {
            case 0:
              msg = "ActiveBussiness.Msg0";
              break;
            case 1:
              msg = "ActiveBussiness.Msg1";
              break;
            case 2:
              msg = "ActiveBussiness.Msg2";
              break;
            case 3:
              msg = "ActiveBussiness.Msg3";
              break;
            case 4:
              msg = "ActiveBussiness.Msg4";
              break;
            case 5:
              msg = "ActiveBussiness.Msg5";
              break;
            case 6:
              msg = "ActiveBussiness.Msg6";
              break;
            case 7:
              msg = "ActiveBussiness.Msg7";
              break;
            case 8:
              msg = "ActiveBussiness.Msg8";
              break;
            default:
              msg = "ActiveBussiness.Msg9";
              break;
          }
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      return num;
    }
  }
}
