// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddGodDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddGodDamageEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public PetAddGodDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetAddGodDamageEquip, elementID)
    {
      this.int_0 = count;
      this.int_2 = skillId;
      switch (skillId)
      {
        case 187:
          this.int_3 = 100;
          break;
        case 188:
          this.int_3 = 300;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddGodDamageEquip) is PetAddGodDamageEquip ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BaseDamage += (double) this.int_3;
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.BaseDamage -= (double) this.int_3;
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
    }
  }
}
