// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.HelpGameRewardMgr
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
  public class HelpGameRewardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<HelpGameRewardInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        HelpGameRewardInfo[] HelpGameReward = HelpGameRewardMgr.LoadHelpGameRewardDb();
        Dictionary<int, List<HelpGameRewardInfo>> dictionary = HelpGameRewardMgr.LoadHelpGameRewards(HelpGameReward);
        if (HelpGameReward.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<HelpGameRewardInfo>>>(ref HelpGameRewardMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (HelpGameRewardMgr.ilog_0.IsErrorEnabled)
          HelpGameRewardMgr.ilog_0.Error((object) "ReLoad HelpGameReward", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => HelpGameRewardMgr.ReLoad();

    public static HelpGameRewardInfo[] LoadHelpGameRewardDb()
    {
      HelpGameRewardInfo[] allHelpGameReward;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allHelpGameReward = produceBussiness.GetAllHelpGameReward();
      return allHelpGameReward;
    }

    public static Dictionary<int, List<HelpGameRewardInfo>> LoadHelpGameRewards(
      HelpGameRewardInfo[] HelpGameReward)
    {
      Dictionary<int, List<HelpGameRewardInfo>> dictionary = new Dictionary<int, List<HelpGameRewardInfo>>();
      for (int index = 0; index < HelpGameReward.Length; ++index)
      {
        HelpGameRewardInfo info = HelpGameReward[index];
        if (!dictionary.Keys.Contains<int>(info.MissionID))
        {
          IEnumerable<HelpGameRewardInfo> source = Enumerable.Where<HelpGameRewardInfo>((IEnumerable<HelpGameRewardInfo>) HelpGameReward, (Func<HelpGameRewardInfo, bool>) (s => s.MissionID == info.MissionID));
          dictionary.Add(info.MissionID, source.ToList<HelpGameRewardInfo>());
        }
      }
      return dictionary;
    }

    public static List<HelpGameRewardInfo> FindHelpGameReward(int missionID)
    {
      return HelpGameRewardMgr.dictionary_0.ContainsKey(missionID) ? HelpGameRewardMgr.dictionary_0[missionID] : (List<HelpGameRewardInfo>) null;
    }
  }
}
