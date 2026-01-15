// Decompiled with JetBrains decompiler
// Type: Game.Logic.PveInfoMgr
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
  public static class PveInfoMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, PveInfo> dictionary_0 = new Dictionary<int, PveInfo>();
    private static ReaderWriterLock readerWriterLock_0 = new ReaderWriterLock();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool Init() => PveInfoMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, PveInfo> dictionary = PveInfoMgr.LoadFromDatabase();
        if (dictionary.Count > 0)
          Interlocked.Exchange<Dictionary<int, PveInfo>>(ref PveInfoMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        PveInfoMgr.ilog_0.Error((object) nameof (PveInfoMgr), ex);
      }
      return false;
    }

    public static Dictionary<int, PveInfo> LoadFromDatabase()
    {
      Dictionary<int, PveInfo> dictionary = new Dictionary<int, PveInfo>();
      using (PveBussiness pveBussiness = new PveBussiness())
      {
        foreach (PveInfo allPveInfo in pveBussiness.GetAllPveInfos())
        {
          if (!dictionary.ContainsKey(allPveInfo.ID))
            dictionary.Add(allPveInfo.ID, allPveInfo);
        }
      }
      return dictionary;
    }

    public static PveInfo GetPveInfoById(int id)
    {
      return PveInfoMgr.dictionary_0.ContainsKey(id) ? PveInfoMgr.dictionary_0[id] : (PveInfo) null;
    }

    public static PveInfo[] GetPveInfo()
    {
      if (PveInfoMgr.dictionary_0 == null)
        PveInfoMgr.ReLoad();
      return PveInfoMgr.dictionary_0.Values.ToArray<PveInfo>();
    }

    public static PveInfo GetPveInfoByType(eRoomType roomType, int levelLimits)
    {
      switch (roomType)
      {
        case eRoomType.Exploration:
          using (Dictionary<int, PveInfo>.ValueCollection.Enumerator enumerator = PveInfoMgr.dictionary_0.Values.GetEnumerator())
          {
            while (enumerator.MoveNext())
            {
              PveInfo current = enumerator.Current;
              if ((eRoomType) current.Type == roomType && current.LevelLimits == levelLimits)
                return current;
            }
            break;
          }
        case eRoomType.Dungeon:
        case eRoomType.FightLib:
        case eRoomType.Freshman:
        case eRoomType.AcademyDungeon:
        case eRoomType.Lanbyrinth:
        case eRoomType.ConsortiaBoss:
        case eRoomType.ActivityDungeon:
        case eRoomType.SpecialActivityDungeon:
          using (Dictionary<int, PveInfo>.ValueCollection.Enumerator enumerator = PveInfoMgr.dictionary_0.Values.GetEnumerator())
          {
            while (enumerator.MoveNext())
            {
              PveInfo current = enumerator.Current;
              if ((eRoomType) current.Type == roomType)
                return current;
            }
            break;
          }
      }
      return (PveInfo) null;
    }
  }
}
