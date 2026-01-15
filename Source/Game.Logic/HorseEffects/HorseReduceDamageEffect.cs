// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseReduceDamageEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseReduceDamageEffect : AbstractHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public HorseReduceDamageEffect(
      int count,
      int plusReduce,
      int damageReduce,
      int skillId,
      string elementID)
      : base(eHorseEffectType.HorseReduceDamageEffect, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
      this.int_2 = plusReduce;
      this.int_3 = damageReduce;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseReduceDamageEffect) is HorseReduceDamageEffect ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
      living.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_1);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
      living.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_1);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
    }

    private void method_1(Living living_0, Living living_1, ref int int_4, ref int int_5)
    {
      int num = int_4 / 100 * this.int_2 + this.int_3;
      if (num < int_4 && num > 0)
        int_4 -= num;
      else
        int_4 = 1;
    }
  }
}
