// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddAttackEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddAttackEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public AddAttackEffect(int count, int probability)
      : base(eEffectType.AddAttackEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddAttackEffect) is AddAttackEffect ofType))
        return base.Start(living);
      this.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeforePlayerShoot += new PlayerEventHandle(this.method_1);
      player.AfterPlayerShooted += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeforePlayerShoot -= new PlayerEventHandle(this.method_1);
      player.AfterPlayerShooted -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0) => player_0.FlyingPartical = 0;

    private void method_1(Player player_0)
    {
      if (player_0.CurrentBall.IsSpecial())
        return;
      player_0.Attack -= (double) this.int_2;
      this.int_2 = 0;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1 || player_0.AttackGemLimit != 0)
        return;
      player_0.AttackGemLimit = 4;
      player_0.FlyingPartical = 65;
      this.IsTrigger = true;
      player_0.EffectTrigger = true;
      player_0.Attack += (double) this.int_0;
      this.int_2 = this.int_0;
      player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("AddAttackEffect.msg"), 9, 0, 1000));
    }
  }
}
