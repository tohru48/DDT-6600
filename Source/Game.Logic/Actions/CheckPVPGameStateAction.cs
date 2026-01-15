// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.CheckPVPGameStateAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using log4net;
using System.Reflection;

#nullable disable
namespace Game.Logic.Actions
{
  public class CheckPVPGameStateAction : IAction
  {
    private long long_0;
    private bool tupuXhMuWV;
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

    public CheckPVPGameStateAction(int delay)
    {
      this.tupuXhMuWV = false;
      this.long_0 += TickHelper.GetTickCount() + (long) delay;
    }

    public void Execute(BaseGame game, long tick)
    {
      if (this.long_0 > tick)
        return;
      if (game is PVPGame pvpGame)
      {
        switch (game.GameState)
        {
          case eGameState.Inited:
            pvpGame.Prepare();
            break;
          case eGameState.Prepared:
            pvpGame.StartLoading();
            break;
          case eGameState.Loading:
            if (pvpGame.IsAllComplete())
            {
              pvpGame.StartGame();
              break;
            }
            break;
          case eGameState.Playing:
            if (pvpGame.CurrentPlayer == null || !pvpGame.CurrentPlayer.IsAttacking)
            {
              if (pvpGame.CanGameOver())
              {
                if (pvpGame.ArenaPK())
                  pvpGame.GameOverArenaMode();
                else
                  pvpGame.GameOver();
              }
              else
                pvpGame.NextTurn();
              break;
            }
            break;
          case eGameState.GameOver:
            pvpGame.Stop();
            break;
        }
      }
      this.tupuXhMuWV = true;
    }

    public bool IsFinished(long tick) => this.tupuXhMuWV;
  }
}
