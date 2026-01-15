// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingSealAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingSealAction : BaseAction
  {
    private Living living_0;
    private Player player_0;
    private int int_0;

    public LivingSealAction(Living Living, Player target, int type, int delay)
      : base(delay, 2000)
    {
      this.living_0 = Living;
      this.player_0 = target;
      this.int_0 = type;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.player_0.AddEffect((AbstractEffect) new SealEffect(2), 0);
      this.Finish(tick);
    }
  }
}
