// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.FightingSpell.PowerNextTurnTeamSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.Spells.FightingSpell
{
  [SpellAttibute(86)]
  public class PowerNextTurnTeamSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      foreach (Living allTeamPlayer in player.Game.GetAllTeamPlayers((Living) player))
        new PowerNextTurn(1, 100).Start(allTeamPlayer);
    }
  }
}
