// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingDelayHorseEffectAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.HorseEffects;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingDelayHorseEffectAction : BaseAction
  {
    private AbstractHorseEffect abstractHorseEffect_0;
    private Living living_0;

    public LivingDelayHorseEffectAction(Living living, AbstractHorseEffect effect, int delay)
      : base(delay)
    {
      this.abstractHorseEffect_0 = effect;
      this.living_0 = living;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.abstractHorseEffect_0.Start(this.living_0);
      this.Finish(tick);
    }
  }
}
