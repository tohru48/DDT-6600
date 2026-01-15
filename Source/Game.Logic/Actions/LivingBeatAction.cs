// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingBeatAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingBeatAction : BaseAction
  {
    private Living living_0;
    private Living living_1;
    private int int_0;
    private int int_1;
    private string string_0;
    private int int_2;
    private int int_3;

    public LivingBeatAction(
      Living living,
      Living target,
      int demageAmount,
      int criticalAmount,
      string action,
      int delay,
      int livingCount,
      int attackEffect)
      : base(delay)
    {
      this.living_0 = living;
      this.living_1 = target;
      this.int_0 = demageAmount;
      this.int_1 = criticalAmount;
      this.string_0 = action;
      this.int_2 = livingCount;
      this.int_3 = attackEffect;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.living_1.SyncAtTime = false;
      this.living_1.SyncAtTime = true;
      if (this.living_1.TakeDamage(this.living_0, ref this.int_0, ref this.int_1, "LivingFire"))
      {
        int int_4 = this.int_0 + this.int_1;
        game.method_26(this.living_0, this.living_1, int_4, this.string_0, this.int_2, this.int_3);
      }
      this.living_1.IsFrost = false;
      this.Finish(tick);
    }
  }
}
