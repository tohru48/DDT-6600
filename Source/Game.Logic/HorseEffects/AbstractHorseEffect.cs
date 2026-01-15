// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.AbstractHorseEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class AbstractHorseEffect
  {
    private eHorseEffectType eHorseEffectType_0;
    protected Living m_living;
    public ThreadSafeRandom rand;
    public bool IsTrigger;
    private MountSkillElementTemplateInfo mountSkillElementTemplateInfo_0;

    public MountSkillElementTemplateInfo Info => this.mountSkillElementTemplateInfo_0;

    public eHorseEffectType Type => this.eHorseEffectType_0;

    public int TypeValue => (int) this.eHorseEffectType_0;

    public AbstractHorseEffect(eHorseEffectType type, string ElementID)
    {
      this.rand = new ThreadSafeRandom();
      this.eHorseEffectType_0 = type;
      this.mountSkillElementTemplateInfo_0 = MountMgr.FindMountSkillElement(int.Parse(ElementID));
      if (this.mountSkillElementTemplateInfo_0 != null)
        return;
      this.mountSkillElementTemplateInfo_0 = new MountSkillElementTemplateInfo();
      this.mountSkillElementTemplateInfo_0.EffectPic = "";
      this.mountSkillElementTemplateInfo_0.Pic = -1;
    }

    public virtual bool Start(Living living)
    {
      this.m_living = living;
      return this.m_living.HorseEffectList.Add(this);
    }

    public virtual bool Stop()
    {
      return this.m_living != null && this.m_living.HorseEffectList.Remove(this);
    }

    public virtual void OnAttached(Living living)
    {
    }

    public virtual void OnRemoved(Living living)
    {
    }
  }
}
