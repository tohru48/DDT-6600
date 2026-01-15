// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AbstractEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public abstract class AbstractEffect
  {
    private eEffectType nfhuwbJvwd;
    protected Living m_living;
    protected static ThreadSafeRandom rand;
    public bool IsTrigger;

    public eEffectType Type => this.nfhuwbJvwd;

    public int TypeValue => (int) this.nfhuwbJvwd;

    public AbstractEffect(eEffectType type)
    {
      AbstractEffect.rand = new ThreadSafeRandom();
      this.nfhuwbJvwd = type;
    }

    public virtual bool Start(Living living)
    {
      this.m_living = living;
      return this.m_living.EffectList.Add(this);
    }

    public virtual bool Stop() => this.m_living != null && this.m_living.EffectList.Remove(this);

    public virtual void OnAttached(Living living)
    {
    }

    public virtual void OnRemoved(Living living)
    {
    }
  }
}
