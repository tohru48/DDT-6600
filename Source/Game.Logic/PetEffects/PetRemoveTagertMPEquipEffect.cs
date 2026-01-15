// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetRemoveTagertMPEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetRemoveTagertMPEquipEffect : BasePetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;

    public PetRemoveTagertMPEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetRemoveTagertMPEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
      switch (skillId)
      {
        case 183:
          this.int_5 = 10;
          break;
        case 184:
          this.int_5 = 20;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetRemoveTagertMPEquipEffect) is PetRemoveTagertMPEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBuffSkillPet += new PlayerEventHandle(this.method_1);
      player.AfterKillingLiving += new KillLivingEventHanlde(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBuffSkillPet -= new PlayerEventHandle(this.method_1);
      player.AfterKillingLiving -= new KillLivingEventHanlde(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, int int_6, int int_7)
    {
      if (!this.IsTrigger || living_0 == living_1 || !(living_1 is Player))
        return;
      ((TurnedLiving) living_1).RemovePetMP(this.int_5);
      this.IsTrigger = false;
    }

    private void method_1(Player player_0)
    {
      this.IsTrigger = false;
      if (this.rand.Next(100) >= this.int_2 || player_0.PetEffects.CurrentUseSkill != this.int_4)
        return;
      this.IsTrigger = true;
      player_0.PetEffectTrigger = true;
    }
  }
}
