// Decompiled with JetBrains decompiler
// Type: Game.Logic.NPCInfoMgr
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
  public static class NPCInfoMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, NpcInfo> dictionary_0 = new Dictionary<int, NpcInfo>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool Init() => NPCInfoMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, NpcInfo> dictionary = NPCInfoMgr.smethod_0();
        if (dictionary != null && dictionary.Count > 0)
          Interlocked.Exchange<Dictionary<int, NpcInfo>>(ref NPCInfoMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        NPCInfoMgr.ilog_0.Error((object) nameof (NPCInfoMgr), ex);
      }
      return false;
    }

    private static Dictionary<int, NpcInfo> smethod_0()
    {
      Dictionary<int, NpcInfo> dictionary = new Dictionary<int, NpcInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (NpcInfo npcInfo in produceBussiness.GetAllNPCInfo())
        {
          if (!dictionary.ContainsKey(npcInfo.ID))
            dictionary.Add(npcInfo.ID, npcInfo);
        }
      }
      return dictionary;
    }

    public static NpcInfo GetNpcInfoById(int id)
    {
      return NPCInfoMgr.dictionary_0.ContainsKey(id) ? NPCInfoMgr.dictionary_0[id] : (NpcInfo) null;
    }
  }
}
