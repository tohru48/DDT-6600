// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddGuardEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddGuardEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public AddGuardEquipEffect(int count, int probability)
      : base(eEffectType.AddGuardEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddGuardEquipEffect) is AddGuardEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.AddArmor = true;
      player.BeginSelfTurn += new LivingEventHandle(this.method_1);
      player.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
      player.Game.method_61((Living) player, 6, true);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.AddArmor = false;
      player.BeginSelfTurn -= new LivingEventHandle(this.method_1);
      player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
      player.Game.method_61((Living) player, 6, false);
    }

    private void method_0(Living living_0, Living living_1, ref int int_2, ref int int_3)
    {
      int_2 -= this.int_0;
      if ((int_2 -= this.int_0) > 0)
        return;
      int_2 = 1;
    }

    private void method_1(Living living_0)
    {
      --this.int_1;
      if (this.int_1 >= 0)
        return;
      this.Stop();
    }
  }
}
