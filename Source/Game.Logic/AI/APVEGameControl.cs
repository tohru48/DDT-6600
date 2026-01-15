// Decompiled with JetBrains decompiler
// Type: Game.Logic.AI.APVEGameControl
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.AI
{
  public abstract class APVEGameControl
  {
    protected PVEGame m_game;

    public PVEGame Game
    {
      get => this.m_game;
      set => this.m_game = value;
    }

    public virtual void OnCreated()
    {
    }

    public virtual void OnPrepated()
    {
    }

    public virtual void OnGameOverAllSession()
    {
    }

    public virtual int CalculateScoreGrade(int score) => 0;

    public virtual void Dispose()
    {
    }
  }
}
