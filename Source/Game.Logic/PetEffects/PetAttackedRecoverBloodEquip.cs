// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAttackedRecoverBloodEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAttackedRecoverBloodEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public PetAttackedRecoverBloodEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetAttackedRecoverBloodEquip, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
      switch (skillId)
      {
        case 110:
          this.int_2 = 800;
          break;
        case 111:
          this.int_2 = 1000;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAttackedRecoverBloodEquip) is PetAttackedRecoverBloodEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_1);
      living.BeforeTakeDamage += new LivingTakedDamageEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_1);
      living.BeforeTakeDamage -= new LivingTakedDamageEventHandle(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, ref int int_3, ref int int_4)
    {
      if (this.rand.Next(10000) >= 3500)
        return;
      living_0.SyncAtTime = true;
      living_0.AddBlood(this.int_2);
      living_0.SyncAtTime = false;
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
