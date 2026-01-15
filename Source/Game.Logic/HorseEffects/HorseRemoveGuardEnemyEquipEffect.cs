// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseRemoveGuardEnemyEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseRemoveGuardEnemyEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public HorseRemoveGuardEnemyEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseRemoveGuardEnemyEquipEffect, elementID)
    {
      switch (elementID)
      {
        case "10301":
          this.int_1 = 15;
          break;
        case "10302":
          this.int_1 = 20;
          break;
        case "10303":
          this.int_1 = 25;
          break;
        case "10304":
          this.int_1 = 30;
          break;
        case "10305":
          this.int_1 = 35;
          break;
        case "10306":
          this.int_1 = 40;
          break;
        case "10307":
          this.int_1 = 45;
          break;
        case "10308":
          this.int_1 = 50;
          break;
        case "10309":
          this.int_1 = 55;
          break;
        case "10310":
          this.int_1 = 60;
          break;
      }
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseRemoveGuardEnemyEquipEffect) is HorseRemoveGuardEnemyEquipEffect ofType))
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
        living_0.IgnoreGuard = this.int_1;
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
        living_0.Game.CurrentLiving.IgnoreGuard = this.int_1;
    }
  }
}
