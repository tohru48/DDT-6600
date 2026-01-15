// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.AccumulActiveLoginMgr
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
  public static class AccumulActiveLoginMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static AccumulAtiveLoginAwardInfo[] accumulAtiveLoginAwardInfo_0;
    private static Dictionary<int, List<AccumulAtiveLoginAwardInfo>> dictionary_0 = new Dictionary<int, List<AccumulAtiveLoginAwardInfo>>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        AccumulAtiveLoginAwardInfo[] AccumulAtiveLoginAwards = AccumulActiveLoginMgr.LoadAccumulAtiveLoginAwardDb();
        Dictionary<int, List<AccumulAtiveLoginAwardInfo>> dictionary = AccumulActiveLoginMgr.LoadAccumulAtiveLoginAwards(AccumulAtiveLoginAwards);
        if (AccumulAtiveLoginAwards != null)
        {
          Interlocked.Exchange<AccumulAtiveLoginAwardInfo[]>(ref AccumulActiveLoginMgr.accumulAtiveLoginAwardInfo_0, AccumulAtiveLoginAwards);
          Interlocked.Exchange<Dictionary<int, List<AccumulAtiveLoginAwardInfo>>>(ref AccumulActiveLoginMgr.dictionary_0, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (AccumulActiveLoginMgr.ilog_0.IsErrorEnabled)
          AccumulActiveLoginMgr.ilog_0.Error((object) nameof (ReLoad), ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => AccumulActiveLoginMgr.ReLoad();

    public static AccumulAtiveLoginAwardInfo[] LoadAccumulAtiveLoginAwardDb()
    {
      AccumulAtiveLoginAwardInfo[] ativeLoginAwardInfos;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        ativeLoginAwardInfos = produceBussiness.GetAccumulAtiveLoginAwardInfos();
      return ativeLoginAwardInfos;
    }

    public static Dictionary<int, List<AccumulAtiveLoginAwardInfo>> LoadAccumulAtiveLoginAwards(
      AccumulAtiveLoginAwardInfo[] AccumulAtiveLoginAwards)
    {
      Dictionary<int, List<AccumulAtiveLoginAwardInfo>> dictionary = new Dictionary<int, List<AccumulAtiveLoginAwardInfo>>();
      for (int index = 0; index < AccumulAtiveLoginAwards.Length; ++index)
      {
        AccumulAtiveLoginAwardInfo info = AccumulAtiveLoginAwards[index];
        if (!dictionary.Keys.Contains<int>(info.Count))
        {
          IEnumerable<AccumulAtiveLoginAwardInfo> source = Enumerable.Where<AccumulAtiveLoginAwardInfo>((IEnumerable<AccumulAtiveLoginAwardInfo>) AccumulAtiveLoginAwards, (Func<AccumulAtiveLoginAwardInfo, bool>) (s => s.Count == info.Count));
          dictionary.Add(info.Count, source.ToList<AccumulAtiveLoginAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<AccumulAtiveLoginAwardInfo> FindAccumulAtiveLoginAward(int Count)
    {
      return AccumulActiveLoginMgr.dictionary_0.ContainsKey(Count) ? AccumulActiveLoginMgr.dictionary_0[Count] : (List<AccumulAtiveLoginAwardInfo>) null;
    }

    public static List<SqlDataProvider.Data.ItemInfo> GetAllAccumulAtiveLoginAward(int Count)
    {
      List<AccumulAtiveLoginAwardInfo> accumulAtiveLoginAward1 = AccumulActiveLoginMgr.FindAccumulAtiveLoginAward(Count);
      List<SqlDataProvider.Data.ItemInfo> accumulAtiveLoginAward2 = new List<SqlDataProvider.Data.ItemInfo>();
      if (accumulAtiveLoginAward1 != null)
      {
        foreach (AccumulAtiveLoginAwardInfo ativeLoginAwardInfo in accumulAtiveLoginAward1)
        {
          SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(ativeLoginAwardInfo.RewardItemID), ativeLoginAwardInfo.RewardItemCount, 105);
          fromTemplate.IsBinds = ativeLoginAwardInfo.IsBind;
          fromTemplate.ValidDate = ativeLoginAwardInfo.RewardItemValid;
          fromTemplate.StrengthenLevel = ativeLoginAwardInfo.StrengthenLevel;
          fromTemplate.AttackCompose = ativeLoginAwardInfo.AttackCompose;
          fromTemplate.DefendCompose = ativeLoginAwardInfo.DefendCompose;
          fromTemplate.AgilityCompose = ativeLoginAwardInfo.AgilityCompose;
          fromTemplate.LuckCompose = ativeLoginAwardInfo.LuckCompose;
          accumulAtiveLoginAward2.Add(fromTemplate);
        }
      }
      return accumulAtiveLoginAward2;
    }

    public static List<SqlDataProvider.Data.ItemInfo> GetSelecedAccumulAtiveLoginAward(int ID)
    {
      List<SqlDataProvider.Data.ItemInfo> accumulAtiveLoginAward1 = new List<SqlDataProvider.Data.ItemInfo>();
      List<AccumulAtiveLoginAwardInfo> accumulAtiveLoginAward2 = AccumulActiveLoginMgr.FindAccumulAtiveLoginAward(7);
      if (accumulAtiveLoginAward2 != null)
      {
        foreach (AccumulAtiveLoginAwardInfo ativeLoginAwardInfo in accumulAtiveLoginAward2)
        {
          if (ID == ativeLoginAwardInfo.ID)
          {
            SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(ativeLoginAwardInfo.RewardItemID), ativeLoginAwardInfo.RewardItemCount, 105);
            fromTemplate.IsBinds = ativeLoginAwardInfo.IsBind;
            fromTemplate.ValidDate = ativeLoginAwardInfo.RewardItemValid;
            fromTemplate.StrengthenLevel = ativeLoginAwardInfo.StrengthenLevel;
            fromTemplate.AttackCompose = ativeLoginAwardInfo.AttackCompose;
            fromTemplate.DefendCompose = ativeLoginAwardInfo.DefendCompose;
            fromTemplate.AgilityCompose = ativeLoginAwardInfo.AgilityCompose;
            fromTemplate.LuckCompose = ativeLoginAwardInfo.LuckCompose;
            accumulAtiveLoginAward1.Add(fromTemplate);
            break;
          }
        }
      }
      return accumulAtiveLoginAward1;
    }
  }
}
