// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingSayAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingSayAction : BaseAction
  {
    private Living living_0;
    private string string_0;
    private int int_0;

    public LivingSayAction(Living living, string msg, int type, int delay, int finishTime)
      : base(delay, finishTime)
    {
      this.living_0 = living;
      this.string_0 = msg;
      this.int_0 = type;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      game.method_23(this.living_0, this.string_0, this.int_0);
      this.Finish(tick);
    }
  }
}
