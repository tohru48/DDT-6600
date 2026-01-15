// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.FusionMgr
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
  public class FusionMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, FusionInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, FusionInfo> fusion = new Dictionary<int, FusionInfo>();
        if (FusionMgr.smethod_0(fusion))
        {
          try
          {
            FusionMgr.dictionary_0 = fusion;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (FusionMgr.ilog_0.IsErrorEnabled)
          FusionMgr.ilog_0.Error((object) nameof (FusionMgr), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        FusionMgr.dictionary_0 = new Dictionary<int, FusionInfo>();
        FusionMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = FusionMgr.smethod_0(FusionMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (FusionMgr.ilog_0.IsErrorEnabled)
          FusionMgr.ilog_0.Error((object) nameof (FusionMgr), ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(Dictionary<int, FusionInfo> fusion)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (FusionInfo fusionInfo in produceBussiness.GetAllFusion())
        {
          if (!fusion.ContainsKey(fusionInfo.FusionID))
            fusion.Add(fusionInfo.FusionID, fusionInfo);
        }
      }
      return true;
    }

    public static FusionInfo FindItemFusion(int fusionId)
    {
      return FusionMgr.dictionary_0.ContainsKey(fusionId) ? FusionMgr.dictionary_0[fusionId] : (FusionInfo) null;
    }
  }
}
