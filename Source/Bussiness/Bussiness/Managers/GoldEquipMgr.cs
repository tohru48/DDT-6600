// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.GoldEquipMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class GoldEquipMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, GoldEquipTemplateInfo> dictionary_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, GoldEquipTemplateInfo> infos = new Dictionary<int, GoldEquipTemplateInfo>();
        if (GoldEquipMgr.LoadItem(infos))
        {
          try
          {
            GoldEquipMgr.dictionary_0 = infos;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (GoldEquipMgr.ilog_0.IsErrorEnabled)
          GoldEquipMgr.ilog_0.Error((object) nameof (ReLoad), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        GoldEquipMgr.dictionary_0 = new Dictionary<int, GoldEquipTemplateInfo>();
        flag = GoldEquipMgr.LoadItem(GoldEquipMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (GoldEquipMgr.ilog_0.IsErrorEnabled)
          GoldEquipMgr.ilog_0.Error((object) nameof (Init), ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadItem(Dictionary<int, GoldEquipTemplateInfo> infos)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (GoldEquipTemplateInfo equipTemplateInfo in produceBussiness.GetAllGoldEquipTemplateLoad())
        {
          if (!infos.Keys.Contains<int>(equipTemplateInfo.OldTemplateId))
            infos.Add(equipTemplateInfo.OldTemplateId, equipTemplateInfo);
        }
      }
      return true;
    }

    public static GoldEquipTemplateInfo FindGoldEquipByTemplate(int templateId)
    {
      if (GoldEquipMgr.dictionary_0 == null)
        GoldEquipMgr.Init();
      try
      {
        if (GoldEquipMgr.dictionary_0.Keys.Contains<int>(templateId))
          return GoldEquipMgr.dictionary_0[templateId];
      }
      catch
      {
      }
      return (GoldEquipTemplateInfo) null;
    }

    public static GoldEquipTemplateInfo FindGoldEquipOldTemplate(int TemplateId)
    {
      if (GoldEquipMgr.dictionary_0 == null)
        GoldEquipMgr.Init();
      try
      {
        foreach (GoldEquipTemplateInfo equipOldTemplate in GoldEquipMgr.dictionary_0.Values)
        {
          string str = equipOldTemplate.OldTemplateId.ToString();
          if (equipOldTemplate.NewTemplateId == TemplateId && str.Substring(4) != "4")
            return equipOldTemplate;
        }
      }
      catch
      {
      }
      return (GoldEquipTemplateInfo) null;
    }
  }
}
