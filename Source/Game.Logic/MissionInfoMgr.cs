// Decompiled with JetBrains decompiler
// Type: Game.Logic.MissionInfoMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public static class MissionInfoMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, MissionInfo> dictionary_0 = new Dictionary<int, MissionInfo>();
    private static ReaderWriterLock readerWriterLock_0 = new ReaderWriterLock();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool Init() => MissionInfoMgr.Reload();

    public static bool Reload()
    {
      try
      {
        Dictionary<int, MissionInfo> dictionary = MissionInfoMgr.smethod_0();
        if (dictionary.Count > 0)
          Interlocked.Exchange<Dictionary<int, MissionInfo>>(ref MissionInfoMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        MissionInfoMgr.ilog_0.Error((object) nameof (MissionInfoMgr), ex);
      }
      return false;
    }

    private static Dictionary<int, MissionInfo> smethod_0()
    {
      Dictionary<int, MissionInfo> dictionary = new Dictionary<int, MissionInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (MissionInfo missionInfo in produceBussiness.GetAllMissionInfo())
        {
          if (!dictionary.ContainsKey(missionInfo.Id))
            dictionary.Add(missionInfo.Id, missionInfo);
        }
      }
      return dictionary;
    }

    public static MissionInfo GetMissionInfo(int id)
    {
      return MissionInfoMgr.dictionary_0.ContainsKey(id) ? MissionInfoMgr.dictionary_0[id] : (MissionInfo) null;
    }
  }
}
