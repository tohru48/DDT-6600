// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.CheckPVEGameStateAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using log4net;
using System.Reflection;

#nullable disable
namespace Game.Logic.Actions
{
  public class CheckPVEGameStateAction : IAction
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private long long_0;
    private bool bool_0;

    public CheckPVEGameStateAction(int delay)
    {
      this.long_0 = TickHelper.GetTickCount() + (long) delay;
      this.bool_0 = false;
    }

    public void Execute(BaseGame game, long tick)
    {
      if (this.long_0 > tick || game.GetWaitTimer() >= tick)
        return;
      if (game is PVEGame pveGame)
      {
        switch (pveGame.GameState)
        {
          case eGameState.Inited:
            pveGame.Prepare();
            break;
          case eGameState.Prepared:
            pveGame.PrepareNewSession();
            break;
          case eGameState.Loading:
            if (pveGame.IsAllComplete())
            {
              pveGame.StartGame();
              ++pveGame.PreSessionId;
              break;
            }
            game.WaitTime(1000);
            break;
          case eGameState.GameStartMovie:
            if (game.CurrentActionCount > 1)
            {
              pveGame.StartGameMovie();
              break;
            }
            pveGame.StartGame();
            break;
          case eGameState.GameStart:
            pveGame.PrepareNewGame();
            break;
          case eGameState.Playing:
            if ((pveGame.CurrentLiving == null || !pveGame.CurrentLiving.IsAttacking) && game.CurrentActionCount <= 1)
            {
              if (pveGame.CanGameOver())
              {
                if (pveGame.IsLabyrinth() && pveGame.CanEnterGate)
                  pveGame.GameOverMovie();
                else if (pveGame.ArenaBoss())
                  pveGame.GameOverArenaAll();
                else
                  pveGame.GameOver();
              }
              else
                pveGame.NextTurn();
              break;
            }
            break;
          case eGameState.GameOver:
            if (pveGame.HasNextSession())
            {
              pveGame.PrepareNewSession();
              break;
            }
            if (pveGame.ArenaBoss())
            {
              pveGame.GameOverArenaAll();
              break;
            }
            pveGame.GameOverAllSession();
            break;
          case eGameState.SessionPrepared:
            if (pveGame.CanStartNewSession())
            {
              pveGame.StartLoading();
              break;
            }
            game.WaitTime(1000);
            break;
          case eGameState.ALLSessionStopped:
            if (pveGame.PlayerCount != 0 && pveGame.WantTryAgain != 0)
            {
              if (pveGame.WantTryAgain == 1)
              {
                pveGame.ShowLargeCard();
                pveGame.PrepareNewSession();
                break;
              }
              if (pveGame.WantTryAgain == 2)
              {
                --pveGame.SessionId;
                pveGame.PrepareNewSession();
                break;
              }
              game.WaitTime(1000);
              break;
            }
            pveGame.Stop();
            break;
        }
      }
      this.bool_0 = true;
    }

    public bool IsFinished(long tick) => this.bool_0;
  }
}
