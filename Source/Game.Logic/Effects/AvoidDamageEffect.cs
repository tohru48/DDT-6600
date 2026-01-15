// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AvoidDamageEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AvoidDamageEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public AvoidDamageEffect(int count, int probability, int type)
      : base(eEffectType.AvoidDamageEffect)
    {
      this.int_1 = count;
      this.int_2 = probability;
      this.int_0 = type;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AvoidDamageEffect) is AvoidDamageEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, ref int int_3, ref int int_4)
    {
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_2 || living_0.DefendActiveGem != this.int_0)
        return;
      this.IsTrigger = true;
      living_0.EffectTrigger = true;
      int_3 = int_3 * (100 - this.int_1) / 100;
      living_0.Game.method_58(living_0, LanguageMgr.GetTranslation("DefenceEffect.Success"));
      living_0.Game.AddAction((IAction) new LivingSayAction(living_0, LanguageMgr.GetTranslation("AvoidDamageEffect.msg"), 9, 0, 1000));
    }
  }
}
