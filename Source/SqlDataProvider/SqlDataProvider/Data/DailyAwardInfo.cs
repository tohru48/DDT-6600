// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.DailyAwardInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class DailyAwardInfo
  {
    public int ID { get; set; }

    public int Type { get; set; }

    public int TemplateID { get; set; }

    public int Count { get; set; }

    public int ValidDate { get; set; }

    public bool IsBinds { get; set; }

    public int Sex { get; set; }

    public string Remark { get; set; }

    public string CountRemark { get; set; }

    public int GetWay { get; set; }

    public int AwardDays { get; set; }
  }
}
