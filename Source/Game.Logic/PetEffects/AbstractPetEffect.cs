// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.AbstractPetEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.PetEffects
{
  public abstract class AbstractPetEffect
  {
    private ePetEffectType ePetEffectType_0;
    protected Living m_living;
    public ThreadSafeRandom rand;
    public bool IsTrigger;
    private PetSkillElementInfo petSkillElementInfo_0;

    public PetSkillElementInfo Info => this.petSkillElementInfo_0;

    public ePetEffectType Type => this.ePetEffectType_0;

    public int TypeValue => (int) this.ePetEffectType_0;

    public AbstractPetEffect(ePetEffectType type, string ElementID)
    {
      this.rand = new ThreadSafeRandom();
      this.ePetEffectType_0 = type;
      this.petSkillElementInfo_0 = PetMgr.FindPetSkillElement(int.Parse(ElementID));
      if (this.petSkillElementInfo_0 != null)
        return;
      this.petSkillElementInfo_0 = new PetSkillElementInfo();
      this.petSkillElementInfo_0.EffectPic = "";
      this.petSkillElementInfo_0.Pic = -1;
      this.petSkillElementInfo_0.Value = 1;
    }

    public virtual bool Start(Living living)
    {
      this.m_living = living;
      return this.m_living.PetEffectList.Add(this);
    }

    public virtual bool Stop() => this.m_living != null && this.m_living.PetEffectList.Remove(this);

    public virtual void OnAttached(Living living)
    {
    }

    public virtual void OnRemoved(Living living)
    {
    }
  }
}
