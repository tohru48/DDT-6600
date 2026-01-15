// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.SubActiveInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class SubActiveInfo
  {
    public int ID { get; set; }

    public int ActiveID { get; set; }

    public int SubID { get; set; }

    public bool IsOpen { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime StartTime { get; set; }

    public DateTime EndDate { get; set; }

    public DateTime EndTime { get; set; }

    public bool IsContinued { get; set; }

    public string ActiveInfo { get; set; }
  }
}
