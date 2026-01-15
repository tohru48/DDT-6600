// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseBuffHPEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseBuffHPEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;

    public HorseBuffHPEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseBuffHPEquipEffect, elementID)
    {
      switch (elementID)
      {
        case "10101":
          this.int_1 = 3;
          this.int_5 = 150;
          break;
        case "10102":
          this.int_1 = 4;
          this.int_5 = 190;
          break;
        case "10103":
          this.int_1 = 5;
          this.int_5 = 230;
          break;
        case "10104":
          this.int_1 = 6;
          this.int_5 = 275;
          break;
        case "10105":
          this.int_1 = 7;
          this.int_5 = 325;
          break;
        case "10106":
          this.int_1 = 8;
          this.int_5 = 380;
          break;
        case "10107":
          this.int_1 = 9;
          this.int_5 = 440;
          break;
        case "10108":
          this.int_1 = 10;
          this.int_5 = 515;
          break;
        case "10109":
          this.int_1 = 11;
          this.int_5 = 580;
          break;
        case "10110":
          this.int_1 = 12;
          this.int_5 = 660;
          break;
      }
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseBuffHPEquipEffect) is HorseBuffHPEquipEffect ofType))
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
      {
        int num = living_0.Blood / 100 * this.int_1 + this.int_5;
        living_0.AddBlood(num);
      }
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
      {
        int num = living_0.Game.CurrentLiving.Blood / 100 * this.int_1 + this.int_5;
        living_0.Game.CurrentLiving.AddBlood(num);
      }
    }
  }
}
