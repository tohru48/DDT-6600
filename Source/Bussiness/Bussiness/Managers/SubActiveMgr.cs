// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.SubActiveMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class SubActiveMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    public static Dictionary<int, SubActiveConditionInfo> m_subActiveConditionInfo = new Dictionary<int, SubActiveConditionInfo>();
    public static Dictionary<int, List<SubActiveInfo>> m_subActiveInfo = new Dictionary<int, List<SubActiveInfo>>();

    public static SubActiveConditionInfo GetSubActiveInfo(SqlDataProvider.Data.ItemInfo item)
    {
      foreach (List<SubActiveInfo> subActiveInfoList in SubActiveMgr.m_subActiveInfo.Values)
      {
        foreach (SubActiveInfo info in subActiveInfoList)
        {
          if (SubActiveMgr.IsValid(info))
          {
            foreach (SubActiveConditionInfo subActiveInfo in SubActiveMgr.m_subActiveConditionInfo.Values)
            {
              if (info.ActiveID == subActiveInfo.ActiveID && info.SubID == subActiveInfo.SubID && subActiveInfo.ConditionID == item.TemplateID)
              {
                switch (item.Template.CategoryID)
                {
                  case 6:
                    return subActiveInfo;
                  default:
                    return item.StrengthenLevel == subActiveInfo.Type || item.IsGold && item.StrengthenLevel + 100 == subActiveInfo.Type ? subActiveInfo : (SubActiveConditionInfo) null;
                }
              }
            }
          }
        }
      }
      return (SubActiveConditionInfo) null;
    }

    public static bool Init() => SubActiveMgr.ReLoad();

    public static bool IsValid(SubActiveInfo info)
    {
      DateTime startTime = info.StartTime;
      DateTime endTime = info.EndTime;
      DateTime dateTime1 = info.StartTime;
      long ticks1 = dateTime1.Ticks;
      dateTime1 = DateTime.Now;
      long ticks2 = dateTime1.Ticks;
      int num;
      if (ticks1 <= ticks2)
      {
        DateTime dateTime2 = info.EndTime;
        long ticks3 = dateTime2.Ticks;
        dateTime2 = DateTime.Now;
        long ticks4 = dateTime2.Ticks;
        num = ticks3 >= ticks4 ? 1 : 0;
      }
      else
        num = 0;
      return num != 0;
    }

    public static Dictionary<int, SubActiveConditionInfo> LoadSubActiveConditionDb(
      Dictionary<int, List<SubActiveInfo>> conditions)
    {
      Dictionary<int, SubActiveConditionInfo> dictionary = new Dictionary<int, SubActiveConditionInfo>();
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (int key in conditions.Keys)
        {
          foreach (SubActiveConditionInfo activeConditionInfo in playerBussiness.GetAllSubActiveCondition(key))
          {
            if (key == activeConditionInfo.ActiveID && !dictionary.ContainsKey(activeConditionInfo.ID))
              dictionary.Add(activeConditionInfo.ID, activeConditionInfo);
          }
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<SubActiveInfo>> LoadSubActiveDb()
    {
      Dictionary<int, List<SubActiveInfo>> dictionary = new Dictionary<int, List<SubActiveInfo>>();
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (SubActiveInfo subActiveInfo in playerBussiness.GetAllSubActive())
        {
          List<SubActiveInfo> subActiveInfoList = new List<SubActiveInfo>();
          if (!dictionary.ContainsKey(subActiveInfo.ActiveID))
          {
            subActiveInfoList.Add(subActiveInfo);
            dictionary.Add(subActiveInfo.ActiveID, subActiveInfoList);
          }
          else
            dictionary[subActiveInfo.ActiveID].Add(subActiveInfo);
        }
      }
      return dictionary;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, List<SubActiveInfo>> conditions = SubActiveMgr.LoadSubActiveDb();
        Dictionary<int, SubActiveConditionInfo> dictionary = SubActiveMgr.LoadSubActiveConditionDb(conditions);
        if (conditions.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, List<SubActiveInfo>>>(ref SubActiveMgr.m_subActiveInfo, conditions);
          Interlocked.Exchange<Dictionary<int, SubActiveConditionInfo>>(ref SubActiveMgr.m_subActiveConditionInfo, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        SubActiveMgr.ilog_0.Error((object) "QuestMgr", ex);
      }
      return false;
    }
  }
}
