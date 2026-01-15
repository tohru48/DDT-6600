// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Actions.BombAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;

#nullable disable
namespace Game.Logic.Phy.Actions
{
  public class BombAction
  {
    public float Time;
    public int Type;
    public int Param1;
    public int Param2;
    public int Param3;
    public int Param4;

    public int TimeInt => (int) Math.Round((double) this.Time * 1000.0);

    public BombAction(float time, ActionType type, int para1, int para2, int para3, int para4)
    {
      this.Time = time;
      this.Type = (int) type;
      this.Param1 = para1;
      this.Param2 = para2;
      this.Param3 = para3;
      this.Param4 = para4;
    }
  }
}
