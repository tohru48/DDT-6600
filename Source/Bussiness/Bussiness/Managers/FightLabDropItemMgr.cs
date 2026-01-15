// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.FightLabDropItemMgr
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
  public class FightLabDropItemMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<FightLabDropItemInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        FightLabDropItemInfo[] FightLabDropItem = FightLabDropItemMgr.LoadFightLabDropItemDb();
        Dictionary<int, List<FightLabDropItemInfo>> dictionary = FightLabDropItemMgr.LoadFightLabDropItems(FightLabDropItem);
        if (FightLabDropItem.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<FightLabDropItemInfo>>>(ref FightLabDropItemMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (FightLabDropItemMgr.ilog_0.IsErrorEnabled)
          FightLabDropItemMgr.ilog_0.Error((object) "ReLoad FightLabDropItem", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => FightLabDropItemMgr.ReLoad();

    public static FightLabDropItemInfo[] LoadFightLabDropItemDb()
    {
      FightLabDropItemInfo[] fightLabDropItem;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        fightLabDropItem = produceBussiness.GetAllFightLabDropItem();
      return fightLabDropItem;
    }

    public static Dictionary<int, List<FightLabDropItemInfo>> LoadFightLabDropItems(
      FightLabDropItemInfo[] FightLabDropItem)
    {
      Dictionary<int, List<FightLabDropItemInfo>> dictionary = new Dictionary<int, List<FightLabDropItemInfo>>();
      for (int index = 0; index < FightLabDropItem.Length; ++index)
      {
        FightLabDropItemInfo info = FightLabDropItem[index];
        if (!dictionary.Keys.Contains<int>(info.ID))
        {
          IEnumerable<FightLabDropItemInfo> source = Enumerable.Where<FightLabDropItemInfo>((IEnumerable<FightLabDropItemInfo>) FightLabDropItem, (Func<FightLabDropItemInfo, bool>) (s => s.ID == info.ID));
          dictionary.Add(info.ID, source.ToList<FightLabDropItemInfo>());
        }
      }
      return dictionary;
    }

    public static List<FightLabDropItemInfo> FindFightLabDropItem(int DataId)
    {
      return FightLabDropItemMgr.dictionary_0.ContainsKey(DataId) ? FightLabDropItemMgr.dictionary_0[DataId] : (List<FightLabDropItemInfo>) null;
    }
  }
}
