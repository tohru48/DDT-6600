// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.SealEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class SealEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public SealEquipEffect(int count, int probability)
      : base(eEffectType.SealEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.SealEquipEffect) is SealEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_1);
      player.AfterKillingLiving += new KillLivingEventHanlde(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, int int_2, int int_3)
    {
      if (!this.IsTrigger)
        return;
      living_1.AddEffect((AbstractEffect) new SealEffect(2), 0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_1);
      player.AfterKillingLiving -= new KillLivingEventHanlde(this.method_0);
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
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("SealEquipEffect.msg"), 9, 0, 1000));
    }
  }
}
