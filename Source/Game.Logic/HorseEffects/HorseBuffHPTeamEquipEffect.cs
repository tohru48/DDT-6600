// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseBuffHPTeamEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseBuffHPTeamEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private double double_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public HorseBuffHPTeamEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseBuffHPTeamEquipEffect, elementID)
    {
      switch (elementID)
      {
        case "10201":
          this.double_0 = 1.0;
          this.int_4 = 90;
          break;
        case "10202":
          this.double_0 = 1.5;
          this.int_4 = 125;
          break;
        case "10203":
          this.double_0 = 2.0;
          this.int_4 = 160;
          break;
        case "10204":
          this.double_0 = 2.5;
          this.int_4 = 195;
          break;
        case "10205":
          this.double_0 = 3.0;
          this.int_4 = 230;
          break;
        case "10206":
          this.double_0 = 3.5;
          this.int_4 = 275;
          break;
        case "10207":
          this.double_0 = 4.0;
          this.int_4 = 320;
          break;
        case "10208":
          this.double_0 = 4.5;
          this.int_4 = 370;
          break;
        case "10209":
          this.double_0 = 5.0;
          this.int_4 = 420;
          break;
        case "10210":
          this.double_0 = 5.5;
          this.int_4 = 470;
          break;
      }
      this.int_1 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_2 = delay;
      this.int_3 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseBuffHPTeamEquipEffect) is HorseBuffHPTeamEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
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
      if (this.rand.Next(10000) >= this.int_1 || living_0.PetEffects.CurrentHorseSkill != this.int_3)
        return;
      foreach (Player allTeamPlayer in living_0.Game.GetAllTeamPlayers(living_0))
      {
        if (allTeamPlayer.IsLiving)
        {
          int num = (int) ((double) (allTeamPlayer.Blood / 100) * this.double_0 + (double) this.int_4);
          allTeamPlayer.AddBlood(num);
        }
      }
    }
  }
}
