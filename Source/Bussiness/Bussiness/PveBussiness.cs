// Decompiled with JetBrains decompiler
// Type: Bussiness.PveBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
  public class PveBussiness : BaseBussiness
  {
    public PveInfo InitPveInfo(SqlDataReader dr)
    {
      return new PveInfo()
      {
        ID = (int) dr["ID"],
        Name = dr["Name"] == null ? "" : dr["Name"].ToString(),
        Type = (int) dr["Type"],
        LevelLimits = (int) dr["LevelLimits"],
        SimpleTemplateIds = dr["SimpleTemplateIds"] == null ? "" : dr["SimpleTemplateIds"].ToString(),
        NormalTemplateIds = dr["NormalTemplateIds"] == null ? "" : dr["NormalTemplateIds"].ToString(),
        HardTemplateIds = dr["HardTemplateIds"] == null ? "" : dr["HardTemplateIds"].ToString(),
        TerrorTemplateIds = dr["TerrorTemplateIds"] == null ? "" : dr["TerrorTemplateIds"].ToString(),
        EpicTemplateIds = dr["EpicTemplateIds"] == null ? "" : dr["EpicTemplateIds"].ToString(),
        NightmareTemplateIds = dr["NightmareTemplateIds"] == null ? "" : dr["NightmareTemplateIds"].ToString(),
        Pic = dr["Pic"] == null ? "" : dr["Pic"].ToString(),
        Description = dr["Description"] == null ? "" : dr["Description"].ToString(),
        Ordering = (int) dr["Ordering"],
        AdviceTips = dr["AdviceTips"] == null ? "" : dr["AdviceTips"].ToString(),
        BossFightNeedMoney = dr["BossFightNeedMoney"] == null ? "" : dr["BossFightNeedMoney"].ToString(),
        MinLv = (int) dr["MinLv"],
        MaxLv = (int) dr["MaxLv"],
        SimpleGameScript = dr["SimpleGameScript"] == null ? "" : dr["SimpleGameScript"].ToString(),
        NormalGameScript = dr["NormalGameScript"] == null ? "" : dr["NormalGameScript"].ToString(),
        HardGameScript = dr["HardGameScript"] == null ? "" : dr["HardGameScript"].ToString(),
        TerrorGameScript = dr["TerrorGameScript"] == null ? "" : dr["TerrorGameScript"].ToString(),
        EpicGameScript = dr["EpicGameScript"] == null ? "" : dr["EpicGameScript"].ToString(),
        NightmareGameScript = dr["NightmareGameScript"] == null ? "" : dr["NightmareGameScript"].ToString()
      };
    }

    public PveInfo[] GetAllPveInfos()
    {
      List<PveInfo> pveInfoList = new List<PveInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_PveInfos_All");
        while (ResultDataReader.Read())
          pveInfoList.Add(this.InitPveInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllPveInfos), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return pveInfoList.ToArray();
    }
  }
}
