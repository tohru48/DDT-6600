// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.MissionEnergyMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public static class MissionEnergyMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, MissionEnergyInfo> dictionary_0 = new Dictionary<int, MissionEnergyInfo>();
    private static ReaderWriterLock readerWriterLock_0 = new ReaderWriterLock();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool Init() => MissionEnergyMgr.Reload();

    public static bool Reload()
    {
      try
      {
        Dictionary<int, MissionEnergyInfo> dictionary = MissionEnergyMgr.smethod_0();
        if (dictionary.Count > 0)
          Interlocked.Exchange<Dictionary<int, MissionEnergyInfo>>(ref MissionEnergyMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        MissionEnergyMgr.ilog_0.Error((object) "MissionEnergyInfoMgr", ex);
      }
      return false;
    }

    private static Dictionary<int, MissionEnergyInfo> smethod_0()
    {
      Dictionary<int, MissionEnergyInfo> dictionary = new Dictionary<int, MissionEnergyInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MissionEnergyInfo missionEnergyInfo in produceBussiness.GetAllMissionEnergyInfo())
        {
          if (!dictionary.ContainsKey(missionEnergyInfo.Count))
            dictionary.Add(missionEnergyInfo.Count, missionEnergyInfo);
        }
      }
      return dictionary;
    }

    public static MissionEnergyInfo GetMissionEnergyInfo(int id)
    {
      return MissionEnergyMgr.dictionary_0.ContainsKey(id) ? MissionEnergyMgr.dictionary_0[id] : (MissionEnergyInfo) null;
    }
  }
}
