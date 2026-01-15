// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.PowerNextTurn
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class PowerNextTurn : AbstractEffect
  {
    private int int_0;
    private int int_1;

    public PowerNextTurn(int count, int damage)
      : base(eEffectType.PowerNextTurn)
    {
      this.int_0 = count;
      this.int_1 = damage;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.PowerNextTurn) is PowerNextTurn ofType))
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
      living.SetNiutou(false);
    }

    private void method_0(Living living_0)
    {
      --this.int_0;
      if (this.int_0 == 0)
      {
        living_0.CurrentDamagePlus += (float) (this.int_1 / 100);
        living_0.SetNiutou(true);
      }
      else
      {
        if (this.int_0 >= 0)
          return;
        this.Stop();
      }
    }
  }
}
