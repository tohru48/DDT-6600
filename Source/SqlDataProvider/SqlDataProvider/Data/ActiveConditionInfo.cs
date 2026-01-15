// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ActiveConditionInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ActiveConditionInfo
  {
    public int ActiveID { get; set; }

    public string AwardId { get; set; }

    public int Condition { get; set; }

    public int Conditiontype { get; set; }

    public DateTime EndTime { get; set; }

    public int ID { get; set; }

    public bool IsMult { get; set; }

    public string LimitGrade { get; set; }

    public DateTime StartTime { get; set; }
  }
}
