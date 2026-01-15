// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.FatalEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class FatalEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public FatalEffect(int count, int probability)
      : base(eEffectType.FatalEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.FatalEffect) is FatalEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_3);
      player.TakePlayerDamage += new LivingTakedDamageEventHandle(this.method_2);
      player.BeginNextTurn += new LivingEventHandle(this.method_1);
      player.AfterPlayerShooted += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_3);
      player.TakePlayerDamage -= new LivingTakedDamageEventHandle(this.method_2);
      player.BeginNextTurn -= new LivingEventHandle(this.method_1);
      player.AfterPlayerShooted -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0)
    {
      this.IsTrigger = false;
      player_0.ControlBall = false;
      player_0.EffectTrigger = false;
    }

    private void method_1(Living living_0) => this.int_2 = 0;

    private void method_2(Living living_0, Living living_1, ref int int_3, ref int int_4)
    {
      if (!this.IsTrigger || !(living_0 is Player))
        return;
      int_3 = int_3 * (100 - this.int_0) / 100;
    }

    private void method_3(Player player_0)
    {
      if (player_0.CurrentBall.IsSpecial())
        return;
      ++this.int_2;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1 || player_0.AttackGemLimit != 0)
        return;
      player_0.AttackGemLimit = 4;
      player_0.ShootMovieDelay = 50;
      this.IsTrigger = true;
      if (player_0.CurrentBall.ID != 3)
        player_0.ControlBall = true;
      if (this.int_2 == 1)
      {
        player_0.EffectTrigger = true;
        player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
        player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("FatalEffect.msg"), 9, 0, 1000));
      }
    }
  }
}
