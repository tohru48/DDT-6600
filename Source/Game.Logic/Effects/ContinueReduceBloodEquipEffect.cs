// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.ContinueReduceBloodEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class ContinueReduceBloodEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public ContinueReduceBloodEquipEffect(int blood, int probability)
      : base(eEffectType.ContinueReduceBloodEquipEffect)
    {
      this.int_0 = blood;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.ContinueReduceBloodEquipEffect) is ContinueReduceBloodEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_0);
      player.AfterKillingLiving += new KillLivingEventHanlde(this.player_AfterKillingLiving);
    }

    protected void player_AfterKillingLiving(
      Living living,
      Living target,
      int damageAmount,
      int criticalAmount)
    {
      if (!this.IsTrigger)
        return;
      target.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, this.int_0, living), 0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_0);
      player.AfterKillingLiving -= new KillLivingEventHanlde(this.player_AfterKillingLiving);
    }

    private void method_0(Player player_0)
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
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("ContinueReduceBloodEquipEffect.msg"), 9, 0, 1000));
    }
  }
}
