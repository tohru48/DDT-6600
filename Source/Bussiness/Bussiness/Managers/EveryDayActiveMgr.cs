// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.EveryDayActiveMgr
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
  public class EveryDayActiveMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, EveryDayActivePointTemplateInfo> dictionary_0;
    private static Dictionary<int, EveryDayActiveProgressInfo> dictionary_1;
    private static Dictionary<int, List<EveryDayActiveRewardTemplateInfo>> dictionary_2;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        EveryDayActivePointTemplateInfo[] EveryDayActivePointTemplate = EveryDayActiveMgr.LoadEveryDayActivePointTemplateDb();
        Dictionary<int, EveryDayActivePointTemplateInfo> dictionary1 = EveryDayActiveMgr.LoadEveryDayActivePointTemplates(EveryDayActivePointTemplate);
        if (EveryDayActivePointTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, EveryDayActivePointTemplateInfo>>(ref EveryDayActiveMgr.dictionary_0, dictionary1);
        EveryDayActiveProgressInfo[] EveryDayActiveProgress = EveryDayActiveMgr.LoadEveryDayActiveProgressDb();
        Dictionary<int, EveryDayActiveProgressInfo> dictionary2 = EveryDayActiveMgr.LoadEveryDayActiveProgresss(EveryDayActiveProgress);
        if (EveryDayActiveProgress.Length > 0)
          Interlocked.Exchange<Dictionary<int, EveryDayActiveProgressInfo>>(ref EveryDayActiveMgr.dictionary_1, dictionary2);
        EveryDayActiveRewardTemplateInfo[] EveryDayActiveRewardTemplate = EveryDayActiveMgr.LoadEveryDayActiveRewardTemplateDb();
        Dictionary<int, List<EveryDayActiveRewardTemplateInfo>> dictionary3 = EveryDayActiveMgr.LoadEveryDayActiveRewardTemplates(EveryDayActiveRewardTemplate);
        if (EveryDayActiveRewardTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<EveryDayActiveRewardTemplateInfo>>>(ref EveryDayActiveMgr.dictionary_2, dictionary3);
        return true;
      }
      catch (Exception ex)
      {
        if (EveryDayActiveMgr.ilog_0.IsErrorEnabled)
          EveryDayActiveMgr.ilog_0.Error((object) "ReLoad EveryDayActivePointTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => EveryDayActiveMgr.ReLoad();

    public static EveryDayActiveRewardTemplateInfo[] LoadEveryDayActiveRewardTemplateDb()
    {
      EveryDayActiveRewardTemplateInfo[] activeRewardTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        activeRewardTemplate = produceBussiness.GetAllEveryDayActiveRewardTemplate();
      return activeRewardTemplate;
    }

    public static Dictionary<int, List<EveryDayActiveRewardTemplateInfo>> LoadEveryDayActiveRewardTemplates(
      EveryDayActiveRewardTemplateInfo[] EveryDayActiveRewardTemplate)
    {
      Dictionary<int, List<EveryDayActiveRewardTemplateInfo>> dictionary = new Dictionary<int, List<EveryDayActiveRewardTemplateInfo>>();
      for (int index = 0; index < EveryDayActiveRewardTemplate.Length; ++index)
      {
        EveryDayActiveRewardTemplateInfo info = EveryDayActiveRewardTemplate[index];
        if (!dictionary.Keys.Contains<int>(info.ID))
        {
          IEnumerable<EveryDayActiveRewardTemplateInfo> source = Enumerable.Where<EveryDayActiveRewardTemplateInfo>((IEnumerable<EveryDayActiveRewardTemplateInfo>) EveryDayActiveRewardTemplate, (Func<EveryDayActiveRewardTemplateInfo, bool>) (s => s.RewardID == info.RewardID));
          dictionary.Add(info.ID, source.ToList<EveryDayActiveRewardTemplateInfo>());
        }
      }
      return dictionary;
    }

    public static List<EveryDayActiveRewardTemplateInfo> FindEveryDayActiveRewardTemplate(int ID)
    {
      return EveryDayActiveMgr.dictionary_2.ContainsKey(ID) ? EveryDayActiveMgr.dictionary_2[ID] : (List<EveryDayActiveRewardTemplateInfo>) null;
    }

    public static EveryDayActiveProgressInfo[] LoadEveryDayActiveProgressDb()
    {
      EveryDayActiveProgressInfo[] dayActiveProgress;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        dayActiveProgress = produceBussiness.GetAllEveryDayActiveProgress();
      return dayActiveProgress;
    }

    public static Dictionary<int, EveryDayActiveProgressInfo> LoadEveryDayActiveProgresss(
      EveryDayActiveProgressInfo[] EveryDayActiveProgress)
    {
      Dictionary<int, EveryDayActiveProgressInfo> dictionary = new Dictionary<int, EveryDayActiveProgressInfo>();
      for (int index = 0; index < EveryDayActiveProgress.Length; ++index)
      {
        EveryDayActiveProgressInfo activeProgressInfo = EveryDayActiveProgress[index];
        if (!dictionary.Keys.Contains<int>(activeProgressInfo.ID))
          dictionary.Add(activeProgressInfo.ID, activeProgressInfo);
      }
      return dictionary;
    }

    public static EveryDayActiveProgressInfo FindEveryDayActiveProgress(int ID)
    {
      return EveryDayActiveMgr.dictionary_1.ContainsKey(ID) ? EveryDayActiveMgr.dictionary_1[ID] : (EveryDayActiveProgressInfo) null;
    }

    public static EveryDayActivePointTemplateInfo[] LoadEveryDayActivePointTemplateDb()
    {
      EveryDayActivePointTemplateInfo[] activePointTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        activePointTemplate = produceBussiness.GetAllEveryDayActivePointTemplate();
      return activePointTemplate;
    }

    public static Dictionary<int, EveryDayActivePointTemplateInfo> LoadEveryDayActivePointTemplates(
      EveryDayActivePointTemplateInfo[] EveryDayActivePointTemplate)
    {
      Dictionary<int, EveryDayActivePointTemplateInfo> dictionary = new Dictionary<int, EveryDayActivePointTemplateInfo>();
      for (int index = 0; index < EveryDayActivePointTemplate.Length; ++index)
      {
        EveryDayActivePointTemplateInfo pointTemplateInfo = EveryDayActivePointTemplate[index];
        if (!dictionary.Keys.Contains<int>(pointTemplateInfo.ID))
          dictionary.Add(pointTemplateInfo.ID, pointTemplateInfo);
      }
      return dictionary;
    }

    public static EveryDayActivePointTemplateInfo FindEveryDayActivePointTemplate(int ID)
    {
      return EveryDayActiveMgr.dictionary_0.ContainsKey(ID) ? EveryDayActiveMgr.dictionary_0[ID] : (EveryDayActivePointTemplateInfo) null;
    }
  }
}
