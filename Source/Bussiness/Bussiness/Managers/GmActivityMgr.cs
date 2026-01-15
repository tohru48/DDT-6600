// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.GmActivityMgr
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
  public class GmActivityMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<string, GmActivityInfo> dictionary_0;
    private static Dictionary<string, List<GmGiftInfo>> dictionary_1;
    private static Dictionary<string, List<GmActiveConditionInfo>> dictionary_2;
    private static Dictionary<string, List<GmActiveRewardInfo>> dictionary_3;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        GmActivityInfo[] gmActivityInfoArray = GmActivityMgr.LoadGmActivityDb();
        GmGiftInfo[] gmGiftInfoArray = GmActivityMgr.LoadGmGiftDb();
        Dictionary<string, GmActivityInfo> dictionary1 = GmActivityMgr.LoadGmActivitys(gmActivityInfoArray);
        Dictionary<string, List<GmGiftInfo>> dictionary2 = GmActivityMgr.LoadGmGifts(gmActivityInfoArray, gmGiftInfoArray);
        Dictionary<string, List<GmActiveConditionInfo>> dictionary3 = GmActivityMgr.LoadGmActiveConditions(gmGiftInfoArray);
        Dictionary<string, List<GmActiveRewardInfo>> dictionary4 = GmActivityMgr.LoadGmActiveRewards(gmGiftInfoArray);
        if (gmActivityInfoArray.Length > 0)
        {
          Interlocked.Exchange<Dictionary<string, GmActivityInfo>>(ref GmActivityMgr.dictionary_0, dictionary1);
          if (gmGiftInfoArray.Length > 0)
          {
            Interlocked.Exchange<Dictionary<string, List<GmGiftInfo>>>(ref GmActivityMgr.dictionary_1, dictionary2);
            Interlocked.Exchange<Dictionary<string, List<GmActiveConditionInfo>>>(ref GmActivityMgr.dictionary_2, dictionary3);
            Interlocked.Exchange<Dictionary<string, List<GmActiveRewardInfo>>>(ref GmActivityMgr.dictionary_3, dictionary4);
          }
        }
        return true;
      }
      catch (Exception ex)
      {
        if (GmActivityMgr.ilog_0.IsErrorEnabled)
          GmActivityMgr.ilog_0.Error((object) "ReLoad GmActivity", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => GmActivityMgr.ReLoad();

    public static List<GmGiftInfo> FindGmGift(string giftId)
    {
      return GmActivityMgr.dictionary_1.ContainsKey(giftId) ? GmActivityMgr.dictionary_1[giftId] : (List<GmGiftInfo>) null;
    }

    public static List<GmActiveConditionInfo> FindGmActiveCondition(string giftId)
    {
      return GmActivityMgr.dictionary_2.ContainsKey(giftId) ? GmActivityMgr.dictionary_2[giftId] : (List<GmActiveConditionInfo>) null;
    }

    public static List<GmActiveRewardInfo> FindGmActiveReward(string giftId)
    {
      return GmActivityMgr.dictionary_3.ContainsKey(giftId) ? GmActivityMgr.dictionary_3[giftId] : (List<GmActiveRewardInfo>) null;
    }

    public static GmGiftInfo[] LoadGmGiftDb()
    {
      GmGiftInfo[] allGmGift;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allGmGift = produceBussiness.GetAllGmGift();
      return allGmGift;
    }

    public static Dictionary<string, List<GmActiveRewardInfo>> LoadGmActiveRewards(
      GmGiftInfo[] gmGiftBags)
    {
      Dictionary<string, List<GmActiveRewardInfo>> dictionary = new Dictionary<string, List<GmActiveRewardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        GmActiveRewardInfo[] allGmActiveReward = produceBussiness.GetAllGmActiveReward();
        for (int index = 0; index < gmGiftBags.Length; ++index)
        {
          GmGiftInfo info = gmGiftBags[index];
          if (!dictionary.Keys.Contains<string>(info.giftbagId))
          {
            IEnumerable<GmActiveRewardInfo> source = Enumerable.Where<GmActiveRewardInfo>((IEnumerable<GmActiveRewardInfo>) allGmActiveReward, (Func<GmActiveRewardInfo, bool>) (s => s.giftId == info.giftbagId));
            dictionary.Add(info.giftbagId, source.ToList<GmActiveRewardInfo>());
          }
        }
      }
      return dictionary;
    }

    public static Dictionary<string, List<GmActiveConditionInfo>> LoadGmActiveConditions(
      GmGiftInfo[] gmGiftBags)
    {
      Dictionary<string, List<GmActiveConditionInfo>> dictionary = new Dictionary<string, List<GmActiveConditionInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        GmActiveConditionInfo[] gmActiveCondition = produceBussiness.GetAllGmActiveCondition();
        for (int index = 0; index < gmGiftBags.Length; ++index)
        {
          GmGiftInfo info = gmGiftBags[index];
          if (!dictionary.Keys.Contains<string>(info.giftbagId))
          {
            IEnumerable<GmActiveConditionInfo> source = Enumerable.Where<GmActiveConditionInfo>((IEnumerable<GmActiveConditionInfo>) gmActiveCondition, (Func<GmActiveConditionInfo, bool>) (s => s.giftbagId == info.giftbagId));
            dictionary.Add(info.giftbagId, source.ToList<GmActiveConditionInfo>());
          }
        }
      }
      return dictionary;
    }

    public static Dictionary<string, List<GmGiftInfo>> LoadGmGifts(
      GmActivityInfo[] gmActivitys,
      GmGiftInfo[] tempGmGift)
    {
      Dictionary<string, List<GmGiftInfo>> dictionary = new Dictionary<string, List<GmGiftInfo>>();
      for (int index = 0; index < gmActivitys.Length; ++index)
      {
        GmActivityInfo gmActivity = gmActivitys[index];
        Func<GmGiftInfo, bool> func = (Func<GmGiftInfo, bool>) (s => s.activityId == gmActivity.activityId);
        IEnumerable<GmGiftInfo> source = Enumerable.Where<GmGiftInfo>((IEnumerable<GmGiftInfo>) tempGmGift, func);
        dictionary.Add(gmActivity.activityId, source.ToList<GmGiftInfo>());
      }
      return dictionary;
    }

    public static GmActivityInfo[] LoadGmActivityDb()
    {
      GmActivityInfo[] allGmActivity;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allGmActivity = produceBussiness.GetAllGmActivity();
      return allGmActivity;
    }

    public static Dictionary<string, GmActivityInfo> LoadGmActivitys(GmActivityInfo[] GmActivity)
    {
      Dictionary<string, GmActivityInfo> dictionary = new Dictionary<string, GmActivityInfo>();
      for (int index = 0; index < GmActivity.Length; ++index)
      {
        GmActivityInfo gmActivityInfo = GmActivity[index];
        if (!dictionary.Keys.Contains<string>(gmActivityInfo.activityId))
          dictionary.Add(gmActivityInfo.activityId, gmActivityInfo);
      }
      return dictionary;
    }

    public static GmActivityInfo FindGmActivity(string activityId)
    {
      return GmActivityMgr.dictionary_0.ContainsKey(activityId) ? GmActivityMgr.dictionary_0[activityId] : (GmActivityInfo) null;
    }
  }
}
