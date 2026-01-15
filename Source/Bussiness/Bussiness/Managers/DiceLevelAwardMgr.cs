// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.DiceLevelAwardMgr
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
  public class DiceLevelAwardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<DiceLevelAwardInfo>> dictionary_0;
    private static ThreadSafeRandom pNgqEgypOn = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        DiceLevelAwardInfo[] DiceLevelAwards = DiceLevelAwardMgr.LoadDiceLevelAwardDb();
        Dictionary<int, List<DiceLevelAwardInfo>> dictionary = DiceLevelAwardMgr.LoadDiceLevelAwards(DiceLevelAwards);
        if (DiceLevelAwards.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<DiceLevelAwardInfo>>>(ref DiceLevelAwardMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (DiceLevelAwardMgr.ilog_0.IsErrorEnabled)
          DiceLevelAwardMgr.ilog_0.Error((object) "ReLoad DiceLevelAwardMgr", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => DiceLevelAwardMgr.ReLoad();

    public static DiceLevelAwardInfo[] LoadDiceLevelAwardDb()
    {
      DiceLevelAwardInfo[] diceLevelAwardInfos;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        diceLevelAwardInfos = produceBussiness.GetDiceLevelAwardInfos();
      return diceLevelAwardInfos;
    }

    public static Dictionary<int, List<DiceLevelAwardInfo>> LoadDiceLevelAwards(
      DiceLevelAwardInfo[] DiceLevelAwards)
    {
      Dictionary<int, List<DiceLevelAwardInfo>> dictionary = new Dictionary<int, List<DiceLevelAwardInfo>>();
      for (int index = 0; index < DiceLevelAwards.Length; ++index)
      {
        DiceLevelAwardInfo info = DiceLevelAwards[index];
        if (!dictionary.Keys.Contains<int>(info.DiceLevel))
        {
          IEnumerable<DiceLevelAwardInfo> source = Enumerable.Where<DiceLevelAwardInfo>((IEnumerable<DiceLevelAwardInfo>) DiceLevelAwards, (Func<DiceLevelAwardInfo, bool>) (s => s.DiceLevel == info.DiceLevel));
          dictionary.Add(info.DiceLevel, source.ToList<DiceLevelAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<DiceLevelAwardInfo> FindDiceLevelAward(int DataId)
    {
      return DiceLevelAwardMgr.dictionary_0.ContainsKey(DataId) ? DiceLevelAwardMgr.dictionary_0[DataId] : (List<DiceLevelAwardInfo>) null;
    }
  }
}
