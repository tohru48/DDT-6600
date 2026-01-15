// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddBloodEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddBloodEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetAddBloodEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetAddBloodEquip, elementID)
    {
      this.int_0 = count;
      switch (skillId)
      {
        case 93:
          this.int_1 = 500;
          break;
        case 94:
          this.int_1 = 1000;
          break;
        case 172:
          this.int_1 = 1500;
          break;
        case 173:
          this.int_1 = 2500;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddBloodEquip) is PetAddBloodEquip ofType))
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
      if (living_0.Game.RoomType != eRoomType.Match && living_0.Game.RoomType != eRoomType.Freedom && living_0.Game.RoomType != eRoomType.RingStation)
        return;
      living_0.SyncAtTime = true;
      living_0.AddBlood(this.int_1);
      living_0.SyncAtTime = false;
    }

    private void method_1(Living living_0)
    {
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
    }
  }
}
