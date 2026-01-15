// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseReviveTeamEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseReviveTeamEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private double double_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public HorseReviveTeamEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseReviveTeamEquipEffect, elementID)
    {
      switch (elementID)
      {
        case null:
          this.int_1 = probability == -1 ? 10000 : probability;
          this.int_0 = type;
          this.int_2 = delay;
          this.int_3 = skillId;
          break;
        case "10501":
          this.double_0 = 20.0;
          goto default;
        case "10502":
          this.double_0 = 26.0;
          goto default;
        case "10503":
          this.double_0 = 32.0;
          goto default;
        case "10504":
          this.double_0 = 38.0;
          goto default;
        case "10505":
          this.double_0 = 44.0;
          goto default;
        default:
          goto case null;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseReviveTeamEquipEffect) is HorseReviveTeamEquipEffect ofType))
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
      if (this.rand.Next(10000) >= this.int_1 || living_0.PetEffects.CurrentHorseSkill != this.int_3 || !living_0.IsLiving)
        return;
      List<Player> allTeamPlayerDies = living_0.Game.GetAllTeamPlayerDies(living_0);
      Player player = (Player) null;
      if (allTeamPlayerDies.Count > 1)
      {
        int index = this.rand.Next(allTeamPlayerDies.Count);
        player = allTeamPlayerDies[index];
      }
      else if (allTeamPlayerDies.Count == 1)
        player = allTeamPlayerDies[0];
      if (player != null)
      {
        int blood = (int) ((double) (player.MaxBlood / 100) * this.double_0);
        player.Revive(blood, living_0.X, living_0.Y);
      }
    }
  }
}
