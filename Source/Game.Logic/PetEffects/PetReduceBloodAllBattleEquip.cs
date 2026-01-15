// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetReduceBloodAllBattleEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetReduceBloodAllBattleEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetReduceBloodAllBattleEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetReduceBloodAllBattleEquip, elementID)
    {
      this.int_0 = count;
      if (skillId > 131)
      {
        switch (skillId)
        {
          case 150:
            goto label_9;
          case 151:
          case 190:
            this.int_1 = 1000;
            return;
          case 189:
            break;
          default:
            return;
        }
      }
      else
      {
        switch (skillId)
        {
          case 103:
            this.int_1 = 200;
            return;
          case 104:
            this.int_1 = 300;
            return;
          case 105:
          case 130:
            goto label_9;
          case 131:
            break;
          default:
            return;
        }
      }
      this.int_1 = 800;
      return;
label_9:
      this.int_1 = 500;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetReduceBloodAllBattleEquip) is PetReduceBloodAllBattleEquip ofType))
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
        living_0.Game.udqMkhsej5(living_0, this.Info, false);
        this.Stop();
      }
      else
      {
        living_0.SyncAtTime = true;
        living_0.AddBlood(-this.int_1, 1);
        living_0.SyncAtTime = false;
        if (living_0.Blood > 0)
          return;
        living_0.Die();
      }
    }
  }
}
