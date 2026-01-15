// Decompiled with JetBrains decompiler
// Type: Game.Logic.PropItemMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class PropItemMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();
    private static ReaderWriterLock readerWriterLock_0;
    private static Dictionary<int, ItemTemplateInfo> dictionary_0;
    private static int[] int_0 = new int[8]
    {
      10001,
      10002,
      10003,
      10004,
      10005,
      10006,
      10007,
      10008
    };

    public static bool Reload()
    {
      try
      {
        Dictionary<int, ItemTemplateInfo> allProp = new Dictionary<int, ItemTemplateInfo>();
        if (PropItemMgr.smethod_0(allProp))
        {
          PropItemMgr.readerWriterLock_0.AcquireWriterLock(-1);
          try
          {
            PropItemMgr.dictionary_0 = allProp;
            return true;
          }
          catch
          {
          }
          finally
          {
            PropItemMgr.readerWriterLock_0.ReleaseWriterLock();
          }
        }
      }
      catch (Exception ex)
      {
        if (PropItemMgr.ilog_0.IsErrorEnabled)
          PropItemMgr.ilog_0.Error((object) "ReloadProps", ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        PropItemMgr.readerWriterLock_0 = new ReaderWriterLock();
        PropItemMgr.dictionary_0 = new Dictionary<int, ItemTemplateInfo>();
        flag = PropItemMgr.smethod_0(PropItemMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (PropItemMgr.ilog_0.IsErrorEnabled)
          PropItemMgr.ilog_0.Error((object) "InitProps", ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(Dictionary<int, ItemTemplateInfo> allProp)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ItemTemplateInfo itemTemplateInfo in produceBussiness.GetSingleCategory(10))
          allProp.Add(itemTemplateInfo.TemplateID, itemTemplateInfo);
      }
      return true;
    }

    public static ItemTemplateInfo FindAllProp(int id)
    {
      PropItemMgr.readerWriterLock_0.AcquireReaderLock(-1);
      try
      {
        if (PropItemMgr.dictionary_0.ContainsKey(id))
          return PropItemMgr.dictionary_0[id];
      }
      catch
      {
      }
      finally
      {
        PropItemMgr.readerWriterLock_0.ReleaseReaderLock();
      }
      return (ItemTemplateInfo) null;
    }

    public static ItemTemplateInfo FindFightingProp(int id)
    {
      PropItemMgr.readerWriterLock_0.AcquireReaderLock(-1);
      try
      {
        if (!((IEnumerable<int>) PropItemMgr.int_0).Contains<int>(id))
          return (ItemTemplateInfo) null;
        if (PropItemMgr.dictionary_0.ContainsKey(id))
          return PropItemMgr.dictionary_0[id];
      }
      catch
      {
      }
      finally
      {
        PropItemMgr.readerWriterLock_0.ReleaseReaderLock();
      }
      return (ItemTemplateInfo) null;
    }
  }
}
