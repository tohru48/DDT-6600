// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseControlBallEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseControlBallEquipEffect : BaseHorseEffect
  {
    private int int_0;
    private float float_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public HorseControlBallEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(eHorseEffectType.HorseControlBallEquipEffect, elementID)
    {
      switch (elementID)
      {
        case null:
          this.int_1 = probability == -1 ? 10000 : probability;
          this.int_0 = type;
          this.int_2 = delay;
          this.int_3 = skillId;
          break;
        case "10801":
          this.float_0 = 0.5f;
          goto default;
        case "10802":
          this.float_0 = 0.45f;
          goto default;
        case "10803":
          this.float_0 = 0.4f;
          goto default;
        case "10804":
          this.float_0 = 0.35f;
          goto default;
        case "10805":
          this.float_0 = 0.3f;
          goto default;
        default:
          goto case null;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseControlBallEquipEffect) is HorseControlBallEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBuffSkillHorse += new PlayerEventHandle(this.method_1);
      player.PlayerShoot += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBuffSkillHorse -= new PlayerEventHandle(this.method_1);
      player.PlayerShoot -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0)
    {
      if (!player_0.ControlBall || player_0.PetEffects.CurrentHorseSkill != this.int_3)
        return;
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("FatalEffect.msg"), 9, 0, 1000));
    }

    private void method_1(Living living_0)
    {
      if (this.rand.Next(10000) >= this.int_1 || living_0.PetEffects.CurrentHorseSkill != this.int_3)
        return;
      if (living_0.IsLiving)
      {
        living_0.ControlBall = true;
        living_0.CurrentShootMinus *= this.float_0;
      }
      else if (living_0.Game.CurrentLiving != null && living_0.Game.CurrentLiving is Player && living_0.Game.CurrentLiving.Team == living_0.Team)
      {
        living_0.Game.CurrentLiving.ControlBall = true;
        living_0.Game.CurrentLiving.CurrentShootMinus *= this.float_0;
      }
    }
  }
}
