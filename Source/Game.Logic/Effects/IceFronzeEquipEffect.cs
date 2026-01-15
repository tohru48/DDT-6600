// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.IceFronzeEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Bussiness.Managers;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;
using Game.Logic.Spells;

#nullable disable
namespace Game.Logic.Effects
{
  public class IceFronzeEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;

    public IceFronzeEquipEffect(int count, int probability)
      : base(eEffectType.IceFronzeEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.IceFronzeEquipEffect) is IceFronzeEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0)
    {
      if (player_0.CurrentBall.IsSpecial() || AbstractEffect.rand.Next(100) >= this.int_1 || player_0.AttackGemLimit != 0)
        return;
      player_0.AttackGemLimit = 4;
      SpellMgr.ExecuteSpell(player_0.Game, player_0, ItemMgr.FindItemTemplate(10015));
      player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("IceFronzeEquipEffect.msg"), 9, 0, 1000));
    }
  }
}
