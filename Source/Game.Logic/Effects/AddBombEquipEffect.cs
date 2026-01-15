// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddBombEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddBombEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private bool NtborMqlNg;

    public AddBombEquipEffect(int count, int probability)
      : base(eEffectType.AddBombEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddBombEquipEffect) is AddBombEquipEffect ofType))
        return base.Start(living);
      this.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_0);
      player.BeginAttacking += new LivingEventHandle(this.method_1);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_0);
      player.BeginAttacking -= new LivingEventHandle(this.method_1);
    }

    private void method_0(Player player_0)
    {
      if (!this.IsTrigger || !this.NtborMqlNg)
        return;
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("AddBombEquipEffect.msg"), 9, 0, 1000));
      player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      this.NtborMqlNg = false;
    }

    private void method_1(Living living_0)
    {
      if ((living_0 as Player).CurrentBall.IsSpecial())
        return;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1 || living_0.AttackGemLimit != 0)
        return;
      this.NtborMqlNg = true;
      living_0.AttackGemLimit = 4;
      this.IsTrigger = true;
      (living_0 as Player).ShootCount += this.int_0;
      living_0.EffectTrigger = true;
    }
  }
}
