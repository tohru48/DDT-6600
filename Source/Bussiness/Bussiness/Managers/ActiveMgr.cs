// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ActiveMgr
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
  public class ActiveMgr
  {
    private static readonly ILog loribHfmT = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ActiveInfo> dictionary_0 = new Dictionary<int, ActiveInfo>();
    private static Dictionary<int, List<ActiveConvertItemInfo>> dictionary_1 = new Dictionary<int, List<ActiveConvertItemInfo>>();
    private static Dictionary<int, List<ActiveAwardInfo>> dictionary_2 = new Dictionary<int, List<ActiveAwardInfo>>();
    private static Dictionary<int, List<ActivitySystemItemInfo>> dictionary_3 = new Dictionary<int, List<ActivitySystemItemInfo>>();

    public static bool Init() => ActiveMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ActiveInfo> Actives = ActiveMgr.LoadActiveInfoDb();
        Dictionary<int, List<ActiveConvertItemInfo>> dictionary1 = ActiveMgr.LoadActiveCondictionDb(Actives);
        Dictionary<int, List<ActiveAwardInfo>> dictionary2 = ActiveMgr.LoadActiveGoodDb(Actives);
        if (Actives.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ActiveInfo>>(ref ActiveMgr.dictionary_0, Actives);
          Interlocked.Exchange<Dictionary<int, List<ActiveConvertItemInfo>>>(ref ActiveMgr.dictionary_1, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<ActiveAwardInfo>>>(ref ActiveMgr.dictionary_2, dictionary2);
        }
        ActivitySystemItemInfo[] ActivitySystemItem = ActiveMgr.LoadActivitySystemItemDb();
        Dictionary<int, List<ActivitySystemItemInfo>> dictionary3 = ActiveMgr.LoadActivitySystemItems(ActivitySystemItem);
        if (ActivitySystemItem.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<ActivitySystemItemInfo>>>(ref ActiveMgr.dictionary_3, dictionary3);
        return true;
      }
      catch (Exception ex)
      {
        ActiveMgr.loribHfmT.Error((object) nameof (ActiveMgr), ex);
      }
      return false;
    }

    public static ActiveConvertItemInfo GetActiveConvertItem(int id, int templateID, int index)
    {
      if (ActiveMgr.dictionary_1.ContainsKey(id))
      {
        foreach (ActiveConvertItemInfo activeConvertItem in ActiveMgr.dictionary_1[id])
        {
          if (activeConvertItem.TemplateID == templateID && activeConvertItem.ItemType == index)
            return activeConvertItem;
        }
      }
      return (ActiveConvertItemInfo) null;
    }

    public static List<ActiveConvertItemInfo> GetActiveConvertItemAward(int id, int index)
    {
      List<ActiveConvertItemInfo> convertItemAward = new List<ActiveConvertItemInfo>();
      if (ActiveMgr.dictionary_1.ContainsKey(id))
      {
        foreach (ActiveConvertItemInfo activeConvertItemInfo in ActiveMgr.dictionary_1[id])
        {
          if (activeConvertItemInfo.ItemType == ActiveMgr.GetGoodsAward(index))
            convertItemAward.Add(activeConvertItemInfo);
        }
      }
      return convertItemAward;
    }

    public static List<ActiveConvertItemInfo> FindActiveConvertItem(int id)
    {
      return ActiveMgr.dictionary_1.ContainsKey(id) ? ActiveMgr.dictionary_1[id] : (List<ActiveConvertItemInfo>) null;
    }

    public static int GetGoodsAward(int index)
    {
      switch (index)
      {
        case 1:
          return 3;
        case 2:
          return 5;
        case 3:
          return 7;
        default:
          return 1;
      }
    }

    public static ActivitySystemItemInfo[] LoadActivitySystemItemDb()
    {
      ActivitySystemItemInfo[] activitySystemItem;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        activitySystemItem = produceBussiness.GetAllActivitySystemItem();
      return activitySystemItem;
    }

    public static Dictionary<int, List<ActivitySystemItemInfo>> LoadActivitySystemItems(
      ActivitySystemItemInfo[] ActivitySystemItem)
    {
      Dictionary<int, List<ActivitySystemItemInfo>> dictionary = new Dictionary<int, List<ActivitySystemItemInfo>>();
      for (int index = 0; index < ActivitySystemItem.Length; ++index)
      {
        ActivitySystemItemInfo info = ActivitySystemItem[index];
        if (!dictionary.Keys.Contains<int>(info.ActivityType))
        {
          IEnumerable<ActivitySystemItemInfo> source = Enumerable.Where<ActivitySystemItemInfo>((IEnumerable<ActivitySystemItemInfo>) ActivitySystemItem, (Func<ActivitySystemItemInfo, bool>) (s => s.ActivityType == info.ActivityType));
          dictionary.Add(info.ActivityType, source.ToList<ActivitySystemItemInfo>());
        }
      }
      return dictionary;
    }

    public static List<ActivitySystemItemInfo> FindActivitySystemItem(int ActivityType)
    {
      return ActiveMgr.dictionary_3.ContainsKey(ActivityType) ? ActiveMgr.dictionary_3[ActivityType] : (List<ActivitySystemItemInfo>) null;
    }

    public static List<ActivitySystemItemInfo> GetActivitySystemItemByLayer(int layer)
    {
      List<ActivitySystemItemInfo> systemItemByLayer = new List<ActivitySystemItemInfo>();
      foreach (ActivitySystemItemInfo activitySystemItemInfo in ActiveMgr.FindActivitySystemItem(8))
      {
        if (activitySystemItemInfo.Quality == layer)
          systemItemByLayer.Add(activitySystemItemInfo);
      }
      return systemItemByLayer;
    }

    public static List<ActivitySystemItemInfo> GetGrowthPackage(int layer)
    {
      List<ActivitySystemItemInfo> growthPackage = new List<ActivitySystemItemInfo>();
      foreach (ActivitySystemItemInfo activitySystemItemInfo in ActiveMgr.FindActivitySystemItem(20))
      {
        if (activitySystemItemInfo.Quality == layer)
          growthPackage.Add(activitySystemItemInfo);
      }
      return growthPackage;
    }

    public static List<ActivitySystemItemInfo> FindChickActivePakage(int quality)
    {
      List<ActivitySystemItemInfo> chickActivePakage = new List<ActivitySystemItemInfo>();
      foreach (ActivitySystemItemInfo activitySystemItemInfo in ActiveMgr.FindActivitySystemItem(40))
      {
        if (activitySystemItemInfo.Quality == quality)
          chickActivePakage.Add(activitySystemItemInfo);
      }
      return chickActivePakage;
    }

    public static Dictionary<int, ActiveInfo> LoadActiveInfoDb()
    {
      Dictionary<int, ActiveInfo> dictionary = new Dictionary<int, ActiveInfo>();
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
      {
        foreach (ActiveInfo allActive in activeBussiness.GetAllActives())
        {
          if (!dictionary.ContainsKey(allActive.ActiveID))
            dictionary.Add(allActive.ActiveID, allActive);
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<ActiveConvertItemInfo>> LoadActiveCondictionDb(
      Dictionary<int, ActiveInfo> Actives)
    {
      Dictionary<int, List<ActiveConvertItemInfo>> dictionary = new Dictionary<int, List<ActiveConvertItemInfo>>();
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
      {
        ActiveConvertItemInfo[] activeConvertItem = activeBussiness.GetAllActiveConvertItem();
        foreach (ActiveInfo activeInfo in Actives.Values)
        {
          ActiveInfo active = activeInfo;
          IEnumerable<ActiveConvertItemInfo> source = Enumerable.Where<ActiveConvertItemInfo>((IEnumerable<ActiveConvertItemInfo>) activeConvertItem, (Func<ActiveConvertItemInfo, bool>) (s => s.ActiveID == active.ActiveID));
          dictionary.Add(active.ActiveID, source.ToList<ActiveConvertItemInfo>());
        }
      }
      return dictionary;
    }

    public static Dictionary<int, List<ActiveAwardInfo>> LoadActiveGoodDb(
      Dictionary<int, ActiveInfo> Actives)
    {
      Dictionary<int, List<ActiveAwardInfo>> dictionary = new Dictionary<int, List<ActiveAwardInfo>>();
      using (ActiveBussiness activeBussiness = new ActiveBussiness())
      {
        ActiveAwardInfo[] allActiveAwardInfo = activeBussiness.GetAllActiveAwardInfo();
        foreach (ActiveInfo activeInfo in Actives.Values)
        {
          ActiveInfo Active = activeInfo;
          IEnumerable<ActiveAwardInfo> source = Enumerable.Where<ActiveAwardInfo>((IEnumerable<ActiveAwardInfo>) allActiveAwardInfo, (Func<ActiveAwardInfo, bool>) (s => s.ActiveID == Active.ActiveID));
          dictionary.Add(Active.ActiveID, source.ToList<ActiveAwardInfo>());
        }
      }
      return dictionary;
    }

    public static ActiveInfo GetSingleActive(int id)
    {
      if (ActiveMgr.dictionary_0.Count == 0)
        ActiveMgr.ReLoad();
      return ActiveMgr.dictionary_0.ContainsKey(id) ? ActiveMgr.dictionary_0[id] : (ActiveInfo) null;
    }
  }
}
