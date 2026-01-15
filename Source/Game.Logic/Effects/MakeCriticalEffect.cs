// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.MakeCriticalEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class MakeCriticalEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public MakeCriticalEffect(int count, int probability)
      : base(eEffectType.MakeCriticalEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.MakeCriticalEffect) is MakeCriticalEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.TakePlayerDamage += new LivingTakedDamageEventHandle(this.method_1);
      player.AfterPlayerShooted += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.TakePlayerDamage -= new LivingTakedDamageEventHandle(this.method_1);
      player.AfterPlayerShooted -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0) => player_0.FlyingPartical = 0;

    private void method_1(Living living_0, Living living_1, ref int int_2, ref int int_3)
    {
      if ((living_0 as Player).CurrentBall.IsSpecial())
        return;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1 || living_0.AttackGemLimit != 0)
        return;
      living_0.AttackGemLimit = 4;
      this.IsTrigger = true;
      living_0.EffectTrigger = true;
      int_3 = (int) (0.5 + living_0.Lucky * 0.0005 * (double) int_2);
      living_0.Game.method_58(living_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      living_0.FlyingPartical = 65;
      living_0.Game.AddAction((IAction) new LivingSayAction(living_0, LanguageMgr.GetTranslation("MakeCriticalEffect.msg"), 9, 0, 1000));
    }
  }
}
