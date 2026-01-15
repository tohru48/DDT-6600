// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddDanderEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddDanderEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public AddDanderEquipEffect(int count, int probability, int type)
      : base(eEffectType.AddDander)
    {
      this.int_1 = count;
      this.int_2 = probability;
      this.int_0 = type;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddDander) is AddDanderEquipEffect ofType))
        return base.Start(living);
      this.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.BeginAttacked += new LivingEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.BeginAttacked -= new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_2 || living_0.DefendActiveGem != this.int_0)
        return;
      this.IsTrigger = true;
      if (living_0 is Player)
        (living_0 as Player).AddDander(this.int_1);
      living_0.EffectTrigger = true;
      living_0.Game.method_58(living_0, LanguageMgr.GetTranslation("DefenceEffect.Success"));
      living_0.Game.AddAction((IAction) new LivingSayAction(living_0, LanguageMgr.GetTranslation("AddDanderEquipEffect.msg"), 9, 0, 1000));
    }
  }
}
