// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetEffects.PetShootedAddDamageForTeamEquip
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
  public class PetShootedAddDamageForTeamEquip : AbstractPetEffect
  {
    private int int_0;
    private int int_1;

    public PetShootedAddDamageForTeamEquip(int count, int skillId, string elementID)
      : base(ePetEffectType.PetShootedAddDamageForTeamEquip, elementID)
    {
      this.int_0 = count;
      this.int_1 = skillId;
    }

    public override bool Start(Living living)
    {
      if (!(living.PetEffectList.GetOfType(ePetEffectType.PetShootedAddDamageForTeamEquip) is PetShootedAddDamageForTeamEquip ofType))
        return base.Start(living);
      ofType.int_0 = this.int_0;
      return true;
    }

    public override void OnAttached(Living living)
    {
      (living as Player).PlayerShoot += new PlayerEventHandle(this.method_0);
    }

    public override void OnRemoved(Living living)
    {
      (living as Player).PlayerShoot -= new PlayerEventHandle(this.method_0);
    }

    private void method_0(Player player_0)
    {
      foreach (Player allTeamPlayer in player_0.Game.GetAllTeamPlayers((Living) player_0))
      {
        if (allTeamPlayer != player_0)
          allTeamPlayer.AddPetEffect((AbstractPetEffect) new PetActiveDamageEquip(2, this.int_1, this.Info.ID.ToString()), 0);
      }
      --this.int_0;
      if (this.int_0 >= 0)
        return;
      this.Stop();
    }
  }
}
