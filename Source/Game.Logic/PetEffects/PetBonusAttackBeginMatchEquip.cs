// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetBonusAttackBeginMatchEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetBonusAttackBeginMatchEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public PetBonusAttackBeginMatchEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetBonusAttackBeginMatchEquip, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
      switch (skillId)
      {
        case 134:
          this.int_2 = 100;
          break;
        case 135:
          this.int_2 = 300;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetBonusAttackBeginMatchEquip) is PetBonusAttackBeginMatchEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living player) => player.PetEffects.BonusAttack += this.int_2;

    public override void OnRemoved(Living player) => player.PetEffects.BonusAttack -= this.int_2;
  }
}
