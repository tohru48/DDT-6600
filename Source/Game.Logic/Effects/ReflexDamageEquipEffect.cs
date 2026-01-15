// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.ReflexDamageEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class ReflexDamageEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public ReflexDamageEquipEffect(int count, int probability)
      : base(eEffectType.ReflexDamageEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.ReflexDamageEquipEffect) is ReflexDamageEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeginAttacked += new LivingEventHandle(this.ChangeProperty);
      player.AfterKilledByLiving += new KillLivingEventHanlde(this.method_0);
    }

    private void method_0(Living living_0, Living living_1, int int_2, int int_3)
    {
      if (!this.IsTrigger)
        return;
      living_1.AddBlood(-this.int_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeginAttacked -= new LivingEventHandle(this.ChangeProperty);
    }

    public void ChangeProperty(Living living)
    {
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1)
        return;
      this.IsTrigger = true;
      living.EffectTrigger = true;
      living.Game.method_58(living, LanguageMgr.GetTranslation("ReflexDamageEquipEffect.Success", (object) this.int_0));
    }
  }
}
