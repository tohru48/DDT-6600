// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseNoHoleEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseNoHoleEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public HorseNoHoleEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseNoHoleEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseNoHoleEquipEffect) is HorseNoHoleEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBuffSkillHorse += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBuffSkillHorse -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      if (this.rand.Next(10000) >= this.int_2 || living_0.PetEffects.CurrentHorseSkill != this.int_4)
        return;
      if (living_0.IsLiving)
        new NoHoleEffect(this.int_1).Start(living_0);
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
        new NoHoleEffect(this.int_1).Start((Living) living_0.Game.CurrentLiving);
    }
  }
}
