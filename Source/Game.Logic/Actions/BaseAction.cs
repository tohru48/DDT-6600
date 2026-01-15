// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.BaseAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.Actions
{
  public class BaseAction : IAction
  {
    private long long_0;
    private long long_1;
    private long long_2;

    public BaseAction(int delay)
      : this(delay, 0)
    {
    }

    public BaseAction(int delay, int finishDelay)
    {
      this.long_0 = TickHelper.GetTickCount() + (long) delay;
      this.long_1 = (long) finishDelay;
      this.long_2 = long.MaxValue;
    }

    public void Execute(BaseGame game, long tick)
    {
      if (this.long_0 > tick || this.long_2 != long.MaxValue)
        return;
      this.ExecuteImp(game, tick);
    }

    protected virtual void ExecuteImp(BaseGame game, long tick) => this.Finish(tick);

    public void Finish(long tick) => this.long_2 = tick + this.long_1;

    public bool IsFinished(long tick) => this.long_2 <= tick;
  }
}
