// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseReduceDamageEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseReduceDamageEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;

    public HorseReduceDamageEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseReduceDamageEquipEffect, elementID)
    {
      switch (elementID)
      {
        case "11301":
          this.int_5 = 3;
          this.int_6 = 65;
          break;
        case "11302":
          this.int_5 = 5;
          this.int_6 = 90;
          break;
        case "11303":
          this.int_5 = 7;
          this.int_6 = 125;
          break;
        case "11304":
          this.int_5 = 9;
          this.int_6 = 165;
          break;
        case "11305":
          this.int_5 = 12;
          this.int_6 = 225;
          break;
        case "11306":
          this.int_5 = 15;
          this.int_6 = 295;
          break;
        case "11307":
          this.int_5 = 18;
          this.int_6 = 395;
          break;
        case "11308":
          this.int_5 = 21;
          this.int_6 = 405;
          break;
        case "11309":
          this.int_5 = 24;
          this.int_6 = 515;
          break;
        case "11310":
          this.int_5 = 28;
          this.int_6 = 625;
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
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseReduceDamageEquipEffect) is HorseReduceDamageEquipEffect ofType))
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
        new HorseReduceDamageEffect(this.int_1, this.int_5, this.int_6, this.int_4, this.Info.ID.ToString()).Start(living_0);
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
        living_0.Game.CurrentLiving.AddHorseEffect((AbstractHorseEffect) new HorseReduceDamageEffect(this.int_1, this.int_5, this.int_6, this.int_4, this.Info.ID.ToString()), 0);
    }
  }
}
