// Decompiled with JetBrains decompiler
// Type: Game.Logic.AI.ABrain
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.AI
{
  public abstract class ABrain
  {
    protected Living m_body;
    protected BaseGame m_game;

    public Living Body
    {
      get => this.m_body;
      set => this.m_body = value;
    }

    public BaseGame Game
    {
      get => this.m_game;
      set => this.m_game = value;
    }

    public virtual void OnCreated()
    {
    }

    public virtual void OnBeginNewTurn()
    {
    }

    public virtual void OnBeginSelfTurn()
    {
    }

    public virtual void OnStartAttacking()
    {
    }

    public virtual void OnStopAttacking()
    {
    }

    public virtual void Dispose()
    {
    }

    public virtual void OnKillPlayerSay()
    {
    }

    public virtual void OnDiedSay()
    {
    }

    public virtual void OnShootedSay()
    {
    }
  }
}
