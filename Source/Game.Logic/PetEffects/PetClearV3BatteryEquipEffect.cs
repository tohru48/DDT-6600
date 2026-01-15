// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetClearV3BatteryEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetClearV3BatteryEquipEffect : BasePetEffect
  {
    private int wtDiEeJdtY;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public PetClearV3BatteryEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetClearV3BatteryEquipEffect, elementID)
    {
      this.int_0 = count;
      this.int_1 = probability == -1 ? 10000 : probability;
      this.wtDiEeJdtY = type;
      this.int_2 = delay;
      this.int_3 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetClearV3BatteryEquipEffect) is PetClearV3BatteryEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBeginMoving += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBeginMoving += new PlayerEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      if (living_0.PetEffects.AddAttackValue <= 0 || living_0.PetEffects.AddLuckValue <= 0 || living_0.PetEffects.ReduceDefendValue <= 0)
        return;
      living_0.IsNoHole = false;
      if (living_0.PetEffectList.GetOfType(ePetEffectType.PetAddAttackEquipEffect) is PetAddAttackEquipEffect ofType)
        living_0.Game.udqMkhsej5(living_0, ofType.Info, false);
      (living_0 as Player).Attack -= (double) living_0.PetEffects.AddAttackValue;
      (living_0 as Player).Lucky -= (double) living_0.PetEffects.AddLuckValue;
      (living_0 as Player).Defence += (double) living_0.PetEffects.ReduceDefendValue;
      living_0.PetEffects.AddAttackValue = 0;
      living_0.PetEffects.AddLuckValue = 0;
      living_0.PetEffects.ReduceDefendValue = 0;
    }
  }
}
