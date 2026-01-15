// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.DropMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Bussiness.Protocol;
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
  public class DropMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static string[] string_0 = Enum.GetNames(typeof (eDropType));
    private static List<DropCondiction> list_0 = new List<DropCondiction>();
    private static Dictionary<int, List<DropItem>> dictionary_0 = new Dictionary<int, List<DropItem>>();

    public static bool Init() => DropMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        List<DropCondiction> dropCondictionList = DropMgr.LoadDropConditionDb();
        Interlocked.Exchange<List<DropCondiction>>(ref DropMgr.list_0, dropCondictionList);
        Dictionary<int, List<DropItem>> dictionary = DropMgr.LoadDropItemDb();
        Interlocked.Exchange<Dictionary<int, List<DropItem>>>(ref DropMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        DropMgr.ilog_0.Error((object) nameof (DropMgr), ex);
      }
      return false;
    }

    public static List<DropCondiction> LoadDropConditionDb()
    {
      List<DropCondiction> list;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        DropCondiction[] allDropCondictions = produceBussiness.GetAllDropCondictions();
        list = allDropCondictions != null ? ((IEnumerable<DropCondiction>) allDropCondictions).ToList<DropCondiction>() : (List<DropCondiction>) null;
      }
      return list;
    }

    public static Dictionary<int, List<DropItem>> LoadDropItemDb()
    {
      Dictionary<int, List<DropItem>> dictionary = new Dictionary<int, List<DropItem>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        DropItem[] allDropItems = produceBussiness.GetAllDropItems();
        foreach (DropCondiction dropCondiction in DropMgr.list_0)
        {
          DropCondiction info = dropCondiction;
          IEnumerable<DropItem> source = Enumerable.Where<DropItem>((IEnumerable<DropItem>) allDropItems, (Func<DropItem, bool>) (s => s.DropId == info.DropId));
          dictionary.Add(info.DropId, source.ToList<DropItem>());
        }
      }
      return dictionary;
    }

    public static int FindCondiction(eDropType type, string para1, string para2)
    {
      string str1 = "," + para1 + ",";
      string str2 = "," + para2 + ",";
      foreach (DropCondiction dropCondiction in DropMgr.list_0)
      {
        if ((eDropType) dropCondiction.CondictionType == type && dropCondiction.Para1.IndexOf(str1) != -1 && dropCondiction.Para2.IndexOf(str2) != -1)
          return dropCondiction.DropId;
      }
      return 0;
    }

    public static List<DropItem> FindDropItem(int dropId)
    {
      return DropMgr.dictionary_0.ContainsKey(dropId) ? DropMgr.dictionary_0[dropId] : (List<DropItem>) null;
    }
  }
}
