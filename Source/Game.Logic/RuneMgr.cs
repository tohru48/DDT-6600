// Decompiled with JetBrains decompiler
// Type: Game.Logic.RuneMgr
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

#nullable disable
namespace Game.Logic
{
  public class RuneMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, RuneTemplateInfo> aiYouYhlUA;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, RuneTemplateInfo> infos = new Dictionary<int, RuneTemplateInfo>();
        if (RuneMgr.LoadItem(infos))
        {
          try
          {
            RuneMgr.aiYouYhlUA = infos;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (RuneMgr.ilog_0.IsErrorEnabled)
          RuneMgr.ilog_0.Error((object) nameof (ReLoad), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        RuneMgr.aiYouYhlUA = new Dictionary<int, RuneTemplateInfo>();
        flag = RuneMgr.LoadItem(RuneMgr.aiYouYhlUA);
      }
      catch (Exception ex)
      {
        if (RuneMgr.ilog_0.IsErrorEnabled)
          RuneMgr.ilog_0.Error((object) nameof (Init), ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadItem(Dictionary<int, RuneTemplateInfo> infos)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (RuneTemplateInfo runeTemplateInfo in produceBussiness.GetAllRuneTemplate())
        {
          if (!infos.Keys.Contains<int>(runeTemplateInfo.TemplateID))
            infos.Add(runeTemplateInfo.TemplateID, runeTemplateInfo);
        }
      }
      return true;
    }

    public static RuneTemplateInfo FindRuneByTemplateID(int templateID)
    {
      if (RuneMgr.aiYouYhlUA == null)
        RuneMgr.Init();
      return !RuneMgr.aiYouYhlUA.Keys.Contains<int>(templateID) ? (RuneTemplateInfo) null : RuneMgr.aiYouYhlUA[templateID];
    }

    public static RuneTemplateInfo FindRuneByTemplateID(int templateID, int lv)
    {
      foreach (RuneTemplateInfo runeByTemplateId in RuneMgr.GetListRuneByTemplate(templateID))
      {
        if (runeByTemplateId.BaseLevel >= lv)
          return runeByTemplateId;
      }
      return (RuneTemplateInfo) null;
    }

    public static List<RuneTemplateInfo> GetListRuneByTemplate(int templateID)
    {
      if (RuneMgr.aiYouYhlUA == null)
        RuneMgr.Init();
      List<RuneTemplateInfo> listRuneByTemplate = new List<RuneTemplateInfo>();
      int num = templateID;
      foreach (RuneTemplateInfo runeTemplateInfo in RuneMgr.aiYouYhlUA.Values)
      {
        if (runeTemplateInfo.TemplateID == num)
        {
          listRuneByTemplate.Add(runeTemplateInfo);
          num = runeTemplateInfo.NextTemplateID;
        }
      }
      return listRuneByTemplate;
    }

    public static int FindRuneExp(int lv) => lv < 0 ? 1 : GameProperties.RuneExp()[lv];

    public static int GetRuneLevel(int GP)
    {
      List<int> intList = GameProperties.RuneExp();
      if (GP >= intList[RuneMgr.MaxLv() - 1])
        return RuneMgr.MaxLv();
      for (int index = 0; index < intList.Count; ++index)
      {
        if (GP < intList[index])
          return index;
      }
      return 1;
    }

    public static int MaxLv() => GameProperties.RuneExp().Count;

    public static int MaxExp()
    {
      return GameProperties.RuneExp()[RuneMgr.MaxLv() - 1 < 0 ? 0 : RuneMgr.MaxLv() - 1];
    }
  }
}
