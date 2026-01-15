// Decompiled with JetBrains decompiler
// Type: Game.Logic.LivingConfig
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic
{
  public class LivingConfig
  {
    private bool bool_0;
    private bool bool_1;
    private bool bool_2;
    private bool bool_3;
    private bool bool_4;
    private bool bool_5;
    private bool bool_6;
    private bool bool_7;
    private bool bool_8;
    private bool bool_9;
    private bool bool_10;
    private bool bool_11;
    private bool bool_12;
    private byte byte_0;
    private bool bool_13;
    private bool bool_14;
    private int int_0;

    public bool IsWorldBoss
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public bool IsChristmasBoss
    {
      get => this.bool_2;
      set => this.bool_2 = value;
    }

    public bool IsHelper
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }

    public bool isConsortiaBoss
    {
      get => this.bool_3;
      set => this.bool_3 = value;
    }

    public bool IsInsectBoss
    {
      get => this.bool_4;
      set => this.bool_4 = value;
    }

    public bool IsInsectNpc
    {
      get => this.bool_5;
      set => this.bool_5 = value;
    }

    public bool IsShield
    {
      get => this.bool_6;
      set => this.bool_6 = value;
    }

    public bool IsDown
    {
      get => this.bool_7;
      set => this.bool_7 = value;
    }

    public bool KeepLife
    {
      get => this.bool_8;
      set => this.bool_8 = value;
    }

    public bool HasTurn
    {
      get => this.bool_9;
      set => this.bool_9 = value;
    }

    public bool CanFrost
    {
      get => this.bool_10;
      set => this.bool_10 = value;
    }

    public bool IsGoal
    {
      get => this.bool_11;
      set => this.bool_11 = value;
    }

    public bool IsFly
    {
      get => this.bool_12;
      set => this.bool_12 = value;
    }

    public byte isBotom
    {
      get => this.byte_0;
      set => this.byte_0 = value;
    }

    public bool isShowBlood
    {
      get => this.bool_13;
      set => this.bool_13 = value;
    }

    public bool isShowSmallMapPoint
    {
      get => this.bool_14;
      set => this.bool_14 = value;
    }

    public int ReduceBloodStart
    {
      get => this.int_0;
      set => this.int_0 = value;
    }
  }
}
