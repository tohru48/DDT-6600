// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.DiceGameAwardMgr
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
  public class DiceGameAwardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<DiceGameAwardInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        DiceGameAwardInfo[] DiceGameAward = DiceGameAwardMgr.LoadDiceGameAwardDb();
        Dictionary<int, List<DiceGameAwardInfo>> dictionary = DiceGameAwardMgr.LoadDiceGameAwards(DiceGameAward);
        if (DiceGameAward.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<DiceGameAwardInfo>>>(ref DiceGameAwardMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (DiceGameAwardMgr.ilog_0.IsErrorEnabled)
          DiceGameAwardMgr.ilog_0.Error((object) "ReLoad DiceGameAward", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => DiceGameAwardMgr.ReLoad();

    public static DiceGameAwardInfo[] LoadDiceGameAwardDb()
    {
      DiceGameAwardInfo[] allDiceGameAward;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allDiceGameAward = produceBussiness.GetAllDiceGameAward();
      return allDiceGameAward;
    }

    public static Dictionary<int, List<DiceGameAwardInfo>> LoadDiceGameAwards(
      DiceGameAwardInfo[] DiceGameAward)
    {
      Dictionary<int, List<DiceGameAwardInfo>> dictionary = new Dictionary<int, List<DiceGameAwardInfo>>();
      for (int index = 0; index < DiceGameAward.Length; ++index)
      {
        DiceGameAwardInfo info = DiceGameAward[index];
        if (!dictionary.Keys.Contains<int>(info.rank))
        {
          IEnumerable<DiceGameAwardInfo> source = Enumerable.Where<DiceGameAwardInfo>((IEnumerable<DiceGameAwardInfo>) DiceGameAward, (Func<DiceGameAwardInfo, bool>) (s => s.rank == info.rank));
          dictionary.Add(info.rank, source.ToList<DiceGameAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<DiceGameAwardInfo> FindDiceGameAward(int DataId)
    {
      return DiceGameAwardMgr.dictionary_0.ContainsKey(DataId) ? DiceGameAwardMgr.dictionary_0[DataId] : (List<DiceGameAwardInfo>) null;
    }
  }
}
