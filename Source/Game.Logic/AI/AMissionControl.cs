// Decompiled with JetBrains decompiler
// Type: Game.Logic.AI.AMissionControl
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.AI
{
  public abstract class AMissionControl
  {
    private PVEGame pvegame_0;

    public PVEGame Game
    {
      get => this.pvegame_0;
      set => this.pvegame_0 = value;
    }

    public virtual void OnPrepareNewSession()
    {
    }

    public virtual void OnStartMovie()
    {
    }

    public virtual void OnStartGame()
    {
    }

    public virtual void OnBeginNewTurn()
    {
    }

    public virtual void OnNewTurnStarted()
    {
    }

    public virtual bool CanGameOver() => true;

    public virtual void OnGameOverMovie()
    {
    }

    public virtual void OnGameOver()
    {
    }

    public virtual void OnGameOverAllSession()
    {
    }

    public virtual int CalculateScoreGrade(int score) => 0;

    public virtual void GameOverAllSession()
    {
    }

    public virtual int UpdateUIData() => 0;

    public virtual void Dispose()
    {
    }

    public virtual void DoOther()
    {
    }

    public virtual void OnShooted()
    {
    }

    public virtual void OnMoving()
    {
    }

    public virtual void OnTakeDamage()
    {
    }
  }
}
