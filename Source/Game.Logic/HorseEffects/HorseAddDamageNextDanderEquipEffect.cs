// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseAddDamageNextDanderEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseAddDamageNextDanderEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public HorseAddDamageNextDanderEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseAddDamageNextDanderEquipEffect, elementID)
    {
      switch (elementID)
      {
        case null:
          this.int_2 = probability == -1 ? 10000 : probability;
          this.int_0 = type;
          this.int_3 = delay;
          this.int_4 = skillId;
          break;
        case "11401":
          this.int_1 = 2;
          goto default;
        case "11402":
          this.int_1 = 4;
          goto default;
        case "11403":
          this.int_1 = 6;
          goto default;
        case "11404":
          this.int_1 = 8;
          goto default;
        case "11405":
          this.int_1 = 10;
          goto default;
        default:
          goto case null;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseAddDamageNextDanderEquipEffect) is HorseAddDamageNextDanderEquipEffect ofType))
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
        new HorseAddDamageNextDanderEffect(this.int_1, this.int_4, this.Info.ID.ToString()).Start(living_0);
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
        living_0.Game.CurrentLiving.AddHorseEffect((AbstractHorseEffect) new HorseAddDamageNextDanderEffect(this.int_1, this.int_4, this.Info.ID.ToString()), 0);
    }
  }
}
