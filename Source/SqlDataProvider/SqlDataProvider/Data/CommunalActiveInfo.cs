// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.CommunalActiveInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class CommunalActiveInfo
  {
    public int ActiveID { get; set; }

    public DateTime BeginTime { get; set; }

    public DateTime EndTime { get; set; }

    public int LimitGrade { get; set; }

    public int DayMaxScore { get; set; }

    public int MinScore { get; set; }

    public string AddPropertyByMoney { get; set; }

    public string AddPropertyByProp { get; set; }

    public bool IsReset { get; set; }

    public bool IsSendAward { get; set; }

    public bool IsOpen { get; set; }
  }
}
