// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetReduceBloodEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetReduceBloodEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetReduceBloodEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetReduceBloodEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 189:
          this.int_1 = 800;
          break;
        case 190:
          this.int_1 = 1000;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetReduceBloodEquip) is PetReduceBloodEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 < 0)
      {
        this.Stop();
      }
      else
      {
        if (living_0.Game.RoomType != eRoomType.Match && living_0.Game.RoomType != eRoomType.Freedom && living_0.Game.RoomType != eRoomType.RingStation)
          return;
        living_0.SyncAtTime = true;
        living_0.AddBlood(-this.int_1, 1);
        living_0.SyncAtTime = false;
        if (living_0.Blood <= 0)
          living_0.Die();
      }
    }
  }
}
