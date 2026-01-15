// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingPlayeMovieAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingPlayeMovieAction : BaseAction
  {
    private Living living_0;
    private string string_0;

    public LivingPlayeMovieAction(Living living, string action, int delay, int movieTime)
      : base(delay, movieTime)
    {
      this.living_0 = living;
      this.string_0 = action;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      game.method_27(this.living_0, this.string_0);
      this.Finish(tick);
    }
  }
}
