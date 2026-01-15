// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseAddDamageEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseAddDamageEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;

    public HorseAddDamageEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseAddDamageEquipEffect, elementID)
    {
      switch (elementID)
      {
        case "11101":
          this.int_5 = 100;
          this.int_6 = 4;
          break;
        case "11102":
          this.int_5 = 140;
          this.int_6 = 6;
          break;
        case "11103":
          this.int_5 = 190;
          this.int_6 = 8;
          break;
        case "11104":
          this.int_5 = 245;
          this.int_6 = 10;
          break;
        case "11105":
          this.int_5 = 300;
          this.int_6 = 13;
          break;
        case "11106":
          this.int_5 = 360;
          this.int_6 = 16;
          break;
        case "11107":
          this.int_5 = 435;
          this.int_6 = 19;
          break;
        case "11108":
          this.int_5 = 525;
          this.int_6 = 22;
          break;
        case "11109":
          this.int_5 = 625;
          this.int_6 = 25;
          break;
        case "11110":
          this.int_5 = 730;
          this.int_6 = 30;
          break;
      }
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseAddDamageEquipEffect) is HorseAddDamageEquipEffect ofType))
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
        new HorseAddDamageEffect(this.int_1, this.int_5, this.int_6, this.int_4, this.Info.ID.ToString()).Start(living_0);
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
        living_0.Game.CurrentLiving.AddHorseEffect((AbstractHorseEffect) new HorseAddDamageEffect(this.int_1, this.int_5, this.int_6, this.int_4, this.Info.ID.ToString()), 0);
    }
  }
}
