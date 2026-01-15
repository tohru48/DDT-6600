// Decompiled with JetBrains decompiler
// Type: Game.Server.Managers.FairBattleRewardMgr
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
  public class FairBattleRewardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, FairBattleRewardInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool Init()
    {
      bool flag;
      try
      {
        FairBattleRewardMgr.dictionary_0 = new Dictionary<int, FairBattleRewardInfo>();
        FairBattleRewardMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = FairBattleRewardMgr.smethod_0(FairBattleRewardMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (FairBattleRewardMgr.ilog_0.IsErrorEnabled)
          FairBattleRewardMgr.ilog_0.Error((object) nameof (FairBattleRewardMgr), ex);
        flag = false;
      }
      return flag;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, FairBattleRewardInfo> Level = new Dictionary<int, FairBattleRewardInfo>();
        if (FairBattleRewardMgr.smethod_0(Level))
        {
          try
          {
            FairBattleRewardMgr.dictionary_0 = Level;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (FairBattleRewardMgr.ilog_0.IsErrorEnabled)
          FairBattleRewardMgr.ilog_0.Error((object) "FairBattleMgr", ex);
      }
      return false;
    }

    private static bool smethod_0(Dictionary<int, FairBattleRewardInfo> Level)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (FairBattleRewardInfo battleRewardInfo in playerBussiness.GetAllFairBattleReward())
        {
          if (!Level.ContainsKey(battleRewardInfo.Level))
            Level.Add(battleRewardInfo.Level, battleRewardInfo);
        }
      }
      return true;
    }

    public static FairBattleRewardInfo FindLevel(int Level)
    {
      try
      {
        if (FairBattleRewardMgr.dictionary_0.ContainsKey(Level))
          return FairBattleRewardMgr.dictionary_0[Level];
      }
      catch
      {
      }
      return (FairBattleRewardInfo) null;
    }

    public static FairBattleRewardInfo GetBattleDataByPrestige(int Prestige)
    {
      for (int key = FairBattleRewardMgr.dictionary_0.Values.Count - 1; key >= 0; --key)
      {
        if (Prestige >= FairBattleRewardMgr.dictionary_0[key].Prestige)
          return FairBattleRewardMgr.dictionary_0[key];
      }
      return (FairBattleRewardInfo) null;
    }

    public static int MaxLevel()
    {
      if (FairBattleRewardMgr.dictionary_0 == null)
        FairBattleRewardMgr.Init();
      return FairBattleRewardMgr.dictionary_0.Values.Count;
    }

    public static int GetLevel(int GP)
    {
      if (GP >= FairBattleRewardMgr.FindLevel(FairBattleRewardMgr.MaxLevel()).Prestige)
        return FairBattleRewardMgr.MaxLevel();
      for (int Level = 1; Level <= FairBattleRewardMgr.MaxLevel(); ++Level)
      {
        if (GP < FairBattleRewardMgr.FindLevel(Level).Prestige)
          return Level - 1 != 0 ? Level - 1 : 1;
      }
      return 1;
    }

    public static int GetGP(int level)
    {
      return FairBattleRewardMgr.MaxLevel() > level && level > 0 ? FairBattleRewardMgr.FindLevel(level - 1).Prestige : 0;
    }
  }
}
