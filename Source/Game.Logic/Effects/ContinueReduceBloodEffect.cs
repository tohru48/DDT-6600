// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.ContinueReduceBloodEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class ContinueReduceBloodEffect : AbstractEffect
  {
    private int int_0;
    private int int_1;
    private Living living_0;

    public ContinueReduceBloodEffect(int count, int blood, Living liv)
      : base(eEffectType.ContinueReduceBloodEffect)
    {
      this.int_0 = count;
      this.int_1 = blood;
      this.living_0 = liv;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.ContinueReduceBloodEffect) is ContinueReduceBloodEffect ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      living.BeginSelfTurn += new LivingEventHandle(this.method_0);
      living.Game.method_61(living, 2, true);
    }

    public override void OnRemoved(Living living)
    {
      living.BeginSelfTurn -= new LivingEventHandle(this.method_0);
      living.Game.method_61(living, 2, false);
    }

    private void method_0(Living living_1)
    {
      --this.int_0;
      if (this.int_0 < 0)
      {
        this.Stop();
      }
      else
      {
        living_1.AddBlood(-this.int_1, 1);
        if (living_1.Blood > 0)
          return;
        living_1.Die();
        if (this.living_0 != null && this.living_0 is Player)
          (this.living_0 as Player).PlayerDetail.OnKillingLiving((AbstractGame) this.living_0.Game, 2, living_1.Id, living_1.IsLiving, this.int_1);
      }
    }
  }
}
