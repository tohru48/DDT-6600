// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.DailyLogListInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class DailyLogListInfo
  {
    public int ID { get; set; }

    public int UserAwardLog { get; set; }

    public int UserID { get; set; }

    public string DayLog { get; set; }

    public DateTime LastDate { get; set; }
  }
}
