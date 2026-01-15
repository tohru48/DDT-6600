// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ActivityHalloweenItemsMgr
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
  public class ActivityHalloweenItemsMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<ActivityHalloweenItemsInfo>> dictionary_0 = new Dictionary<int, List<ActivityHalloweenItemsInfo>>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        ActivityHalloweenItemsInfo[] ActivityHalloweenItems = ActivityHalloweenItemsMgr.LoadActivityHalloweenItemsDb();
        Dictionary<int, List<ActivityHalloweenItemsInfo>> dictionary = ActivityHalloweenItemsMgr.LoadActivityHalloweenItemss(ActivityHalloweenItems);
        if (ActivityHalloweenItems.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<ActivityHalloweenItemsInfo>>>(ref ActivityHalloweenItemsMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (ActivityHalloweenItemsMgr.ilog_0.IsErrorEnabled)
          ActivityHalloweenItemsMgr.ilog_0.Error((object) "ReLoad ActivityHalloweenItems", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => ActivityHalloweenItemsMgr.ReLoad();

    public static ActivityHalloweenItemsInfo[] LoadActivityHalloweenItemsDb()
    {
      ActivityHalloweenItemsInfo[] activityHalloweenItems;
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
        activityHalloweenItems = activeBussiness.GetAllActivityHalloweenItems();
      return activityHalloweenItems;
    }

    public static Dictionary<int, List<ActivityHalloweenItemsInfo>> LoadActivityHalloweenItemss(
      ActivityHalloweenItemsInfo[] ActivityHalloweenItems)
    {
      Dictionary<int, List<ActivityHalloweenItemsInfo>> dictionary = new Dictionary<int, List<ActivityHalloweenItemsInfo>>();
      for (int index = 0; index < ActivityHalloweenItems.Length; ++index)
      {
        ActivityHalloweenItemsInfo info = ActivityHalloweenItems[index];
        if (!dictionary.Keys.Contains<int>(info.rewardLevel))
        {
          IEnumerable<ActivityHalloweenItemsInfo> source = Enumerable.Where<ActivityHalloweenItemsInfo>((IEnumerable<ActivityHalloweenItemsInfo>) ActivityHalloweenItems, (Func<ActivityHalloweenItemsInfo, bool>) (s => s.rewardLevel == info.rewardLevel));
          dictionary.Add(info.rewardLevel, source.ToList<ActivityHalloweenItemsInfo>());
        }
      }
      return dictionary;
    }

    public static List<ActivityHalloweenItemsInfo> FindActivityHalloweenItems(int rewardLevel)
    {
      return ActivityHalloweenItemsMgr.dictionary_0.ContainsKey(rewardLevel) ? ActivityHalloweenItemsMgr.dictionary_0[rewardLevel] : (List<ActivityHalloweenItemsInfo>) null;
    }
  }
}
