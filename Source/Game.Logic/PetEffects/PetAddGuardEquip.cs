// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddGuardEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddGuardEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetAddGuardEquip(int count, int skilId, string elementID)
      : base(ePetEffectType.PetAddGuardEquip, elementID)
    {
      this.int_0 = count;
      switch (skilId)
      {
        case 181:
          this.int_1 = 100;
          break;
        case 182:
          this.int_1 = 200;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddGuardEquip) is PetAddGuardEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      if (living.Game.RoomType == eRoomType.Match || living.Game.RoomType == eRoomType.Freedom || living.Game.RoomType == eRoomType.RingStation)
        living.BaseGuard += (double) this.int_1;
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      if (living.Game.RoomType == eRoomType.Match || living.Game.RoomType == eRoomType.Freedom || living.Game.RoomType == eRoomType.RingStation)
        living.BaseGuard -= (double) this.int_1;
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
    }
  }
}
