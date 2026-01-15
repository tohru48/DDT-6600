// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddDefenceEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddDefenceEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;

    public AddDefenceEffect(int count, int probability, int type)
      : base(eEffectType.AddDefenceEffect)
    {
      this.int_1 = count;
      this.int_2 = probability;
      this.int_3 = 0;
      this.int_0 = type;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddDefenceEffect) is AddDefenceEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeginAttacked += new LivingEventHandle(this.ChangeProperty);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeginAttacked -= new LivingEventHandle(this.ChangeProperty);
    }

    public void ChangeProperty(Living living)
    {
      living.Defence -= (double) this.int_3;
      this.int_3 = 0;
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_2 || living.DefendActiveGem != this.int_0)
        return;
      this.IsTrigger = true;
      living.Defence += (double) this.int_1;
      this.int_3 = this.int_1;
      living.EffectTrigger = true;
      living.Game.method_58(living, LanguageMgr.GetTranslation("DefenceEffect.Success"));
      living.Game.AddAction((IAction) new LivingSayAction(living, LanguageMgr.GetTranslation("AddDefenceEffect.msg"), 9, 1000, 1000));
    }
  }
}
