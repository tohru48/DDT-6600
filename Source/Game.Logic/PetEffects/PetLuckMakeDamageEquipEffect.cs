// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetLuckMakeDamageEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetLuckMakeDamageEquipEffect : BasePetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;

    public PetLuckMakeDamageEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetLuckMakeDamageEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
      switch (skillId)
      {
        case 84:
          this.int_5 = 300;
          break;
        case 85:
        case 170:
          this.int_5 = 500;
          break;
        case 171:
          this.int_5 = 800;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetLuckMakeDamageEquipEffect) is PetLuckMakeDamageEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.AfterKilledByLiving += new KillLivingEventHanlde(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.AfterKilledByLiving -= new KillLivingEventHanlde(this.method_0);
      player.Game.udqMkhsej5((Living) player, this.Info, false);
    }

    private void method_0(Living living_0, Living living_1, int int_6, int int_7)
    {
      if (this.rand.Next(10000) >= this.int_2 || living_1 == living_0)
        return;
      living_1.SyncAtTime = true;
      living_1.AddBlood(-this.int_5, 1);
      living_1.SyncAtTime = false;
      if (living_1.Blood <= 0)
        living_1.Die();
      living_0.Game.udqMkhsej5(living_0, this.Info, true);
    }
  }
}
