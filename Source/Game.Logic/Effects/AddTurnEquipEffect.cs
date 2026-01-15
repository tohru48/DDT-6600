// Decompiled with JetBrains decompiler
// Type: Game.Logic.Effects.AddTurnEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Effects
{
  public class AddTurnEquipEffect : BasePlayerEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;

    public AddTurnEquipEffect(int count, int probability, int templateID)
      : base(eEffectType.AddTurnEquipEffect)
    {
      this.int_0 = count;
      this.int_1 = probability;
      this.int_2 = templateID;
    }

    public override bool Start(Living living)
    {
      if (!(living.EffectList.GetOfType(eEffectType.AddTurnEquipEffect) is AddTurnEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerShoot += new PlayerEventHandle(this.method_0);
      player.BeginNextTurn += new LivingEventHandle(this.player_BeginSelfTurn);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerShoot -= new PlayerEventHandle(this.method_0);
      player.BeginNextTurn -= new LivingEventHandle(this.player_BeginSelfTurn);
    }

    public void player_BeginSelfTurn(Living living)
    {
      if (!this.IsTrigger || !(living is Player))
        return;
      int num = 0;
      switch (this.int_2)
      {
        case 311112:
          num = 130;
          break;
        case 311129:
          num = 145;
          break;
        case 311212:
          num = 160;
          break;
        case 311229:
          num = 175;
          break;
        case 311312:
          num = 190;
          break;
        case 311329:
          num = 205;
          break;
        case 311412:
          num = 220;
          break;
        case 311429:
          num = 245;
          break;
        case 311512:
          num = 260;
          break;
        case 311529:
          num = 265;
          break;
      }
      (living as Player).Delay += (living as Player).Delay * this.int_0 / 100;
      (living as Player).Energy = num;
      this.IsTrigger = false;
    }

    private void method_0(Player player_0)
    {
      if (player_0.CurrentBall.IsSpecial() || AbstractEffect.rand.Next(100) >= this.int_1 || player_0.AttackGemLimit != 0)
        return;
      player_0.AttackGemLimit = 4;
      player_0.Delay = player_0.DefaultDelay;
      this.IsTrigger = true;
      player_0.EffectTrigger = true;
      player_0.Game.method_58((Living) player_0, LanguageMgr.GetTranslation("AttackEffect.Success"));
      player_0.Game.AddAction((IAction) new LivingSayAction((Living) player_0, LanguageMgr.GetTranslation("AddTurnEquipEffect.msg"), 9, 0, 1000));
    }
  }
}
