// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ActivityQuestMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class ActivityQuestMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ActivityQuestInfo> dictionary_0 = new Dictionary<int, ActivityQuestInfo>();
    private static Dictionary<int, List<AtivityQuestConditionInfo>> dictionary_1 = new Dictionary<int, List<AtivityQuestConditionInfo>>();

    public static bool Init() => ActivityQuestMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ActivityQuestInfo> ActivityQuests = ActivityQuestMgr.LoadActivityQuestInfoDb();
        Dictionary<int, List<AtivityQuestConditionInfo>> dictionary = ActivityQuestMgr.LoadActivityQuestCondictionDb(ActivityQuests);
        if (ActivityQuests.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ActivityQuestInfo>>(ref ActivityQuestMgr.dictionary_0, ActivityQuests);
          Interlocked.Exchange<Dictionary<int, List<AtivityQuestConditionInfo>>>(ref ActivityQuestMgr.dictionary_1, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        ActivityQuestMgr.ilog_0.Error((object) nameof (ActivityQuestMgr), ex);
      }
      return false;
    }

    public static Dictionary<int, ActivityQuestInfo> LoadActivityQuestInfoDb()
    {
      Dictionary<int, ActivityQuestInfo> dictionary = new Dictionary<int, ActivityQuestInfo>();
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
      {
        foreach (ActivityQuestInfo activityQuestInfo in activeBussiness.GetAllActivityQuest())
        {
          if (!dictionary.ContainsKey(activityQuestInfo.ID))
            dictionary.Add(activityQuestInfo.ID, activityQuestInfo);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<AtivityQuestConditionInfo>> LoadActivityQuestCondictionDb(
      Dictionary<int, ActivityQuestInfo> ActivityQuests)
    {
      Dictionary<int, List<AtivityQuestConditionInfo>> dictionary = new Dictionary<int, List<AtivityQuestConditionInfo>>();
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
      {
        AtivityQuestConditionInfo[] ativityQuestCondition = activeBussiness.GetAllAtivityQuestCondition();
        foreach (ActivityQuestInfo activityQuestInfo in ActivityQuests.Values)
        {
          ActivityQuestInfo ActivityQuest = activityQuestInfo;
          IEnumerable<AtivityQuestConditionInfo> source = Enumerable.Where<AtivityQuestConditionInfo>((IEnumerable<AtivityQuestConditionInfo>) ativityQuestCondition, (Func<AtivityQuestConditionInfo, bool>) (s => s.QuestID == ActivityQuest.ID));
          dictionary.Add(ActivityQuest.ID, source.ToList<AtivityQuestConditionInfo>());
        }
      }
      return dictionary;
    }

    public static ActivityQuestInfo GetSingleActivityQuest(int id)
    {
      if (ActivityQuestMgr.dictionary_0.Count == 0)
        ActivityQuestMgr.ReLoad();
      return ActivityQuestMgr.dictionary_0.ContainsKey(id) ? ActivityQuestMgr.dictionary_0[id] : (ActivityQuestInfo) null;
    }
  }
}
