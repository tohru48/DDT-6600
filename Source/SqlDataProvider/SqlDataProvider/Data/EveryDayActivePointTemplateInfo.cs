// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.EveryDayActivePointTemplateInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class EveryDayActivePointTemplateInfo
  {
    public int ID { get; set; }

    public int MinLevel { get; set; }

    public int MaxLevel { get; set; }

    public int ActivityType { get; set; }

    public int JumpType { get; set; }

    public string Description { get; set; }

    public int Count { get; set; }

    public int ActivePoint { get; set; }

    public int MoneyPoint { get; set; }
  }
}
