// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetReduceTakeDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetReduceTakeDamageEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;
    private int vcfiZloBvC;

    public PetReduceTakeDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetReduceTakeDamageEquip, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
      switch (skillId)
      {
        case 50:
        case 51:
        case 52:
        case 163:
          this.vcfiZloBvC = 500;
          break;
        case 164:
          this.vcfiZloBvC = 650;
          break;
        case 165:
          this.vcfiZloBvC = 750;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetReduceTakeDamageEquip) is PetReduceTakeDamageEquip ofType))
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
      int_2 -= this.vcfiZloBvC;
    }

    private void method_1(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      living_0.Game.udqMkhsej5(living_0, this.Info, false);
      this.Stop();
    }
  }
}
