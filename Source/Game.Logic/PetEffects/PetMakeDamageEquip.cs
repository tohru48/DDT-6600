// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetMakeDamageEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetMakeDamageEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetMakeDamageEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetMakeDamageEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 65:
          this.int_1 = 400;
          break;
        case 66:
          this.int_1 = 800;
          break;
        case 166:
          this.int_1 = 600;
          break;
        case 167:
          this.int_1 = 1200;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetMakeDamageEquip) is PetMakeDamageEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living player)
    {
      player.AfterKilledByLiving += new KillLivingEventHanlde(this.method_0);
      player.BeginSelfTurn += new LivingEventHandle(this.method_1);
    }

    public override void OnRemoved(Living player)
    {
      player.AfterKilledByLiving -= new KillLivingEventHanlde(this.method_0);
      player.BeginSelfTurn += new LivingEventHandle(this.method_1);
    }

    private void method_0(Living living_0, Living living_1, int int_2, int int_3)
    {
      if (living_1 == living_0)
        return;
      living_1.SyncAtTime = true;
      living_1.AddBlood(-this.int_1, 1);
      living_1.SyncAtTime = false;
      if (living_1.Blood <= 0)
        living_1.Die();
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
