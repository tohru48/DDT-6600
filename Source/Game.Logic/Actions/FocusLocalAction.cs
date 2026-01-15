// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.FocusLocalAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.Actions
{
  public class FocusLocalAction : BaseAction
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public FocusLocalAction(int x, int y, int type, int delay, int finishTime)
      : base(delay, finishTime)
    {
      this.int_0 = x;
      this.int_1 = y;
      this.int_2 = type;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      game.method_16(this.int_0, this.int_1, this.int_2);
      this.Finish(tick);
    }
  }
}
