// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ItemStrengThenDataMgr
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
  public class ItemStrengThenDataMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, List<ItemStrengThenDataInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        ItemStrengThenDataInfo[] ItemStrengThenData = ItemStrengThenDataMgr.LoadItemStrengThenDataDb();
        Dictionary<int, List<ItemStrengThenDataInfo>> dictionary = ItemStrengThenDataMgr.LoadItemStrengThenDatas(ItemStrengThenData);
        if (ItemStrengThenData.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<ItemStrengThenDataInfo>>>(ref ItemStrengThenDataMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (ItemStrengThenDataMgr.ilog_0.IsErrorEnabled)
          ItemStrengThenDataMgr.ilog_0.Error((object) "ReLoad ItemStrengThenData", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => ItemStrengThenDataMgr.ReLoad();

    public static ItemStrengThenDataInfo[] LoadItemStrengThenDataDb()
    {
      ItemStrengThenDataInfo[] itemStrengThenData;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        itemStrengThenData = produceBussiness.GetAllItemStrengThenData();
      return itemStrengThenData;
    }

    public static Dictionary<int, List<ItemStrengThenDataInfo>> LoadItemStrengThenDatas(
      ItemStrengThenDataInfo[] ItemStrengThenData)
    {
      Dictionary<int, List<ItemStrengThenDataInfo>> dictionary = new Dictionary<int, List<ItemStrengThenDataInfo>>();
      for (int index = 0; index < ItemStrengThenData.Length; ++index)
      {
        ItemStrengThenDataInfo info = ItemStrengThenData[index];
        if (!dictionary.Keys.Contains<int>(info.TemplateID))
        {
          IEnumerable<ItemStrengThenDataInfo> source = Enumerable.Where<ItemStrengThenDataInfo>((IEnumerable<ItemStrengThenDataInfo>) ItemStrengThenData, (Func<ItemStrengThenDataInfo, bool>) (s => s.TemplateID == info.TemplateID));
          dictionary.Add(info.TemplateID, source.ToList<ItemStrengThenDataInfo>());
        }
      }
      return dictionary;
    }

    public static List<ItemStrengThenDataInfo> FindItemStrengThenData(int DataId)
    {
      return ItemStrengThenDataMgr.dictionary_0.ContainsKey(DataId) ? ItemStrengThenDataMgr.dictionary_0[DataId] : (List<ItemStrengThenDataInfo>) null;
    }
  }
}
