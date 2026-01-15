// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetSecondWeaponBonusPointEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetSecondWeaponBonusPointEquipEffect : BasePetEffect
  {
    private int uYuTjjoTdI;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public PetSecondWeaponBonusPointEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetSecondWeaponBonusPointEquipEffect, elementID)
    {
      this.int_0 = count;
      this.int_1 = probability == -1 ? 10000 : probability;
      this.uYuTjjoTdI = type;
      this.int_2 = delay;
      this.int_3 = skillId;
      switch (skillId)
      {
        case 72:
          this.int_4 = 300;
          break;
        case 73:
          this.int_4 = 600;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetSecondWeaponBonusPointEquipEffect) is PetSecondWeaponBonusPointEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      if (this.rand.Next(10000) >= this.int_1 || 72 != this.int_3 && 73 != this.int_3 || living_0.PetEffects.BonusPoint >= this.int_4)
        return;
      living_0.PetEffects.BonusPoint = this.int_4;
    }
  }
}
