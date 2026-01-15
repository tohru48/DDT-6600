// Decompiled with JetBrains decompiler
// Type: Game.Server.Managers.ConsortiaExtraMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Game.Server.Managers
{
  public class ConsortiaExtraMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ConsortiaLevelInfo> dictionary_0;
    private static Dictionary<int, ConsortiaBufferTempInfo> dictionary_1;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ConsortiaLevelInfo> consortiaLevel = new Dictionary<int, ConsortiaLevelInfo>();
        Dictionary<int, ConsortiaBufferTempInfo> consortiaBuffTemp = new Dictionary<int, ConsortiaBufferTempInfo>();
        if (ConsortiaExtraMgr.smethod_0(consortiaLevel, consortiaBuffTemp))
        {
          try
          {
            ConsortiaExtraMgr.dictionary_0 = consortiaLevel;
            ConsortiaExtraMgr.dictionary_1 = consortiaBuffTemp;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (ConsortiaExtraMgr.ilog_0.IsErrorEnabled)
          ConsortiaExtraMgr.ilog_0.Error((object) "ConsortiaLevelMgr", ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        ConsortiaExtraMgr.dictionary_0 = new Dictionary<int, ConsortiaLevelInfo>();
        ConsortiaExtraMgr.dictionary_1 = new Dictionary<int, ConsortiaBufferTempInfo>();
        ConsortiaExtraMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = ConsortiaExtraMgr.smethod_0(ConsortiaExtraMgr.dictionary_0, ConsortiaExtraMgr.dictionary_1);
      }
      catch (Exception ex)
      {
        if (ConsortiaExtraMgr.ilog_0.IsErrorEnabled)
          ConsortiaExtraMgr.ilog_0.Error((object) "ConsortiaLevelMgr", ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(
      Dictionary<int, ConsortiaLevelInfo> consortiaLevel,
      Dictionary<int, ConsortiaBufferTempInfo> consortiaBuffTemp)
    {
      using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
      {
        foreach (ConsortiaLevelInfo consortiaLevelInfo in consortiaBussiness.GetAllConsortiaLevel())
        {
          if (!consortiaLevel.ContainsKey(consortiaLevelInfo.Level))
            consortiaLevel.Add(consortiaLevelInfo.Level, consortiaLevelInfo);
        }
        foreach (ConsortiaBufferTempInfo consortiaBufferTempInfo in consortiaBussiness.GetAllConsortiaBuffTemp())
        {
          if (!consortiaBuffTemp.ContainsKey(consortiaBufferTempInfo.id))
            consortiaBuffTemp.Add(consortiaBufferTempInfo.id, consortiaBufferTempInfo);
        }
      }
      return true;
    }

    public static ConsortiaLevelInfo FindConsortiaLevelInfo(int level)
    {
      try
      {
        if (ConsortiaExtraMgr.dictionary_0.ContainsKey(level))
          return ConsortiaExtraMgr.dictionary_0[level];
      }
      catch
      {
      }
      return (ConsortiaLevelInfo) null;
    }

    public static ConsortiaBufferTempInfo FindConsortiaBuffInfo(int id)
    {
      try
      {
        if (ConsortiaExtraMgr.dictionary_1.ContainsKey(id))
          return ConsortiaExtraMgr.dictionary_1[id];
      }
      catch
      {
      }
      return (ConsortiaBufferTempInfo) null;
    }

    public static List<ConsortiaBufferTempInfo> GetAllConsortiaBuff()
    {
      List<ConsortiaBufferTempInfo> allConsortiaBuff = new List<ConsortiaBufferTempInfo>();
      try
      {
        foreach (ConsortiaBufferTempInfo consortiaBufferTempInfo in ConsortiaExtraMgr.dictionary_1.Values)
          allConsortiaBuff.Add(consortiaBufferTempInfo);
      }
      catch
      {
      }
      return allConsortiaBuff;
    }
  }
}
