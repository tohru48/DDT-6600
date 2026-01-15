// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.AchievementMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class AchievementMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, AchievementInfo> dictionary_0 = new Dictionary<int, AchievementInfo>();
    private static Dictionary<int, List<AchievementConditionInfo>> dictionary_1 = new Dictionary<int, List<AchievementConditionInfo>>();
    private static Dictionary<int, List<AchievementRewardInfo>> dictionary_2 = new Dictionary<int, List<AchievementRewardInfo>>();
    private static Hashtable hashtable_0 = new Hashtable();
    private static Dictionary<int, List<ItemRecordTypeInfo>> dictionary_3 = new Dictionary<int, List<ItemRecordTypeInfo>>();
    private static Hashtable hashtable_1 = new Hashtable();
    private static Dictionary<int, List<int>> dictionary_4 = new Dictionary<int, List<int>>();

    public static Dictionary<int, AchievementInfo> Achievement => AchievementMgr.dictionary_0;

    public static Hashtable ItemRecordType => AchievementMgr.hashtable_1;

    public static List<AchievementConditionInfo> GetAchievementCondition(AchievementInfo info)
    {
      return AchievementMgr.dictionary_1.ContainsKey(info.ID) ? AchievementMgr.dictionary_1[info.ID] : (List<AchievementConditionInfo>) null;
    }

    public static List<AchievementRewardInfo> GetAchievementReward(AchievementInfo info)
    {
      return AchievementMgr.dictionary_2.ContainsKey(info.ID) ? AchievementMgr.dictionary_2[info.ID] : (List<AchievementRewardInfo>) null;
    }

    public static int GetNextLimit(int recordType, int recordValue)
    {
      if (!AchievementMgr.dictionary_4.ContainsKey(recordType))
        return int.MaxValue;
      foreach (int nextLimit in AchievementMgr.dictionary_4[recordType])
      {
        if (nextLimit > recordValue)
          return nextLimit;
      }
      return int.MaxValue;
    }

    public static AchievementInfo GetSingleAchievement(int id)
    {
      if (AchievementMgr.dictionary_0.Count == 0)
        AchievementMgr.Reload();
      return AchievementMgr.dictionary_0.ContainsKey(id) ? AchievementMgr.dictionary_0[id] : (AchievementInfo) null;
    }

    public static bool Init() => AchievementMgr.Reload();

    public static Dictionary<int, List<AchievementConditionInfo>> LoadAchievementConditionInfoDB(
      Dictionary<int, AchievementInfo> achievementInfos)
    {
      Dictionary<int, List<AchievementConditionInfo>> dictionary = new Dictionary<int, List<AchievementConditionInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        AchievementConditionInfo[] achievementCondition = produceBussiness.GetALlAchievementCondition();
        using (Dictionary<int, AchievementInfo>.ValueCollection.Enumerator enumerator = achievementInfos.Values.GetEnumerator())
        {
          while (enumerator.MoveNext())
          {
            AchievementInfo achievementInfo = enumerator.Current;
            IEnumerable<AchievementConditionInfo> source = Enumerable.Where<AchievementConditionInfo>((IEnumerable<AchievementConditionInfo>) achievementCondition, (Func<AchievementConditionInfo, bool>) (s => s.AchievementID == achievementInfo.ID));
            dictionary.Add(achievementInfo.ID, source.ToList<AchievementConditionInfo>());
            if (source != null)
            {
              foreach (AchievementConditionInfo achievementConditionInfo in source)
              {
                if (!AchievementMgr.hashtable_0.Contains((object) achievementConditionInfo.CondictionType))
                  AchievementMgr.hashtable_0.Add((object) achievementConditionInfo.CondictionType, (object) achievementConditionInfo.CondictionType);
              }
            }
          }
        }
        foreach (AchievementConditionInfo achievementConditionInfo in achievementCondition)
        {
          int condictionType = achievementConditionInfo.CondictionType;
          int condictionPara2 = achievementConditionInfo.Condiction_Para2;
          if (!AchievementMgr.dictionary_4.ContainsKey(condictionType))
            AchievementMgr.dictionary_4.Add(condictionType, new List<int>());
          if (!AchievementMgr.dictionary_4[condictionType].Contains(condictionPara2))
            AchievementMgr.dictionary_4[condictionType].Add(condictionPara2);
        }
        foreach (int key in AchievementMgr.dictionary_4.Keys)
          AchievementMgr.dictionary_4[key].Sort();
      }
      return dictionary;
    }

    public static Dictionary<int, AchievementInfo> LoadAchievementInfoDB()
    {
      Dictionary<int, AchievementInfo> dictionary = new Dictionary<int, AchievementInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (AchievementInfo achievementInfo in produceBussiness.GetALlAchievement())
        {
          if (!dictionary.ContainsKey(achievementInfo.ID))
            dictionary.Add(achievementInfo.ID, achievementInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<AchievementRewardInfo>> LoadAchievementRewardInfoDB(
      Dictionary<int, AchievementInfo> achievementInfos)
    {
      Dictionary<int, List<AchievementRewardInfo>> dictionary = new Dictionary<int, List<AchievementRewardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        AchievementRewardInfo[] achievementReward = produceBussiness.GetALlAchievementReward();
        using (Dictionary<int, AchievementInfo>.ValueCollection.Enumerator enumerator = achievementInfos.Values.GetEnumerator())
        {
          while (enumerator.MoveNext())
          {
            AchievementInfo achievementInfo = enumerator.Current;
            IEnumerable<AchievementRewardInfo> source = Enumerable.Where<AchievementRewardInfo>((IEnumerable<AchievementRewardInfo>) achievementReward, (Func<AchievementRewardInfo, bool>) (s => s.AchievementID == achievementInfo.ID));
            dictionary.Add(achievementInfo.ID, source.ToList<AchievementRewardInfo>());
          }
        }
      }
      return dictionary;
    }

    public static void LoadItemRecordTypeInfoDB()
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ItemRecordTypeInfo itemRecordTypeInfo in produceBussiness.GetAllItemRecordType())
        {
          if (!AchievementMgr.hashtable_1.Contains((object) itemRecordTypeInfo.RecordID))
            AchievementMgr.hashtable_1.Add((object) itemRecordTypeInfo.RecordID, (object) itemRecordTypeInfo.Name);
        }
      }
    }

    public static bool Reload()
    {
      try
      {
        AchievementMgr.LoadItemRecordTypeInfoDB();
        Dictionary<int, AchievementInfo> achievementInfos = AchievementMgr.LoadAchievementInfoDB();
        Dictionary<int, List<AchievementConditionInfo>> dictionary1 = AchievementMgr.LoadAchievementConditionInfoDB(achievementInfos);
        Dictionary<int, List<AchievementRewardInfo>> dictionary2 = AchievementMgr.LoadAchievementRewardInfoDB(achievementInfos);
        if (achievementInfos.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, AchievementInfo>>(ref AchievementMgr.dictionary_0, achievementInfos);
          Interlocked.Exchange<Dictionary<int, List<AchievementConditionInfo>>>(ref AchievementMgr.dictionary_1, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<AchievementRewardInfo>>>(ref AchievementMgr.dictionary_2, dictionary2);
        }
        return true;
      }
      catch (Exception ex)
      {
        AchievementMgr.ilog_0.Error((object) nameof (AchievementMgr), ex);
      }
      return false;
    }
  }
}
