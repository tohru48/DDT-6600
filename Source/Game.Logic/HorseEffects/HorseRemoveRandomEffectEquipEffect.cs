// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseRemoveRandomEffectEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseRemoveRandomEffectEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;

    public HorseRemoveRandomEffectEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseRemoveRandomEffectEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseRemoveRandomEffectEquipEffect) is HorseRemoveRandomEffectEquipEffect ofType))
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
      int[] array = new int[5]{ 0, 1, 2, 3, 4 };
      this.rand.Shuffer<int>(array);
      List<Player> allPlayersSameTeam = living_0.Game.GetAllPlayersSameTeam(living_0);
      Player player = (Player) null;
      if (allPlayersSameTeam.Count > 1)
      {
        int index = this.rand.Next(allPlayersSameTeam.Count);
        player = allPlayersSameTeam[index];
      }
      else if (allPlayersSameTeam.Count == 1)
        player = allPlayersSameTeam[0];
      if (player != null)
      {
        switch (array[0])
        {
          case 0:
            player.EffectList.StopEffect(typeof (IceFronzeEffect));
            break;
          case 1:
            player.EffectList.StopEffect(typeof (HideEffect));
            break;
          case 2:
            player.EffectList.StopEffect(typeof (NoHoleEffect));
            break;
          case 3:
            player.EffectList.StopEffect(typeof (SealEffect));
            break;
          case 4:
            player.EffectList.StopEffect(typeof (ContinueReduceBloodEffect));
            break;
        }
      }
    }
  }
}
