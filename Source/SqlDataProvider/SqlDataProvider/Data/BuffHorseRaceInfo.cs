// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.BuffHorseRaceInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class BuffHorseRaceInfo
  {
    public int UserID { get; set; }

    public int OwerID { get; set; }

    public int Type { get; set; }

    public DateTime StartTime { get; set; }

    public int VaildTime { get; set; }

    public BuffHorseRaceInfo()
    {
    }

    public BuffHorseRaceInfo(int type, int vaildDate)
    {
      this.UserID = 0;
      this.OwerID = 0;
      this.Type = type;
      this.VaildTime = vaildDate;
      this.StartTime = DateTime.Now;
    }
  }
}
