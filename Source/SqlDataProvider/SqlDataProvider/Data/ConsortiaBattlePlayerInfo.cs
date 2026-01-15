// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaBattlePlayerInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaBattlePlayerInfo
  {
    public int PlayerID { get; set; }

    public bool Sex { get; set; }

    public int curHp { get; set; }

    public int posX { get; set; }

    public int posY { get; set; }

    public int consortiaID { get; set; }

    public string consortiaName { get; set; }

    public DateTime tombstoneEndTime { get; set; }

    public byte status { get; set; }

    public int victoryCount { get; set; }

    public int winningStreak { get; set; }

    public int failBuffCount { get; set; }

    public int score { get; set; }

    public bool isPowerFullUsed { get; set; }

    public bool isDoubleScoreUsed { get; set; }
  }
}
