// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddAgilityEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddAgilityEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public AddAgilityEffect(int count, int probability)
      : base(eEffectType.AddAgilityEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddAgilityEffect) is AddAgilityEffect ofType))
        return base.Start(living);
      this.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeginAttacking += new LivingEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeginAttacking -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      living_0.Agility -= (double) this.int_2;
      this.int_2 = 0;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1)
        return;
      living_0.EffectTrigger = true;
      this.IsTrigger = true;
      living_0.Agility += (double) this.int_0;
      this.int_2 = this.int_0;
      living_0.Game.method_58(living_0, LanguageMgr.GetTranslation("AddAgilityEffect.Success", (object) this.int_0));
    }

    private void method_1(Living living_0)
    {
    }
  }
}
