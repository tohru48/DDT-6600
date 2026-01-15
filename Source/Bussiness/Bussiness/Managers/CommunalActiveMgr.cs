// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.CommunalActiveMgr
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
  public class CommunalActiveMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, CommunalActiveInfo> dictionary_0 = new Dictionary<int, CommunalActiveInfo>();
    private static Dictionary<int, List<CommunalActiveExpInfo>> dictionary_1 = new Dictionary<int, List<CommunalActiveExpInfo>>();
    private static Dictionary<int, List<CommunalActiveAwardInfo>> dictionary_2 = new Dictionary<int, List<CommunalActiveAwardInfo>>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        CommunalActiveInfo[] communalActiveInfoArray = CommunalActiveMgr.LoadCommunalActiveDb();
        Dictionary<int, CommunalActiveInfo> dictionary1 = CommunalActiveMgr.LoadCommunalActives(communalActiveInfoArray);
        Dictionary<int, List<CommunalActiveExpInfo>> dictionary2 = CommunalActiveMgr.LoadCommunalActiveExps(communalActiveInfoArray);
        Dictionary<int, List<CommunalActiveAwardInfo>> dictionary3 = CommunalActiveMgr.LoadCommunalActiveAwards(communalActiveInfoArray);
        if (communalActiveInfoArray.Length > 0)
        {
          Interlocked.Exchange<Dictionary<int, CommunalActiveInfo>>(ref CommunalActiveMgr.dictionary_0, dictionary1);
          Interlocked.Exchange<Dictionary<int, List<CommunalActiveExpInfo>>>(ref CommunalActiveMgr.dictionary_1, dictionary2);
          Interlocked.Exchange<Dictionary<int, List<CommunalActiveAwardInfo>>>(ref CommunalActiveMgr.dictionary_2, dictionary3);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (CommunalActiveMgr.ilog_0.IsErrorEnabled)
          CommunalActiveMgr.ilog_0.Error((object) "ReLoad CommunalActive", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => CommunalActiveMgr.ReLoad();

    public static Dictionary<int, List<CommunalActiveAwardInfo>> LoadCommunalActiveAwards(
      CommunalActiveInfo[] CommunalActives)
    {
      Dictionary<int, List<CommunalActiveAwardInfo>> dictionary = new Dictionary<int, List<CommunalActiveAwardInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        CommunalActiveAwardInfo[] communalActiveAward = produceBussiness.GetAllCommunalActiveAward();
        for (int index = 0; index < CommunalActives.Length; ++index)
        {
          CommunalActiveInfo info = CommunalActives[index];
          if (!dictionary.Keys.Contains<int>(info.ActiveID))
          {
            IEnumerable<CommunalActiveAwardInfo> source = Enumerable.Where<CommunalActiveAwardInfo>((IEnumerable<CommunalActiveAwardInfo>) communalActiveAward, (Func<CommunalActiveAwardInfo, bool>) (s => s.ActiveID == info.ActiveID));
            dictionary.Add(info.ActiveID, source.ToList<CommunalActiveAwardInfo>());
          }
        }
      }
      return dictionary;
    }

    public static List<CommunalActiveAwardInfo> FindCommunalActiveAward(int ActiveID)
    {
      return CommunalActiveMgr.dictionary_2.ContainsKey(ActiveID) ? CommunalActiveMgr.dictionary_2[ActiveID] : (List<CommunalActiveAwardInfo>) null;
    }

    public static Dictionary<int, List<CommunalActiveExpInfo>> LoadCommunalActiveExps(
      CommunalActiveInfo[] CommunalActives)
    {
      Dictionary<int, List<CommunalActiveExpInfo>> dictionary = new Dictionary<int, List<CommunalActiveExpInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        CommunalActiveExpInfo[] communalActiveExp = produceBussiness.GetAllCommunalActiveExp();
        for (int index = 0; index < CommunalActives.Length; ++index)
        {
          CommunalActiveInfo info = CommunalActives[index];
          if (!dictionary.Keys.Contains<int>(info.ActiveID))
          {
            IEnumerable<CommunalActiveExpInfo> source = Enumerable.Where<CommunalActiveExpInfo>((IEnumerable<CommunalActiveExpInfo>) communalActiveExp, (Func<CommunalActiveExpInfo, bool>) (s => s.ActiveID == info.ActiveID));
            dictionary.Add(info.ActiveID, source.ToList<CommunalActiveExpInfo>());
          }
        }
      }
      return dictionary;
    }

    public static List<CommunalActiveExpInfo> FindCommunalActiveExp(int ActiveID)
    {
      return CommunalActiveMgr.dictionary_1.ContainsKey(ActiveID) ? CommunalActiveMgr.dictionary_1[ActiveID] : (List<CommunalActiveExpInfo>) null;
    }

    public static CommunalActiveInfo[] LoadCommunalActiveDb()
    {
      CommunalActiveInfo[] allCommunalActive;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allCommunalActive = produceBussiness.GetAllCommunalActive();
      return allCommunalActive;
    }

    public static Dictionary<int, CommunalActiveInfo> LoadCommunalActives(
      CommunalActiveInfo[] CommunalActive)
    {
      Dictionary<int, CommunalActiveInfo> dictionary = new Dictionary<int, CommunalActiveInfo>();
      for (int index = 0; index < CommunalActive.Length; ++index)
      {
        CommunalActiveInfo communalActiveInfo = CommunalActive[index];
        if (!dictionary.Keys.Contains<int>(communalActiveInfo.ActiveID))
          dictionary.Add(communalActiveInfo.ActiveID, communalActiveInfo);
      }
      return dictionary;
    }

    public static CommunalActiveInfo FindCommunalActive(int ActiveID)
    {
      return CommunalActiveMgr.dictionary_0.ContainsKey(ActiveID) ? CommunalActiveMgr.dictionary_0[ActiveID] : (CommunalActiveInfo) null;
    }

    public static CommunalActiveInfo[] GetAllCommunalActives()
    {
      return CommunalActiveMgr.dictionary_0.Values.ToArray<CommunalActiveInfo>();
    }
  }
}
