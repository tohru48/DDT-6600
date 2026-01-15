// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.FightSpiritTemplateMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class FightSpiritTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, FightSpiritTemplateInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, FightSpiritTemplateInfo> consortiaLevel = new Dictionary<int, FightSpiritTemplateInfo>();
        if (FightSpiritTemplateMgr.smethod_0(consortiaLevel))
        {
          try
          {
            FightSpiritTemplateMgr.dictionary_0 = consortiaLevel;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (FightSpiritTemplateMgr.ilog_0.IsErrorEnabled)
          FightSpiritTemplateMgr.ilog_0.Error((object) "ConsortiaLevelMgr", ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        FightSpiritTemplateMgr.dictionary_0 = new Dictionary<int, FightSpiritTemplateInfo>();
        FightSpiritTemplateMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = FightSpiritTemplateMgr.smethod_0(FightSpiritTemplateMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (FightSpiritTemplateMgr.ilog_0.IsErrorEnabled)
          FightSpiritTemplateMgr.ilog_0.Error((object) "ConsortiaLevelMgr", ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(
      Dictionary<int, FightSpiritTemplateInfo> consortiaLevel)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (FightSpiritTemplateInfo spiritTemplateInfo in playerBussiness.GetAllFightSpiritTemplate())
        {
          if (!consortiaLevel.ContainsKey(spiritTemplateInfo.ID))
            consortiaLevel.Add(spiritTemplateInfo.ID, spiritTemplateInfo);
        }
      }
      return true;
    }

    public static FightSpiritTemplateInfo FindFightSpiritTemplateInfo(int FigSpiritId, int lv)
    {
      try
      {
        foreach (FightSpiritTemplateInfo spiritTemplateInfo in FightSpiritTemplateMgr.dictionary_0.Values)
        {
          if (spiritTemplateInfo.FightSpiritID == FigSpiritId && spiritTemplateInfo.Level == lv)
            return spiritTemplateInfo;
        }
      }
      catch
      {
      }
      return (FightSpiritTemplateInfo) null;
    }

    public static int getProp(int FigSpiritId, int lv, int place)
    {
      FightSpiritTemplateInfo spiritTemplateInfo = FightSpiritTemplateMgr.FindFightSpiritTemplateInfo(FigSpiritId, lv);
      switch (place)
      {
        case 2:
          return spiritTemplateInfo.Attack;
        case 3:
          return spiritTemplateInfo.Lucky;
        case 5:
          return spiritTemplateInfo.Agility;
        case 11:
          return spiritTemplateInfo.Defence;
        case 13:
          return spiritTemplateInfo.Blood;
        default:
          return 0;
      }
    }
  }
}
