// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseEffectList
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using log4net;
using System;
using System.Collections;
using System.Reflection;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseEffectList
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected ArrayList m_effects;
    protected readonly Living m_owner;
    protected volatile sbyte m_changesCount;
    protected int m_immunity;

    public ArrayList List => this.m_effects;

    public HorseEffectList(Living owner, int immunity)
    {
      this.m_owner = owner;
      this.m_effects = new ArrayList(5);
      this.m_immunity = immunity;
    }

    public bool CanAddEffect(int id) => id > 5 || id < 0 || (1 << id - 1 & this.m_immunity) == 0;

    public virtual bool Add(AbstractHorseEffect effect)
    {
      if (!this.CanAddEffect(effect.TypeValue))
        return false;
      lock (this.m_effects)
        this.m_effects.Add((object) effect);
      effect.OnAttached(this.m_owner);
      this.OnEffectsChanged(effect);
      return true;
    }

    public virtual bool Remove(AbstractHorseEffect effect)
    {
      int index = -1;
      lock (this.m_effects)
      {
        index = this.m_effects.IndexOf((object) effect);
        if (index < 0)
          return false;
        this.m_effects.RemoveAt(index);
      }
      if (index == -1)
        return false;
      effect.OnRemoved(this.m_owner);
      this.OnEffectsChanged(effect);
      return true;
    }

    public virtual void OnEffectsChanged(AbstractHorseEffect changedEffect)
    {
      if (this.m_changesCount > (sbyte) 0)
        return;
      this.UpdateChangedEffects();
    }

    public void BeginChanges() => ++this.m_changesCount;

    public virtual void CommitChanges()
    {
      if (--this.m_changesCount < (sbyte) 0)
      {
        if (HorseEffectList.ilog_0.IsWarnEnabled)
          HorseEffectList.ilog_0.Warn((object) ("changes count is less than zero, forgot BeginChanges()?\n" + Environment.StackTrace));
        this.m_changesCount = (sbyte) 0;
      }
      if (this.m_changesCount != (sbyte) 0)
        return;
      this.UpdateChangedEffects();
    }

    protected virtual void UpdateChangedEffects()
    {
    }

    public virtual AbstractHorseEffect GetOfType(eHorseEffectType effectType)
    {
      lock (this.m_effects)
      {
        foreach (AbstractHorseEffect effect in this.m_effects)
        {
          if (effect.Type == effectType)
            return effect;
        }
      }
      return (AbstractHorseEffect) null;
    }

    public virtual System.Collections.Generic.List<AbstractHorseEffect> GetAllEffect()
    {
      System.Collections.Generic.List<AbstractHorseEffect> allEffect;
      lock (this.m_effects)
      {
        System.Collections.Generic.List<AbstractHorseEffect> abstractHorseEffectList = new System.Collections.Generic.List<AbstractHorseEffect>();
        foreach (AbstractHorseEffect effect in this.m_effects)
          abstractHorseEffectList.Add(effect);
        allEffect = abstractHorseEffectList;
      }
      return allEffect;
    }

    public virtual IList GetAllOfType(Type effectType)
    {
      ArrayList allOfType = new ArrayList();
      lock (this.m_effects)
      {
        foreach (AbstractHorseEffect effect in this.m_effects)
        {
          if (effect.GetType().Equals(effectType))
            allOfType.Add((object) effect);
        }
      }
      return (IList) allOfType;
    }

    public void StopEffect(Type effectType)
    {
      IList allOfType = this.GetAllOfType(effectType);
      this.BeginChanges();
      foreach (AbstractHorseEffect abstractHorseEffect in (IEnumerable) allOfType)
        abstractHorseEffect.Stop();
      this.CommitChanges();
    }

    public void StopAllEffect()
    {
      if (this.m_effects.Count <= 0)
        return;
      AbstractHorseEffect[] abstractHorseEffectArray = new AbstractHorseEffect[this.m_effects.Count];
      this.m_effects.CopyTo((Array) abstractHorseEffectArray);
      foreach (AbstractHorseEffect abstractHorseEffect in abstractHorseEffectArray)
        abstractHorseEffect.Stop();
      this.m_effects.Clear();
    }
  }
}
