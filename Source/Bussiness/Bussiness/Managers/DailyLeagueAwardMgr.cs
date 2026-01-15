// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.DailyLeagueAwardMgr
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
  public class DailyLeagueAwardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<DailyLeagueAwardInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        DailyLeagueAwardInfo[] DailyLeagueAward = DailyLeagueAwardMgr.LoadDailyLeagueAwardDb();
        Dictionary<int, List<DailyLeagueAwardInfo>> dictionary = DailyLeagueAwardMgr.LoadDailyLeagueAwards(DailyLeagueAward);
        if (DailyLeagueAward.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<DailyLeagueAwardInfo>>>(ref DailyLeagueAwardMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (DailyLeagueAwardMgr.ilog_0.IsErrorEnabled)
          DailyLeagueAwardMgr.ilog_0.Error((object) "ReLoad DailyLeagueAward", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => DailyLeagueAwardMgr.ReLoad();

    public static DailyLeagueAwardInfo[] LoadDailyLeagueAwardDb()
    {
      DailyLeagueAwardInfo[] dailyLeagueAward;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        dailyLeagueAward = produceBussiness.GetAllDailyLeagueAward();
      return dailyLeagueAward;
    }

    public static Dictionary<int, List<DailyLeagueAwardInfo>> LoadDailyLeagueAwards(
      DailyLeagueAwardInfo[] DailyLeagueAward)
    {
      Dictionary<int, List<DailyLeagueAwardInfo>> dictionary = new Dictionary<int, List<DailyLeagueAwardInfo>>();
      for (int index = 0; index < DailyLeagueAward.Length; ++index)
      {
        DailyLeagueAwardInfo info = DailyLeagueAward[index];
        if (!dictionary.Keys.Contains<int>(info.Class))
        {
          IEnumerable<DailyLeagueAwardInfo> source = Enumerable.Where<DailyLeagueAwardInfo>((IEnumerable<DailyLeagueAwardInfo>) DailyLeagueAward, (Func<DailyLeagueAwardInfo, bool>) (s => s.Class == info.Class));
          dictionary.Add(info.Class, source.ToList<DailyLeagueAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<DailyLeagueAwardInfo> FindDailyLeagueAward(int Class)
    {
      return DailyLeagueAwardMgr.dictionary_0.ContainsKey(Class) ? DailyLeagueAwardMgr.dictionary_0[Class] : (List<DailyLeagueAwardInfo>) null;
    }
  }
}
