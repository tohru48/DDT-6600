// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.WaitPlayerLoadingAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class WaitPlayerLoadingAction : IAction
  {
    private long long_0;
    private bool bool_0;

    public WaitPlayerLoadingAction(BaseGame game, int maxTime)
    {
      this.long_0 = TickHelper.GetTickCount() + (long) maxTime;
      game.GameStarted += new GameEventHandle(this.method_0);
    }

    private void method_0(AbstractGame abstractGame_0)
    {
      abstractGame_0.GameStarted -= new GameEventHandle(this.method_0);
      this.bool_0 = true;
    }

    public void Execute(BaseGame game, long tick)
    {
      if (this.bool_0 || tick <= this.long_0 || game.GameState != eGameState.Loading)
        return;
      if (game.GameState == eGameState.Loading)
      {
        foreach (Player allFightPlayer in game.GetAllFightPlayers())
        {
          if (allFightPlayer.LoadingProcess < 100)
          {
            game.method_62(allFightPlayer);
            game.RemovePlayer(allFightPlayer.PlayerDetail, false);
          }
        }
        game.CheckState(0);
      }
      this.bool_0 = true;
    }

    public bool IsFinished(long tick) => this.bool_0;
  }
}
