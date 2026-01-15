// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.RecoverBloodEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class RecoverBloodEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public RecoverBloodEffect(int count, int probability, int type)
      : base(eEffectType.RecoverBloodEffect)
    {
      this.int_1 = count;
      this.int_2 = probability;
      this.int_0 = type;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.RecoverBloodEffect) is RecoverBloodEffect ofType))
        return base.Start(living);
      this.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.AfterKilledByLiving += new KillLivingEventHanlde(this.ChangeProperty);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.AfterKilledByLiving -= new KillLivingEventHanlde(this.ChangeProperty);
    }

    public void ChangeProperty(Living living, Living target, int damageAmount, int criticalAmount)
    {
      if (!living.IsLiving)
        return;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_2 || living.DefendActiveGem != this.int_0)
        return;
      this.IsTrigger = true;
      living.EffectTrigger = true;
      living.SyncAtTime = true;
      living.AddBlood(this.int_1);
      living.SyncAtTime = false;
      living.Game.method_58(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
      living.Game.AddAction((IAction) new LivingSayAction(living, LanguageMgr.GetTranslation("RecoverBloodEffect.msg"), 9, 0, 1000));
    }
  }
}
