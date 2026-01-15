// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.FightingSpell.AddWoudSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.Spells.FightingSpell
{
  [SpellAttibute(13)]
  public class AddWoudSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      if (player.IsLiving)
      {
        player.CurrentDamagePlus += (float) item.Property2 / 100f;
      }
      else
      {
        if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
          return;
        game.CurrentLiving.CurrentDamagePlus += (float) item.Property2 / 100f;
      }
    }
  }
}
