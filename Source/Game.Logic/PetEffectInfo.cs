// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffectInfo
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic
{
  public class PetEffectInfo
  {
    private int int_0;
    private bool bool_0;
    private int int_1;
    private int int_2;
    private bool bool_1;
    private bool bool_2;
    private bool bool_3;
    private bool bool_4;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;
    private int int_10;
    private int int_11;
    private int ovAqxpNcd7;
    private int int_12;
    private int int_13;
    private int int_14;
    private int int_15;
    private int int_16;

    public int CurrentHorseSkill
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    public bool CritActive
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public int CritRate
    {
      get => this.int_1;
      set => this.int_1 = value;
    }

    public int PetDelay
    {
      get => this.int_2;
      set => this.int_2 = value;
    }

    public bool ActivePetHit
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }

    public bool ActiveGuard
    {
      get => this.bool_2;
      set => this.bool_2 = value;
    }

    public bool StopMoving
    {
      get => this.bool_3;
      set => this.bool_3 = value;
    }

    public bool IsPetUseSkill
    {
      get => this.bool_4;
      set => this.bool_4 = value;
    }

    public int PetBaseAtt
    {
      get => this.int_3;
      set => this.int_3 = value;
    }

    public int CurrentUseSkill
    {
      get => this.int_4;
      set => this.int_4 = value;
    }

    public int AddDameValue
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public int AddGuardValue
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public int AddAttackValue
    {
      get => this.int_7;
      set => this.int_7 = value;
    }

    public int AddLuckValue
    {
      get => this.int_8;
      set => this.int_8 = value;
    }

    public int ReduceDefendValue
    {
      get => this.int_9;
      set => this.int_9 = value;
    }

    public int BonusPoint
    {
      get => this.int_10;
      set => this.int_10 = value;
    }

    public int BonusGuard
    {
      get => this.int_11;
      set => this.int_11 = value;
    }

    public int BonusBaseDamage
    {
      get => this.ovAqxpNcd7;
      set => this.ovAqxpNcd7 = value;
    }

    public int BonusAttack
    {
      get => this.int_12;
      set => this.int_12 = value;
    }

    public int BonusLucky
    {
      get => this.int_13;
      set => this.int_13 = value;
    }

    public int BonusAgility
    {
      get => this.int_14;
      set => this.int_14 = value;
    }

    public int BonusDefend
    {
      get => this.int_15;
      set => this.int_15 = value;
    }

    public int MaxBlood
    {
      get => this.int_16;
      set => this.int_16 = value;
    }
  }
}
