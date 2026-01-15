// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetReduceTakeDamageEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetReduceTakeDamageEquipEffect : BasePetEffect
  {
    private int int_0;
    private int DqriscgPov;
    private int int_1;
    private int int_2;
    private int int_3;

    public PetReduceTakeDamageEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetReduceTakeDamageEquipEffect, elementID)
    {
      this.DqriscgPov = count;
      this.int_1 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_2 = delay;
      this.int_3 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetReduceTakeDamageEquipEffect) is PetReduceTakeDamageEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBuffSkillPet += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBuffSkillPet -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      if (this.rand.Next(10000) >= this.int_1 || living_0.PetEffects.CurrentUseSkill != this.int_3)
        return;
      living_0.PetEffectTrigger = true;
      new PetReduceTakeDamageEquip(this.DqriscgPov, this.int_3, this.Info.ID.ToString()).Start(living_0);
      living_0.Game.udqMkhsej5(living_0, this.Info, true);
    }
  }
}
