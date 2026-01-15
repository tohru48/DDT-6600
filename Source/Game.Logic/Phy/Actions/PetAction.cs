// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Actions.PetAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;

#nullable disable
namespace Game.Logic.Phy.Actions
{
  public class PetAction
  {
    public float Time;
    public int Type;
    public int id;
    public int damage;
    public int dander;
    public int blood;

    public int TimeInt => (int) Math.Round((double) this.Time * 1000.0);

    public PetAction(
      float time,
      PetActionType type,
      int _id,
      int _damage,
      int _dander,
      int _blood)
    {
      this.Time = time;
      this.Type = (int) type;
      this.id = _id;
      this.damage = _damage;
      this.blood = _blood;
      this.dander = _dander;
    }
  }
}
