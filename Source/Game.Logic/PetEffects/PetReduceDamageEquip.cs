// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetReduceDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetReduceDamageEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetReduceDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetReduceDamageEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 50:
        case 53:
          this.int_1 = 100;
          break;
        case 51:
        case 54:
        case 163:
          this.int_1 = 200;
          break;
        case 52:
        case 55:
          this.int_1 = 300;
          break;
        case 164:
          this.int_1 = 250;
          break;
        case 165:
          this.int_1 = 350;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetReduceDamageEquip) is PetReduceDamageEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living player)
    {
      player.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
      player.BeginSelfTurn += new LivingEventHandle(this.method_1);
    }

    public override void OnRemoved(Living player)
    {
      player.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
      player.BeginSelfTurn += new LivingEventHandle(this.method_1);
    }

    private void method_0(Living living_0, Living living_1, ref int int_2, ref int int_3)
    {
      int_2 -= this.int_1;
    }

    private void method_1(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
      living_0.Game.udqMkhsej5(living_0, this.Info, false);
    }
  }
}
