// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetUnlimitAddBloodEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetUnlimitAddBloodEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetUnlimitAddBloodEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetAddBloodEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 31:
          this.int_1 = 500;
          break;
        case 32:
          this.int_1 = 700;
          break;
        case 33:
          this.int_1 = 1000;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetUnlimitAddBloodEquip) is PetUnlimitAddBloodEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living player)
    {
      player.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living player)
    {
      player.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 < 0)
      {
        this.Stop();
        living_0.Game.udqMkhsej5(living_0, this.Info, false);
      }
      else
      {
        living_0.SyncAtTime = true;
        living_0.AddBlood(this.int_1);
        living_0.SyncAtTime = false;
      }
    }
  }
}
