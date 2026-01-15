// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.RateInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class RateInfo
  {
    public int ServerID { get; set; }

    public int Type { get; set; }

    public float Rate { get; set; }

    public DateTime BeginDay { get; set; }

    public DateTime EndDay { get; set; }

    public DateTime BeginTime { get; set; }

    public DateTime EndTime { get; set; }
  }
}
