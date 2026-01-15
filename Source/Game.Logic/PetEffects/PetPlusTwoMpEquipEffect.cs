// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetPlusTwoMpEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetPlusTwoMpEquipEffect : BasePetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public PetPlusTwoMpEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetPlusTwoMpEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetPlusTwoMpEquipEffect) is PetPlusTwoMpEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, ref int int_5, ref int int_6)
    {
      if (this.rand.Next(10000) >= this.int_2)
        return;
      ((TurnedLiving) living_0).AddPetMP(2);
    }
  }
}
