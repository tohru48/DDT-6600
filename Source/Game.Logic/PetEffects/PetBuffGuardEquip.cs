// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetBuffGuardEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetBuffGuardEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetBuffGuardEquip(int count, int skilId, string elementID)
      : base(ePetEffectType.PetBuffGuardEquip, elementID)
    {
      this.int_0 = count;
      switch (skilId)
      {
        case (int) sbyte.MaxValue:
          this.int_1 = 100;
          break;
        case 128:
          this.int_1 = 200;
          break;
        case 129:
          this.int_1 = 300;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetBuffGuardEquip) is PetBuffGuardEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BaseGuard += (double) this.int_1;
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.BaseGuard -= (double) this.int_1;
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
