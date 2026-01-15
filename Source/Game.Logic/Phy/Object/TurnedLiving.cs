// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.TurnedLiving
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class TurnedLiving : Living
  {
    protected int m_delay;
    public int DefaultDelay;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;

    public int Delay
    {
      get => this.m_delay;
      set => this.m_delay = value;
    }

    public int psychic
    {
      get => this.int_7;
      set => this.int_7 = value;
    }

    public int PetMaxMP
    {
      get => this.int_8;
      set => this.int_8 = value;
    }

    public int PetMP
    {
      get => this.int_9;
      set => this.int_9 = value;
    }

    public int Dander
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public TurnedLiving(
      int id,
      BaseGame game,
      int team,
      string name,
      string modelId,
      int maxBlood,
      int immunity,
      int direction)
      : base(id, game, team, name, modelId, maxBlood, immunity, direction)
    {
      this.int_8 = 100;
      this.int_9 = 10;
    }

    public override void Reset() => base.Reset();

    public void AddDelay(int value) => this.m_delay += value;

    public override void PrepareSelfTurn() => base.PrepareSelfTurn();

    public void AddPetMP(int value)
    {
      if (value <= 0)
        return;
      if (this.IsLiving && this.PetMP < this.PetMaxMP)
      {
        this.int_9 += value;
        if (this.int_9 > this.PetMaxMP)
          this.int_9 = this.PetMaxMP;
      }
      else
        this.int_9 = this.PetMaxMP;
    }

    public void RemovePetMP(int value)
    {
      if (value <= 0 || !this.IsLiving || this.PetMP <= 0)
        return;
      this.int_9 -= value;
      if (this.int_9 < 0)
        this.int_9 = 0;
    }

    public void AddDander(int value)
    {
      if (value <= 0 || !this.IsLiving)
        return;
      this.SetDander(this.int_6 + value);
    }

    public void SetDander(int value)
    {
      this.int_6 = Math.Min(value, 200);
      if (!this.SyncAtTime)
        return;
      this.m_game.method_29(this);
    }

    public virtual void StartGame()
    {
    }

    public virtual void Skip(int spendTime)
    {
      if (!this.IsAttacking)
        return;
      this.StopAttacking();
      this.m_game.method_6((Living) this, 0);
      this.m_game.CheckState(0);
    }
  }
}
