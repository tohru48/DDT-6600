// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingDieAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingDieAction : BaseAction
  {
    private Living living_0;

    public LivingDieAction(Living living, int delay)
      : base(delay, 1000)
    {
      this.living_0 = living;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.living_0.Die();
      this.Finish(tick);
    }
  }
}
