// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.LogFight
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class LogFight
  {
    public int ApplicationId { get; set; }

    public int SubId { get; set; }

    public int LineId { get; set; }

    public int RoomType { get; set; }

    public int FightType { get; set; }

    public DateTime PlayBegin { get; set; }

    public DateTime PlayEnd { get; set; }

    public int UserCount { get; set; }

    public int MapId { get; set; }

    public string Users { get; set; }

    public string PlayResult { get; set; }
  }
}
