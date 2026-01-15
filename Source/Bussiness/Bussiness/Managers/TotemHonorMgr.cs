// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.TotemHonorMgr
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
  public class TotemHonorMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, TotemHonorTemplateInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, TotemHonorTemplateInfo> TotemHonorTemplate = new Dictionary<int, TotemHonorTemplateInfo>();
        if (TotemHonorMgr.smethod_0(TotemHonorTemplate))
        {
          try
          {
            TotemHonorMgr.dictionary_0 = TotemHonorTemplate;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (TotemHonorMgr.ilog_0.IsErrorEnabled)
          TotemHonorMgr.ilog_0.Error((object) nameof (TotemHonorMgr), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        TotemHonorMgr.dictionary_0 = new Dictionary<int, TotemHonorTemplateInfo>();
        TotemHonorMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = TotemHonorMgr.smethod_0(TotemHonorMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (TotemHonorMgr.ilog_0.IsErrorEnabled)
          TotemHonorMgr.ilog_0.Error((object) nameof (TotemHonorMgr), ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(
      Dictionary<int, TotemHonorTemplateInfo> TotemHonorTemplate)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (TotemHonorTemplateInfo honorTemplateInfo in playerBussiness.GetAllTotemHonorTemplate())
        {
          if (!TotemHonorTemplate.ContainsKey(honorTemplateInfo.ID))
            TotemHonorTemplate.Add(honorTemplateInfo.ID, honorTemplateInfo);
        }
      }
      return true;
    }

    public static TotemHonorTemplateInfo FindTotemHonorTemplateInfo(int ID)
    {
      return TotemHonorMgr.dictionary_0.ContainsKey(ID) ? TotemHonorMgr.dictionary_0[ID] : (TotemHonorTemplateInfo) null;
    }
  }
}
