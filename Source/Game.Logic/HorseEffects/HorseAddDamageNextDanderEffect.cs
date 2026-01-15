// Decompiled with JetBrains decompiler
// Type: Game.Logic.HorseEffects.HorseAddDamageNextDanderEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.HorseEffects
{
  public class HorseAddDamageNextDanderEffect : AbstractHorseEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public HorseAddDamageNextDanderEffect(int count, int skillId, string elementID)
      : base(eHorseEffectType.HorseAddDamageNextDanderEffect, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
      this.int_2 = 0;
    }

    public override bool Start(Living living)
    {
      if (!(living.HorseEffectList.GetOfType(eHorseEffectType.HorseAddDamageNextDanderEffect) is HorseAddDamageNextDanderEffect ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      (living as Player).PlayerUseDander += new PlayerEventHandle(this.method_0);
      (living as Player).TakePlayerDamage += new LivingTakedDamageEventHandle(this.method_1);
    }

    public override void OnRemoved(Living living)
    {
      (living as Player).PlayerUseDander -= new PlayerEventHandle(this.method_0);
      (living as Player).TakePlayerDamage -= new LivingTakedDamageEventHandle(this.method_1);
    }

    private void method_0(Player player_0) => ++this.int_2;

    private void method_1(Living living_0, Living living_1, ref int int_3, ref int int_4)
    {
      if (this.int_2 < 2)
        return;
      int num = int_3 / 100 * this.int_0;
      int_3 += num;
      this.Stop();
    }
  }
}
