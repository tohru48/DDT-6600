// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetActiveDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetActiveDamageEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetActiveDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetActiveDamageEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 42:
          this.int_1 = 400;
          break;
        case 43:
          this.int_1 = 300;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetActiveDamageEquip) is PetActiveDamageEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_1);
      living.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_1);
      living.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, ref int int_2, ref int int_3)
    {
      if (living_0.PetEffects.AddGuardValue >= this.int_1)
        return;
      (living_0 as Player).BaseGuard += (double) this.int_1;
      living_0.PetEffects.AddGuardValue = this.int_1;
    }

    private void method_1(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      (living_0 as Player).BaseDamage -= (double) living_0.PetEffects.AddDameValue;
      living_0.PetEffects.AddDameValue = 0;
      living_0.Game.udqMkhsej5(living_0, this.Info, false);
      this.Stop();
    }
  }
}
