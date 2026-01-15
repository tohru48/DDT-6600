// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.ContinueReduceDamageEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class ContinueReduceDamageEffect : AbstractEffect
  {
    private int int_0;

    public ContinueReduceDamageEffect(int count)
      : base(eEffectType.ContinueReduceDamageEffect)
    {
      this.int_0 = count;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.ContinueReduceDamageEffect) is ContinueReduceDamageEffect ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
      if (living is Player)
        (living as Player).BaseDamage = (living as Player).BaseDamage * 5.0 / 100.0;
      living.Game.method_61(living, 4, true);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
      (living as Player).BaseDamage = (living as Player).BaseDamage * 100.0 / 5.0;
      living.Game.method_61(living, 4, false);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
    }
  }
}
