// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetAttackedRecoverBloodEquipEffect
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetAttackedRecoverBloodEquipEffect : BasePetEffect
  {
    private int int_0;
    private int ltkDjKxgoj;
    private int int_1;
    private int int_2;
    private int int_3;

    public PetAttackedRecoverBloodEquipEffect(
      int count,
      int probability,
      int type,
      int skillId,
      int delay,
      string elementID)
      : base(ePetEffectType.PetAttackedRecoverBloodEquipEffect, elementID)
    {
      this.ltkDjKxgoj = count;
      this.int_1 = probability == -1 ? 10000 : probability;
      this.int_0 = type;
      this.int_2 = delay;
      this.int_3 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAttackedRecoverBloodEquipEffect) is PetAttackedRecoverBloodEquipEffect ofType))
        return base.Start(living);
      ofType.int_1 = this.int_1 > ofType.int_1 ? this.int_1 : ofType.int_1;
      return true;
    }

    protected override void OnAttachedToPlayer(Player player)
    {
      player.PlayerBuffSkillPet += new PlayerEventHandle(this.method_0);
    }

    protected override void OnRemovedFromPlayer(Player player)
    {
      player.PlayerBuffSkillPet -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0)
    {
      if (this.rand.Next(100) >= this.int_1 || player_0.PetEffects.CurrentUseSkill != this.int_3)
        return;
      foreach (Player allTeamPlayer in player_0.Game.GetAllTeamPlayers((Living) player_0))
      {
        allTeamPlayer.AddPetEffect((AbstractPetEffect) new PetAttackedRecoverBloodEquip(this.ltkDjKxgoj, this.int_3, this.Info.ID.ToString()), 0);
        allTeamPlayer.Game.udqMkhsej5((Living) allTeamPlayer, this.Info, true);
      }
    }
  }
}
