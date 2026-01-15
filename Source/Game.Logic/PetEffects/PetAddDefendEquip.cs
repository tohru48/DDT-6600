// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddDefendEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddDefendEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetAddDefendEquip(int count, int skilId, string elementID)
      : base(ePetEffectType.AddDefenceEquip, elementID)
    {
      this.int_0 = count;
      switch (skilId)
      {
        case 34:
        case 89:
          this.int_1 = 100;
          break;
        case 35:
        case 37:
        case 74:
        case 90:
          this.int_1 = 300;
          break;
        case 36:
        case 39:
        case 75:
          this.int_1 = 500;
          break;
        case 38:
          this.int_1 = 400;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.AddDefenceEquip) is PetAddDefendEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.Defence += (double) this.int_1;
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.Defence -= (double) this.int_1;
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      living_0.Game.udqMkhsej5(living_0, this.Info, false);
      this.Stop();
    }
  }
}
