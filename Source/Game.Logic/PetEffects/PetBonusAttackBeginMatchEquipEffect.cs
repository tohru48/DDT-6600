// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetBonusAttackBeginMatchEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetBonusAttackBeginMatchEquipEffect : BasePetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;

    public PetBonusAttackBeginMatchEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetBonusAttackBeginMatchEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
      switch (skillId)
      {
        case 112:
          this.int_5 = 80;
          break;
        case 113:
          this.int_5 = 100;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetBonusAttackBeginMatchEquipEffect) is PetBonusAttackBeginMatchEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PetEffects.BonusAttack += this.int_5;
      player.Game.udqMkhsej5((Living) player, this.Info, true);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PetEffects.BonusAttack -= this.int_5;
      player.Game.udqMkhsej5((Living) player, this.Info, false);
    }
  }
}
