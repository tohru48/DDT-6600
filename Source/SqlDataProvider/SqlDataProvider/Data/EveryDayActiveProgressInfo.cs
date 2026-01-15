// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.EveryDayActiveProgressInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class EveryDayActiveProgressInfo
  {
    public int ID { get; set; }

    public string ActiveName { get; set; }

    public string ActiveTime { get; set; }

    public string Count { get; set; }

    public string Description { get; set; }

    public int JumpType { get; set; }

    public int LevelLimit { get; set; }

    public string DayOfWeek { get; set; }
  }
}
