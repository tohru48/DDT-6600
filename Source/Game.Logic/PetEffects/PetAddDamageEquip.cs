// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddDamageEquip : AbstractPetEffect
  {
    private int int_0;

    public PetAddDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetAddDamageEquip, elementID)
    {
      this.int_0 = count;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddDamageEquip) is PetAddDamageEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living player)
    {
      player.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living player)
    {
      player.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      (living_0 as Player).BaseDamage -= (double) living_0.PetEffects.AddDameValue;
      living_0.PetEffects.AddDameValue = 0;
      this.Stop();
      living_0.Game.udqMkhsej5(living_0, this.Info, false);
    }
  }
}
