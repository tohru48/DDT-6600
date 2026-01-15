// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddBloodEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddBloodEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public AddBloodEffect(int count, int probability)
      : base(eEffectType.AddBloodEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddBloodEffect) is AddBloodEffect ofType))
        return base.Start(living);
      this.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.ChangeProperty);
      player.BeginAttacked += new LivingEventHandle(this.ChangeProperty);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.ChangeProperty);
      player.BeginAttacked -= new LivingEventHandle(this.ChangeProperty);
    }

    public void ChangeProperty(Living living)
    {
      this.IsTrigger = false;
      if (AbstractEffect.rand.Next(100) >= this.int_1)
        return;
      this.IsTrigger = true;
      living.EffectTrigger = true;
      living.Blood += this.int_0;
      living.Game.method_58(living, LanguageMgr.GetTranslation("AddBloodEffect.Success", (object) this.int_0));
    }
  }
}
