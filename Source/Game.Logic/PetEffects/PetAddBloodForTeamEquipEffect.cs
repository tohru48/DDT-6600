// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAddBloodForTeamEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAddBloodForTeamEquipEffect : BasePetEffect
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;

    public PetAddBloodForTeamEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetAddBloodForTeamEquipEffect, elementID)
    {
      this.int_1 = count;
      this.int_2 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_3 = delay;
      this.int_4 = skillId;
      switch (skillId)
      {
        case 82:
          this.int_5 = 300;
          break;
        case 83:
          this.int_5 = 600;
          break;
      }
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddBloodForTeamEquipEffect) is PetAddBloodForTeamEquipEffect ofType))
        return base.Start(living);
      ofType.int_2 = this.int_2 > ofType.int_2 ? this.int_2 : ofType.int_2;
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
      if (this.rand.Next(10000) >= this.int_2 || !player_0.IsCure())
        return;
      player_0.PetEffectTrigger = true;
      foreach (Player allTeamPlayer in player_0.Game.GetAllTeamPlayers((Living) player_0))
      {
        if (allTeamPlayer != player_0)
        {
          allTeamPlayer.SyncAtTime = true;
          allTeamPlayer.AddBlood(this.int_5);
          allTeamPlayer.SyncAtTime = false;
        }
      }
    }
  }
}
