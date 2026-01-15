// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AssimilateBloodEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AssimilateBloodEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public AssimilateBloodEffect(int count, int probability)
      : base(eEffectType.AssimilateBloodEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AssimilateBloodEffect) is AssimilateBloodEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.TakePlayerDamage += new LivingTakedDamageEventHandle(this.method_0);
      player.PlayerShoot += new PlayerEventHandle(this.method_1);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.TakePlayerDamage -= new LivingTakedDamageEventHandle(this.method_0);
      player.PlayerShoot -= new PlayerEventHandle(this.method_1);
    }

    private void method_0(Living living_0, Living living_1, ref int int_2, ref int int_3)
    {
      if (!living_0.IsLiving || !this.IsTrigger)
        return;
      living_0.SyncAtTime = true;
      living_0.AddBlood(int_2 * this.int_0 / 100);
      living_0.SyncAtTime = false;
    }

    private void method_1(Player player_0)
    {
      if (player_0.CurrentBall.IsSpecial())
        return;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1 || player_0.AttackGemLimit != 0)
        return;
      player_0.AttackGemLimit = 4;
      this.IsTrigger = true;
      player_0.EffectTrigger = true;
      player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("AssimilateBloodEffect.msg"), 9, 0, 1000));
    }
  }
}
